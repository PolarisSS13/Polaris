/proc/save_all_emails()
	if(!config.canonicity)
		return 0

	for(var/datum/computer_file/data/email_account/account in ntnet_global.email_accounts)
		account.save_email()

	return 1

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

/proc/manifest_persistent_email(address)
	var/datum/computer_file/data/email_account/account = new/datum/computer_file/data/email_account()
	account.login = address

	if(!account.get_persistent_data())
		return 0

	return account



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


/proc/new_persistent_email(var/address, var/password)
	var/full_path = "data/persistent/emails/[address].sav"
	if(!full_path)			return 0
	if(fexists(full_path)) return 0

	var/savefile/S = new /savefile(full_path)
	if(!S)					return 0
	S.cd = "/"

	if(!address)
		return 0

	var/pass

	if(!password)
		pass = GenerateKey()
	else
		pass = password

	S["login"] << address
	S["inbox"] << list()
	S["outbox"] << list()
	S["spam"] << list()
	S["deleted"] << list()
	S["password"] << pass
	S["max_messages"] << 50

	return full_path



/proc/send_to_persistent_email(var/address, var/datum/computer_file/data/email_message/message)
	var/full_path = "data/persistent/emails/[address].sav"
	if(!full_path)			return 0
	if(!fexists(full_path)) return 0

	var/savefile/S = new /savefile(full_path)
	if(!S)					return 0
	S.cd = "/"

	if(!address)
		return 0

	if(!message)
		return 0

	var/list/inbox = list()
	var/list/spam = list()
	var/list/deleted = list()
	var/list/outbox = list()

	var/max_messages

	S["inbox"]		>>	inbox
	S["outbox"]		>>	outbox
	S["spam"]			>>	spam
	S["deleted"]		>>	deleted

	S["max_messages"]	>>	max_messages

	var/list/all_messages = 	(inbox | spam | deleted | outbox)

	if(!isemptylist(all_messages))
		if((all_messages.len - 1) > max_messages)
			return 0

	if(message.spam)
		if(prob(98))
			spam += message
		else
			inbox += message
	else
		if(prob(1))
			spam += message
		else
			inbox += message

	S["inbox"] << inbox
	S["spam"] << spam

	return 1

/proc/check_persistent_email(var/address)
	var/full_path = "data/persistent/emails/[address].sav"
	if(!full_path)			return 0
	if(fexists(full_path))	return full_path

	return 0

/proc/generate_email(var/name)
	var/new_email = "[replacetext(lowertext(name), " ", ".")][rand(1,500)]@[pick(using_map.usable_email_tlds)]"

	return new_email


/proc/get_persistent_email_suspended(var/address)
	var/full_path = "data/persistent/emails/[address].sav"
	if(!full_path)			return 0
	if(!fexists(full_path)) return 0

	var/savefile/S = new /savefile(full_path)
	if(!S)					return 0
	S.cd = "/"

	if(!address)
		return 0

	var/suspended

	S["suspended"] >> suspended

	return suspended


/proc/get_persistent_email_password(var/address)
	var/full_path = "data/persistent/emails/[address].sav"
	if(!full_path)			return 0
	if(!fexists(full_path)) return 0

	var/savefile/S = new /savefile(full_path)
	if(!S)					return 0
	S.cd = "/"

	if(!address)
		return 0

	var/password

	S["password"] >> password

	return password

/proc/change_persistent_email_address(var/address, var/new_address)
	var/full_path = "data/persistent/emails/[address].sav"
	if(!full_path)			return 0
	if(!fexists(full_path)) return 0

	var/savefile/S = new /savefile(full_path)
	if(!S)					return 0
	S.cd = "/"

	if(!address)
		return 0

	var/adr

	S["login"] >> adr

	adr = new_address

	S["login"] << adr

	return adr