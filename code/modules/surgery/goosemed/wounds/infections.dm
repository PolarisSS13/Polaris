// Infection -- Ticks up toxloss over time
// Treatable by surgical excision (quick), or by chems
/datum/wound/infection
	name = "infection"
	autohealing = FALSE
	var/tox_damage_increment = 0.05 // 1.5 TOX / minute
	surgery_steps = list(/* Excise */)

/datum/wound/infection/New(var/obj/item/organ/affecting = null, var/tox_dam)
	..(affecting, list(TOX = tox_dam))

/datum/wound/infection/get_examine_tag()
	return "swollen spot"

/datum/wound/infection/process()
	// It gets worse over time until treated
	damage[TOX] += tox_damage_increment

/datum/wound/infection/get_surgery_steps()
	// If there's a surgical opening to access the infected tissue,
	if(FALSE)
		return surgery_steps
	return list()

// Gangrene (Rot)
