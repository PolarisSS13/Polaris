
/mob/living/carbon/human/proc/save_character_money()

	sanitize_integer(mind.initial_account.money, 0, 999999, initial(mind.initial_account.money))

	mind.prefs.money_balance = mind.initial_account.money
	mind.prefs.bank_pin = mind.initial_account.remote_access_pin
	mind.prefs.bank_no = mind.initial_account.account_number

	return 1

