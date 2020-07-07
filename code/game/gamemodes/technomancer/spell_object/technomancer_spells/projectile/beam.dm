/datum/technomancer_catalog/spell/beam
	name = "Beam"
	cost = 50
	category = OFFENSIVE_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/projectile/beam)

/datum/spell_metadata/projectile/beam
	name = "Beam"
	desc = "Fires a laser at your target. Cheap, reliable, and a bit boring."
	aspect = ASPECT_LIGHT
	icon_state = "tech_beam"
	cooldown = 0.8 SECONDS
	spell_path = /obj/item/weapon/spell/technomancer/projectile/beam

/obj/item/weapon/spell/technomancer/projectile/beam
	name = "beam"
	icon_state = "beam"
	desc = "Boring, but practical."
	cast_methods = CAST_RANGED
	spell_projectile = /obj/item/projectile/beam/blue
	energy_cost_per_shot = 250
	instability_per_shot = 1
	fire_sound = 'sound/weapons/Laser.ogg'
