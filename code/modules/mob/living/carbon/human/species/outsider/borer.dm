// Wrapper datum for creating a borer'd monkey on roundstart (or via set_species())
/datum/species/monkey/borer

	name = "Cortical Borer"
	name_plural = "Cortical Borers"

	default_language = "Galactic Common"
	language = "Galactic Common"
	num_alternate_languages = 2
	secondary_langs = list("Sol Common")
	name_language = null

	blurb = "Cortical borers are a strange symbiotic lifeform that burrows into a host brain and merges with \
		the nervous system, either guiding the host through subtle hints or seizing direct control. Neutered \
		cortical borers are occasionally used with cloned monkey hosts to provide a cheap labour source for \
		corporate stations without the ethical concerns of using human or alien workers."

	spawn_flags = CAN_JOIN | IS_WHITELISTED

/datum/species/monkey/borer/handle_post_spawn(var/mob/living/carbon/human/H)

	..()

	if(!istype(H))
		return

	// This is needed to prevent 'This is X, Cortical Borer'.
	H.set_species("Monkey")

	sleep(-1)

	var/obj/item/organ/external/head = H.get_organ(BP_HEAD)
	var/mob/living/simple_animal/borer/borer = new(H)
	borer.neutered = 1
	borer.host = H
	borer.host.status_flags |= PASSEMOTES
	head.implants += borer

	if(!borer.host_brain)
		borer.host_brain = new(borer)
	borer.host_brain.name = borer.host.name
	borer.host_brain.real_name = borer.host.real_name
	borer.controlling = 1

	H.add_language("Cortical Link")
	H.add_language("Galactic Common")

	H.verbs += /mob/living/carbon/proc/release_control
