/datum/new_skill/engineering
	name = "Engineering"
	desc = "You understand the fundamentals required to keep the cold out and the lights on, more or less."
	freebies = list(/datum/new_skill/engineering_proficiency)
	tree = /datum/new_skill/engineering
	tree_parent = TRUE

/datum/new_skill/engineering_proficiency
	name = "Engineering Aptitude"
	desc = "You can examine some machines to get extra info about how they work."
	tree = /datum/new_skill/engineering

/datum/new_skill/atmospherics
	name = "Atmospherics"
	desc = "You're proficient with piping, air distribution, and gas dynamics. You've also worked with gas thrusters on spaceships, and understand how to keep them fueled and maintained."
	tree = /datum/new_skill/engineering

/datum/new_skill/construction
	name = "Construction"
	desc = "You understand how to assemble simple structures like tables, racks, and basic walls. This level of skill is typical for janitors or engineering trainees."
	tree = /datum/new_skill/engineering
	additional_ranks = list(
		"You understand how to assemble complex structures like decorative flooring, high-strength walls, and borosilicate glass windows. With electrical knowledge, you also understand how to construct APCs, air alarms, and so on. This level of skill is typical for dedicated engineers."
	)

/datum/new_skill/electronics
	name = "Electronics"
	desc = "You're skilled with the fundamentals of electrical engineering. You can fiddle with the wires of common machines, and assemble new ones if you have the appropriate construction knowledge."
	tree = /datum/new_skill/engineering

/datum/new_skill/supermatter
	name = "Supermatter"
	desc = "You know the fundamentals of supermatter as a material and as a generator, at least theoretically - how it functions, how it tends to interact with gases, and how to handle it in an emergency. Even if you don't know all of the specifics, you at least know enough to get the engine to produce power without blowing it up."
	tree = /datum/new_skill/engineering
