SUBSYSTEM_DEF(organizations)
	name = "Organizations"
	var/list/datum/organization/organizations

/datum/controller/subsystem/organizations/Initialize()
	init_organizations()

/datum/controller/subsystem/organizations/proc/init_organizations()
	for(var/i in subtypesof(/datum/organization))
		var/datum/organization/O = i
		if(initial(O.abstract_type) == i)
			continue
		O = new
		organizations += O
	for(var/i in organizations)
		var/datum/organization/O = i
		O.Initialize()
