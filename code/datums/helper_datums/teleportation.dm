// Holds various procs for teleporting and checking if teleporting should be allowed.

/datum/teleportation
	var/atom/movable/teleported_AM = null // AM to teleport.
	var/turf/destination = null // Place that the teleport is aimed at. Inaccuracy can make this not be where the AM ends up going.

	// Teleport modifiers.
	var/inaccuracy = 0 // If higher than 0, teleporting can vary by this many tiles.
	var/teleport_buckled = TRUE // If true, attempts to teleport things that someone is buckled to, if unanchored. Otherwise always unbuckles them.
	var/teleport_grabbed = TRUE // If true, humans with a grab on someone will bring the grabbed person along with them if possible.
	var/teleport_all_unanchored = FALSE // If true, everything on the same tile that's not anchored will be brought along.

	// Sounds and effects.
	var/sound_exited = null // A sound to play at the teleporting AM just before the teleport.
	var/sound_entered = null // Ditto, but plays just after teleporting.

	var/teleport_effect_exited_path = null // A path to a (preferably `/obj/effect/temp_visual`) object to spawn when teleporting.
	var/teleport_effect_entered_path = null // Ditto.

	var/visible_message_exited = null // If not null, a `visible_message()` is done, with the format "\The [teleported_AM] [text goes here]".
	var/visible_message_entered = null

	// Teleporting restrictions.
	var/ignore_block_tele_turf = FALSE // Determines if turfs that block teleportation will block or not.
	var/ignore_block_tele_mob = FALSE // Some mob things can block teleporting, like holding specific items or modifiers.
	var/ignore_admin_z = FALSE // If true, can be used on admin z-levels.
	var/ignore_density = FALSE // If true, dense turfs are ignored and things can be teleported into walls.
	var/ignore_safety = TRUE // If a living mob is being teleported, it will check that the destination is 'safe'.

/datum/teleportation/New(atom/movable/new_teleportee, turf/new_destination)
	teleported_AM = new_teleportee
	destination = new_destination


/datum/teleportation/blink
	visible_message_exited = "vanishes!"
	visible_message_entered = "suddenly appears!"

	sound_exited = 'sound/effects/magic/technomancer/blink.ogg'
	sound_entered = 'sound/effects/magic/technomancer/blink.ogg'

	teleport_effect_exited_path = /obj/effect/temp_visual/phase_out
	teleport_effect_entered_path = /obj/effect/temp_visual/phase_in

/datum/teleportation/apportation
	visible_message_exited = "vanishes into thin air!"

	sound_exited = 'sound/effects/magic/technomancer/teleport_diss.ogg'
	sound_entered = 'sound/effects/magic/technomancer/teleport_app.ogg'

	teleport_effect_exited_path = /obj/effect/temp_visual/phase_out
	teleport_effect_entered_path = /obj/effect/temp_visual/phase_in

/datum/teleportation/banish_out
	teleport_effect_exited_path = /obj/effect/temp_visual/phase_out
	sound_exited = 'sound/effects/magic/technomancer/teleport_diss.ogg'
	visible_message_exited = "disappears in an instant!"

	ignore_block_tele_turf = TRUE

/datum/teleportation/banish_in
	teleport_all_unanchored = TRUE // So things don't get left behind in the 'void'.
	ignore_admin_z = TRUE
	ignore_block_tele_turf = TRUE

	teleport_effect_entered_path = /obj/effect/temp_visual/phase_in
	sound_entered = 'sound/effects/magic/technomancer/teleport_app.ogg'
	visible_message_entered = "suddenly re-appears!"

/datum/teleportation/recall
	visible_message_exited = "vanishes!"
	visible_message_entered = "suddenly appears!"

	sound_exited = 'sound/effects/magic/technomancer/teleport_diss.ogg'
	sound_entered = 'sound/effects/magic/technomancer/teleport_app.ogg'

	teleport_effect_exited_path = /obj/effect/temp_visual/phase_out
	teleport_effect_entered_path = /obj/effect/temp_visual/phase_in


/atom/movable/proc/can_teleport()
	return TRUE

/mob/living/can_teleport()
	for(var/datum/modifier/M in modifiers)
		if(M.block_tele)
			return FALSE
	return ..()

/datum/teleportation/proc/allowed_to_teleport()
	if(ignore_block_tele_mob || teleported_AM.can_teleport())
		// Check the tile the person is on.
		// The destination tile is checked later.
		return can_tele_to_turf(get_turf(teleported_AM), FALSE)
	return FALSE

/datum/teleportation/proc/can_tele_to_turf(turf/T, is_target = TRUE)
	if(!istype(T))
		return FALSE // Nullspace pls go.

	if(!ignore_block_tele_turf && T.block_tele)
		return FALSE // Some turfs block teleports from going outward (and also inward).

	if(!ignore_admin_z && (T.z in using_map.admin_levels))
		return FALSE // Admin z-levels typically block teleporting if the teleport isn't very specific like the teleporter machine's beacons.

	if(is_target) // Don't worry about these if this tile being checked is the one that the AM is gonna leave from.
		if(!ignore_density && T.check_density(ignore_mobs = TRUE))
			return FALSE // Don't teleport into walls.

		if(!ignore_safety && isliving(teleported_AM) && !istype(T, /turf/space) && !T.is_safe_to_enter(teleported_AM))
			return FALSE // Don't teleport into lava/space/open tile.

	return TRUE

// Called when teleporting out of somewhere.
/datum/teleportation/proc/tele_out_effects()
	if(sound_exited)
		playsound(teleported_AM, sound_exited, 75, 1)
	if(teleport_effect_exited_path)
		new teleport_effect_exited_path(get_turf(teleported_AM))
	if(visible_message_exited)
		teleported_AM.visible_message(span("notice", "\The [teleported_AM] [visible_message_exited]"))

// Does the actual teleportation.
// Note that this will always succeed, do the checks before calling this.
/datum/teleportation/proc/do_teleport()
	if(isliving(teleported_AM))
		var/mob/living/L = teleported_AM
		if(L.buckled)
			if(L.buckled.anchored || !teleport_buckled)
				L.buckled.unbuckle_mob()
			else
				// Bring the chair/roller bed/etc with them.
				L.buckled.forceMove(destination)

	if(teleport_all_unanchored)
		for(var/atom/movable/AM in get_turf(teleported_AM))
			if(AM.anchored)
				continue
			AM.forceMove(destination)

	teleported_AM.forceMove(destination)

// Called just after the teleport succeeds.
/datum/teleportation/proc/tele_in_effects()
	if(sound_entered)
		playsound(teleported_AM, sound_entered, 75, 1)
	if(teleport_effect_entered_path)
		new teleport_effect_entered_path(get_turf(teleported_AM))
	if(visible_message_entered)
		teleported_AM.visible_message(span("notice", "\The [teleported_AM] [visible_message_entered]"))

/datum/teleportation/proc/choose_destination(turf/destination_epicenter, potential_offset)
	var/list/candidates = circlerangeturfs(destination_epicenter, potential_offset)
	candidates = shuffle(candidates)
	var/turf/final_destination = null // No items, Fox only.

	for(var/thing in candidates)
		var/turf/T = thing
		if(!can_tele_to_turf(T))
			continue
		final_destination = T
		break

	if(final_destination)
		destination = final_destination

// Attempts to teleport the AM. Returns TRUE if it succeeded, FALSE otherwise.
/datum/teleportation/proc/teleport()
	if(!teleported_AM.can_teleport() || !can_tele_to_turf(get_turf(teleported_AM), FALSE))
		return FALSE

	if(inaccuracy > 0)
		choose_destination(destination, inaccuracy)

	if(!can_tele_to_turf(destination))
		return FALSE

	tele_out_effects()

	do_teleport()

	tele_in_effects()
	return TRUE

