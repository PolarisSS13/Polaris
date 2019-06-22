/datum/game_mode/zombie
	name = "Zombie Invasion"
	config_tag = "zombies"
	antag_tags = list(MODE_ZOMBIE)
	round_description = "Zombies are taking over the city, all civilians must defend and fight back against the invasion!"
	var/datum/mind/zombies[] = list() //These are our basic lists to keep track of who is in the game.
	required_players = 20
	required_players_secret = 20
	required_enemies = 1
	end_on_antag_death = 1
	restricted_jobs = list("AI", "Cyborg","Chief Medical Officer", "Doctor", "Virologist", "Chief of Police", "Police Officer")
	votable = 0
