/datum/game_mode/clandestine
	name = "clandestine"
	round_description = "A hacker and spy are working to stealthily gain control of the station! Watch your backs!"
	extended_round_description = "A stealthy duo comprised of a spy and a remote hacker have infiltrated the station, \
		posing as a member of the crew. Their goals are unknown, as are their motives, but it is certain that their clandestine \
		plans will spell trouble for the station."
	config_tag = "clandestine"
	required_players = 3
	required_players_secret = 3
	required_enemies = 2
	end_on_antag_death = 0
	antag_tags = list(MODE_CLANDESTINE, MODE_TRAITOR)
	antag_scaling_coeff = 2