/datum/expense
  var/name = "Generic Expense"
  var/cost_per_payroll = 0          // per payroll
  var/department = "Civilian"
  var/purpose = "Bill"

  var/comments                      // comments on this particular case.

  var/amount_left

  var/active                        // If this is currently active, or not.

  var/delete_paid = 1				// does this expense delete itself when paid?

  var/applied_by					// ckey of the person who made this expense


// This proc takes payment and then returns the "change"
/datum/expense/proc/process_charge(var/num)

	var/charge

	if(num > amount_left)
		charge += amount_left
	else
		charge += num

	amount_left -= charge
	department_accounts[department].money += charge

	if(delete_paid)
		if(-1 > amount_left)
			QDEL_NULL(src)

	return charge

// This proc is just a default proc for paying expenses per payroll.

/datum/expense/proc/payroll_expense()
	process_charge(cost_per_payroll)

//This if for if you have a expense, and a bank account.

/proc/charge_expense(var/datum/expense/E, var/datum/money_account/bank_account, var/num)
	E.process_charge(num)
	bank_account.money -= num


/datum/expense/police
  name = "Police Fine"
  cost_per_payroll = 30
  var/datum/law/fine

  department = "Police"


/datum/expense/hospital
  name = "Hospital Bill"
  cost_per_payroll = 30
  var/datum/medical_bill

  department = "Public Healthcare"


/datum/expense/law
  name = "Court Injunction"
  cost_per_payroll = 50
  var/datum/law/injunction

  department = "Civilian"


