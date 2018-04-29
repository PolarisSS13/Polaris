// Tunnelers have a special ability that allows them to charge at an enemy by tunneling towards them.
// Any mobs inbetween the tunneler's path and the target will be stunned if the tunneler hits them.
// The target will suffer a stun as well, if the tunneler hits them at the end. A successful hit will stop the tunneler.
// If the target moves fast enough, the tunneler can miss, causing it to overshoot.
// If the tunneler hits a solid wall, the tunneler will suffer a stun.

/mob/living/simple_mob/animal/giant_spider/tunneler
	desc = "Sandy and brown, it makes you shudder to look at it. This one has glittering yellow eyes."
	icon_state = "tunneler"
	icon_living = "tunneler"
	icon_dead = "tunneler_dead"

	maxHealth = 120
	health = 120

	melee_damage_lower = 10
	melee_damage_upper = 20

	poison_chance = 15
	poison_per_bite = 3
	poison_type = "serotrotium_v"

//	ai_holder_type = /datum/ai_holder/simple_mob/melee/tunneler

	player_msg = "You <b>can perform a tunneling attack</b> by clicking on someone from a distance while on natural terrain.<br>\
	There is a noticable travel delay as you tunnel towards the tile the target was at when you started the tunneling attack.<br>\
	Any entities inbetween you and the targeted tile will be stunned for a brief period of time.<br>\
	Whatever is on the targeted tile when you arrive will suffer a potent stun.<br>\
	If nothing is on the targeted tile, you will overshoot and keep going for a few more tiles.<br>\
	If you hit a wall or other solid structure during that time, you will suffer a lengthy stun."

	// Tunneling is a special attack, similar to the hunter's Leap.
	special_attack_min_range = 2
	special_attack_max_range = 6
	special_attack_cooldown = 10 SECONDS

	var/tunnel_warning = 0.5 SECONDS	// How long the dig telegraphing is.
	var/tunnel_tile_speed = 2			// How long to wait between each tile. Higher numbers result in an easier to dodge tunnel attack.

/mob/living/simple_mob/animal/giant_spider/tunneler/frequent
	special_attack_cooldown = 5 SECONDS

/mob/living/simple_mob/animal/giant_spider/tunneler/fast
	tunnel_tile_speed = 1

/mob/living/simple_mob/animal/giant_spider/tunneler/do_special_attack(atom/A)
	set waitfor = FALSE
	set_AI_busy(TRUE)

	// Save where we're gonna go soon.
	var/turf/destination = get_turf(A)
	var/turf/starting_turf = get_turf(src)

	// Telegraph to give a small window to dodge if really close.
	do_windup_animation(A, tunnel_warning)
	sleep(tunnel_warning) // For the telegraphing.

	// Do the dig!
	visible_message(span("danger","\The [src] tunnels towards \the [A]!"))

	if(handle_tunnel(destination) == FALSE)
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

		visible_message(span("danger","\The [src] erupts from underneath, and hits \the [L]!"))
		L.Weaken(3)
		overshoot = FALSE

	if(!overshoot) // We hit the target, or something, at destination, so we're done.
		set_AI_busy(FALSE)
		return TRUE

	// Otherwise we need to keep going.
	to_chat(src, span("warning", "You overshoot your target!"))
	playsound(src, 'sound/weapons/punchmiss.ogg', 75, 1)
	var/dir_to_go = get_dir(starting_turf, destination)
	for(var/i = 1 to rand(2, 4))
		destination = get_step(destination, dir_to_go)

	if(handle_tunnel(destination) == FALSE)
		set_AI_busy(FALSE)
		return FALSE

	set_AI_busy(FALSE)
	return FALSE



// Does the tunnel movement, stuns enemies, etc.
/mob/living/simple_mob/animal/giant_spider/tunneler/proc/handle_tunnel(turf/destination)
	var/turf/T = get_turf(src) // Hold our current tile.

	// Regular tunnel loop.
	for(var/i = 1 to get_dist(src, destination))
		if(stat)
			return FALSE // We died or got knocked out on the way.
		if(loc == destination)
			break // We somehow got there early.

		// Update T.
		T = get_step(src, get_dir(src, destination))
		if(T.check_density(ignore_mobs = TRUE))
			to_chat(src, span("critical", "You hit something really solid!"))
			playsound(src, "punch", 75, 1)
			Weaken(5)
			return FALSE // Hit a wall.

		// Stun anyone in our way.
		for(var/mob/living/L in T)
			L.Weaken(2)

		// Get into the tile.
		forceMove(T)

		// Visuals and sound.
		new /obj/item/weapon/ore/glass(T)
		playsound(src, 'sound/effects/break_stone.ogg', 75, 1)
		sleep(tunnel_tile_speed)



/*
// The actual leaping attack.
/mob/living/simple_mob/animal/giant_spider/hunter/do_special_attack(atom/A)
	set waitfor = FALSE
	set_AI_busy(TRUE)

	// Telegraph, since getting stunned suddenly feels bad.
	do_windup_animation(A, leap_warmup)
	sleep(leap_warmup) // For the telegraphing.

	// Do the actual leap.
	status_flags |= LEAPING // Lets us pass over everything.
	visible_message(span("danger","\The [src] leaps at \the [A]!"))
	throw_at(get_step(get_turf(A), get_turf(src)), special_attack_max_range+1, 1, src)
	playsound(src, 'sound/weapons/spiderlunge.ogg', 75, 1)

	sleep(5) // For the throw to complete. It won't hold up the AI ticker due to waitfor being false.

	if(status_flags & LEAPING)
		status_flags &= ~LEAPING // Revert special passage ability.

	var/turf/T = get_turf(src) // Where we landed. This might be different than A's turf.

	. = FALSE

	// Now for the stun.
	var/mob/living/victim = null
	for(var/mob/living/L in T) // So player-controlled spiders only need to click the tile to stun them.
		if(L == src)
			continue

		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(H.check_shields(damage = 0, damage_source = src, attacker = src, def_zone = null, attack_text = "the leap"))
				continue // We were blocked.

		victim = L
		break

	if(victim)
		victim.Weaken(2)
		victim.visible_message(span("danger","\The [src] knocks down \the [victim]!"))
		to_chat(victim, span("critical", "\The [src] jumps on you!"))
		. = TRUE

	set_AI_busy(FALSE)
*/

/*
/mob/living/simple_animal/hostile/giant_spider/tunneler
	desc = "Sandy and brown, it makes you shudder to look at it. This one has glittering yellow eyes."
	icon_state = "tunneler"
	icon_living = "tunneler"
	icon_dead = "tunneler_dead"

	maxHealth = 120
	health = 120
	move_to_delay = 4

	melee_damage_lower = 10
	melee_damage_upper = 20

	poison_chance = 15
	poison_per_bite = 3
	poison_type = "serotrotium_v"

/mob/living/simple_animal/hostile/giant_spider/tunneler/death()
	spawn(1)
		for(var/I = 1 to rand(3,6))
			if(src)
				new/obj/item/weapon/ore/glass(src.loc)
			else
				break
	return ..()
*/