/obj/item/mech_component
	icon = 'icons/mob/mecha/mech_parts_held.dmi'
	w_class = ITEMSIZE_HUGE
	gender = PLURAL
	color = COLOR_GUNMETAL

	var/on_mech_icon = 'icons/mob/mecha/mech_parts.dmi'
	var/exosuit_desc_string
	var/total_damage = 0
	var/brute_damage = 0
	var/burn_damage = 0
	var/max_damage = 60
	var/damage_state = 1
	var/list/has_hardpoints = list()
	var/decal
	var/power_use = 0
	matter = list(MATERIAL_STEEL = 15000, MATERIAL_PLASTIC = 1000, MATERIAL_OSMIUM = 500)
	dir = SOUTH

/obj/item/mech_component/proc/query_color(var/mob/living/user)
	if(user)
		var/input = input("Modify part color:", "Color", color) as color|null
		if(input)
			return set_colour(input)

/obj/item/mech_component/proc/set_colour(new_colour)
	var/last_colour = color
	color = new_colour
	return color != last_colour

/obj/item/mech_component/emp_act(var/severity)
	take_burn_damage(rand((10 - (severity*3)),15-(severity*4)))
	for(var/obj/item/thing in contents)
		thing.emp_act(severity)

/obj/item/mech_component/examine(mob/user)
	. = ..()
	if(ready_to_install())
		. += SPAN_NOTICE("It is ready for installation.")
	else
		. += show_missing_parts(user)

//These icons have multiple directions but before they're attached we only want south.
/obj/item/mech_component/set_dir()
	..(SOUTH)

/obj/item/mech_component/proc/show_missing_parts(var/mob/user)
	return

/obj/item/mech_component/proc/prebuild()
	return

/obj/item/mech_component/proc/install_component(var/obj/item/thing, var/mob/user)
	if(!user.unEquip(thing, src))
		return FALSE
	user.visible_message(SPAN_NOTICE("\The [user] installs \the [thing] in \the [src]."))
	thing.forceMove(src)
	update_components()
	return TRUE

/obj/item/mech_component/proc/update_health()
	total_damage = brute_damage + burn_damage
	if(total_damage > max_damage) total_damage = max_damage
	damage_state = between(MECH_COMPONENT_DAMAGE_UNDAMAGED, round((total_damage/max_damage) * 4), MECH_COMPONENT_DAMAGE_DAMAGED_TOTAL)

/obj/item/mech_component/proc/ready_to_install()
	return TRUE

/obj/item/mech_component/proc/repair_brute_damage(var/amt)
	take_brute_damage(-amt)

/obj/item/mech_component/proc/repair_burn_damage(var/amt)
	take_burn_damage(-amt)

/obj/item/mech_component/proc/take_brute_damage(var/amt)
	brute_damage = max(0, brute_damage + amt)
	update_health()
	if(total_damage == max_damage)
		take_component_damage(amt,0)

/obj/item/mech_component/proc/take_burn_damage(var/amt)
	burn_damage = max(0, burn_damage + amt)
	update_health()
	if(total_damage == max_damage)
		take_component_damage(0,amt)

/obj/item/mech_component/proc/take_component_damage(var/brute, var/burn)
	var/list/damageable_components = list()
	for(var/obj/item/robot_parts/robot_component/RC in contents)
		damageable_components += RC
	if(!damageable_components.len) return
	var/obj/item/robot_parts/robot_component/RC = pick(damageable_components)
	if(RC.take_damage(brute, burn))
		qdel(RC)
		update_components()

/obj/item/mech_component/attackby(var/obj/item/thing, var/mob/user)
	if(thing.has_tool_quality(TOOL_SCREWDRIVER))
		if(contents.len)
			var/obj/item/removed = input("Which component would you like to remove") as null|anything in contents
			if(!removed)
				return
			user.visible_message(SPAN_NOTICE("\The [user] removes \the [removed] from \the [src]."))
			removed.forceMove(user.loc)
			playsound(user.loc, 'sound/effects/pop.ogg', 50, 0)
			update_components()
		else
			to_chat(user, SPAN_WARNING("There is nothing to remove."))
		return
	if(istype(thing, /obj/item/weldingtool))
		repair_brute_generic(thing, user)
		return
	if(istype(thing, /obj/item/stack/cable_coil))
		repair_burn_generic(thing, user)
		return

	if(thing.has_tool_quality(TOOL_MULTITOOL))
		query_color(user)
		return

	return ..()

/obj/item/mech_component/proc/update_components()
	return

/obj/item/mech_component/proc/repair_brute_generic(var/obj/item/weldingtool/WT, var/mob/user)
	if(!istype(WT))
		return
	if(!brute_damage)
		to_chat(user, SPAN_NOTICE("You inspect \the [src] but find nothing to repair."))
		return
	if(!WT.welding)
		to_chat(user, SPAN_WARNING("Turn \the [WT] on, first."))
		return
	if(WT.remove_fuel(1, user))
		if(do_after(user, 10, src) && brute_damage)
			repair_brute_damage(10)
			to_chat(user, SPAN_NOTICE("You mend the damage to \the [src]."))
			playsound(user.loc, 'sound/items/Welder.ogg', 25, 1)

/obj/item/mech_component/proc/repair_burn_generic(var/obj/item/stack/cable_coil/CC, var/mob/user)
	if(!istype(CC))
		return
	if(!burn_damage)
		to_chat(user, SPAN_NOTICE("\The [src]'s wiring doesn't need replacing."))
		return

	if(CC.get_amount() < 6)
		to_chat(user, SPAN_WARNING("You need at least 6 units of cable to repair this section."))
		return

	user.visible_message("\The [user] begins replacing the wiring of \the [src]...")

	if(do_after(user, 10, src) && burn_damage)
		if(QDELETED(CC) || QDELETED(src) || !CC.use(6))
			return

		repair_burn_damage(25)
		to_chat(user, SPAN_NOTICE("You mend the damage to \the [src]'s wiring."))
		playsound(user.loc, 'sound/items/Deconstruct.ogg', 25, 1)
	return
