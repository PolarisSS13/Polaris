/datum/category_item/player_setup_item/general/expense
	name = "Expense"
	sort_order = 8

datum/preferences
	var/list/datum/expense/expenses = list()

/datum/category_item/player_setup_item/general/expense/load_character(var/savefile/S)
	S["expenses"]    >> pref.expenses

/datum/category_item/player_setup_item/general/expense/save_character(var/savefile/S)
	S["expenses"]    << pref.expenses


/datum/category_item/player_setup_item/general/economy/delete_character(var/savefile/S)
	pref.expenses = list()

/datum/category_item/player_setup_item/general/economy/content(var/mob/user)
	. = list()
	. += "<h1>Income and Expenses:</h1><hr>"
	. += "<b>Debts:</b></br>"
	if(!pref.expenses)
		. += "<i>You have no recorded debts.</i>"

	for(var/datum/expense/E in pref.expenses)
		var/purpose_name
		if(E.purpose)
			purpose_name = " ([E.purpose])"
			. += "<h4>[E.name][purpose_name]</h4><br> <b>Debt owed:</b> [E.amount_left] credits. ([E.cost_per_payroll] per payroll.)<br>"

	. = jointext(.,null)