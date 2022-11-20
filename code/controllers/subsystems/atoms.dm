SUBSYSTEM_DEF(atoms)
	name = "Atoms"
	init_order = INIT_ORDER_ATOMS
	flags = SS_NO_FIRE

	// Bad initialization types.
	var/const/QDEL_BEFORE_INITIALIZE = 1
	var/const/DID_NOT_SET_INITIALIZED = 2
	var/const/SLEPT_IN_INITIALIZE = 4
	var/const/DID_NOT_RETURN_HINT = 8

	var/static/atom_init_stage = INITIALIZATION_INSSATOMS
	var/static/old_init_stage
	var/static/list/late_loaders = list()
	var/static/list/created_atoms = list()
	var/static/list/bad_init_calls = list()


/datum/controller/subsystem/atoms/Initialize(start_uptime)
	atom_init_stage = INITIALIZATION_INNEW_MAPLOAD
	InitializeAtoms()


/datum/controller/subsystem/atoms/Recover()
	created_atoms.Cut()
	late_loaders.Cut()
	if (atom_init_stage == INITIALIZATION_INNEW_MAPLOAD)
		InitializeAtoms()


/datum/controller/subsystem/atoms/Shutdown()
	var/initlog = InitLog()
	if (!initlog)
		return
	text2file(initlog, "[log_path]/initialize.log")


/datum/controller/subsystem/atoms/proc/InitializeAtoms(list/atom/submap_atoms)
	if (atom_init_stage <= INITIALIZATION_INSSATOMS_LATE)
		return
	atom_init_stage = INITIALIZATION_INNEW_MAPLOAD
	var/list/mapload_arg = list(TRUE)
	var/count = 0
	var/atom/created
	var/list/arguments
	var/list/atom/initialize_queue = submap_atoms || created_atoms
	for (var/i = 1 to length(initialize_queue))
		created = initialize_queue[i]
		if (!(created.atom_flags & ATOM_INITIALIZED))
			arguments = initialize_queue[created] ? mapload_arg + initialize_queue[created] : mapload_arg
			InitAtom(created, arguments)
			CHECK_TICK
	initialize_queue.Cut()
	if (!subsystem_initialized)
		for (var/atom/atom in world)
			if (!(atom.atom_flags & ATOM_INITIALIZED))
				InitAtom(atom, mapload_arg)
				++count
				CHECK_TICK
	report_progress("Initialized [count] atom\s")
	atom_init_stage = INITIALIZATION_INNEW_REGULAR
	if (!length(late_loaders))
		return
	for (var/atom/atom as anything in late_loaders)
		atom.LateInitialize(arglist(late_loaders[atom]))
	report_progress("Late initialized [length(late_loaders)] atom\s")
	late_loaders.Cut()


/datum/controller/subsystem/atoms/proc/InitAtom(atom/atom, list/arguments)
	var/atom_type = atom?.type
	if (QDELING(atom))
		bad_init_calls[atom_type] |= QDEL_BEFORE_INITIALIZE
		return TRUE
	var/start_tick = world.time
	var/result = atom.Initialize(arglist(arguments))
	if (start_tick != world.time)
		bad_init_calls[atom_type] |= SLEPT_IN_INITIALIZE
	var/qdeleted = FALSE
	if (result != INITIALIZE_HINT_NORMAL)
		switch (result)
			if (INITIALIZE_HINT_LATELOAD)
				if (arguments[1])	//mapload
					late_loaders[atom] = arguments
				else
					atom.LateInitialize(arglist(arguments))
			if (INITIALIZE_HINT_QDEL)
				qdel(atom)
				qdeleted = TRUE
			else
				bad_init_calls[atom_type] |= DID_NOT_RETURN_HINT
	if (!atom)
		qdeleted = TRUE
	else if (!(atom.atom_flags & ATOM_INITIALIZED))
		bad_init_calls[atom_type] |= DID_NOT_SET_INITIALIZED
	return qdeleted || QDELING(atom)


/datum/controller/subsystem/atoms/proc/BeginMapLoad()
	old_init_stage = atom_init_stage
	atom_init_stage = INITIALIZATION_INSSATOMS_LATE


/datum/controller/subsystem/atoms/proc/FinishMapLoad()
	atom_init_stage = old_init_stage


/datum/controller/subsystem/atoms/proc/InitLog()
	. = ""
	for (var/path in bad_init_calls)
		. += "Path : [path] \n"
		var/fails = bad_init_calls[path]
		if (fails & DID_NOT_SET_INITIALIZED)
			. += "- Didn't call atom/Initialize()\n"
		if (fails & DID_NOT_RETURN_HINT)
			. += "- Didn't return an Initialize hint\n"
		if (fails & QDEL_BEFORE_INITIALIZE)
			. += "- Qdel'd in New()\n"
		if (fails & SLEPT_IN_INITIALIZE)
			. += "- Slept during Initialize()\n"
