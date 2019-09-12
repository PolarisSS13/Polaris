/datum/expense
  var/name = "Generic Expense"
  var/cost_per_payroll = 0          // per payroll
  var/department = "Civilian"
  var/purpose = "Bill"

  var/comments                      // comments on this particular case.

  var/amount_left

  var/active = 1                      // If this is currently active, or not.

  var/delete_paid = 1				// does this expense delete itself when paid?

  var/applied_by					// ckey of the person who made this expense
  var/added_by						// IC version of the person who made this.

  var/creation_date					// Date of when this was made.


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

/datum/expense/proc/payroll_expense()
	process_charge(cost_per_payroll)

//This if for if you have a expense, and a bank account.

/proc/charge_expense(var/datum/expense/E, var/datum/money_account/bank_account, var/num)
	if(!active)
		return 0

	E.process_charge(num)
	bank_account.money -= num

	if(E.delete_paid && !E.amount_left)
		if(E in bank_account.expenses)
			bank_account.expenses -= E
			qdel(E)

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


