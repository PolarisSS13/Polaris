/datum/new_skill/combat
	name = "Combat"
	desc = "You know the fundamentals of fighting - what end to point at the other thing, basic chain of command, and so on."
	tree = /datum/new_skill/combat
	tree_parent = TRUE

/datum/new_skill/cqc
	name = "Close Quarters"
	desc = "Your ability to fight in melee combat is passable. At bare minimum, you know how to swing properly, and if you're security, you can probably handle a stun baton long enough to hit the other guy without shocking yourself instead."
	tree = /datum/new_skill/combat
	additional_ranks = list(
		"You're quite good at fighting up close and you can hold your own against experienced opponents. You know how to feint effectively and evade when you need to, and perhaps more importantly, you know when you're outmatched and need to fall back. You know how to swing a punch better than most, even if you really shouldn't be doing so against someone with a weapon."
	)

/datum/new_skill/weapons_expertise
	name = "Weapons Expertise"
	desc = "You know how simple weapons work and how to use them. You can line up a shot with a taser, blind someone with a flash, block a giant spider with a riot shield, or handle a grenade without setting it off in your hands. This level of competence is typical for security officers."
	tree = /datum/new_skill/combat
	additional_ranks = list(
		"You're a good shot and you know how to use complex weapons like laser rifles and bombs. You can draw a bead under pressure, hit your shots reliably, and get out mostly intact. This level of competence is typical for private security, soldiers, and paramilitary groups."
	)
