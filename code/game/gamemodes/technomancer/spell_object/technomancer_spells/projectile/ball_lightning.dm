/datum/technomancer_catalog/spell/ball_lightning
	name = "Ball Lightning"
	cost = 100
	category = OFFENSIVE_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/ball_lightning)

/datum/spell_metadata/ball_lightning
	name = "Ball Lightning"
	desc = "Fires a small ball of lightning at a targeted tile, which zaps anyone it touches, \
	and bounces off of solid objects such as walls. When such a bounce happens, a zap is sent \
	out to anyone nearby. After enough bounces or distance, the ball of lighting explodes in \
	a final, bigger zap, and a flash of light. Electrical protection is recommended to avoid \
	unintentional user fatalities."
	enhancement_desc = "There is a chance for the ball to bounce towards a non-allied entity, \
	instead of bouncing normally."
	aspect = ASPECT_SHOCK
	icon_state = "tech_ball_lightning"
	cooldown = 1 SECOND
	spell_path = /obj/item/weapon/spell/technomancer/projectile/ball_lightning

/obj/item/weapon/spell/technomancer/projectile/ball_lightning
	name = "ball lightning"
	icon_state = "ball_lightning"
	desc = "Don't die!"
	cast_methods = CAST_RANGED
	spell_projectile = /obj/item/projectile/energy/ball_lightning
	energy_cost_per_shot = 1000
	instability_per_shot = 4
	fire_sound = 'sound/effects/magic/technomancer/death.ogg'
	can_hit_shooter = TRUE


/obj/item/weapon/spell/technomancer/projectile/ball_lightning/tweak_projectile(obj/item/projectile/energy/ball_lightning/P, mob/living/user)
	if(check_for_scepter())
		P.scepter = TRUE


/obj/item/projectile/energy/ball_lightning
	name = "ball lightning"
	icon_state = "tesla_projectile"
	penetrating = INFINITY
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	damage = 5
	damage_type = ELECTROCUTE
	ignore_permutations = TRUE // So we can hit people repeatively, and not go through walls we bounced off of before.
	hitsound = 'sound/effects/magic/technomancer/zap_hit.ogg'
	hitsound_wall = 'sound/effects/magic/technomancer/zap_hit.ogg'
	range = 150 // Should give around 10-14 bounces.
	modifier_type_to_apply = /datum/modifier/shocked
	modifier_duration = 5 SECONDS
	var/bounce_range_cost = 10 // Decreases range by this much when it bounces.
	var/scepter = FALSE // If TRUE, bouncing has a chance to redirect towards an enemy instead of the normal way.

/obj/item/projectile/energy/ball_lightning/check_penetrate(atom/A)
	if(isliving(A))
		return TRUE
	else if(A.density)
		bounce_off_solid_object(A)
		return TRUE
	return FALSE


/obj/item/projectile/energy/ball_lightning/proc/bounce_off_solid_object(atom/A)
	var/wall_angle = dir2angle(get_dir(A, get_turf(src)))

	var/incidence = GET_ANGLE_OF_INCIDENCE(wall_angle, (trajectory.angle + 180))
	if(abs(incidence) > 90 && abs(incidence) < 270)
		return FALSE
	var/new_angle = SIMPLIFY_DEGREES(wall_angle + incidence)
	setAngle(new_angle)

	zap_splash()

	range -= bounce_range_cost
	if(scepter && prob(30))
		bounce_to_enemy()
	return TRUE

// Called when casted with the Scepter of Enchancement in the offhand and it bounces.
/obj/item/projectile/energy/ball_lightning/proc/bounce_to_enemy()
	var/list/potential_enemies = viewers(get_turf(src))
	var/mob/living/enemy = null

	for(var/mob/living/L in shuffle(potential_enemies))
		if(L.stat == DEAD)
			continue
		if(L.mind && technomancers.is_antagonist(L.mind))
			continue // Don't redirect to the caster or their apprentices.
		enemy = L

	if(!enemy)
		return FALSE

	var/angle_to_enemy = Get_Angle(src, enemy)
	setAngle(angle_to_enemy)
	return TRUE

// Called when the projectile hits something solid like a wall, or when it explodes at the end.
/obj/item/projectile/energy/ball_lightning/proc/zap_splash(radius = 1, strength = 5)
	playsound(src, 'sound/effects/magic/technomancer/zap_hit.ogg', 75, 1)
	var/turf/T = get_turf(src)

	for(var/thing in view(radius, T))
		if(isturf(thing))
			var/turf/other_T = thing
			T.Beam(other_T, icon_state = "lightning[rand(1, 12)]", maxdistance = radius+1, time = 5)

		if(isliving(thing))
			var/mob/living/L = thing
			L.inflict_shock_damage(strength)
			playsound(L, 'sound/effects/magic/technomancer/zap_hit.ogg', 75, 1)
			L.add_modifier(/datum/modifier/shocked, 2 SECONDS)

		// I don't like mech code. It's coarse and rough and irritating and it gets everywhere.
		if(istype(thing, /obj/mecha))
			var/obj/mecha/M = thing
			M.take_damage(strength, "energy")
			playsound(M, 'sound/effects/magic/technomancer/zap_hit.ogg', 75, 1)

// Called when the projectile explodes at the end of its life.
/obj/item/projectile/energy/ball_lightning/on_range()
	visible_message(span("danger", "\The [src] explodes in a flash of light, sending a shock nearby!"))
	playsound(src.loc, 'sound/effects/lightningbolt.ogg', 100, 1, extrarange = 30)

	zap_splash(3, 10)

	// Flash people.
	for(var/mob/living/L in viewers(src))
		if(L == src)
			continue
		var/dir_towards_us = get_dir(L, src)
		if(L.dir && L.dir & dir_towards_us)
			to_chat(L, span("danger", "The flash of light blinds you briefly."))
			L.flash_eyes(intensity = FLASH_PROTECTION_MODERATE, override_blindness_check = FALSE, affect_silicon = TRUE)
	return ..()
