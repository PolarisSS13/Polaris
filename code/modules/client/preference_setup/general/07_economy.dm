/datum/category_item/player_setup_item/general/economy
	name = "Economy"
	sort_order = 7

/datum/category_item/player_setup_item/general/economy/load_character(var/savefile/S)
	S["money_balance"]	>> pref.money_balance
	S["bank_no"]		>> pref.bank_no
	S["money_balance"]	>> pref.money_balance

/datum/category_item/player_setup_item/general/economy/save_character(var/savefile/S)
	S["money_balance"]	<< pref.money_balance
	S["bank_no"]		<< pref.bank_no
	S["bank_pin"]		<< pref.bank_pin

/datum/category_item/player_setup_item/general/economy/sanitize_character()
	pref.money_balance		= sanitize_integer(pref.money_balance, 0, 99999999, initial(pref.money_balance))
	pref.bank_no			= sanitize_integer(pref.bank_no, 111111, 999999, initial(pref.bank_no))
	pref.bank_pin			= sanitize_integer(pref.bank_pin, 1111, 9999, initial(pref.bank_pin))
	if(!pref.bank_pin)
		pref.bank_pin = rand(1111,9999)
	if(!pref.bank_no)
		pref.bank_no = rand(111111, 999999)

/datum/category_item/player_setup_item/general/economy/delete_character(var/savefile/S)
	pref.money_balance		= 0
	pref.bank_no			= 0
	pref.bank_pin			= 0


/datum/category_item/player_setup_item/general/economy/content(var/mob/user)
	. = list()
	. += "<h1>Income and Expenses:</h1><hr>"
	. += "<b>Money:</b> [pref.money_balance] credits<br>"

	if(pref.bank_no)
		. += "<b>Account Number:</b> [pref.bank_no]<br>"

	if(pref.bank_pin)
		. += "<b>Account Pin:</b> [pref.bank_pin]<br>"
	. += "<b>Social Class:</b> [pref.economic_status]<br>"
	. += "<b>[pref.economic_status] Tax Rate:</b> [get_tax_rate(pref.economic_status)]%<br>"

	. = jointext(.,null)