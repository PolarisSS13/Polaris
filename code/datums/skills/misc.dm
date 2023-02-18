#define SKILL_EXOSUIT_OPERATION "exosuit_operation"
#define SKILL_PILOTING "piloting"
#define SKILL_BOTANY "botany"
#define SKILL_COOKING "cooking"
#define SKILL_MIXOLOGY "mixology"

/datum/new_skill/exosuit_operation
	id = SKILL_EXOSUIT_OPERATION
	name = "Exosuit Operation"
	desc = "You can get into the cockpit of an exosuit and operate it smoothly without stumbling or getting confused. You might not be experienced with fighting with exosuits, but you at least have a grasp of the basics and understand how to maneuver several tons of steel around yourself without getting mulched in the process."

/datum/new_skill/piloting
	id = SKILL_PILOTING
	name = "Piloting"
	desc = "You can pilot shuttles, manual escape pods, and other small spacecraft, both in an atmosphere and in space. You can perform simple maneuvers with the aid of flight assists, and you can pilot small craft into and out of an atmosphere."
	additional_ranks = list(
		"You're a strong pilot for spacecraft up to and including large shuttles. You can perform complex maneuvers in agile ships, and you know how to get somewhere quickly and efficiently - and if need be, your dogfighting is passable, too.",
		"You're an extremely experienced pilot, with years of training and practice under your belt. You could comfortably take the helm of large vessels and pilot them through deep space hazards and attacks. If you're a fighter pilot, you're damn good at it."
	)

/datum/new_skill/botany
	id = SKILL_BOTANY
	name = "Botany"
	desc = "You know the basics of how to grow plants for food and resource production, both in natural soil and in hydroponics trays, and you're pretty good at it. You can maintain small hydroponics bays on your own, as long as you have the time and the things you need."

/datum/new_skill/cooking
	id = SKILL_COOKING
	name = "Cooking"
	desc = "Anyone can toss a pocket in the microwave or cook a frozen pizza. You know how to make *real* food - from scratch, with hand-picked ingredients. You can experiment to find new variations of recipes, and generally comfortably cook anything in a cookbook as long as you have the things you need for it."

/datum/new_skill/mixology
	id = SKILL_MIXOLOGY
	name = "Mixology"
	desc = "The difference between warm garbage and a pint of perfectly-chilled craft beer is you. You know how to make cocktails - both with and without alcohol - that taste good, and you know how to serve them just right. You might have even dabbled in homebrewing."
