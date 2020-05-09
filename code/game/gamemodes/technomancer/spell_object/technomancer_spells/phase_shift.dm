// Uses vis_contents to make the phase shift object look like the user.

/datum/technomancer_catalog/spell/phase_shift
	name = "Phase Shift"
	cost = 50
	category = DEFENSIVE_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/phase_shift)

/datum/spell_metadata/phase_shift
	name = "Phase Shift"
	desc = "Partially shifts your form in such a way that makes most physical interactions pass \
	through yourself, making you very resilient to harm. You are slowed considerably while in this form, however. \
	Special care has been done to ensure you still collide with the walls and floors, so \
	you won't sink through the floor due to gravity."
	aspect = ASPECT_TELE
	icon_state = "tech_phase_shift"
	spell_path = /obj/item/weapon/spell/technomancer/phase_shift
	cooldown = 20 SECONDS

/datum/spell_metadata/phase_shift/get_spell_info()
	var/obj/item/weapon/spell/technomancer/phase_shift/spell = spell_path
	. = list()
	.["Phase Shift Duration"] = DisplayTimeText(initial(spell.shift_duration))
	.["Energy Cost"] = initial(spell.shift_energy_cost)
	.["Instability Cost"] = initial(spell.shift_instability_cost)

/obj/item/weapon/spell/technomancer/phase_shift
	name = "phase shift"
	desc = "Allows you to dodge your untimely fate by shifting your location somewhere else."
	icon_state = "blink"
	cast_methods = CAST_INNATE
	var/shift_duration = 5 SECONDS
	var/shift_energy_cost = 1000
	var/shift_instability_cost = 20

/obj/item/weapon/spell/technomancer/phase_shift/on_innate_cast(mob/living/user)
	if(istype(user.loc, /obj/effect/phase_shift))
		qdel(user.loc) // Juuuuuust in case.
		return TRUE

	if(!pay_energy(shift_energy_cost))
		to_chat(user, span("warning", "You can't afford to phase shift!"))
		return FALSE

	var/datum/teleportation/phase_shift_in/tele = new(user, get_turf(user))
	if(!tele.teleport())
		to_chat(user, span("warning", "Something is preventing you from phase shifting out..."))
		return FALSE

	adjust_instability(shift_instability_cost)
	playsound(owner, 'sound/effects/magic/technomancer/generic_cast.ogg', 75, 1)

	var/obj/effect/phase_shift/shift = new(get_turf(user), user)
	user.forceMove(shift)
	QDEL_IN(shift, shift_duration)
	return TRUE


/obj/effect/phase_shift
	name = "rift"
	desc = "The visage of someone that can't currently be touched by most physical interactions."
	icon = null // This uses vis_contents to look like a purple technomancer.
	alpha = 50
	var/mob/living/occupant = null
	var/movement_multiplier = 1.5 // How much to multiply movement cooldowns by. Numbers above 1.0 make moving slower, and under 1.0 makes them go faster.
	var/next_movement_time = null // world.time the object can be moved again by the occupant.


/obj/effect/phase_shift/ex_act()
	return

/obj/effect/phase_shift/Initialize(mapload, new_occupant)
	occupant = new_occupant
	name = "phase shifted [occupant.name]"
	occupant.add_modifier(/datum/modifier/phase_shifted)
	vis_contents += new_occupant

	set_light(3, 5, l_color = "#FA58F4")
	color = "#FA58F4"

	return ..()

/obj/effect/phase_shift/Destroy()
	if(occupant)
		vis_contents -= occupant
		occupant.forceMove(get_turf(src))
		occupant.remove_modifiers_of_type(/datum/modifier/phase_shifted)
		occupant.reset_view() // So their screen doesn't go black until the next `Life()` tick.

		var/datum/teleportation/phase_shift_out/tele = new(occupant, get_turf(src))
		tele.teleport() // This shouldn't fail, but we don't care if it does since its just visuals.

	for(var/atom/movable/AM in contents) // In case they dropped something while inside.
		AM.forceMove(get_turf(src))

	return ..()


/obj/effect/phase_shift/relaymove(mob/living/user, direction)
	user.set_dir(direction)
	if(world.time < next_movement_time)
		return FALSE

	var/turf/oldloc = get_turf(user)

	. = Move(get_step(loc, direction), direction)
	if(.)
		var/movement_delay = movement_multiplier * (config.run_speed + user.movement_delay(oldloc, direction))
		next_movement_time = world.time + movement_delay

/datum/modifier/phase_shifted
	name = "phase shifted"
	desc = "You mostly can't interact with the world, and the world mostly can't interact with you."

	client_color = "#FA58F4"
