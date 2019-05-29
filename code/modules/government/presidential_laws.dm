// Laws can be set by the president, here.

#define MISDEMEANOR_OFFENSE "Misdemeanor Offense"
#define CRIMINAL_OFFENSE "Criminal Offense"
#define MAJOR_OFFENSE "Major Offense"
#define CAPITAL_OFFENSE "Capital Offense"

#define PERMANENT_IMPRISONMENT -1

var/global/list/presidential_laws = list()

var/global/list/misdemeanor_laws = list()
var/global/list/criminal_laws = list()
var/global/list/major_laws = list()
var/global/list/capital_laws = list()

/datum/law
	var/id // automatically generated

	var/name = "Sample Law"
	var/description = "n/a"
	var/notes = "n/a"

	var/law_color						//	Color classification

	var/fine = 40						//	In credits
	var/class = MISDEMEANOR_OFFENSE
	var/cell_time = 50					//	How long the jail time should be (in minutes)

	var/death_penalty = 0				//	Can this law KILL people, can it?!

	var/prefix = 1
	var/can_edit = 1					//	Can the president touch this?

	var/passed_by = "NanoTrasen"		//	Passed by who? (president)
	var/last_edited = "NanoTrasen"		//	Last edited by who? (president)
	var/related_act						//	What act introduced this abomination?



