
var/global/list/political_parties = list()

/datum/party
	var/id
	var/password								//password needed to access party

	var/name
	var/description

	var/party_message = " "						//party's announcement board message shown to members only

	var/datum/party_member/members
	var/datum/party_member/party_leader

	var/monthly_cost = 3500
	var/current_balance = 0
	var/public_balance = TRUE

	var/max_party = 10 //max amount of party members. Can be upgraded.

	var/creation_time
	var/party_email

	var/suspended
	var/suspended_time //Date of suspension
	var/suspension_reason = "This party has been suspended." // Yanno. Reason. Can vary.

	var/list/positions = list("Party Leader", "Party Member", "Party Moderator") //list of positions you can set people to. Default
	var/slogan

	var/primary_color = "#000000"
	var/secondary_color = "#ffffff"
	var/accepting_new_members = 1				//if this party is accepting new members or not.

	var/linked_account

/datum/party_member
	var/name
	var/leader // If this person is a leader or not
	var/position = "Party Member"
	var/unique_ID
	var/is_admin = 0

/proc/create_new_party(var/name, var/description, var/slogan, var/pass, var/mob/living/carbon/human/H)

	var/datum/party/P = new()
	create_party_leader(H, P)
	P.name = name
	P.description = description
	P.slogan = slogan
	P.creation_time = get_game_time()
	P.password = pass
	P.id = md5("[P.name]")

	political_parties += P

	return P

/proc/suspend_party(var/datum/party/P, var/reason)
	P.suspended = 1
	P.suspension_reason = reason
	P.suspended_time = get_game_time()

	return 1

/proc/create_party_member(var/mob/living/carbon/human/H, var/position, var/admin, var/datum/party/party)
	//First of all, let's make a party member.
	var/datum/party_member/M = new()
	M.name = H.real_name
	M.leader = 1
	M.position = position
	M.unique_ID = H.mind.prefs.unique_id
	M.is_admin = admin
	party.members += M

	return M

/proc/create_party_leader(var/mob/living/carbon/human/H, var/datum/party/party)
	var/L = create_party_member(H, "Party Leader", 1, party)
	party.party_leader = L

	return L

/proc/is_party_member(var/uid, var/datum/party/party)
	for(var/datum/party_member/M in party.members)
		if(M.unique_ID == uid)
			return 1
	return 0

/proc/is_party_leader(var/uid, var/datum/party/party)
	for(var/datum/party_member/M in party.members)
		if(M.unique_ID == uid  && M.is_admin == 1)
			return 1
	return 0

/proc/get_party_by_id(var/id)
	for(var/datum/party/P in political_parties)
		if(P.id == id)
			return P

/proc/get_party_by_name(var/name)
	for(var/datum/party/P in political_parties)
		if(P.name == name)
			return P

/proc/try_auth_party(var/datum/party/P, var/name, var/pass)
	if(P.name == name && P.password == pass)
		return 1
	return 0

/proc/try_auth_party_id(var/datum/party/P, var/id, var/pass)
	if(P.id == id && P.password == pass)
		return 1
	return 0

/proc/check_party_name_exist(var/name)
	for(var/datum/party/P in political_parties)
		if(name == P.name)
			message_admins("Found [P.name].")
			return 1
	return 0


/proc/get_all_parties(mob/user)
	user.client.debug_variables(political_parties)
	var/dat = list()
	dat += "<center>"
	if(!political_parties.len)
		dat += "<br>No current political parties.<br>"
	else
		dat += "<br>Currently, there are [political_parties.len] political parties.<br>"

		for(var/datum/party/P in political_parties)

			dat += "<table style=\"width: 85%;\" border=1>"
			dat += "<thead><tr>"
			dat += "<th style=\"text-align: right; padding: 10px; background-color: [P.primary_color];\">"
			dat += "<span style=\"font-family: Tahoma, Geneva, sans-serif; font-size: 24px; color: [P.secondary_color];\">[P.name]</span></th></tr>"
			dat += "</thead><tbody><tr><td style=\"width: 100.0000%; padding: 10px;\">"
			dat += "<p style=\"text-align: center;\"><em><span style=\"font-size: 18px; color: [P.secondary_color]; font-family: Georgia, serif;\">[P.slogan]</span></em></p>"
			dat += "<hr>"

			dat += "<p>[P.description]</p>"

			dat += "<p><strong>Party Leader:</strong><br>[P.party_leader.name]</p>"

			dat += "<p><strong>Party Members:</strong><br>"

			for(var/datum/party_member/M in P.members)
				dat +=  "<p>[M.name] ([M.position])</p>"

			if(P.public_balance)
				dat += "<p><strong>Party Balance:</strong><br>[P.current_balance]</p>"


			dat += "<li><p><strong>Accepting new registrations:</strong><br><b>[P.accepting_new_members  ? "<span style=\"color:green\">Yes</span>" : "<span style=\"color:red\">No</span>"]</b></p>"
			dat += "<li><p><strong>Current Status:</strong><br><b>[P.suspended  ? "<span style=\"color:red\">Suspended</span> ([P.suspension_reason])" : "<span style=\"color:green\">Active</span>"]</b></p>"

			dat += "</td></tr></tbody></table>"

			dat += "</br>"

	dat += "</center>"

	var/datum/browser/popup = new(usr, "Parties", "Parties", 640, 600, src)
	popup.set_content(jointext(dat,null))
	popup.open()
