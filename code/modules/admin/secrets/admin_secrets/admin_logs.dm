/datum/admin_secret_item/admin_secret/admin_logs
	name = "Admin Logs"

/datum/admin_secret_item/admin_secret/admin_logs/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	var/dat = "<B>Admin Log<HR></B>"
	for(var/l in admin_log)
		dat += "<li>[l]</li>"
	if(!admin_log.len)
		dat += "No-one has done anything this round!"
	user << browse(dat, "window=admin_log")


var/round_text_log = list( )

/datum/admin_secret_item/admin_secret/round_logs
	name = "Round Dialogue Logs"

/datum/admin_secret_item/admin_secret/round_logs/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	var/dat = "<B>Dialogue Log<HR></B>"
	for(var/l in round_text_log)
		dat += "<li>[l]</li>"
	if(!round_text_log)
		dat += "No-one has done anything this round!"
	user << browse(dat, "window=round_log")
