

/datum/computer_file/data/email_account/proc/save_email()
	var/full_path = "data/persistent/emails/[login].sav"
	if(!full_path)			return 0
	if(!fexists(full_path)) return 0

	var/savefile/S = new /savefile(full_path)
	if(!S)					return 0
	S.cd = "/"

	S["login"] 		<<		login
	S["inbox"] 		<< 		inbox
	S["outbox"]		<<		outbox
	S["spam"]			<< 		spam
	S["deleted"]		<<		deleted
	S["login"] 		<< 		login
	S["password"] 		<< 		password
	S["suspended"] 	<< 		suspended
	S["max_messages"] 	<<		max_messages

	return 1



/datum/computer_file/data/email_account/proc/get_persistent_data()
	var/full_path = "data/persistent/emails/[login].sav"
	if(!full_path)			return 0
	if(!fexists(full_path)) return 0

	var/savefile/S = new /savefile(full_path)
	if(!S)					return 0
	S.cd = "/"

	S["login"]		>>	login
	S["password"]		>>	password
	S["inbox"]		>>	inbox
	S["outbox"]		>>	outbox
	S["spam"]			>>	spam
	S["deleted"]		>>	deleted
	S["suspended"]		>>	suspended
	S["max_messages"]	>>	max_messages
	return 1








