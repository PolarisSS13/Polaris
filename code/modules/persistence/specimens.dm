// Device used to implant, remove or read specimen tags.

/* Notes on specimen tagger and expected flow:
 * - Xenofauna player uses tagger (/obj/item/specimen_tagger) on appropriate critter (appropriate type, has cataloguer info).
 * - Tag (/obj/item/gps/specimen_tag) is created and registered in the critter.
 * - Xenofauna players can then track the tag via GPS to scan, remove, etc.
 * - When persistent specimens are committed, tags will be loaded and assigned to mobs at world init.
 */

/obj/item/specimen_tagger
	name = "specimen tagger"
	desc = "A handheld device used to implant, remove and read xenofauna tracking tags from local specimens. Not for use on crewmembers."
	icon = 'icons/obj/specimen_tagger.dmi'
	icon_state = "tagger"
	force = 0
	item_flags = NOBLUDGEON
	var/tag_id = "FAUNA0"
	var/static/list/unsuitable_tag_types = list(
		// Do not specimen tag your crewmates
		/mob/living/carbon,
		/mob/living/simple_mob/animal/sif/grafadreka/trained,
		// Do not specimen tag pre-mapped critters
		/mob/living/simple_mob/animal/passive/opossum/poppy,
		/mob/living/simple_mob/animal/passive/dog/corgi/Ian,
		/mob/living/simple_mob/animal/passive/cat/runtime
	)

/obj/item/specimen_tagger/attack_self(mob/user)
	var/new_tag = input("Please enter desired tag.", name, tag_id) as text
	if(QDELETED(src) || QDELETED(user) || user.incapacitated() || loc != user)
		return TRUE
	new_tag = uppertext(copytext(sanitize(new_tag), 1, 11))
	if(!length(new_tag))
		return TRUE
	tag_id = new_tag
	to_chat(usr, "You set the tracker tag to '[tag_id]'.")
	return TRUE

/obj/item/specimen_tagger/examine(mob/user)
	. = ..()
	. += "Use this on a living animal on help intent to read an existing tracker, grab intent to tag an animal with a tracker, and any other intent to remove an existing tracker."

/obj/item/specimen_tagger/attack(mob/living/M, mob/living/user, target_zone, attack_modifier)
	switch(user.a_intent)
		if(I_HELP)
			try_read_tag(user, M)
		if(I_GRAB)
			try_implant_tag(user, M)
		else
			try_remove_tag(user, M)
	return TRUE

/obj/item/specimen_tagger/proc/try_read_tag(var/mob/user, var/mob/living/target)
	var/obj/item/gps/specimen_tag/xenotag = locate() in target
	if(!istype(xenotag) || !xenotag.has_been_implanted())
		to_chat(user, SPAN_WARNING("\The [target] has not been tagged."))
		return FALSE
	to_chat(user, "<b>Specimen data for [xenotag.gps_tag]:</b>")
	to_chat(user, "<b>Species:</b> [target.real_name]")
	to_chat(user, "<b>Tag duration:</b> [xenotag.age] shift\s")
	to_chat(user, "<b>Tagged by:</b> [xenotag.implanted_by]")
	to_chat(user, "<b>Physical notes:</b> [xenotag.physical_info]")
	to_chat(user, "<b>Behavioral notes:</b> [xenotag.behavioral_info]")
	return TRUE

/obj/item/specimen_tagger/proc/check_can_tag(var/mob/user, var/mob/living/target)
	if(QDELETED(target) || !istype(target) || target.stat == DEAD || target.isSynthetic())
		to_chat(user, SPAN_WARNING("Xenofauna specimens need to be living organic creatures."))
		return FALSE
	if(!LAZYLEN(target.get_catalogue_data()))
		to_chat(user, SPAN_WARNING("There's no scientific reason to tag \the [target]."))
		return FALSE
	if(target.key || target.client || is_type_in_list(target, unsuitable_tag_types))
		to_chat(user, SPAN_WARNING("\The [target] is not suitable for tagging."))
		return FALSE
	var/obj/item/gps/specimen_tag/xenotag = locate(/obj/item/gps/specimen_tag) in target
	if(istype(xenotag) && xenotag.has_been_implanted())
		to_chat(user, SPAN_WARNING("\The [target] has already been tagged."))
		return FALSE
	return TRUE

/obj/item/specimen_tagger/proc/try_implant_tag(var/mob/user, var/mob/living/target)
	if(!check_can_tag(user, target))
		return FALSE
	user.visible_message(SPAN_NOTICE("\The [user] begins tagging \the [target] with \the [src]..."))
	if(!do_after(user, 3 SECONDS, target) || !check_can_tag(user, target))
		return FALSE
	var/obj/item/gps/specimen_tag/xenotag = new
	xenotag.SetTag(tag_id)
	xenotag.implanted_by = user.real_name
	if(user.mind)
		var/user_title = user.mind.assigned_role || user.mind.role_alt_title
		if(user_title)
			xenotag.implanted_by = "[xenotag.implanted_by], [user_title]"

	xenotag.implant(target)
	user.visible_message(SPAN_NOTICE("\The [user] tags \the [target] with \a [xenotag]!"))
	return TRUE

/obj/item/specimen_tagger/proc/can_remove_tag(var/mob/user, var/mob/living/target)
	if(!istype(target))
		to_chat(user, SPAN_WARNING("\The [target] is not a xenofauna specimen."))
		return FALSE
	var/obj/item/gps/specimen_tag/xenotag = locate() in target
	if(!istype(xenotag) || !xenotag.has_been_implanted())
		to_chat(user, SPAN_WARNING("\The [target] has not been tagged."))
		return FALSE
	return TRUE

/obj/item/specimen_tagger/proc/try_remove_tag(var/mob/user, var/mob/living/target)
	if(!can_remove_tag(user, target))
		return FALSE
	var/obj/item/gps/specimen_tag/xenotag = locate() in target
	if(!istype(xenotag))
		return FALSE
	user.visible_message(SPAN_NOTICE("\The [user] starts removing \the [xenotag] from \the [target] with \the [src]..."))
	if(!do_after(user, 3 SECONDS, target) || !can_remove_tag(user, target))
		return FALSE
	if(!istype(xenotag))
		return FALSE
	qdel(xenotag)
	user.visible_message(SPAN_NOTICE("\The [user] removes \the [xenotag] from \the [target]!"))
	return TRUE

// Specimen tag itself.
/obj/item/gps/specimen_tag
	name = "xenofauna tracker"
	gps_tag = "FAUNA0"
	icon = 'icons/obj/specimen_tag.dmi'
	icon_state = "gps-tag"
	w_class = ITEMSIZE_TINY
	tag_category = "XENOFAUNA"

	var/age = 0
	var/mob/living/implanted_in
	var/implanted_by
	var/physical_info = "No notes recorded."
	var/behavioral_info = "No notes recorded."

/obj/item/gps/specimen_tag/Initialize(mapload, _age, _implanted_by, _specimen_id, _specimen_gender, _physical_info, _behavioral_info, _specimen_type)
	// If we have a specimen, set up our data.
	if(_specimen_type)
		var/mob/living/critter = new _specimen_type(get_turf(src))
		implant(critter, TRUE)
		if(_specimen_gender)
			critter.gender = _specimen_gender
		if(_age)
			age = _age
		if(_specimen_id)
			gps_tag = _specimen_id
		if(_physical_info)
			physical_info = _physical_info
		if(_behavioral_info)
			behavioral_info = _behavioral_info
		if(_implanted_by)
			implanted_by = _implanted_by
	. = ..()
	if(!tracking)
		toggletracking()

/obj/item/gps/specimen_tag/Destroy()
	clear_implanted()
	// TODO: persistent tags
	// SSpersistence.forget_value(src, /datum/persistent/specimen)
	. = ..()

/obj/item/gps/specimen_tag/Move()
	. = ..()
	if(implanted_in && loc != implanted_in)
		clear_implanted()

// Specimen tags are just for tracking, they don't work as held GPS.
/obj/item/gps/specimen_tag/attack_hand(mob/living/user)
	toggletracking(user)
	return TRUE
/obj/item/gps/specimen_tag/check_visible_to_holder()
	return FALSE
/obj/item/gps/specimen_tag/create_compass()
	return
/obj/item/gps/specimen_tag/display_list()
	return list()

/obj/item/gps/specimen_tag/proc/has_been_implanted()
	return !QDELETED(implanted_in) && istype(implanted_in) && loc == implanted_in

/obj/item/gps/specimen_tag/proc/implant(var/mob/target, var/implanted_in_init = FALSE)
	forceMove(target)
	implanted_in = target
	GLOB.destroyed_event.register(implanted_in, src, /obj/item/gps/specimen_tag/proc/clear_implanted)
	// TODO: persistent tags
	// SSpersistence.track_value(src, /datum/persistent/specimen)
	if(!implanted_in_init)
		generate_critter_info()

/obj/item/gps/specimen_tag/proc/generate_critter_info()

	var/list/possible_physical_info
	var/list/possible_behavioral_info
	var/list/catalogue_data = implanted_in.get_catalogue_data()
	for(var/catalogue_data_type in catalogue_data)
		if(ispath(catalogue_data_type, /datum/category_item/catalogue/fauna))
			var/datum/category_item/catalogue/fauna/fauna_data = GLOB.catalogue_data.resolve_item(catalogue_data_type)
			var/notes = fauna_data.get_fauna_physical_notes()
			if(!isnull(notes))
				LAZYDISTINCTADD(possible_physical_info, notes)
			notes = fauna_data.get_fauna_behavior_notes()
			if(!isnull(notes))
				LAZYDISTINCTADD(possible_behavioral_info, notes)

	if(LAZYLEN(possible_physical_info))
		physical_info = pick(possible_physical_info)
	else
		physical_info = "No notes recorded."

	if(LAZYLEN(possible_behavioral_info))
		behavioral_info = pick(possible_behavioral_info)
	else
		behavioral_info = "No notes recorded."

/obj/item/gps/specimen_tag/proc/clear_implanted()
	if(implanted_in)
		GLOB.destroyed_event.unregister(implanted_in, src)
		implanted_in = null

/obj/item/gps/specimen_tag/proc/update_from_animal()
	return

// Mob helpers/overrides.
/mob/living/examine(mob/user, infix, suffix)
	. = ..()
	var/obj/item/gps/specimen_tag/xenotag = locate() in src
	if(istype(xenotag) && xenotag.has_been_implanted())
		. += "\The [src] has been tagged with \a [xenotag]."

// Lists of strings used by the specimen tracking system to add flavour to
// specimens. Static lists in procs to allow overriding while also not putting
// a massive string list on every single cataloguer fauna entry.
/datum/category_item/catalogue/fauna/proc/get_fauna_physical_notes()
	var/static/list/fauna_physical_notes = list(
		"Perpetually smells like mold no matter what we do about it.",
		"Perpetually smells like mildew no matter what we do about it.",
		"Perpetually smells like sifsap no matter what we do about it.",
		"Seems to always have an itch in the spot it can't reach.",
		"Vocalizations are notably harsh and loud for the species.",
		"Vocalizations are notably soft and quiet for the species.",
		"Has a notch in its left ear.",
		"Has a notch in its right ear.",
		"Is missing its left ear.",
		"Is missing its right ear.",
		"Is missing its left eye.",
		"Is missing its right eye.",
		"Has had the very tip of its tail chewed off.",
		"Might have trouble with its hearing.",
		"Is more scar tissue than animal at this point.",
		"Walks with a limp.",
		"Has two differently colored eyes.",
		"Might have a cold...",
		"Is allergic to nuts.",
		"Is allergic to berries.",
		"Is allergic to dairy."
	)
	return fauna_physical_notes

/datum/category_item/catalogue/fauna/proc/get_fauna_behavior_notes()
	var/static/list/fauna_behavior_notes = list(
		"Likes rolling around in the moss with reckless abandon.",
		"Enjoys munching on frostbelles the most, as a treat.",
		"Enjoys munching on wabback the most, as a treat.",
		"Enjoys munching on eyebulbs the most, as a treat.",
		"Constantly sniffs around at everything new.",
		"Seems super friendly! Probably won't bite. Probably.",
		"Seems rather stand-offish. Mind the personal bubble.",
		"Loves a good back scritch.",
		"Loves a good head scritch.",
		"Loves a good behind the ear scritch.",
		"Seems to hate the world and everything in it.",
		"Just tolerates being pet, but certainly doesn't enjoy it.",
		"Often sticks its head into snowbanks to contemplate the state of things.",
		"Enjoys singing along to songs only it can hear. Mostly just sounds like an animal wailing.",
		"Would rather be fishing.",
		"Partakes in many siestas.",
		"Struggles with object permanence.",
		"Is very picky about food; maybe it's a texture thing.",
		"Is a sentient garbage disposal for anything even remotely edible.",
		"Loves swimming and splashing around in water.",
		"Sinks like a rock the moment it enters water.",
		"Gets lost easily.",
		"Enjoys soft things. It'd have a bed of plushies if it knew what a bed was.",
		"Never seems to be in a rush to go anywhere...",
		"Has gotta go fast at all times."
	)
	return fauna_behavior_notes
