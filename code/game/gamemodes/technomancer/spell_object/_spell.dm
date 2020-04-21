/obj/item/weapon/spell
	name = "glowing particles"
	desc = "Your hands appear to be glowing brightly."
	icon = 'icons/obj/spells.dmi'
	icon_state = "generic"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_spells.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_spells.dmi',
		)
	throwforce = 0
	force = 0
	show_examine = FALSE
	var/mob/living/owner = null
	var/cast_methods = null			// Controls how the spell is casted.
	var/aspect = null				// Used for combining spells.
	var/datum/spell_metadata/meta = null // Ref to the metadata datum that holds information that survives between spell drops.
	var/toggled = FALSE				// Mainly used for overlays.
	var/dont_qdel_when_dropped = FALSE // If true, the spell won't delete itself when dropped.
	var/delete_after_cast = FALSE
	var/cooldown_visual_timerid = null

/obj/item/weapon/spell/Initialize(mapload, datum/spell_metadata/new_meta)
	if(isliving(loc))
		owner = loc
	meta = new_meta
	new_spell_icon_visuals()
	return ..()

/obj/item/weapon/spell/Destroy()
	owner.unref_spell(src)
	owner = null
	return ..()

/mob/living/proc/place_spell_in_hand(var/path)
	return

/*
	if(get_cooldown())
		to_chat(owner, span("warning", "It's too soon to invoke this function again. \
		You have to wait for at least [DisplayTimeText(get_cooldown())]."))
		return FALSE
*/

// Gives the spell to the human mob, if it is allowed to have spells, hands are not full, etc.  Otherwise it deletes itself.
// Returns the newly created spell, in case you want to do things with it.
/mob/living/carbon/human/place_spell_in_hand(var/path, datum/spell_metadata/new_meta)
	if(!path || !ispath(path))
		return FALSE

	var/obj/item/weapon/spell/S = new path(src, new_meta)

	//No hands needed for innate casts.
	if(S.cast_methods & CAST_INNATE)
		if(S.run_checks())
			if(S.get_cooldown())
				to_chat(src, span("warning", "It's too soon to invoke this function again. \
				You have to wait for at least [DisplayTimeText(S.get_cooldown())]."))
				qdel(S)
				return null
			else
				if(S.on_innate_cast(src))
					S.after_cast(src)
				return S

	if(l_hand && r_hand) //Make sure our hands aren't full.
		if(istype(r_hand, /obj/item/weapon/spell)) //If they are full, perhaps we can still be useful.
			var/obj/item/weapon/spell/r_spell = r_hand
			if(r_spell.aspect == ASPECT_CHROMATIC) //Check if we can combine the new spell with one in our hands.
				r_spell.on_combine_cast(S, src)
		else if(istype(l_hand, /obj/item/weapon/spell))
			var/obj/item/weapon/spell/l_spell = l_hand
			if(l_spell.aspect == ASPECT_CHROMATIC) //Check the other hand too.
				l_spell.on_combine_cast(S, src)
		else //Welp
			to_chat(src, span("warning", "You require a free hand to use this function."))
			qdel(S)
			return null

	if(S.run_checks())
		put_in_hands(S)
		return S
	else
		qdel(S)
		return null

// Nulls object references on specific mobs so it can qdel() cleanly.
/mob/living/proc/unref_spell(var/obj/item/weapon/spell/the_spell)
	return

// Ensures spells should not function if something is wrong.  If a core is missing, it will try to find one,
// then fail if it still can't find one.  It will also check if the core is being worn properly,
// and finally checks if the owner is a technomancer.
/obj/item/weapon/spell/proc/run_checks()
	if(!owner)
		return FALSE
	return TRUE

// Tries to combine the spells, if W is a spell, and is receptive to being combined.
/obj/item/weapon/spell/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/weapon/spell))
		var/obj/item/weapon/spell/spell = W
		if(run_checks() && (cast_methods & CAST_COMBINE))
			spell.on_combine_cast(src, user)
	else
		..()

// Tests to make sure it can cast, then casts a combined, ranged, or melee spell based on what it can do,
// and the  range the click occured.  Melee casts have higher priority than ranged if both are possible.
// Don't override this for spells, override the on_[melee|range]_cast() spells below.
/obj/item/weapon/spell/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!run_checks())
		return

	if(get_cooldown())
		to_chat(user, span("warning", "It's too soon to invoke this function again. \
		You have to wait for at least [DisplayTimeText(get_cooldown())]."))
		return

	if(!proximity_flag)
		if(cast_methods & CAST_RANGED)
			. = on_ranged_cast(target, user)
	else
		if(istype(target, /obj/item/weapon/spell))
			var/obj/item/weapon/spell/spell = target
			if(spell.cast_methods & CAST_COMBINE)
				. = spell.on_combine_cast(src, user)
				return
		if(cast_methods & CAST_MELEE)
			. = on_melee_cast(target, user)
		else if(cast_methods & CAST_RANGED) // Try to use a ranged method if a melee one doesn't exist.
			. = on_ranged_cast(target, user)
	if(.)
		after_cast(user)

/obj/item/weapon/spell/proc/after_cast(mob/user)
	apply_cooldown()
	if(delete_after_cast || QDELETED(src))
		qdel(src)
	else
		handle_cooldown_visuals()

// Tries to call on_use_cast() if it is allowed to do so.  Don't override this, override on_use_cast() instead.
/obj/item/weapon/spell/attack_self(mob/user)
	if(run_checks() && (cast_methods & CAST_USE))
		if(on_use_cast(user))
			after_cast(user)
	..()

/obj/item/weapon/spell/dropped()
	. = ..()
	if(!dont_qdel_when_dropped && !QDELETED(src))
		qdel(src)

/obj/item/weapon/spell/proc/apply_cooldown()
	meta.last_cast_time = world.time
	return TRUE

// Returns the number of seconds a spell is on cooldown for, or 0 if it isn't on cooldown.
/obj/item/weapon/spell/proc/get_cooldown()
	return max(0, (meta.last_cast_time + meta.cooldown) - world.time)

/obj/item/weapon/spell/throw_impact(atom/hit_atom)
	. = ..()
	if(cast_methods & CAST_THROW)
		on_throw_cast(hit_atom)
	qdel(src)


#define COOLDOWN_ICON_STATES 9

/obj/item/weapon/spell/proc/handle_cooldown_visuals()
	cooldown_loop()

/obj/item/weapon/spell/proc/cooldown_loop()
	if(cooldown_visual_timerid)
		deltimer(cooldown_visual_timerid)
		cooldown_visual_timerid = null

	if(!get_cooldown())
		icon_state = initial(icon_state)
		update_icon()
		return

	var/icon_state_to_use = (1 - (get_cooldown() / meta.cooldown)) * COOLDOWN_ICON_STATES
	icon_state_to_use = CEILING(between(1, icon_state_to_use, COOLDOWN_ICON_STATES), 1)
	icon_state = "cooldown[icon_state_to_use]"

	if(!cooldown_visual_timerid)
		var/shortest_period = meta.cooldown / COOLDOWN_ICON_STATES
		var/next_period = max(FLOOR(shortest_period, 1), 1)
		// This is deliberately not using TIMER_LOOP because they tend to have `deltimer()` do nothing and loop forever.
		cooldown_visual_timerid = addtimer(CALLBACK(src, .proc/cooldown_loop), next_period, TIMER_STOPPABLE)


#undef COOLDOWN_ICON_STATES

// Should return TRUE if the user can pay for the spell, FALSE otherwise.
/obj/item/weapon/spell/proc/pay_energy(var/amount)
	return TRUE

/obj/item/weapon/spell/proc/give_energy(var/amount)
	return TRUE

/obj/item/weapon/spell/proc/new_spell_icon_visuals()
	// TODO: Add spinny overlay if the spell is toggled/passive/etc.
	handle_cooldown_visuals() // If the player gets a spell that's still on cooldown, it should be shown.

// Override this to do something as soon as the technomancer has the spell in their hand,
// as Initialize() can be too early to do certain things.
/obj/item/weapon/spell/proc/on_spell_given(mob/user)

// Override this for clicking the spell in your hands.
/obj/item/weapon/spell/proc/on_use_cast(mob/user)

// Override this for throwing effects.
/obj/item/weapon/spell/proc/on_throw_cast(atom/hit_atom)

// Override this for ranged effects.
// This is also called if clicked on in melee range, and the spell doesn't have a seperate melee cast flag.
/obj/item/weapon/spell/proc/on_ranged_cast(atom/hit_atom, mob/user)

// Override this for effects that occur at melee range.
/obj/item/weapon/spell/proc/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)


// Override this for combining spells, if that is ever re-implemented.
/obj/item/weapon/spell/proc/on_combine_cast(obj/item/I, mob/user)
	return


// Override this for casting immediately, without using hands.
/obj/item/weapon/spell/proc/on_innate_cast(mob/user)