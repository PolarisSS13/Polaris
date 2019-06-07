/datum/computer_file/program/party_manager
	filename = "prtymangr"
	filedesc = "Official Party Management"
	extended_desc = "This program allows you to create an official party and also manage and view existing parties."
	requires_ntnet = 1
	size = 3
	nanomodule_path = /datum/nano_module/program/party_manager/

/datum/nano_module/program/party_manager/
	name = "Official Party Management"
	var/index = 0
	var/page_msg
	var/authuser

	var/user_uid
	var/can_login

	// SELECTED PARTY
	var/current_party

	// REGISTRATION
	var/p_name = " "
	var/p_slogan = " "
	var/p_desc = " "

	var/acc_no
	var/acc_pin

	var/party_pass = " "


	var/reg_error = "*Fields marked with an asterisk are required."

/datum/nano_module/program/party_manager/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/list/data = list()
	if(program)
		data = program.get_header_data()

	data["index"] = index
	data["page_msg"] = page_msg
	data["parties"] = political_parties

	var/obj/item/weapon/card/id/I = user.GetIdCard()

	if(!ishuman(user) || !istype(I) || !I.registered_name)
		data["authuser"] = "Anonymous"
		can_login = 0
	else
		var/mob/living/carbon/human/H = user
		data["authuser"] = "[I.registered_name] - [I.assignment ? I.assignment : "(Unknown)"]"
		can_login = 1
		user_uid = H.client.prefs.unique_id
		data["party_leader"] = I.registered_name


	if(can_login)
		data["unique_id"] = user_uid
		acc_no = I.associated_account_number
		acc_pin = I.associated_pin_number


	//Registration
	data["p_name"] = p_name
	data["p_slogan"] = p_slogan
	data["p_desc"] = p_desc
	data["acc_no"] = acc_no
	data["acc_pin"] = acc_pin
//	data["party_email"] = party_email
	data["reg_error"] = reg_error
	data["party_pass"] = party_pass

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "political_party.tmpl", "Official Party Management", 690, 680, state = state)
		if(program.update_layout())
			ui.auto_update_layout = 1
		ui.set_auto_update(1)
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/party_manager/Topic(href, href_list)
	if(..()) return 1

	if(href_list["back"])
		. = 1
		index = 0

	if(href_list["login"])
		. = 1
		index = 0

	if(href_list["register_party"])
		. = 1
		if(!ishuman(usr) || !can_login)
			index = 2
		else
			index = 1
			page_msg = "You are not authorized to access this page."

	if(href_list["view_parties"])
		. = 1
		get_all_parties(usr)

	if(href_list["set_party_name"])
		. = 1
		p_name = sanitize(copytext(input(usr, "Enter your party name (40 chars max)", "Party Manager", null)  as text,1,40))
		if(!p_name)
			return

	if(href_list["set_party_slogan"])
		. = 1
		p_slogan = sanitize(copytext(input(usr, "Enter your party's slogan (80 chars max)", "Party Manager", null)  as text,1,80))
		if(!p_slogan)
			return

	if(href_list["set_party_desc"])
		. = 1
		p_desc = sanitize(copytext(input(usr, "Enter your party's description (200 chars max)", "Picket Message", null)  as message,1,200))
		if(!p_desc)
			return
/*

	if(href_list["set_party_email"])
		. = 1
		p_name = sanitize(copytext(input(usr, "Enter your party's email", "Party Manager", null)  as text,1,60))
		if(!p_name)
			return
*/
	if(href_list["set_party_pass"])
		. = 1
		party_pass = sanitize(copytext(input(usr, "Enter the password your party will use. (15 characters max)", "Party Manager", null)  as text,1,15))
		if(!party_pass)
			return

	if(href_list["submit_new_party"])
		. = 1
		if(p_name == initial(p_name))
			reg_error = "You need to enter a party name!"
			return 0

		if(p_slogan == initial(p_slogan))
			reg_error = "A party slogan is required!"
			return 0
		if(p_desc == initial(p_desc))
			reg_error = "The party description cannot be left blank!"
			return 0
		if(party_pass == initial(party_pass))
			reg_error = "A password is required!"
			return 0

		for(var/datum/party/K in political_parties)
			if(K.name == p_name)
				reg_error = "The name \"[p_name]\" already exists."
				break
				return 0


		if("No" == alert("Create [p_name] party for 3,500 credits?", "Create Party", "No", "Yes"))
			return 0

		if(!attempt_account_access(acc_no, acc_pin, 2) || !charge_to_account(acc_no, "Party Registrar", "[p_name] registration", "Polluxian Party Registration", 3500))
			reg_error = "There was an error charging your bank account. Please contact your bank's administrator."
			return 0
		else
			var/datum/party/P = create_new_party(p_name, p_desc, p_slogan, party_pass, usr)
			message_admins("Party created.")

			index = 2
			page_msg = "Party created! <br><br>\
			<b>Party Name:</b> [P.name]<p>\
			<b>Party Unique ID:</b> [P.id] (Use this as a login.)<p>\
			<b>Party Password:</b> [P.password]"

			p_name = initial(p_name)
			p_desc = initial(p_desc)
			p_slogan = initial(p_slogan)
			party_pass = initial(party_pass)





