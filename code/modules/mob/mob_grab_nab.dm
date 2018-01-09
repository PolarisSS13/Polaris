
// Nabbers are all about grabbing people for fighting, so they get cool
// grabbing stuff and need their own object for it.
/obj/item/weapon/grab/nabber
	var/has_been_neck = 0
	var/attacking = 0
	var/from_special = 0
	state = GRAB_AGGRESSIVE

/obj/item/weapon/grab/nabber/New(mob/user, mob/victim, var/special = 0)

	loc = user
	assailant = user
	affecting = victim

	from_special = special

	if(affecting.anchored || !assailant.Adjacent(victim)) //Shouldn't even be created if these aren't met
		return

	if((assailant.l_hand && assailant.l_hand != src && istype(assailant.l_hand, /obj/item/weapon/grab/nabber)))
		return
	if((assailant.r_hand && assailant.r_hand != src && istype(assailant.r_hand, /obj/item/weapon/grab/nabber)))
		return

	affecting.nabbed_by += src
	affecting.update_canmove()
	hud = new /obj/screen/grab(src)
	hud.icon_state = "reinforce1"
	icon_state = "grabbed1"
	hud.name = "reinforce grab"
	hud.master = src

	if(victim.grabbed_by)
		for (var/obj/item/weapon/grab/G in assailant.grabbed_by)
			if(G.assailant == affecting && G.affecting == assailant)
				to_chat(assailant, "<span class='warning'>[assailant] tears [G.affecting] out of your hands!</span>")
				qdel(G)

	if(assailant.nabbed_by)
		for (var/obj/item/weapon/grab/G in assailant.nabbed_by)
			if(G.assailant == affecting && G.affecting == assailant)
				G.dancing = 1
				G.adjust_position()
				dancing = 1

	assailant.set_dir(get_dir(assailant, affecting))
	last_action = world.time

	if(from_special)
		state = GRAB_NECK
		icon_state = "grabbed+1"
		assailant.set_dir(get_dir(assailant, affecting))
		admin_attack_log(assailant, affecting, "Grabbed the neck of their victim.", "Had their neck grabbed", "grabbed the neck of")

		hud.icon_state = "kill"
		hud.name = "kill"
		affecting.Stun(10) //10 ticks of ensured grab
		if(!has_been_neck)
			var/armor = affecting.run_armor_check(BP_TORSO, "melee")
			affecting.apply_damage(15, BRUTE, BP_TORSO, armor, 0, "organic punctures", 1, 0)
			affecting.visible_message("<span class='danger'>[assailant]'s spikes dig in painfully!</span>")
			has_been_neck = 1

	adjust_position()

/obj/item/weapon/grab/nabber/process()
	if(QDELETED(src)) // GC is trying to delete us, we'll kill our processing so we can cleanly GC
		return PROCESS_KILL

	if(!confirm())
		return PROCESS_KILL	//qdel'd in confirm.

	if(!assailant)
		qdel(src) // Same here, except we're trying to delete ourselves.
		return PROCESS_KILL

	if(assailant.client)
		assailant.client.screen -= hud
		assailant.client.screen += hud

	if(assailant.pulling == affecting)
		assailant.stop_pulling()

// TODO: redefine these grab things for nabbers
/obj/item/weapon/grab/nabber/handle_eye_mouth_covering(mob/living/carbon/human/target, mob/user, var/target_zone)
	last_hit_zone = target_zone

/obj/item/weapon/grab/nabber/process()
	if(QDELETED(src)) // GC is trying to delete us, we'll kill our processing so we can cleanly GC
		return PROCESS_KILL

	if(!confirm())
		return PROCESS_KILL	//qdel'd in confirm.

	if(!assailant)
		qdel(src) // Same here, except we're trying to delete ourselves.
		return PROCESS_KILL

	if(assailant.client)
		assailant.client.screen -= hud
		assailant.client.screen += hud

	if(assailant.pulling == affecting)
		assailant.stop_pulling()

	if(state <= GRAB_AGGRESSIVE)
		allow_upgrade = 1
		//disallow upgrading if we're grabbing more than one person
		if((assailant.l_hand && assailant.l_hand != src && istype(assailant.l_hand, /obj/item/weapon/grab)))
			var/obj/item/weapon/grab/G = assailant.l_hand
			if(G.affecting != affecting)
				allow_upgrade = 0
		if((assailant.r_hand && assailant.r_hand != src && istype(assailant.r_hand, /obj/item/weapon/grab)))
			var/obj/item/weapon/grab/G = assailant.r_hand
			if(G.affecting != affecting)
				allow_upgrade = 0

		//disallow upgrading past aggressive if we're being grabbed aggressively
		for(var/obj/item/weapon/grab/G in affecting.grabbed_by)
			if(G == src) continue
			if(G.state >= GRAB_AGGRESSIVE)
				allow_upgrade = 0

		if(allow_upgrade)
			if(state < GRAB_AGGRESSIVE)
				hud.icon_state = "reinforce"
			else
				hud.icon_state = "reinforce1"
		else
			hud.icon_state = "!reinforce"

	if(state >= GRAB_AGGRESSIVE)
		affecting.drop_l_hand()
		affecting.drop_r_hand()

		if(iscarbon(affecting))
			handle_eye_mouth_covering(affecting, assailant, assailant.zone_sel.selecting)

		if(force_down)
			if(affecting.loc != assailant.loc || size_difference(affecting, assailant) > 0)
				force_down = 0
			else
				affecting.Weaken(2)

	if(state >= GRAB_NECK)
		affecting.Stun(3)
		if(isliving(affecting))
			var/mob/living/L = affecting
			L.adjustOxyLoss(1)

	if(state >= GRAB_KILL)
		if(iscarbon(affecting))
			var/mob/living/carbon/C = affecting.
			C.Weaken(5)	//Should keep you down unless you get help.

		if(ishuman(affecting))
			var/mob/living/carbon/human/H = affecting
			var/hit_zone = assailant.zone_sel.selecting
			handle_crush_masticate(hit_zone, rand(8,14), rand(15,20), H)

	adjust_position()

/obj/item/weapon/grab/nabber/adjust_position()
	if(!affecting || affecting.buckled)
		return 1
	if(!assailant)
		return 2
	if(affecting.lying && state != GRAB_KILL)
		animate(affecting, pixel_x = 0, pixel_y = 0, 5, 1, LINEAR_EASING)
		if(force_down)
			affecting.set_dir(SOUTH) //face up
		return 3
	var/shift = 0
	var/adir = get_dir(assailant, affecting)
	affecting.layer = 4
	switch(state)
		if(GRAB_PASSIVE)
			shift = 8
			if(dancing) //look at partner
				shift = 10
				assailant.set_dir(get_dir(assailant, affecting))
		if(GRAB_NECK, GRAB_UPGRADING, GRAB_KILL, GRAB_AGGRESSIVE)
			shift = -10
			adir = assailant.dir
			affecting.set_dir(assailant.dir)
			affecting.forceMove(assailant.loc)

	switch(adir)
		if(NORTH)
			animate(affecting, pixel_x = 0, pixel_y =-shift, 5, 1, LINEAR_EASING)
			affecting.plane = assailant.plane
			affecting.layer = assailant.layer - 0.01
		if(SOUTH)
			animate(affecting, pixel_x = 0, pixel_y = shift + 6, 5, 1, LINEAR_EASING)
		if(WEST)
			animate(affecting, pixel_x = shift, pixel_y = 0, 5, 1, LINEAR_EASING)
		if(EAST)
			animate(affecting, pixel_x =-shift, pixel_y = 0, 5, 1, LINEAR_EASING)


/obj/item/weapon/grab/nabber/s_click(obj/screen/S)
	if(QDELETED(src))
		return
	if(!affecting)
		return
	if(state == GRAB_UPGRADING)
		return
	if(!assailant.canClick())
		return
	if(world.time < (last_action + UPGRADE_COOLDOWN))
		return
	if(!assailant.canmove || assailant.lying)
		qdel(src)
		return

	last_action = world.time

	if(assailant.a_intent == I_HELP)
		switch(state)
			if(GRAB_PASSIVE) //Lets go
				assailant.visible_message("<span class='notice'>[assailant] lets go of [affecting].</span>")
				qdel(src)

			if(GRAB_AGGRESSIVE) //downgrade to GRAB_PASSIVE
				if(force_down)
					to_chat(assailant, "<span class='warning'>You are no longer pinning [affecting] to the ground.</span>")
					force_down = 0

				assailant.visible_message("<span class='notice'>[assailant] has relaxed \his grip on [affecting].</span>")
				state = GRAB_PASSIVE
				icon_state = "grabbed"
				assailant.set_dir(get_dir(assailant, affecting))

				hud.icon_state = "reinforce"
				hud.name = "reinforce grab"

			if(GRAB_NECK) //downgrade to GRAB_AGGRESSIVE
				assailant.visible_message("<span class='notice'>[assailant] has relaxed \his grip on [affecting], spikes no longer digging in!</span>")
				hud.icon_state = "reinforce1"
				icon_state = "grabbed1"
				hud.name = "reinforce grab"
				state = GRAB_AGGRESSIVE
				has_been_neck = 1

			if(GRAB_KILL) //downgrade to GRAB_NECK
				assailant.visible_message("<span class='notice'>[assailant] has relaxed \his grip on [affecting], no longer crushing them.</span>")
				hud.icon_state = "kill"
				hud.name = "kill"
				state = GRAB_NECK
	else
		switch(state)
			if(GRAB_PASSIVE) //upgrade to GRAB_AGGRESSIVE
				if(!allow_upgrade)
					return
				if(!affecting.lying || size_difference(affecting, assailant) > 0)
					assailant.visible_message("<span class='warning'>[assailant] has grabbed [affecting] aggressively with its forelimbs!</span>")
				else
					assailant.visible_message("<span class='warning'>[assailant] pins [affecting] down to the ground (now hands)!</span>")
					apply_pinning(affecting, assailant)

				state = GRAB_AGGRESSIVE
				icon_state = "grabbed1"
				hud.icon_state = "reinforce1"
				affecting.update_canmove()
				assailant.set_dir(get_dir(assailant, affecting))
			if(GRAB_AGGRESSIVE) //upgrade to GRAB_NECK
				if(isslime(affecting))
					to_chat(assailant, "<span class='notice'>You squeeze [affecting], but nothing interesting happens.</span>")
					return

				assailant.visible_message("<span class='warning'>[assailant] has reinforced \his grip on [affecting], spiky forelimbs digging in!</span>")
				state = GRAB_NECK
				icon_state = "grabbed+1"
				assailant.set_dir(get_dir(assailant, affecting))
				admin_attack_log(assailant, affecting, "Grabbed the neck of their victim.", "Had their neck grabbed", "grabbed the neck of")

				hud.icon_state = "kill"
				hud.name = "kill"
				affecting.Stun(10) //10 ticks of ensured grab
				if(!has_been_neck)
					var/armor = affecting.run_armor_check(BP_TORSO, "melee")
					affecting.apply_damage(15, BRUTE, BP_TORSO, armor, 0, "organic punctures", 1, 0)
					affecting.visible_message("<span class='danger'>[assailant]'s spikes dig in painfully!</span>")
					has_been_neck = 1
			if(GRAB_NECK) //upgrade to GRAB_KILL
				assailant.visible_message("<span class='dkanger'>[assailant] starts to tighten \his grip on [affecting] and is trying to crush them!</span>")
				hud.icon_state = "kill1"

				state = GRAB_KILL
				assailant.visible_message("<span class='danger'>[assailant] has tightened \his grip on [affecting]. [affecting] is being crushed!</span>")
				admin_attack_log(assailant, affecting, "Strangled their victim", "Was strangled", "strangled")

				affecting.setClickCooldown(10)
				affecting.set_dir(WEST)
				if(iscarbon(affecting))
					var/mob/living/carbon/C = affecting
					C.losebreath += 1
	adjust_position()

/obj/item/weapon/grab/nabber/attack(mob/M, mob/living/user)
	if(QDELETED(src))
		return
	if(!affecting)
		return
	if(world.time < (last_action + UPGRADE_COOLDOWN))
		return
	if(!M.Adjacent(user))
		qdel(src)
		return
	if(state != GRAB_NECK)
		return

	reset_kill_state() //using special grab moves will interrupt choking them

	//clicking on the victim while grabbing them
	if(M == affecting)
		if(ishuman(affecting))
			var/mob/living/carbon/human/H = affecting
			var/hit_zone = assailant.zone_sel.selecting
			flick(hud.icon_state, hud)
			switch(assailant.a_intent)
				if(I_GRAB, I_HURT)
					last_action = world.time
					handle_crush_masticate(hit_zone, rand(8,14), rand(15,20), H)
	//clicking on yourself while grabbing them
	if(M == assailant && state >= GRAB_AGGRESSIVE)
		devour(affecting, assailant)

/obj/item/weapon/grab/nabber/proc/handle_crush_masticate(var/hit_zone, var/crush_damage, var/masticate_damage, var/mob/living/carbon/human/H)
	if(attacking)
		return

	var/obj/item/organ/external/organ = H.get_organ(hit_zone)
	switch(hit_zone)
		if(BP_TORSO, BP_HEAD, BP_GROIN)
			affecting.visible_message("<span class='danger'>[assailant] begins crushing [affecting]!</span>")
			attacking = 1
			if(do_mob(assailant, affecting, UPGRADE_COOLDOWN - 1))
				attacking = 0
				crush(hit_zone, crush_damage, H)
			else
				attacking = 0
				affecting.visible_message("<span class='notice'>[assailant] stops crushing [affecting]!</span>")

		if(BP_L_ARM, BP_L_HAND)
			hit_zone = BP_L_HAND
			organ = H.get_organ(hit_zone)
			if(organ.is_stump())
				hit_zone = BP_L_ARM
				masticate_damage += 5
				organ = H.get_organ(hit_zone)
				if(organ.is_stump())
					to_chat(assailant, "<span class='danger'>They are missing that limb!</span>")
					return 0
			affecting.visible_message("<span class='danger'>[assailant] begins chewing on [affecting]!</span>")
			attacking = 1
			if(do_mob(assailant, affecting, UPGRADE_COOLDOWN - 1))
				attacking = 0
				masticate(hit_zone, masticate_damage, H)
			else
				attacking = 0
				affecting.visible_message("<span class='notice'>[assailant] stops chewing on [affecting].</span>")


		if(BP_R_ARM, BP_R_HAND)
			hit_zone = BP_R_HAND
			organ = H.get_organ(hit_zone)
			if(organ.is_stump())
				hit_zone = BP_R_ARM
				masticate_damage += 5
				organ = H.get_organ(hit_zone)
				if(organ.is_stump())
					to_chat(assailant, "<span class='danger'>They are missing that limb!</span>")
					return 0
			affecting.visible_message("<span class='danger'>[assailant] begins chewing on [affecting]!</span>")
			attacking = 1
			if(do_mob(assailant, affecting, UPGRADE_COOLDOWN - 1))
				attacking = 0
				masticate(hit_zone, masticate_damage, H)
			else
				attacking = 0
				affecting.visible_message("<span class='notice'>[assailant] stops chewing on [affecting].</span>")

		if(BP_L_LEG, BP_L_FOOT)
			hit_zone = BP_L_FOOT
			organ = H.get_organ(hit_zone)
			if(organ.is_stump())
				hit_zone = BP_L_LEG
				masticate_damage += 5
				organ = H.get_organ(hit_zone)
				if(organ.is_stump())
					to_chat(assailant, "<span class='danger'>They are missing that limb!</span>")
					return 0
			affecting.visible_message("<span class='danger'>[assailant] begins chewing on [affecting]!</span>")
			attacking = 1
			if(do_mob(assailant, affecting, UPGRADE_COOLDOWN - 1))
				attacking = 0
				masticate(hit_zone, masticate_damage, H)
			else
				attacking = 0
				affecting.visible_message("<span class='notice'>[assailant] stops chewing on [affecting].</span>")

		if(BP_R_LEG, BP_R_FOOT)
			hit_zone = BP_R_FOOT
			organ = H.get_organ(hit_zone)
			if(organ.is_stump())
				hit_zone = BP_R_LEG
				masticate_damage += 5
				organ = H.get_organ(hit_zone)
				if(organ.is_stump())
					to_chat(assailant, "<span class='danger'>They are missing that limb!</span>")
					return 0
			affecting.visible_message("<span class='danger'>[assailant] begins chewing on [affecting]!</span>")
			attacking = 1
			if(do_mob(assailant, affecting, UPGRADE_COOLDOWN - 1))
				attacking = 0
				masticate(hit_zone, masticate_damage, H)
			else
				attacking = 0
				affecting.visible_message("<span class='notice'>[assailant] stops chewing on [affecting].</span>")


/obj/item/weapon/grab/nabber/proc/crush(var/hit_zone, var/attack_damage, var/mob/living/carbon/human/H)
	var/obj/item/organ/external/damaging = H.get_organ(hit_zone)
	var/armor = affecting.run_armor_check(hit_zone, "melee")

	affecting.visible_message("<span class='danger'>[assailant] crushes [affecting]'s [damaging.name]!</span>")

	if(prob(30))
		affecting.apply_damage(max(attack_damage + 10, 15), BRUTE, hit_zone, armor, 0, "organic punctures", 1, 0)
		affecting.apply_effect(attack_damage, AGONY, armor)
		affecting.visible_message("<span class='danger'>[assailant]'s spikes dig in painfully!</span>")
	else
		affecting.apply_damage(attack_damage, BRUTE, hit_zone, armor,, "crushing")
	playsound(assailant.loc, 'sound/weapons/bite.ogg', 25, 1, -1)

	admin_attack_log(assailant, affecting, "Crushed their victim.", "Was crushed.", "crushed")

/obj/item/weapon/grab/nabber/proc/masticate(var/hit_zone, var/attack_damage, var/mob/living/carbon/human/H)
	var/obj/item/organ/external/damaging = H.get_organ(hit_zone)
	var/armor = affecting.run_armor_check(hit_zone, "melee")

	affecting.apply_damage(attack_damage, BRUTE, hit_zone, armor, 0, "mandibles", 1, 1)
	affecting.visible_message("<span class='danger'>[assailant] chews on [affecting]'s [damaging.name]!</span>")
	playsound(assailant.loc, 'sound/weapons/bite.ogg', 25, 1, -1)

	admin_attack_log(assailant, affecting, "Chews their victim.", "Was chewed.", "chewed")

/obj/item/weapon/grab/nabber/reset_kill_state()
	if(!assailant)
		qdel(src)
		return
	if(state == GRAB_KILL)
		assailant.visible_message("<span class='warning'>[assailant] lost \his tight grip on [affecting] and is no longer crushing them!</span>")
		hud.icon_state = "kill"
		state = GRAB_NECK

/obj/item/weapon/grab/nabber/handle_resist()
	var/grab_name = "grip"
	var/break_strength = 1
	var/list/break_chance_table = list(100)
	switch(state)
		if(GRAB_PASSIVE)
			//Being knocked down makes it harder to break a grab, so it is easier to cuff someone who is down without forcing them into unconsciousness.
			//use same chance_table as aggressive but give +2 for not-weakened so that resomi grabs don't become auto-success for weakened either, that's lame
			if(!affecting.incapacitated(INCAPACITATION_KNOCKDOWN))
				break_strength += 2
			break_chance_table = list(15, 60, 100)

		if(GRAB_AGGRESSIVE)
			//Being knocked down makes it harder to break a grab, so it is easier to cuff someone who is down without forcing them into unconsciousness.
			if(!affecting.incapacitated(INCAPACITATION_KNOCKDOWN))
				break_strength++
			break_chance_table = list(15, 60, 100)

		if(GRAB_NECK)
			grab_name = "headlock"
			//If the you move when grabbing someone then it's easier for them to break free. Same if the affected mob is immune to stun.
			if(world.time - assailant.l_move_time < 30 || !affecting.stunned)
				break_strength++
			break_chance_table = list(3, 18, 45, 100)

		if(GRAB_KILL)
			grab_name = "stranglehold"
			break_chance_table = list(5, 20, 40, 80, 100)


	//It's easier to break out of a grab by a smaller mob and harder from a larger one
	break_strength += size_difference(affecting, assailant)

	var/break_chance = break_chance_table[Clamp(break_strength, 1, break_chance_table.len)]
	if(prob(break_chance))
		if(state == GRAB_KILL && !prob((break_chance+100)/2))
			if(grab_name)
				affecting.visible_message("<span class='warning'>[affecting] has broken free of [assailant]'s [grab_name]!</span>")
			reset_kill_state()
			return
		else
			if(grab_name)
				affecting.visible_message("<span class='warning'>[affecting] has broken free of [assailant]'s [grab_name]!</span>")
			qdel(src)

/obj/item/weapon/grab/nabber/Destroy()
	if(affecting)
		affecting.nabbed_by -= src
		affecting.update_canmove()
	if(assailant)
		if(assailant.client)
			assailant.client.screen -= hud
	return ..()

