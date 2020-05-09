/datum/technomancer_catalog/spell/gambit
	name = "Gambit"
	cost = 100
	category = UTILITY_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/gambit)

/datum/spell_metadata/gambit
	name = "Gambit"
	desc = "This function causes you to receive a random function, including those which you haven't purchased."
	aspect = ASPECT_UNSTABLE
	icon_state = "tech_gambit"
	spell_path = /obj/item/weapon/spell/technomancer/gambit
	cooldown = 30 SECONDS
	exclude_from_gambit = TRUE


/datum/spell_metadata/gambit/get_spell_info()
	var/obj/item/weapon/spell/technomancer/gambit/spell = spell_path
	. = list()
	.["Energy Cost"] = initial(spell.gambit_energy_cost)
	.["Instability Cost"] = initial(spell.gambit_instability_cost)



/obj/item/weapon/spell/technomancer/gambit
	name = "gambit"
	desc = "Do you feel lucky?"
	icon_state = "gambit"
	cast_methods = CAST_INNATE
	delete_after_cast = TRUE
	var/gambit_energy_cost = 200
	var/gambit_instability_cost = 5

/obj/item/weapon/spell/technomancer/gambit/on_innate_cast(mob/living/user)
	if(pay_energy(200))
		adjust_instability(5)
		// TODO: Scepter.
		give_new_spell(random_spell())
		playsound(get_turf(src), 'sound/effects/magic/technomancer/swap.ogg', 75, 1)
		return TRUE
	return FALSE


/obj/item/weapon/spell/technomancer/gambit/proc/give_new_spell(datum/spell_metadata/random_meta)
	dont_qdel_when_dropped = TRUE
	owner.drop_item(src)
	src.forceMove(owner)

	// A lot of spells need to have a metadata datum to work properly.
	// Since this is likely to give spells the user doesn't own (thats the whole point),
	// we need to make those datums as needed.
	var/datum/spell_metadata/existing_meta = core.spell_metas[random_meta.type]
	if(!istype(existing_meta))
		core.spell_metas[random_meta.type] = random_meta
		existing_meta = core.spell_metas[random_meta.type]

	// This code is baaaaaad.
	var/obj/item/weapon/spell/technomancer/spell = owner.place_spell_in_hand(existing_meta.spell_path, existing_meta)
	if(istype(spell) && !QDELETED(spell))
		spell.on_spell_given(owner)

	to_chat(owner, span("notice", "You've been randomly given <b>[random_meta.name]</b>!"))

/obj/item/weapon/spell/technomancer/gambit/proc/random_spell()
	var/list/all_spell_metas = subtypesof(/datum/spell_metadata)
	for(var/meta_type in shuffle(all_spell_metas))
		var/datum/spell_metadata/meta = meta_type
		if(!initial(meta.name))
			continue

		if(initial(meta.exclude_from_gambit))
			continue
		return new meta_type()

/*
// Gives a random spell.
/obj/item/weapon/spell/gambit/proc/random_spell()
	var/list/potential_spells = all_technomancer_gambit_spells.Copy()
	var/rare_spell_chance = between(0, calculate_spell_power(100) - 100, 100) // Having 120% spellpower means a 20% chance to get to roll for rare spells.
	if(prob(rare_spell_chance))
		potential_spells += rare_spells.Copy()
		to_chat(owner, "<span class='notice'>You feel a bit luckier...</span>")
	return pick(potential_spells)
*/

/*
/obj/item/weapon/spell/gambit/on_use_cast(mob/living/carbon/human/user)
	if(pay_energy(200))
		adjust_instability(3)
		if(check_for_scepter())
			give_new_spell(biased_random_spell())
		else
			give_new_spell(random_spell())
		playsound(get_turf(src), 'sound/effects/magic/technomancer/swap.ogg', 75, 1)
		qdel(src)

/obj/item/weapon/spell/gambit/proc/give_new_spell(var/spell_type)
	owner.drop_from_inventory(src, null)
	owner.place_spell_in_hand(spell_type)
*/