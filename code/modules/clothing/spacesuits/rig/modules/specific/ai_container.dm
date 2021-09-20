/obj/item/ai_verbs
	name = "AI verb holder"

/obj/item/ai_verbs/verb/hardsuit_interface()
	set category = "Hardsuit"
	set name = "Open Hardsuit Interface"
	set src in usr

	if(!usr.loc || !usr.loc.loc || !istype(usr.loc.loc, /obj/item/rig_module))
		to_chat(usr, "You are not loaded into a hardsuit.")
		return

	var/obj/item/rig_module/module = usr.loc.loc
	if(!module.holder)
		to_chat(usr, "Your module is not installed in a hardsuit.")
		return

	module.holder.tgui_interact(usr, custom_state = GLOB.tgui_contained_state)

/obj/item/rig_module/ai_container

	name = "IIS module"
	desc = "An integrated intelligence system module suitable for most hardsuits."
	icon_state = "IIS"
	toggleable = 1
	usable = 1
	disruptive = 0
	activates_on_touch = 1

	engage_string = "Eject AI"
	activate_string = "Enable Core Transfer"
	deactivate_string = "Disable Core Transfer"

	interface_name = "integrated intelligence system"
	interface_desc = "A socket that supports a range of artificial intelligence systems."

	var/mob/integrated_ai // Direct reference to the actual mob held in the suit.
	var/obj/item/device/aicard/ai_card  // Reference to the MMI, posibrain, intellicard or pAI card previously holding the AI.
	var/obj/item/ai_verbs/verb_holder = /obj/item/ai_verbs
	var/ai_locked = FALSE	// Can the AI be interacted with? Ejected, Transferred, Etc.

/obj/item/rig_module/ai_container/process()
	if(integrated_ai)
		var/obj/item/weapon/rig/rig = get_rig()
		if(rig && rig.ai_override_enabled)
			integrated_ai.get_rig_stats = 1
		else
			integrated_ai.get_rig_stats = 0

/mob/living/Stat()
	. = ..()
	if(. && get_rig_stats)
		var/obj/item/weapon/rig/rig = get_rig()
		if(rig)
			SetupStat(rig)

/obj/item/rig_module/ai_container/proc/update_verb_holder()
	if(ispath(verb_holder))
		verb_holder = new verb_holder(src)
	if(integrated_ai)
		verb_holder.forceMove(integrated_ai)
	else
		verb_holder.forceMove(src)

/obj/item/rig_module/ai_container/accepts_item(var/obj/item/input_device, var/mob/living/user)
	if(ai_locked)
		return 0

	// Check if there's actually an AI to deal with.
	var/mob/living/silicon/ai/target_ai
	if(istype(input_device, /mob/living/silicon/ai))
		target_ai = input_device
	else
		target_ai = locate(/mob/living/silicon/ai) in input_device.contents

	var/obj/item/device/aicard/card = ai_card

	// Downloading from/loading to a terminal.
	if(istype(input_device,/obj/machinery/computer/aifixer) || istype(input_device,/mob/living/silicon/ai) || istype(input_device,/obj/structure/AIcore/deactivated))

		// If we're stealing an AI, make sure we have a card for it.
		if(!card)
			card = new /obj/item/device/aicard(src)

		// Terminal interaction only works with an intellicarded AI.
		if(!istype(card))
			return 0

		// Since we've explicitly checked for three types, this should be safe.
		input_device.attackby(card,user)

		// If the transfer failed we can delete the card.
		if(locate(/mob/living/silicon/ai) in card)
			ai_card = card
			integrated_ai = locate(/mob/living/silicon/ai) in card
		else
			eject_ai()
		update_verb_holder()
		return 1

	if(istype(input_device,/obj/item/device/aicard))
		// We are carding the AI in our suit.
		if(integrated_ai)
			integrated_ai.attackby(input_device,user)
			// If the transfer was successful, we can clear out our vars.
			if(integrated_ai.loc != src)
				integrated_ai = null
				eject_ai()
		else
			// You're using an empty card on an empty suit, idiot.
			if(!target_ai)
				return 0
			integrate_ai(input_device,user)
		return 1

	// Okay, it wasn't a terminal being touched, check for all the simple insertions.
	if(input_device.type in list(/obj/item/device/paicard, /obj/item/device/mmi, /obj/item/device/mmi/digital/posibrain))
		if(integrated_ai)
			integrated_ai.attackby(input_device,user)
			// If the transfer was successful, we can clear out our vars.
			if(integrated_ai.loc != src)
				integrated_ai = null
				eject_ai()
		else
			integrate_ai(input_device,user)
		return 1

	return 0

/obj/item/rig_module/ai_container/engage(atom/target)

	if(!..())
		return 0

	if(ai_locked)
		to_chat(usr, SPAN_WARNING("\The [src] gives an error code response."))
		return 0

	var/mob/living/carbon/human/H = holder.wearer

	if(!target)
		if(istype(ai_card))
			ai_card.tgui_interact(H, custom_state = deep_inventory_state)
		else if(!ai_locked)
			eject_ai(H)
		update_verb_holder()
		return 1

	if(accepts_item(target,H))
		return 1

	return 0

/obj/item/rig_module/ai_container/removed()
	eject_ai()
	..()

/obj/item/rig_module/ai_container/proc/eject_ai(var/mob/user)
	if(ai_locked)
		to_chat(usr, SPAN_WARNING("\The [src] gives an error code response."))
		return
	if(ai_card)
		if(istype(ai_card, /obj/item/device/aicard))
			if(integrated_ai && !integrated_ai.stat)
				if(user)
					to_chat(user, SPAN_DANGER("You cannot eject your currently stored AI. Purge it manually."))
				return 0
			to_chat(user, SPAN_DANGER("You purge the previous AI from your Integrated Intelligence System, freeing it for use."))
			if(integrated_ai)
				integrated_ai.ghostize()
				qdel(integrated_ai)
				integrated_ai = null
			if(ai_card)
				qdel(ai_card)
				ai_card = null
		else if(user)
			user.put_in_hands(ai_card)
		else
			ai_card.forceMove(get_turf(src))
	ai_card = null
	integrated_ai = null
	update_verb_holder()

/obj/item/rig_module/ai_container/proc/integrate_ai(var/obj/item/ai,var/mob/user)
	if(!ai) return

	if(ai_locked)
		to_chat(usr, SPAN_WARNING("\The [src] gives an error code response."))
		return

	// The ONLY THING all the different AI systems have in common is that they all store the mob inside an item.
	var/mob/living/ai_mob = locate(/mob/living) in ai.contents
	if(ai_mob?.key && ai_mob.client)
		if(istype(ai, /obj/item/device/aicard))

			if(!ai_card)
				ai_card = new /obj/item/device/aicard(src)

			var/obj/item/device/aicard/source_card = ai
			var/obj/item/device/aicard/target_card = ai_card
			if(istype(source_card) && istype(target_card) && target_card.grab_ai(ai_mob, user))
				source_card.clear()
			else
				return FALSE
		else
			user.drop_from_inventory(ai)
			ai.forceMove(src)
			ai_card = ai
			to_chat(ai_mob, SPAN_NOTICE("You have been transferred to \the [holder]'s [src]."))
			to_chat(user, SPAN_NOTICE("You load [ai_mob] into \the [holder]'s [src]."))

		integrated_ai = ai_mob

		if(!(locate(integrated_ai) in ai_card))
			integrated_ai = null
			eject_ai()
	else
		to_chat(user, SPAN_WARNING("There is no active AI within \the [ai]."))
	update_verb_holder()
	return

/*
 * The realm of cyberpunk, a Neural Jack-enabled IIS.
 * Components unashamedly utilizing the groundwork of borers.
 */
/obj/item/ai_verbs/advanced/verb/assume_control()
	set category = "Hardsuit"
	set name = "Enable Direct Control"
	set src in usr

	if(!usr.loc || !usr.loc.loc || !istype(usr.loc.loc, /obj/item/rig_module))
		to_chat(usr, SPAN_WARNING("You are not loaded into a hardsuit."))
		return

	var/obj/item/rig_module/ai_container/advanced/module = usr.loc.loc
	if(!module.holder)
		to_chat(usr, SPAN_WARNING("Your module is not installed in a hardsuit."))
		return

	module.jack_brain()

/obj/item/rig_module/ai_container/advanced
	name = "\improper AINI module"
	desc = "An artificial intelligence neural integration module, suitable for most hardsuits."
	description_fluff = "The unassuming device has no exterior markings, save for a network usage monitor and tiny warning label. On closer inspection, it reads, \"Warning: Device may cause damage if used without proper neural interface firmware.\" Something in your core urges you to heed that warning."
	description_info = "Unless used by a robotic RIG pilot, or an organic one with a neural implant, the module will cause brain-damage on activation of its override mode."
	icon_state = "AIIS"
	var/controlling = FALSE

	verb_holder = /obj/item/ai_verbs/advanced

	var/last_defib = 1
	var/mob/living/captive_brain/pilot_brain	
	var/obj/item/weapon/shockpaddles/rig/paddles
	var/imperfect_connection = FALSE	// Is the AI properly connected to the body? If N, they can't speak without sign-lang.
	var/corpse_pilot = FALSE	// Is the AI controlling a corpse? If Y, kill the body again when they revert.

/obj/item/rig_module/ai_container/advanced/Initialize()
	. = ..()

	paddles = new(src)

/obj/item/rig_module/ai_container/advanced/removed()
	revert()
	..()

/obj/item/rig_module/ai_container/advanced/process()
	if(holder)
		if((holder.offline || !holder.ai_override_enabled) && controlling)
			revert()

		if(controlling)
			var/mob/living/carbon/human/H = holder.wearer

			var/mob/living/simple_mob/animal/borer/Borer = H.has_brain_worms()
			if(Borer)	// As funny as it would be to see a borer, AI, and human swap minds like musical chairs, let's not.
				revert()
				to_chat(integrated_ai, SPAN_DANGER("<span class='danger'>The neural jack signals a warning abruptly, before rapidly retracting.</span>"))
				to_chat(H, SPAN_WARNING("You are shoved into consciousness as though you have been dropped into freezing water."))
				return

			var/obj/item/organ/internal/brain/Brain = H.internal_organs_by_name[O_BRAIN]
			if(Brain)
				if(Brain.robotic < ORGAN_ASSISTED)
					H.add_modifier(/datum/modifier/mute, 30 SECONDS, suppress_failure = TRUE)

			if(H.stat == DEAD && world.time > last_defib + 1 MINUTE && (H.getBruteLoss() + H.getFireLoss()) < (H.getMaxHealth() * 2 - H.getCloneLoss()))
				H.setToxLoss(0)
				paddles.attack(holder,integrated_ai)
				if(H.stat != DEAD)
					corpse_pilot = TRUE

			if(H.stat != DEAD)
				if(corpse_pilot)
					H.setOxyLoss(0)
					H.add_modifier(/datum/modifier/risen_corpse, 30 SECONDS, suppress_failure = TRUE)
					last_defib = world.time
				if(H.sleeping)
					H.AdjustSleeping(-10)

			if(H.has_modifier_of_type(/datum/modifier/risen_corpse))
				H.adjustToxLoss(0.1)

	. = ..()

/obj/item/rig_module/ai_container/advanced/proc/jack_brain()
	set category = "Hardsuit"
	set name = "Enable Direct Control"
	set desc = "Engage a neural jack."

	var/mob/living/jacker = integrated_ai
	var/obj/item/weapon/rig/rig = holder
	var/mob/living/carbon/human/H = rig.wearer
	if(!(istype(H) && H.get_rig() == rig))
		to_chat(jacker, SPAN_WARNING("Your rig does not have a pilot, or is attached to an incompatible bioform."))
		return

	if(jacker.stat)
		to_chat(src, SPAN_WARNING("You cannot do that in your current state."))
		return

	if(!holder.ai_override_enabled)
		to_chat(src, SPAN_WARNING("You are locked out of \the [src]'s neural jack controls."))
		return

	to_chat(jacker, SPAN_NOTICE("You begin the process of enabling \the [src]'s neural jack."))
	to_chat(H, SPAN_WARNING("\The [rig]'s [src] begins clacking, accompanied by a pressure along your spine."))

	if(do_after(jacker, 1 MINUTE, H, ignore_movement = TRUE))
		if(!H || !integrated_ai || controlling || !rig.ai_override_enabled)
			return

		to_chat(jacker, SPAN_WARNING("You fully engage \the [src]'s neural jack, interfacing directly with the pilot's nervous system."))
		var/obj/item/organ/internal/brain/Brain = H.internal_organs_by_name[O_BRAIN]
		if(!Brain)
			to_chat(jacker, SPAN_WARNING("\The [src] responds with an error code, as the neural jack swiftly retracts. The pilot has no neural cortex."))
			return

		if(H.has_brain_worms())
			to_chat(jacker, SPAN_WARNING("\The [src] connects, but only for a moment. You see the world through.. alien eyes, for a brief instant, as the jack retracts."))
			to_chat(H, SPAN_WARNING("Something moves under the surface of your neck."))
			return

		if(Brain.robotic < ORGAN_ASSISTED)
			to_chat(H, SPAN_WARNING("You feel a strange shifting sensation behind your eyes as a consciousness displaces yours. Your final sensation is that of something wet tearing."))
			H.adjustBrainLoss(rand(0,5))
			imperfect_connection = TRUE

		else
			to_chat(H, SPAN_WARNING("You feel a strange shifting sensation behind your eyes as a consciousness displaces yours."))

		if(H.stat == DEAD)
			corpse_pilot = TRUE

		// pilot -> brain
		qdel(pilot_brain)
		pilot_brain = new(src)

		H.transfer_player(pilot_brain)

		// AI -> pilot
		jacker.transfer_player(H)
		controlling = TRUE
		ai_locked = TRUE

		H.verbs += /mob/living/carbon/proc/release_control

		return

/obj/item/rig_module/ai_container/advanced/proc/revert()
	if(controlling && integrated_ai && pilot_brain)
		var/mob/living/carbon/human/H = holder.loc	// The mob wearing the rig

		if(istype(H))
			controlling = FALSE
			H.verbs -= /mob/living/carbon/proc/release_control

			H.transfer_player(integrated_ai)

			to_chat(pilot_brain, "<span class='notice'>Your mind returns from a strange limbo, the sensations of the body returning.[imperfect_connection ? " Your voice returns shakily." : ""][corpse_pilot ? " <span class='warning'>And then everything comes crashing down.</span>" : ""]</span>")

			pilot_brain.transfer_player(H)

			QDEL_NULL(pilot_brain)
			ai_locked = FALSE
			imperfect_connection = FALSE

			if(H.has_modifier_of_type(/datum/modifier/risen_corpse) || corpse_pilot)
				H.death()

			corpse_pilot = FALSE

	return
