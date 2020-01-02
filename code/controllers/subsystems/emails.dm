SUBSYSTEM_DEF(emails)
	name = "Emails"
	init_order = INIT_ORDER_EMAILS
	flags = SS_NO_FIRE

/datum/controller/subsystem/emails/Initialize(timeofday)
	SetupGovEmails()

	..()


/datum/controller/subsystem/emails/proc/GetGovEmails()
	var/list/gov_emails = list()

	gov_emails += using_map.president_email
	gov_emails += using_map.vice_email
	gov_emails += using_map.boss_email
	gov_emails += using_map.rep_email
	gov_emails += using_map.director_email
	gov_emails += using_map.investigation_email

	gov_emails += using_map.council_email

	gov_emails += using_map.minister_defense_email
	gov_emails += using_map.minister_health_email
	gov_emails += using_map.minister_innovation_email
	gov_emails += using_map.minister_justice_email
	gov_emails += using_map.minister_information_email

	return gov_emails


/datum/controller/subsystem/emails/proc/SetupGovEmails()
	//makes sure an email exists for these emails.
	for(var/E in GetGovEmails())
		if(!E)
			continue

		var/datum/computer_file/data/email_account/email

		if(!check_persistent_email(E))
			new_persistent_email(E)

		email = manifest_persistent_email(E)
		email.max_messages = 1000

	return 1


/datum/controller/subsystem/emails/proc/save_all_emails()
	if(!config.canonicity)
		return 0

	for(var/datum/computer_file/data/email_account/account in ntnet_global.email_accounts)
		account.save_email()

	return 1


/datum/controller/subsystem/emails/proc/manifest_persistent_email(address)
	var/datum/computer_file/data/email_account/account = new/datum/computer_file/data/email_account()
	account.login = address

	if(!account.get_persistent_data())
		return 0

	return account

/datum/controller/subsystem/emails/proc/new_persistent_email(var/address, var/password)
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



/datum/controller/subsystem/emails/proc/send_to_persistent_email(var/address, var/datum/computer_file/data/email_message/message)
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



/datum/controller/subsystem/emails/proc/check_persistent_email(var/address)
	var/full_path = "data/persistent/emails/[address].sav"
	if(!full_path)			return 0
	if(fexists(full_path))	return full_path

	return 0

/datum/controller/subsystem/emails/proc/generate_email(var/name)
	var/new_email = "[replacetext(lowertext(name), " ", ".")][rand(1,500)]@[pick(using_map.usable_email_tlds)]"

	return new_email


/datum/controller/subsystem/emails/proc/get_persistent_email_suspended(var/address)
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



/datum/controller/subsystem/emails/proc/get_persistent_email_password(var/address)
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


/datum/controller/subsystem/emails/proc/change_persistent_email_address(var/address, var/new_address)
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

/datum/controller/subsystem/emails/proc/change_persistent_email_password(var/address, var/new_pass)
	var/full_path = "data/persistent/emails/[address].sav"
	if(!full_path)			return 0
	if(!fexists(full_path)) return 0

	var/savefile/S = new /savefile(full_path)
	if(!S)					return 0
	S.cd = "/"

	if(!address)
		return 0

	var/pass

	S["password"] >> pass

	pass = new_pass

	S["password"] << pass

	return pass
