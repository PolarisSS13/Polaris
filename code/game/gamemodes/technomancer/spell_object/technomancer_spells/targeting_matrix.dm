/datum/technomancer_catalog/spell/targeting_matrix
	name = "Targeting Matrix"
	cost = 50
	category = UTILITY_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/targeting_matrix)

/datum/spell_metadata/targeting_matrix
	name = "Targeting Matrix"
	desc = "Automatically targets and fires a ranged weapon or function at a non-friendly target \
	near a targeted tile. Each target assisted attack costs some energy and instability."
	aspect = ASPECT_FORCE
	icon_state = "tech_targeting_matrix"
	spell_path = /obj/item/weapon/spell/technomancer/targeting_matrix


/datum/spell_metadata/targeting_matrix/get_spell_info()
	var/obj/item/weapon/spell/technomancer/targeting_matrix/spell = spell_path
	. = list()
	.["Target Search Radius"] = initial(spell.hostile_target_search_radius)
	.["Energy Cost"] = initial(spell.assist_energy_cost)
	.["Instability Cost"] = initial(spell.assist_instability_cost)

/obj/item/weapon/spell/technomancer/targeting_matrix
	name = "targeting matrix"
	desc = "Aiming is too much effort for you."
	icon_state = "targeting_matrix"
	cast_methods = CAST_RANGED
	aspect = ASPECT_FORCE
	var/assist_energy_cost = 200
	var/assist_instability_cost = 2
	var/hostile_target_search_radius = 5

/obj/item/weapon/spell/technomancer/targeting_matrix/on_ranged_cast(atom/hit_atom, mob/user)
	var/turf/T = get_turf(hit_atom)
	if(!istype(T))
		return FALSE

	var/mob/living/chosen_target = targeting_assist(T, hostile_target_search_radius) //The person who's about to get attacked.

	if(!chosen_target)
		to_chat(user, span("warning", "The function failed to find a viable target."))
		return FALSE

	var/obj/item/I = user.get_inactive_hand()

	if(!istype(I))
		to_chat(user, span("warning", "You need to hold something in your off-hand for this function to work."))
		return FALSE

	if(istype(I, /obj/item/weapon/spell/technomancer/targeting_matrix)) // Avoid ping-pong between two instances of this spell.
		to_chat(user, span("warning", "Using this function with the same function in your other hand seems dangerously redundant..."))
		return FALSE

	if(!pay_energy(assist_energy_cost))
		to_chat(user, span("warning", "You need more energy in order to assist your arm."))
		return FALSE

	var/prox = user.Adjacent(chosen_target)
	if(prox) // Needed or else they can attack with melee from afar.
		I.attack(chosen_target,owner)
	I.afterattack(chosen_target,owner, prox)
	adjust_instability(assist_instability_cost)

	var/image/target_image = image(icon = 'icons/obj/spells.dmi', loc = get_turf(chosen_target), icon_state = "target")
	user << target_image
	QDEL_IN(target_image, 5)
	return TRUE