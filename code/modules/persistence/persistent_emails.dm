
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


	S["address"] << address
	S["password"] << pass

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

	var/list/inbox
	var/list/spam

	S["inbox"] >> inbox
	S["spam"] >> spam

	if(message.spam)
		if(prob(98))
			spam.Add(message)
		else
			inbox.Add(message)
	else
		if(prob(1))
			spam.Add(message)
		else
			inbox.Add(message)

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

	S["address"] >> adr

	adr = new_address

	S["address"] << adr

	return adr