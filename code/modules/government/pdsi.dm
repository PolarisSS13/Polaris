#DEFINE ACTIVE "active"
#DEFINE RESOLVED "resolved"
#DEFINE CLOSED "closed"
#DEFINE SUSPENDED "suspended"
#DEFINE IN_PROGRESS "in progess"

/datum/pdsi_report
	var/id
	var/title
	var/message
	var/reporter_name
	var/game_id
	var/status

/proc/new_pdsi_report(var/id, var/title, var/message, var/reporter_name)
	var/datum/expense/new_expense = new datum/expense(src)
