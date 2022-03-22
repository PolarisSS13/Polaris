/mob/living/simple_mob/animal/space/alien
	name = "skathari soldier"
	desc = "Terrible insects from beyond this galaxy!"
	description_fluff = "Also know as the 'Bluespace Bugs', these insectoid invaders began to manifest suddenly around 2565 and their ravenous hunger for the very particles upon which modern FTL technology relies brought much of galactic society to a standstill. Their ravenous hunger for physical matter on the other hand, got people moving again fast - in the other direction!"
	tt_desc = "X Extraneus Tarlevi"
	icon = 'icons/mob/alien.dmi'
	icon_state = "alienh_running"
	icon_living = "alienh_running"
	icon_dead = "alien_dead"
	icon_gib = "syndicate_gib"
	icon_rest = "alienh_sleep"
	faction = "xeno"
	mob_class = MOB_CLASS_ABERRATION
	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"
	organ_names = /decl/mob_organ_names/skathari
	maxHealth = 120
	health = 120
	see_in_dark = 7
	turn_sound = "skathari_chitter"
	harm_intent_damage = 5
	melee_damage_lower = 25
	melee_damage_upper = 25
	attack_armor_pen = 15
	attack_sharp = TRUE
	attack_edge = TRUE
	attacktext = list("slashed")
	attack_sound = 'sound/weapons/bladeslice.ogg'


/mob/living/simple_mob/animal/space/alien/death()
	var/turf/center = get_turf(src)
	if (isturf(center))
		playsound(center, 'sound/effects/mob_effects/skathari_teleport.ogg', 75, TRUE)
		for (var/mob/living/carbon/victim in oviewers(5, center))
			victim.flash_eyes(3)
		visible_message(
			SPAN_WARNING("\The [src] disappears with a screech and a flash of light!"),
			SPAN_WARNING("You hear a thin, high screech, ended by a sudden echoing snap!")
		)
		new /obj/effect/decal/cleanable/blood/skathari (center)
		new /obj/effect/temp_visual/bluespace_tear (center)
	qdel(src)
	..()


/mob/living/simple_mob/animal/space/alien/drone
	name = "skathari worker"
	icon_state = "aliend_running"
	icon_living = "aliend_running"
	icon_dead = "aliend_l"
	icon_rest = "aliend_sleep"
	health = 80
	melee_damage_lower = 15
	melee_damage_upper = 15
	projectiletype = /obj/item/projectile/energy/skathari


/mob/living/simple_mob/animal/space/alien/queen/empress/mother
	name = "skathari tyrant"
	desc = "Sweet mother of bugs!"
	icon = 'icons/mob/96x96.dmi'
	icon_state = "tyrant_s"
	icon_living = "tyrant_s"
	icon_dead = "tyrant_dead"
	icon_rest = "tyrant_rest"
	maxHealth = 600
	health = 600
	meat_amount = 10
	melee_damage_lower = 15
	melee_damage_upper = 25
	movement_cooldown = 8
	projectiletype = /obj/item/projectile/energy/skathari
	pixel_x = -32
	old_x = -32
	icon_expected_width = 96
	icon_expected_height = 96


/decl/mob_organ_names/skathari
	hit_zones = list("carapace", "abdomen", "left forelegs", "right forelegs", "left hind legs", "right hind legs", "head")
