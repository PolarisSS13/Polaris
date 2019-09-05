datum/expenses
  var/name = "Generic Expense"
  var/cost_per_payroll = 0          // per payroll
  var/department = "Civilian"
  var/purpose = "Bill"
  
  var/comments                      // comments on this particular case.

  var/amount_left


datum/expense/police
  name = "Police Fine"
  cost_per_payroll = 30
  var/datum/law/fine

  department = "Police"


datum/expense/hospital
  name = "Hospital Bill"
  cost_per_payroll = 30
  var/datum/medical_bill

  department = "Public Healthcare"


datum/expense/law
  name = "Court Injunction"
  cost_per_payroll = 50
  var/datum/law/injunction

  department = "Civilian"
