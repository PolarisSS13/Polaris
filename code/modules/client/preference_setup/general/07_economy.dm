/datum/category_item/player_setup_item/general/economy
	name = "Economy"
	sort_order = 7

/datum/category_item/player_setup_item/general/economy/load_character(var/savefile/S)
	S["money_balance"]	>> pref.money_balance
	S["bank_account"]	>> pref.bank_account
	S["bank_pin"]		>> pref.bank_pin
	S["expenses"]   	>> pref.expenses

/datum/category_item/player_setup_item/general/economy/save_character(var/savefile/S)
	S["money_balance"]	<< pref.money_balance
	S["bank_account"]	<< pref.bank_account
	S["bank_pin"]		<< pref.bank_pin
	S["expenses"]    	<< pref.expenses


/datum/category_item/player_setup_item/general/economy/sanitize_character()

	if(!pref.bank_pin)
		pref.bank_pin = rand(1111,9999)

	if(!pref.bank_account)
		pref.bank_account = make_new_persistent_account(pref.real_name, pref.money_balance, pref.bank_pin, pref.expenses, null, 0, 0)
		persist_set_balance(pref.bank_account, pref.money_balance)

	if(!check_persistent_account(pref.bank_account))
		pref.bank_account = make_new_persistent_account(pref.real_name, pref.money_balance, pref.bank_pin, pref.expenses, null, 0, 0)
		persist_set_balance(pref.bank_account, pref.money_balance)
		save_character()

	if(check_persistent_account(pref.bank_account))
		pref.money_balance = get_persistent_acc_balance(pref.bank_account)

	pref.money_balance		= sanitize_integer(pref.money_balance, 0, 999999, initial(pref.money_balance))
	pref.bank_pin			= sanitize_integer(pref.bank_pin, 1111, 9999, initial(pref.bank_pin))

/datum/category_item/player_setup_item/general/economy/delete_character(var/savefile/S)
	pref.money_balance		= 0
	del_persistent_account(pref.bank_account)
	pref.bank_pin			= 0
	pref.expenses = list()

/datum/category_item/player_setup_item/general/economy/content(var/mob/user)
	. = list()
	. += "<h1>Income and Expenses:</h1><hr>"
	. += "<b>Money:</b> [pref.money_balance] credits<br>"

	if(pref.bank_account)
		. += "<b>Account ID:</b> [pref.bank_account]<br>"

	if(pref.bank_pin)
		. += "<b>Account Pin:</b> [pref.bank_pin]<br>"
	. += "<b>Economic Class:</b> [pref.economic_status]<br>"
	if(persistent_economy)
		. += "<b>[pref.economic_status] Tax Rate:</b> [get_tax_rate(pref.economic_status)]%<br>"

	. += "<b>Debts:</b></br>"
	if(isemptylist(pref.expenses))
		. += "<i>You have no recorded debts.</i>"
	else
		for(var/datum/expense/E in pref.expenses)
			var/purpose_name
			if(E.purpose)
				purpose_name = " ([E.purpose])"
				. += "<b>[E.name][purpose_name]:</b> [E.amount_left] credits. ([E.cost_per_payroll] per payroll.)<br>"


	. = jointext(.,null)