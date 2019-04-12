/datum/gm_action/wormholes
	name = "space-time anomalies"
	chaotic = 70
	length = 6 MINUTES	// 5 minutes to spawn all the wormholes, up to 6 minutes for the last one to dissipate.
	departments = list(ROLE_EVERYONE)

/datum/gm_action/wormholes/start()
	..()
	wormhole_event()

/datum/gm_action/wormholes/get_weight()
	return 10 + max(0, -30 + (metric.count_people_in_department(ROLE_EVERYONE) * 5) + (metric.count_people_in_department(ROLE_ENGINEERING) + 10) + (metric.count_people_in_department(ROLE_MEDICAL) * 20))

/datum/gm_action/wormholes/end()
	command_announcement.Announce("There are no more space-time anomalies detected on the station.", "Anomaly Alert")
