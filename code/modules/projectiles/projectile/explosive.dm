

/obj/item/projectile/bullet/srmrocket
	name ="SRM-8 Rocket"
	desc = "Boom"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "missile"
	damage = 30	//Meaty whack. *Chuckles*
	does_spin = 0

/obj/item/projectile/bullet/srmrocket/on_hit(atom/target, blocked=0)
	..()
	if(!isliving(target)) //if the target isn't alive, so is a wall or something
		explosion(target, 0, 1, 2, 4)
	else
		explosion(target, 0, 0, 2, 4)
	return 1


/obj/item/projectile/bullet/srmrocket/weak	//Used in the jury rigged one.
	damage = 10

/obj/item/projectile/bullet/srmrocket/weak/on_hit(atom/target, blocked=0)
	..()
	explosion(target, 0, 0, 2, 4)//No need to have a question.
	return 1

/*Old vars here for reference.
	var/devastation = 0
	var/heavy_blast = 1
	var/light_blast = 2
	var/flash_blast = 4
*/




















/obj/item/projectile/missile
	name = "ion bolt"
	icon_state = "ion"
	fire_sound = 'sound/weapons/Laser.ogg'
	damage = 0
	damage_type = BURN
	nodamage = 1
	check_armour = "energy"
	light_range = 2
	light_power = 0.5
	light_color = "#55AAFF"

	combustion = FALSE
	impact_effect_type = /obj/effect/temp_visual/impact_effect/ion
	hitsound_wall = 'sound/weapons/effects/searwall.ogg'
	hitsound = 'sound/weapons/ionrifle.ogg'

	var/sev1_range = 0
	var/sev2_range = 1
	var/sev3_range = 1
	var/sev4_range = 1