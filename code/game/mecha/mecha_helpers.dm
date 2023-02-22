/*
 * Helper file for Exosuit / Mecha code.
 */

// Returns, at least, a usable target body position, for things like guns.

/obj/mecha/proc/get_pilot_zone_sel()
	if(!occupant || !occupant.zone_sel || occupant.stat)
		return BP_TORSO

	return occupant.zone_sel.selecting

/obj/mecha/proc/in_flight()
	var/safe = FALSE
	if(M.flying)
		safe = TRUE
	for(var/obj/item/mecha_parts/mecha_equipment/Mequip in M.equipment)
		if(safe)
			break
		safe = Mequip.check_hover()
	return safe
