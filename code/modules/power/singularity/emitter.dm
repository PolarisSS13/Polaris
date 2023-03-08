#define EMITTER_DAMAGE_POWER_TRANSFER 450 //used to transfer power to containment field generators
#define STATE_LOOSE 0 //unanchored
#define STATE_WRENCHED 1 //wrenched
#define STATE_WELDED 2 //wrenched and welded. dormant - can be activated now

/obj/machinery/power/emitter
	name = "emitter"
	desc = "It is a heavy duty industrial laser."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "emitter"
	anchored = 0
	density = 1
	req_access = list(access_engine_equip)
	var/id = null

	use_power = USE_POWER_OFF	//uses powernet power, not APC power
	active_power_usage = 30000	//30 kW laser. I guess that means 30 kJ per shot.

	var/active = FALSE
	var/powered = FALSE
	var/fire_delay = 100
	var/max_burst_delay = 100
	var/min_burst_delay = 20
	var/burst_shots = 3
	var/last_shot = 0
	var/shot_number = 0
	var/state = STATE_LOOSE
	var/locked = FALSE
	var/safety = FALSE //Are the safeties enabled?
	var/safety_override = FALSE //Multitool to disable the safeties... or emag to disable permanently.

	var/burst_delay = 2
	var/initial_fire_delay = 100

	var/integrity = 80


/obj/machinery/power/emitter/verb/rotate_clockwise()
	set name = "Rotate Emitter Clockwise"
	set category = "Object"
	set src in oview(1)

	if (src.anchored || usr:stat)
		to_chat(usr, "It is fastened to the floor!")
		return 0
	src.set_dir(turn(src.dir, 270))
	return 1

/obj/machinery/power/emitter/Initialize()
	. = ..()
	if(state == STATE_WELDED && anchored)
		connect_to_network()
	if(emagged) //So they can start emagged, if for some ungodly reason you want to torment the engineers.
		emag_act()

/obj/machinery/power/emitter/faulty
	name = "ominous emitter"
	desc = "If you can see it, it can see you."
	emagged = TRUE

/obj/machinery/power/emitter/Destroy()
	message_admins("Emitter deleted at ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
	log_game("EMITTER([x],[y],[z]) Destroyed/deleted.")
	investigate_log("<font color='red'>deleted</font> at ([x],[y],[z])","singulo")
	..()

/obj/machinery/power/emitter/update_icon()
	if (active && powernet && avail(active_power_usage))
		icon_state = "emitter_+a"
	else
		icon_state = "emitter"

/obj/machinery/power/emitter/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	activate(user)

/obj/machinery/power/emitter/proc/activate(mob/user as mob)
	if(state == STATE_WELDED)
		if(!powernet)
			to_chat(user, "\The [src] isn't connected to a wire.")
			return 1
	if(state != STATE_WELDED)
		to_chat(user, SPAN_WARNING("\The [src] needs to be firmly secured to the floor first."))
		return TRUE

	if(!powernet && active_power_usage)
		to_chat(user, SPAN_WARNING("\The [src] has no power!"))
		return TRUE

	if(src.locked)
		to_chat(user, SPAN_WARNING("The controls are locked!"))
		return TRUE

	active = !active
	var/status = active ? "on" : "off"
	to_chat(user, "You turn [status] \the [src].")
	if(!safety)
		update_safety()

	message_admins("Emitter turned [status] by [key_name(user, user.client)](<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A>) in ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
	log_game("EMITTER([x],[y],[z]) [status] by [key_name(user)]")
	investigate_log("turned <font color='red'>[status]</font> by [user.key]","singulo")

	update_icon()
	return TRUE


/obj/machinery/power/emitter/emp_act(var/severity)//Emitters are hardened but still might have issues
//	add_load(1000)
/*	if((severity == 1)&&prob(1)&&prob(1))
		if(src.active)
			src.active = 0
			src.use_power = 1	*/
	return 1

/obj/machinery/power/emitter/process()
	if(stat & (BROKEN))
		return
	if(src.state != STATE_WELDED || (!powernet && active_power_usage))
		src.active = FALSE
		src.safety = FALSE //Don't bother with the targeting laser if we're unpowered.
		update_icon()
		return
	if(safety) // Being emagged will prevent the safety from being enabled
		var/list/hit = check_trajectory(get_step(src, dir), src)
		src.Beam(LAZYACCESS(hit, hit?.len), icon_state = "sniper_beam", time = 2 SECONDS, maxdistance = 50) //Refreshes on process() so short duration is fine.

	if(((src.last_shot + src.fire_delay) <= world.time) && (src.active == 1))

		var/actual_load = draw_power(active_power_usage)
		if(actual_load >= active_power_usage) //does the laser have enough power to shoot?
			if(!powered)
				powered = 1
				update_icon()
				log_game("EMITTER([x],[y],[z]) Regained power and is ON.")
				investigate_log("regained power and turned <font color='green'>on</font>","singulo")
		else
			if(powered)
				powered = 0
				update_icon()
				log_game("EMITTER([x],[y],[z]) Lost power and was ON.")
				investigate_log("lost power and turned <font color='red'>off</font>","singulo")
			return

		src.last_shot = world.time
		if(src.shot_number < burst_shots)
			src.fire_delay = get_burst_delay() //R-UST port
			src.shot_number ++
		else
			src.fire_delay = get_rand_burst_delay() //R-UST port
			src.shot_number = 0

		//need to calculate the power per shot as the emitter doesn't fire continuously.
		var/burst_time = (min_burst_delay + max_burst_delay)/2 + 2*(burst_shots-1)
		var/power_per_shot = active_power_usage * (burst_time/10) / burst_shots

		playsound(src, 'sound/weapons/emitter.ogg', 25, 1)
		if(prob(35))
			var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
			s.set_up(5, 1, src)
			s.start()

		var/obj/item/projectile/beam/emitter/A = get_emitter_beam()
		A.damage = round(power_per_shot/EMITTER_DAMAGE_POWER_TRANSFER)
		A.firer = src
		A.fire(dir2angle(dir))

/obj/machinery/power/emitter/attackby(obj/item/W, mob/user)

	if(istype(W, /obj/item/multitool))
		toggle_safety_override(user)
		return

	if(W.is_wrench())
		if(active)
			to_chat(user, "Turn off [src] first.")
			return
		switch(state)
			if(STATE_LOOSE)
				state = STATE_WRENCHED
				playsound(src, W.usesound, 75, 1)
				user.visible_message("[user.name] secures [src] to the floor.", \
					"You secure the external reinforcing bolts to the floor.", \
					"You hear a ratchet.")
				src.anchored = 1
			if(STATE_WRENCHED)
				state = STATE_LOOSE
				playsound(src, W.usesound, 75, 1)
				user.visible_message("[user.name] unsecures [src] reinforcing bolts from the floor.", \
					"You undo the external reinforcing bolts.", \
					"You hear a ratchet.")
				src.anchored = 0
				disconnect_from_network()
			if(STATE_WELDED)
				to_chat(user, "<span class='warning'>\The [src] needs to be unwelded from the floor.</span>")
		return

	if(istype(W, /obj/item/weldingtool))
		var/obj/item/weldingtool/WT = W
		if(active)
			to_chat(user, "Turn off [src] first.")
			return
		switch(state)
			if(STATE_LOOSE)
				to_chat(user, "<span class='warning'>\The [src] needs to be wrenched to the floor.</span>")
			if(STATE_WRENCHED)
				if (WT.remove_fuel(0,user))
					playsound(src, WT.usesound, 50, 1)
					user.visible_message("[user.name] starts to weld [src] to the floor.", \
						"You start to weld [src] to the floor.", \
						"You hear welding")
					if (do_after(user,20 * WT.toolspeed))
						if(!src || !WT.isOn()) return
						state = STATE_WELDED
						to_chat(user, "You weld [src] to the floor.")
						connect_to_network()
				else
					to_chat(user, "<span class='warning'>You need more welding fuel to complete this task.</span>")
			if(STATE_WELDED)
				if (WT.remove_fuel(0,user))
					playsound(src, WT.usesound, 50, 1)
					user.visible_message("[user.name] starts to cut [src] free from the floor.", \
						"You start to cut [src] free from the floor.", \
						"You hear welding")
					if (do_after(user,20 * WT.toolspeed))
						if(!src || !WT.isOn()) return
						state = STATE_WRENCHED
						to_chat(user, "You cut [src] free from the floor.")
						disconnect_from_network()
				else
					to_chat(user, "<span class='warning'>You need more welding fuel to complete this task.</span>")
		return

	if(istype(W, /obj/item/stack/material) && W.get_material_name() == MAT_STEEL)
		var/amt = CEILING(( initial(integrity) - integrity)/10, 1)
		if(!amt)
			to_chat(user, "<span class='notice'>\The [src] is already fully repaired.</span>")
			return
		var/obj/item/stack/P = W
		if(P.amount < amt)
			to_chat(user, "<span class='warning'>You don't have enough sheets to repair this! You need at least [amt] sheets.</span>")
			return
		to_chat(user, "<span class='notice'>You begin repairing \the [src]...</span>")
		if(do_after(user, 30))
			if(P.use(amt))
				to_chat(user, "<span class='notice'>You have repaired \the [src].</span>")
				integrity = initial(integrity)
				return
			else
				to_chat(user, "<span class='warning'>You don't have enough sheets to repair this! You need at least [amt] sheets.</span>")
				return

	if(istype(W, /obj/item/card/id) || istype(W, /obj/item/pda))
		if(emagged)
			to_chat(user, "<span class='warning'>The lock seems to be broken.</span>")
			return
		if(src.allowed(user))
			src.locked = !src.locked
			to_chat(user, "The controls are now [src.locked ? "locked." : "unlocked."]")
		else
			to_chat(user, "<span class='warning'>Access denied.</span>")
		return
	..()
	return

/obj/machinery/power/emitter/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		locked = FALSE
		emagged = TRUE
		safety = FALSE
		burst_shots = rand(3,5) //An unpredictable number of shots...
		min_burst_delay = rand(0,20) //... with an unpredictable rate of fire.
		max_burst_delay = rand(21,100) //These aren't safe at all...
		initial_fire_delay = rand(0,100) //... but they fire more often? Worth it?
		user.visible_message("[user.name] tampers with [src]'s electronics.","<span class='warning'>You short out [src]'s electronics.</span>")
		return 1

/obj/machinery/power/emitter/bullet_act(var/obj/item/projectile/P)
	if(!P || !P.damage || P.get_structure_damage() <= 0 )
		return

	adjust_integrity(-P.get_structure_damage())

/obj/machinery/power/emitter/blob_act()
	adjust_integrity(-1000) // This kills the emitter.

/obj/machinery/power/emitter/proc/adjust_integrity(amount)
	integrity = between(0, integrity + amount, initial(integrity))
	if(integrity == 0)
		if(powernet && avail(active_power_usage)) // If it's powered, it goes boom if killed.
			visible_message(src, "<span class='danger'>\The [src] explodes violently!</span>", "<span class='danger'>You hear an explosion!</span>")
			explosion(get_turf(src), 1, 2, 4)
		else
			src.visible_message("<span class='danger'>\The [src] crumples apart!</span>", "<span class='warning'>You hear metal collapsing.</span>")
		if(src)
			qdel(src)

/obj/machinery/power/emitter/examine(mob/user)
	. = ..()
	var/integrity_percentage = round((integrity / initial(integrity)) * 100)
	switch(integrity_percentage)
		if(0 to 30)
			. += "<span class='danger'>It is close to falling apart!</span>"
		if(31 to 70)
			. += "<span class='danger'>It is damaged.</span>"
		if(77 to 99)
			. += "<span class='warning'It is slightly damaged.</span>"

//R-UST port
/obj/machinery/power/emitter/proc/get_initial_fire_delay()
	return initial_fire_delay

/obj/machinery/power/emitter/proc/get_rand_burst_delay()
	return rand(min_burst_delay, max_burst_delay)

/obj/machinery/power/emitter/proc/get_burst_delay()
	return burst_delay

/obj/machinery/power/emitter/proc/get_emitter_beam()
	return new /obj/item/projectile/beam/emitter(get_turf(src))


//Safety mechanisms - 2023-03-07/2023-03-23
//Added due to in-character Union actions (and multiple disintegrated arms)
//Summary: when the emitter is dormant, a targeting laser can be present (toggled with alt-click).
//When the emitter is firing, the targeting laser WILL be present.
//Multitools temporarily disable the targeting software. Emags permanently disable the targeting software... and scramble the fire delays.
/obj/machinery/power/emitter/AltClick(mob/user)
	. = ..()
	try_toggle_safety(user)

/obj/machinery/power/emitter/proc/update_safety()
	safety = !emagged && (powernet || !active_power_usage) && (!safety_override || active) //Emagged, overridden or depowered = no safety. Otherwise, toggle.

/obj/machinery/power/emitter/proc/can_toggle_safety(mob/user)
	if(state != STATE_WELDED)
		to_chat(user, "<span class='notice'>You can't adjust the emitter's targeting laser without securing it first.</span>")
		return FALSE
	if(active)
		to_chat(user, "<span class='danger'>You can't adjust \the [src]'s targeting laser while it's firing!</span>")
		return FALSE
	if(safety_override)
		to_chat(user, "<span class='danger'>\The [src]'s targeting laser has been manually disabled!</span>")
		return FALSE
	if(emagged) //You weren't standing in front of it, right?
		to_chat(user, "<span class='warning'>The targeting laser on [src] short-circuits!</span>")
		activate(user)
		return FALSE
	return TRUE

/obj/machinery/power/emitter/proc/try_toggle_safety(mob/user) //Enable or disable the targeting laser when it's dormant
	if(!can_toggle_safety(user))
		return
	to_chat(user, "You [safety ? "disable" : "enable"] \the [src]'s targeting laser.") //give feedback to user!
	toggle_safety()
	return

/obj/machinery/power/emitter/proc/toggle_safety_override(mob/user) //Prevent the targeting laser from showing up at all
	if(!emagged && state == STATE_WELDED && !active)
		safety_override = !safety_override
		if(safety_override)
			to_chat(user, "You disable [src]'s targeting software. It was just getting in the way anyway.")
		else
			to_chat(user, "In a brief moment of wisdom, you reenable [src]'s targeting software.")
		update_safety()
	else
		can_toggle_safety(user) //If it's emagged, active, or unsecured, give us the failure message. Otherwise, flip the override.