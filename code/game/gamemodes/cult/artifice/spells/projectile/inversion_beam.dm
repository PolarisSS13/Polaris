
/datum/cultist/spell/inversionbeam
	name = "Inversion Beam"
	desc = "Fires an un-light beam at your target."
	cost = 100
	ability_icon_state = "const_beam"
	obj_path = /obj/item/weapon/spell/construct/projectile/inverted_beam
	category = CULT_OFFENSIVE_SPELLS

//Harvester Laser.

/obj/item/weapon/spell/construct/projectile/inverted_beam
	name = "inversion beam"
	icon_state = "generic"
	desc = "Your manipulators fire searing beams of inverted light."
	cast_methods = CAST_RANGED
	spell_projectile = /obj/item/projectile/beam/inversion
	pre_shot_delay = 0
	cooldown = 5
	fire_sound = 'sound/weapons/spiderlunge.ogg'

/obj/item/projectile/beam/inversion
	name = "inversion beam"
	icon_state = "invert"
	fire_sound = 'sound/weapons/spiderlunge.ogg'
	damage = 15
	damage_type = BURN
	check_armour = "laser"
	armor_penetration = 60
	light_range = 2
	light_power = -2
	light_color = "#FFFFFF"

	muzzle_type = /obj/effect/projectile/muzzle/inversion
	tracer_type = /obj/effect/projectile/tracer/inversion
	impact_type = /obj/effect/projectile/impact/inversion
