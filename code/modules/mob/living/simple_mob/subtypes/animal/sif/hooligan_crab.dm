/*
	Hooligan Crabs are called so because they are rather curious and tend to follow people,
	whether the people want them to or not, and sometimes causing vandalism by accident.
	They're pretty strong and have strong melee armor, but won't attack first.
	They unknowingly play a role in keeping the shoreline fairly safe, by killing whatever would attack other people.
*/

/mob/living/simple_mob/animal/sif/hooligan_crab
	name = "hooligan crab"
	desc = "A large, hard-shelled crustacean. This one is mostly grey."
	icon_state = "sif_crab"
	icon_living = "sif_crab"
	icon_dead = "sif_crab_dead"
	icon_scale = 1.5

	faction = "crabs"

	maxHealth = 200
	health = 200
	movement_cooldown = 10
	movement_sound = 'sound/weapons/heavysmash.ogg'
	armor = list(
				"melee" = 40,
				"bullet" = 20,
				"laser" = 10,
				"energy" = 0,
				"bomb" = 0,
				"bio" = 0,
				"rad" = 0
				)
	armor_soak = list(
				"melee" = 10,
				"bullet" = 5,
				"laser" = 0,
				"energy" = 0,
				"bomb" = 0,
				"bio" = 0,
				"rad" = 0
				)

	mob_size = MOB_LARGE

	melee_damage_lower = 22
	melee_damage_upper = 35
	attack_armor_pen = 35
	attack_sharp = 1
	attack_edge = 1

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	friendly = "pinches"
	attacktext = list("clawed", "pinched", "crushed")
	speak_emote = list("clicks")

	ai_holder_type = /datum/ai_holder/simple_mob/melee/hooligan
	say_list_type = /datum/say_list/crab

