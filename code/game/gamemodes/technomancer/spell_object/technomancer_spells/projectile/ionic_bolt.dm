/datum/technomancer_catalog/spell/ionic_bolt
	name = "Ionic Bolt"
	cost = 50
	category = OFFENSIVE_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/projectile/ionic_bolt)

/datum/spell_metadata/projectile/ionic_bolt
	name = "Ionic Bolt"
	desc = "Shoots a bolt of ion energy at the target.  If it hits something, it will generally drain energy, \
	corrupt electronics, or otherwise ruin complex machinery. Be sure to not hit yourself if you're one of those things."
	aspect = ASPECT_SHOCK
	icon_state = "tech_ionic_bolt"
	cooldown = 1 SECOND
	spell_path = /obj/item/weapon/spell/technomancer/projectile/ionic_bolt

/obj/item/weapon/spell/technomancer/projectile/ionic_bolt
	name = "ionic bolt"
	icon_state = "ionic_bolt"
	desc = "For those pesky security units."
	cast_methods = CAST_RANGED
	spell_projectile = /obj/item/projectile/ion
	energy_cost_per_shot = 500
	instability_per_shot = 6
	fire_sound = 'sound/weapons/Laser.ogg'