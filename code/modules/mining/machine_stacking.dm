/**********************Mineral stacking unit console**************************/

/obj/machinery/mineral/stacking_unit_console
	name = "stacking machine console"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "console"
	layer = ABOVE_WINDOW_LAYER
	density = 1
	anchored = 1
	var/obj/machinery/mineral/stacking_machine/machine = null
	//var/machinedir = SOUTHEAST //This is really dumb, so lets burn it with fire.

/obj/machinery/mineral/stacking_unit_console/New()

	..()

	spawn(7)
		//src.machine = locate(/obj/machinery/mineral/stacking_machine, get_step(src, machinedir)) //No.
		src.machine = locate(/obj/machinery/mineral/stacking_machine) in range(5,src)
		if (machine)
			machine.console = src
		else
			//Silently failing and causing mappers to scratch their heads while runtiming isn't ideal.
			to_world("<span class='danger'>Warning: Stacking machine console at [src.x], [src.y], [src.z] could not find its machine!</span>")
			qdel(src)

/obj/machinery/mineral/stacking_unit_console/attack_hand(mob/user)
	add_fingerprint(user)
	interact(user)

/obj/machinery/mineral/stacking_unit_console/interact(mob/user)
	user.set_machine(src)

	var/dat

	dat += text("<h1>Stacking unit console</h1><hr><table>")

	for(var/stacktype in machine.stack_storage)
		if(machine.stack_storage[stacktype] > 0)
			dat += "<tr><td width = 150><b>[capitalize(stacktype)]:</b></td><td width = 30>[machine.stack_storage[stacktype]]</td><td width = 50><A href='?src=\ref[src];release_stack=[stacktype]'>\[release\]</a></td></tr>"
	dat += "</table><hr>"
	dat += text("<br>Stacking: [machine.stack_amt] <A href='?src=\ref[src];change_stack=1'>\[change\]</a><br><br>")

	user << browse("[dat]", "window=console_stacking_machine")
	onclose(user, "console_stacking_machine")


/obj/machinery/mineral/stacking_unit_console/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["change_stack"])
		var/choice = input("What would you like to set the stack amount to?") as null|anything in list(1,5,10,20,50)
		if(!choice) return
		machine.stack_amt = choice

	if(href_list["release_stack"])
		if(machine.stack_storage[href_list["release_stack"]] > 0)
			var/stacktype = machine.stack_paths[href_list["release_stack"]]
			var/obj/item/stack/material/S = new stacktype (get_turf(machine.output))
			S.amount = machine.stack_storage[href_list["release_stack"]]
			machine.stack_storage[href_list["release_stack"]] = 0
			S.update_icon()

	src.add_fingerprint(usr)
	src.updateUsrDialog()

	return

/**********************Mineral stacking unit**************************/


/obj/machinery/mineral/stacking_machine
	name = "stacking machine"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "stacker"
	density = 1
	anchored = 1.0
	var/obj/machinery/mineral/stacking_unit_console/console
	var/obj/machinery/mineral/input = null
	var/obj/machinery/mineral/output = null
	var/list/stack_storage[0]
	var/list/stack_paths[0]
	var/stack_amt = 50; // Amount to stack before releassing

/obj/machinery/mineral/stacking_machine/New()
	..()

	for(var/stacktype in (subtypesof(/obj/item/stack/material) - typesof(/obj/item/stack/material/cyborg)))
		var/obj/item/stack/material/S = stacktype
		var/s_matname = initial(S.default_type)
		stack_storage[s_matname] = 0
		stack_paths[s_matname] = stacktype

	spawn( 5 )
		for (var/dir in cardinal)
			src.input = locate(/obj/machinery/mineral/input, get_step(src, dir))
			if(src.input) break
		for (var/dir in cardinal)
			src.output = locate(/obj/machinery/mineral/output, get_step(src, dir))
			if(src.output) break
		return
	return

/obj/machinery/mineral/stacking_machine/proc/toggle_speed(var/forced)
	if(forced)
		speed_process = forced
	else
		speed_process = !speed_process // switching gears
	if(speed_process) // high gear
		STOP_MACHINE_PROCESSING(src)
		START_PROCESSING(SSfastprocess, src)
	else // low gear
		STOP_PROCESSING(SSfastprocess, src)
		START_MACHINE_PROCESSING(src)

/obj/machinery/mineral/stacking_machine/process()
	if (src.output && src.input)
		var/turf/T = get_turf(input)
		for(var/obj/item/O in T.contents)
			if(!O) return
			if(istype(O,/obj/item/stack/material))
				var/obj/item/stack/material/S = O
				var/matname = S.material.name
				if(!isnull(stack_storage[matname]))
					stack_storage[matname] += S.amount
					qdel(S)
				else
					O.loc = output.loc
			else
				O.loc = output.loc

	//Output amounts that are past stack_amt.
	for(var/sheet in stack_storage)
		if(stack_storage[sheet] >= stack_amt)
			var/stacktype = stack_paths[sheet]
			var/obj/item/stack/material/S = new stacktype (get_turf(output))
			S.amount = stack_amt
			stack_storage[sheet] -= stack_amt
			S.update_icon()
	
	if(console)
		console.updateUsrDialog()
	return

