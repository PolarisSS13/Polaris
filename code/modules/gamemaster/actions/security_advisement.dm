/datum/gm_action/security_screening
	name = "security screening"
	departments = list(ROLE_SECURITY, ROLE_EVERYONE)

/datum/gm_action/security_screening/announce()
	spawn(rand(1 MINUTE, 2 MINUTES))
		command_announcement.Announce("[pick("A nearby Navy vessel", "A Solar official", "A Vir-Gov official", "A NanoTrasen board director")] has requested the screening of [pick("every other", "every", "suspicious", "willing")] [pickweight("Skrellian" = 5, "Unathi" = 10, "Vatborn" = 3, "Drone" = 30, "Positronic" = 25, "Teshari" = 2, "Tajaran" = 3, "Dionaean" = 1, "Zaddat" = 25, "Human" = 1, "Synthetic" = 5)] personnel onboard \the [station_name()].", "Security Advisement")

/datum/gm_action/security_screening/get_weight()
	return max(-20, 10 + round(gm.staleness * 1.5) - (gm.danger * 2)) + (metric.count_people_in_department(ROLE_SECURITY) * 10) + (metric.count_people_in_department(ROLE_EVERYONE) * 1.5)
