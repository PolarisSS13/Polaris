
/proc/new_persistent_email(var/address, var/password)
	var/full_path = "data/persistent/emails/[address].sav"
	if(!full_path)			return 0
	if(fexists(full_path)) return 0

	var/savefile/S = new /savefile(full_path)
	if(!S)					return 0
	S.cd = "/"

	if(!address)
		return 0

	if(!password)
		password = GenerateKey()

	S["address"] << address
	S["password"] << password

	return S