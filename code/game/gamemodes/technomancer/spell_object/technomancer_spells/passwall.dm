/datum/technomancer_catalog/spell/passwall
	name = "Passwall"
	cost = 200
	category = UTILITY_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/passwall)

/datum/spell_metadata/passwall
	name = "Passwall"
	desc = "A notable function that allows the user to phase through matter (usually walls) \
	in order to enter or exit a room. Be careful you don't pass into somewhere dangerous."
	aspect = ASPECT_TELE
	icon_state = "tech_passwall"
	spell_path = /obj/item/weapon/spell/technomancer/passwall
	cooldown = 5 SECONDS

/datum/spell_metadata/passwall/get_spell_info()
	var/obj/item/weapon/spell/technomancer/passwall/spell = spell_path
	. = list()
	.["Energy Cost"] = "[initial(spell.energy_cost_per_tile)] per tile"
	.["Instability Cost"] = initial(spell.instability_cost)
	.["Maximum Distance"] = initial(spell.maximum_distance)
	.["Delay"] = "[DisplayTimeText(initial(spell.delay_per_tile))] per tile"
	.["Scepter Delay Energy Cost"] = "[DisplayTimeText(initial(spell.scepter_delay_per_tile))] per tile"


/obj/item/weapon/spell/technomancer/passwall
	name = "passwall"
	desc = "No walls can hold you back."
	cast_methods = CAST_MELEE
	var/busy = FALSE
	var/maximum_distance = 10
	var/energy_cost_per_tile = 500
	var/instability_cost = 5
	var/delay_per_tile = 1 SECOND
	var/scepter_delay_per_tile = 0.25 SECONDS

/obj/item/weapon/spell/technomancer/passwall/on_melee_cast(atom/hit_atom, mob/user)
	if(busy)
		to_chat(user, span("warning", "You're in the middle of teleporting, be patient."))
		return FALSE

	var/turf/T = get_turf(hit_atom) // Turf of the thing we touched.
	var/turf/our_T = get_turf(user) // Where we are.
	if(!T.check_density(ignore_mobs = TRUE))
		to_chat(user, span("warning", "Perhaps you should try using passWALL on a wall, or other solid object."))
		return FALSE

	var/direction = get_dir(our_T, T)
	var/total_cost = 0
	var/turf/checked_turf = T // Turf we're currently checking for density in the loop below.
	var/turf/found_turf = null // The destination, if one is found.
	var/i = maximum_distance

	user.visible_message(span("notice", "\The [user] rests a hand on \the [hit_atom]."))

	while(i)
		checked_turf = get_step(checked_turf, direction) // Advance in the given direction.
		total_cost += energy_cost_per_tile
		i--

		if(checked_turf.block_tele) // The fun ends here.
			break

		if(!checked_turf.check_density(ignore_mobs = TRUE)) // If we found a destination (a non-dense turf), then we can stop.
			found_turf = checked_turf
			break

	if(!found_turf)
		to_chat(user, span("warning", "You weren't able to find an open space to go to."))
		return FALSE

	// At this point, we found where we want to go.
	var/delay_used = delay_per_tile
	if(check_for_scepter())
		delay_used = scepter_delay_per_tile

	var/obj/effect/temp_visual/pulse/passwall_indicator/indicator = new(our_T, direction, delay_used)
	busy = TRUE
	playsound(user, 'sound/effects/magic/technomancer/generic_cast.ogg', 75, 1)

	if(!do_after(user, get_dist(our_T, found_turf) * delay_used, get_turf(user)))
		to_chat(user, span("warning", "You need to stand still in order to phase through \the [hit_atom]."))
		qdel(indicator)
		busy = FALSE
		return FALSE

	qdel(indicator)
	busy = FALSE

	if(!pay_energy(total_cost))
		to_chat(user, span("warning", "You don't have enough energy to phase through these walls!"))
		return FALSE

	playsound(user, 'sound/effects/magic/technomancer/teleport.ogg', 75, 1)

	var/datum/teleportation/recall/tele = new(user, found_turf)
	if(!tele.teleport())
		to_chat(user, span("warning", "Something along the way interfered with your attempt to phase through \the [hit_atom]."))
		return FALSE

	// At this point, we teleported.

	to_chat(user, span("notice", "You find a destination on the other side of \the [hit_atom], and phase through it."))
	adjust_instability(instability_cost)
	delete_after_cast = TRUE
	return TRUE
