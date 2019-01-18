SUBSYSTEM_DEF(economy)
	name = "Economy"
	wait = 100
	init_order = INIT_ORDER_ECONOMY

	var/conversion_ratio_credits_cargo = 1			//Higher = more cargo points
	var/station_paycheck = 10000					//Per minute.
	var/station_payroll_interval = 10 MINUTES		//how often payouts happen

	var/static/list/accounts								//assoc list "[number]" = /datum/bank_account				- These two are static because I'm too lazy to write recover().
	var/static/list/special_accounts						//assoc list "special_account_tag" = /datum/bank_account
	var/static/next_account_number = 1

/datum/controller/subsystem/economy/Initialize()
	initialize_accounts()

/datum/controller/subsystem/economy/fire()

/datum/controller/subsystem/economy/proc/initialize_accounts()
	accounts = accounts || list()
	special_accounts = special_accounts || list()





/datum/controller/subsystem/economy/proc/get_account(number)
	return accounts["[number]"]

/datum/controller/subsystem/economy/proc/next_account_number()
	next_account_number += rand(2, 50)
	if(next_account_number >= 1e12)
		next_account_number = 1
	var/number = num2text(next_account_number, 12)
	if(accounts["[number]"])
		return next_account_number()
	return number

/datum/controller/subsystem/economy/proc/random_account_number()
	var/number = num2text(rand(1, 1e11))
	if(accounts["[number]"])
		return random_account_number()
	return number

//I do NOT like what I did with the log variable.
/datum/controller/subsystem/economy/proc/make_account(name, balance, special_tag, obj/machinery/account_database/log = TRUE, force_localized = FALSE)
	if(special_accounts[special_tag])
		return FALSE
	var/localized = force_localized || istype(log)
	var/account_number = localized? next_account_number() : random_account_number()
	var/datum/bank_account/BA = new
	BA.owner_name = name
	BA.balance = balance
	BA.account_number = account_number
	accounts["[BA.account_number]"] = BA
	if(istext(special_tag))
		BA.special_account_tag = special_tag
		special_accounts[special_tag] = BA
	BA.Initialize()
	var/datum/bank_transaction/T = new
	T.target_name = name
	T.purpose = "Account creation"
	T.amount = balance
	if(istype(log))

		T.date =
		T.time = stationtime2text()
		T.source_terminal = log.machine_id

		//create a sealed package containing the account details - This should REALLY go somewhere else, ugh.
		var/obj/item/smallDelivery/P = new /obj/item/smallDelivery(source_db.loc)

		var/obj/item/weapon/paper/R = new /obj/item/weapon/paper(P)
		P.wrapped = R
		R.name = "Account information: [M.owner_name]"
		R.info = "<b>Account details (confidential)</b><br><hr><br>"
		R.info += "<i>Account holder:</i> [M.owner_name]<br>"
		R.info += "<i>Account number:</i> [M.account_number]<br>"
		R.info += "<i>Account pin:</i> [M.remote_access_pin]<br>"
		R.info += "<i>Starting balance:</i> $[M.money]<br>"
		R.info += "<i>Date and time:</i> [stationtime2text()], [current_date_string]<br><br>"
		R.info += "<i>Creation terminal ID:</i> [source_db.machine_id]<br>"
		R.info += "<i>Authorised NT officer overseeing creation:</i> [source_db.held_card.registered_name]<br>"

		//stamp the paper
		var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
		stampoverlay.icon_state = "paper_stamp-cent"
		if(!R.stamped)
			R.stamped = new
		R.stamped += /obj/item/weapon/stamp
		R.overlays += stampoverlay
		R.stamps += "<HR><i>This paper has been stamped by the Accounts Database.</i>"

	else
		//set a random date, time and location some time over the past few decades
		T.date = "[num2text(rand(1,31))] [pick("January","February","March","April","May","June","July","August","September","October","November","December")], 25[rand(10,56)]"
		T.time = "[rand(0,24)]:[rand(11,59)]"
		T.source_terminal = "NTGalaxyNet Terminal #[rand(111,1111)]"
	BA.log_transaction(T)
	return BA





/proc/charge_to_account(var/attempt_account_number, var/source_name, var/purpose, var/terminal_id, var/amount)
	for(var/datum/money_account/D in all_money_accounts)
		if(D.account_number == attempt_account_number && !D.suspended)
			D.money += amount

			//create a transaction log entry
			var/datum/transaction/T = new()
			T.target_name = source_name
			T.purpose = purpose
			if(amount < 0)
				T.amount = "([amount])"
			else
				T.amount = "[amount]"
			T.date = current_date_string
			T.time = stationtime2text()
			T.source_terminal = terminal_id
			D.transaction_log.Add(T)

			return 1

	return 0

//this returns the first account datum that matches the supplied accnum/pin combination, it returns null if the combination did not match any account
/proc/attempt_account_access(var/attempt_account_number, var/attempt_pin_number, var/security_level_passed = 0)
	for(var/datum/money_account/D in all_money_accounts)
		if(D.account_number == attempt_account_number)
			if( D.security_level <= security_level_passed && (!D.security_level || D.remote_access_pin == attempt_pin_number) )
				return D
			break

/proc/get_account(var/account_number)
	for(var/datum/money_account/D in all_money_accounts)
		if(D.account_number == account_number)
			return D

