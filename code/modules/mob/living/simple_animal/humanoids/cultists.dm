/mob/living/simple_animal/hostile/cultist
	name = "blood cultist"
	desc = "A mysterious hooded figure. They do not look friendly."
	tt_desc = "Unknown"
	icon_state = "cultist"
	icon_living = "cultist"
	icon_gib = "syndicate_gib"
	intelligence_level = SA_HUMANOID

	faction = "cult"
	maxHealth = 100
	health = 100
	speed = 2

	run_at_them = 0
	cooperative = 1
	investigates = 1
	firing_lines = 1
	returns_home = 1
	reacts = 1

	turns_per_move = 5
	stop_when_pulled = 0
	status_flags = CANPUSH

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 12
	melee_damage_upper = 18
	environment_smash = 1
	attacktext = list("slashed")

	min_oxy = 5
	max_oxy = 0
	min_tox = 0
	max_tox = 1
	min_co2 = 0
	max_co2 = 5
	min_n2 = 0
	max_n2 = 0
	unsuitable_atoms_damage = 15


	speak_chance = 3 //YES ALMOST ALL OF THEM ARE WARCRAFT REFERENCES
	speak = list("Nar'Sie, bless us.",
				"All I see is blackness. Oh, my hood's down.",
				"Stop the voices! They make the lamest puns...",
				"I knew I should have joined Ratvar...",
				"Every man lives. Not every man truly dies.",
				"Once you head down the dark path, forever will it dominate your destiny. And you get dental.",
				"You should see the skeletons in my closet.",
				"This hood doesn't help with the frost.",
				"We're not a cult so much as a maniacal group of fanatical, blade-wielding zealots")
	emote_hear = list("sniffs","coughs","prays","casts evil incantations")
	emote_see = list("looks around","swings their sword around")
	say_understood = list()
	say_cannot = list()
	say_maybe_target = list("What's that?","Is someone there?","Is that...?","Are spectres fooling us again?")
	say_got_target = list("Join us or die! Or both!","For Nar'Sie!","For the Blood Geometer!","Blood will flow!", "Repent!")
	reactions = list("Hail Nar'Sie." = "Hail Nar'Sie!")

	var/corpse = /obj/effect/landmark/corpse/cultist

/mob/living/simple_animal/hostile/cultist/death()
	..()
	if(corpse)
		new corpse (src.loc)
	qdel(src)
	return