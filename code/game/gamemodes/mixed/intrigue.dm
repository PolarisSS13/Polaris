/datum/game_mode/intrigue
	name = "Traitors & Ninja"
	round_description = "Crewmembers are contacted by external elements while another infiltrates the colony."
	extended_round_description = "Traitors and a ninja spawn during this round."
	config_tag = "intrigue"
	required_players = 6
	required_players_secret = 8
	required_enemies = 3
	end_on_antag_death = 0
	antag_tags = list(MODE_NINJA, MODE_TRAITOR)
	round_autoantag = 1
	require_all_templates = 1
	latejoin_antags = list(MODE_TRAITOR)
