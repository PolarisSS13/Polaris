/datum/admin_secret_item/fun_secret/paintbal_mode
	name = "Paintball Mode"

/datum/admin_secret_item/fun_secret/paintbal_mode/execute(var/mob/user)
	. = ..()
	if(!.)
		return

	for(var/species in get_all_species())
		var/datum/species/S = get_species_by_key(species)
		S.blood_color = "rainbow"
	for(var/obj/effect/decal/cleanable/blood/B in world)
		B.basecolor = "rainbow"
		B.update_icon()
