// This file holds things required for remote borg control by an AI.

GLOBAL_LIST_EMPTY(available_ai_shells)

/mob/living/silicon/robot
	var/shell = FALSE
	var/deployed = FALSE
	var/mob/living/silicon/ai/mainframe = null

// Premade AI shell, for roundstart shells.
/mob/living/silicon/robot/ai_shell/Initialize()
	mmi = new /obj/item/device/mmi/ai_remote(src)
	post_mmi_setup()
	return ..()

// Call after inserting or instantiating an MMI.
/mob/living/silicon/robot/proc/post_mmi_setup()
	if(istype(mmi, /obj/item/device/mmi/ai_remote))
		make_shell()
	return

/mob/living/silicon/robot/proc/make_shell()
	shell = TRUE
	braintype = "AI Shell"
	SetName("[modtype] AI Shell [num2text(ident)]")
	GLOB.available_ai_shells |= src
	//if(!QDELETED(builtInCamera))
	//	builtInCamera.c_tag = real_name	//update the camera name too
	//notify_ai(AI_SHELL)
	updateicon()

/mob/living/silicon/robot/proc/revert_shell()
	if(!shell)
		return
	undeploy()
	shell = FALSE
	GLOB.available_ai_shells -= src
	updateicon()

/mob/living/silicon/robot/proc/deploy_init(mob/living/silicon/ai/AI)
	//real_name = "[AI.real_name] shell [rand(100, 999)] - [designation]"	//Randomizing the name so it shows up separately in the shells list
	//name = real_name
	SetName("[AI.real_name] shell [num2text(ident)]")
	if(isnull(sprite_name)) // For custom sprites. It can only chance once in case there are two AIs with custom borg sprites.
		sprite_name = AI.real_name
	mainframe = AI
	deployed = TRUE
	updateicon()
	connected_ai = mainframe // So they share laws.
	mainframe.connected_robots |= src
	lawsync()
	verbs += /mob/living/silicon/robot/proc/undeploy_act
//	if(radio && AI.radio) //AI keeps all channels, including Syndie if it is a Traitor
//		if(AI.radio.syndie)
//			radio.make_syndie()
//		radio.subspace_transmission = TRUE
//		radio.channels = AI.radio.channels
//		for(var/chan in radio.channels)
//			radio.secure_radio_connections[chan] = add_radio(radio, GLOB.radiochannels[chan])

/mob/living/silicon/robot/proc/undeploy(message)
	if(!deployed || !mind || !mainframe)
		return
//	mainframe.redeploy_action.Grant(mainframe)
//	mainframe.redeploy_action.last_used_shell = src
	if(message)
		to_chat(src, span("notice", message))
	mind.transfer_to(mainframe)
	deployed = FALSE
	updateicon()
	mainframe.deployed_shell = null
//	undeployment_action.Remove(src)
//	if(radio) //Return radio to normal
//		radio.recalculateChannels()
//	if(!QDELETED(builtInCamera))
//		builtInCamera.c_tag = real_name	//update the camera name too
//	diag_hud_set_aishell()
//	mainframe.diag_hud_set_deployed()
	SetName("[modtype] AI Shell [num2text(ident)]")
	if(mainframe.laws)
		mainframe.laws.show_laws(mainframe) //Always remind the AI when switching
	mainframe = null

/mob/living/silicon/robot/proc/undeploy_act()
	set name = "Release Control"
	set desc = "Release control of a remote drone."
	set category = "Silicon Commands"

	undeploy("Remote session terminated.")

/mob/living/silicon/robot/attack_ai(mob/living/silicon/ai/AI)
	AI.deploy_to_shell(src)

/*

/mob/living/silicon/robot/drone/attack_ai(var/mob/living/silicon/ai/user)

	if(!istype(user) || controlling_ai || !config.allow_drone_spawn || !config.allow_ai_drones)
		return

	if(client || key)
		to_chat(user, "<span class='warning'>You cannot take control of an autonomous, active drone.</span>")
		return

	if(health < -35 || emagged)
		to_chat(user, "<span class='notice'><b>WARNING:</b> connection timed out.</span>")
		return

	user.controlling_drone = src
	user.teleop = src
	radio.channels = user.aiRadio.keyslot2.channels
	controlling_ai = user
	verbs += /mob/living/silicon/robot/drone/proc/release_ai_control_verb
	local_transmit = FALSE
	languages = controlling_ai.languages.Copy()
	speech_synthesizer_langs = controlling_ai.speech_synthesizer_langs.Copy()
	stat = CONSCIOUS
	if(user.mind)
		user.mind.transfer_to(src)
	else
		key = user.key
	updatename()
	to_chat(src, "<span class='notice'><b>You have shunted your primary control loop into \a [initial(name)].</b> Use the <b>Release Control</b> verb to return to your core.</span>")


/mob/living/silicon/robot/proc/revert_shell()
	if(!shell)
		return
	undeploy()
	for(var/obj/item/borg/upgrade/ai/boris in src)
	//A player forced reset of a borg would drop the module before this is called, so this is for catching edge cases
		qdel(boris)
	shell = FALSE
	GLOB.available_ai_shells -= src
	name = "Unformatted Cyborg [rand(100,999)]"
	real_name = name
	if(!QDELETED(builtInCamera))
		builtInCamera.c_tag = real_name
	diag_hud_set_aishell()

/mob/living/silicon/robot/proc/deploy_init(var/mob/living/silicon/ai/AI)
	real_name = "[AI.real_name] shell [rand(100, 999)] - [designation]"	//Randomizing the name so it shows up separately in the shells list
	name = real_name
	if(!QDELETED(builtInCamera))
		builtInCamera.c_tag = real_name	//update the camera name too
	mainframe = AI
	deployed = TRUE
	connected_ai = mainframe
	mainframe.connected_robots |= src
	lawupdate = TRUE
	lawsync()
	if(radio && AI.radio) //AI keeps all channels, including Syndie if it is a Traitor
		if(AI.radio.syndie)
			radio.make_syndie()
		radio.subspace_transmission = TRUE
		radio.channels = AI.radio.channels
		for(var/chan in radio.channels)
			radio.secure_radio_connections[chan] = add_radio(radio, GLOB.radiochannels[chan])

	diag_hud_set_aishell()
	undeployment_action.Grant(src)

/mob/living/silicon/robot/proc/undeploy()

	if(!deployed || !mind || !mainframe)
		return
	mainframe.redeploy_action.Grant(mainframe)
	mainframe.redeploy_action.last_used_shell = src
	mind.transfer_to(mainframe)
	deployed = FALSE
	mainframe.deployed_shell = null
	undeployment_action.Remove(src)
	if(radio) //Return radio to normal
		radio.recalculateChannels()
	if(!QDELETED(builtInCamera))
		builtInCamera.c_tag = real_name	//update the camera name too
	diag_hud_set_aishell()
	mainframe.diag_hud_set_deployed()
	if(mainframe.laws)
		mainframe.laws.show_laws(mainframe) //Always remind the AI when switching
	mainframe = null

/mob/living/silicon/robot/attack_ai(mob/user)
	if(shell && (!connected_ai || connected_ai == user))
		var/mob/living/silicon/ai/AI = user
		AI.deploy_to_shell(src)
*/