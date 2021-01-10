
/obj/item/weapon/spell/construct //Energy costs are in units of blood, in the event a cultist gets one of these.
	name = "unholy energy"
	desc = "Your hands appear to be screaming. This is a debug text, you should probably tell a developer!"
	icon = 'icons/obj/spells.dmi'
	icon_state = "generic"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_spells.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_spells.dmi',
		)
	throwforce = 0
	force = 0
	show_examine = FALSE
	owner = null
	core = null
	cast_methods = null			// Controls how the spell is casted.
	aspect = ASPECT_UNHOLY		// Used for combining spells. Pretty much any cult spell is unholy.
	toggled = 0					// Mainly used for overlays.
	cooldown = 0 				// If set, will add a cooldown overlay and adjust click delay.  Must be a multiple of 5 for overlays.
	cast_sound = null			// Sound file played when this is used.
	var/last_castcheck = null	// The last time this spell was cast.

	var/bloodcost = 10

	var/dangerous = FALSE	// Will this spell drain someone dry?

	var/obj/item/device/crystalball/spellfocus = null

/obj/item/weapon/spell/construct/New()
	//..() //This kills the spell, because super on this calls the default spell's New, which checks for a core. Can't have that.
	if(isliving(loc))
		owner = loc
	if(!owner)
		qdel(src)
	update_icon()

/obj/item/weapon/spell/construct/adjust_instability(var/amount) //The only drawback to the boons of the geometer is the use of a mortal's blood as fuel. Constructs have already paid that price long ago.
	return

/obj/item/weapon/spell/construct/run_checks()
	if(owner)
		spellfocus = locate(/obj/item/device/crystalball) in owner

		if(spellfocus)
			if(!spellfocus.crude && !(iscultist(owner) || istype(owner, /mob/living/simple_mob/construct)))
				return FALSE

		if((world.time >= (last_castcheck + cooldown))) //Are they a cultist or a construct, and has the cooldown time passed?
			last_castcheck = world.time
			return 1
	return 0

/obj/item/weapon/spell/construct/pay_energy(var/amount)
	if(owner)

		var/datum/bloodnet/owner_net = owner.getBloodnet()

		if(spellfocus)
			amount *= spellfocus.efficiency

			if(spellfocus.networked)
				owner_net = spellfocus.getBloodnet()

		if(!owner_net)
			if(!spellfocus || spellfocus.crude)
				return pay_blood(amount * 2)	// Double cost for non-cultist non-constructs.
			else
				return FALSE

		if(handle_network_payment(owner_net,-1 * amount))
			return TRUE

		if(iscultist(owner) && pay_blood(round(amount * 0.25)))
			return TRUE

	return FALSE

// Override this to provide unique effects based on the level of payment from a blood network.
/obj/item/weapon/spell/construct/proc/handle_network_payment(var/datum/bloodnet/bank_net,var/amount)
	if(!bank_net)
		return FALSE

	if(amount == 0)
		return TRUE

	return bank_net.adjustBlood(amount, TRUE)

/obj/item/weapon/spell/construct/proc/pay_blood(var/amount) //If, for some reason, this is put into the hands of a cultist, by a talisnam or whatever.
	if(!dangerous)
		if(owner.getOxyLoss() > 20 || owner.getToxLoss() > 20)
			return FALSE

		if(ishuman(owner))
			var/mob/living/carbon/human/H = owner

			if(!H.isSynthetic())
				if(H.internal_organs_by_name[O_HEART])
					if(H.vessel.total_volume < H.species.blood_volume * 0.9)
						return FALSE
				else
					if(H.getFireLoss() > 20)
						return FALSE

	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		if(!H.should_have_organ(O_HEART) || H.isSynthetic())
			H.adjustToxLoss(amount * 2)
			return TRUE
		if(H.vessel.remove_reagent("blood", amount))
			return TRUE
	return FALSE

/obj/item/weapon/spell/construct/afterattack(atom/target, mob/user, proximity_flag, click_parameters) //Not overriding it caused runtimes, because cooldown checked for core.
	if(!run_checks())
		return
	if(!proximity_flag)
		if(cast_methods & CAST_RANGED)
			on_ranged_cast(target, user)
	else
		if(istype(target, /obj/item/weapon/spell))
			var/obj/item/weapon/spell/spell = target
			if(spell.cast_methods & CAST_COMBINE)
				spell.on_combine_cast(src, user)
				return
		if(cast_methods & CAST_MELEE)
			on_melee_cast(target, user)
		else if(cast_methods & CAST_RANGED) //Try to use a ranged method if a melee one doesn't exist.
			on_ranged_cast(target, user)
	if(cooldown)
		var/effective_cooldown = round(cooldown, 5)
		user.setClickCooldown(effective_cooldown)
		flick("cooldown_[effective_cooldown]",src)

/obj/item/weapon/spell/construct/projectile //This makes me angry, but we need the template, and we can't use it because special check overrides on the base.
	name = "construct projectile template"
	icon_state = "generic"
	desc = "This is a generic template that shoots projectiles.  If you can read this, the game broke!"
	cast_methods = CAST_RANGED
	var/obj/item/projectile/spell_projectile = null
	var/pre_shot_delay = 0
	var/fire_sound = null
	var/energy_cost_per_shot = 10

/obj/item/weapon/spell/construct/projectile/on_ranged_cast(atom/hit_atom, mob/living/user)
	if(set_up(hit_atom, user))
		var/obj/item/projectile/new_projectile = make_projectile(spell_projectile, user)
		new_projectile.old_style_target(hit_atom)
		new_projectile.fire()
		log_and_message_admins("has casted [src] at \the [hit_atom].")
		if(fire_sound)
			playsound(src, fire_sound, 75, 1)
		return 1
	return 0

/obj/item/weapon/spell/construct/projectile/proc/make_projectile(obj/item/projectile/projectile_type, mob/living/user)
	var/obj/item/projectile/P = new projectile_type(get_turf(user))
	return P

/obj/item/weapon/spell/construct/projectile/proc/set_up(atom/hit_atom, mob/living/user)
	if(spell_projectile)
		if(pay_energy(energy_cost_per_shot))
			if(pre_shot_delay)
				var/image/target_image = image(icon = 'icons/obj/spells.dmi', loc = get_turf(hit_atom), icon_state = "target")
				user << target_image
				user.Stun(pre_shot_delay / 10)
				sleep(pre_shot_delay)
				qdel(target_image)
				if(owner)
					return TRUE
				return FALSE // We got dropped before the firing occured.
			return TRUE // No delay, no need to check.
	return FALSE

/obj/item/weapon/spell/construct/spawner
	name = "spawner template"
	desc = "If you see me, someone messed up."
	icon_state = "darkness"
	cast_methods = CAST_RANGED
	var/obj/effect/spawner_type = null

	bloodcost = 30

/obj/item/weapon/spell/construct/spawner/on_ranged_cast(atom/hit_atom, mob/user)
	var/turf/T = get_turf(hit_atom)
	if(T && pay_energy(bloodcost))
		new spawner_type(T)
		to_chat(user, "<span class='cult'>You shift \the [src] onto \the [T].</span>")
		log_and_message_admins("has casted [src] at [T.x],[T.y],[T.z].")
		qdel(src)
