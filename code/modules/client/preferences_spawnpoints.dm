var/global/list/spawntypes = list()

/proc/populate_spawn_points()
	spawntypes = list()
	for(var/type in typesof(/datum/spawnpoint)-/datum/spawnpoint)
		var/datum/spawnpoint/S = new type()
		spawntypes[S.display_name] = S

/datum/spawnpoint
	var/msg          //Message to display on the arrivals computer.
	var/list/turfs   //List of turfs to spawn on.
	var/display_name //Name used in preference setup.
	var/list/restrict_job = null
	var/list/disallow_job = null
	var/list/permit_offsite_job = null
	var/announce_channel = "Common"
	var/allowed_mob_types = JOB_SILICON|JOB_CARBON

/datum/spawnpoint/proc/check_job_spawning(job)
	var/datum/job/J = SSjob.get_job(job)
	if(!J) // Couldn't find, admin shenanigans? Allow it
		return TRUE
	if(J.offmap_spawn && !(job in permit_offsite_job) && !(job in restrict_job))
		return FALSE
	if(restrict_job && !(job in restrict_job))
		return FALSE
	if(disallow_job && (job in disallow_job))
		return FALSE
	if(!(J.mob_type & allowed_mob_types))
		return FALSE
	return TRUE

/datum/spawnpoint/proc/get_spawn_position()
	return get_turf(pick(turfs))

/datum/spawnpoint/arrivals
	display_name = "Arrivals Shuttle"
	msg = "will arrive to the station shortly by shuttle"

/datum/spawnpoint/arrivals/New()
	..()
	turfs = latejoin

/datum/spawnpoint/gateway
	display_name = "Gateway"
	msg = "has completed translation from offsite gateway"

/datum/spawnpoint/gateway/New()
	..()
	turfs = latejoin_gateway

/datum/spawnpoint/elevator
	display_name = "Elevator"
	msg = "has arrived from the residential district"

/datum/spawnpoint/elevator/New()
	..()
	turfs = latejoin_elevator

/datum/spawnpoint/checkpoint
	display_name = "Checkpoint"
	msg = "has arrived at the exterior checkpoint"

/datum/spawnpoint/checkpoint/New()
	..()
	turfs = latejoin_checkpoint

/datum/spawnpoint/cryo
	display_name = "Cryogenic Storage"
	msg = "has completed cryogenic revival"
	allowed_mob_types = JOB_CARBON

/datum/spawnpoint/cryo/New()
	..()
	turfs = latejoin_cryo

/datum/spawnpoint/cyborg
	display_name = "Cyborg Storage"
	msg = "has been activated from storage"
	allowed_mob_types = JOB_SILICON

/datum/spawnpoint/cyborg/New()
	..()
	turfs = latejoin_cyborg

/datum/spawnpoint/wilderness
	display_name = "Wilderness"
	msg = null

/datum/spawnpoint/wilderness/New()
	..()
	turfs = latejoin_wilderness
