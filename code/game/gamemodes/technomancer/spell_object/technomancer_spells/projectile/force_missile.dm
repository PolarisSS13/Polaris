/datum/technomancer_catalog/spell/force_missile
	name = "Force Missile"
	cost = 50
	category = OFFENSIVE_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/force_missile)

/datum/spell_metadata/force_missile
	name = "Force Missile"
	desc = "This fires a missile at your target. It's cheap to use, however the projectile itself moves and impacts in such a way \
	that armor designed to protect from blunt force will mitigate this function as well."
	aspect = ASPECT_FORCE
	icon_state = "tech_force_missile"
	cooldown = 0.25 SECONDS
	spell_path = /obj/item/weapon/spell/technomancer/projectile/force_missile

/obj/item/weapon/spell/technomancer/projectile/force_missile
	name = "force missile"
	icon_state = "force_missile"
	desc = "Make it rain!"
	cast_methods = CAST_RANGED
	spell_projectile = /obj/item/projectile/force_missile
	energy_cost_per_shot = 50
	instability_per_shot = 0.25
	fire_sound = 'sound/weapons/wave.ogg'

/obj/item/projectile/force_missile
	name = "force missile"
	icon_state = "force_missile"
	damage = 15
	damage_type = BRUTE
	check_armour = "melee"

	impact_effect_type = /obj/effect/temp_visual/impact_effect/blue_laser
	hitsound_wall = 'sound/weapons/effects/searwall.ogg'