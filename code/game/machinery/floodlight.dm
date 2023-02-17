/obj/machinery/floodlight
	name = "emergency floodlight"
	desc = "A high-intensity flood lamp on a wheeled platform. It runs on a replaceable power cell."
	icon = 'icons/obj/machines/floodlight.dmi'
	icon_state = "floodlight"
	density = TRUE
	active_power_usage = 200
	var/panel_locked = TRUE
	var/brightness_on = 8
	var/datum/component/battery_power/BP

/obj/machinery/floodlight/Initialize()
	. = ..()
	BP = AddComponent(/datum/component/battery_power)
	if (BP)
		BP.cell = new(src)

/obj/machinery/floodlight/examine(mob/user)
	. = ..()
	if (!panel_open && !panel_locked)
		. += "The screws on the maintenance hatch have been loosened."
	else if (panel_open)
		. += "The maintenance hatch is open and [BP?.cell ? "there's \a [BP.cell] inside" : "the cell has been removed"]."

/obj/machinery/floodlight/update_icon()
	cut_overlays()
	if (use_power == USE_POWER_ACTIVE)
		add_overlay("floodlight_on")
	if (panel_open)
		add_overlay("floodlight_open")
		if (BP?.cell)
			add_overlay("floodlight_cell")

/obj/machinery/floodlight/process()
	if (use_power != USE_POWER_ACTIVE)
		return
	else if (!BP?.draw_power(get_power_usage() * CELLRATE))
		visible_message(SPAN_WARNING("\The [src]'s power cell dies!"))
		toggle(null, FALSE)
		return
	// If the cell is almost empty, rarely "flicker" the light. Aesthetic only.
	else if ((BP.cell?.percent() < 10) && prob(5))
		flicker()

/obj/machinery/floodlight/proc/flicker()
	set waitfor = FALSE
	set_light(brightness_on / 2, brightness_on / 4)
	sleep(0.5 SECONDS)
	if (use_power == USE_POWER_ACTIVE)
		set_light(brightness_on, brightness_on / 2)

/obj/machinery/floodlight/proc/toggle(mob/living/user, to_enable, loud)
	if (to_enable)
		if (!BP?.cell?.check_charge(active_power_usage * CELLRATE))
			to_chat(user, SPAN_WARNING("You flick \the [src]'s power switch, but nothing happens."))
			return
		update_use_power(USE_POWER_ACTIVE)
		set_light(brightness_on, brightness_on / 2)
	else
		update_use_power(USE_POWER_IDLE)
		set_light(0, 0)
	update_icon()
	if (loud)
		if (!user)
			visible_message(SPAN_NOTICE("\The [src] turns [use_power == USE_POWER_ACTIVE ? "on" : "off"]."))
		else
			user.visible_message(
				SPAN_NOTICE("\The [user] turns [use_power == USE_POWER_ACTIVE ? "on" : "off"] \the [src]."),
				SPAN_NOTICE("You turn [use_power == USE_POWER_ACTIVE ? "on" : "off"] \the [src]."))
	return TRUE

/obj/machinery/floodlight/attack_ai(mob/user)
	if (istype(user, /mob/living/silicon/robot) && Adjacent(user))
		return attack_hand(user)
	to_chat(user, SPAN_WARNING("\The [src] is manually controlled; you can't activate it remotely."))
	return

/obj/machinery/floodlight/attack_hand(mob/user)
	. = ..()
	if (!panel_open)
		toggle(user, use_power != USE_POWER_ACTIVE, TRUE)
	else if (!BP?.cell) // Automatically disable if the user took out the cell as part of the interaction
		toggle(null, FALSE)

/obj/machinery/floodlight/attackby(obj/item/O, mob/user)
	if (O.has_tool_quality(TOOL_CROWBAR))
		if (panel_locked)
			to_chat(user, SPAN_WARNING("You'll need to remove the screws before you can pry open \the [src]'s maintenance hatch."))
			return
		panel_open = !panel_open
		user.visible_message(
			SPAN_NOTICE("\The [user] pries \the [src]'s maintenance hatch [panel_open ? "open" : "shut"]."),
			SPAN_NOTICE("You lever \the [src]'s maintenance hatch [panel_open ? "open" : "shut"].")
		)
		playsound(src, 'sound/items/Deconstruct.ogg', 50, TRUE)
		update_icon()
		return
	else if (O.has_tool_quality(TOOL_SCREWDRIVER))
		if (panel_open)
			to_chat(user, SPAN_WARNING("The maintenance hatch is wide open!"))
			return
		panel_locked = !panel_locked
		user.visible_message(
			SPAN_NOTICE("\The [user] [panel_locked ? "tightens" : "loosens"] the screws on \the [src]'s maintenance hatch."),
			SPAN_NOTICE("You [panel_locked ? "tighten" : "loosen"] the screws on the maintenance hatch.")
		)
		playsound(src, 'sound/items/Screwdriver.ogg', 50, TRUE)
	. = ..()
