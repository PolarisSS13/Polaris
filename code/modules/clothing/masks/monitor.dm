//IPC-face object for FPB.
/obj/item/clothing/mask/monitor

	name = "display monitor"
	desc = "A rather clunky old CRT-style display screen, fit for mounting on an optical output."
	flags_inv = HIDEFACE|HIDEEYES
	body_parts_covered = FACE
	dir = SOUTH

	icon = 'icons/mob/monitor_icons.dmi'
	icon_override = 'icons/mob/monitor_icons.dmi'
	icon_state = "monitor"

	var/monitor_state_index = "blank"

	var/list/standard_monitors = list(
		"blank"		= "ipc_blank",
		"pink"		= "ipc_pink",
		"green"		= "ipc_green",
		"red"		= "ipc_red",
		"blue"		= "ipc_blue",
		"shower"	= "ipc_shower",
		"orange"	= "ipc_orange",
		"nature"	= "ipc_nature",
		"eight"		= "ipc_eight",
		"goggles"	= "ipc_goggles",
		"heart"		= "ipc_heart",
		"monoeye"	= "ipc_monoeye",
		"breakout"	= "ipc_breakout",
		"yellow"	= "ipc_yellow",
		"static"	= "ipc_static",
		"purple"	= "ipc_purple",
		"scroll"	= "ipc_scroll",
		"console"	= "ipc_console",
		"glider"	= "ipc_gol_glider",
		"rainbow"	= "ipc_rainbow"
		)

	var/list/hesphiastos_alt_monitors = list(
		"blank"		= "hesphiastos_alt_off",
		"pink"		= "hesphiastos_alt_pink",
		"orange"	= "hesphiastos_alt_orange",
		"goggles"	= "hesphiastos_alt_goggles",
		"scroll"	= "hesphiastos_alt_scroll",
		"rgb"		= "hesphiastos_alt_rgb",
		"rainbow"	= "hesphiastos_alt_rainbow"
		)

	var/list/monitor_states

/obj/item/clothing/mask/monitor/set_dir()
	dir = SOUTH
	return

/obj/item/clothing/mask/monitor/equipped()
	..()
	var/mob/living/carbon/human/H = loc
	if(istype(H) && H.wear_mask == src)
		var/obj/item/organ/external/E = H.organs_by_name[BP_HEAD]
		var/datum/robolimb/robohead = all_robolimbs[E.model]
		canremove = 0
		if(robohead.is_monitor)
			if(robohead.is_monitor == 1)
				monitor_states = standard_monitors
				icon_state = "ipc_blank"
			else if(robohead.is_monitor == 2)
				monitor_states = hesphiastos_alt_monitors
				icon_state = "hesphiastos_alt_off"
			H << "<span class='notice'>\The [src] connects to your display output.</span>"

/obj/item/clothing/mask/monitor/dropped()
	canremove = 1
	return ..()

/obj/item/clothing/mask/monitor/mob_can_equip(var/mob/living/carbon/human/user, var/slot)
	if (!..())
		return 0
	if(istype(user))
		var/obj/item/organ/external/E = user.organs_by_name[BP_HEAD]
		var/datum/robolimb/robohead = all_robolimbs[E.model]
		if(istype(E) && (E.status & ORGAN_ROBOT) && robohead.is_monitor)
			return 1
		user << "<span class='warning'>You must have a compatible robotic head to install this upgrade.</span>"
	return 0

/obj/item/clothing/mask/monitor/verb/set_monitor_state()
	set name = "Set Monitor State"
	set desc = "Choose an icon for your monitor."
	set category = "IC"

	set src in usr
	var/mob/living/carbon/human/H = loc
	if(!istype(H) || H != usr)
		return
	if(H.wear_mask != src)
		usr << "<span class='warning'>You have not installed \the [src] yet.</span>"
		return
	var/choice = input("Select a screen icon.") as null|anything in monitor_states
	if(choice)
		monitor_state_index = choice
		update_icon()

/obj/item/clothing/mask/monitor/update_icon()
	if(!(monitor_state_index in monitor_states))
		monitor_state_index = initial(monitor_state_index)
	icon_state = monitor_states[monitor_state_index]
	var/mob/living/carbon/human/H = loc
	if(istype(H)) H.update_inv_wear_mask()