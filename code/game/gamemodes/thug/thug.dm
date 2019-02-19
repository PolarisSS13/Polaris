/datum/game_mode/thug
	name = "Thugs & Corrupts"
	config_tag = "thug"
	required_players = 0
	round_description = "There's thugs, corrupt civilians, and overall dastardly villians in the city. They're here to make trouble and take over."
	extended_round_description = "A group of thugs, muggers, and corrupts are on the city. What dastardly plans do they have up their sleeve? Drug dealing? Mugging? Threats? Extortion? Find out!"
	antag_tags = list(MODE_THUG)
	votable = 1
	required_players = 5
	required_players_secret = 5
	required_enemies = 3
	end_on_antag_death = 0


/datum/game_mode/thug/post_setup()
	for (var/mob/living/carbon/human/C in mob_list)
		if(C.mind.special_role == "Thug")
			for(var/datum/antagonist/thug/W)
				W.get_gang(C)
	..()