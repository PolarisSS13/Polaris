/datum/shuttle/autodock/ferry/escape_pod
	var/datum/embedded_program/docking/simple/escape_pod_berth/arming_controller
	category = /datum/shuttle/autodock/ferry/escape_pod

/datum/shuttle/autodock/ferry/escape_pod/New()
	move_time = move_time + rand(-30, 60)
	if(name in emergency_shuttle.escape_pods)
		CRASH("An escape pod with the name '[name]' has already been defined.")
	emergency_shuttle.escape_pods[name] = src

	..()

	//find the arming controller (berth) - If not configured directly, try to read it from current location landmark
	var/arming_controller_tag = arming_controller
	if(!arming_controller && active_docking_controller)
		arming_controller_tag = active_docking_controller.id_tag
	arming_controller = SSshuttles.docking_registry[arming_controller_tag]
	if(!istype(arming_controller))
		CRASH("Could not find arming controller for escape pod \"[name]\", tag was '[arming_controller_tag]'.")

	//find the pod's own controller
	var/datum/embedded_program/docking/simple/prog = SSshuttles.docking_registry[docking_controller_tag]
	var/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/controller_master = prog.master
	if(!istype(controller_master))
		CRASH("Escape pod \"[name]\" could not find it's controller master! docking_controller_tag=[docking_controller_tag]")
	controller_master.pod = src

/datum/shuttle/autodock/ferry/escape_pod/can_launch()
	if(arming_controller && !arming_controller.armed)	//must be armed
		return 0
	if(location)
		return 0	//it's a one-way trip.
	return ..()

/datum/shuttle/autodock/ferry/escape_pod/can_force()
	if (arming_controller.eject_time && world.time < arming_controller.eject_time + 50)
		return 0	//don't allow force launching until 5 seconds after the arming controller has reached it's countdown
	return ..()

/datum/shuttle/autodock/ferry/escape_pod/can_cancel()
	return 0


//This controller goes on the escape pod itself
/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod
	name = "escape pod controller"
	program = /datum/embedded_program/docking/simple
	var/datum/shuttle/autodock/ferry/escape_pod/pod

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	var/datum/embedded_program/docking/simple/docking_program = program // Cast to proper type

	data = list(
		"docking_status" = docking_program.get_docking_status(),
		"override_enabled" = docking_program.override_enabled,
		"door_state" = 	docking_program.memory["door_status"]["state"],
		"door_lock" = 	docking_program.memory["door_status"]["lock"],
		"can_force" = pod.can_force() || (emergency_shuttle.departed && pod.can_launch()),	//allow players to manually launch ahead of time if the shuttle leaves
		"is_armed" = pod.arming_controller.armed,
	)

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "escape_pod_console.tmpl", name, 470, 290)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/Topic(href, href_list)
	if((. = ..()))
		return

	if(href_list["manual_arm"])
		pod.arming_controller.arm()
		return TOPIC_REFRESH
	if(href_list["force_launch"])
		if (pod.can_force())
			pod.force_launch(src)
		else if (emergency_shuttle.departed && pod.can_launch())	//allow players to manually launch ahead of time if the shuttle leaves
			pod.launch(src)
		return TOPIC_REFRESH
	return 0



//This controller is for the escape pod berth (station side)
/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod_berth
	name = "escape pod berth controller"
	program = /datum/embedded_program/docking/simple/escape_pod_berth

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod_berth/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	var/datum/embedded_program/docking/simple/docking_program = program // Cast to proper type

	var/armed = null
	if (istype(docking_program, /datum/embedded_program/docking/simple/escape_pod_berth))
		var/datum/embedded_program/docking/simple/escape_pod_berth/P = docking_program
		armed = P.armed

	data = list(
		"docking_status" = docking_program.get_docking_status(),
		"override_enabled" = docking_program.override_enabled,
		"armed" = armed,
	)

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "escape_pod_berth_console.tmpl", name, 470, 290)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod_berth/emag_act(var/remaining_charges, var/mob/user)
	if (!emagged)
		to_chat(user, "<span class='notice'>You emag the [src], arming the escape pod!</span>")
		emagged = 1
		if (istype(program, /datum/embedded_program/docking/simple/escape_pod_berth))
			var/datum/embedded_program/docking/simple/escape_pod_berth/P = program
			if (!P.armed)
				P.arm()
		return 1

//A docking controller program for a simple door based docking port
/datum/embedded_program/docking/simple/escape_pod_berth
	var/armed = 0
	var/eject_delay = 10	//give latecomers some time to get out of the way if they don't make it onto the pod
	var/eject_time = null
	var/closing = 0

/datum/embedded_program/docking/simple/escape_pod_berth/proc/arm()
	if(!armed)
		armed = 1
		open_door()


/datum/embedded_program/docking/simple/escape_pod_berth/receive_user_command(command)
	if (!armed)
		return TRUE // Eat all commands.
	return ..(command)

/datum/embedded_program/docking/simple/escape_pod_berth/process()
	..()
	if (eject_time && world.time >= eject_time && !closing)
		close_door()
		closing = 1

/datum/embedded_program/docking/simple/escape_pod_berth/prepare_for_docking()
	return

/datum/embedded_program/docking/simple/escape_pod_berth/ready_for_docking()
	return 1

/datum/embedded_program/docking/simple/escape_pod_berth/finish_docking()
	return		//don't do anything - the doors only open when the pod is armed.

/datum/embedded_program/docking/simple/escape_pod_berth/prepare_for_undocking()
	eject_time = world.time + eject_delay*10
