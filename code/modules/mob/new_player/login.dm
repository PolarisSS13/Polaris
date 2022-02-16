
/mob/new_player
	var/client/my_client // Need to keep track of this ourselves, since by the time Logout() is called the client has already been nulled

/mob/new_player/Login()
	update_Login_details()	//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying
	if(join_motd)
		to_chat(src, "<div class=\"motd\">[join_motd]</div>")

	if(!mind)
		mind = new /datum/mind(key)
		mind.active = 1
		mind.current = src

	loc = null
	using_map.show_titlescreen(client)
	my_client = client
	sight |= SEE_TURFS
	player_list |= src

	new_player_panel()
	spawn(40)
		if(client)
			handle_privacy_poll()
			client.playtitlemusic()
