/mob/living/bot/trashbot
	name = "Trashbot"
	desc = "A robot that picks up trash off of the floor."
	icon_state = "trashbot0"
	req_one_access = list(access_robotics, access_janitor)
	botcard_access = list(access_janitor, access_maint_tunnels)

	locked = 0 // Start unlocked so robot can set them to patrol, and turn them on.
	wait_if_pulled = 1
	min_target_dist = 0

	var/idle_emote = "makes a quiet humming sound."

	var/list/target_types = list()
	var/list/stored_items = list()

/mob/living/bot/trashbot/New()
	..()
	get_targets()
	update_icons()

/mob/living/bot/trashbot/handleIdle()
	if(prob(5))
		custom_emote(2, idle_emote)
		playsound(src.loc, 'sound/machines/synth_yes.ogg', 50, 0)

	if(src.emagged)
		if(prob(20))
			throwItem()
		if(prob(20))
			dropItem()

/mob/living/bot/trashbot/lookForTargets()
	for(var/obj/D in view(world.view, src))
		if(confirmTarget(D))
			target = D
			return

/mob/living/bot/trashbot/confirmTarget(var/obj/D)
	if(!..())
		return 0
	for(var/T in target_types)
		if(istype(D, T))
			return 1
	return 0

/mob/living/bot/trashbot/handleAdjacentTarget()
	if(get_turf(target) == src.loc)
		UnarmedAttack(target)

/mob/living/bot/trashbot/UnarmedAttack(var/obj/D, var/proximity)
	if(D.loc != src.loc)
		return

	busy = 1
	custom_emote(2, "sucks up \the [D].")
	stored_items += D
	D.forceMove(src)
	target = null
	busy = 0

/mob/living/bot/trashbot/proc/get_targets()

	target_types += /obj/item/ammo_casing
	target_types += /obj/item/trash
	target_types += /obj/item/weapon/reagent_containers/food/snacks //If it's somwhere trashbot can get it, you must not want it.
	target_types += /obj/item/weapon/paper
	target_types += /obj/item/weapon/paperplane
	//target_types += /obj/item/weapon/paper_bundle
	target_types += /obj/item/clothing/mask/smokable
	target_types += /obj/item/weapon/storage/box //If the box is not on a table, then it's obviously not important.
	return

/mob/living/bot/trashbot/emag_act(var/remaining_uses, var/mob/user)
	. = ..()
	if(!emagged)
		if(user)
			to_chat(user, "You short out \the [src]'s motherboard, a loud hissing sound follows.")
		visible_message("<span class='warning'>\The [src] makes an electrical hissing sound!</span>")
		emagged = 1
		idle_emote = "makes a loud banging sound."
		. = 1
	return 0

/mob/living/bot/trashbot/attack_hand(var/mob/user)
	var/dat
	dat += "<TT><B>Automatic Trash Cleaner v1.0</B></TT><BR><BR>"
	dat += "Status: <A href='?src=\ref[src];operation=start'>[on ? "On" : "Off"]</A><BR>"
	dat += "Behaviour controls are [locked ? "locked" : "unlocked"]<BR>"
	dat += "Maintenance panel is [open ? "opened" : "closed"]<BR>"
	dat += "The bag currently has [stored_items.len] items in it. <A href='?src=\ref[src]:operation=empty'>Remove Items?</A>"
	if(!locked || issilicon(user))
		dat += "<BR>Patrol station: <A href='?src=\ref[src];operation=patrol'>[will_patrol ? "Yes" : "No"]</A><BR>"

	user << browse("<HEAD><TITLE>Cleaner v1.0 controls</TITLE></HEAD>[dat]", "window=autocleaner")
	onclose(user, "autocleaner")
	return

/mob/living/bot/trashbot/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	add_fingerprint(usr)
	switch(href_list["operation"])
		if("start")
			if(on)
				turn_off()
			else
				turn_on()
		if("patrol")
			will_patrol = !will_patrol
			patrol_path = null
		if("empty")
			emptyItems()
	attack_hand(usr)

/mob/living/bot/trashbot/update_icons()
	icon_state = "trashbot[on]"

/mob/living/bot/trashbot/proc/emptyItems()
	for(var/obj/D in stored_items)
		D.forceMove(get_turf(src.loc))
	return

/mob/living/bot/trashbot/proc/throwItem()

	var/obj/item_to_throw = null
	var/mob/living/target = locate() in view(7,src)

	if(!target)
		return 0

	for(var/D in stored_items)
		item_to_throw = stored_items[D]
		if(!item_to_throw)
			break
	spawn(0)
		item_to_throw.throw_at(target, 16, 20, src)
	visible_message("<span class='warning'>\The [src] launches \a [item_to_throw] at \the [target]!</span>")
	return 1

/mob/living/bot/trashbot/proc/dropItem()
	var/obj/item_to_drop = null

	for(var/D in stored_items)
		item_to_drop = stored_items[D]
		if(!item_to_drop)
			break
	if(!item_to_drop)
		return 0
	spawn (0)
		item_to_drop.throw_at(src.loc, rand(0,3), 1)


/* Assembly */

/obj/item/weapon/trash_sensor
	name = "proxy trashbag"
	desc = "It's a trashbag with a sensor poorly tied to it."
	icon = 'icons/obj/aibots.dmi'
	icon_state = "all_knowing_bag"
	force = 0.5
	throwforce = 0.1
	throw_speed = 1
	throw_range = 3
	w_class = ITEMSIZE_NORMAL
	var/created_name = "Trashbot"

/obj/item/weapon/trash_sensor/attackby(var/obj/item/W, var/mob/user)
	..()
	if(istype(W, /obj/item/robot_parts/l_arm) || istype(W, /obj/item/robot_parts/r_arm) || (istype(W, /obj/item/organ/external/arm) && ((W.name == "robotic left arm") || (W.name == "robotic right arm"))))
		user.drop_item()
		qdel(W)
		var/turf/T = get_turf(loc)
		var/mob/living/bot/trashbot/A = new /mob/living/bot/trashbot(T)
		A.name = created_name
		to_chat(user,  "<span class='notice'>You add the robot arm to the <span class='warning'><b>all knowing trashbag</b></span> assembly.</span>")
		user.drop_from_inventory(src)
		qdel(src)

	else if(istype(W, /obj/item/weapon/pen))
		var/t = sanitizeSafe(input(user, "Enter new robot name", name, created_name), MAX_NAME_LEN)
		if(!t)
			return
		if(!in_range(src, usr) && src.loc != usr)
			return
		created_name = t