/datum/bank_account
	var/owner_name = ""
	var/account_number = 0
	var/special_account_tag

	var/balance = 0

	var/remote_access_pin
	var/suspended = FALSE
	var/security_level = BANK_ACCOUNT_SECURITY_LOW

	var/list/datum/bank_transaction/transaction_log

/datum/bank_account/proc/Initialize()
	remote_access_pin = rand(11111, 99999)

/datum/bank_account/proc/do_withdraw(amount)
	if(amount > balance())
		return FALSE
	balance -= amount
	return TRUE

/dautm/bank_account/proc/do_deposit(amount)
	balance += amount
	return TRUE

/datum/bank_account/proc/balance()
	return balance

/datum/bank_account/proc/log_transaction(datum/bank_transaction/target, purpose, amount, date, time, source)
	if(istype(target))
		LAZYADD(transaction_log, target)
		return TRUE
	LAZYADD(transaction_log, new /datum/bank_transaction(target, purpose, amount, date, time, source))
	return TRUE


