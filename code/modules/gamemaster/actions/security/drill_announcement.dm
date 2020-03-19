/datum/gm_action/security_drill
	name = "security drills"
	departments = list(DEPARTMENT_SECURITY, DEPARTMENT_EVERYONE)
	chaos_threshold = 20 // To avoid CentCom from mandating a drill while people are dying left and right.

/datum/gm_action/security_drill/announce()
	command_announcement.Announce("[pick("A NanoTrasen security director", "A Vir-Gov correspondant", "Local Sif authoritiy")] \
	has advised the enactment of [pick("a rampant wildlife", "a fire", "a hostile boarding", "a nonstandard", \
	"a bomb", "an emergent intelligence")] drill with the personnel onboard \the [station_name()].", "Security Advisement")

/datum/gm_action/security_drill/get_weight()
	var/sec = metric.count_people_in_department(DEPARTMENT_SECURITY)
	var/everyone = metric.count_people_in_department(DEPARTMENT_EVERYONE)

	if(!sec) // If there's no security, then there is no drill.
		return 0
	if(everyone - sec < 0) // If there's no non-sec, then there is no drill.
		return 0

	// Each security player adds +5 weight, while non-security adds +1.5.
	return (sec * 5) + ((everyone - sec) * 1.5)
