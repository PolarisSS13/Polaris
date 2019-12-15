var/global/list/businesses = list()

/datum/business
	var/name = "Unnamed Business"
	var/category = "General"
	var/slogan = "Generic slogan."
	var/description = "Generic description."
	var/creation_time
	var/uid
	var/password

	var/owner_name
	var/owner_uid

	var/status = "Active"

	var/associated_account_no

	var/gets_business_tax = TRUE                // no one is safe.

	var/primary_color = "#000000"
	var/secondary_color = "#ffffff"

	var/list/blacklisted_employees = list()     // by unique id

	var/list/datum/job/specific_jobs = list()

/proc/get_all_businesses(mob/user)
	user.client.debug_variables(businesses)
	var/dat = list()
	dat += "<center>"
	if(!businesses.len)
		dat += "<br>There are no registered businesses.<br>"
	else
		dat += "<br>Currently, there are [businesses.len] registered businesses.<br>"

		for(var/datum/business/B in businesses)

			dat += "<table style=\"width: 85%;\" border=1>"
			dat += "<thead><tr>"
			dat += "<th style=\"text-align: center; padding: 10px; background-color: [B.primary_color];\">"
			dat += "<span style=\"font-family: Tahoma, Geneva, sans-serif; font-size: 24px; color: [B.secondary_color];\">[B.name]</span></th></tr>"
			dat += "</thead><tbody><tr><td style=\"width: 100.0000%; padding: 10px;\">"
			dat += "<p style=\"text-align: center;\"><em><span style=\"font-size: 18px; color: [B.secondary_color]; font-family: Georgia, serif;\">[B.slogan]</span></em></p>"
			dat += "<hr>"

			dat += "<p>[B.description]</p>"

			dat += "</td></tr></tbody></table>"

			dat += "</br>"

	dat += "</center>"

	var/datum/browser/popup = new(usr, "Businesses", "Businesses", 640, 600, src)
	popup.set_content(jointext(dat,null))
	popup.open()

/proc/check_business_name_exist(var/name)
	for(var/datum/business/B in businesses)
		if(name == B.name)
			message_admins("Found [B.name].")
			return 1
	return 0

/proc/get_business_by_name(var/name)
	for(var/datum/business/B in businesses)
		if(B.name == name)
			return B


/proc/try_auth_business(var/datum/business/B, var/name, var/pass)   //Handles logins
	if(B.name == name && B.password == pass)
		return 1
	return 0

/proc/create_new_business(var/name, var/description, var/slogan, var/pass, var/category, var/owner_uid, var/owner_name)

	var/datum/business/B = new()
	B.name = name
	B.description = description
	B.slogan = slogan
	B.creation_time = get_game_time()
	B.password = pass
	B.owner_uid = owner_uid
	B.owner_name = owner_name
	B.uid = md5("[B.name]")

	B.creation_time = current_date_string

	businesses += B

	return B