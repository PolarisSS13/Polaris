/datum/new_skill/medicine
	name = "Medicine"
	desc = "You know roughly which body parts should go where, and how to tell if someone is hurt."
	tree = /datum/new_skill/medicine
	tree_parent = TRUE
	freebies = list(/datum/new_skill/medicine_proficiency)

/datum/new_skill/medicine_proficiency
	name = "Medicine Aptitude"
	desc = "You can safely operate chemistry machines - chem dispensers, grinders, and so on. You can probably synthesize simple medicines that are critical to running the medbay, but advanced recipes and custom mixes are generally beyond you."
	tree = /datum/new_skill/medicine

/datum/new_skill/anatomy
	name = "Anatomy"
	desc = "You can, with a great deal of care, open up a body and perform routine procedures like appendectomies. At this level, most of your experience will have come from training; you might not have actually worked with a real person on the slab, but as long as you have time and concentration, you can at least get the anesthetic machine turned on and the operation done - even if it's not as clean as it could be."
	tree = /datum/new_skill/medicine
	additional_ranks = list(
		"You're a pretty good surgeon. You've worked with living people of multiple types of species, and you know how to keep them stable in an emergency and during lifesaving operations. When someone rolls into the OR full of bullets, there's a decent chance you can save them with some help."
	)

/datum/new_skill/chemistry
	name = "Chemistry"
	desc = "You are experienced with chemistry machines and you can use them to synthesize complex medicines or, if you were so inclined, dangerous toxins. Even if you don't know every recipe by heart, you can follow a list of instructions without any trouble. Combining chemicals into cocktails to enhance their effects is second nature to you."
	tree = /datum/new_skill/medicine

/datum/new_skill/first_aid
	name = "First Aid"
	desc = "You know how to treat typical wounds. You can salve burns with ointment, patch cuts and bruises with gauze, and safely use a syringe to deliver chemicals. You know which medicines do what, even if you can't make them yourself."
	tree = /datum/new_skill/medicine

/datum/new_skill/psychology
	name = "Psychology"
	desc = "Intelligent minds are an impossible machine, but you know a little about how to help keep them running. You understand thought processes and the way people tend to act, and you can offer comfort and counseling to help ease the pains of isolation."
	tree = /datum/new_skill/medicine

/datum/new_skill/virology
	name = "Virology"
	desc = "You have a good understanding of pathology - how microorganisms like viruses and bacteria spread, how to prevent them from causing an outbreak, and how someone can keep themselves safe from exposure. You can safely handle cultivated samples, and with enough time and patience, engineer your own infections with different symptoms and causes."
	tree = /datum/new_skill/medicine
