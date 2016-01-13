/obj/structure/frame
	anchored = 0
	name = "frame"
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "0"
	var/state = 0
	var/obj/item/weapon/circuitboard/circuit = null
	var/frame_type

	var/list/components = null
	var/list/req_components = null
	var/list/req_component_names = null

	proc/update_desc()
		var/D
		if(req_components)
			var/list/component_list = new
			for(var/I in req_components)
				if(req_components[I] > 0)
					component_list += "[num2text(req_components[I])] [req_component_names[I]]"
			D = "Requires [english_list(component_list)]."
		desc = D

/obj/structure/frame/New(var/loc, var/dir, var/building = 0, var/obj/item/frame/frame_type, mob/user as mob)
	..()
	src.frame_type = frame_type

	icon_state = "[frame_type]_0"

	if(frame_type == "alarm" || frame_type == "display")
		if(building)
			if(loc)
				src.loc = loc

			state = 0
			switch(frame_type)
				if("alarm")
					src.icon = icon
					if(dir)
						src.set_dir(dir)
					pixel_x = (dir & 3)? 0 : (dir == 4 ? -24 : 24)
					pixel_y = (dir & 3)? (dir ==1 ? -24 : 24) : 0
				if("display")
					src.icon = icon
					pixel_x = (dir & 3)? 0 : (dir == 4 ? -32 : 32)
					pixel_y = (dir & 3)? (dir ==1 ? -32 : 32) : 0
			update_icon()
			return

	if(frame_type == "computer" || frame_type == "machine")
		density = 1

/obj/structure/frame/attackby(obj/item/P as obj, mob/user as mob)
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
				if(B.board_type == frame_type)
					playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
					user << "<span class='notice'>You place the circuit board inside the frame.</span>"
					src.icon_state = "[frame_type]_1"
					src.circuit = P
					user.drop_item()
					P.loc = src

					if(frame_type == "machine")  //because machines are assholes
						components = list()
						req_components = circuit.req_components.Copy()
						for(var/A in circuit.req_components)
							req_components[A] = circuit.req_components[A]
						req_component_names = circuit.req_components.Copy()
						for(var/A in req_components)
							var/cp = text2path(A)
							var/obj/ct = new cp() // have to quickly instantiate it get name
							req_component_names[A] = ct.name
						update_desc()
						user << desc

				else
					user << "<span class='warning'>This frame does not accept circuit boards of this type!</span>"
			if(istype(P, /obj/item/weapon/screwdriver) && circuit)
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				user << "<span class='notice'>You screw the circuit board into place.</span>"
				src.state = 2
				src.icon_state = "[frame_type]_2"
			if(istype(P, /obj/item/weapon/crowbar) && circuit)
				playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
				user << "<span class='notice'>You remove the circuit board.</span>"
				src.state = 1
				src.icon_state = "[frame_type]_0"
				circuit.loc = src.loc
				src.circuit = null
				if(frame_type == "machine") //becuase machines are assholes
					req_components = null
		if(2)
			if(istype(P, /obj/item/weapon/screwdriver) && circuit)
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				user << "<span class='notice'>You unfasten the circuit board.</span>"
				src.state = 1
				src.icon_state = "[frame_type]_1"
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
						icon_state = "[frame_type]_3"
		if(3) //end mostly universal steps
			switch(frame_type)
				if("computer")  //computer and display steps
					if(istype(P, /obj/item/weapon/wirecutters))
						playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
						user << "<span class='notice'>You remove the cables.</span>"
						src.state = 2
						src.icon_state = "[frame_type]_2"
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
								src.icon_state = "[frame_type]_4"

				if("display")  //computer and display steps
					if(istype(P, /obj/item/weapon/wirecutters))
						playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
						user << "<span class='notice'>You remove the cables.</span>"
						src.state = 2
						src.icon_state = "[frame_type]_2"
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
								src.icon_state = "[frame_type]_4"

				if("machine") //machine steps
					if(istype(P, /obj/item/weapon/wirecutters))
						playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
						user << "<span class='notice'>You remove the cables.</span>"
						src.state = 2
						src.icon_state = "[frame_type]_2"
						var/obj/item/stack/cable_coil/A = new /obj/item/stack/cable_coil( src.loc )
						A.amount = 5
					if(istype(P, /obj/item/weapon/crowbar))
						playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
						if(components.len == 0)
							user << "<span class='notice'>There are no components to remove.</span>"
						else
							user << "<span class='notice'>You remove the components.</span>"
							for(var/obj/item/weapon/W in components)
								W.loc = src.loc
						components = list()
						req_components = circuit.req_components.Copy()
						for(var/A in circuit.req_components)
							req_components[A] = circuit.req_components[A]
						req_component_names = circuit.req_components.Copy()
						for(var/A in req_components)
							var/cp = text2path(A)
							var/obj/ct = new cp() // have to quickly instantiate it get name
							req_component_names[A] = ct.name
						update_desc()
						user << desc
					else
						if(istype(P, /obj/item/weapon/screwdriver))
							var/component_check = 1
							for(var/R in req_components)
								if(req_components[R] > 0)
									component_check = 0
									break
							if(component_check)
								playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
								var/obj/machinery/new_machine = new src.circuit.build_path(src.loc, src.dir)

								if(new_machine.component_parts)
									new_machine.component_parts.Cut()
								else
									new_machine.component_parts = list()

								src.circuit.construct(new_machine)
								for(var/obj/O in src.components)
									O.loc = null
									new_machine.component_parts += O
								new_machine.RefreshParts()
								qdel(src)
						else
							if(istype(P, /obj/item))
								for(var/I in req_components)
									if(istype(P, text2path(I)) && (req_components[I] > 0))
										playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
										if(istype(P, /obj/item/stack/cable_coil))
											var/obj/item/stack/cable_coil/CP = P
											if(CP.get_amount() > 1)
												var/camt = min(CP.amount, req_components[I]) // amount of cable to take, idealy amount required, but limited by amount provided
												var/obj/item/stack/cable_coil/CC = new /obj/item/stack/cable_coil(src)
												CC.amount = camt
												CC.update_icon()
												CP.use(camt)
												components += CC
												req_components[I] -= camt
												update_desc()
												break
										user.drop_item()
										P.loc = src
										components += P
										req_components[I]--
										update_desc()
										break
								user << desc
								if(P && P.loc != src && !istype(P, /obj/item/stack/cable_coil))
									user << "<span class='warning'>You cannot add that component to the machine!</span>"

				if("alarm") //alarm steps
					if(istype(P, /obj/item/weapon/wirecutters))
						playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
						user << "<span class='notice'>You remove the cables.</span>"
						src.state = 2
						src.icon_state = "[frame_type]_2"
						var/obj/item/stack/cable_coil/A = new /obj/item/stack/cable_coil( src.loc )
						A.amount = 5
					if(istype(P, /obj/item/weapon/screwdriver))
						playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
						user << "<span class='notice'>You fasten the cover.</span>"
						var/obj/machinery/B = new src.circuit.build_path ( src.loc )
						B.pixel_x = src.pixel_x
						B.pixel_y = src.pixel_y
						B.dir = src.dir
						src.circuit.construct(B)
						qdel(src)

		if(4)
			switch(frame_type)
				if("computer")  //computer and display steps
					if(istype(P, /obj/item/weapon/crowbar))
						playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
						user << "<span class='notice'>You remove the glass panel.</span>"
						src.state = 3
						src.icon_state = "[frame_type]_3"
						new /obj/item/stack/material/glass( src.loc, 2 )
					if(istype(P, /obj/item/weapon/screwdriver))
						playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
						user << "<span class='notice'>You connect the monitor.</span>"
						var/obj/machinery/B = new src.circuit.build_path ( src.loc )
						B.pixel_x = src.pixel_x
						B.pixel_y = src.pixel_y
						src.circuit.construct(B)
						qdel(src)

				if("display")  //computer and display steps
					if(istype(P, /obj/item/weapon/crowbar))
						playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
						user << "<span class='notice'>You remove the glass panel.</span>"
						src.state = 3
						src.icon_state = "[frame_type]_3"
						new /obj/item/stack/material/glass( src.loc, 2 )
					if(istype(P, /obj/item/weapon/screwdriver))
						playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
						user << "<span class='notice'>You connect the monitor.</span>"
						var/obj/machinery/B = new src.circuit.build_path ( src.loc)
						B.pixel_x = src.pixel_x
						B.pixel_y = src.pixel_y
						src.circuit.construct(B)
						qdel(src)