#define SHUTTLE_IDLE 0
#define SHUTTLE_SPINNING 1
#define SHUTTLE_DEEP_SPACE 2

/datum/shuttle2
	var/name
	var/area/shuttle_area
	//var/direction
	//var/turf/docking // The turf of the ship that is defined as the docking port // Nope, bad idea
	var/dockX
	var/dockY
	var/dockZ

	var/list/known_coordinates = list()

	var/obj/machinery/embedded_controller/radio/docking_port
	var/datum/computer/file/embedded_program/docking/docking_program

	var/size = 0
	var/engines = 0

	var/status = SHUTTLE_IDLE
	var/spin_time = 40
	var/is_deep_space = 0 // Should only be 0 for elevators and such
	var/move_time = 100 // Only matters if [is_deep_space] is 1

/datum/shuttle2/New(var/newname)
	..()
	if(newname)
		name = newname
	else
		name = "Unknown shuttle"
	shuttle_area = new()
	shuttle_area.name = name
	shuttle_area.base_turf = /turf/space
	//direction = NORTH

/datum/shuttle2/proc/initComponents()
	if(!shuttle_area)
		return
	size = 0
	engines = 0
	for(var/turf/T in shuttle_area)
		++size
	for(var/obj/structure/shuttle/engine/propulsion/P in shuttle_area)
		++engines
	docking_port = locate() in shuttle_area
	if(istype(docking_port, /obj/machinery/embedded_controller/radio/airlock/docking_port))
		var/obj/machinery/embedded_controller/radio/airlock/docking_port/D = docking_port
		docking_program = D.docking_program
	else if(istype(docking_port, /obj/machinery/embedded_controller/radio/docking_port_multi))
		var/obj/machinery/embedded_controller/radio/docking_port_multi/D = docking_port
		docking_program = D.docking_program
	else if(istype(docking_port, /obj/machinery/embedded_controller/radio/simple_docking_controller))
		var/obj/machinery/embedded_controller/radio/simple_docking_controller/D = docking_port
		docking_program = D.docking_program

/datum/shuttle2/proc/moveTo(var/name, var/forced = 0)
	if(status != SHUTTLE_IDLE)
		return
	var/list/P = known_coordinates[name]
	if(!P)
		return
	world << "Undocking"
	undock()
	world << "Undocked, spinning"
	status = SHUTTLE_SPINNING
	sleep(spin_time)
	world << "Spun up"
	if(is_deep_space)
		// TODO
		world << "Entering deep space"
		status = SHUTTLE_DEEP_SPACE
		sleep(move_time)
		world << "Leaving deep space"
	
	world << "Moving"
	status = SHUTTLE_SPINNING
	moveToCoordinates(P["x"], P["y"], P["z"])
	world << "Moved, docking"
	dock()
	world << "All good"
	status = SHUTTLE_IDLE

/datum/shuttle2/proc/undock()
	docking_program.initiate_undocking()

/datum/shuttle2/proc/dock()
	var/obj/machinery/embedded_controller/radio/D = locate() in orange(7, docking_port)
	if(!D)
		world << "Docking not found"
		return
	world << "Docking found, [D] at [D.x] [D.y] [D.z], [D.id_tag]"
	docking_program.initiate_docking(D.id_tag)

/datum/shuttle2/proc/addTurf(var/turf/T)
	shuttle_area.contents += T
	initComponents()

/datum/shuttle2/proc/setDocking(var/turf/T)
	if(T in shuttle_area.contents)
		dockX = T.x
		dockY = T.y
		dockZ = T.z

/datum/shuttle2/proc/attachToArea(var/area/A, var/turf/T)
	if(shuttle_area)
		del(shuttle_area) // Sadly, areas do not qdel
	shuttle_area = A
	shuttle_area.base_turf = /turf/space
	setDocking(T)
	initComponents()

/datum/shuttle2/proc/addCoordinates(var/name, var/x, var/y, var/z)
	if(known_coordinates[name])
		known_coordinates -= name

	known_coordinates[name] = list("x" = x, "y" = y, "z" = z)

/datum/shuttle2/proc/moveToCoordinates(var/x, var/y, var/z)
	world << "[x] [y] [z]"

	for(var/turf/T in shuttle_area.contents)
		var/dx = dockX - T.x
		var/dy = dockY - T.y
		var/dz = dockZ - T.z

		var/turf/move_to = locate(x - dx, y - dy, z - dz)
		if(!(istype(move_to, /turf/space)))
			world << "Non-space turf at [x - dx], [y - dy], [z - dz]"
			return
		var/area/A = move_to.loc
		if(!(istype(A, /area/space)))
			world << "Non-space area at [x - dx], [y - dy], [z - dz]"
			return

	var/area/tmparea = new()

	for(var/turf/T in shuttle_area.contents)
		var/dx = dockX - T.x
		var/dy = dockY - T.y
		var/dz = dockZ - T.z

		var/turf/move_to = locate(x - dx, y - dy, z - dz)

		tmparea.contents += move_to

	shuttle_area.move_contents_to(tmparea)
	tmparea.name = name

	dockX = x
	dockY = y
	dockZ = z

	attachToArea(tmparea)
	world << "Moved successfully"

/datum/shuttle2/proc/get_location_area()
	return shuttle_area

/datum/shuttle2/proc/has_arrive_time()
	return (status == SHUTTLE_DEEP_SPACE)

/datum/shuttle2/proc/is_launching()
	return (status == SHUTTLE_SPINNING)

/datum/shuttle2/proc/can_force()
	return (status == SHUTTLE_IDLE)

/datum/shuttle2/proc/can_launch()
	return (status == SHUTTLE_IDLE) // TODO

/datum/shuttle2/proc/can_cancel()
	return (status == SHUTTLE_IDLE) // TODO

/datum/shuttle2/proc/at_station()
	return (shuttle_area.z in config.station_levels)

/datum/shuttle2/proc/eta_minutes()
	return 2 // TODO

/datum/shuttle2/supply
	var/arrive_time = 5 // TODO

/datum/shuttle2/supply/proc/forbidden_atoms_check()
	if(!at_station()) // If badmins want to send mobs or a nuke on the supply shuttle from centcom we don't care
		return 0
	return supply_controller.forbidden_atoms_check(get_location_area())

/datum/shuttle2/supply/proc/launch()
	moveTo(at_station() ? "Home" : "Station")
	return // TODO

/datum/shuttle2/supply/proc/force_launch()
	return // TODO

/datum/shuttle2/supply/proc/cancel_launch()
	return // TODO

// DEBUG BELOW

/datum/shuttle2/proc/showInfo()
	world << name
	world << shuttle_area
	world << status
	//var/direction
	world << dockX
	world << dockY
	world << dockZ

	world << docking_port

	world << size
	world << engines

var/datum/shuttle2/testShuttle = new()

/mob/verb/defineShuttleFromThisAreaAndMoveIt(var/x as num, var/y as num, var/z as num)
	var/datum/shuttle2/S = new()
	for(var/turf/T in get_area(loc))
		S.addTurf(T)
	S.moveToCoordinates(x, y, z)

/turf/verb/addToShuttle()
	testShuttle.addTurf(src)

/mob/verb/tryMove(var/x as num, var/y as num, var/z as num)
	testShuttle.moveToCoordinates(x, y, z)
