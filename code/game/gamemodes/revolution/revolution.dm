/datum/game_mode/revolution
	name = "Revolution"
	config_tag = "revolution"
	round_description = "Some civilians are attempting to start a revolution!"
	extended_round_description = "Revolutionaries - remove the city's council from power. Convert other civilians to your cause using the 'Convert Bourgeoise' verb. Protect your leaders."
	required_players = 12 //should be enough for a decent manifest, hopefully
	required_players_secret = 12 //pretty sure rev doesn't even appear in secret
	required_enemies = 3
	auto_recall_shuttle = 1
	end_on_antag_death = 1
	antag_tags = list(MODE_REVOLUTIONARY, MODE_LOYALIST)
	require_all_templates = 1
	votable = 1
