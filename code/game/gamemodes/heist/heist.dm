/*
VOX HEIST ROUNDTYPE
*/

var/global/list/obj/cortical_stacks = list() //Stacks for 'leave nobody behind' objective. Clumsy, rewrite sometime.

/datum/game_mode/heist
	name = "heist"
	config_tag = "heist"
	required_players = 15
	required_enemies = 4
	round_description = "An unidentified bluespace signature is approaching the station!"
	extended_round_description = "The Company's majority control of phoron in Vir has marked the \
		station to be a highly valuable target for many competing organizations and individuals. Being a \
		colony of sizable population and considerable wealth causes it to often be the target of various \
		attempts of robbery, fraud and other malicious actions."
	end_on_antag_death = 0
	antag_tags = list(MODE_RAIDER)

/datum/game_mode/heist/check_finished()
	if(!..())
		var/datum/shuttle/multi_shuttle/skipjack = shuttle_controller.shuttles["Skipjack"]
		if (skipjack && skipjack.returned_home)
			return 1
	return 0
