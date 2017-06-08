/datum/trait/modifier
	var/modifier_type = null // Type to add to the mob post spawn.

/datum/modifier/trait
	flags = MODIFIER_GENETIC

/datum/trait/modifier/apply_trait_post_spawn(mob/living/L)
	L.add_modifier(modifier_type)

/datum/modifier/trait/flimsy
	name = "frail"
	desc = "You're more fragile than most, and have less of an ability to endure harm."

	max_health_percent = 0.75

/datum/trait/modifier/flimsy
	name = "Flimsy"
	desc = "You're more fragile than most, and have less of an ability to endure harm."
	modifier_type = /datum/modifier/trait/flimsy
	muturally_exclusive = list(/datum/trait/modifier/frail)



/datum/modifier/trait/frail
	name = "frail"
	desc = "Your body is very fragile, and has even less of an ability to endure harm."

	max_health_percent = 0.5

/datum/trait/modifier/frail
	name = "Frail"
	desc = "Your body is very fragile, and has even less of an ability to endure harm."
	modifier_type = /datum/modifier/trait/frail
	muturally_exclusive = list(/datum/trait/modifier/flimsy)



/datum/trait/modifier/haemophilia
	name = "Haemophilia"
	desc = "Some say that when it rains, it pours.  Unfortunately, this is also true for yourself if you get cut.  You bleed much faster than normal."
//	modifier_type = /datum/modifier/trait/haemophilia



/datum/modifier/trait/weak
	name = "weak"
	desc = "A lack of physical strength causes a diminshed capability in close quarters combat"

	outgoing_melee_damage_percent = 0.6

/datum/trait/modifier/weak
	name = "Weak"
	desc = "A lack of physical strength causes a diminshed capability in close quarters combat."
	modifier_type = /datum/modifier/trait/weak

/datum/trait/modifier/inaccurate
	name = "Inaccurate"
	desc = "You're rather inexperienced with guns, or perhaps you've never used one in your life.  Regardless, you find it quite difficult to land \
	shots where you wanted them to go."
//	modifier_type = /datum/modifier/trait/inaccurate


/datum/trait/modifier/arachnophobe
	name = "Arachnophobic"
	desc = "Spiders are quite creepy to most people, however for you, those chitters of pure evil inspire pure dread and fear."
//	modifier_type = /datum/modifier/trait/weak


/datum/trait/modifier/nyctophobe
	name = "Nyctophobic"
	desc = "More commonly known as the fear of darkness.  The shadows can hide many dangers, which makes the prospect of going into the depths of Maintenance rather worrisome."
//	modifier_type = /datum/modifier/trait/weak

//
/datum/trait/modifier/claustrophobe
	name = "Claustrophobic"
	desc = "Small spaces and tight quarters makes you feel distressed.  Unfortunately both are rather common when traveling via spacecraft."


/datum/trait/modifier/synthphobe
	name = "Synthphobic"
	desc = "You know, deep down, that synthetics cannot be trusted, and so you are always on guard whenever you see one wandering around.  No one knows how a Positronic's mind works, \
	Drones are just waiting for the right time for Emergence, and the poor brains trapped in the cage of Man Machine Interfaces are now soulless, despite being unaware of it.  None \
	can be trusted."


/datum/trait/modifier/xenophobe
	name = "Xenophobic"
	desc = "The mind of the Alien is unknowable, and as such, their intentions cannot be known.  You always watch the xenos closely, as they most certainly are watching you \
	closely, waiting to strike."
	muturally_exclusive = list(
		/datum/trait/modifier/humanphobe,
		/datum/trait/modifier/skrellphobe,
		/datum/trait/modifier/tajaraphobe,
		/datum/trait/modifier/unathiphobe,
		/datum/trait/modifier/teshariphobe
	)

/datum/trait/modifier/humanphobe
	name = "Human-phobic"
	desc = "Boilerplate racism for monkeys goes here."
	muturally_exclusive = list(/datum/trait/modifier/xenophobe)

/datum/trait/modifier/skrellphobe
	name = "Skrell-phobic"
	desc = "Boilerplate racism for squid goes here."
	muturally_exclusive = list(/datum/trait/modifier/xenophobe)

/datum/trait/modifier/tajaraphobe
	name = "Tajara-phobic"
	desc = "Boilerplate racism for cats goes here."
	muturally_exclusive = list(/datum/trait/modifier/xenophobe)

/datum/trait/modifier/unathiphobe
	name = "Unathi-phobic"
	desc = "Boilerplate racism for lizards goes here."
	muturally_exclusive = list(/datum/trait/modifier/xenophobe)

// Not sure why anyone would hate/fear these guys but for the sake of completeness here we are.
/datum/trait/modifier/dionaphobe
	name = "Diona-phobic"
	desc = "Boilerplate racism for trees goes here."
	muturally_exclusive = list(/datum/trait/modifier/xenophobe)

/datum/trait/modifier/teshariphobe
	name = "Teshari-phobic"
	desc = "Boilerplate racism for birds goes here."
	muturally_exclusive = list(/datum/trait/modifier/xenophobe)
