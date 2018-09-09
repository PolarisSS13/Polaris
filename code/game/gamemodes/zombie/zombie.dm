/datum/game_mode/zombie
	name = "Zombie Invasion"
	config_tag = "zombie"
	round_description = "Zombies are taking over the city, all civilians must defend and fight back against the invasion!"
	extended_round_description = "Zombies - Infect and kill all humans. Civillians must kill all zombies."
	var/datum/mind/zombies[] = list() //These are our basic lists to keep track of who is in the game.
	required_players = 2 //should be enough for a decent manifest, hopefullyc
	required_enemies = 1
	required_players_secret = 1
	end_on_antag_death = 1
	restricted_jobs = list("AI", "Cyborg","Chief Medical Officer", "Doctor", "Virologist") //We need some hippocratic oath slaves to actually help, y'know.
