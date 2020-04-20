#define CIRCLE_OF_COMBAT_RADIUS 5

/datum/technomancer_catalog/spell/circle_of_combat
	name = "Circle of Combat"
	desc = "Forms a circular wall around the caster. \
	The walls block movement, but can be destroyed in a few hits. Anyone intersecting a wall when \
	the circle is created will be nudged towards the outside if possible. If that isn't possible, \
	they will be nudged inward, if that is possible. The circle last for ten seconds.\
	<br><br>\
	If this spell is used on an entity, the circle that is made will be centered on them, \
	while using this function in-hand will center the circle on you.\
	<br><br>\
	Additionally, any allied entities inside the circle will receive an aura effect that improves combat performance."
	enhancement_desc = "When cast on a specific entity, all other non-allied entities inside the circle \
	are teleported outside of it."
	cost = 50
	category = UTILITY_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/circle_of_combat)

/datum/spell_metadata/circle_of_combat
	name = "Circle of Combat"
	icon_state = "tech_circle_of_combat"
	spell_path = /obj/item/weapon/spell/technomancer/circle_of_combat
	cooldown = 30 SECONDS

/obj/item/weapon/spell/technomancer/circle_of_combat
	name = "circle of combat"
	desc = "One vee one me."
	icon_state = "circle_of_combat"
	cast_methods = CAST_RANGED | CAST_USE
	aspect = ASPECT_FORCE
	var/circle_radius = CIRCLE_OF_COMBAT_RADIUS


/obj/item/weapon/spell/technomancer/circle_of_combat/on_ranged_cast(atom/hit_atom, mob/living/user)
	var/turf/T = get_turf(hit_atom)
	if(!istype(T))
		return FALSE

	var/mob/living/L = hit_atom

	if(!istype(L))
		L = targeting_assist(T, 3)

	if(istype(L))
		T = get_turf(L)

	if(!within_range(T) || !pay_energy(2000))
		return FALSE

	make_circle(T, L)

	user.adjust_instability(10)
	playsound(owner, 'sound/effects/magic/technomancer/repulse.ogg', 75, 1)
	return TRUE

/obj/item/weapon/spell/technomancer/circle_of_combat/on_use_cast(mob/living/user)
	if(pay_energy(2000))
		make_circle(get_turf(user), user)

		user.adjust_instability(10)
		playsound(owner, 'sound/effects/magic/technomancer/repulse.ogg', 75, 1)
		return TRUE
	return FALSE

/obj/item/weapon/spell/technomancer/circle_of_combat/proc/make_circle(turf/center, mob/living/target)
	var/list/turfs = getcircle(center, circle_radius)
	for(var/point in turfs)
		var/turf/T = point
		// `getcircle()` can give the same turf multiple times for some reason, so avoid multiple walls.
		if(locate(/obj/effect/circle_wall) in T)
			continue

		new /obj/effect/circle_wall(T)
		for(var/thing in T)
			// If someone is intersecting the circle, try to nudge them out of it.
			if(isliving(thing))
				var/mob/living/L = thing

				// First, try nudging outward.
				var/turf/outward_turf = get_step(T, GLOB.reverse_dir[get_dir(T, center)])
				if(L.Move(outward_turf))
					to_chat(L, span("danger", "A circlar forcefield suddenly appeared where you were, and it displaced you outside of it!"))
					continue

				// Otherwise try nudging inward.
				var/turf/inward_turf = get_step(T, get_dir(T, center))
				if(L.Move(inward_turf))
					to_chat(L, span("danger", "A circlar forcefield suddenly appeared where you were, and it displaced you inside of it!"))

	log_and_message_admins("has created a circle around [target == owner ? "themselves" : "\the [target]"].")
	new /obj/effect/temp_visual/pulse/circle_of_combat_aura(center)

	// Blink people outside if they have a scepter.
	if(check_for_scepter() && target != owner)
		for(var/mob/living/L in viewers(center, CIRCLE_OF_COMBAT_RADIUS))
			if(L == target)
				continue
			if(is_technomancer_ally(L))
				continue
			safe_blink(L, CIRCLE_OF_COMBAT_RADIUS + 4, CIRCLE_OF_COMBAT_RADIUS + 2)
			log_and_message_admins("has blinked \the [L] outside of their circle.")

	playsound(src, 'sound/effects/antag_notice/general_baddie_alert.ogg', 75, FALSE, 7)

// Circle wall object.

/obj/effect/circle_wall
	name = "force field"
	desc = "A wall using some kind of energy. You might be able to get through with a few hits."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield1"
	density = TRUE
	anchored = TRUE
	var/hits_left = 3
	var/lifetime = 10 SECONDS

/obj/effect/circle_wall/Initialize()
	QDEL_IN(src, lifetime)
	set_light(3, 2, l_color = "#006AFF")
	playsound(src, 'sound/effects/magic/technomancer/repulse.ogg', 75, 1)
	return ..()

/obj/effect/circle_wall/attackby(obj/item/I, mob/living/user)
	if(I.force > 0)
		receive_hit()
		user.setClickCooldown(user.get_attack_speed(src))
	return ..()

/obj/effect/circle_wall/bullet_act(obj/item/projectile/P, def_zone)
	if(P.get_structure_damage() > 0)
		receive_hit()
	return ..()

/obj/effect/circle_wall/proc/receive_hit()
	hits_left--
	visible_message(span("danger", "\The [src] weakens!"))
	playsound(src, 'sound/effects/EMPulse.ogg', 50, 1)
	if(hits_left <= 0)
		playsound(src, "shatter", 75, 1)
		qdel(src)

// Circle combat modifier.

/datum/modifier/aura/circle_of_combat
	name = "circle of combat"
	desc = "The circle gives"
	mob_overlay_state = "blue_electricity_constant"
	stacks = MODIFIER_STACK_FORBID
	aura_max_distance = CIRCLE_OF_COMBAT_RADIUS

	on_created_text = "<span class='notice'>Standing within the circle makes you feel more powerful!</span>"
	on_expired_text = "<span class='warning'>You feel your fighting ability return to what it was before.</span>"

	disable_duration_percent = 0.75
	incoming_damage_percent = 0.75
	outgoing_melee_damage_percent = 1.25
	attack_speed_percent = 1.25
	slowdown = -0.5
	evasion = 20
	accuracy = 20
	accuracy_dispersion = -10
	technomancer_dispellable = TRUE


// Circle aura granter.

/obj/effect/temp_visual/pulse/circle_of_combat_aura
	name = "empowering glow"
	desc = "Some kind of weird energy thing."
	icon_state = "shield2"
	light_range = 3
	light_power = 2
	light_color = "#006AFF"
	pulses_remaining = 10
	pulse_delay = 1 SECOND

/obj/effect/temp_visual/pulse/circle_of_combat_aura/on_pulse()
	for(var/mob/living/L in view(src, CIRCLE_OF_COMBAT_RADIUS))
		if(is_technomancer_ally(L))
			L.add_modifier(/datum/modifier/aura/circle_of_combat, null, src)