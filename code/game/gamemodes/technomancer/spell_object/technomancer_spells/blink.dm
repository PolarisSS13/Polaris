/datum/technomancer_catalog/spell/blink
	name = "Blink"
	category = UTILITY_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/blink)

/datum/spell_metadata/blink
	name = "Blink"
	desc = "Force the target to teleport to a random position a short distance away. \
	This target could be anything from something lying on the ground, \
	to someone trying to fight you, or even yourself. \
	Using this on someone next to you makes their potential distance after teleportation greater. \
	Self casting has the greatest potential for distance, as well as the cheapest cost. \
	Additionally, anyone blinked will be briefly confused. Self blinks won't confuse you."
	enhancement_desc = "Blinks have a minimum distance that people can be teleported away from, \
	as well as a maximum distance."
	aspect = ASPECT_TELE
	icon_state = "tech_blink"
	spell_path = /obj/item/weapon/spell/technomancer/blink

/datum/spell_metadata/blink/get_spell_info()
	var/obj/item/weapon/spell/technomancer/blink/spell = spell_path
	. = list()
	.["Ranged Energy Cost"] = initial(spell.ranged_blink_energy_cost)
	.["Ranged Instability Cost"] = initial(spell.ranged_blink_instability_cost)
	.["Ranged Max Distance"] = initial(spell.ranged_blink_max_distance)
	.["Ranged Scepter Min Distance"] = initial(spell.ranged_blink_scepter_min_distance)

	.["Melee Energy Cost"] = initial(spell.melee_blink_energy_cost)
	.["Melee Instability Cost"] = initial(spell.melee_blink_instability_cost)
	.["Melee Max Distance"] = initial(spell.melee_blink_max_distance)
	.["Melee Scepter Min Distance"] = initial(spell.melee_blink_scepter_min_distance)

	.["Self Energy Cost"] = initial(spell.self_blink_energy_cost)
	.["Self Instability Cost"] = initial(spell.self_blink_instability_cost)
	.["Self Max Distance"] = initial(spell.self_blink_max_distance)
	.["Self Scepter Min Distance"] = initial(spell.self_blink_scepter_min_distance)



/obj/item/weapon/spell/technomancer/blink
	name = "blink"
	desc = "Blink blink blink blink blink blink..."
	icon_state = "blink"
	cast_methods = CAST_RANGED | CAST_MELEE | CAST_USE
	var/ranged_blink_energy_cost = 400
	var/ranged_blink_instability_cost = 3
	var/ranged_blink_max_distance = 3
	var/ranged_blink_scepter_min_distance = 2

	var/melee_blink_energy_cost = 300
	var/melee_blink_instability_cost = 2
	var/melee_blink_max_distance = 6
	var/melee_blink_scepter_min_distance = 3

	var/self_blink_energy_cost = 200
	var/self_blink_instability_cost = 1
	var/self_blink_max_distance = 6
	var/self_blink_scepter_min_distance = 4

/obj/item/weapon/spell/technomancer/blink/on_ranged_cast(atom/hit_atom, mob/user)
	if(istype(hit_atom, /atom/movable))
		return generic_blink(
			hit_atom,
			blink_cost = ranged_blink_energy_cost,
			instability_amount = ranged_blink_instability_cost,
			max_distance = ranged_blink_max_distance,
			scepter_min_distance = ranged_blink_scepter_min_distance
		)
	return FALSE


/obj/item/weapon/spell/technomancer/blink/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)
	if(istype(hit_atom, /atom/movable))
		if(hit_atom == user) // If the player clicked themselves, use the self cast version instead so they don't accidentally screw themselves out of the best version.
			return on_use_cast(user)
		return generic_blink(
			hit_atom,
			blink_cost = melee_blink_energy_cost,
			instability_amount = melee_blink_instability_cost,
			max_distance = melee_blink_max_distance,
			scepter_min_distance = melee_blink_scepter_min_distance
		)
	return FALSE

/obj/item/weapon/spell/technomancer/blink/on_use_cast(mob/user)
	return generic_blink(
		user,
		blink_cost = self_blink_energy_cost,
		instability_amount = self_blink_instability_cost,
		max_distance = self_blink_max_distance,
		scepter_min_distance = self_blink_scepter_min_distance
	)

// Reduces copypasta between the three types of spell casting.
/obj/item/weapon/spell/technomancer/blink/proc/generic_blink(atom/movable/AM, blink_cost, instability_amount, max_distance, scepter_min_distance)
	if(!allowed_to_teleport())
		to_chat(owner, span("warning", "Teleportation doesn't seem to work here."))
		return FALSE

	if(!within_range(AM))
		to_chat(owner, span("warning", "\The [AM] is too far away to blink."))
		return FALSE

	if(pay_energy(blink_cost))
		var/min_distance = check_for_scepter() ? scepter_min_distance : 0
		safe_blink(AM, max_distance, min_distance)

		if(isliving(AM))
			blink_confusion(AM)
			log_and_message_admins("has blinked [AM == owner ? "themselves" : "\the [AM]"] away.")

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