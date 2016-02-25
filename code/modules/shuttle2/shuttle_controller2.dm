/*
Aright, here's how the shuttle moving should work
First, if it's docked, it undocks.
Second, it starts a spin-up timer. For now it's arbitary, in the future it should depend on the shuttle's components.
If it's a long-range shuttle (merc, heist, etc), it jumps to an empty spot on z-level 2.
It jumps to the target coordinates.
And finally it checks if there's a docking port nearby and docks.
*/


var/global/datum/shuttle_controller2/shuttle_controller2

/datum/shuttle_controller2
	var/list/datum/shuttle2/shuttles = list()

/datum/shuttle_controller2/New()
	..()

	var/datum/shuttle2/curshuttle
	var/area/A
	var/turf/T

	var/datum/shuttle2/supply/supshuttle = new("Supply Shuttle")
	A = locate(/area/supply/dock)
	T = get_turf(locate(/obj/machinery/embedded_controller/radio) in A)
	supshuttle.attachToArea(A, T)
	supshuttle.addCoordinates("Station", 46, 112, 1)
	supshuttle.addCoordinates("Home", 161, 137, 2)
	supshuttle.docking_port = locate(/obj/machinery/embedded_controller/radio) in A // INCREDIBLY DIRTY HACK I WILL HATE MYSELF FOR THIS BUT FUCK THIS CODE IS TERRIBLE AND I NEED TO MAKE IT WORK SOMEHOW NOW
	shuttles["Supply Shuttle"] = supshuttle
	supshuttle.is_deep_space = 1
	supply_controller.shuttle = supshuttle

	curshuttle = new("Escape Pod 3")
	A = locate(/area/shuttle/escape_pod3/station)
	T = get_turf(locate(/obj/machinery/door/airlock) in A)
	curshuttle.attachToArea(A, T)
	shuttles["Escape Pod 3"] = curshuttle

	curshuttle = new("Mercenary Shuttle")
	A = locate(/area/syndicate_station/start)
	T = get_turf(locate(/obj/machinery/embedded_controller/radio/airlock/docking_port) in A)
	curshuttle.attachToArea(A, T)
	curshuttle.addCoordinates("Docked with the station", 201, 64, 1)
	shuttles["Mercenary Shuttle"] = curshuttle

// DEBUG BELOW

/mob/verb/moveShuttleToCoordinates(var/shuttleName as text, var/x as num, var/y as num, var/z as num)
	var/datum/shuttle2/S = shuttle_controller2.shuttles[shuttleName]
	if(istype(S))
		S.moveToCoordinates(x, y, z)

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
		S.addCoordinates(name, x, y, z)

/mob/verb/moveShuttle(var/shuttleName as text, var/name as text)
	var/datum/shuttle2/S = shuttle_controller2.shuttles[shuttleName]
	if(istype(S))
		S.moveTo(name)