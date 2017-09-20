/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/cannon
	name = "8.8cm KwK 47"
	desc = "Do to enemy mechs what the King Tiger did to Allied tanks with 88 milimeters of armor-piercing German steel!"
	icon_state = "mecha_uac2"
	equip_cooldown = 55 // 5.5 seconds
	projectile = /obj/item/projectile/bullet/cannon
	fire_sound = 'sound/weapons/cannon.ogg'
	projectiles = 1
	projectile_energy_cost = 1000
	salvageable = 0 // We don't want players ripping this off a dead mech.

/obj/item/projectile/bullet/cannon
	name ="armor-piercing shell"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "shell"
	damage = 1000 // In order to 1-hit any other mech and royally fuck anyone unfortunate enough to get in the way.

	on_hit(var/atom/target, var/blocked = 0)
		explosion(target, 0, 0, 2, 4)
		return 1

/* // GLITCHY UND LAGGY.
/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/mg42
	name = "Maschinengewehr 60"
	icon_state = "mecha_uac2"
	equip_cooldown = 10
	projectile = /obj/item/projectile/bullet/midbullet2
	fire_sound = 'sound/weapons/mg42.ogg'
	projectiles = 1000
	projectiles_per_shot = 5
	deviation = 0.3
	projectile_energy_cost = 20
	fire_cooldown = 1
	salvageable = 0 // We don't want players ripping this off a dead mech.
*/

/obj/effect/decal/mecha_wreckage/gorilla
	name = "Gorilla wreckage"
	desc = "... Blitzkrieg?"
	icon = 'icons/mecha/mecha64x64.dmi'
	icon_state = "pzrwreck"
	layer = 4 // so it overlaps other people
	pixel_x = -16
	anchored = 1 // It's fucking huge. You aren't moving it.

/obj/mecha/combat/gorilla
	name = "Gorilla"
	desc = "<b>BLITZKRIEEEEEGGGGG!!!</b>"
	icon = 'icons/mecha/mecha64x64.dmi'
	icon_state = "pzrmech"
	initial_icon = "pzrmech"
	pixel_x = -16
	step_in = 10
	health = 5000
	opacity = 0 // Because there's big tall legs to look through. Also it looks fucky if this is set to 1.
	deflect_chance = 50
	damage_absorption = list("brute"=0.1,"fire"=0.7,"bullet"=0.1,"laser"=0.6,"energy"=0.7,"bomb"=0.7) //values show how much damage will pass through, not how much will be absorbed.
	max_temperature = 25000
	infra_luminosity = 3
	var/zoom = 0
	var/smoke = 5
	var/smoke_ready = 1
	var/smoke_cooldown = 100
	var/datum/effect/effect/system/smoke_spread/smoke_system = new
	wreckage = /obj/effect/decal/mecha_wreckage/gorilla
	add_req_access = 0
	internal_damage_threshold = 25
	force = 60
	max_equip = 4
	New()
		..()
		var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/tesla_energy_relay(src)
		ME.attach(src)
		ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/cannon(src)
		ME.attach(src)
		ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/explosive(src)
		ME.attach(src)
		ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg(src)
		ME.attach(src)
		src.smoke_system.set_up(3, 0, src)
		src.smoke_system.attach(src)
		return

/obj/mecha/combat/gorilla/mechstep(direction)
	var/result = step(src,direction)
	var/stepsound = rand(1,2)
	if(result)
		switch(stepsound)
			if(1)
				playsound(src,'sound/mecha/bigmech_lstep.ogg',40,1)
			if(2)
				playsound(src,'sound/mecha/bigmech_rstep.ogg',40,1)
	return result

/obj/mecha/combat/gorilla/mechturn(direction)
	dir = direction
	var/turnsound = rand(1,2)
	switch(turnsound)
		if(1)
			playsound(src,'sound/mecha/bigmech_lturn.ogg',40,1)
		if(2)
			playsound(src,'sound/mecha/bigmech_rturn.ogg',40,1)
	return 1

/obj/mecha/combat/gorilla/mechturn(direction)
	dir = direction
	var/turnsound = rand(1,2)
	switch(turnsound)
		if(1)
			playsound(src,'sound/mecha/bigmech_lturn.ogg',40,1)
		if(2)
			playsound(src,'sound/mecha/bigmech_rturn.ogg',40,1)
	return 1

/obj/mecha/combat/gorilla/relaymove(mob/user,direction)
	if(user != src.occupant)
		user.loc = get_turf(src)
		user << "You climb out from [src]"
		return 0
	if(!can_move)
		return 0
	if(zoom)
		if(world.time - last_message > 20)
			src.occupant_message("Unable to move while in zoom mode.")
			last_message = world.time
		return 0
	if(connected_port)
		if(world.time - last_message > 20)
			src.occupant_message("Unable to move while connected to the air system port")
			last_message = world.time
		return 0
	if(state || !has_charge(step_energy_drain))
		return 0
	var/tmp_step_in = step_in
	var/tmp_step_energy_drain = step_energy_drain
	var/move_result = 0
	if(internal_damage&MECHA_INT_CONTROL_LOST)
		move_result = mechsteprand()
	else if(src.dir!=direction)
		move_result = mechturn(direction)
	else
		move_result	= mechstep(direction)
	if(move_result)
		if(istype(src.loc, /turf/space))
			if(!src.check_for_support())
				src.pr_inertial_movement.start(list(src,direction))
		can_move = 0
		spawn(tmp_step_in) can_move = 1
		use_power(tmp_step_energy_drain)
		return 1
	return 0

/obj/mecha/combat/gorilla/verb/smoke()
	set category = "Exosuit Interface"
	set name = "Smoke"
	set src = usr.loc
	set popup_menu = 0
	if(usr!=src.occupant)
		return
	if(smoke_ready && smoke>0)
		src.smoke_system.start()
		smoke--
		smoke_ready = 0
		spawn(smoke_cooldown)
			smoke_ready = 1
	return

/obj/mecha/combat/gorilla/verb/zoom()
	set category = "Exosuit Interface"
	set name = "Zoom"
	set src = usr.loc
	set popup_menu = 0
	if(usr!=src.occupant)
		return
	if(src.occupant.client)
		src.zoom = !src.zoom
		src.log_message("Toggled zoom mode.")
		src.occupant_message("<font color='[src.zoom?"blue":"red"]'>Zoom mode [zoom?"en":"dis"]abled.</font>")
		if(zoom)
			src.occupant.client.view = 12
			src.occupant << sound('sound/mecha/imag_enh.ogg',volume=50)
		else
			src.occupant.client.view = world.view//world.view - default mob view size
	return


/obj/mecha/combat/gorilla/go_out()
	if(src.occupant && src.occupant.client)
		src.occupant.client.view = world.view
		src.zoom = 0
	..()
	return


/obj/mecha/combat/gorilla/get_stats_part()
	var/output = ..()
	output += {"<b>Smoke:</b> [smoke]"}
	return output


/obj/mecha/combat/gorilla/get_commands()
	var/output = {"<div class='wr'>
						<div class='header'>Special</div>
						<div class='links'>
						<a href='?src=\ref[src];toggle_zoom=1'>Toggle zoom mode</a><br>
						<a href='?src=\ref[src];smoke=1'>Smoke</a>
						</div>
						</div>
						"}
	output += ..()
	return output

/obj/mecha/combat/gorilla/Topic(href, href_list)
	..()
	if (href_list["smoke"])
		src.smoke()
	if (href_list["toggle_zoom"])
		src.zoom()
	return