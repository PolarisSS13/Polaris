/datum/expense
  var/name = "Generic Expense"
  var/cost_per_payroll = 1          // per payroll
  var/department = "Civilian"
  var/purpose = "Bill"

  var/comments                      // comments on this particular case.

  var/initial_cost				//how much it cost in the beginning

  var/amount_left

  var/active = 1                      // If this is currently active, or not.

  var/delete_paid = 1				// does this expense delete itself when paid?

  var/applied_by					// ckey of the person who made this expense
  var/added_by						// IC version of the person who made this.

  var/creation_date					// Date of when this was made.

  var/color = COLOR_WHITE			// the color this is associated with. usually for departments

  var/list/ckey_edit_list					// ckey of last editor(s)




// This proc takes payment and then returns the "change"
/datum/expense/proc/process_charge(var/num)
	if(!active)
		return 0

	var/charge

	if(num > amount_left)
		charge += amount_left
	else
		charge += num

	amount_left -= charge
	department_accounts[department].money += charge

	return charge

// This proc is just a default proc for paying expenses per payroll.

/datum/expense/proc/payroll_expense(var/datum/money_account/bank_account)
	charge_expense(src, bank_account, cost_per_payroll)

//This if for if you have a expense, and a bank account.

/proc/charge_expense(var/datum/expense/E, var/datum/money_account/bank_account, var/num)
	if(!E.active)
		return 0

	E.process_charge(num)
	bank_account.money -= num

	//create an entry for the charge.
	var/datum/transaction/T = new()
	T.target_name = bank_account.owner_name
	T.purpose = "Debt Payment: [E.name]"
	T.amount = num
	T.date = "[get_game_day()] [get_month_from_num(get_game_month())], [get_game_year()]"
	T.time = stationtime2text()
	T.source_terminal = "[E.department] Funding Account"

	//add the account
	bank_account.transaction_log.Add(T)


	if(E.delete_paid)
		if(!E.amount_left)
			bank_account.expenses -= E
			qdel(E)

/datum/expense/police
	name = "Police Fine"
	cost_per_payroll = 30
	var/datum/law/fine

	department = "Police"

	color = COLOR_RED_GRAY


/datum/expense/hospital
	name = "Hospital Bill"
	cost_per_payroll = 30
	var/datum/medical_bill

	department = "Public Healthcare"

	color = COLOR_BLUE_GRAY


/datum/expense/law
	name = "Court Injunction"
	cost_per_payroll = 50
	var/datum/law/injunction

	department = "Civilian"

	color = COLOR_OLIVE


// This proc is just a default proc for paying expenses per payroll.

/proc/create_expense(var/expense_type, var/name, var/comments, var/amount_left, var/added_by, var/applied_by)
	var/datum/expense/new_expense = new expense_type(src)

	new_expense.name = name
	new_expense.comments = comments
	new_expense.amount_left = amount_left
	new_expense.initial_cost = amount_left
	new_expense.added_by = added_by
	new_expense.applied_by = applied_by

	new_expense.creation_date = "[get_game_day()] [get_month_from_num(get_game_month())], [get_game_year()] - [stationtime2text()]"

	return new_expense
