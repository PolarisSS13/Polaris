/datum/technomancer_catalog/spell/instability_tap
	name = "Instability Tap"
	desc = "Creates a large sum of energy, at the cost of a very large amount of instability afflicting you."
	cost = 50
	category = UTILITY_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/instability_tap)

/datum/spell_metadata/instability_tap
	name = "Instability Tap"
	icon_state = "tech_instability_tap"
	spell_path = /obj/item/weapon/spell/technomancer/instability_tap
	cooldown = 1 SECOND

/datum/spell_metadata/instability_tap/get_spell_info()
	var/obj/item/weapon/spell/technomancer/instability_tap/spell = spell_path
	. = list()
	.["Energy Gained"] = initial(spell.energy_gain)
	.["Instability Gained"] = initial(spell.instability_cost)

/obj/item/weapon/spell/technomancer/instability_tap
	name = "instability tap"
	desc = "Short term gain for long term consequences never end bad, right?"
	cast_methods = CAST_INNATE
	aspect = ASPECT_UNSTABLE
	var/instability_cost = 40
	var/energy_gain = 5000

/obj/item/weapon/spell/technomancer/instability_tap/on_innate_cast(mob/living/user)
	give_energy(energy_gain)
	adjust_instability(instability_cost)
	to_chat(span("notice", "You flood your [core.name] with a surge of instability, \
	granting you a large supply of energy, \
	but also causing a spike of unstable energy to cling to you!"))
	playsound(get_turf(src), 'sound/effects/supermatter.ogg', 75, 1)
	return TRUE