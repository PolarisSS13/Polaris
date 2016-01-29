/datum/shuttle2
	var/name
	var/area/shuttle_area
	//var/direction
	var/turf/docking // The turf of the ship that is defined as the docking port

	var/obj/machinery/embedded_controller/radio/airlock/docking_port/docking_port

	var/size = 0
	var/engines = 0

/datum/shuttle2/New(var/newname)
	..()
	if(newname)
		name = newname
	else
		name = "Unknown shuttle"
	shuttle_area = new()
	shuttle_area.name = name
	//direction = NORTH

/datum/shuttle2/proc/init_components()
	if(!shuttle_area)
		return
	size = 0
	engines = 0
	for(var/turf/T in shuttle_area)
		++size
	for(var/obj/structure/shuttle/engine/propulsion/P in shuttle_area)
		++engines
	docking_port = locate() in shuttle_area

/datum/shuttle2/proc/undock()
	docking_port.docking_program.initiate_undocking()

/datum/shuttle2/proc/dock()
	var/obj/machinery/embedded_controller/radio/D = locate() in orange(7, docking_port)
	if(!D)
		world << "Docking not found"
		return
	world << "Docking found, [D] at [D.x] [D.y] [D.z], [D.id_tag]"
	docking_port.docking_program.initiate_docking(D.id_tag)

/datum/shuttle2/proc/add_turf(var/turf/T)
	shuttle_area.contents += T
	init_components()
	if(!docking)
		docking = T

/datum/shuttle2/proc/set_docking(var/turf/T)
	if(T in shuttle_area.contents)
		docking = T

/datum/shuttle2/proc/attach_to_area(var/area/A, var/turf/T)
	if(shuttle_area)
		del(shuttle_area) // Sadly, areas do not qdel
	shuttle_area = A
	docking = T
	init_components()

/datum/shuttle2/proc/move_to(var/x, var/y, var/z, var/newdir = null)
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

	attach_to_area(tmparea)

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
		S.add_turf(T)
	S.move_to(x, y, z)

/turf/verb/addToShuttle()
	testShuttle.add_turf(src)

/mob/verb/tryMove(var/x as num, var/y as num, var/z as num)
	testShuttle.move_to(x, y, z)
