////////////////////////////////
//      Android Simplemob AI
////////////////////////////////

/datum/ai_holder/simple_mob/humanoid/android
	hostile = TRUE //enemy!
	can_breakthrough = FALSE //does not break down doors
	can_flee = TRUE
	outmatched_threshold = 250 //25% higher threshold than usual - so it doesn't run from solo players
	threaten_delay = 15 SECONDS
	call_distance = 3

/datum/ai_holder/simple_mob/humanoid/android/violent
	can_flee = FALSE
	call_distance = 6 //higher communication distance
	can_breakthrough = TRUE //Can break through doors
	var/run_if_this_close = 4 //will be aggressive

/mob/living/simple_mob/humanoid/android/isSynthetic()
	return TRUE

/mob/living/simple_mob/humanoid/android
	name = "android drone"
	desc = "A humanoid robot - a marking on the side of its head denotes its status as a C-class drone."
	icon_state = "syndicateranged"
	icon_living = "syndicateranged"
	corpse = /obj/effect/landmark/mobcorpse/android
	say_list_type = /datum/say_list/hivebot
	ai_holder_type = /datum/ai_holder/simple_mob/humanoid/android
	faction = "drone"

	mob_class = MOB_CLASS_SYNTHETIC
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	armor = list(melee = 10, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 100, rad = 100) //slightly tougher in melee but otherwise just basic resistances that make sense
	taser_kill = FALSE
	poison_resist = 1.0
	shock_resist = -0.5


/mob/living/simple_mob/humanoid/android/combat
	name = "combat unit"
	desc = "An autonomous humanoid robot that was evidently built for combat."
	icon_state = "syndicateranged"
	icon_living = "syndicateranged"
	ai_holder_type = /datum/ai_holder/simple_mob/humanoid/android/violent
	corpse = /obj/effect/landmark/mobcorpse/android/combat
	armor = list(melee = 30, bullet = 20, laser = 20, energy = 10, bomb = 10, bio = 100, rad = 100)

	projectiletype = /obj/item/projectile/beam/midlaser
	projectilesound = 'sound/weapons/Laser.ogg'
	loot_list = list(/obj/item/gun/energy/laser = 100)

	projectile_dispersion = 5
	projectile_accuracy = -20
	reload_max = 10
	needs_reload = TRUE
	reload_time = 4 SECONDS


/mob/living/simple_mob/humanoid/android/scientist
	name = "scientific drone"
	desc = "A humanoid drone outfitted to perform some kind of scientific experiments."
	icon_state = "syndicateranged"
	icon_living = "syndicateranged"
	corpse = /obj/effect/landmark/mobcorpse/android/scientist
	say_list_type = /datum/say_list/android_scientist

	projectiletype = /obj/item/projectile/bullet/pistol //a bit less damage than usual mercs
	loot_list = list(/obj/item/gun/projectile/p92x = 90, /datum/category_item/autolathe/arms/pistol_9mm = 40)
	projectile_dispersion = 6
	projectile_accuracy = -30
	needs_reload = TRUE
	reload_max = 8
	reload_time = 5 SECONDS
