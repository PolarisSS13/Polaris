/datum/bank_transaction
	var/target_name = ""
	var/purpose = ""
	var/amount = 0
	var/date = ""
	var/time = ""
	var/source_terminal = ""

/datum/bank_transaction/New(target, purpose, amount, date, time, source)
	src.target_name = target
	src.purpose = purpose
	src.amount = amount
	src.date = date
	src.time = time
	src.source_terminal = source
