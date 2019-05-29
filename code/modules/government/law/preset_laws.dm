
//Some of the preset laws. Loaded if we don't have laws existing.

//These don't need to be changed. Just gives the laws their prefixes.
/datum/law/misdemeanor
	prefix = 1
	class = MISDEMEANOR_OFFENSE
	cell_time = 5
	law_color = "#00395F" // blue

/datum/law/criminal
	prefix = 2
	class = CRIMINAL_OFFENSE

	law_color = "#e8931e" // orange

/datum/law/major
	prefix = 3
	class = MAJOR_OFFENSE

	law_color = "#d8261a" // red

/datum/law/capital
	prefix = 4
	class = CAPITAL_OFFENSE

	law_color = "#636363" // gray

	fine = 0
	cell_time = PERMANENT_IMPRISONMENT

