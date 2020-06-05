/datum/technomancer_catalog/spell/lightning
	name = "Lightning Strike"
	cost = 100
	category = OFFENSIVE_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/lightning)

/datum/spell_metadata/lightning
	name = "Lightning Strike"
	desc = "This uses a hidden electrolaser, which creates a laser beam to ionize the enviroment, allowing for ideal conditions \
	for a directed lightning strike to occur. The lightning is very strong, however it requires a few seconds to prepare a \
	strike. Lightning functions cannot miss due to distance."
	aspect = ASPECT_SHOCK
	icon_state = "tech_lightning_strike"
	cooldown = 2 SECONDS
	spell_path = /obj/item/weapon/spell/technomancer/projectile/lightning

/obj/item/weapon/spell/technomancer/projectile/lightning
	name = "lightning strike"
	icon_state = "lightning"
	desc = "Now you can feel like Zeus."
	cast_methods = CAST_RANGED
	spell_projectile = /obj/item/projectile/beam/lightning
	energy_cost_per_shot = 1000
	instability_per_shot = 10
	pre_shot_delay = 1 SECOND
	fire_sound = 'sound/weapons/gauss_shoot.ogg'