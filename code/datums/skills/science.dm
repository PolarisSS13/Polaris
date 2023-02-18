#define SKILL_TREE_SCIENCE "!!SCIENCE!!"

#define SKILL_SCIENCE "!!SCIENCE!!"
#define SKILL_SCIENCE_APTITUDE "science_aptitude"
#define SKILL_COMPLEX_DEVICES "complex_devices"
#define SKILL_XENOARCHAEOLOGY "xenoarchaeology"
#define SKILL_XENOBIOLOGY "xenobiology"
#define SKILL_XENOBOTANY "xenobotany"

/datum/new_skill/science
	id = SKILL_SCIENCE
	name = "Science"
	desc = "Modern science is a tangled smorgasbord of different disciplines, fields, and specializations. You understand enough about research and the scientific method to work in that smorgasbord, even if it might not be comfortable or familiar."
	tree = SKILL_TREE_SCIENCE
	tree_parent = TRUE
	freebies = list(SKILL_SCIENCE_APTITUDE)

/datum/new_skill/science_proficiency
	id = SKILL_SCIENCE_APTITUDE
	name = "Science Aptitude"
	desc = "You can use the R&D machines to analyze the material composition of objects, and use that knowledge to make new things."
	tree = SKILL_TREE_SCIENCE

/datum/new_skill/devices
	id = SKILL_COMPLEX_DEVICES
	name = "Complex Devices"
	desc = "You can assemble and work with everyday devices like computers, gas tank assemblies, and simple robots. You could disassemble a tablet and know what each part does, and you could probably slap together something like a medibot with a little trial and error. Most station scientists operate at this level, as do a lot of hobbyists."
	tree = SKILL_TREE_SCIENCE
	additional_ranks = list(
		"You have a strong understanding of how electronic devices work and how to put them together. You can build and maintain drones and cyborgs, and you can probably work with integrated circuits at a proficient level. This level of competence is typical for roboticists, and usually comes with electrical knowledge as well."
	)

/datum/new_skill/xenoarchaeology
	id = SKILL_XENOARCHAEOLOGY
	name = "Xenoarchaeology"
	desc = "You understand how to safely unearth and handle artifacts from the Anomalous Region. You can set up and work in a digsite without smashing the things you're trying to excavate, and then figure out what those things do and how to use and store them without exposing yourself to their negative effects."
	tree = SKILL_TREE_SCIENCE

/datum/new_skill/xenobiology
	id = SKILL_XENOBIOLOGY
	name = "Xenobiology"
	desc = "You know how to work with unfamiliar alien fauna - how to approach them carefully, document their behaviors, and defend yourself from them if need be. You've worked with creatures common in your line of work and you can generally prevent them from mauling you to death."
	tree = SKILL_TREE_SCIENCE

/datum/new_skill/xenobotany
	id = SKILL_XENOBOTANY
	name = "Xenobotany"
	desc = "You can work with alien and mutated flora without killing the plant (or yourself) in the process. You also know how to take clippings non-destructively, and then use those clippings to create hybrid plants for fun and profit."
	tree = SKILL_TREE_SCIENCE
