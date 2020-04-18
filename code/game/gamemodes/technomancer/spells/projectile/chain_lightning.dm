/datum/technomancer/spell/chain_lightning
	name = "Chain Lightning"
	desc = "This dangerous function shoots lightning that will strike someone, then bounce to a nearby person.  Be careful that \
	it does not bounce to you.  The lighting prefers to bounce to people with the least resistance to electricity.  It will \
	strike up to four targets, including yourself if conditions allow it to occur.  Lightning functions cannot miss due to distance."
	cost = 150
	obj_path = /obj/item/weapon/spell/projectile/chain_lightning
	ability_icon_state = "tech_chain_lightning"
	category = OFFENSIVE_SPELLS

/obj/item/weapon/spell/projectile/chain_lightning
	name = "chain lightning"
	icon_state = "chain_lightning"
	desc = "Fun for the whole security team!  Just don't kill yourself in the process.."
	cast_methods = CAST_RANGED
	aspect = ASPECT_SHOCK
	spell_projectile = /obj/item/projectile/beam/chain_lightning
	energy_cost_per_shot = 3000
	instability_per_shot = 10
	cooldown = 20
	fire_sound = 'sound/weapons/gauss_shoot.ogg'
