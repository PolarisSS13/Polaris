/obj/effect/timestop
	name = "chronofield"
	desc = "ZA WARUDO" //no one is gonna see it, since you can't examine the field BUT STILL
	icon = 'icons/effects/timestop.dmi'
	icon_state = "time"
	layer = FLY_LAYER
	pixel_x = -64
	pixel_y = -64
	unacidable = 1
	mouse_opacity = 0
	var/mob/living/immune = list() // the one who creates the timestop is immune
	var/list/stopped_atoms = list()
	var/freezerange = 2
	var/duration = 150
	alpha = 125

/obj/effect/timestop/New()
	processing_objects |= src
	..()


/obj/effect/timestop/process()
	for(var/obj/item/A in range(freezerange, loc))
		var/obj/item/P = A
		P.suspended = 1
		stopped_atoms |= P

/obj/effect/timestop/Destroy()
	playsound(get_turf(src), 'sound/misc/TIMEPARADOX2.ogg', 100, 1, -1) //reverse!
	processing_objects -= src
	return ..()


/obj/effect/timestop/proc/timestop()
	playsound(get_turf(src), 'sound/misc/TIMEPARADOX2.ogg', 100, 1, 1)
	for(var/i in 1 to duration-1)
		for(var/A in range(freezerange, loc))
			if(isliving(A))
				var/mob/living/M = A
				if(M in immune)
					continue
				M.anchored = 1
				M.AdjustStunned(1)
				if(istype(M, /mob/living/simple_animal/hostile))
					var/mob/living/simple_animal/hostile/H = M
					H.ai_inactive = 1
					H.LoseTarget()
				stopped_atoms |= M
			else if(istype(A, /obj/item))
				var/obj/item/P = A
				P.suspended = 1
				stopped_atoms |= P

		for(var/mob/living/M in stopped_atoms)
			if(get_dist(get_turf(M),get_turf(src)) > freezerange) //If they lagged/ran past the timestop somehow, just ignore them
				unfreeze_mob(M)
				stopped_atoms -= M
		sleep(1)

	//End
	for(var/mob/living/M in stopped_atoms)
		unfreeze_mob(M)

	for(var/obj/item/A in stopped_atoms)
		var/obj/item/P = A
		P.suspended = 0
		P.process() //re-start projectile's movement
	qdel(src)
	return


/obj/effect/timestop/proc/unfreeze_mob(mob/living/M)
	M.anchored = 0
	M.AdjustStunned(-1.5 * duration)
	if(istype(M, /mob/living/simple_animal/hostile))
		var/mob/living/simple_animal/hostile/H = M
		H.ai_inactive = 0


/obj/effect/timestop/wizard
	duration = 200

/obj/effect/timestop/wizard/New()
	..()
	timestop()

/obj/effect/timestop/stopwatch
	duration = 80

/obj/effect/timestop/stopwatch/New()
	..()
	timestop()
