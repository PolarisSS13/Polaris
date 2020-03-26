/datum/event2/meta/blob
	name = "blob"
	departments = list(DEPARTMENT_ENGINEERING, DEPARTMENT_SECURITY, DEPARTMENT_MEDICAL)
	chaos = 30
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_HIGH_IMPACT
	event_class = "blob" // This makes it so there is no potential for multiple blob events of different types happening in the same round.
	event_type = /datum/event2/event/blob
	// In the distant future, if a mechanical skill system were to come into being, these vars could be replaced with skill checks so off duty people could count.
	var/required_fighters = 2 // Fighters refers to engineering OR security.
	var/required_support = 1 // Support refers to doctors AND roboticists, depending on fighter composition.

/datum/event2/meta/blob/hard
	name = "harder blob"
	chaos = 40
	event_type = /datum/event2/event/blob/hard_blob
	required_fighters = 3

/datum/event2/meta/blob/multi_blob
	name = "multi blob"
	chaos = 60
	event_type = /datum/event2/event/blob/multi_blob
	required_fighters = 4
	required_support = 2

// For bussing only.
/datum/event2/meta/blob/omni_blob
	name = "omni blob"
	chaos = 200
	event_type = /datum/event2/event/blob/omni_blob
	enabled = FALSE

/datum/event2/meta/blob/get_weight()
	// Count the 'fighters'.
	var/list/engineers = metric.get_people_in_department(DEPARTMENT_ENGINEERING)
	var/list/security = metric.get_people_in_department(DEPARTMENT_SECURITY)

	if(engineers.len + security.len < required_fighters)
		return 0

	// Now count the 'support'.
	var/list/medical = metric.get_people_in_department(DEPARTMENT_MEDICAL)
	var/need_medical = FALSE

	var/list/robotics = metric.get_people_with_job(/datum/job/roboticist)
	var/need_robotics = FALSE

	// Determine what kind of support might be needed.
	for(var/mob/living/L in engineers|security)
		if(L.isSynthetic())
			need_robotics = TRUE
		else
			need_medical = TRUE

	// Medical is more important than robotics, since robits tend to not suffer slow deaths if there isn't a roboticist.
	if(medical.len < required_support && need_medical)
		return 0

	// Engineers can sometimes fill in as robotics. This is done in the interest of the event having a chance of not being super rare.
	// In the uncertain future, a mechanical skill system check could replace this check here.
	if(robotics.len + engineers.len < required_support && need_robotics)
		return 0

	var/fighter_weight = (engineers.len + security.len) * 20
	var/support_weight = (medical.len + robotics.len) * 10 // Not counting engineers as support so they don't cause 30 weight each.
	var/chaos_weight = chaos / 2 // Chaos is added as a weight in order to make more chaotic variants be preferred if they are allowed to be picked.

	return fighter_weight + support_weight + chaos_weight



/datum/event2/event/blob
	announce_delay_lower_bound = 1 MINUTE
	announce_delay_upper_bound = 5 MINUTES
	// This could be made into a GLOB accessible list for reuse if needed.
	var/list/area/excluded = list(
		/area/submap,
		/area/shuttle,
		/area/crew_quarters,
		/area/holodeck,
		/area/engineering/engine_room
	)
	var/list/open_turfs = list()
	var/area/target_area = null
	var/spawn_blob_type = /obj/structure/blob/core/random_medium
	var/number_of_blobs = 1
	var/list/blobs = list() // A list containing weakrefs to blob cores created. Weakrefs mean this event won't interfere with qdel.

/datum/event2/event/blob/hard_blob
	spawn_blob_type = /obj/structure/blob/core/random_hard

/datum/event2/event/blob/multi_blob
	spawn_blob_type = /obj/structure/blob/core/random_hard // Lethargic blobs are boring.
	number_of_blobs = 2

// For adminbus only.
/datum/event2/event/blob/omni_blob
	number_of_blobs = 16 // Someday maybe we can get this to specifically spawn every blob.

/datum/event2/event/blob/set_up()
	var/list/area/grand_list_of_areas = get_station_areas(excluded)
	if(grand_list_of_areas.len)
		for(var/i in 1 to 10)
			var/area/A = pick(grand_list_of_areas)
			if(is_area_occupied(A))
				log_debug("Blob infestation event: Rejected [A] because it is occupied.")
				continue
			var/list/turfs = list()
			for(var/turf/simulated/floor/F in A)
				if(!F.check_density())
					turfs += F
			if(turfs.len < 5 + number_of_blobs)
				log_debug("Blob infestation event: Rejected [A] because it has too little clear turfs.")
				continue
			open_turfs = turfs.Copy()
			target_area = A
			log_debug("Blob infestation event: Going to place blob at [A].")
			break

	if(!open_turfs.len)
		log_debug("Blob infestation event: Giving up after too many failures to pick a blob spot.")
		abort()

/datum/event2/event/blob/start()
	for(var/i = 1 to number_of_blobs)
		var/turf/T = pick(open_turfs)
		var/obj/structure/blob/core/new_blob = new spawn_blob_type(T)
		blobs += weakref(new_blob)
		open_turfs -= T // So we can't put two cores on the same tile if doing multiblob.
		log_debug("Spawned [new_blob.overmind.blob_type.name] blob at [get_area(new_blob)].")

/datum/event2/event/blob/should_end()
	for(var/WR in blobs)
		var/weakref/weakref = WR
		if(weakref.resolve()) // If the weakref is resolvable, that means the blob hasn't been deleted yet.
			return FALSE
	return TRUE // Only end if all blobs die.

// Normally this does nothing, but is useful if aborted by an admin.
/datum/event2/event/blob/end()
	for(var/WR in blobs)
		var/weakref/weakref = WR
		var/obj/structure/blob/core/B = weakref.resolve()
		if(istype(B))
			qdel(B)

/datum/event2/event/blob/announce()
	if(!ended) // Don't announce if the blobs die early.
		var/danger_level = 0
		var/list/blob_type_names = list()
		var/multiblob = FALSE
		for(var/WR in blobs)
			var/weakref/weakref = WR
			var/obj/structure/blob/core/B = weakref.resolve()
			if(!istype(B))
				continue
			var/datum/blob_type/blob_type = B.overmind.blob_type

			blob_type_names += blob_type.name
			if(danger_level > blob_type.difficulty) // The highest difficulty is used, if multiple blobs are present.
				danger_level = blob_type.difficulty

		if(blob_type_names.len > 1) // More than one blob is harder.
			danger_level += blob_type_names.len
			multiblob = TRUE

		var/list/lines = list()
		lines += "Confirmed outbreak of level [7 + danger_level] biohazard[multiblob ? "s": ""] \
		aboard [location_name()]. All personnel must contain the outbreak."

		if(danger_level >= BLOB_DIFFICULTY_MEDIUM) // Tell them what kind of blob it is if it's tough.
			lines += "The biohazard[multiblob ? "s have": " has"] been identified as [english_list(blob_type_names)]."

		if(danger_level >= BLOB_DIFFICULTY_HARD) // If it's really hard then tell them where it is so the response occurs faster.
			lines += "[multiblob ? "It is": "They are"] suspected to have originated from \the [target_area]."

		if(danger_level >= BLOB_DIFFICULTY_SUPERHARD)
			lines += "Extreme caution is advised."

		command_announcement.Announce(lines.Join("\n"), "Biohazard Alert", new_sound = 'sound/AI/outbreak7.ogg')

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

