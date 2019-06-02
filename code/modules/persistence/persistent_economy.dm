

// all the same, by default, but can be changed in-game.

/datum/economy/bank_accounts
	var/path = "data/persistent/banks.sav"
	var/tax_poor
	var/tax_middle
	var/tax_rich
	var/global/list/datum/money_account/eco_data
	var/global/list/datum/money_account/treasury

/datum/economy/bank_accounts/proc/set_economy()
	if(!department_acc_list)
		return 0

	treasury = station_account
	eco_data = department_acc_list

	for(var/M in department_acc_list)
		all_money_accounts.Add(M)

	for(var/T in station_account)
		all_money_accounts.Add(T)

	//rebuild department accounts

	department_accounts.Cut()

	for(var/datum/money_account/D in department_acc_list)
		department_accounts[D.department] = D

	message_admins("Set economy.", 1)

	return 1



/datum/economy/bank_accounts/proc/save_accounts()
//	message_admins("SAVE: Save all department accounts.", 1)
	if(!path)				return 0
	var/savefile/S = new /savefile(path)
	if(!fexists(path))		return 0
	if(!S)					return 0
	S.cd = "/"

	tax_poor = tax_rate_lower
	tax_middle = tax_rate_middle
	tax_rich = tax_rate_upper

	S["eco_data"] << eco_data
	S["treasury"] << treasury
	S["tax_rate_upper"] << tax_rich
	S["tax_rate_middle"] << tax_middle
	S["tax_rate_lower"] << tax_poor

	message_admins("Saved all department accounts.", 1)

/datum/economy/bank_accounts/proc/load_accounts()
//	message_admins("BEGIN: Loaded all department accounts.", 1)
	if(!path)				return 0
	if(!fexists(path))
		save_accounts()
		return 0
	var/savefile/S = new /savefile(path)
	if(!S)					return 0
	S.cd = "/"


	S["eco_data"] >> eco_data
	S["treasury"] >> treasury
	S["tax_rate_upper"] >> tax_rich
	S["tax_rate_middle"] >> tax_middle
	S["tax_rate_lower"] >> tax_poor

	for (var/datum/money_account/T in all_money_accounts)
		if(T.department)
			all_money_accounts -= T

	department_acc_list = eco_data

	station_account = treasury

	all_money_accounts.Add(department_acc_list)

	tax_rate_lower = tax_poor
	tax_rate_middle = tax_middle
	tax_rate_upper = tax_rich

	//rebuild department accounts
	department_accounts.Cut()

	for(var/datum/money_account/D in department_acc_list)
		department_accounts[D.department] = D

	link_economy_accounts()

	message_admins("Loaded all department accounts.", 1)