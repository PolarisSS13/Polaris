/datum/ai_holder
	var/path_display = FALSE			// Displays a visual path when A* is being used.
	var/path_icon = 'icons/misc/debug_group.dmi' // What icon to use for the overlay
	var/path_icon_state = "red"		// What state to use for the overlay
	var/image/path_overlay			// A reference to the overlay

/datum/ai_holder/New()
	..()
	path_overlay = new(path_icon,path_icon_state)

/datum/ai_holder/Destroy()
	path_overlay = null
	return ..()



// Remove this when finished.

/mob/living/simple_animal/corgi
	ai_holder_type = /datum/ai_holder/test

/datum/ai_holder/hostile/ranged
	ranged = TRUE
	cooperative = TRUE
	firing_lanes = TRUE
	conserve_ammo = TRUE
	threaten = TRUE

	threaten_sound = 'sound/weapons/TargetOn.ogg'
	stand_down_sound = 'sound/weapons/TargetOff.ogg'

/mob/living/simple_animal/hostile/pirate
	hostile = FALSE
	ai_inactive = TRUE
	ai_holder_type = /datum/ai_holder/hostile/ranged

/datum/ai_holder/hostile/ranged/robust/on_engagement(atom/movable/AM)
	step_rand(holder)
	holder.face_atom(AM)