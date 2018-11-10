var/datum/antagonist/zombie/infected

/datum/antagonist/zombie
	id = MODE_ZOMBIE
	role_text = "Zombie"
	role_text_plural = "Zombies"
	bantype = "Zombie"
	roundstart_restricted = list("AI", "Cyborg","Chief Medical Officer", "Doctor", "Virologist")
	role_type = BE_ZOMBIE
	antag_indicator = "zombie"
	welcome_text = "For now you are patient zero! You'll become a zombie soon. It's probably just a stomach bug and a headache. No need to go to a doctor, right?"
	victory_text = "The zombies win! The city is now brainless... actually nothing has changed."
	loss_text = "The city managed to stop the zombies!"
	victory_feedback_tag = "win - zombies have won!"
	loss_feedback_tag = "loss - civilians managed to stop the zombies!"

	flags = ANTAG_SUSPICIOUS | ANTAG_RANDSPAWN | ANTAG_VOTABLE
	hard_cap = 1
	hard_cap_round = 1
	initial_spawn_req = 1
	initial_spawn_target = 1

	//Inround revs.
	faction_role_text = "Infectee"
	faction_descriptor = "Zombies"
	faction_welcome = "Eat brains of the living, convert more to become shambling abominations like yourself.."
	faction_indicator = "zombie_infect"
	faction_invisible = 1

/datum/antagonist/zombie/New()
	..()
	infected = src

/datum/antagonist/zombie/update_antag_mob(var/datum/mind/player)
	..()
	var/mob/living/carbon/human/H = player.current
	if(istype(H))
		H.reagents.add_reagent("trioxin", 10)