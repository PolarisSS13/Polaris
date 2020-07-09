
/obj/item/mecha_parts/component
	name = "mecha component"
	icon = 'icons/mecha/mech_component.dmi'
	icon_state = "component"
	w_class = ITEMSIZE_HUGE
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)

	var/obj/mecha/chassis = null
	var/start_damaged = FALSE

	var/emp_resistance = 0	// Amount of emp 'levels' removed.

	var/required_type = null

	var/integrity
	var/integrity_danger_mod = 0.5	// Multiplier for comparison to max_integrity before problems start.
	var/max_integrity = 100

/obj/item/mecha_parts/component/Initialize()
	..()
	integrity = max_integrity

	if(start_damaged)
		integrity = round(integrity * integrity_danger_mod)

/obj/item/mecha_parts/component/emp_act(var/severity = 4)
	if(severity + emp_resistance > 4)
		return

	severity += emp_resistance

	take_damage((4 - severity) * round(integrity * 0.1, 0.1))

/obj/item/mecha_parts/component/proc/adjust_integrity(var/amt = 0)
	integrity = clamp(integrity + amt, 0, max_integrity)
	return

/obj/item/mecha_parts/component/proc/take_damage(var/dam_amt = 0)
	if(dam_amt <= 0)
		return FALSE

	adjust_integrity(dam_amt)

	return TRUE

/obj/item/mecha_parts/component/proc/get_efficiency()
	var/integ_limit = round(max_integrity * integrity_danger_mod)

	if(integrity < integ_limit)
		var/int_percent = round(integrity / integ_limit, 0.1)

		return int_percent

	return 1
