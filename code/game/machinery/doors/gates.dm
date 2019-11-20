// SUBTYPE: Transparent
// Not technically a blast door but operates like one. Allows air and light.
obj/machinery/door/blast/gate
	name = "thick gate"
	icon = 'icons/obj/doors/city_shutters.dmi'
	icon_state_open = "shutter0"
	icon_state_opening = "shutterc0"
	icon_state_closed = "shutter1"
	icon_state_closing = "shutterc1"
	icon_state = "shutter1"
	maxhealth = 400
	block_air_zones = 0
	opacity = 0

	layer = 3.2//Just above doors

obj/machinery/door/blast/gate/open
	begins_closed = FALSE

obj/machinery/door/blast/gate/initialize()
	. = ..()

	if(!begins_closed)
		icon_state = icon_state_open
		set_density(0)
		layer = open_layer

	implicit_material = get_material_by_name("plasteel")

obj/machinery/door/blast/gate/proc/force_close_transparent()
	src.operating = 1
	playsound(src.loc, close_sound, 100, 1)
	src.layer = closed_layer
	flick(icon_state_closing, src)
	src.set_density(1)
	update_nearby_tiles()
	src.update_icon()
	src.set_opacity(0)
	sleep(15)
	src.operating = 0

/obj/machinery/door/blast/gate/thin
	name = "thin gate"
	icon_state_open = "shutter2_0"
	icon_state_opening = "shutter2_c0"
	icon_state_closed = "shutter2_1"
	icon_state_closing = "shutter2_c1"
	icon_state = "shutter2_1"
	maxhealth = 200
	opacity = 0

/obj/machinery/door/blast/gate/thin/open
	begins_closed = FALSE

/obj/machinery/door/blast/gate/bars
	name = "prison bars"
	icon_state_open = "bars_0"
	icon_state_opening = "bars_c0"
	icon_state_closed = "bars_1"
	icon_state_closing = "bars_c1"
	icon_state = "bars_1"
	maxhealth = 600
	opacity = 0

/obj/machinery/door/blast/gate/bars/open
	begins_closed = FALSE


/*
	Blast door remote control
*/
/obj/machinery/button/remote/blast_door
	name = "remote blast door-control"
	desc = "It controls blast doors, remotely."

/obj/machinery/button/remote/blast_door/trigger()
	for(var/obj/machinery/door/blast/gate/M in world)
		if(M.id == id)
			if(M.density)
				spawn(0)
					M.open()
					return
			else
				spawn(0)
					M.force_close_transparent()
					return

	for(var/obj/machinery/door/blast/M in world)
		if(M.id == id)
			if(M.density)
				spawn(0)
					M.open()
					return
			else
				spawn(0)
					M.close()
					return

