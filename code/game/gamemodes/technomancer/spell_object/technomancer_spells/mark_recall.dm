GLOBAL_DATUM(technomancer_mark, /obj/effect/mark_spell)

/datum/technomancer_catalog/spell/mark_recall
	name = "Mark and Recall"
	desc = "Includes two functions, Mark and Recall."
	cost = 50
	category = UTILITY_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/mark, /datum/spell_metadata/recall)

/datum/spell_metadata/mark
	name = "Mark"
	desc = "This function places a specific 'mark' beacon under you, which is used by the Recall function as a destination. \
	Note that using Mark again will move the destination instead of creating a second destination, and only one destination \
	can exist, regardless of who casted Mark."
	aspect = ASPECT_TELE
	icon_state = "tech_mark"
	spell_path = /obj/item/weapon/spell/technomancer/mark
	cooldown = 1 SECOND

/datum/spell_metadata/mark/get_spell_info()
	var/obj/item/weapon/spell/technomancer/mark/spell = spell_path
	. = list()
	.["Mark Energy Cost"] = initial(spell.mark_energy_cost)
	.["Mark Instability Cost"] = initial(spell.mark_instability_cost)


/obj/item/weapon/spell/technomancer/mark
	name = "mark"
	icon_state = "mark"
	desc = "Marks a specific location to be used by Recall."
	cast_methods = CAST_USE
	var/mark_energy_cost = 500
	var/mark_instability_cost = 5

/obj/item/weapon/spell/technomancer/mark/on_use_cast(mob/living/user)
	var/turf/T = get_turf(user)
	var/datum/teleportation/recall/tele = new(user, T) // Using this to test if teleporting is legal at their position.

	if(!tele.can_tele_to_turf(T))
		to_chat(user, span("warning", "You can't teleport here!"))
		return FALSE

	if(!pay_energy(mark_energy_cost))
		to_chat(user, span("warning", "You can't afford the energy cost!"))
		return FALSE

	if(GLOB.technomancer_mark)
		GLOB.technomancer_mark.forceMove(T)
		to_chat(user, span("notice", "Your Mark is moved from its old position to \the [T] under you."))
	else
		GLOB.technomancer_mark = new /obj/effect/mark_spell(T)
		to_chat(user, span("notice", "You mark \the [T] underneath you. You can teleport back to it with Recall."))

	playsound(owner, 'sound/effects/magic/technomancer/generic_cast.ogg', 75, 1)
	delete_after_cast = TRUE
	adjust_instability(mark_instability_cost)
	return TRUE

//The object to teleport to when Recall is used.
/obj/effect/mark_spell
	name = "mark"
	icon = 'icons/effects/effects.dmi'
	desc = "This is a strange looking disturbance."
	icon_state = "technomancer_mark"
	opacity = FALSE
	density = FALSE
	anchored = TRUE



/datum/spell_metadata/recall
	name = "Recall"
	desc = "This function teleports you to where you or someone else placed a mark using the Mark function. \
	Note that teleporting has a short delay. Being incapacitated while teleporting will cancel it."
	enhancement_desc = "Recall takes less time to teleport."
	aspect = ASPECT_TELE
	icon_state = "tech_recall"
	spell_path = /obj/item/weapon/spell/technomancer/recall
	cooldown = 20 SECONDS

/datum/spell_metadata/recall/get_spell_info()
	var/obj/item/weapon/spell/technomancer/recall/spell = spell_path
	. = list()
	.["Teleport Delay"] = DisplayTimeText(initial(spell.teleport_delay))
	.["Scepter Teleport Delay"] = DisplayTimeText(initial(spell.scepter_teleport_delay))
	.["Teleport Energy Cost"] = initial(spell.teleport_energy_cost)
	.["Teleport Instability Cost"] = initial(spell.teleport_instability_cost)


/obj/item/weapon/spell/technomancer/recall
	name = "recall"
	icon_state = "recall"
	desc = "This will bring you to your Mark."
	cast_methods = CAST_USE
	var/teleport_delay = 3 SECONDS
	var/scepter_teleport_delay = 1.5 SECONDS
	var/teleport_energy_cost = 3000
	var/teleport_instability_cost = 10


/obj/item/weapon/spell/technomancer/recall/on_use_cast(mob/living/user)
	if(!pay_energy(teleport_energy_cost))
		to_chat(user, span("warning", "You can't afford the energy cost!"))
		return FALSE

	if(!GLOB.technomancer_mark)
		to_chat(user, span("warning", "There's no Mark!"))
		return FALSE


	var/delay_to_use = teleport_delay
	if(check_for_scepter())
		delay_to_use = scepter_teleport_delay

	var/datum/teleportation/recall/tele = new(user, get_turf(GLOB.technomancer_mark))
	var/obj/effect/temp_visual/summoning/visual = new(get_turf(user))
	playsound(owner, 'sound/effects/magic/technomancer/generic_cast.ogg', 75, 1)

	if(!do_after(user, delay_to_use, get_turf(user)))
		to_chat(user, span("warning", "You didn't manage to complete the teleportation."))
		qdel(visual)
		return FALSE

	if(!tele.teleport())
		to_chat(user, span("warning", "Something is interfering with the teleportation."))
		return FALSE

	// At this point, the teleport happened.
	delete_after_cast = TRUE
	adjust_instability(teleport_instability_cost)
	qdel(visual)
	return TRUE
