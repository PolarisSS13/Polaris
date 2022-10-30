SUBSYSTEM_DEF(atoms)
	name = "Atoms"
	init_order = INIT_ORDER_ATOMS
	flags = SS_NO_FIRE

	// Bad initialization types.
	var/const/QDEL_BEFORE_INITIALIZE = 0x1
	var/const/DID_NOT_SET_INITIALIZED = 0x2
	var/const/SLEPT_IN_INITIALIZE = 0x4
	var/const/DID_NOT_RETURN_HINT = 0x8
	var/const/INIT_STAGE_IS_INVALID = 0x10

	/// A map of (path = bitfield) from the above flags, if any.
	var/static/list/bad_init_calls = list()

	// Initialization stages.
	var/const/MANUAL = -1 // Something inadvisable is happening. Atoms will mark themselves as initialized without doing it. Dragons.
	var/const/WORLD_START = 0 // The world is newly started. New will add atoms to initialize_queue or early_initialize_queue.
	var/const/MAP_START = 1 // The runtime map loader is in use. Atoms will be added to a remote queue to pass to InitializeAtoms.
	var/const/LOADING_MAP = 2 // A map is being loaded from WORLD_START or MAP_START. New will call Initialize(TRUE, ...).
	var/const/AT_RUNTIME = 3 // The game is running normally. New will call Initialize(FALSE, ...).

	/// The current atom initialization stage from the above levels.
	var/static/init_stage = WORLD_START

	/// When using the map loader, the value of init_stage to return to afterward.
	var/static/mapload_old_init_stage

	/// When using manual mode, the value of init_stage to return to afterward.
	var/static/manual_old_init_stage

	/// A map of (ref => falsy|list). Refs are atoms awaiting initialization. Value is an optional argument list to Initialize with.
	var/static/list/initialize_queue = list()

		/// A list of (ref). Refs are atoms that have returned INITIALIZE_HINT_LATELOAD from Initialize.
	var/static/list/lateload_queue = list()

	/// Debug number. Holds the length of global.early_initialize_queue at Initialize time.
	var/static/early_initialize_queue_size = 0


/// Holds identical list matter initialize_queue for atoms New'd before SSatoms exists.
var/global/list/early_initialize_queue


/datum/controller/subsystem/atoms/Initialize(start_uptime)
	init_stage = LOADING_MAP
	early_initialize_queue_size = length(global.early_initialize_queue)
	for (var/ref in global.early_initialize_queue)
		initialize_queue[ref] = global.early_initialize_queue[ref]
	LAZYCLEARLIST(global.early_initialize_queue)
	InitializeAtoms()


/datum/controller/subsystem/atoms/Recover()
	for (var/atom/atom as anything in initialize_queue)
		if (QDELETED(atom))
			initialize_queue -= atom
	for (var/atom/atom as anything in lateload_queue)
		if (QDELETED(atom))
			lateload_queue -= atom
	if (init_stage == LOADING_MAP)
		InitializeAtoms()


/datum/controller/subsystem/atoms/Shutdown()
	var/bad_init_log = GenerateBadInitLog()
	if (!bad_init_log)
		return
	text2file(bad_init_log, "[log_path]/initialize.log")


/datum/controller/subsystem/atoms/proc/InitializeAtoms()
	set background = TRUE
	if (init_stage <= MAP_START)
		return
	init_stage = LOADING_MAP
	var/list/mapload_arg = list(TRUE)
	var/count = 0
	var/list/arguments
	var/queue_size = length(initialize_queue)
	var/start_time = world.timeofday
	var/start_chunk = start_time
	var/next_progress = start_time + 5 SECONDS
	report_progress("Starting queue initialize.")
	for (var/atom/atom as anything in initialize_queue)
		if (!isloc(atom))
			log_debug({"Non-atom entry "[atom || "falsy"]" skipped in initialize queue."})
			continue
		if (atom.atom_flags & ATOM_INITIALIZED)
			continue
		arguments = initialize_queue[atom]
		if (arguments)
			InitAtom(atom, mapload_arg + arguments)
		else
			InitAtom(atom, mapload_arg)
		if (++count & 0x4000)
			var/time = world.timeofday
			if (time > next_progress)
				next_progress = time + 5 SECONDS
				report_progress("Initializing atoms. [queue_size - count] remaining.")
			sleep(-1)
	report_progress("Initialized [count] queue atom\s in [round((world.timeofday - start_chunk) * 0.1, 0.1)] seconds.")
	sleep(-1)
	initialize_queue.Cut()
	if (!subsystem_initialized)
		report_progress("Starting world scan initialize.")
		count = 0
		start_chunk = world.timeofday
		var/world_count = 0
		for (var/atom/atom in world)
			if (++world_count & 0x4000)
				var/time = world.timeofday
				if (time > next_progress)
					next_progress = time + 5 SECONDS
					report_progress("Still initializing world scan atoms...")
				sleep(-1)
			if (atom.atom_flags & ATOM_INITIALIZED)
				continue
			InitAtom(atom, mapload_arg)
			++count
		report_progress("Initialized [count] world scan atom\s in [round((world.timeofday - start_chunk) * 0.1, 0.1)] seconds.")
		sleep(-1)
	init_stage = AT_RUNTIME
	queue_size = length(lateload_queue)
	if (queue_size)
		report_progress("Starting lateload.")
		count = 0
		start_chunk = world.timeofday
		for (var/atom/atom as anything in lateload_queue)
			atom.LateInitialize()
			if (++count & 0x4000)
				var/time = world.timeofday
				if (time > next_progress)
					next_progress = time + 5 SECONDS
					report_progress("LateLoading atoms- [queue_size - count] remaining.")
				sleep(-1)
		report_progress("LateLoaded [count] atom\s in [round((world.timeofday - start_chunk) * 0.1, 0.1)] seconds.")
		lateload_queue.Cut()
	report_progress("Finished [mapload_old_init_stage ? "map" : "world"] initialization in [round((world.timeofday - start_time) * 0.1, 0.1)] seconds.")


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
					lateload_queue[atom] = FALSE
				else
					atom.LateInitialize()
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


/datum/controller/subsystem/atoms/proc/HandleNewAtom(atom/atom, list/atom_args)
	switch (init_stage)
		if (LOADING_MAP, AT_RUNTIME)
			atom_args[1] = init_stage == SSatoms.LOADING_MAP
			InitAtom(atom, atom_args)
		if (WORLD_START, MAP_START)
			var/list/init_args = FALSE
			if (length(atom_args) > 1)
				init_args = atom_args.Copy(2)
			initialize_queue[atom] = init_args
		if (MANUAL)
			atom.atom_flags |= ATOM_INITIALIZED
		else
			bad_init_calls[atom.type] |= INIT_STAGE_IS_INVALID
			crash_with({"Panic!! Invalid SSatoms.init_stage "[init_stage]""})


/// Enter map load mode. Atoms will be queued and then processed as a batch, the same as on startup.
/datum/controller/subsystem/atoms/proc/BeginMapLoad()
	if (!isnull(mapload_old_init_stage))
		log_error("SSatoms.BeginMapLoad called while already in mapload mode!")
	mapload_old_init_stage = init_stage
	init_stage = MAP_START


/// Exit map load mode and return to normal runtime initialization.
/datum/controller/subsystem/atoms/proc/FinishMapLoad()
	init_stage = mapload_old_init_stage
	mapload_old_init_stage = null


/// Enter manual mode. Atoms will mark themselves initialized without initializing. Only villains do this.
/datum/controller/subsystem/atoms/proc/BeginManual()
	if (!isnull(mapload_old_init_stage))
		log_error("SSatoms.BeginManual called while already in manual mode!")
	manual_old_init_stage = init_stage
	init_stage = MANUAL


/// Exit manual mode. It's for the best.
/datum/controller/subsystem/atoms/proc/FinishManual()
	init_stage = manual_old_init_stage
	manual_old_init_stage = null


/datum/controller/subsystem/atoms/proc/GenerateBadInitLog()
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
		if (fails & INIT_STAGE_IS_INVALID)
			. += "- Created during invalid init_stage\n"
