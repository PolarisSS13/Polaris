/obj/structure/display_frame
	anchored = 0
	name = "display frame"
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "display_0"
	var/state = 0
	var/obj/item/weapon/circuitboard/circuit = null

/obj/structure/display_frame/New(var/loc, var/dir, var/building = 0)
	..()

	if(building)
		if(loc)
			src.loc = loc

		state = 0
		pixel_x = (dir & 3)? 0 : (dir == 4 ? -32 : 32)
		pixel_y = (dir & 3)? (dir ==1 ? -32 : 32) : 0
		update_icon()
		return

/obj/structure/display_frame/attackby(obj/item/P as obj, mob/user as mob)
	switch(state)
		if(0)
			if(istype(P, /obj/item/weapon/wrench))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
				if(do_after(user, 20))
					user << "<span class='notice'>You wrench the frame into place.</span>"
					src.anchored = 1
					src.state = 1
			if(istype(P, /obj/item/weapon/weldingtool))
				var/obj/item/weapon/weldingtool/WT = P
				if(!WT.remove_fuel(0, user))
					user << "The welding tool must be on to complete this task."
					return
				playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
				if(do_after(user, 20))
					if(!src || !WT.isOn()) return
					user << "<span class='notice'>You deconstruct the frame.</span>"
					new /obj/item/stack/material/steel( src.loc, 5 )
					qdel(src)
		if(1)
			if(istype(P, /obj/item/weapon/wrench))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
				if(do_after(user, 20))
					user << "<span class='notice'>You unfasten the frame.</span>"
					src.anchored = 0
					src.state = 0
			if(istype(P, /obj/item/weapon/circuitboard) && !circuit)
				var/obj/item/weapon/circuitboard/B = P
				if(B.board_type == "display")
					playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
					user << "<span class='notice'>You place the circuit board inside the frame.</span>"
					src.icon_state = "display_1"
					src.circuit = P
					user.drop_item()
					P.loc = src
				else
					user << "<span class='warning'>This frame does not accept circuit boards of this type!</span>"
			if(istype(P, /obj/item/weapon/screwdriver) && circuit)
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				user << "<span class='notice'>You screw the circuit board into place.</span>"
				src.state = 2
				src.icon_state = "display_2"
			if(istype(P, /obj/item/weapon/crowbar) && circuit)
				playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
				user << "<span class='notice'>You remove the circuit board.</span>"
				src.state = 1
				src.icon_state = "display_0"
				circuit.loc = src.loc
				src.circuit = null
		if(2)
			if(istype(P, /obj/item/weapon/screwdriver) && circuit)
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				user << "<span class='notice'>You unfasten the circuit board.</span>"
				src.state = 1
				src.icon_state = "display_1"
			if(istype(P, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/C = P
				if (C.get_amount() < 5)
					user << "<span class='warning'>You need five coils of wire to add them to the frame.</span>"
					return
				user << "<span class='notice'>You start to add cables to the frame.</span>"
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
				if(do_after(user, 20) && state == 2)
					if (C.use(5))
						user << "<span class='notice'>You add cables to the frame.</span>"
						state = 3
						icon_state = "display_3"
		if(3)
			if(istype(P, /obj/item/weapon/wirecutters))
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
				user << "<span class='notice'>You remove the cables.</span>"
				src.state = 2
				src.icon_state = "display_2"
				var/obj/item/stack/cable_coil/A = new /obj/item/stack/cable_coil( src.loc )
				A.amount = 5

			if(istype(P, /obj/item/stack/material) && P.get_material_name() == "glass")
				var/obj/item/stack/G = P
				if (G.get_amount() < 2)
					user << "<span class='warning'>You need two sheets of glass to put in the glass panel.</span>"
					return
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
				user << "<span class='notice'>You start to put in the glass panel.</span>"
				if(do_after(user, 20) && state == 3)
					if (G.use(2))
						user << "<span class='notice'>You put in the glass panel.</span>"
						src.state = 4
						src.icon_state = "display_4"
		if(4)
			if(istype(P, /obj/item/weapon/crowbar))
				playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
				user << "<span class='notice'>You remove the glass panel.</span>"
				src.state = 3
				src.icon_state = "display_3"
				new /obj/item/stack/material/glass( src.loc, 2 )
			if(istype(P, /obj/item/weapon/screwdriver))
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				user << "<span class='notice'>You connect the monitor.</span>"
				var/obj/machinery/B = new src.circuit.build_path ( src.loc )
				B.pixel_x = src.pixel_x
				B.pixel_y = src.pixel_y
				src.circuit.construct(B)
				qdel(src)