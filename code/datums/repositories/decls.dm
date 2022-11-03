// /decl is a subtype used for singletons that should never have more than one instance
// in existence at a time. If you want to use a /decl you should use a pattern like:
//     var/decl/somedecl/mydecl = GET_DECL(/decl/somedecl)

// /decls are created the first time they are fetched from decls_repository and will
// automatically call Initialize() and such when created in this way.

// decls_repository.get_decls_of_type() and decls_repository.get_decls_of_subtype()
// can be used similarly to typesof() and subtypesof(), returning assoc instance lists.

// The /decl commandments:
//     I.   Thou shalt not create a /decl with new().
//     II.  Thou shalt not del() or qdel() a /decl.
//     III. Thou shalt not write a decl that relies on arguments supplied to New().
//     IV.  Thou shalt not call Initialize() on a /decl.

var/global/repository/decls/decls_repository = new()
/repository/decls
	var/list/fetched_decls         = list()
	var/list/fetched_decl_ids      = list()
	var/list/fetched_decl_types    = list()
	var/list/fetched_decl_subtypes = list()

/repository/decls/New()
	..()
	for(var/decl_type in typesof(/decl))
		var/decl/decl = decl_type
		var/decl_uid = initial(decl.uid)
		if(decl_uid && (!DECL_TYPE_IS_ABSTRACT(decl) || initial(decl.allow_abstract_init)))
			fetched_decl_ids[decl_uid] = decl

/repository/decls/proc/get_decl_by_id(var/decl_id)
	. = get_decl(fetched_decl_ids[decl_id])

/repository/decls/proc/get_decl(var/decl/decl_type)
	ASSERT(ispath(decl_type, /decl))
	. = fetched_decls[decl_type]
	if(DECL_TYPE_IS_ABSTRACT(decl_type) && !initial(decl_type.allow_abstract_init))
		return // We do not instantiate abstract decls.
	if(!.)
		var/decl/decl = new decl_type()
		fetched_decls[decl_type] = decl
		var/init_result = decl.Initialize()
		switch(init_result)
			if(INITIALIZE_HINT_NORMAL)
				. = decl
			else
				if(fetched_decls[decl_type] == decl)
					fetched_decls -= decl_type
				PRINT_STACK_TRACE("Invalid return hint to [decl_type]/Initialize(): [init_result || "NULL"]")


/repository/decls/proc/get_decls(var/list/decl_types)
	. = list()
	for(var/decl_type in decl_types)
		.[decl_type] = get_decl(decl_type)

/repository/decls/proc/get_decls_unassociated(var/list/decl_types)
	. = list()
	for(var/decl_type in decl_types)
		. += get_decl(decl_type)

/repository/decls/proc/get_decls_of_type(var/decl_prototype)
	. = fetched_decl_types[decl_prototype]
	if(!.)
		. = get_decls(typesof(decl_prototype))
		fetched_decl_types[decl_prototype] = .

/repository/decls/proc/get_decls_of_subtype(var/decl_prototype)
	. = fetched_decl_subtypes[decl_prototype]
	if(!.)
		. = get_decls(subtypesof(decl_prototype))
		fetched_decl_subtypes[decl_prototype] = .

/decl
	var/uid
	abstract_type = /decl
	var/initialized = FALSE
	var/allow_abstract_init = FALSE

/decl/proc/Initialize()
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(initialized)
		CRASH("[type] initialized more than once!")
	initialized = TRUE
	return INITIALIZE_HINT_NORMAL

/decl/Destroy()
	SHOULD_CALL_PARENT(FALSE)
	crash_with("Prevented attempt to delete a decl instance: [log_info_line(src)]")
	return QDEL_HINT_LETMELIVE // Prevents decl destruction
