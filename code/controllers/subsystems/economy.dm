SUBSYSTEM_DEF(economy)
	name = "Economy"
	init_order = INIT_ORDER_PAYROLL

	wait = 1200 //Ticks once per 2 minutes
	var/payday_interval = 1 HOUR
	var/next_payday = 1 HOUR

/datum/controller/subsystem/economy/Initialize()
	.=..()

/datum/controller/subsystem/economy/fire()
	if (world.time >= next_payday)
		next_payday = world.time + payday_interval

		//Search general records, and process payroll for all those that have bank numbers.
		for(var/datum/data/record/R in data_core.general)
			payroll(R)
		command_announcement.Announce("Hourly payroll has been processed. Please check your bank accounts for your latest payment.", "Payroll")


/proc/payroll(var/datum/data/record/G)
	var/bank_number = G.fields["bank_account"]
	var/datum/job/job = job_master.GetJob(G.fields["real_rank"])
	var/department
	var/class = G.fields["economic_status"]
	var/name = G.fields["name"]
	var/age = G.fields["age"]
	var/datum/money_account/bank_account
	var/wage
	var/calculated_tax
	var/tax

	var/unique_id = G.fields["unique_id"]

	var/mob/living/carbon/human/linked_person



	//let's find the relevent person.
	for(var/mob/living/carbon/human/H in mob_list)
		if(unique_id == H.unique_id)
			linked_person = H

	if(!bank_number)
//		message_admins("ERROR: No bank number found for field. Returned [bank_number].", 1)
		return


	bank_account = get_account(bank_number)

	if(!bank_account)
//		message_admins("ERROR: Could not find a bank account for [bank_number].", 1)
		return


	department = job.department

	if(!(department in station_departments))
//		message_admins("ERROR: Could not find [department] in station departments.", 1)
		return

	if(bank_account.suspended)
//		message_admins("ERROR: Bank account [bank_number] is suspended.", 1)
		// If there's no money in the department account, tough luck. Not getting paid.
		var/datum/transaction/N = new()
		N.target_name = bank_account.owner_name
		N.purpose = "[department] Payroll: Failed (Payment Bounced Due to Suspension)"
		N.amount = 0
		N.date = "[get_game_day()] [get_month_from_num(get_game_month())], [get_game_year()]"
		N.time = stationtime2text()
		N.source_terminal = "[department] Funding Account"

		//add the account
		bank_account.transaction_log.Add(N)
		return

	if((!class)  ||  (class == "Unknown"))
		class = CLASS_WORKING
//		message_admins("ERROR: Could not find class. Assigned working class.", 1)

	if(!unique_id) // shouldn't happen, but you know.
		return


	if(linked_person.client)
		var/client/linked_client = linked_person.client

		if(linked_client.inactivity > 18000) // About 30 minutes inactivity.
			return // inactive people don't get paid, sorry.
	else
//		message_admins("ERROR: Not paid due to inactivity.", 1)
		return		// person's not in the round? welp.

	switch(class)
		if(CLASS_UPPER)
			tax = persistent_economy.tax_rate_upper
		if(CLASS_MIDDLE)
			tax = persistent_economy.tax_rate_middle
		if(CLASS_WORKING)
			tax = persistent_economy.tax_rate_lower


	wage = job.wage

//	message_admins("Wage set to [job.wage].", 1)

	if(!wage)
//		message_admins("ERROR: Job does not have wage.", 1)
		return


	if(wage > department_accounts[department].money)
		// If there's no money in the department account, tough luck. Not getting paid.
		var/datum/transaction/N = new()
		N.target_name = bank_account.owner_name
		N.purpose = "[department] Payroll: Failed (Inadequate Department Funds)"
		N.amount = 0
		N.date = "[get_game_day()] [get_month_from_num(get_game_month())], [get_game_year()]"
		N.time = stationtime2text()
		N.source_terminal = "[department] Funding Account"

		//add the account
		bank_account.transaction_log.Add(N)

//		message_admins("ERROR: Not paid because not enough money in department account.", 1)
		return

	if(age > 17) // Do they pay tax?
		calculated_tax = round(tax * wage, 1)

	//Tax goes to the treasury. Mh-hm.
	department_accounts["[station_name()] Funds"].money += calculated_tax

	//Your wage comes from your department, yes.
	department_accounts[department].money -= wage

	wage -= calculated_tax

	//You get paid.
	bank_account.money += wage

	//create an entry for the payroll (for the payee).
	var/datum/transaction/T = new()
	T.target_name = bank_account.owner_name
	T.purpose = "[department] Payroll: [name] ([calculated_tax] credit tax)"
	T.amount = wage
	T.date = "[get_game_day()] [get_month_from_num(get_game_month())], [get_game_year()]"
	T.time = stationtime2text()
	T.source_terminal = "[department] Funding Account"

	//add the account
	bank_account.transaction_log.Add(T)



	//if you owe anything, let's deduct your ownings.
	for(var/datum/expense/E in bank_account.expenses)
		E.payroll_expense(bank_account)

	//Complete
