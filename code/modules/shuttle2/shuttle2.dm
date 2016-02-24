#define SHUTTLE_IDLE 0
#define SHUTTLE_SPINNING 1
#define SHUTTLE_DEEP_SPACE 2

/datum/shuttle2
	var/name
	var/area/shuttle_area
	//var/direction
	var/turf/docking // The turf of the ship that is defined as the docking port

	var/list/known_coordinates = list()

	var/obj/machinery/embedded_controller/radio/airlock/docking_port/docking_port

	var/size = 0
	var/engines = 0

	var/status = SHUTTLE_IDLE
	var/spin_time = 40
	var/is_deep_space = 0
	var/move_time = 100 // Only matters if [is_deep_space] is 1

/datum/shuttle2/New(var/newname)
	..()
	if(newname)
		name = newname
	else
		name = "Unknown shuttle"
	shuttle_area = new()
	shuttle_area.name = name
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

/datum/shuttle2/proc/moveTo(var/name)
	if(status != SHUTTLE_IDLE)
		return
	var/list/P = known_coordinates[name]
	if(!P)
		return
	undock()
	status = SHUTTLE_SPINNING
	sleep(spin_time)
	if(is_deep_space)
		
		sleep(move_time)
	
	moveToCoordinates(P["x"], P["y"], P["z"])
	dock()

/datum/shuttle2/proc/undock()
	docking_port.docking_program.initiate_undocking()

/datum/shuttle2/proc/dock()
	var/obj/machinery/embedded_controller/radio/D = locate() in orange(7, docking_port)
	if(!D)
		world << "Docking not found"
		return
	world << "Docking found, [D] at [D.x] [D.y] [D.z], [D.id_tag]"
	docking_port.docking_program.initiate_docking(D.id_tag)

/datum/shuttle2/proc/addTurf(var/turf/T)
	shuttle_area.contents += T
	initComponents()
	if(!docking)
		docking = T

/datum/shuttle2/proc/setDocking(var/turf/T)
	if(T in shuttle_area.contents)
		docking = T

/datum/shuttle2/proc/attachToArea(var/area/A, var/turf/T)
	if(shuttle_area)
		del(shuttle_area) // Sadly, areas do not qdel
	shuttle_area = A
	docking = T
	initComponents()

/datum/shuttle2/proc/addCoordinates(var/name, var/x, var/y, var/z)
	if(known_coordinates[name])
		known_coordinates -= name

	known_coordinates[name] = list("x" = x, "y" = y, "z" = z)

/datum/shuttle2/proc/moveToCoordinates(var/x, var/y, var/z)
	if(!docking)
		return

	var/dockx = docking.x
	var/docky = docking.y
	var/dockz = docking.z

	for(var/turf/T in shuttle_area.contents)
		var/dx = dockx - T.x
		var/dy = docky - T.y
		var/dz = dockz - T.z

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
		var/dx = dockx - T.x
		var/dy = docky - T.y
		var/dz = dockz - T.z

		var/turf/move_to = locate(x - dx, y - dy, z - dz)

		tmparea.contents += move_to

	shuttle_area.move_contents_to(tmparea)
	tmparea.name = name

	docking = locate(x, y, z)

	attachToArea(tmparea)

/datum/shuttle2/proc/showInfo()
	world << name
	world << shuttle_area
	//var/direction
	world << docking // The turf of the ship that is defined as the docking port

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
