/datum/technomancer_catalog/spell/track
	name = "Track"
	cost = 25
	category = UTILITY_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/track)

/datum/spell_metadata/track
	name = "Track"
	desc = "Acts as directional guidance towards an object that belongs to you or your team. \
	It can also point towards your allies. Wonderful if you're worried someone will steal your valuables, like a certain shiny Scepter..."
	enhancement_desc = "You will be able to track most other entities in addition to your belongings and allies."
	aspect = ASPECT_TELE // Don't know where else to put this.
	icon_state = "tech_track"
	spell_path = /obj/item/weapon/spell/technomancer/track
	var/weakref/tracked = null


/obj/item/weapon/spell/technomancer/track
	name = "track"
	desc = "Never lose your stuff again!"
	icon_state = "track"
	cast_methods = CAST_USE
	var/tracking = FALSE // Used for icons and processing.
	var/track_update_frequency = 0.5 SECONDS // How often the spell locates the thing being tracked. Raise this if it makes lag.

/obj/item/weapon/spell/technomancer/track/on_spell_given(mob/user)
	var/datum/spell_metadata/track/track_meta = meta
	if(track_meta.tracked?.resolve())
		tracking = TRUE
		do_track() // If they selected something before, the spell will immediately re-track it.

/obj/item/weapon/spell/technomancer/track/Destroy()
	tracking = FALSE
	return ..()

/obj/item/weapon/spell/technomancer/track/on_use_cast(mob/living/user)
	var/datum/spell_metadata/track/track_meta = meta
	var/atom/movable/AM = track_meta.tracked?.resolve()

	if(tracking)
		tracking = FALSE
		if(AM)
			to_chat(user, span("notice", "You stop tracking for \the [AM]'s whereabouts."))
		else
			to_chat(user, span("notice", "You stop trying to track something that no longer exists."))
		track_meta.tracked = null
		playsound(user, 'sound/effects/magic/technomancer/generic_cast.ogg', 75, 1)
		return TRUE

	var/can_track_non_allies = FALSE
	if(check_for_scepter())
		can_track_non_allies = TRUE

	var/list/object_choices = GLOB.technomancer_belongings.Copy()
	var/list/mob_choices = list()
	for(var/mob/living/L in mob_list)
		if(L == user) // Tracking ourselves would be pointless.
			continue
		if(!is_technomancer_ally(L) && !can_track_non_allies)
			continue
		if(!(L.z in using_map.player_levels)) // Don't show people on admin z-levels and such.
			continue
		mob_choices += L

	var/choice = input(user, "Decide what or who to track.", "Tracking") as null|anything in object_choices + mob_choices
	if(!choice)
		to_chat(user, span("warning", "You appear to have not picked anything. Suit yourself."))
		return FALSE

	track_meta.tracked = weakref(choice)
	tracking = TRUE
	playsound(user, 'sound/effects/magic/technomancer/generic_cast.ogg', 75, 1)
	do_track()
	return TRUE

/obj/item/weapon/spell/technomancer/track/proc/do_track()
	update_icon()
	if(tracking)
		addtimer(CALLBACK(src, .proc/do_track), track_update_frequency)

/obj/item/weapon/spell/technomancer/track/update_icon()
	var/datum/spell_metadata/track/track_meta = meta
	var/atom/movable/AM = track_meta.tracked?.resolve()

	if(!tracking)
		icon_state = "track"
		return ..()

	if(!AM) // It stopped existing for some reason.
		icon_state = "track_unknown"
		return ..()

	if(AM.z != owner.z)
		icon_state = "track_unknown"
		return ..()

	// Point to them.
	set_dir(get_dir(src, AM))

	// Show distance.
	switch(get_dist(src, AM))
		if(0)
			icon_state = "track_direct"
		if(1 to 8)
			icon_state = "track_close"
		if(9 to 16)
			icon_state = "track_medium"
		if(16 to INFINITY)
			icon_state = "track_far"

	return ..()
