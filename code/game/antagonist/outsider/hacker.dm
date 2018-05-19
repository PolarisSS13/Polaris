var/datum/antagonist/hacker/hacker

/datum/antagonist/hacker
	id = MODE_CLANDESTINE
	bantype = "Hacker (Clandestine)"
	role_type = BE_HACKER
	role_text = "Hacker"
	role_text_plural = "Elite Hacking Group"
	welcome_text = "<b>Be prepared to help the spy any way you can!</b>"
	landmark_id = "Response Team" //****CHANGE LATER****//
	id_type = /obj/item/weapon/card/id/hacker

	flags = ANTAG_OVERRIDE_JOB | ANTAG_CHOOSE_NAME
	antaghud_indicator = "hudloyalist" //****CHANGE LATER***//

	hard_cap = 1
	hard_cap_round = 1
	initial_spawn_req = 1
	initial_spawn_target = 1

/datum/antagonist/hacker/create_default(var/mob/source)
	var/mob/hacker = ..()

/datum/antagonist/hacker/New()
	..()
	hacker = src

/datum/antagonist/hacker/greet(var/datum/mind/player)
	if(!..())
		return
	else
		to_chat(player.current, "Protect the Spy in any way possible.")
		to_chat(player.current, "Don't be stupid.")

/datum/antagonist/ert/equip(var/mob/living/carbon/human/player)
	return 1