

/datum/economy/bank_accounts
	var/path = "data/persistent/banks.sav"

/datum/economy/bank_accounts/proc/save_accounts()
//	message_admins("SAVE: Save all department accounts.", 1)
	if(!path)				return 0
	var/savefile/S = new /savefile(path)
	if(!fexists(path))		return 0
	if(!S)					return 0
	S.cd = "/"

	S["department_accounts"]		<< 		department_accounts

	message_admins("Saved all department accounts.", 1)

/datum/economy/bank_accounts/proc/load_accounts()
//	message_admins("BEGIN: Loaded all department accounts.", 1)
	if(!path)				return 0
	if(!fexists(path))		return 0
	var/savefile/S = new /savefile(path)
	if(!S)					return 0
	S.cd = "/"


	S["department_accounts"]		>> 		department_accounts

	message_admins("Loaded all department accounts.", 1)

/datum/economy/bank_accounts/proc/restore_economy()
	load_accounts()

	message_admins("Restored economy.", 1)

/datum/economy/bank_accounts/proc/view_accounts()

	var/list/dat = list("<table width = '100%'>")
	dat += "<b>Money Accounts:</b><br>"
	for(var/datum/money_account/D in all_money_accounts)

		dat += "<h3>[D.owner_name]</h3> <br>"

		dat += "<b>Balance:</b> [D.money] credits. <br>"
		dat += "<b>Account Number:</b> [D.account_number]<br>"
		dat += "<b>Pin:</b> [D.remote_access_pin] <br>"
		dat += "<br>"
		dat += "<a href='?src=\ref[src];adjust_money=[D]'>Adjust Money</a><br>"
		dat += "<a href='?src=\ref[src];logs_view=[D.transaction_log]'>View Transaction Logs</a><br>"
		dat += "<br><hr><br>"
	dat += "</table>"
	var/datum/browser/popup = new(usr, "admin_accounts", "View Accounts Data", src)
	popup.set_content(jointext(dat, null))
	popup.open()


/datum/economy/bank_accounts/proc/view_logs(var/list/L)



/datum/economy/bank_accounts/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["adjust_money"])
		var/datum/money_account/M = href_list["adjust_money"]
		var/adj_money = sanitize(input(usr, "Current money is [M.money]. Set money to what?", "Magical Money Adjustment", null)  as num|null)
		if(!adj_money)
			return

		M.money = adj_money

		message_admins("Adjusted money of [M] to [adj_money].", 1)

	else if(href_list["logs_view"])
		var/L = href_list["logs_view"]
		var/list/dat = list("<table width = '100%'>")
		for(var/datum/transaction/T in L)
			dat += "<b>Name:</b> [T.target_name]. <br>"
			dat += "<b>Amount:</b> [T.amount] credits<br>"
			dat += "<br>"
			dat += "<b>Purpose:</b> [T.purpose]<br>"
			dat += "<b>Date & Time:</b> [T.date] - [T.time]<br>"
			dat += "<b>Source Terminal:</b> [T.source_terminal]<br>"
			dat += "<hr><br>"
		dat += "</table>"
		var/datum/browser/popup = new(usr, "admin_accounts_log", "View Transaction Logs", src)
		popup.set_content(jointext(dat, null))
		popup.open()

	return ..()