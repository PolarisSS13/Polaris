/datum/job/president
	title = "President"
	flag = PRESIDENT
	department = "Command"
	head_position = 1
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	supervisors = "NanoTrasen"
	selection_color = "#1D1D4F"
	idtype = /obj/item/weapon/card/id/centcom/station/president
	req_admin_notify = 1
	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()
	minimal_player_age = 14
	economic_modifier = 20

	minimum_character_age = 30
	ideal_character_age = 50
	outfit_type = /decl/hierarchy/outfit/job/president

/datum/job/president/get_access()
	get_all_station_access()
	get_all_centcom_access()
	return



/mob/observer/dead/verb/join_as_president()
	set category = "Ghost"
	set name = "Join As President"
	set desc = "Join as the current president. This should be fun."

	if(ticker.current_state < GAME_STATE_PLAYING)
		src << "<span class='danger'>The game hasn't started yet!</span>"
		return

	if(!(config.president_allowed))
		src << "<span class='danger'>Currently, president spawning is not allowed.</span>"
		return

	if (!src.stat)
		src << "<span class='danger'>You can only do this as a ghost.</span>"
		return

	if (usr != src)
		return 0 //something is terribly wrong

	if(jobban_isbanned(src,"President"))
		usr << "<span class='danger'>Somehow, you're jobbanned from president.</span>"
		return

	if(!(config.presidents))
		usr << "<span class='danger'>It seems no one is the current president right now...</span>"
	else
		if(config.presidents == "[usr.ckey]")
			usr << "<span class='danger'>Spawning as president.</span>"
			return 1
		else
			usr << "<span class='danger'>You don't seem to be the current president.</span>"
			return 0
