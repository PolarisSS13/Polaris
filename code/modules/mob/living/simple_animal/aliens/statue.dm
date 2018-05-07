// A mob which only moves when it isn't being watched by living beings.
//Weeping angels/SCP-173 hype
//Horrible shitcoding and stolen code adaptations below. You have been warned.

/mob/living/simple_animal/hostile/statue
	name = "statue" // matches the name of the statue with the flesh-to-stone spell
	desc = "An incredibly lifelike marble carving. Its eyes seems to follow you..." // same as an ordinary statue with the added "eye following you" description
	icon = 'icons/obj/statue.dmi'
	tt_desc = "angelum weepicus"
	icon_state = "human_male"
	icon_living = "human_male"
	icon_dead = "human_male"
	intelligence_level = SA_HUMANOID
	var/annoyance = 30 //stop staring you creep
	var/respond = 1
	var/banishable = 0
	faction = "statue"
	mob_size = MOB_HUGE
	response_help = "touches"
	response_disarm = "pushes"
	environment_smash = 2
	can_be_antagged = 1
	speed = -1
	maxHealth = 50000
	health = 50000
//	investigates = 1


	harm_intent_damage = 60
	melee_damage_lower = 50
	melee_damage_upper = 70
	attacktext = "clawed"
	attack_sound = 'sound/hallucinations/growl1.ogg'

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	maxbodytemp = 9000
	run_at_them = 0


	move_to_delay = 0 // Very fast

	animate_movement = NO_STEPS // Do not animate movement, you jump around as you're a scary statue.

	see_in_dark = 13
	view_range = 35 //So it can run at the victim when out of the view

	melee_miss_chance = 0


	see_invisible = SEE_INVISIBLE_NOLIGHTING
	sight = SEE_SELF|SEE_MOBS|SEE_OBJS|SEE_TURFS
	anchored = 1
	var/last_hit = 0
	var/cannot_be_seen = 1
	var/mob/living/creator = null
	mob_swap_flags = null

// No movement while seen code.

/mob/living/simple_animal/hostile/statue/New(loc)
	..()
	// Give spells
	add_spell(new/spell/aoe_turf/flicker_lights)
	add_spell(new/spell/aoe_turf/blindness)
	add_spell(new/spell/aoe_turf/shatter)

/mob/living/simple_animal/hostile/statue/DestroySurroundings()
	if(can_be_seen(get_turf(loc)))
		if(client)
			to_chat(src, "<span class='warning'>You cannot move, there are eyes on you!</span>")
		return 0
	return ..()

/mob/living/simple_animal/hostile/statue/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/weapon/nullrod))
		visible_message("<span class='warning'>[user] tries to banish [src] with [O]!</span>")
		if(do_after(user, 15, src))
			if(banishable)
				visible_message("<span class='warning'>[src] crumbles into dust!</span>")
				gib()
			else
				visible_message("<span class='warning'>[src] is too strong to be banished!</span>")
				Paralyse(rand(8,15))

/mob/living/simple_animal/hostile/statue/death()
	new /obj/item/stack/material/marble(loc)

/mob/living/simple_animal/hostile/statue/Move(turf/NewLoc)
	if(can_be_seen(NewLoc))
		if(client)
			to_chat(src, "<span class='warning'>You cannot move, there are eyes on you!</span>")
		return 0
	return ..()

/mob/living/simple_animal/hostile/statue/Life()
	..()
	handleAnnoyance()
	if(target_mob)
		if((annoyance + 4) < 800)
			annoyance += 4
	else if ((annoyance - 2) > 0)
		annoyance -= 2

/mob/living/simple_animal/hostile/statue/handle_stance()
	if(!..())
		return
	if(target_mob) // If we have a target and we're AI controlled
		var/mob/watching = can_be_seen()
		// If they're not our target
		if(watching && watching != target_mob)
			// This one is closer.
			if(get_dist(watching, src) > get_dist(target_mob, src))
				LoseTarget()
				target_mob = watching


/mob/living/simple_animal/hostile/statue/proc/handleAnnoyance()
	if(respond) //so it won't blind people 24/7
		respond = 0
		if (annoyance > 50)
			AI_blind()
			annoyance -= 15
			if (prob(30))
				var/turf/T = get_turf(loc)
				if(T.get_lumcount() * 10 > 1.5)
					AI_flash()
					annoyance -= 35
	spawn(18)
		respond = 1


/mob/living/simple_animal/hostile/statue/proc/AI_blind()
	for(var/mob/living/L in oviewers(7, src))
		if (prob(75))
			if(istype(L , /mob/living/carbon/human))
				var/mob/living/carbon/human/H = L
				if (H.species == "Diona" || H.species == "Promethean")// can't blink and organic
					return
			to_chat(L, "<span class='notice'>Your eyes feel very heavy.</span>")
			L.Blind(2)
	return

/mob/living/simple_animal/hostile/statue/proc/AI_flash()
	if (prob(60))
		visible_message("The statue slowly points at the light.")
	for(var/obj/machinery/light/L in oview(12, src))
		L.flicker()
	return


/mob/living/simple_animal/hostile/statue/proc/AI_mirrorshmash()
	for(var/obj/structure/mirror/M in oview(4, src))
		if ((!M.shattered )||(!M.glass))
			visible_message("The statue slowly points at the mirror!")
			sleep(5)
			M.shatter()
	return



/mob/living/simple_animal/hostile/statue/AttackTarget()
	if(can_be_seen(get_turf(loc)))
		if(client)
			to_chat(src, "<span class='warning'>You cannot attack, there are eyes on you!</span>")
			return
	else
		spawn(3) //a small delay
		..()



/mob/living/simple_animal/hostile/statue/DoPunch(var/atom/A)
	if(!Adjacent(A)) // They could've moved in the meantime.
		return FALSE

	var/damage_to_do = rand(melee_damage_lower, melee_damage_upper)

	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.outgoing_melee_damage_percent))
			damage_to_do *= M.outgoing_melee_damage_percent

	// SA attacks can be blocked with shields.
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		H.adjustBruteLossByPart(damage_to_do*0.9, pick(BP_HEAD, BP_TORSO))
		playsound(src, attack_sound, 75, 1)

	else if(A.attack_generic(src, damage_to_do, pick(attacktext), attack_armor_type, attack_armor_pen, attack_sharp, attack_edge) && attack_sound)
		playsound(src, attack_sound, 75, 1)

	return TRUE





/mob/living/simple_animal/hostile/statue/face_atom()
	if(!can_be_seen(get_turf(loc)))
		..()

/mob/living/simple_animal/hostile/statue/proc/can_be_seen(turf/destination)
	if(!cannot_be_seen)
		return null
	// Check for darkness
	var/turf/T = get_turf(loc)
	if(T && destination && T.lighting_overlay)
		if(T.get_lumcount() * 10 < 0.9 && destination.get_lumcount() * 10 < 0.9) // No one can see us in the darkness, right?
			return null
		if(T == destination)
			destination = null

	// We aren't in darkness, loop for viewers.
	var/list/check_list = list(src)
	if(destination)
		check_list += destination

	// This loop will, at most, loop twice.
	for(var/atom/check in check_list)
		for(var/mob/living/M in viewers(world.view + 1, check) - src)
			if(!(M.sdisabilities & BLIND) || !(M.blinded))
				if(M.has_vision() && !M.isSynthetic())
					return M
		for(var/obj/mecha/M in view(world.view + 1, check)) //assuming if you can see them they can see you
			if(M.occupant && M.occupant.client)
				if(M.occupant.has_vision() && !M.occupant.isSynthetic())
					return M.occupant
		for(var/obj/structure/mirror/M in view(3, check)) //Weeping angels hate mirrors. Probably because they're ugly af
			if ((!M.shattered )||(!M.glass))
				annoyance += 3
				if (prob(5) && (ai_inactive == 0))
					AI_mirrorshmash()
					annoyance -= 50
				return src //if it sees the mirror, it sees itself, right?
	return null

// Cannot talk

/mob/living/simple_animal/hostile/statue/say()
	return 0

// Turn to dust when gibbed

/mob/living/simple_animal/hostile/statue/gib()
	dust()


// Stop attacking clientless mobs

/mob/living/simple_animal/hostile/statue/proc/CanAttack(atom/the_target) //ignore clientless mobs
	if(isliving(the_target))
		var/mob/living/L = the_target
		if(!L.client && !L.ckey)
			return 0
	return ..()

// Statue powers

// Flicker lights
/spell/aoe_turf/flicker_lights
	name = "Flicker Lights"
	desc = "You will trigger a large amount of lights around you to flicker."
	spell_flags = 0
	charge_max = 400
	range = 10

/spell/aoe_turf/flicker_lights/cast(list/targets, mob/user = usr)
	for(var/turf/T in targets)
		for(var/obj/machinery/light/L in T)
			L.flicker()
	return

//Blind AOE
/spell/aoe_turf/blindness
	name = "Blindness"
	desc = "Your prey will be momentarily blind for you to advance on them."

	message = "<span class='notice'>You glare your eyes.</span>"
	charge_max = 250
	spell_flags = 0
	range = 10

/spell/aoe_turf/blindness/cast(list/targets, mob/user = usr)
	for(var/mob/living/L in targets)
		if(L == user)
			continue
		var/turf/T = get_turf(L.loc)
		if(T && T in targets)
			L.Blind(4)
	return


/spell/aoe_turf/shatter
	name = "Shatter mirrors!"
	desc = "That handsome devil has to wait. You have people to make into corpses."

	message = "<span class='notice'>You glare your eyes.</span>"
	charge_max = 2000
	silenced = 500
	spell_flags = 0
	range = 10




/spell/aoe_turf/shatter/cast(list/targets, mob/user = usr)
	for(var/obj/structure/mirror/M in view(5, src))
		if ((!M.shattered )||(!M.glass))
			M.shatter()
	return



/mob/living/simple_animal/hostile/statue/verb/toggle_darkness()
	set name = "Toggle Darkness"
	set desc = "You ARE the darkness."
	set category = "Abilities"
	seedarkness = !seedarkness
	plane_holder.set_vis(VIS_FULLBRIGHT, !seedarkness)
	to_chat(src,"You [seedarkness ? "now" : "no longer"] see darkness.")



/mob/living/simple_animal/hostile/statue/restrained()
	. = ..()
	if(can_be_seen(loc))
		return 1


/mob/living/simple_animal/hostile/statue/ListTargets(dist = view_range)
	var/list/L = mobs_in_xray_view(dist, src)

	for(var/obj/mecha/M in mechas_list)
		if ((M.z == src.z) && (get_dist(src, M) <= dist) && (isInSight(src,M)))
			L += M
	if(creator)
		L -= creator

	return L



/obj/item/cursed_marble
	name = "marble slab"
	desc = "A peculiar slab of marble, radiating with dark energy."
	icon = 'icons/obj/stacks.dmi'
	icon_state = "sheet-marble"
	description_info = "Summons the Statue - a mysterious powerful creature, that can move only when unsurveyed by living eyes."
	var/searching = 0

/obj/item/cursed_marble/attack_self(mob/user as mob)
	if(!searching)
		to_chat(user, "<span class='warning'>You rub the slab in hopes a wandering spirit wishes to inhabit it. [src] starts to sparkle!</span>")
		icon_state = "sheet-snowbrick"
		searching = 1
		request_player()
		spawn(60 SECONDS)
			reset_search()


/obj/item/cursed_marble/proc/request_player()
	for(var/mob/observer/dead/O in player_list)
		if(!O.MayRespawn())
			continue
		if(O.client)
			if(O.client.prefs.be_special & BE_ALIEN)
				question(O.client)

/obj/item/cursed_marble/proc/question(var/client/C)
	spawn(0)
		if(!C)
			return
		var/response = alert(C, "Someone is requesting a soul for the statue. Would you like to play as one?", "Statue request", "Yes", "No", "Never for this round")
		if(response == "Yes")
			response = alert(C, "Are you sure you want to play as the statue?", "Statue request", "Yes", "No")
		if(!C || 2 == searching)
			return //handle logouts that happen whilst the alert is waiting for a response, and responses issued after a brain has been located.
		if(response == "Yes")
			transfer_personality(C.mob)
		else if(response == "Never for this round")
			C.prefs.be_special ^= BE_ALIEN

/obj/item/cursed_marble/proc/reset_search() //We give the players sixty seconds to decide, then reset the timer.
	icon_state = "sheet-marble"
	if(searching == 1)
		searching = 0
		var/turf/T = get_turf_or_move(src.loc)
		for (var/mob/M in viewers(T))
			M.show_message("<span class='warning'>[src] fades. Maybe it will spark another time.</span>")

/obj/item/cursed_marble/proc/transfer_personality(var/mob/candidate)
	announce_ghost_joinleave(candidate, 0, "They are a statue now.")
	src.searching = 2
	var/mob/living/simple_animal/hostile/statue/S = new(get_turf(src))
	S.client = candidate.client
	to_chat(S, "<b>You are \a [S], brought into existence on [station_name()] by [usr]! Obey all their orders.</b>")
	S.mind.assigned_role = "The Statue"
	visible_message("<span class='warning'>The slab suddenly takes the shape of a humanoid!</span>")
	qdel(src)


/obj/item/cursed_marble/verb/crush()
	set name = "Crush the marble slab"
	set category = "Object"
	set src in usr
	summonmob(usr)

/obj/item/cursed_marble/proc/summonmob(mob/user as mob)
	if(searching == 0)
		var/choice = alert(user, "Are you sure you want to crush the marble? (this will spawn a clientless version of the statue)", "Crush it?", "Yes", "No")
		if(choice)
			if(choice == "Yes")
				var/mob/living/simple_animal/hostile/statue/S = new /mob/living/simple_animal/hostile/statue(get_turf(user))
				visible_message("<span class='warning'>The slab suddenly takes the shape of a humanoid!</span>")
				S.creator = user
				qdel(src)