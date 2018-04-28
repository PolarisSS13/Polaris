//Dummy object for holding items in vehicles.
//Prevents items from being interacted with.
/datum/vehicle_dummy_load
	var/name = "dummy load"
	var/actual_load

/obj/vehicle
	name = "vehicle"
	icon = 'icons/obj/vehicles.dmi'
	layer = MOB_LAYER + 0.1 //so it sits above objects including mobs
	density = 1
	anchored = 1
	animate_movement=1
//	light_power = 1.5
//	light_range = 3

	can_buckle = 1
	buckle_movable = 1
	buckle_lying = 0

//	var/list/buckled_mobs = list()
	var/list/action_buttons = list()
	var/mechanical = TRUE // If false, doesn't care for things like cells, engines, EMP, keys, etc.

	var/attack_log = null
	var/on = 0
	var/headlights = 0
	var/health = 0	//do not forget to set health for your vehicle!
	var/maxhealth = 0
	var/fire_dam_coeff = 1.0
	var/brute_dam_coeff = 1.0
	var/open = 0	//Maint panel
	var/locked = 1
	var/stat = 0
	var/emagged = 0
	var/powered = 0		//set if vehicle is powered and should use fuel when moving
	var/move_delay = 0	//set this to limit the speed of the vehicle
	var/fits_passenger = 0
	var/bumped = 0 //to prevent spammage from Bump()

	var/speed = 1 //Two speeds, 1 and 2. 2 is fastest.

	var/obj/item/weapon/cell/car/cell
	var/charge_use = 5	//set this to adjust the amount of power the vehicle uses per move

	var/atom/movable/load		//all vehicles can take a load, since they should all be a least drivable
	var/atom/movable/passenger  //some vehicles can take passengers
	var/atom/movable/trunk	    //some vehicles have additional storage in the back
	var/load_item_visible = 1	//set if the loaded item should be overlayed on the vehicle sprite
	var/passenger_item_visible = 1
	var/load_offset_x = 0		//pixel_x offset for item overlay
	var/load_offset_y = 0		//pixel_y offset for item overlay
	var/mob_offset_y = 0		//pixel_y offset for mob overlay
	var/mob_offset_x = 0		//pixel_y offset for mob overlay
	var/passenger_offset_y = 0		//pixel_y offset for mob overlay
	var/passenger_offset_x = 0		//pixel_y offset for mob overlay
	var/default_layer = OBJ_LAYER

	light_power = 1.5 //for headlights

	var/spam_flag = 0 //for sound effects
	var/cooldowntime
	var/engine_start
	var/engine_fail
	var/horn_sound = 'sound/items/bikehorn.ogg'

	var/datum/riding/riding_datum = null

//-------------------------------------------
// Standard procs
//-------------------------------------------
/obj/vehicle/New()
	..()
	populate_action_buttons()
	populate_verbs()
	//spawn the cell you want in each vehicle

/obj/vehicle/Destroy()
	qdel_null(riding_datum)
	return ..()


/obj/vehicle/buckle_mob(mob/living/M, forced = FALSE, check_loc = TRUE)
	. = ..()
	M.update_water()
	if(riding_datum)
		riding_datum.ridden = src
		riding_datum.handle_vehicle_offsets()

/obj/vehicle/unbuckle_mob(mob/living/buckled_mob, force = FALSE)
	. = ..(buckled_mob, force)
	buckled_mob.update_water()
	if(riding_datum)
		riding_datum.restore_position(buckled_mob)
		riding_datum.handle_vehicle_offsets() // So the person in back goes to the front.

/obj/vehicle/set_dir(newdir)
	..(newdir)
	if(riding_datum)
		riding_datum.handle_vehicle_offsets()

/obj/vehicle/Move()
	if(world.time > l_move_time + move_delay)
		var/old_loc = get_turf(src)
		if(mechanical && on && powered && cell.charge < charge_use)
			turn_off()

		var/init_anc = anchored
		anchored = 0
		if(!..())
			anchored = init_anc
			return 0

		set_dir(get_dir(old_loc, loc))
		anchored = init_anc

		if(on && powered)
			cell.use(charge_use)

		//Dummy loads do not have to be moved as they are just an overlay
		//See load_object() proc in cargo_trains.dm for an example
		if(load && !istype(load, /datum/vehicle_dummy_load))
			load.forceMove(loc)
			load.set_dir(dir)
		if(passenger)
			passenger.forceMove(loc)
			passenger.set_dir(dir)
		if(trunk)
			//trunk.forceMove(loc)
			trunk.set_dir(dir)

		return 1
	else
		return 0

/obj/vehicle/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/hand_labeler))
		return

	if(mechanical)
		if(istype(W, /obj/item/weapon/screwdriver))
			if(!locked)
				open = !open
				update_icon()
				user << "<span class='notice'>Maintenance panel is now [open ? "opened" : "closed"].</span>"
				playsound(src, W.usesound, 50, 1)
		else if(istype(W, /obj/item/weapon/crowbar) && cell && open)
			remove_cell(user)

		else if(istype(W, /obj/item/weapon/cell) && !cell && open)
			insert_cell(W, user)
		else if(istype(W, /obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/T = W
			if(T.welding)
				if(health < maxhealth)
					if(open)
						health = min(maxhealth, health+10)
						user.setClickCooldown(user.get_attack_speed(W))
						playsound(src, T.usesound, 50, 1)
						user.visible_message("<font color='red'>[user] repairs [src]!</font>","<font color='blue'> You repair [src]!</font>")
					else
						user << "<span class='notice'>Unable to repair with the maintenance panel closed.</span>"
				else
					user << "<span class='notice'>[src] does not need a repair.</span>"
			else
				user << "<span class='notice'>Unable to repair while [src] is off.</span>"

	else if(hasvar(W,"force") && hasvar(W,"damtype"))
		user.setClickCooldown(user.get_attack_speed(W))
		switch(W.damtype)
			if("fire")
				health -= W.force * fire_dam_coeff
			if("brute")
				health -= W.force * brute_dam_coeff
		..()
		healthcheck()
	else
		..()

/obj/vehicle/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.damage
	..()
	healthcheck()
/*
/obj/vehicle/meteorhit()
	explode()
	return
*/
/obj/vehicle/blob_act()
	src.health -= rand(20,40)*fire_dam_coeff
	healthcheck()
	return

/obj/vehicle/ex_act(severity)
	switch(severity)
		if(1.0)
			explode()
			return
		if(2.0)
			health -= rand(5,10)*fire_dam_coeff
			health -= rand(10,20)*brute_dam_coeff
			healthcheck()
			return
		if(3.0)
			if (prob(50))
				health -= rand(1,5)*fire_dam_coeff
				health -= rand(1,5)*brute_dam_coeff
				healthcheck()
				return
	return

/obj/vehicle/emp_act(severity)
	if(!mechanical)
		return

	var/was_on = on
	stat |= EMPED
	var/obj/effect/overlay/pulse2 = new /obj/effect/overlay(src.loc)
	pulse2.icon = 'icons/effects/effects.dmi'
	pulse2.icon_state = "empdisable"
	pulse2.name = "emp sparks"
	pulse2.anchored = 1
	pulse2.set_dir(pick(cardinal))

	spawn(10)
		qdel(pulse2)
	if(on)
		turn_off()
	spawn(severity*300)
		stat &= ~EMPED
		if(was_on)
			turn_on()

/obj/vehicle/emag_act(mob/user)
	if(locked)
		locked = 0
		user << "<span class='warning'>You bypass [src]'s controls.</span>"
		return

	if(emagged)
		emagged = 0
		user << "<span class='notice'>You silently enable [src]'s safety protocols with the cryptographic sequencer."
	else
		emagged = 1
		user << "<span class='warning'>You silently disable [src]'s safety protocols with the cryptographic sequencer."

/obj/vehicle/attack_ai(mob/user as mob)
	return

// For downstream compatibility (in particular Paradise)
/obj/vehicle/proc/handle_rotation()
	return

//-------------------------------------------
// Vehicle procs
//-------------------------------------------
/obj/vehicle/proc/turn_on()
	if(stat)
		return 0
	if(powered && cell.charge < charge_use)
		return 0
	on = 1
	bumped = 0 //for non-emagged collisions
	update_icon()

	verbs -= /obj/vehicle/verb/stop_engine
	verbs -= /obj/vehicle/verb/start_engine

	if(on)
		verbs += /obj/vehicle/verb/stop_engine
	else
		verbs += /obj/vehicle/verb/start_engine

	for(var/obj/screen/vehicle_action/enginetoggle/A in action_buttons)
		A.icon_state = "engine[on]"
		A.name = "[on ? "Turn Off" : "Turn On"] Engine"

	if(usr) usr.update_action_buttons()

	return 1

/obj/vehicle/proc/turn_off()
	on = 0
	update_icon()

	verbs -= /obj/vehicle/verb/stop_engine
	verbs -= /obj/vehicle/verb/start_engine

	if(!on)
		verbs += /obj/vehicle/verb/start_engine
	else
		verbs += /obj/vehicle/verb/stop_engine

	for(var/obj/screen/vehicle_action/enginetoggle/A in action_buttons)
		A.icon_state = "engine[on]"
		A.name = "[on ? "Turn Off" : "Turn On"] Engine"

	if(usr) usr.update_action_buttons()

/obj/vehicle/proc/headlights_on()

	headlights = 1
	set_light(3)

	verbs -= /obj/vehicle/verb/turn_headlights_off
	verbs -= /obj/vehicle/verb/turn_headlights_on

	if(headlights)
		verbs += /obj/vehicle/verb/turn_headlights_off
	else
		verbs += /obj/vehicle/verb/turn_headlights_on

	for(var/obj/screen/vehicle_action/headlightstoggle/A in action_buttons)
		A.icon_state = "headlights[headlights]"
		A.name = "[headlights ? "Turn Off" : "Turn On"] Headlights"

	if(usr) usr.update_action_buttons()

/obj/vehicle/proc/headlights_off()

	headlights = 0
	set_light(0)

	verbs -= /obj/vehicle/verb/turn_headlights_off
	verbs -= /obj/vehicle/verb/turn_headlights_on

	if(!headlights)
		verbs += /obj/vehicle/verb/turn_headlights_on
	else
		verbs += /obj/vehicle/verb/turn_headlights_off

	for(var/obj/screen/vehicle_action/headlightstoggle/A in action_buttons)
		A.icon_state = "headlights[headlights]"
		A.name = "[headlights ? "Turn Off" : "Turn On"] Headlights"

	if(usr) usr.update_action_buttons()

/obj/vehicle/proc/swap()
	return

/obj/vehicle/proc/honk_horn()
	playsound(src, horn_sound,40,1)

/obj/vehicle/proc/explode()
	src.visible_message("\red <B>[src] blows apart!</B>", 1)
	var/turf/Tsec = get_turf(src)

	new /obj/item/stack/rods(Tsec)
	new /obj/item/stack/rods(Tsec)
	new /obj/item/stack/cable_coil/cut(Tsec)

	if(cell)
		cell.forceMove(Tsec)
		cell.update_icon()
		cell = null

	//stuns people who are thrown off a train that has been blown up
	if(istype(load, /mob/living))
		var/mob/living/M = load
		M.apply_effects(5, 5)

	unload()
	//explosion(src.loc, 2, 3, 4, 4)
	new /obj/effect/gibspawner/robot(Tsec)
	new /obj/effect/decal/cleanable/blood/oil(src.loc)

	qdel(src)

/obj/vehicle/emag_act(var/remaining_charges, mob/user as mob)
	if(!mechanical)
		return FALSE

	if(!emagged)
		emagged = 1
		if(locked)
			locked = 0
			user << "<span class='warning'>You bypass [src]'s controls.</span>"
		return TRUE



/obj/vehicle/proc/healthcheck()
	if(health <= 0)
		explode()

/obj/vehicle/proc/powercheck()
	if(!cell && !powered)
		return

	if(!cell && powered)
		turn_off()
		return

	if(cell.charge < charge_use)
		turn_off()
		return

	if(cell && powered)
		turn_on()
		return

/obj/vehicle/proc/insert_cell(var/obj/item/weapon/cell/car/C, var/mob/living/carbon/human/H)
	if(cell)
		return
	if(!istype(C))
		return

	H.drop_from_inventory(C)
	C.forceMove(src)
	cell = C
	powercheck()
	usr << "<span class='notice'>You install [C] in [src].</span>"

/obj/vehicle/proc/remove_cell(var/mob/living/carbon/human/H)
	if(!cell)
		return

	usr << "<span class='notice'>You remove [cell] from [src].</span>"
	cell.forceMove(get_turf(H))
	H.put_in_hands(cell)
	cell = null
	powercheck()

/obj/vehicle/proc/RunOver(var/mob/living/carbon/human/H)
	return		//write specifics for different vehicles

//-------------------------------------------
// Loading/unloading procs
//
// Set specific item restriction checks in
// the vehicle load() definition before
// calling this parent proc.
//-------------------------------------------
/obj/vehicle/proc/load(var/atom/movable/C)
	//This loads objects onto the vehicle so they can still be interacted with.
	//Define allowed items for loading in specific vehicle definitions.
	if(!isturf(C.loc)) //To prevent loading things from someone's inventory, which wouldn't get handled properly.
		return 0
	if(load || C.anchored)
		return 0

	// if a create/closet, close before loading
	var/obj/structure/closet/crate = C
	if(istype(crate))
		crate.close()

	C.forceMove(loc)
	C.set_dir(dir)
	C.anchored = 1

	load = C

	if(load_item_visible)
		C.pixel_x += load_offset_x
		if(ismob(C))
			C.pixel_y += mob_offset_y
		else
			C.pixel_y += load_offset_y
		C.layer = layer + 0.1		//so it sits above the vehicle
		default_layer = C.layer

	if(ismob(C))
		buckle_mob(C)
		var/mob/M = C
		M.update_action_buttons()

	return 1

/obj/vehicle/proc/unload(var/mob/user, var/direction)
	if(!load)
		return

	var/turf/dest = null

	//find a turf to unload to
	if(direction)	//if direction specified, unload in that direction
		dest = get_step(src, direction)
	else if(user)	//if a user has unloaded the vehicle, unload at their feet
		dest = get_turf(user)

	if(!dest)
		dest = get_step_to(src, get_step(src, turn(dir, 90))) //try unloading to the side of the vehicle first if neither of the above are present

	//if these all result in the same turf as the vehicle or nullspace, pick a new turf with open space
	if(!dest || dest == get_turf(src))
		var/list/options = new()
		for(var/test_dir in alldirs)
			var/new_dir = get_step_to(src, get_step(src, test_dir))
			if(new_dir && load.Adjacent(new_dir))
				options += new_dir
		if(options.len)
			dest = pick(options)
		else
			dest = get_turf(src)	//otherwise just dump it on the same turf as the vehicle

	if(!isturf(dest))	//if there still is nowhere to unload, cancel out since the vehicle is probably in nullspace
		return 0

	load.forceMove(dest)
	load.set_dir(get_dir(loc, dest))
	load.anchored = 0		//we can only load non-anchored items, so it makes sense to set this to false
	load.pixel_x = initial(load.pixel_x)
	load.pixel_y = initial(load.pixel_y)
	load.layer = initial(load.layer)

	if(ismob(load))
		unbuckle_mob(load)
		var/mob/M = load
		M.update_action_buttons()

	load = null

	return 1

//-------------------------------------------------------
// Verbs
//-------------------------------------------------------

/obj/vehicle/verb/turn_headlights_on()
	set name = "Turn On Headlights"
	set category = "Vehicle"
	set src in oview(0)

	if(usr.stat || usr.restrained() || usr.stunned || usr.lying)
		return

	headlights_on()

/obj/vehicle/verb/turn_headlights_off()
	set name = "Turn Off Headlights"
	set category = "Vehicle"
	set src in oview(0)

	if(usr.stat || usr.restrained() || usr.stunned || usr.lying)
		return

	headlights_off()

/obj/vehicle/verb/start_engine()
	set name = "Start engine"
	set category = "Vehicle"
	set src in view(0)

	if(!istype(usr, /mob/living/carbon/human))
		return

	if(usr.stat || usr.restrained() || usr.stunned || usr.lying)
		return

	if(on)
		usr << "<span class='warning'>The engine is already running.</span>"
		return

	if(!spam_flag)
		spam_flag = 1
		cooldowntime = 30
		turn_on()
		if (on)
			playsound(src.loc, engine_start, 80, 0, 10)
			usr << "<span class='notice'>You start [src]'s engine.</span>"
			spawn(cooldowntime)
				spam_flag = 0
		else
			if(cell.charge < charge_use)
				usr << "<span class='warning'>[src] is out of power.</span>"
			else
				spam_flag = 1
				cooldowntime = 50
				usr << "<span class='warning'>[src]'s engine won't start.</span>"
				playsound(src.loc, engine_fail, 80, 0, 10)
				spawn(cooldowntime)
					spam_flag = 0

/obj/vehicle/verb/stop_engine()
	set name = "Stop engine"
	set category = "Vehicle"
	set src in view(0)

	if(!istype(usr, /mob/living/carbon/human))
		return

	if(usr.stat || usr.restrained() || usr.stunned || usr.lying)
		return

	if(!on)
		usr << "<span class='warning'>The engine is already stopped.</span>"
		return

	turn_off()
	if (!on)
		usr << "<span class='notice'>You stop [src]'s engine.</span>"

/obj/vehicle/verb/open_trunk()
	set name = "Trunk Open"
	set category = "Vehicle"
	set src in oview(1)
	return
/obj/vehicle/verb/close_trunk()
	set name = "Trunk Close"
	set category = "Vehicle"
	set src in oview(1)
	return
/obj/vehicle/verb/honk()
	set name = "Honk horn"
	set category = "Vehicle"
	set src in view(0)

	if(usr.stat || usr.restrained() || usr.stunned || usr.lying)
		return

	honk_horn()

//-------------------------------------------------------
// Stat update procs
//-------------------------------------------------------
/obj/vehicle/proc/update_stats()
	return

/obj/vehicle/attack_generic(var/mob/user, var/damage, var/attack_message)
	if(!damage)
		return
	visible_message("<span class='danger'>[user] [attack_message] the [src]!</span>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [src.name]</font>")
	src.health -= damage
	if(prob(10))
		new /obj/effect/decal/cleanable/blood/oil(src.loc)
	spawn(1) healthcheck()
	return 1

/obj/vehicle/proc/populate_action_buttons() //These come with all vehicles
	action_buttons += new /obj/screen/vehicle_action/enginetoggle(null)
	action_buttons += new /obj/screen/vehicle_action/headlightstoggle(null)
	action_buttons += new /obj/screen/vehicle_action/horntoggle(null)

/obj/vehicle/proc/populate_verbs()
	verbs -= /obj/vehicle/verb/close_trunk
	verbs -= /obj/vehicle/verb/open_trunk
	verbs -= /obj/vehicle/verb/stop_engine
	verbs -= /obj/vehicle/verb/turn_headlights_off