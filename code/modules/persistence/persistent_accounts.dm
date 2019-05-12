

/datum/economy/bank_accounts
	var/treasury_money = 8000000
	var/list/treasury_logs = list()

	var/council_money = 70000
	var/list/council_logs = list()

	var/hospital_money = 9000
	var/list/hospital_logs = list()

	var/emt_money = 300
	var/list/emt_logs = list()

	var/research_money = 9000
	var/list/research_logs = list()

	var/police_money = 9000
	var/list/police_logs = list()

	var/cargo_money = 9000
	var/list/cargo_logs = list()

// oof struggling businesses rip
	var/bar_money = 200
	var/list/bar_logs = list()

	var/botany_money = 200
	var/list/botany_logs = list()

// Could be used for uh, welfare? ~ Cass
	var/civilian_money = 10000
	var/list/civilian_logs = list()

//#############################################//

	var/path = "data/persistence/banks.sav"


/datum/economy/bank_accounts/proc/save_accounts()
	message_admins("SAVE: Save all department accounts.", 1)
	if(!path)				return 0
	var/savefile/S = new /savefile(path)
	if(!fexists(path))		return 0
	if(!S)					return 0
	S.cd = "/"


	S["treasury_money"]				<< treasury_money
	S["treasury_logs"]				<< treasury_logs

	S["council_money"]				<< council_money
	S["council_logs"]				<< council_logs

	S["hospital_money"]				<< hospital_money
	S["hospital_logs"]				<< hospital_logs

	S["emt_money"]					<< emt_money
	S["emt_logs"]					<< emt_logs

	S["research_money"]				<< research_money
	S["research_logs"]				<< research_logs

	S["police_money"]				<< police_money
	S["police_logs"]				<< police_logs

	S["cargo_money"]				<< cargo_money
	S["cargo_logs"]					<< cargo_logs

	S["bar_money"]					<< bar_money
	S["bar_logs"]					<< bar_logs

	S["botany_money"]				<< botany_money
	S["botany_logs"]				<< botany_logs

	S["civilian_money"]				<< civilian_money
	S["civilian_logs"]				<< civilian_logs

	message_admins("Saved all department accounts.", 1)

/datum/economy/bank_accounts/proc/load_accounts()
	message_admins("BEGIN: Loaded all department accounts.", 1)
	if(!path)				return 0
	if(!fexists(path))		return 0
	var/savefile/S = new /savefile(path)
	if(!S)					return 0
	S.cd = "/"


	S["treasury_money"]				>> treasury_money
	S["treasury_logs"]				>> treasury_logs

	S["council_money"]				>> council_money
	S["council_logs"]				>> council_logs

	S["hospital_money"]				>> hospital_money
	S["hospital_logs"]				>> hospital_logs

	S["emt_money"]					>> emt_money
	S["emt_logs"]					>> emt_logs

	S["research_money"]				>> research_money
	S["research_logs"]				>> research_logs

	S["police_money"]				>> police_money
	S["police_logs"]				>> police_logs

	S["cargo_money"]				>> cargo_money
	S["cargo_logs"]					>> cargo_logs

	S["bar_money"]					>> bar_money
	S["bar_logs"]					>> bar_logs

	S["botany_money"]				>> botany_money
	S["botany_logs"]				>> botany_logs

	S["civilian_money"]				>> civilian_money
	S["civilian_logs"]				>> civilian_logs

	message_admins("Loaded all department accounts.", 1)

/datum/economy/bank_accounts/proc/restore_economy()
	department_accounts["Polluxian Treasury"].money = treasury_money
	department_accounts["Polluxian Treasury"].transaction_log = treasury_logs

	department_accounts["City Council"].money = council_money
	department_accounts["City Council"].transaction_log = council_logs

	department_accounts["Public Healthcare"].money = hospital_money
	department_accounts["Public Healthcare"].transaction_log = hospital_logs

	department_accounts["Emergency and Maintenance"].money = emt_money
	department_accounts["Emergency and Maintenance"].transaction_log = emt_logs

	department_accounts["Research and Science"].money = research_money
	department_accounts["Research and Science"].transaction_log = research_logs

	department_accounts["Police"].money = police_money
	department_accounts["Police"].transaction_log = police_logs

	department_accounts["Cargo"].money = cargo_money
	department_accounts["Cargo"].transaction_log = cargo_logs

	department_accounts["Bar"].money = bar_money
	department_accounts["Bar"].transaction_log = bar_logs

	department_accounts["Botany"].money = botany_money
	department_accounts["Botany"].transaction_log = botany_logs

	department_accounts["Civilian"].money = civilian_money
	department_accounts["Civilian"].transaction_log = civilian_logs

	message_admins("Restored economy.", 1)