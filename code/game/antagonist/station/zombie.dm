var/datum/antagonist/zombie/infected

/datum/antagonist/zombie
	id = MODE_ZOMBIE
	role_text = "Zombie"
	role_text_plural = "Zombies"
	bantype = "Zombie"
	roundstart_restricted = list("AI","Cyborg","Chief Medical Officer","Doctor","Virologist","Mayor","Chief of Police")
	restricted_jobs = list("AI","Cyborg")
	role_type = BE_ZOMBIE
	antag_indicator = "zombie"
	welcome_text = "For now you are patient zero! You'll become a zombie soon. It's probably just a stomach bug and a headache. No need to go to a doctor, right?"
	victory_text = "The zombies win! The city is now brainless... actually nothing has changed."
	loss_text = "The city managed to stop the zombies!"
	victory_feedback_tag = "win - zombies have won!"
	loss_feedback_tag = "loss - civilians managed to stop the zombies!"

	flags = ANTAG_SUSPICIOUS | ANTAG_RANDSPAWN | ANTAG_VOTABLE
	hard_cap = 2
	hard_cap_round = 4
	initial_spawn_req = 2
	initial_spawn_target = 4

	spawn_announcement = "A deadly and contagious outbreak of the cordyceps parasite has taken over a quarantined neighbouring city. This parasite can be prevented or slowed down with inaprovaline but once symptoms manifest it is incurable, those afflicted with the late stages of infection must be cremated in order to contain the outbreak. Civilians are advised to report strange flu-like symptoms to their local hospital."
	spawn_announcement_title = "Pathogen Alert"
	spawn_announcement_delay = 5000

	//Inround revs.
	faction_role_text = "Infectee"
	faction_descriptor = "Zombies"
	faction_welcome = "Eat brains of the living, convert more to become shambling abominations like yourself..."
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

/datum/antagonist/zombie/can_become_antag(var/datum/mind/player, var/ignore_role)
	if(!..())
		return 0
	if(player.current)
		if(ishuman(player.current))
			var/mob/living/carbon/human/H = player.current
			if(H.isSynthetic())
				return 0
			if(H.species.flags & NO_SCAN)
				return 0
			return 1
		else if(isnewplayer(player.current))
			if(player.current.client && player.current.client.prefs)
				var/datum/species/S = all_species[player.current.client.prefs.species]
				if(S && (S.flags & NO_SCAN))
					return 0
				if(player.current.client.prefs.organ_data["torso"] == "cyborg") // Full synthetic.
					return 0
				return 1
	return 0