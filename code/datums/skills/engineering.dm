#define SKILL_ENGINEERING "engineering"
#define SKILL_ENGINEERING_APTITUDE "engineering_aptitude"
#define SKILL_ATMOSPHERICS "atmospherics"
#define SKILL_CONSTRUCTION "construction"
#define SKILL_ELECTRONICS "electronics"
#define SKILL_SUPERMATTER "supermatter"

/datum/new_skill/engineering
	id = SKILL_ENGINEERING
	name = "Engineering"
	desc = "You understand the fundamentals required to keep the cold out and the lights on, more or less."
	freebies = list(SKILL_ENGINEERING_APTITUDE)

/datum/new_skill/engineering_proficiency
	id = SKILL_ENGINEERING_APTITUDE
	name = "Engineering Aptitude"
	desc = "You can examine some machines to get extra info about how they work."

/datum/new_skill/atmospherics
	id = SKILL_ATMOSPHERICS
	name = "Atmospherics"
	desc = "You're proficient with piping, air distribution, and gas dynamics. You've also worked with gas thrusters on spaceships, and understand how to keep them fueled and maintained."

/datum/new_skill/construction
	id = SKILL_CONSTRUCTION
	name = "Construction"
	desc = "You understand how to assemble simple structures like tables, racks, and basic walls. This level of skill is typical for janitors or engineering trainees."
	additional_ranks = list(
		"You understand how to assemble complex structures like decorative flooring, high-strength walls, and borosilicate glass windows. With electrical knowledge, you also understand how to construct APCs, air alarms, and so on. This level of skill is typical for dedicated engineers."
	)

/datum/new_skill/electronics
	id = SKILL_ELECTRONICS
	name = "Electronics"
	desc = "You're skilled with the fundamentals of electrical engineering. You can fiddle with the wires of common machines, and assemble new ones if you have the appropriate construction knowledge."

/datum/new_skill/supermatter
	id = SKILL_SUPERMATTER
	name = "Supermatter"
	desc = "You know the fundamentals of supermatter as a material and as a generator, at least theoretically - how it functions, how it tends to interact with gases, and how to handle it in an emergency. Even if you don't know all of the specifics, you at least know enough to get the engine to produce power without blowing it up."
