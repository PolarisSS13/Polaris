GLOBAL_VAR_INIT(banish_counter, 0)
GLOBAL_LIST_EMPTY(all_banish_landmarks)

/datum/technomancer_catalog/spell/banish
	name = "Banish"
	desc = "Sends a targeted entity somewhere very far away, where there is no light, no sound, no anything (except air). \
	They will be returned in five seconds at the same position they were in before, with no physical harm done, and \
	a very minimal amount of mental harm, if they were not prepared for it by virtue of being a Technomancer. \
	All entities who get banished will be unable to be banished again for two minutes."
	enhancement_desc = "Banished entities will be banished for ten seconds, instead of five."
	cost = 50
	category = DEFENSIVE_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/banish)

/datum/spell_metadata/banish
	name = "Banish"
	icon_state = "tech_banish"
	spell_path = /obj/item/weapon/spell/technomancer/banish



/obj/item/weapon/spell/technomancer/banish
	name = "banish"
	desc = "Bye bye... for a few seconds"
	icon_state = "banish"
	cast_methods = CAST_RANGED
	aspect = ASPECT_TELE
	var/banish_duration = 5 SECONDS

/obj/item/weapon/spell/technomancer/banish/on_ranged_cast(atom/hit_atom, mob/user)
	if(isliving(hit_atom) && within_range(hit_atom) && pay_energy(500))
		var/mob/living/L = hit_atom
		if(!allowed_to_teleport(L))
			to_chat(user, span("warning", "Something is preventing \the [L] from being teleported."))
			return FALSE
		if(L.has_modifier_of_type(/datum/modifier/recently_banished))
			to_chat(user, span("warning", "\The [L] can't be banished again for a period of time."))
			return FALSE
		playsound(user, 'sound/effects/magic/technomancer/teleport.ogg', 75, 1)
		banish_mob(L)
		adjust_instability(5)
		return TRUE
	return FALSE

/obj/item/weapon/spell/technomancer/banish/proc/banish_mob(mob/living/L)
	if(!L.mind || !technomancers.is_antagonist(L.mind))
		L.adjustBrainLoss(3) // This is very unlikely to kill someone due to the 2 minute cooldown.

	var/obj/effect/banish_return/return_point = new(get_turf(L))

	var/landmark_index = (GLOB.banish_counter++ % GLOB.all_banish_landmarks.len) + 1
	var/obj/effect/landmark/banish_target/target = GLOB.all_banish_landmarks[landmark_index]
	if(!target)
		return

	var/datum/teleportation/banish_out/tele = new(L, target.loc)
	if(tele.teleport())
		log_and_message_admins("banished [L] to a dark place for a short period of time.")
		to_chat(L, span("danger", "You've been teleported to an empty black void!"))

		var/duration = banish_duration
		if(check_for_scepter())
			duration = 10 SECONDS

		addtimer(CALLBACK(return_point, /obj/effect/banish_return/proc/return_mob, L), duration)


/obj/effect/banish_return
	invisibility = 99

// This is on the effect because the spell might not exist by the time it's time to bring them back.
/obj/effect/banish_return/proc/return_mob(mob/living/L)
	if(!L)
		qdel(src)
		return

	var/turf/T = get_turf(src)
	var/datum/teleportation/banish_in/tele = new(L, T)
	tele.teleport()

	to_chat(L, span("danger", "You've been teleported back to \the [T.loc]."))
	L.add_modifier(/datum/modifier/recently_banished, 2 MINUTES)
	qdel(src) // Our job is done.


// Mobs who get banished are taken to one of these.
// Note that the one the mob is sent to alternates based on an incrementing GLOB var.
/obj/effect/landmark/banish_target

/obj/effect/landmark/banish_target/Initialize()
	GLOB.all_banish_landmarks += src
	return ..()

// Acts as a cooldown to getting banished again.
// It's not a /technomancer subtype to avoid Dispel from removing it and resulting in chain banishes.
/datum/modifier/recently_banished
	name = "recently banished"
	desc = "You were recently sent to a very dark and spooky place."
