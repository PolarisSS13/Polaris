/datum/hierarchy
	var/name = "Hierarchy"
	var/hierarchy_type
	var/datum/hierarchy/parent
	var/list/datum/hierarchy/children

/datum/hierarchy/New(var/full_init = TRUE)
	children = list()
	if(!full_init)
		return

	var/list/all_subtypes = list()
	all_subtypes[type] = src
	for(var/subtype in subtypesof(type))
		all_subtypes[subtype] = new subtype(FALSE)

	for(var/subtype in (all_subtypes - type))
		var/datum/hierarchy/subtype_instance = all_subtypes[subtype]
		var/datum/hierarchy/subtype_parent = all_subtypes[subtype_instance.parent_type]
		subtype_instance.parent = subtype_parent
		dd_insertObjectList(subtype_parent.children, subtype_instance)

/datum/hierarchy/proc/is_category()
	return hierarchy_type == type || children.len

/datum/hierarchy/proc/is_hidden_category()
	return hierarchy_type == type

/datum/hierarchy/dd_SortValue()
	return name