/obj/machinery/constructable_frame
	name = "machine frame"
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "box_0"
	density = 1
	anchored = 1
	use_power = 0

	var/obj/item/weapon/circuitboard/circuit = null
	var/list/components = null
	var/list/req_components = null
	var/list/req_component_names = null
	var/state = 0

/obj/machinery/constructable_frame/proc/update_desc()
	var/D
	if(req_components)
		var/list/component_list = list()
		for(var/I in req_components)
			if(req_components[I] > 0)
				component_list += "[num2text(req_components[I])] [req_component_names[I]]"
		D = "Requires [english_list(component_list)]."
	desc = D

/obj/machinery/constructable_frame/machine_frame/attackby(var/obj/item/O, var/mob/user)
	switch(state)
		if(0)
			if(istype(O, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/C = O
				if(C.get_amount() < 5)
					user << "<span class='warning'>You need five lengths of cable to add them to the frame.</span>"
					return
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
				user << "<span class='notice'>You start to add cables to the frame.</span>"
				if(do_after(user, 20) && state == 0)
					if(C.use(5))
						user << "<span class='notice'>You add cables to the frame.</span>"
						state = 1
						icon_state = "box_[state]"
			else
				if(istype(O, /obj/item/weapon/wrench))
					playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
					user << "<span class='notice'>You dismantle the frame</span>"
					new /obj/item/stack/material/steel(src.loc, 5)
					qdel(src)
		if(1)
			if(istype(O, /obj/item/weapon/circuitboard))
				var/obj/item/weapon/circuitboard/B = O
				if(B.board_type == "machine")
					playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
					user << "<span class='notice'>You add the circuit board to the frame.</span>"
					circuit = O
					user.drop_item()
					O.loc = src
					state = 2
					icon_state = "box_[state]"
					components = list()
					req_components = circuit.req_components.Copy()
					for(var/A in circuit.req_components)
						req_components[A] = circuit.req_components[A]
					req_component_names = list()
					for(var/A in req_components)
						var/obj/C = A
						req_component_names[A] = initial(C.name)
					update_desc()
					user << desc
				else
					user << "<span class='warning'>This frame does not accept circuit boards of this type!</span>"
			else
				if(istype(O, /obj/item/weapon/wirecutters))
					playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
					user << "<span class='notice'>You remove the cables.</span>"
					state = 0
					icon_state = "box_[state]"
					var/obj/item/stack/cable_coil/A = new /obj/item/stack/cable_coil(src.loc)
					A.amount = 5

		if(2)
			if(istype(O, /obj/item/weapon/crowbar))
				playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
				state = 1
				circuit.forceMove(src.loc)
				circuit = null
				if(components.len == 0)
					user << "<span class='notice'>You remove the circuit board.</span>"
				else
					user << "<span class='notice'>You remove the circuit board and other components.</span>"
					for(var/obj/item/weapon/W in components)
						W.forceMove(src.loc)
				desc = initial(desc)
				req_components = null
				components = null
				icon_state = "box_[state]"
			else
				if(istype(O, /obj/item/weapon/screwdriver))
					var/component_check = 1
					for(var/R in req_components)
						if(req_components[R] > 0)
							component_check = 0
							break
					if(component_check)
						playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
						var/obj/machinery/new_machine = new src.circuit.build_path(src.loc, src.dir) // Its component_parts MUST be a list - DO NOT apply baindain fixes here, it MUST runtime so the issue is visible
						
						new_machine.component_parts.Cut() // THIS IS ONLY IN PLACE BECAUSE I DON'T WANT TO DO USELESS WORK ON TELECOMMS AND INCREASE AMOUNT OF CONFLICTS WHEN THEY ARE BEING CUT SOON (PROBABLY)
						// AS SOON AS TCOMMS ARE SIMPLIFIED, THERE WILL BE A PR TO FIX THEM UP AND REMOVE THIS
						// OR IF THAT PR IS REJECTED FOR WHATEVER REASON
						// https://github.com/PolarisSS13/Polaris/pull/965 FOR THE REFERENCE
						
						src.circuit.construct(new_machine)
						for(var/obj/I in src)
							if(circuit.contain_parts) // things like disposal don't want their parts in them
								I.loc = new_machine
							else
								I.loc = null
							new_machine.component_parts += I
						
						if(circuit.contain_parts)
							circuit.loc = new_machine
						else
							circuit.loc = null
						
						new_machine.RefreshParts()
						qdel(src)
				else
					var/added = 0
					for(var/I in req_components)
						if(istype(O, I) && (req_components[I] > 0))
							added = 1
							playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
							if(istype(O, /obj/item/stack))
								var/obj/item/stack/CP = O
								if(CP.get_amount() > 1)
									var/camt = min(CP.amount, req_components[I]) // amount of cable to take, idealy amount required, but limited by amount provided
									var/obj/item/stack/CC = new CP.type(src)
									CC.amount = camt
									CC.update_icon()
									CP.use(camt)
									components += CC
									req_components[I] -= camt
									update_desc()
									break
							user.drop_item()
							O.loc = src
							components += O
							req_components[I]--
							update_desc()
							break
					if(added)
						user << desc
					else
						user << "<span class='warning'>You cannot add that component to the machine!</span>"
