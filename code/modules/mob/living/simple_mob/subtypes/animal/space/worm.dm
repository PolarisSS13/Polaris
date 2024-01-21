/mob/living/simple_mob/animal/space/space_worm
	name = "space worm segment"
	desc = "A part of a space worm."
	icon = 'icons/mob/worm.dmi'
	icon_state = "spaceworm"
	icon_living = "spaceworm"
	icon_dead = "spacewormdead"

	tt_desc = "U Tyranochaetus imperator"

	anchored = TRUE	// Theoretically, you shouldn't be able to move this without moving the head.

	maxHealth = 200
	health = 200
	movement_cooldown = 0

	faction = "worm"

	status_flags = 0
	universal_speak = 0
	universal_understand = 1
	animate_movement = SYNC_STEPS

	response_help  = "touches"
	response_disarm = "flails at"
	response_harm   = "punches the"

	harm_intent_damage = 2

	attacktext = list("slammed")

	organ_names = /decl/mob_organ_names/wormlike

	ai_holder_type = /datum/ai_holder/simple_mob/inert

	mob_class = MOB_CLASS_ABERRATION	// It's a monster.

	meat_amount = 2
	meat_type = /obj/item/reagent_containers/food/snacks/meat/worm

	internal_organs = list(\
		/obj/item/organ/internal/heart/grey,\
		/obj/item/organ/internal/intestine/xeno,\
		/obj/item/organ/internal/lungs/grey,\
		/obj/item/organ/internal/xenos/plasmavessel,\
		/obj/item/organ/internal/xenos/acidgland\
		)

	butchery_loot = list(\
		/obj/item/stack/animalhide = 3\
		)

	var/mob/living/simple_mob/animal/space/space_worm/previous //next/previous segments, correspondingly
	var/mob/living/simple_mob/animal/space/space_worm/next     //head is the nextest segment

	var/severed = FALSE	// Is this a severed segment?

	var/severed_head_type = /mob/living/simple_mob/animal/space/space_worm/head/severed	// What type of head do we spawn when detaching?
	var/segment_type = /mob/living/simple_mob/animal/space/space_worm	// What type of segment do our heads make?

	var/stomachProcessProbability = 50
	var/digestionProbability = 20
	var/flatPlasmaValue = 5 //flat Phoron amount given for non-items

	var/atom/currentlyEating // Worm's current Maw target.
	var/obj/item/stack/material/digested_sheet = /obj/item/stack/material/phoron	// Material sheet type produced from digestion. Default, phoron.

	var/z_transitioning = FALSE	// Are we currently moving between Z-levels, or doing something that might mean we can't rely on distance checking for segments?
	var/sever_chunks = FALSE	// Do we fall apart when dying?

	var/time_maw_opened = 0
	var/maw_cooldown = 30 SECONDS
	var/open_maw = FALSE	// Are we trying to eat things?
	var/charging = FALSE		// Are we charging?

/*
 * The head. Holds multiple abilities.
 */
/decl/mob_organ_names/wormlike
	hit_zones = list("annuli") //Worms.

/decl/mob_organ_names/wormhead
	hit_zones = list("annuli", "cephalon", "mouth") //Worms, again. This time the head or "cephalon" though.

/mob/living/simple_mob/animal/space/space_worm/head
	name = "space worm"
	icon_state = "spacewormhead"
	icon_living = "spacewormhead"

	anchored = FALSE	// You can pull the head to pull the body.

	maxHealth = 300
	health = 300

	hovering = TRUE

	ai_holder_type = /datum/ai_holder/simple_mob/destructive/worm

	melee_damage_lower = 10
	melee_damage_upper = 25
	attack_sharp = TRUE
	attack_edge = TRUE
	attack_armor_pen = 30
	attacktext = list("bitten", "gored", "gouged", "chomped", "slammed")

	// Charging is a special attack, based on the tunneler spiders' namesake ability.
	special_attack_min_range = 2
	special_attack_max_range = 6
	special_attack_cooldown = 30 SECONDS

	var/charge_warning = 0.5 SECONDS	// How long the dig telegraphing is.
	var/charge_tile_speed = 2			// How long to wait between each tile. Higher numbers result in an easier to charge attack.

	organ_names = /decl/mob_organ_names/wormhead

	internal_organs = list(\
		/obj/item/organ/internal/heart/grey,\
		/obj/item/organ/internal/intestine,\
		/obj/item/organ/internal/lungs/grey,\
		/obj/item/organ/internal/xenos/plasmavessel,\
		/obj/item/organ/internal/immunehub,\
		/obj/item/organ/internal/brain/grey\
		)

	animate_movement = SLIDE_STEPS

	var/segment_count = 6

/mob/living/simple_mob/animal/space/space_worm/head/apply_bonus_melee_damage(atom/A, damage_amount)
	if(istype(A, /turf) || istype(A, /obj/machinery/door))
		damage_amount *= 5
	else if(istype(A, /obj/mecha))
		damage_amount *= 1.5
	return damage_amount

/mob/living/simple_mob/animal/space/space_worm/head/severed
	segment_count = 0
	severed = TRUE

/mob/living/simple_mob/animal/space/space_worm/head/short
	segment_count = 3

/mob/living/simple_mob/animal/space/space_worm/head/long
	segment_count = 10

/mob/living/simple_mob/animal/space/space_worm/head/handle_special()
	..()
	update_body_states()

/mob/living/simple_mob/animal/space/space_worm/head/update_icon()
	..()
	if(!open_maw && !stat)
		icon_state = "[icon_living][previous ? 1 : 0]_hunt"
	else
		icon_state = "[icon_living][previous ? 1 : 0]"

	if(previous)
		set_dir(get_dir(previous,src))

	if(stat)
		icon_state = "[icon_state]_dead"

/mob/living/simple_mob/animal/space/space_worm/head/Initialize()
	. = ..()

	var/mob/living/simple_mob/animal/space/space_worm/current = src

	if(segment_count && !severed)
		for(var/i = 1 to segment_count)
			var/mob/living/simple_mob/animal/space/space_worm/newSegment = new segment_type(loc)
			current.Attach(newSegment)
			current = newSegment
			current.faction = faction

	update_body_states()

/mob/living/simple_mob/animal/space/space_worm/head/verb/toggle_devour()
	set name = "Toggle Feeding"
	set desc = "Extends your teeth for 30 seconds so that you can chew through mobs and structures alike."
	set category = "Abilities"

	if(world.time < time_maw_opened + maw_cooldown)
		if(open_maw)
			to_chat(src, "<span class='notice'>You retract your teeth.</span>")
			time_maw_opened -= maw_cooldown / 2	// Recovers half cooldown if you end it early manually.
		else
			to_chat(src, "<span class='notice'>You are too tired to do this..</span>")
		set_maw(FALSE)
	else
		set_maw(!open_maw)

/mob/living/simple_mob/animal/space/space_worm/head/should_special_attack(atom/A)
	if(world.time < time_maw_opened + maw_cooldown)
		return FALSE
	// Make sure its possible for the worm to reach the target.
	var/turf/destination = get_turf(A)
	var/turf/starting_turf = get_turf(src)
	var/turf/T = starting_turf
	for(var/i = 1 to get_dist(starting_turf, destination))
		if(T == destination)
			break

		T = get_step(T, get_dir(T, destination))
	return T == destination


/mob/living/simple_mob/animal/space/space_worm/head/do_special_attack(atom/A)
	set waitfor = FALSE
	set_AI_busy(TRUE)

	// Save where we're gonna go soon.
	var/turf/destination = get_turf(A)
	var/turf/starting_turf = get_turf(src)

	// Telegraph to give a small window to dodge if really close.
	set_maw(TRUE)
	do_windup_animation(A, charge_warning)
	sleep(charge_warning) // For the telegraphing.

	// Do the charge!
	visible_message(span("danger","\The [src] charges towards \the [A]!"))

	if(!handle_charge(destination))
		set_AI_busy(FALSE)
		return FALSE

	// Did we make it?
	if(!(src in destination))
		set_AI_busy(FALSE)
		return FALSE

	var/overshoot = TRUE

	// Test if something is at destination.
	for(var/mob/living/L in destination)
		if(L == src)
			continue

		visible_message(span("danger","\The [src] slams into \the [L]!"))
		playsound(src, 'sound/weapons/heavysmash.ogg', 75, 1)
		AttemptToEat(L)
		overshoot = FALSE

	if(!overshoot) // We hit the target, or something, at destination, so we're done.
		set_AI_busy(FALSE)
		return TRUE

	// Otherwise we need to keep going.
	var/dir_to_go = get_dir(starting_turf, destination)
	for(var/i = 1 to rand(2, max(4, tally_segments(0))))
		destination = get_step(destination, dir_to_go)

	handle_charge(destination)	// This is overshooting, we don't really care if we hit this destination so don't check the return, just move.

	set_AI_busy(FALSE)
	return FALSE



// Does the charge movement, stuns enemies, etc.
/mob/living/simple_mob/animal/space/space_worm/head/proc/handle_charge(turf/destination)
	var/turf/T = get_turf(src) // Hold our current tile.

	// Regular charge loop.
	for(var/i = 1 to get_dist(src, destination))
		if(stat)
			return FALSE // We died or got knocked out on the way.
		if(loc == destination)
			break // We somehow got there early.

		// Update T.
		T = get_step(src, get_dir(src, destination))
		Move(T)

		sleep(charge_tile_speed)
	set_maw(FALSE)

/*
 * Head end.
 */

/mob/living/simple_mob/animal/space/space_worm/proc/set_maw(var/state = FALSE)
	open_maw = state
	if(open_maw)
		time_maw_opened = world.time
		movement_cooldown = initial(movement_cooldown) + 1.5
	else
		movement_cooldown = initial(movement_cooldown)
	update_icon()

/mob/living/simple_mob/animal/space/space_worm/death()
	..()

	DumpStomach()

	if(previous)
		previous.death()

/mob/living/simple_mob/animal/space/space_worm/handle_special()	// Processed in life. Nicer to have it modular incase something in Life change(d)(s)
	..()

	if(world.time > time_maw_opened + maw_cooldown)	// Auto-stop eating.
		if(open_maw)
			to_chat(src, "<span class='notice'>Your jaws cannot remain open..</span>")
			set_maw(FALSE)

	if(next && !(next in view(src,1)) && !z_transitioning)
		Detach(1)

	if(stat == DEAD && sever_chunks) // Dead chunks fall off and die immediately if we sever_chunks
		if(previous)
			previous.Detach(1)
		if(next)
			Detach(1)

	if(prob(stomachProcessProbability))
		ProcessStomach()

	update_icon()

	return

/mob/living/simple_mob/animal/space/space_worm/CanPass(atom/movable/mover, turf/target)
	if(istype(mover, /mob/living/simple_mob/animal/space/space_worm/head))
		var/mob/living/simple_mob/animal/space/space_worm/head/H = mover
		if(H.previous == src)
			return FALSE

	if(istype(mover, /mob/living/simple_mob/animal/space/space_worm))	// Worms don't run over worms. That's weird. And also really annoying.
		return TRUE
	if(src.stat == DEAD && !istype(mover, /obj/item/projectile))	// Projectiles need to do their normal checks.
		return TRUE
	return ..()

/mob/living/simple_mob/animal/space/space_worm/Destroy() // If a chunk is destroyed, kill the back half.
	DumpStomach()
	if(previous)
		previous.Detach(1)
	if(next)
		next.previous = null
		next = null
	..()

/mob/living/simple_mob/animal/space/space_worm/Moved(atom/old_loc, direction, forced = FALSE)
	. = ..()
	if(previous)
		if(previous.z != z)
			previous.z_transitioning = TRUE
		else
			previous.z_transitioning = FALSE
		previous.forceMove(old_loc)	// None of this 'ripped in half by an airlock' business.

	if(open_maw)
		for(var/atom/movable/AM in get_turf(src))
			if(!AM.anchored && prob(30))
				AttemptToEat(AM)

	update_icon()

/mob/living/simple_mob/animal/space/space_worm/head/Bump(atom/obstacle)
	if(open_maw && !stat && obstacle != previous)
		spawn(1)
			if(currentlyEating != obstacle)
				currentlyEating = obstacle

			if(!charging)
				set_AI_busy(TRUE)
			if(AttemptToEat(obstacle))
				currentlyEating = null
			if(!charging)
				set_AI_busy(FALSE)
	else
		currentlyEating = null
		. = ..(obstacle)

/mob/living/simple_mob/animal/space/space_worm/update_icon()
	if(previous) //midsection
		icon_state = "spaceworm[get_dir(src,previous) | get_dir(src,next)]"
		if(stat)
			icon_state = "[icon_state]_dead"

	else //tail
		icon_state = "spacewormtail"
		if(stat)
			icon_state = "[icon_state]_dead"
		set_dir(get_dir(src,next))

	if(next)
		color = next.color

	return

/mob/living/simple_mob/animal/space/space_worm/proc/AttemptToEat(var/atom/target)
	if(istype(target,/turf/simulated/wall))
		var/turf/simulated/wall/W = target
		if((!W.reinf_material && do_after(src, 5 SECONDS)) || do_after(src, 10 SECONDS)) // 10 seconds for an R-wall, 5 seconds for a normal one.
			if(target)
				W.dismantle_wall()
				return TRUE
	else if(istype(target,/atom/movable))
		if(istype(target,/mob) || do_after(src, 5)) // 5 ticks to eat stuff like tables.
			var/atom/movable/objectOrMob = target
			if(istype(objectOrMob, /obj/machinery/door))	// Doors and airlocks take time based on their durability and our damageo.
				var/obj/machinery/door/D = objectOrMob
				var/total_hits = max(2, round(D.maxhealth / (2 * melee_damage_upper)))

				for(var/I = 1 to total_hits)

					if(!D)
						objectOrMob = null
						break

					if(do_after(src, 5))
						D.visible_message("<span class='danger'>Something crashes against \the [D]!</span>")
						D.take_damage(2 * melee_damage_upper)
					else
						objectOrMob = null
						break

					if(D && (D.stat & BROKEN|NOPOWER))
						D.open(TRUE)
						D.update_nearby_tiles(need_rebuild=1)
						return TRUE

			if(istype(objectOrMob, /obj/effect/energy_field))
				var/obj/effect/energy_field/EF = objectOrMob
				objectOrMob = null	// No eating shields.
				if(EF.opacity)
					EF.visible_message("<span class='danger'>Something begins forcing itself through \the [EF]!</span>")
				else
					EF.visible_message("<span class='danger'>\The [src] begins forcing itself through \the [EF]!</span>")
				if(do_after(src, EF.strength * 5))
					EF.adjust_strength(rand(-8, -10))
					EF.visible_message("<span class='danger'>\The [src] crashes through \the [EF]!</span>")
				else
					EF.visible_message("<span class='danger'>\The [EF] reverberates as it returns to normal.</span>")

			if(istype(objectOrMob, /obj/machinery/shieldwall))	// This shield type is explicitly a containment field, and if you somehow get a worm inside this, congrats.
				return FALSE

			if(objectOrMob)
				objectOrMob.update_nearby_tiles(need_rebuild=1)
				objectOrMob.forceMove(src)
				return TRUE

	return FALSE

/mob/living/simple_mob/animal/space/space_worm/proc/Attach(var/mob/living/simple_mob/animal/space/space_worm/attachement)
	if(!attachement)
		return

	previous = attachement
	attachement.next = src

	return

/mob/living/simple_mob/animal/space/space_worm/proc/Detach(die = 0)
	var/mob/living/simple_mob/animal/space/space_worm/head/newHead = new severed_head_type(loc,0)
	var/mob/living/simple_mob/animal/space/space_worm/newHeadPrevious = previous

	previous = null //so that no extra heads are spawned

	newHead.Attach(newHeadPrevious)

	if(die)
		newHead.death()

	qdel(src)

/mob/living/simple_mob/animal/space/space_worm/proc/ProcessStomach()
	for(var/atom/movable/stomachContent in contents)
		if(stomach_special(stomachContent))
			continue
		if(prob(digestionProbability))
			if(stomach_special_digest(stomachContent))
				continue
			if(istype(stomachContent,/obj/item/stack)) //converts to plasma, keeping the stack value
				if(!istype(stomachContent,digested_sheet))
					var/obj/item/stack/oldStack = stomachContent
					new digested_sheet(src, oldStack.get_amount())
					qdel(oldStack)
					continue
			else if(istype(stomachContent,/obj/item)) //converts to plasma, keeping the w_class
				var/obj/item/oldItem = stomachContent
				if(oldItem.unacidable)
					continue
				new digested_sheet(src, oldItem.w_class)
				qdel(oldItem)
				continue
			else
				new digested_sheet(src, flatPlasmaValue) //just flat amount
				if(!isliving(stomachContent))
					qdel(stomachContent)
				else
					var/mob/living/L = stomachContent
					if(iscarbon(L))
						var/mob/living/carbon/C = L
						var/damage_cycles = rand(3, 5)
						for(var/I = 0, I < damage_cycles, I++)
							C.apply_damage(damage = rand(10,20), damagetype = BIOACID, def_zone = pick(BP_ALL))
					else
						L.apply_damage(damage = rand(10,60), damagetype = BIOACID)
				continue

	DumpStomach()

	return

/mob/living/simple_mob/animal/space/space_worm/proc/DumpStomach()
	if(previous && previous.stat != DEAD)
		for(var/atom/movable/stomachContent in contents) //transfer it along the digestive tract
			stomachContent.forceMove(previous)
	else
		for(var/atom/movable/stomachContent in contents) // Or dump it out.
			stomachContent.forceMove(get_turf(src))
	return

/mob/living/simple_mob/animal/space/space_worm/proc/stomach_special(var/atom/A)	// Futureproof. Anything that interacts with contents without relying on digestion probability. Return TRUE if it should skip digest.
	if(istype(A, /mob/living/simple_mob))
		var/mob/living/simple_mob/SM = A
		if(!SM.ckey)	// Players can always fight back.
			SM.Stun(3)
	return FALSE

/mob/living/simple_mob/animal/space/space_worm/proc/stomach_special_digest(var/atom/A)	// Futureproof. Any special checks that interact with digested atoms. I.E., ore processing. Return TRUE if it should skip future digest checks.
	if(istype(A, /obj/mecha))
		var/obj/mecha/ME = A
		ME.take_damage(rand(10,60), "bio")
		return TRUE
	return FALSE

/mob/living/simple_mob/animal/space/space_worm/proc/update_body_states()
	if(next)	// Keep us on the same page, here.
		if(mob_class != next.mob_class)
			mob_class = next.mob_class
		if(plane != next.plane)
			plane = next.plane
		if(invisibility != next.invisibility)
			invisibility = next.invisibility
		if(meat_type != next.meat_type)
			meat_type = next.meat_type
		if(severed_head_type != next.severed_head_type)
			severed_head_type = next.severed_head_type
		if(segment_type != next.segment_type)
			segment_type = next.segment_type
		if(digested_sheet != next.digested_sheet)
			digested_sheet = next.digested_sheet
		if(tt_desc != next.tt_desc)
			tt_desc = next.tt_desc
		if(faction != next.faction)
			faction = next.faction
		if(icon != next.icon)
			icon = next.icon

		// Handle damage distribution, if we're alive. Dead segments are dead weight.
		// If the next headward segment has more damage, take some of the damage to ourself.
		if(stat != DEAD)
			if(next.bruteloss > bruteloss)
				var/change = round((next.bruteloss - bruteloss) / 2)
				next.adjustBruteLoss(-change)
				adjustBruteLoss(change)

			if(next.fireloss > fireloss)
				var/change = round((next.fireloss - fireloss) / 2)
				next.adjustFireLoss(-change)
				adjustFireLoss(change)

	if(previous)
		previous.update_body_states()
		return 1
	return 0

// Returns the number of segments.
/mob/living/simple_mob/animal/space/space_worm/proc/tally_segments(var/count = 0)
	count++
	if(previous)
		return previous.tally_segments(count)
	return count

// Worm meat.

/obj/item/reagent_containers/food/snacks/meat/worm
	name = "meat"
	desc = "A chunk of pulsating meat."
	icon_state = "wormmeat"
	health = 180
	filling_color = "#551A8B"
	center_of_mass = list("x"=16, "y"=14)

/obj/item/reagent_containers/food/snacks/meat/worm/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)
	reagents.add_reagent("phoron", 3)
	reagents.add_reagent("myelamine", 3)
	src.bitesize = 3

/obj/item/reagent_containers/food/snacks/meat/worm/attackby(obj/item/W as obj, mob/user as mob)
	if(is_sharp(W))
		var/to_spawn = pickweight(/obj/random/junk = 30,
		/obj/random/trash = 30,
		/obj/random/maintenance/clean = 15,
		/obj/random/tool = 15,
		/obj/random/medical = 3,
		/obj/random/bomb_supply = 7,
		/obj/random/contraband = 3,
		/obj/random/unidentified_medicine/old_medicine = 7,
		/obj/item/strangerock = 3,
		/obj/item/ore/phoron = 7,
		/obj/random/handgun = 1,
		/obj/random/toolbox = 4,
		/obj/random/drinkbottle = 5
		)

		new to_spawn(get_turf(src))

		if(prob(20))
			user.visible_message("<span class='alien'>Something oozes out of \the [src] as it is cut.</span>")

		to_chat(user, "<span class='alien'>You cut the tissue holding the chunks together.</span>")

	..()

/*
 * AI
 */

/datum/ai_holder/simple_mob/destructive/worm
	can_demolish = TRUE
	ignore_opacity = TRUE

/datum/ai_holder/simple_mob/destructive/worm/intelligent
	astar_adjacent_proc = /turf/proc/CardinalTurfsWithAccessNoDensity
	use_astar = TRUE
