/datum/technomancer/spell/lightning
	name = "Lightning Strike"
	desc = "This uses a hidden electrolaser, which creates a laser beam to ionize the enviroment, allowing for ideal conditions \
	for a directed lightning strike to occur.  The lightning is very strong, however it requires a few seconds to prepare a \
	strike.  Lightning functions cannot miss due to distance."
	cost = 150
	obj_path = /obj/item/weapon/spell/projectile/lightning
	category = OFFENSIVE_SPELLS

/obj/item/weapon/spell/projectile/lightning
	name = "lightning strike"
	icon_state = "lightning_strike"
	desc = "Now you can feel like Zeus."
	cast_methods = CAST_RANGED
	aspect = ASPECT_SHOCK
	spell_projectile = /obj/item/projectile/beam/lightning
	energy_cost_per_shot = 2500
	instability_per_shot = 10
	cooldown = 20
	pre_shot_delay = 10
	fire_sound = 'sound/weapons/gauss_shoot.ogg'
