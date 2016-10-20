/datum/ban
	var/list/data

/datum/ban/New(var/list/_data)
	data = _data
	if(data["bantype"] == BAN_SERVERBAN)
		serverbans += src
	else
		jobbans += src
	allbans += src

/datum/ban/Destroy()
	data.Cut()
	return ..()

// Use this to update the datum with new information from the sqlite db.
// Using sqlite_load_bans() is very expensive.
/datum/ban/proc/update_data()
	establish_sqlite_connection()
	if(!sqlite_db)
		return
	var/database/query/query = new(
		"SELECT * FROM ban \
		WHERE (id == ?);", data["id"]
		)
	query.Execute(sqlite_db)
	sqlite_check_for_errors(query, "update_data (1)")
	if(query.NextRow())
		data = query.GetRowData()

/datum/ban/proc/get_summary()

	var/banstatus = "<b>(bID #[data["id"]])</b> "
	if(get_bantype() == BAN_SERVERBAN)
		banstatus += "Banned from the server"
	else
		banstatus += "Banned from job ([data["job"]])"

	banstatus += " by [data["banning_ckey"]] on [get_banned_datetime()] for reason: '[data["reason"]]'. "

	var/strike = 1
	if(!expired() && !lifted())
		strike = 0
		banstatus += "Active."
	else if(expired())
		banstatus += "Expired on [get_expiry_datetime()]."
	else if(lifted())
		banstatus += "Unbanned by [data["unbanned_ckey"]] on [get_unbanned_datetime()]."

	return strike ? "<strike>[banstatus]</strike>" : banstatus

/datum/ban/proc/expired()
	if(!data["expiration_datetime"])
		return FALSE // No entry means it is a permaban.
	var/database/query/query = new(
		"SELECT id FROM ban \
		WHERE (id == ? AND expiration_datetime < datetime('now'));", data["id"]
		)
	query.Execute(sqlite_db)
	sqlite_check_for_errors(query, "expired (1)")
	if(query.NextRow()) // If this is true, the ban ID provided is expired.
		return TRUE
	return FALSE // Tough luck otherwise.

/datum/ban/proc/lifted()
	return (!isnull(data["unbanned_ckey"]) && data["unbanned_ckey"] != "")

/datum/ban/proc/get_banned_datetime()
	return data["banning_datetime"]

/datum/ban/proc/get_unbanned_datetime()
	return data["unbanned_datetime"]

/datum/ban/proc/get_expiry_datetime()
	return data["expiration_datetime"]

/datum/ban/proc/get_bantype()
	return data["bantype"]

/proc/get_ban_datum_by_id(var/_id)
	for(var/datum/ban/B in allbans)
		if(B.data["id"] == _id)
			return B

/datum/ban/proc/unban(var/unbanner)
	establish_sqlite_connection()
	if(!sqlite_db)
		return
	if(!unbanner)
		return
	var/database/query/query = new(
		"UPDATE ban SET unbanned_ckey = ?, unbanned_datetime = datetime('now') \
		WHERE id == ?;", sql_sanitize_text(ckey(unbanner)), data["id"])
	query.Execute(sqlite_db)
	sqlite_check_for_errors(query, "unban (1)")
	log_and_message_admins("unbanned [data["ckey"]]'s [data["bantype"]].")
	update_data()

/datum/ban/proc/edit_reason(var/new_reason)
	establish_sqlite_connection()
	if(!sqlite_db)
		return
	if(!new_reason)
		return
	var/current_reason = data["reason"]
	var/database/query/query = new(
		"UPDATE ban SET reason = ? \
		WHERE id == ?;", new_reason, data["id"])
	query.Execute(sqlite_db)
	sqlite_check_for_errors(query, "edit_reason (1)")
	log_and_message_admins("changed [data["ckey"]]'s ban reason from ([current_reason]), to ([new_reason]).")
	update_data()

/datum/ban/proc/edit_ip(var/new_ip)
	establish_sqlite_connection()
	if(!sqlite_db)
		return
	if(!new_ip)
		return
	var/current_ip = data["ip"]
	var/database/query/query = new(
		"UPDATE ban SET ip = ? \
		WHERE id == ?;", new_ip, data["id"])
	query.Execute(sqlite_db)
	sqlite_check_for_errors(query, "edit_ip (1)")
	log_and_message_admins("changed [data["ckey"]]'s ban IP address from ([current_ip]), to ([new_ip]).")
	update_data()

/datum/ban/proc/edit_cid(var/new_cid)
	establish_sqlite_connection()
	if(!sqlite_db)
		return
	if(!new_cid)
		return
	var/current_cid = data["computerid"]
	var/database/query/query = new(
		"UPDATE ban SET computerid = ? \
		WHERE id == ?;", new_cid, data["id"])
	query.Execute(sqlite_db)
	sqlite_check_for_errors(query, "edit_cid (1)")
	log_and_message_admins("changed [data["ckey"]]'s ban Comp. ID from ([current_cid]), to ([new_cid]).")
	update_data()

/datum/ban/proc/edit_expiration_datetime(var/new_datetime)
	establish_sqlite_connection()
	if(!sqlite_db)
		return
	if(!new_datetime)
		return
	var/current_datetime = data["expiration_datetime"]
	var/database/query/query = new(
		"UPDATE ban SET expiration_datetime = ? \
		WHERE id == ?;", new_datetime, data["id"])
	query.Execute(sqlite_db)
	sqlite_check_for_errors(query, "edit_expiration_datetime (1)")
	log_and_message_admins("changed [data["ckey"]]'s ban expiration time from ([current_datetime]), to ([new_datetime]).")
	update_data()

/datum/ban/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["view_ban"])
		interact(usr)
	if(href_list["lift_ban"])
		var/confirm = alert("Confirm unbanning of [data["ckey"]].","Unban","No","Yes")
		if(confirm == "Yes")
			unban(usr.ckey)
	if(href_list["edit_reason"])
		var/new_reason = sql_sanitize_text(input("Please write a new reason to be written on the ban.", "Ban Edit", "[data["reason"]]") as null|message)
		if(new_reason)
			new_reason = "(EDITED BY [uppertext(usr.key)]) [new_reason]"
			edit_reason(new_reason)
	if(href_list["edit_ip"])
		var/new_ip = sql_sanitize_text(input("Please write a IP address to be written on the ban.", "Ban Edit", "[data["ip"]]") as null|text)
		if(new_ip)
			edit_ip(new_ip)
	if(href_list["edit_cid"])
		var/new_cid = input("Please write a Comp. ID to be written on the ban.", "Ban Edit", "[data["computerid"]]") as null|num
		if(new_cid)
			edit_cid(new_cid)
	if(href_list["edit_expiration_datetime"])
		var/current_year = time2text(world.realtime, "YYYY")
		var/current_month = time2text(world.realtime, "MM")
		var/current_day = time2text(world.realtime, "DD")
		var/current_hour = time2text(world.realtime, "hh")
		var/current_minute = time2text(world.realtime, "mm")
		var/new_year = input("Please write what year the ban should expire.", "Ban Edit", current_year) as null|num
		if(!new_year)
			return
		var/new_month = input("Please write what month (in number form) the ban should expire.", "Ban Edit", current_month) as null|num
		if(!new_month)
			return
		var/new_day = input("Please write what day (in number form) the ban should expire.", "Ban Edit", current_day) as null|num
		if(!new_day)
			return
		var/new_hour = input("Please write what hour (in number form) the ban should expire.", "Ban Edit", current_hour) as null|num
		if(!new_hour)
			return
		var/new_minute = input("Please write what minute (in number form) the ban should expire.", "Ban Edit", current_minute) as null|num
		if(!new_minute)
			return
		//2016-11-02 04:15:46
		var/new_datetime = "[new_year]-[new_month]-[new_day] [new_hour]:[new_minute]:00"

		edit_expiration_datetime(new_datetime)



/datum/ban/proc/interact(var/mob/user)
	var/HTML = "<html><head><title>[data["ckey"]]'s ban</title></head><body>"
	HTML += "<h2><b>Info</b></h2><br>"
	HTML += "<b>Active?</b> [(expired() || lifted() ) ? "No" : "Yes"]<br>"
	HTML += "<b>Lifted?</b> [lifted() ? "Yes" : "No"]<br>"
	HTML += "<br>"
	HTML += "<b>Database ID:</b> [data["id"]]<br>"
	HTML += "<b>Ckey:</b> [data["ckey"] ? data["ckey"] : "CKEY NOT SET"]<br>"
	HTML += "<b>IP Address:</b> [data["ip"] ? data["ip"] : "IP NOT SET"]<br>"
	HTML += "<b>Comp. ID:</b> [data["computerid"] ? data["computerid"] : "COMPUTER ID NOT SET"]<br>"
	HTML += "<b>Ban Type:</b> [get_bantype() ? get_bantype() : "BAN TYPE NOT SET"]<br>"
	HTML += "<b>Job:</b> [data["job"] ? data["job"] : "Not Jobbanned"]<br>"
	HTML += "<b>Banning Admin:</b> [data["banning_ckey"] ? data["banning_ckey"] : "BANNING ADMIN NOT SET"]<br>"
	HTML += "<b>Time of Ban:</b> [data["banning_datetime"] ? data["banning_datetime"] : "BANNING TIME NOT SET"]<br>"
	HTML += "<b>Expiration Time:</b> [data["expiration_datetime"] ? data["expiration_datetime"] : "Permanent"]<br>"
	HTML += "<b>Unbanning Admin:</b> [data["unbanned_ckey"] ? data["unbanned_ckey"] : "Not Lifted"]<br>"
	HTML += "<b>Unbanning Time:</b> [data["unbanned_datetime"] ? data["unbanned_time"] : "Not Lifted"]<br>"
	HTML += "<b>Reason:</b> [data["reason"] ? data["reason"] : "REASON NOT SET"]<br>"
	HTML += "<br>"
	HTML += "<h2><b>Actions</b></h2><br>"
	HTML += "<a href='?src=\ref[src];lift_ban=1'>\[Lift Ban\]</a> | "
	HTML += "<a href='?src=\ref[src];edit_reason=1'>\[Edit Reason\]</a> | "
	HTML += "<a href='?src=\ref[src];edit_ip=1'>\[Edit IP\]</a> | "
	HTML += "<a href='?src=\ref[src];edit_cid=1'>\[Edit Comp. ID\]</a> | "
	HTML += "<a href='?src=\ref[src];edit_expiration_datetime=1'>\[Edit Expiration Time\]</a>"

	HTML += "</body></html>"
	usr << browse(HTML, "window=ban_\ref[src];size=400x444;border=1;can_resize=1;can_close=1;can_minimize=1")