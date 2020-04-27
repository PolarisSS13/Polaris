GLOBAL_DATUM(technomancer_mark, /obj/effect/mark_spell)

/datum/technomancer_catalog/spell/mark_recall
	name = "Mark and Recall"
	desc = "Includes two functions, Mark and Recall. Mark will create a special beacon underneath you, while \
	Recall will teleport you to it. Note that using Mark again will move the beacon, instead of creating a second one, \
	and only one beacon can exist, regardless of who casted Mark."
	cost = 50
	category = UTILITY_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/mark, /datum/spell_metadata/recall)

/datum/spell_metadata/mark
	name = "Mark"
	icon_state = "tech_mark"
	spell_path = /obj/item/weapon/spell/technomancer/mark
	cooldown = 1 SECOND

/datum/spell_metadata/recall
	name = "Recall"
	icon_state = "tech_recall"
	spell_path = /obj/item/weapon/spell/technomancer/recall
	cooldown = 20 SECONDS
/*
/datum/spell_metadata/recall/get_spell_info()
	var/obj/item/weapon/spell/technomancer/recall = spell_path
	. = list()
	.["Teleport Delay"] = initial(spell.teleport_delay)
*/

/obj/item/weapon/spell/technomancer/mark
	name = "mark"
	icon_state = "mark"
	desc = "Marks a specific location to be used by Recall."
	cast_methods = CAST_USE
	aspect = ASPECT_TELE
	var/mark_energy_cost = 1000
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
	adjust_instability(mark_instability_cost)
	return TRUE

//The object to teleport to when Recall is used.
/obj/effect/mark_spell
	name = "mark"
	desc = "This is a strange looking disturbance."
	icon_state = "technomancer_mark"
	opacity = FALSE
	density = FALSE
	anchored = TRUE

/obj/item/weapon/spell/technomancer/recall
	name = "recall"
	icon_state = "recall"
	desc = "This will bring you to your Mark."
	cast_methods = CAST_USE
	aspect = ASPECT_TELE