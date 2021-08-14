// Straight move from the old location, with the paths corrected.

/mob/living/captive_brain
	name = "host brain"
	real_name = "host brain"
	universal_understand = 1

/mob/living/captive_brain/say(var/message, var/datum/language/speaking = null, var/whispering = 0)

	if (src.client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, "<font color='red'>You cannot speak in IC (muted).</font>")
			return

	if(istype(src.loc, /mob/living/simple_mob/animal/borer))

		message = sanitize(message)
		if (!message)
			return
		log_say(message,src)
		if (stat == 2)
			return say_dead(message)

		var/mob/living/simple_mob/animal/borer/B = src.loc
		to_chat(src, "You whisper silently, \"[message]\"")
		to_chat(B.host, "The captive mind of [src] whispers, \"[message]\"")

		for (var/mob/M in player_list)
			if (istype(M, /mob/new_player))
				continue
			else if(M.stat == DEAD && M.is_preference_enabled(/datum/client_preference/ghost_ears))
				to_chat(M, "The captive mind of [src] whispers, \"[message]\"")

	else if(istype(src.loc,/obj/item/rig_module/ai_container/advanced))
		message = sanitize(message)

		if (!message)
			return
		log_say(message,src)
		if (stat == 2)
			return say_dead(message)

		var/obj/item/rig_module/ai_container/advanced/module = loc
		var/mob/living/carbon/human/H = module.holder.loc

		to_chat(src, "You think, \"<span class='notice'>[message]</span>\"")
		to_chat(H, "The displaced mind of [src] whispers, \"<span class='notice'>[message]</span>\"")

/mob/living/captive_brain/me_verb(message as text)
	to_chat(src, "<span class='danger'>You cannot emote as a captive mind.</span>")
	return

/mob/living/captive_brain/emote(var/message)
	to_chat(src, "<span class='danger'>You cannot emote as a captive mind.</span>")
	return

/mob/living/captive_brain/process_resist()
	//Resisting control by an alien mind.
	if(istype(src.loc, /mob/living/simple_mob/animal/borer))
		var/mob/living/simple_mob/animal/borer/B = src.loc
		var/mob/living/captive_brain/H = src

		to_chat(H, "<span class='danger'>You begin doggedly resisting the parasite's control (this will take approximately sixty seconds).</span>")
		to_chat(B.host, "<span class='danger'>You feel the captive mind of [src] begin to resist your control.</span>")

		spawn(rand(200,250)+B.host.brainloss)
			if(!B || !B.controlling) return

			B.host.adjustBrainLoss(rand(0.1,0.5))
			to_chat(H, "<span class='danger'>With an immense exertion of will, you regain control of your body!</span>")
			to_chat(B.host, "<span class='danger'>You feel control of the host brain ripped from your grasp, and retract your probosci before the wild neural impulses can damage you.</span>")
			B.detatch()
			verbs -= /mob/living/carbon/proc/release_control
			verbs -= /mob/living/carbon/proc/punish_host
			verbs -= /mob/living/carbon/proc/spawn_larvae

		return

	//Or control by an all-too-familiar machine.
	else if(istype(src.loc, /obj/item/rig_module/ai_container/advanced))
		var/obj/item/rig_module/ai_container/advanced/module = src.loc
		var/mob/living/captive_brain/H = src
		var/obj/item/weapon/rig/rig = module.holder
		var/mob/living/carbon/human/Pilot = rig.loc

		to_chat(H, "<span class='danger'>You begin doggedly resisting the neural jack's input (this will take approximately sixty seconds).</span>")
		to_chat(Pilot, "<span class='danger'>You feel the repressed mind of [src] begin to resist your control.</span>")

		if(do_after(H, rand(50 SECONDS,70 SECONDS), Pilot, ignore_movement = TRUE))
			Pilot.adjustBrainLoss(rand(0.1,0.5))
			to_chat(H, "<span class='danger'>With an immense exertion of will, you regain control of your body as the neural jack snakes back into \the [rig]!</span>")
			to_chat(Pilot, "<span class='danger'>You feel as though you are falling, before the neural jack retracts fully, and your processes return to \the [rig]'s limited scope.</span>")
			module.revert()

		return

	..()
