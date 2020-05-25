// A really dumb datum that only exists to hold information about summon options.
// It's a datum because its the best way to hold more than two pieces of information without doing weird nested list stuff that's hard to read.

/datum/technomancer_summon_choice
	var/name = null
	var/slot_cost = 1
	var/summon_typepath = null

/datum/technomancer_summon_choice/New(new_name, new_typepath, new_slot_cost)
	name = new_name
	summon_typepath = new_typepath
	slot_cost = new_slot_cost