/datum/technomancer_catalog/spell/repel_missiles
	name = "Repel Missiles"
	cost = 25
	category = SUPPORT_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/modifier/repel_missiles)

/datum/spell_metadata/modifier/repel_missiles
	name = "Repel Missiles"
	desc = "Places a repulsion field around your target, which attempts to deflect incoming bullets and lasers, making them less likely to hit. \
	How that works on lasers is a question you don't need to worry about." // The answer is game balance.
	icon_state = "tech_repel_missiles"
	aspect = ASPECT_FORCE
	spell_path = /obj/item/weapon/spell/technomancer/modifier/repel_missiles

/datum/spell_metadata/modifier/repel_missiles/get_spell_info()
	var/obj/item/weapon/spell/technomancer/modifier/repel_missiles/spell = spell_path
	var/datum/modifier/repel_missiles/modifier = initial(spell.modifier_type)
	. = list()
	.["Evasion Added"] = "[initial(modifier.evasion)]%"
	. += ..()


/obj/item/weapon/spell/technomancer/modifier/repel_missiles
	name = "repel missiles"
	desc = "Use it before they start shooting at you!"
	icon_state = "generic"
	cast_methods = CAST_RANGED
	modifier_type = /datum/modifier/repel_missiles/technomancer
	modifier_duration = 10 MINUTES
	modifier_energy_cost = 500
	modifier_instability_cost = 5

/datum/modifier/repel_missiles
	name = "Repel Missiles"
	desc = "A repulsion field can always be useful to have."
//	mob_overlay_state = "repel_missiles"

	on_created_text = "<span class='notice'>You have a repulsion field around you, which will attempt to deflect projectiles.</span>"
	on_expired_text = "<span class='warning'>Your repulsion field has expired.</span>"
	evasion = 50
	stacks = MODIFIER_STACK_EXTEND
	filter_parameters = list(type = "outline", size = 1, color = "#99FFFF", flags = OUTLINE_SHARP)

/datum/modifier/repel_missiles/tick()
	animate(filter_instance, size = 3, time = 0.25 SECONDS)
	animate(size = 1, 0.25 SECONDS)

/datum/modifier/repel_missiles/technomancer
	technomancer_dispellable = TRUE