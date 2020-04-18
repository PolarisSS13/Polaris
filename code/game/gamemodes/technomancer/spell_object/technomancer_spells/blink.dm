/datum/technomancer_catalog/spell/blink
	name = "Blink"
	desc = "Force the target to teleport to a random position a short distance away. \
	This target could be anything from something lying on the ground, \
	to someone trying to fight you, or even yourself. \
	Using this on someone next to you makes their potential distance after teleportation greater. \
	Self casting has the greatest potential for distance, as well as the cheapest cost. \
	Additionally, anyone blinked will be briefly confused. Self blinks won't confuse you."
	enhancement_desc = "Max potential blink distance is increased greatly."
	spell_power_desc = "Max potential blink distance is scaled up with more spell power."
	category = UTILITY_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/blink)

/datum/spell_metadata/blink
	name = "Blink"
	icon_state = "tech_blink"
	spell_path = /obj/item/weapon/spell/technomancer/blink

/obj/item/weapon/spell/technomancer/blink
	name = "blink"
	desc = "Blink blink blink blink blink blink..."
	icon_state = "blink"
	cast_methods = CAST_RANGED | CAST_MELEE | CAST_USE
	aspect = ASPECT_TELE
	var/ranged_blink_cost = 400
	var/melee_blink_cost = 300
	var/self_blink_cost = 200

/obj/item/weapon/spell/technomancer/blink/on_ranged_cast(atom/hit_atom, mob/user)
	if(istype(hit_atom, /atom/movable))
		return generic_blink(hit_atom, blink_cost = ranged_blink_cost, instability_amount = 3, max_distance = 3, scepter_max_distance = 6)
	return FALSE

/obj/item/weapon/spell/technomancer/blink/on_use_cast(mob/user)
	return generic_blink(user, blink_cost = self_blink_cost, instability_amount = 1, max_distance = 6, scepter_max_distance = 10)

/obj/item/weapon/spell/technomancer/blink/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)
	if(istype(hit_atom, /atom/movable))
		if(hit_atom == user) // If the player clicked themselves, use the self cast version instead so they don't accidentally screw themselves out of the best version.
			return on_use_cast(user)
		return generic_blink(hit_atom, blink_cost = melee_blink_cost, instability_amount = 2, max_distance = 6, scepter_max_distance = 10)
	return FALSE

// Reduces copypasta between the three types of spell casting.
/obj/item/weapon/spell/technomancer/blink/proc/generic_blink(atom/movable/AM, blink_cost, instability_amount, max_distance, scepter_max_distance)
	if(!allowed_to_teleport())
		to_chat(owner, span("warning", "Teleportation doesn't seem to work here."))
		return FALSE

	if(!within_range(AM))
		to_chat(owner, span("warning", "\The [AM] is too far away to blink."))
		return FALSE

	if(pay_energy(blink_cost))
		var/blink_distance = max_distance
		if(check_for_scepter())
			blink_distance = scepter_max_distance

		safe_blink(AM, blink_distance)
		if(isliving(AM))
			blink_confusion(AM)
			log_and_message_admins("has blinked [AM == owner ? "themself" : "\the [AM]"] away.")

		adjust_instability(instability_amount)
		return TRUE

	to_chat(owner, span("warning", "You need more energy to blink \the [AM] away!"))
	return FALSE

/obj/item/weapon/spell/technomancer/blink/proc/blink_confusion(mob/living/L)
	if(!istype(L))
		return
	if(L == owner) // Self blinks won't confuse the user.
		return
	L.Confuse(1) // A very short confuse.
	to_chat(L, span("warning", "You feel disoriented after your surroundings suddenly shifted."))