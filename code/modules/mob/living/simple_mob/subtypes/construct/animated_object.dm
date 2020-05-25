// The simple-mob used for the Technomancer's Animate Object spell.

/mob/living/simple_mob/artificial_construct/animated_object
	name = "Bad Name" // Actual name is set elsewhere.
	desc = "Bug report me if you can read this." // Ditto.
	icon = null
	icon_state = null

	hovering = TRUE
	pass_flags = PASSTABLE
	summoned = TRUE // So Abjuration kills them.
	maxHealth = 50
	health = 50

	// Default values, likely to be changed based on the object animated.
	movement_cooldown = 0
	melee_damage_lower = 5
	melee_damage_upper = 5
	base_attack_cooldown = DEFAULT_ATTACK_COOLDOWN // Default for objects.
	attack_sound = "swing_hit"

	// Needed for guns to shoot, sadly.
	humanoid_hands = TRUE
	has_hands = TRUE

	ai_holder_type = /datum/ai_holder/simple_mob/animated_object

	var/obj/animated_object = null // The object that was animated to produce this mob.
	var/outline_color = "#678FFE"
	var/y_offset = 8
	var/dont_drop_item = FALSE // If true, dying won't move the object. Used in case of death involving the item being ripped out.
	var/static/image/shadow_overlay = null

/mob/living/simple_mob/artificial_construct/animated_object/Initialize(mapload, obj/new_object)
	animated_object = new_object
	if(isliving(animated_object.loc))
		var/mob/living/L = animated_object.loc
		L.drop_from_inventory(animated_object, get_turf(src))
	animated_object.forceMove(src)
	apply_object(animated_object)
	visible_message(span("notice", "\The [animated_object] starts to float, with a soft glow around its edges."))
	return ..()

/mob/living/simple_mob/artificial_construct/animated_object/Destroy()
	if(!dont_drop_item)
		animated_object.forceMove(get_turf(src))

		if(istype(animated_object, /obj/item)) // Play the same sound as if it was dropped by someone.
			var/obj/item/I = animated_object
			if(I.drop_sound)
				playsound(I, I.drop_sound, 25, FALSE, preference = /datum/client_preference/drop_sounds)

	animated_object = null
	return ..()

/mob/living/simple_mob/artificial_construct/animated_object/Exited(atom/movable/AM, atom/new_loc)
	if(AM == animated_object)
		dont_drop_item = TRUE // So it won't teleport back.
		qdel(src)
	..()

/mob/living/simple_mob/artificial_construct/animated_object/death()
	qdel(src)

/mob/living/simple_mob/artificial_construct/animated_object/update_icon()
	. = ..()

	icon = animated_object.icon
	icon_state = animated_object.icon_state
	alpha = animated_object.alpha
	color = animated_object.color
	copy_overlays(animated_object, TRUE)

	icon_scale_x = animated_object.icon_scale_x
	icon_scale_y = animated_object.icon_scale_y
	update_transform()

	if(!get_filter("animated_object_outline"))
		add_filter("animated_object_outline", 1, list(type = "outline", size = 1, color = outline_color, flags = OUTLINE_SHARP))

	if(!shadow_overlay) // Let's be lazy.
		shadow_overlay = image(icon = 'icons/mob/animal.dmi', icon_state = "animated_object_shadow", loc = src)
		shadow_overlay.pixel_y -= y_offset
		shadow_overlay.appearance_flags = RESET_COLOR|RESET_ALPHA|PIXEL_SCALE

	cut_overlay(shadow_overlay) // Not sure this is needed to prevent a thousand duplicate overlays.
	add_overlay(shadow_overlay)


/mob/living/simple_mob/artificial_construct/animated_object/ICheckRangedAttack(atom/A)
	return istype(animated_object, /obj/item/weapon/gun)

/mob/living/simple_mob/artificial_construct/animated_object/shoot(atom/A)
	face_atom(A)
	if(!istype(animated_object, /obj/item/weapon/gun))
		return

	var/obj/item/weapon/gun/our_gun = animated_object
	our_gun.Fire(A, src, pointblank = Adjacent(A), reflex = FALSE)

	if(should_die())
		qdel(src)
	else
		update_icon() // So you can see how full the gun is.

/mob/living/simple_mob/artificial_construct/animated_object/emp_act(severity)
	animated_object.emp_act(severity)
	if(should_die())
		qdel(src)

/mob/living/simple_mob/artificial_construct/animated_object/ex_act(severity)
	animated_object.ex_act(severity)

/mob/living/simple_mob/artificial_construct/animated_object/bullet_act(obj/item/projectile/P)
	animated_object.bullet_act(P) // Makes animated fuel tanks very !FUN!.
	return ..()

// Returns TRUE if the animated object should die (besides running out of health), such as running out of ammo.
/mob/living/simple_mob/artificial_construct/animated_object/proc/should_die()
	if(!istype(animated_object, /obj/item/weapon/gun))
		return FALSE // Non-gun animated objects can stay alive until killed the normal way.

	var/obj/item/weapon/gun/our_gun = animated_object

	if(our_gun.attached_lock?.stored_dna)
		return TRUE

	// Ballistics.
	if(istype(our_gun, /obj/item/weapon/gun/projectile))
		var/obj/item/weapon/gun/projectile/P = our_gun
		if(!P.getAmmo())
			return TRUE

	// Energy.
	else if(istype(our_gun, /obj/item/weapon/gun/energy))
		var/obj/item/weapon/gun/energy/E = our_gun
		if(!E.power_supply && E.charge_cost) // No batteries means a useless gun.
			return TRUE
		if(E.power_supply.self_recharge) // Self charging batteries keep the object alive.
			return FALSE
		if(round(E.power_supply.charge / max(1, E.charge_cost)) <= 0) // Out of charge
			return TRUE

	return FALSE

/mob/living/simple_mob/artificial_construct/animated_object/proc/apply_object(obj/new_object)
	name = "animated [new_object.name]"
	desc = "It looks like a floating, glowing [new_object.name]."

	// Appearance stuff.
	pixel_x = initial(animated_object.pixel_x)
	pixel_y = initial(animated_object.pixel_y) + y_offset
	old_x = pixel_x
	old_y = pixel_y

	update_icon()

	//make_floating(TRUE)

	// Stat stuff.
	movement_cooldown = (new_object.w_class - 1) * 2 // Smaller objects are faster.

	if(istype(new_object, /obj/item/weapon))
		var/obj/item/weapon/W = new_object
		base_attack_cooldown = W.attackspeed

		if(istype(W, /obj/item/weapon/gun))
			var/obj/item/weapon/gun/G = W
			base_attack_cooldown = G.fire_delay

		attack_sound = W.hitsound

		if(istype(W, /obj/item/weapon/material/twohanded))
			var/obj/item/weapon/material/twohanded/twohanded = W
			melee_damage_lower = twohanded.force_wielded
			melee_damage_upper = twohanded.force_wielded
		else
			melee_damage_lower = W.force
			melee_damage_upper = W.force


/mob/living/simple_mob/artificial_construct/animated_object/technomancer/IIsAlly(mob/living/L)
	. = ..()
	if(!.)
		return is_technomancer_ally(L)


/datum/ai_holder/simple_mob/animated_object
	conserve_ammo = TRUE
	pointblank = TRUE
