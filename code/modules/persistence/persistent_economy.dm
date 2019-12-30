

// all the same, by default, but can be changed in-game.

/datum/economy/bank_accounts
	var/path = "data/persistent/banks.sav"
	var/tax_poor
	var/tax_middle
	var/tax_rich
	var/list/datum/money_account/eco_data
	var/list/datum/money_account/treasury

	//income tax rates
	var/tax_rate_upper = 0.20
	var/tax_rate_middle = 0.20
	var/tax_rate_lower = 0.20

	//sales tax rates
	var/general_sales_tax = 0.10
	var/business_income_tax = 0.10

	var/medical_tax = 0.10
	var/weapons_tax = 0.10
	var/alcoholic_tax = 0.10
	var/tobacco_tax = 0.10
	var/recreational_drug_tax = 0.10
	var/gambling_tax = 0.10

	//contraband // See law/contraband.dm for potential contraband types.
	var/law_CANNABIS = PERMIT_POSSESSION
	var/law_ALCOHOL = PERMIT_SELLING
	var/law_ECSTASY = ILLEGAL
	var/law_PSILOCYBIN = LEGAL
	var/law_CRACK = ILLEGAL
	var/law_COCAINE = ILLEGAL
	var/law_HEROIN = ILLEGAL
	var/law_METH = ILLEGAL
	var/law_NICOTINE = PERMIT_SELLING
	var/law_STIMM = LEGAL
	var/law_CYANIDE = LEGAL
	var/law_LSD = ILLEGAL
	var/law_DMT = ILLEGAL
	var/law_AYAHUASCA = ILLEGAL
	var/law_BATHSALTS = ILLEGAL
	var/law_KROKODIL = ILLEGAL
	var/law_CHLORAL = ILLEGAL

	var/law_GUNS = PERMIT_POSSESSION
	var/law_SMALLKNIVES = LEGAL
	var/law_LARGEKNIVES = PERMIT_POSSESSION
	var/law_EXPLOSIVES = ILLEGAL


	var/voting_age = 13
	var/drinking_age = 18
	var/smoking_age = 18
	var/gambling_age = 18
	var/sentencing_age = 13
	var/synth_vote = TRUE			// Are FBPs allowed to vote?
	var/citizenship_vote = TRUE		// Are starsystem immigrants allowed to vote?
	var/criminal_vote = TRUE		// Can people with criminal records vote? (unimplemented)

/datum/economy/bank_accounts/proc/set_economy()
	if(!department_acc_list)
		return 0

	treasury = station_account
	eco_data = department_acc_list

	for(var/M in department_acc_list)
		all_money_accounts.Add(M)

	for(var/T in station_account)
		all_money_accounts.Add(T)

	//rebuild department accounts

	department_accounts.Cut()

	for(var/datum/money_account/D in department_acc_list)
		department_accounts[D.department] = D

	sanitize_economy()

	message_admins("Set economy.", 1)

	return 1


/datum/economy/bank_accounts/proc/sanitize_economy()
	for(var/datum/money_account/D in department_acc_list)
		D.money = Clamp(D.money, -999999, 999999)

	for(var/datum/money_account/T in station_account)
		T.money = Clamp(T.money, -999999, 999999)


/datum/economy/bank_accounts/proc/save_economy()
//	message_admins("SAVE: Save all department accounts.", 1)
	if(!path)				return 0
	var/savefile/S = new /savefile(path)
	if(!fexists(path))		return 0
	if(!S)					return 0
	S.cd = "/"

	sanitize_economy()

	tax_poor = tax_rate_lower
	tax_middle = tax_rate_middle
	tax_rich = tax_rate_upper

	S["eco_data"] << eco_data
	S["treasury"] << treasury
	S["tax_rate_upper"] << tax_rich
	S["tax_rate_middle"] << tax_middle
	S["tax_rate_lower"] << tax_poor

	S["general_sales_tax"] << general_sales_tax
	S["business_income_tax"] << business_income_tax
	S["medical_tax"] << medical_tax
	S["weapons_tax "] << weapons_tax
	S["alcoholic_tax"] << alcoholic_tax
	S["tobacco_tax"] << tobacco_tax
	S["recreational_drug_tax"] << recreational_drug_tax
	S["gambling_tax"] << gambling_tax
	S["law_CANNABIS"] << law_CANNABIS
	S["law_ALCOHOL"] << law_ALCOHOL
	S["law_ECSTASY"] << law_ECSTASY
	S["law_PSILOCYBIN"] << law_PSILOCYBIN
	S["law_CRACK"] << law_CRACK
	S["law_COCAINE"] << law_COCAINE
	S["law_HEROIN"] << law_HEROIN
	S["law_METH"] << law_METH
	S["law_NICOTINE"] << law_NICOTINE
	S["law_STIMM"] << law_STIMM
	S["law_CYANIDE"] << law_CYANIDE
	S["law_CHLORAL"] << law_CHLORAL

	S["law_GUNS"] << law_GUNS
	S["law_SMALLKNIVES"] << law_SMALLKNIVES
	S["law_LARGEKNIVES"] << law_LARGEKNIVES
	S["law_EXPLOSIVES"] << law_EXPLOSIVES


	S["voting_age"] << voting_age
	S["drinking_age"] << drinking_age
	S["smoking_age"] << smoking_age
	S["gambling_age"] << gambling_age
	S["synth_vote"] << synth_vote
	S["citizenship_vote "] << citizenship_vote
	S["criminal_vote"] << criminal_vote

	message_admins("Saved all department accounts.", 1)

/datum/economy/bank_accounts/proc/load_accounts()
//	message_admins("BEGIN: Loaded all department accounts.", 1)
	if(!path)				return 0
	if(!fexists(path))
		save_economy()
		return 0
	var/savefile/S = new /savefile(path)
	if(!S)					return 0
	S.cd = "/"


	S["eco_data"] >> eco_data
	S["treasury"] >> treasury
	S["tax_rate_upper"] >> tax_rich
	S["tax_rate_middle"] >> tax_middle
	S["tax_rate_lower"] >> tax_poor


	S["general_sales_tax"] >> general_sales_tax
	S["business_income_tax"] >> business_income_tax
	S["medical_tax"] >> medical_tax
	S["weapons_tax "] >> weapons_tax
	S["alcoholic_tax"] >> alcoholic_tax
	S["tobacco_tax"] >> tobacco_tax
	S["recreational_drug_tax"] >> recreational_drug_tax
	S["gambling_tax"] >> gambling_tax
	S["law_CANNABIS"] >> law_CANNABIS
	S["law_ALCOHOL"] >> law_ALCOHOL
	S["law_ECSTASY"] >> law_ECSTASY
	S["law_PSILOCYBIN"] >> law_PSILOCYBIN
	S["law_CRACK"] >> law_CRACK
	S["law_COCAINE"] >> law_COCAINE
	S["law_HEROIN"] >> law_HEROIN
	S["law_METH"] >> law_METH
	S["law_NICOTINE"] >> law_NICOTINE
	S["law_STIMM"] >> law_STIMM
	S["law_CYANIDE"] >> law_CYANIDE
	S["law_CHLORAL"] >> law_CHLORAL

	S["law_GUNS"] >> law_GUNS
	S["law_SMALLKNIVES"] >> law_SMALLKNIVES
	S["law_LARGEKNIVES"] >> law_LARGEKNIVES
	S["law_EXPLOSIVES"] >> law_EXPLOSIVES


	S["voting_age"] >> voting_age
	S["drinking_age"] >> drinking_age
	S["smoking_age"] >> smoking_age
	S["gambling_age"] >> gambling_age
	S["synth_vote"] >> synth_vote
	S["citizenship_vote "] >> citizenship_vote
	S["criminal_vote"] >> criminal_vote

	sanitize_economy()

	for (var/datum/money_account/T in all_money_accounts)
		if(T.department)
			all_money_accounts -= T

	department_acc_list = eco_data

	station_account = treasury

	all_money_accounts.Add(department_acc_list)

	tax_rate_lower = tax_poor
	tax_rate_middle = tax_middle
	tax_rate_upper = tax_rich

	//rebuild department accounts
	department_accounts.Cut()

	for(var/datum/money_account/D in department_acc_list)
		department_accounts[D.department] = D

	link_economy_accounts()

	message_admins("Loaded all department accounts.", 1)
