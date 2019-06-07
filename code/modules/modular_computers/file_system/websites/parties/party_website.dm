
/datum/website/party

	name = "pollux.nt/parties"
	//stuff relating to party members
	title = "Official Party Registrar"
	interactive_website = "party"



/datum/nano_module/nt_explorer/Topic(href, href_list)
	if(href_list["register_party"])
		. = 1
		make_party(usr)

	if(href_list["view_parties"])
		. = 1
		get_all_parties(usr)

	..()