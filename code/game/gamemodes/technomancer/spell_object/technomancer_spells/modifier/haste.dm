/datum/technomancer_catalog/spell/haste
	name = "Haste"
	cost = 100
	category = SUPPORT_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/modifier/haste)


/datum/spell_metadata/modifier/haste
	name = "Haste"
	desc = "Allows the target to run at speeds that should not be possible for an ordinary being. \
	For five seconds, the target runs extremly fast, and cannot be slowed by any means."
	icon_state = "tech_haste"
	aspect = ASPECT_FORCE
	spell_path = /obj/item/weapon/spell/technomancer/modifier/haste


/obj/item/weapon/spell/technomancer/modifier/haste
	name = "haste"
	desc = "Now you can outrun a Teshari!"
	icon_state = "haste"
	cast_methods = CAST_RANGED
	modifier_type = /datum/modifier/haste/technomancer
	modifier_duration = 5 SECONDS
	modifier_energy_cost = 2000
	modifier_instability_cost = 20
	delete_after_cast = TRUE

/datum/modifier/haste/technomancer
	technomancer_dispellable = TRUE