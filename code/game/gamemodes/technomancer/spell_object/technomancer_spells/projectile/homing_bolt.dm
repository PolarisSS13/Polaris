/datum/technomancer_catalog/spell/homing_bolt
	name = "Homing Bolt"
	cost = 100
	category = OFFENSIVE_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/projectile/homing_bolt)

/datum/spell_metadata/projectile/homing_bolt
	name = "Homing Bolt"
	desc = "Fires a special projectile which will track it's target, adjusting its own trajectory as it flies, \
	and making it more difficult to dodge. It accelerates faster as it flies, however the turning rate also decreases."
	aspect = ASPECT_FORCE
	icon_state = "tech_homing_bolt"
	cooldown = 1 SECOND
	spell_path = /obj/item/weapon/spell/technomancer/projectile/homing_bolt

/obj/item/weapon/spell/technomancer/projectile/homing_bolt
	name = "homing bolt"
	icon_state = "homing_bolt"
	desc = "Time to make the crew suffer through a bullet hell."
	spell_projectile = /obj/item/projectile/energy/technomancer_homing
	energy_cost_per_shot = 250
	instability_per_shot = 2
	fire_sound = 'sound/effects/magic/technomancer/magic_missile.ogg'

// Makes the projectile start homing towards the closest mob to what was clicked, if a mob wasn't already clicked.
/obj/item/weapon/spell/technomancer/projectile/homing_bolt/tweak_projectile(obj/item/projectile/P, atom/target, mob/living/user)
	if(!isliving(target))
		var/mob/living/L = targeting_assist(get_turf(target), 5)
		if(L)
			P.set_homing_target(L)
	else
		P.set_homing_target(target)

// Distinct from the advanced dark gygax's version, so that tweaking one won't make the other get really over/underpowered.
/obj/item/projectile/energy/technomancer_homing
	name = "homing bolt"
	icon_state = "homing_bolt"
	damage = 20
	damage_type = BURN
	check_armour = "laser"
	accuracy = 60 // Reduce the odds of an RNG miss, so avoiding it by moving becomes the better plan.
	homing_turn_speed = 15
	var/base_pixel_speed = 0.75
	var/base_turn_speed = 15
	var/acceleration_ticks = 0
	var/max_acceleration_ticks = 20
	var/max_acceleration_pixel_speed = 1.0
	var/max_acceleration_turn_speed = 5

// Smaller versions fired alongside the normal one when casting with the Scepter.
/obj/item/projectile/energy/technomancer_homing/lesser
	damage = 10

/obj/item/projectile/energy/technomancer_homing/fire(angle, atom/direct_target)
	..()
	set_pixel_speed(base_pixel_speed) // This sadly has to be done this way.

/obj/item/projectile/energy/technomancer_homing/process_homing()
	..()
	// The bolt gets faster as it flies, but turns slower.
	if(acceleration_ticks < max_acceleration_ticks)
		acceleration_ticks++

		set_pixel_speed( LERP(base_pixel_speed, max_acceleration_pixel_speed, acceleration_ticks / max_acceleration_ticks) )
		homing_turn_speed = LERP(base_turn_speed, max_acceleration_turn_speed, acceleration_ticks / max_acceleration_ticks)

