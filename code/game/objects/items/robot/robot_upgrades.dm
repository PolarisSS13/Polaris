/*
 * Cyborg/Robot Upgrades
 * Contains various robot upgrade modules.
 */
/obj/item/borg/upgrade
	name = "borg upgrade module."
	desc = "Protected by FRM."
	icon = 'icons/obj/module.dmi'
	icon_state = "cyborg_upgrade"

	var/locked = FALSE
	var/require_module = FALSE
	var/installed = FALSE

/obj/item/borg/upgrade/proc/action(mob/living/silicon/robot/R)
	if(R.stat == DEAD)
		to_chat(usr, SPAN_WARNING("The [src] will not function on a deceased robot."))
		return FALSE

	return TRUE


/obj/item/borg/upgrade/reset
	name = "robotic module reset board"
	desc = "Used to reset a cyborg's module. Destroys any other upgrades applied to the robot."
	icon_state = "cyborg_upgrade1"
	item_state = "cyborg_upgrade"
	require_module = TRUE

/obj/item/borg/upgrade/reset/action(mob/living/silicon/robot/R)
	if(!..())
		return FALSE

	R.module_reset()
	return TRUE


/obj/item/borg/upgrade/rename
	name = "robot reclassification board"
	desc = "Used to rename a cyborg."
	icon_state = "cyborg_upgrade1"
	item_state = "cyborg_upgrade"

	var/heldname = "default name"

/obj/item/borg/upgrade/rename/attack_self(mob/user as mob)
	heldname = sanitizeSafe(input(user, "Enter new robot name", "Robot Reclassification", heldname), MAX_NAME_LEN)

/obj/item/borg/upgrade/rename/action(mob/living/silicon/robot/R)
	if(!..())
		return FALSE

	R.notify_ai(ROBOT_NOTIFICATION_NEW_NAME, R.name, heldname)
	R.name = heldname
	R.custom_name = heldname
	R.real_name = heldname
	return TRUE


/obj/item/borg/upgrade/restart
	name = "robot emergency restart module"
	desc = "Used to force a restart of a disabled-but-repaired robot, bringing it back online."
	icon_state = "cyborg_upgrade1"
	item_state = "cyborg_upgrade"

/obj/item/borg/upgrade/restart/action(mob/living/silicon/robot/R)
	if(R.health < 0)
		to_chat(usr, "You have to repair the robot before using this module!")
		return FALSE

	if(isnull(R.key))
		for(var/mob/observer/dead/ghost in player_list)
			if(ghost.mind && ghost.mind.current == R)
				R.key = ghost.key

	R.set_stat(CONSCIOUS)
	dead_mob_list -= R
	living_mob_list |= R
	R.notify_ai(ROBOT_NOTIFICATION_NEW_UNIT)
	return TRUE


/obj/item/borg/upgrade/vtec
	name = "robotic VTEC Module"
	desc = "Used to kick in a robot's VTEC systems, increasing their speed."
	icon_state = "cyborg_upgrade2"
	item_state = "cyborg_upgrade"
	require_module = TRUE

	var/move_delay_reduction = 0.5

/obj/item/borg/upgrade/vtec/action(mob/living/silicon/robot/R)
	if(!..())
		return FALSE
	if(R.speed == (initial(R.speed) - move_delay_reduction))
		return FALSE

	R.speed -= move_delay_reduction
	return TRUE


/obj/item/borg/upgrade/tasercooler
	name = "robotic Rapid Taser Cooling Module"
	desc = "Used to cool a mounted taser, increasing the potential current in it and thus its recharge rate."
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"
	require_module = TRUE

/obj/item/borg/upgrade/tasercooler/action(mob/living/silicon/robot/R)
	if(!..())
		return FALSE
	if(!R.module || !(type in R.module.supported_upgrades))
		to_chat(R, "Upgrade mounting error! No suitable hardpoint detected!")
		to_chat(usr, "There's no mounting point for the module!")
		return FALSE

	var/obj/item/gun/energy/taser/mounted/cyborg/T = locate() in R.module
	if(isnull(T))
		T = locate() in R.module.contents
	if(isnull(T))
		T = locate() in R.module.modules
	if(isnull(T))
		to_chat(usr, SPAN_WARNING("This robot has had its taser removed!"))
		return FALSE

	// This actually reduces the recharge time, not the fire delay.
	if(T.recharge_time <= 2)
		to_chat(R, "Maximum cooling achieved for this hardpoint!")
		to_chat(usr, "There's no room for another cooling unit!")
		return FALSE
	else
		T.recharge_time = max(2 , T.recharge_time - 4)
	return TRUE


/obj/item/borg/upgrade/jetpack
	name = "robot jetpack"
	desc = "A carbon dioxide jetpack suitable for low-gravity operations."
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"
	require_module = TRUE

/obj/item/borg/upgrade/jetpack/action(mob/living/silicon/robot/R)
	if(!..())
		return FALSE
	if(R.module.jetpack)
		to_chat(R, "Upgrade mounting error! No suitable hardpoint detected!")
		to_chat(usr, "There's no mounting point for the module!")
		return FALSE

	R.module.jetpack = new /obj/item/tank/jetpack/carbondioxide(R.module)
	R.internals = R.module.jetpack
	return TRUE


/obj/item/borg/upgrade/advhealth
	name = "advanced health analyzer module"
	desc = "A carbon dioxide jetpack suitable for low-gravity operations."
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"
	require_module = TRUE

/obj/item/borg/upgrade/advhealth/action(mob/living/silicon/robot/R)
	if(!..())
		return FALSE

	var/obj/item/healthanalyzer/advanced/T = locate() in R.module
	if(isnull(T))
		T = locate() in R.module.contents
	if(isnull(T))
		T = locate() in R.module.modules
	if(isnull(T))
		R.module.modules.Add(new /obj/item/healthanalyzer/advanced(R.module))
		return TRUE
	if(!isnull(T))
		to_chat(R, "Upgrade mounting error! No suitable hardpoint detected!")
		to_chat(usr, "There's no mounting point for the module!")
		return FALSE


/obj/item/borg/upgrade/syndicate
	name = "scrambled equipment module"
	desc = "Unlocks new and often deadly module specific items of a robot"
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"
	require_module = TRUE

/obj/item/borg/upgrade/syndicate/action(mob/living/silicon/robot/R)
	if(!..())
		return FALSE
	if(R.emag_items)
		return FALSE

	R.emag_items = TRUE
	return TRUE


/obj/item/borg/upgrade/language
	name = "language module"
	desc = "Used to let cyborgs other than clerical or service speak a variety of languages."
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"

/obj/item/borg/upgrade/language/action(mob/living/silicon/robot/R)
	if(!..())
		return FALSE

	R.add_language(LANGUAGE_SOL_COMMON, TRUE)
	R.add_language(LANGUAGE_TRADEBAND, TRUE)
	R.add_language(LANGUAGE_SIVIAN, TRUE)
	R.add_language(LANGUAGE_UNATHI, TRUE)
	R.add_language(LANGUAGE_SIIK, TRUE)
	R.add_language(LANGUAGE_AKHANI, TRUE)
	R.add_language(LANGUAGE_SKRELLIAN, TRUE)
	R.add_language(LANGUAGE_SKRELLIANFAR, FALSE)
	R.add_language(LANGUAGE_GUTTER, TRUE)
	R.add_language(LANGUAGE_SCHECHI, TRUE)
	R.add_language(LANGUAGE_ROOTLOCAL, TRUE)
	R.add_language(LANGUAGE_TERMINUS, TRUE)
	R.add_language(LANGUAGE_ZADDAT, TRUE)
	return TRUE
