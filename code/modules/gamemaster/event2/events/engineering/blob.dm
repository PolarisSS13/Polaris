/datum/event2/meta/blob
	name = "blob"
	departments = list(DEPARTMENT_ENGINEERING, DEPARTMENT_SECURITY, DEPARTMENT_MEDICAL)
	chaos = 50
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_HIGH_IMPACT
	event_type = /datum/event2/event/blob

/datum/event2/meta/blob/get_weight()
	var/engineers = metric.count_people_in_department(DEPARTMENT_ENGINEERING)
	var/security = metric.count_people_in_department(DEPARTMENT_SECURITY)
	var/medical = metric.count_people_in_department(DEPARTMENT_MEDICAL)

	var/assigned_staff = engineers + security
	if(engineers || security)	// Medical only counts if one of the other two exists, and even then they count as half.
		assigned_staff += round(medical / 2)

	var/weight = (max(assigned_staff - 2, 0) * 20) // An assigned staff count of 2 must be had to spawn a blob.
	return weight



/datum/event2/event/blob

	// This could be made into a GLOB accessible list if needed.
	var/list/area/excuded = list(
		/area/submap,
		/area/shuttle,
		/area/crew_quarters,
		/area/holodeck,
		/area/engineering/engine_room
	)
	var/turf/target_turf = null
	var/area/target_area = null
	var/spawn_blob_type = /obj/structure/blob/core/random_medium
	var/obj/structure/blob/core/blob_core = null

/datum/event2/event/blob/set_up()
	var/list/area/grand_list_of_areas = get_station_areas(excluded)

	for(var/i in 1 to 10)
		var/area/A = pick(grand_list_of_areas)
		if(is_area_occupied(A))
			log_debug("Blob infestation event: Rejected [A] because it is occupied.")
			continue
		var/list/turfs = list()
		for(var/turf/simulated/floor/F in A)
			if(turf_clear(F))
				turfs += F
		if(turfs.len == 0)
			log_debug("Blob infestation event: Rejected [A] because it has no clear turfs.")
			continue
		target_area = A
		target_turf = pick(turfs)

	if(!target_area)
		log_debug("Blob infestation event: Giving up after too many failures to pick target area")

/datum/event2/event/blob/start()
	blob_core = new spawn_blob_type(target_turf)

/datum/event2/event/blob/announce()
	spawn(rand(600, 3000))	// 1-5 minute leeway for the blob to go un-detected.
		command_announcement.Announce("Confirmed outbreak of level 7 biohazard aboard [station_name()]. All personnel must contain the outbreak.", "Biohazard Alert", new_sound = 'sound/AI/outbreak7.ogg')


/*
/datum/gm_action/blob
	name = "blob infestation"
	departments = list(DEPARTMENT_ENGINEERING, DEPARTMENT_SECURITY, DEPARTMENT_MEDICAL)
	chaotic = 25

	var/list/area/excluded = list(
		/area/submap,
		/area/shuttle,
		/area/crew_quarters,
		/area/holodeck,
		/area/engineering/engine_room
	)

	var/area/target_area	// Chosen target area
	var/turf/target_turf	// Chosen target turf in target_area

	var/obj/structure/blob/core/Blob
	var/spawn_blob_type = /obj/structure/blob/core/random_medium

/datum/gm_action/blob/set_up()
	severity = pickweight(EVENT_LEVEL_MUNDANE = 4,
		EVENT_LEVEL_MODERATE = 2,
		EVENT_LEVEL_MAJOR = 1
		)

	var/list/area/grand_list_of_areas = get_station_areas(excluded)

	for(var/i in 1 to 10)
		var/area/A = pick(grand_list_of_areas)
		if(is_area_occupied(A))
			log_debug("Blob infestation event: Rejected [A] because it is occupied.")
			continue
		var/list/turfs = list()
		for(var/turf/simulated/floor/F in A)
			if(turf_clear(F))
				turfs += F
		if(turfs.len == 0)
			log_debug("Blob infestation event: Rejected [A] because it has no clear turfs.")
			continue
		target_area = A
		target_turf = pick(turfs)

	if(!target_area)
		log_debug("Blob infestation event: Giving up after too many failures to pick target area")

/datum/gm_action/blob/start()
	..()
	var/turf/T

	if(severity == EVENT_LEVEL_MUNDANE || !target_area || !target_turf)
		T = pick(blobstart)
	else if(severity == EVENT_LEVEL_MODERATE)
		T = target_turf
	else
		T = target_turf
		spawn_blob_type = /obj/structure/blob/core/random_hard

	Blob = new spawn_blob_type(T)

/datum/gm_action/blob/announce()
	spawn(rand(600, 3000))	// 1-5 minute leeway for the blob to go un-detected.
		command_announcement.Announce("Confirmed outbreak of level 7 biohazard aboard [station_name()]. All personnel must contain the outbreak.", "Biohazard Alert", new_sound = 'sound/AI/outbreak7.ogg')

/datum/gm_action/blob/get_weight()
	var/engineers = metric.count_people_in_department(DEPARTMENT_ENGINEERING)
	var/security = metric.count_people_in_department(DEPARTMENT_SECURITY)
	var/medical = metric.count_people_in_department(DEPARTMENT_MEDICAL)

	var/assigned_staff = engineers + security
	if(engineers || security)	// Medical only counts if one of the other two exists, and even then they count as half.
		assigned_staff += round(medical / 2)

	var/weight = (max(assigned_staff - 2, 0) * 20) // An assigned staff count of 2 must be had to spawn a blob.
	return weight

*/

/*
/proc/level_seven_blob_announcement(var/obj/structure/blob/core/B)
	if(!B || !B.overmind)
		return
	var/datum/blob_type/blob = B.overmind.blob_type // Shortcut so we don't need to delve into three variables every time.
	var/list/lines = list()

	lines += "Confirmed outbreak of level [7 + blob.difficulty] biohazard aboard [station_name()]. All personnel must contain the outbreak."

	if(blob.difficulty >= BLOB_DIFFICULTY_MEDIUM) // Tell them what kind of blob it is if it's tough.
		lines += "The biohazard has been identified as a '[blob.name]'."

	if(blob.difficulty >= BLOB_DIFFICULTY_HARD) // If it's really hard then tell them where it is so the response occurs faster.
		lines += "It is suspected to have originated from \the [get_area(B)]."

	if(blob.difficulty >= BLOB_DIFFICULTY_SUPERHARD)
		lines += "Extreme caution is advised."

	command_announcement.Announce(lines.Join("\n"), "Biohazard Alert", new_sound = 'sound/AI/outbreak7.ogg')
*/