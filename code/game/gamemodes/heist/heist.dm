/*
VOX HEIST ROUNDTYPE
*/

var/global/list/obj/cortical_stacks = list() //Stacks for 'leave nobody behind' objective. Clumsy, rewrite sometime.

/datum/game_mode/heist
	name = "Raiders & Thieves"
	config_tag = "heist"
	required_players = 12
	required_players_secret = 12
	required_enemies = 3
	round_description = "An unidentified bluespace signature is approaching the city!"
	extended_round_description = "The colony's majority control of phoron in the system has marked the \
		city to be a highly valuable target for many competing organizations and individuals. Being a \
		colony of sizable population and considerable wealth causes it to often be the target of various \
		attempts of robbery, fraud and other malicious actions."
	end_on_antag_death = 0
	antag_tags = list(MODE_RAIDER)
