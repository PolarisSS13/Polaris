// AIs for simple mobs.

/datum/ai_holder/simple_mob
	hostile = TRUE // The majority of simplemobs are hostile.
	cooperative = TRUE
	returns_home = TRUE
	can_flee = FALSE
	speak_chance = 1 // If the mob's saylist is empty, nothing will happen.

// For animals.
/datum/ai_holder/simple_mob/passive
	hostile = FALSE
	wander = TRUE
	can_flee = TRUE

// Ranged mobs.

/datum/ai_holder/simple_mob/ranged
	ranged = TRUE

// Tries to not waste ammo.
/datum/ai_holder/simple_mob/ranged/careful
	conserve_ammo = TRUE

// Runs away from its target if within a certain distance.
/datum/ai_holder/simple_mob/ranged/kiting
	pointblank = TRUE // So we don't need to copypaste post_melee_attack().
	var/run_if_this_close = 4 // If anything gets within this range, it'll try to move away.

/datum/ai_holder/simple_mob/ranged/kiting/threatening
	threaten = TRUE
	threaten_delay = 1 SECOND // Less of a threat and more of pre-attack notice.
	threaten_timeout = 30 SECONDS

/datum/ai_holder/simple_mob/ranged/kiting/post_ranged_attack(atom/A)
	if(get_dist(holder, A) < run_if_this_close)
		holder.IMove(get_step_away(holder, A, run_if_this_close))
		holder.face_atom(A)


// Melee mobs.

/datum/ai_holder/simple_mob/melee

// Dances around the enemy its fighting, making it harder to fight back.
/datum/ai_holder/simple_mob/melee/evasive

/datum/ai_holder/simple_mob/melee/evasive/post_melee_attack(atom/A)
	if(holder.Adjacent(A))
		holder.IMove(get_step(holder, pick(alldirs)))
		holder.face_atom(A)

// The AI for hooligan crabs. Follows people for awhile.
/datum/ai_holder/simple_mob/melee/hooligan
	hostile = FALSE
	retaliate = TRUE
	max_home_distance = 12
	var/random_follow = TRUE // Turn off if you want to bus with crabs.

/datum/ai_holder/simple_mob/melee/hooligan/handle_stance_strategical()
	..()
	if(random_follow && stance == STANCE_IDLE && !leader)
		if(prob(10))
			for(var/mob/living/L in hearers(holder))
				if(!istype(L, holder)) // Don't follow other hooligan crabs.
					holder.visible_message("<span class='notice'>\The [holder] starts to follow \the [L].</span>")
					set_follow(L, rand(20 SECONDS, 40 SECONDS))


// The AI for nurse spiders. Wraps things in webs by 'attacking' them.
/datum/ai_holder/simple_mob/melee/nurse_spider
	wander = TRUE
	base_wander_delay = 8

// Get us unachored objects as an option as well.
/datum/ai_holder/simple_mob/melee/nurse_spider/list_targets()
	. = ..()

	var/static/alternative_targets = typecacheof(list(/obj/item, /obj/structure))

	for(var/AT in typecache_filter_list(range(vision_range, holder), alternative_targets))
		var/obj/O = AT
		if(can_see(holder, O, vision_range) && !O.anchored)
			. += O

// Select an obj if no mobs are around.
/datum/ai_holder/melee/nurse_spider/pick_target(list/targets)
	var/mobs_only = locate(/mob/living) in targets // If a mob is in the list of targets, then ignore objects.
	if(mobs_only)
		for(var/A in targets)
			if(!isliving(A))
				targets -= A

	return ..(targets)

/datum/ai_holder/simple_mob/melee/nurse_spider/can_attack(atom/movable/the_target)
	. = ..()
	if(!.) // Parent returned FALSE.
		if(istype(the_target, /obj))
			var/obj/O = the_target
			if(!O.anchored)
				return TRUE

/*



/datum/ai_holder/simple_mob/melee/nurse_spider/list_targets()
	var/list/targets = ..()

	if(targets.len) // Do regular targeting if there's actual enemies.
		world << "Returned early."
		world << "targets was [english_list(targets)]."
		return targets

	// Otherwise lets target objects to web them.
	var/static/webbable_types = typecacheof(list(/obj/machinery, /obj/item/, /obj/structure))
	for(var/WT in typecache_filter_list(range(vision_range, holder), webbable_types))
		var/obj/O = WT
		if(!O.anchored && can_see(holder, O, vision_range))
			targets += WT

	world << "targets was [english_list(targets)]."
	return targets
*/
/*
/datum/ai_holder/simple_mob/melee/nurse_spider/can_attack(atom/movable/the_target)
	. = ..()
	if(!.) // Parent returned FALSE.
		if(istype(the_target, /obj))
			var/obj/O = the_target
			if(!O.anchored)
				return TRUE
*/

/*
	. = hearers(vision_range, holder) - src // Remove ourselves to prevent suicidal decisions.

	var/static/hostile_machines = typecacheof(list(/obj/machinery/porta_turret, /obj/mecha))

	for(var/HM in typecache_filter_list(range(vision_range, holder), hostile_machines))
		if(can_see(holder, HM, vision_range))
			. += HM
*/