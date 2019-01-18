/datum/supply_item
	var/name = "Generic Item"
	var/abstract_type = /datum/supply_item
	var/path = /obj/item/bikehorn
	var/cost = 1337								//Cost in whatever GALACTIC_CURRENCY is
	var/default_organization = TRUE				//Setting this to TRUE makes whichever the default organization (usually Nanotrasen) include it in their supplies.

//Can be expanded on later
/datum/supply_item/proc/spawn_item(atom/location)
	return new path(location)

//Can be expanded on later
/datum/supply_item/proc/return_cost()
	return cost

//Can be expanded on later
/datum/supply_item/proc/return_cost_string()
	return "[cost] [GALACTIC_CURRENCY]"
