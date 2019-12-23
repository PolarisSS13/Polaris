/datum/computer_file/program/presidential_portal
	filename = "president_portal"
	filedesc = "Presidential Portal"
	extended_desc = "The control panel to the entire colony. Use with care. Restricted access."
	requires_ntnet = 1
	size = 3
	nanomodule_path = /datum/nano_module/program/presidential_portal/
	required_access = access_president

/datum/nano_module/program/presidential_portal/
	name = "Presidential Portal"

	var/index
	var/page_msg

	var/full_name
	var/unique_id
	var/ckey

	var/error_msg = " "

	var/working_tax
	var/middle_tax
	var/upper_tax



/datum/nano_module/program/presidential_portal/proc/tax_range(num)
	switch(num)
		if(0 to 80)
			return TRUE

	return FALSE

/datum/nano_module/program/presidential_portal/proc/age_range(num)
	switch(num)
		if(13 to 25)
			return TRUE

	return FALSE

/datum/nano_module/program/presidential_portal/proc/clear_data()
	error_msg = " "

/datum/nano_module/program/presidential_portal/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/list/data = list()
	if(program)
		data = program.get_header_data()

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		full_name =	H.real_name
		unique_id = H.client.prefs.unique_id
		ckey = H.ckey
		if(!index)
			index = 1

	else
		index = 0

	if(index == 0)
		page_msg = "You are not authorized to use this system."

	else if(index == 1) // Main Portal Page
		page_msg = "Welcome to the Presidential Portal, [full_name].<br>\
		Your general contact email is president@nanotrasen.gov.nt. This will be used for official corrospondence.<br><br>\
		Here you can control aspects of law, colony life, and taxes and also keep in contact with officials and the general public. \
		If you have any questions or concerns do not hesistate to contact NT directorate."

	else if(index == 2) // Tax Adjustment Page
		page_msg = "There are three economic groups:<p> \
		<b>Working Class:</b> The majority and main demographic group of any colony. Low income.<br>\
		<b>Middle Class:</b> The second biggest and moderately earning group of the colony.<br> \
		<b>Upper Class:</b> The smallest, but highest earning economic class.<br> \
		<br> \
		Choose your taxes wisely, as this will have a huge effect on earnings for each group of people."

	else if(index == 3) // Item Tax Page
		page_msg = "You can set the general taxes of each type of item that exists on the colony."


	else if(index == 4) // Contraband Page
		page_msg = "There are a few present items in the colony you can restrict access to legally. Contraband comes in five classifications:<br><br>"
		page_msg += "<b>Legal:</b> Use and possession of this item is not limited by law and has no control by the government. <br>"
		page_msg += "<b>Permit Possession:</b> A permit required for creation, possession and selling. <br>"
		page_msg += "<b>Permit Selling:</b> A permit is needed to sell. Possession and creation is acceptable. <br>"
		page_msg += "<b>Professional Use:</b> Only public and authorized industries can use this in a professional setting needed by work. No personal use. <br>"
		page_msg += "<b>Illegal:</b> Illegal for all institutions and individuals to use. <br>"


	else if(index == 5) // Contraband Page
		if(SSelections.current_president)
			page_msg = "The colony's current president is [SSelections.current_president.name]. Once resigned, this cannot be reversed."
			if(SSelections.vice_president)
				page_msg += " If [SSelections.current_president.name] resigns, vice president [SSelections.vice_president.name] will become the current president."
			else
				page_msg += " If [SSelections.current_president.name] resigns, the colony will be handed over to NanoTrasen officials as there is no vice president."
		else
			page_msg = "Currently, there is no president. NanoTrasen officials handle this colony."


	else if(index == 6) // Voting Eligibility Page
		page_msg = "Here, you can change the voting eligibility of groups in the colony. Beware, this can be quite controversial."


	if(index == -1)
		page_msg = "This isn't a thing yet, sorry."

	data["index"] = index
	data["page_msg"] = page_msg
	data["full_name"] = full_name
	data["unique_id"] = unique_id
	data["error_msg"] = error_msg

	var/wc = (persistent_economy.tax_rate_lower * 100)
	var/mc = (persistent_economy.tax_rate_middle * 100)
	var/uc = (persistent_economy.tax_rate_upper * 100)

	//current president stuff
	data["current_president"] = SSelections.current_president.name
	if(SSelections.vice_president)
		data["vice_president"] = SSelections.vice_president.name

	//classes
	data["working_tax"] = wc
	data["middle_tax"] = mc
	data["upper_tax"] = uc

	//statuses
	data["cannabis_status"] = persistent_economy.law_CANNABIS
	data["alcohol_status"] = persistent_economy.law_ALCOHOL
	data["ecstasy_status"] = persistent_economy.law_ECSTASY
	data["psilocybin_status"] = persistent_economy.law_PSILOCYBIN
	data["crack_status"] = persistent_economy.law_CRACK
	data["cocaine_status"] = persistent_economy.law_COCAINE
	data["heroin_status"] = persistent_economy.law_HEROIN
	data["meth_status"] = persistent_economy.law_METH
	data["nicotine_status"] = persistent_economy.law_NICOTINE
	data["stimm_status"] = persistent_economy.law_STIMM
	data["cyanide_status"] = persistent_economy.law_CYANIDE
	data["chloral_status"] = persistent_economy.law_CHLORAL

	data["guns_status"] = persistent_economy.law_GUNS
	data["smallknives_status"] = persistent_economy.law_SMALLKNIVES
	data["largeknives_status"] = persistent_economy.law_LARGEKNIVES
	data["explosives_status"] = persistent_economy.law_EXPLOSIVES

	//taxes
	data["medical_tax"] = persistent_economy.medical_tax * 100
	data["weapons_tax"] = persistent_economy.weapons_tax * 100
	data["alcoholic_tax"] = persistent_economy.alcoholic_tax * 100
	data["tobacco_tax"] = persistent_economy.tobacco_tax * 100
	data["recreational_drug_tax"] = persistent_economy.recreational_drug_tax * 100
	data["gambling_tax"] = persistent_economy.gambling_tax * 100

	//legal statuses
	data["voting_age"] = persistent_economy.voting_age
	data["drinking_age"] = persistent_economy.drinking_age
	data["smoking_age"] = persistent_economy.smoking_age
	data["gambling_age"] = persistent_economy.gambling_age
	data["sentencing_age"] = persistent_economy.sentencing_age
	data["synth_vote"] = "[persistent_economy.synth_vote ? "Can Vote" : "Cannot Vote"]"
	data["citizenship_vote"] = "[persistent_economy.citizenship_vote ? "Can Vote" : "Cannot Vote"]"
	data["criminal_vote"] = "[persistent_economy.criminal_vote ? "Can Vote" : "Cannot Vote"]"

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "presidential_portal.tmpl", "Presidential Candidate Registration", 690, 680, state = state)
		if(program.update_layout())
			ui.auto_update_layout = 1
		ui.set_auto_update(1)
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/presidential_portal/Topic(href, href_list)
	if(..()) return 1

	if(href_list["back"])
		. = 1
		clear_data()
		index = 1

	if(href_list["notyet"])
		. = 1
		index = -1

	if(href_list["taxes"])
		. = 1
		index = 2


	if(href_list["adjust_wc_taxes"])
		. = 1
		working_tax = persistent_economy.tax_rate_lower * 100


		working_tax = input(usr, "Please input the new tax rate for working class citizens. (Min 0% - Max 80%)", "Taxes for Working Class", working_tax) as num|null
		working_tax = sanitize_integer(working_tax, 0, 100, initial(working_tax))

		if(!tax_range(working_tax))
			error_msg = "This tax range is incorrect. You must enter a decimal between 1 and 80."
			return

		persistent_economy.tax_rate_lower = working_tax / 100

	if(href_list["adjust_mc_taxes"])
		. = 1

		middle_tax = persistent_economy.tax_rate_middle * 100


		middle_tax = input(usr, "Please input the new tax rate for middle class citizens. (Min 0% - Max 80%)", "Taxes for Middle Class", middle_tax) as num|null
		middle_tax = sanitize_integer(middle_tax, 0, 100, initial(middle_tax))


		if(!tax_range(middle_tax))
			error_msg = "This tax range is incorrect. You must enter a decimal between 1 and 80."
			return

		persistent_economy.tax_rate_middle = middle_tax / 100


	if(href_list["adjust_uc_taxes"])
		. = 1
		upper_tax = persistent_economy.tax_rate_upper * 100

		upper_tax = input(usr, "Please input the new tax rate for upper class citizens. (Min 0% - Max 80%)", "Taxes for Upper Class", upper_tax) as num|null

		if(!tax_range(upper_tax))
			error_msg = "This tax range is incorrect. You must enter a decimal between 0 and 80."
			return

		persistent_economy.tax_rate_upper = upper_tax / 100

	if(href_list["item_tax"])
		. = 1
		index = 3

	if(href_list["contraband"])
		. = 1
		index = 4

	if(href_list["adjust_main_taxes"])
		. = 1

		var/tax_group = input(usr, "Please select which tax group you'd like to edit.", "Select Tax Group") as null|anything in tax_groups
		if(!tax_group) return

		var/new_tax = input(usr, "Please input the new tax rate for \"[tax_group]\". (Min 0% - Max 80%)", "[tax_group]") as num|null

		if(!tax_range(new_tax))
			error_msg = "This tax range is incorrect. You must enter a decimal between 0 and 80."
			return

		new_tax = new_tax / 100

		switch(tax_group)
			if("General Sales Tax")
				persistent_economy.general_sales_tax = new_tax
				return

			if("Business Income Tax")
				persistent_economy.business_income_tax = new_tax
				return

			if("Medical Tax")
				persistent_economy.medical_tax = new_tax
				return

			if("Weapons Tax")
				persistent_economy.weapons_tax = new_tax
				return

			if("Alcoholic Tax")
				persistent_economy.alcoholic_tax = new_tax
				return

			if("Tobacco Tax")
				persistent_economy.tobacco_tax = new_tax
				return

			if("Recreational Drug Tax")
				persistent_economy.recreational_drug_tax = new_tax
				return

			if("Gambling Tax")
				persistent_economy.gambling_tax = new_tax
				return


	if(href_list["contraband_edit"])
		. = 1

		var/contraband = input(usr, "Please select which contraband classification you'd like to edit.", "Select Contraband") as null|anything in potential_contraband
		if(!contraband) return

		var/cont_status = input(usr, "What legal classification would you like to set [contraband] to?", "Select Contraband Classification") as null|anything in contraband_classifications
		if(!cont_status) return

		switch(contraband)
			if("Cannabis")
				persistent_economy.law_CANNABIS = cont_status
				return

			if("Alcohol")
				persistent_economy.law_ALCOHOL = cont_status
				return

			if("Ecstasy")
				persistent_economy.law_ECSTASY = cont_status
				return

			if("Psilocybin")
				persistent_economy.law_PSILOCYBIN = cont_status
				return

			if("Crack")
				persistent_economy.law_CRACK = cont_status
				return

			if("Cocaine")
				persistent_economy.law_COCAINE = cont_status
				return

			if("Heroin")
				persistent_economy.law_HEROIN = cont_status
				return

			if("Meth")
				persistent_economy.law_METH = cont_status
				return

			if("Nicotine")
				persistent_economy.law_NICOTINE = cont_status
				return

			if("Stimm")
				persistent_economy.law_STIMM = cont_status
				return

			if("Cyanide")
				persistent_economy.law_CYANIDE = cont_status
				return

			if("Chloral Hydrate")
				persistent_economy.law_CHLORAL = cont_status
				return

			if("Guns")
				persistent_economy.law_GUNS = cont_status
				return

			if("Short Knives")
				persistent_economy.law_SMALLKNIVES = cont_status
				return

			if("Long Knives")
				persistent_economy.law_LARGEKNIVES = cont_status
				return

			if("Explosives")
				persistent_economy.law_EXPLOSIVES = cont_status
				return


	if(href_list["resign"])
		. = 1

		index = 5


	if(href_list["resign_president"])
		. = 1

		if("No" == alert("Are you sure you would like to resign as president?", "Resign as President", "No", "Yes"))
			return

		if("No" == alert("Just making sure, do you want to resign as president? This CANNOT be undone.", "Resign as President", "No", "Yes"))
			return

		SSelections.clear_president()
		index = 1

	if(href_list["rights_panel"])
		. = 1

		index = 6

	if(href_list["drinking_age"])
		. = 1

		var/age = input(usr, "Please select the minimum drinking age. Min: 13. Max: 25.", "Drinking Age") as num|null
		if(!age)
			error_msg = "You must enter an age."
			return

		if(!age_range(age))
			error_msg = "This age is incorrect. You must enter a decimal between 13 and 25."
			return

		persistent_economy.drinking_age = age


	if(href_list["smoking_age"])
		. = 1

		var/age = input(usr, "Please select the minimum smoking age. Min: 13. Max: 25.", "Smoking Age") as num|null
		if(!age)
			error_msg = "You must enter an age."
			return

		if(!age_range(age))
			error_msg = "This age is incorrect. You must enter a decimal between 13 and 25."
			return

		persistent_economy.smoking_age = age

	if(href_list["gambling_age"])
		. = 1

		var/age = input(usr, "Please select the minimum gambling age. Min: 13. Max: 25.", "Gambling Age") as num|null
		if(!age)
			error_msg = "You must enter an age."
			return

		if(!age_range(age))
			error_msg = "This age is incorrect. You must enter a decimal between 13 and 25."
			return

		persistent_economy.gambling_age = age

	if(href_list["voting_age"])
		. = 1

		var/age = input(usr, "Please select the minimum voting age. Min: 13. Max: 25.", "Voting Age") as num|null
		age = sanitize_integer(persistent_economy.voting_age, 0, 100, 25)
		if(!age)
			error_msg = "You must enter an age."
			return

		if(!age_range(age))
			error_msg = "This age is incorrect. You must enter a decimal between 13 and 25."
			return

		persistent_economy.voting_age = age

	if(href_list["sentencing_age"])
		. = 1

		var/age = input(usr, "Please select the minimum age for criminal sentencing. Min: 13. Max: 25.", "Criminal Sentencing Age") as num|null
		age = sanitize_integer(persistent_economy.sentencing_age, 0, 100, 25)
		if(!age)
			error_msg = "You must enter an age."
			return

		if(!age_range(age))
			error_msg = "This age is incorrect. You must enter a decimal between 13 and 25."
			return

		persistent_economy.sentencing_age = age

	if(href_list["synth_vote"])
		. = 1

		var/vote_status = input(usr, "Please select a voting status for synths.", "Synthetic Vote") as null|anything in list("Able to vote", "Disallowed from voting")
		if(vote_status == "Able to vote")
			persistent_economy.synth_vote = TRUE
		else
			persistent_economy.synth_vote = FALSE

	if(href_list["citizenship_vote"])
		. = 1

		var/vote_status = input(usr, "Please select a voting status for non-Polluxian citizens.", "Citizenship Vote") as null|anything in list("Able to vote", "Disallowed from voting")
		if(vote_status == "Able to vote")
			persistent_economy.citizenship_vote = TRUE
		else
			persistent_economy.citizenship_vote = FALSE

	if(href_list["criminal_vote"])
		. = 1

		var/vote_status = input(usr, "Please select a voting status for people with a criminal record.", "Criminal Vote") as null|anything in list("Able to vote", "Disallowed from voting")
		if(vote_status == "Able to vote")
			persistent_economy.criminal_vote = TRUE
		else
			persistent_economy.criminal_vote = FALSE
