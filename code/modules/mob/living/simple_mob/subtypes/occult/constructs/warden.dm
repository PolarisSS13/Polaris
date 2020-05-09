// Warden, a usually-AI-controlled sentinel from the other-realms. Kind of a ranged juggernaut.

/mob/living/simple_mob/construct/warden
	name = "Warden"
	real_name = "Warden"
	construct_type = "warden"
	desc = "A living statue animated by the will of the tireless dead."
	icon_state = "tg_harvester"
	icon_living = "tg_harvester"
	maxHealth = 250
	health = 250
	response_harm   = "harmlessly punches"
	harm_intent_damage = 0
	melee_damage_lower = 20
	melee_damage_upper = 30
	attack_armor_pen = 50
	attacktext = list("smashed their scythe-like gauntlet into")
	friendly = list("pats")
	mob_size = MOB_HUGE

	movement_cooldown = 3

	attack_sound = 'sound/weapons/heavysmash.ogg'
	status_flags = 0
	resistance = 10
	construct_spells = list(/spell/targeted/fortify,
							/spell/targeted/construct_advanced/inversion_beam,
							/spell/targeted/construct_advanced/slam
							)

	armor = list(
				"melee" = 50,
				"bullet" = 20,
				"laser" = 20,
				"energy" = 10,
				"bomb" = 10,
				"bio" = 100,
				"rad" = 100)

/mob/living/simple_mob/construct/warden/npc
	ai_holder_type = /datum/ai_holder/simple_mob/intentional/adv_dark_gygax	// Charges, doing ranged until melee. Seems perfect.
	projectiletype = /obj/item/projectile/beam/inversion
	projectilesound = 'sound/weapons/spiderlunge.ogg'
