var/global/datum/shuttle_controller2/shuttle_controller2

/datum/shuttle_controller2
	var/list/datum/shuttle2/shuttles = list()

/datum/shuttle_controller2/New()
	..()

	var/datum/shuttle2/curshuttle
	var/area/A
	var/turf/T

	curshuttle = new("Escape Pod 3")
	A = locate(/area/shuttle/escape_pod3/station)
	T = get_turf(locate(/obj/machinery/door/airlock) in A)
	curshuttle.attachToArea(A, T)
	shuttles["Escape Pod 3"] = curshuttle

	curshuttle = new("Mercenary Shuttle")
	A = locate(/area/syndicate_station/start)
	T = get_turf(locate(/obj/machinery/embedded_controller/radio/airlock/docking_port) in A)
	curshuttle.attachToArea(A, T)
	curshuttle.addCoordynates("Docked with the station", 201, 64, 1)
	shuttles["Mercenary Shuttle"] = curshuttle

/mob/verb/moveShuttleToCoordinates(var/shuttleName as text, var/x as num, var/y as num, var/z as num)
	var/datum/shuttle2/S = shuttle_controller2.shuttles[shuttleName]
	if(istype(S))
		S.moveTo(x, y, z)

/mob/verb/undockShip(var/shuttleName as text)
	var/datum/shuttle2/S = shuttle_controller2.shuttles[shuttleName]
	if(istype(S))
		S.undock()

/mob/verb/dockShip(var/shuttleName as text)
	var/datum/shuttle2/S = shuttle_controller2.shuttles[shuttleName]
	if(istype(S))
		S.dock()

/mob/verb/showInfo(var/shuttleName as text)
	var/datum/shuttle2/S = shuttle_controller2.shuttles[shuttleName]
	if(istype(S))
		S.showInfo()

/mob/verb/addShipCoordynates(var/shuttleName as text, var/name as text, var/x as num, var/y as num, var/z as num)
	var/datum/shuttle2/S = shuttle_controller2.shuttles[shuttleName]
	if(istype(S))
		S.addCoordynates(name, x, y, z)

/mob/verb/moveShipToCoordynates(var/shuttleName as text, var/name as text)
	var/datum/shuttle2/S = shuttle_controller2.shuttles[shuttleName]
	if(istype(S))
		S.moveToCoordynates(name)