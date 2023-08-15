/obj/item/robot_parts/frame
	name = "standard robot frame"
	desc = "A complex metal backbone with standard limb sockets and pseudomuscle anchors."
	icon_state = "robo_suit"
	var/list/parts = list()
	var/list/required_parts = list(
		BP_L_ARM = /obj/item/robot_parts/l_arm,
		BP_R_ARM = /obj/item/robot_parts/r_arm,
		BP_TORSO = /obj/item/robot_parts/chest,
		BP_L_LEG = /obj/item/robot_parts/l_leg,
		BP_R_LEG = /obj/item/robot_parts/r_leg,
		BP_HEAD  = /obj/item/robot_parts/head
	)
	var/created_name = ""
	var/product = /mob/living/silicon/robot

/obj/item/robot_parts/frame/examine(mob/user)
	. = ..()
	if(check_completion())
		. += SPAN_NOTICE("It is ready to receive a controlling intelligence.")
	else
		for(var/part in required_parts)
			if(!parts[part])
				var/obj/item/part_type = required_parts[part]
				. += SPAN_WARNING("It is missing \a [initial(part_type.name)]")

/obj/item/robot_parts/frame/update_model_info(var/model)
	return FALSE

/obj/item/robot_parts/frame/Initialize()
	. = ..()
	update_icon()

/obj/item/robot_parts/frame/update_icon()
	cut_overlays()
	for(var/part in required_parts)
		if(parts[part])
			add_overlay("[part]+o")

/obj/item/robot_parts/frame/proc/check_completion()
	for(var/part in required_parts)
		if(!parts[part])
			return FALSE
	return TRUE

/obj/item/robot_parts/frame/attackby(obj/item/W, mob/user)

	// Uninstall a robotic part.
	if(W.is_crowbar())
		if(!parts.len)
			to_chat(user, SPAN_WARNING("\The [src] has no parts to remove."))
			return
		var/removing = pick(parts)
		var/obj/item/robot_parts/part = parts[removing]
		part.forceMove(get_turf(src))
		user.put_in_hands(part)
		parts -= removing
		to_chat(user, SPAN_WARNING("You lever \the [part] off \the [src]."))
		update_icon()

	// Install a robotic part.
	else if (istype(W, /obj/item/robot_parts))
		var/obj/item/robot_parts/part = W
		if(!required_parts[part.bp_tag] || !istype(W, required_parts[part.bp_tag]))
			to_chat(user, SPAN_WARNING("\The [src] is not compatible with \the [W]."))
			return
		if(parts[part.bp_tag])
			to_chat(user, SPAN_WARNING("\The [src] already has \a [W] installed."))
			return
		if(part.can_install(user) && user.unEquip(W, src))
			parts[part.bp_tag] = part
			part.forceMove(src)
			update_icon()

	// Install an MMI/brain.
	else if(istype(W, /obj/item/mmi))

		if(!istype(loc,/turf))
			to_chat(user, SPAN_WARNING("You can't put \the [W] in without the frame being on the ground."))
			return

		if(!check_completion())
			to_chat(user, SPAN_WARNING("The frame is not ready for the central processor to be installed."))
			return

		var/obj/item/mmi/M = W
		var/mob/living/carbon/brain/B = M.brainmob
		if(!istype(M, /obj/item/mmi/inert))
			if(!B)
				to_chat(user, SPAN_WARNING("Sticking an empty [W.name] into the frame would sort of defeat the purpose."))
				return

			if(jobban_isbanned(B, "Cyborg"))
				to_chat(user, SPAN_WARNING("\The [W] does not seem to fit."))
				return

			if(B.stat == DEAD)
				to_chat(user, SPAN_WARNING("Sticking a dead [W.name] into the frame would sort of defeat the purpose."))
				return

			var/ghost_can_reenter = 0
			if(B.mind)
				if(B.key)
					ghost_can_reenter = TRUE
				else
					for(var/mob/observer/dead/G in player_list)
						if(G.can_reenter_corpse && G.mind == B.mind)
							ghost_can_reenter = TRUE
							//Jamming a ghosted brain into a borg is likely detrimental, and may result in some problems.
							to_chat(user, SPAN_NOTICE("\The [W] is completely unresponsive, but it may be able to auto-resuscitate if you leave it be for awhile."))
							break

			if(!ghost_can_reenter)
				to_chat(user, SPAN_WARNING("\The [W] is completely unresponsive; there's no point."))
				return

		if(!user.unEquip(W))
			return

		var/mob/living/silicon/robot/O = new product(get_turf(loc))
		if(!O)
			return

		O.mmi = W
		O.invisibility = 0
		O.custom_name = created_name
		O.updatename("Default")
		if(B)
			B.mind.transfer_to(O)
		if(O.mind && O.mind.assigned_role)
			O.job = O.mind.assigned_role
		else
			O.job = "Robot"

		var/obj/item/robot_parts/chest/chest = parts[BP_TORSO]
		if (chest && chest.cell)
			chest.cell.forceMove(O)
		W.forceMove(O) //Should fix cybros run time erroring when blown up. It got deleted before, along with the frame.

		// Since we "magically" installed a cell, we also have to update the correct component.
		if(O.cell)
			var/datum/robot_component/cell_component = O.components["power cell"]
			cell_component.wrapped = O.cell
			cell_component.installed = 1
		callHook("borgify", list(O))
		O.Namepick()
		qdel(src)

	else if(istype(W, /obj/item/pen))
		var/t = sanitizeSafe(input(user, "Enter new robot name", src.name, src.created_name), MAX_NAME_LEN)
		if(t && (in_range(src, user) || loc == user))
			created_name = t
	else
		..()

/obj/item/robot_parts/frame/Destroy()
	parts.Cut()
	for(var/thing in contents)
		qdel(thing)
	. = ..()

/obj/item/robot_parts/frame/proc/dismantled_from(mob/living/silicon/robot/donor)
	for(var/thing in required_parts - list(BP_TORSO, BP_HEAD))
		var/part_type = required_parts[thing]
		parts[thing] = new part_type(src)
	var/obj/item/robot_parts/chest/chest = (locate() in donor.contents) || new
	if(chest)
		chest.forceMove(src)
		parts[BP_TORSO] = chest
	update_icon()

/obj/item/robot_parts/frame/SetDefaultName()
	name = initial(name)

/obj/item/robot_parts/frame/flyer
	name = "flying robot frame"
	icon = 'icons/obj/robot_parts_flying.dmi'
	product = /mob/living/silicon/robot/flying
	required_parts = list(
		BP_L_ARM = /obj/item/robot_parts/l_arm,
		BP_R_ARM = /obj/item/robot_parts/r_arm,
		BP_TORSO = /obj/item/robot_parts/chest,
		BP_HEAD  = /obj/item/robot_parts/head
	)

/obj/item/robot_parts/frame/platform
	name = "large robot frame"
	icon = 'icons/obj/robot_parts_platform.dmi'
	product = /mob/living/silicon/robot/platform
	required_parts = list(
		BP_L_ARM = /obj/item/robot_parts/l_arm,
		BP_R_ARM = /obj/item/robot_parts/r_arm,
		BP_L_LEG = /obj/item/robot_parts/l_leg,
		BP_R_LEG = /obj/item/robot_parts/r_leg,
		BP_TORSO = /obj/item/robot_parts/chest,
		BP_HEAD  = /obj/item/robot_parts/head
	)
