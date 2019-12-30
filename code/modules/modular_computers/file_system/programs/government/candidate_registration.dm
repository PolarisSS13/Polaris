/datum/computer_file/program/candidate_registration
	filename = "candidate_reg"
	filedesc = "Presidential Candidate Registration"
	extended_desc = "Allows you to register as a candidate for the presidential elections."
	requires_ntnet = 1
	size = 3
	nanomodule_path = /datum/nano_module/program/candidate_registration/

/datum/nano_module/program/candidate_registration/
	name = "Presidential Candidate Registration"

	var/full_name
	var/unique_id
	var/pitch
	var/slogan
	var/index = 1
	var/page_msg = " "
	var/reg_error = "*Fields marked with an asterisk are required."

	var/datum/president_candidate/registered

/datum/nano_module/program/candidate_registration/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/list/data = list()
	if(program)
		data = program.get_header_data()

	var/can_use

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		full_name =	H.real_name
		unique_id = H.client.prefs.unique_id

		can_use = 1

	if(!can_use)
		index = 0


	if(index == 0)
		page_msg = "You are not authorized to use this system."

	if(index == 1)
		page_msg = "Welcome to [name]. You may apply as a candidate or login to your \
		candidate account. <br>What would you like to do today?"

	if(index == 2)
		page_msg = "Please enter your pitch and slogan. Please note that registering as a candidate costs <b>3,500 credits.</b> \
		Keep your ID on hand to scan for payment."

	if(index == 3)
		page_msg = "Thank you for using [name] to register as a political candidate. Your account has been charged and your candidacy \
		is effective immediately."

	if(index == 4)
		if(registered)
			pitch = registered.pitch
			slogan = registered.slogan
		page_msg = "This is your control panel. You can edit your details, as well as withdraw from candidacy if you wish."


	if(index == 5)
		page_msg = "No candidate data found, please register for candidacy before using the control panel."


	if(index == 6)
		page_msg = "No bank details found, either you are missing an ID card with an associated or you lack sufficient funds in your account. \
		Please try again later."


	if(index == 7)
		page_msg = "It is only possible to register an account during election registration days. Sorry for the inconvienience."

	data["full_name"] = full_name
	data["unique_id"] = unique_id
	data["pitch"] = pitch
	data["slogan"] = slogan
	data["index"] = index
	data["page_msg"] = page_msg
	data["reg_error"] = reg_error

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "candidate_registration.tmpl", "Presidential Candidate Registration", 690, 680, state = state)
		if(program.update_layout())
			ui.auto_update_layout = 1
		ui.set_auto_update(1)
		ui.set_initial_data(data)
		ui.open()


/datum/nano_module/program/candidate_registration/Topic(href, href_list)
	if(..()) return 1

	if(href_list["back"])
		. = 1
		index = 1

		pitch = null
		slogan = null

	if(href_list["edit_candidacy"])
		. = 1

		registered = null

		for(var/datum/president_candidate/P in SSelections.political_candidates)
			if(unique_id == P.unique_id)
				registered = P

		if(!registered)
			index = 5
			return

		index = 4

	if(href_list["withdraw_candidacy"])
		. = 1
		if(!registered in SSelections.political_candidates)
			reg_error = "You're not a current candidate!"

		for(var/datum/president_candidate/P in SSelections.political_candidates)
			if(unique_id == P.unique_id)
				registered = P

		if("No" == alert("Are you sure you wish to withdraw from the election? You will not be refunded the cost.", "Create Candidacy", "No", "Yes"))
			return

		if(registered in SSelections.political_candidates)
			SSelections.political_candidates -= registered
			SSelections.former_candidates += registered

		registered.ckeys_voted = null

		index = 1

	if(href_list["submit_register"])
		. = 1

		if(!SSelections.is_registration_days(get_game_day()))
			reg_error = "It is not possible to register a new candidate account during non-registration days."
			return


		if(!pitch)
			reg_error = "A pitch is required!"
			return

		if(!slogan)
			reg_error = "A slogan is required!"
			return

		if(!unique_id  || !full_name)
			reg_error = "Unknown error! You shouldn't be seeing this, contact the network administrator!"
			return

		for(var/datum/president_candidate/P in SSelections.political_candidates)
			if(unique_id == P.unique_id)
				reg_error = "You already are registered as a candidate!"
				return

		if(unique_id == SSelections.current_president.unique_id)
			reg_error = "You already are registered as a candidate!"
			return

		if("No" == alert("Enter into the election candidate pool for 3,500 credits?", "Create Candidacy", "No", "Yes"))
			return

		var/mob/living/carbon/human/H = usr

		var/obj/item/weapon/card/id/I = H.GetIdCard()

		if(!istype(I) || !I.registered_name)
			index = 6
			return

		if(!charge_to_account(I.associated_account_number, "Candidate Registrar", "Candidate registration", "Electoral Registration", -3500))
			index = 6
			return

		department_accounts["[station_name()] Funds"].money += 3500

		var/datum/president_candidate/associated_candidacy

		//find if they actually have an account already from previous election. Recycling!
		for(var/datum/president_candidate/A in SSelections.former_candidates)
			if(unique_id == A.unique_id)
				associated_candidacy = A
				SSelections.former_candidates -= A

		//or check if they were a president, we can reuse this.
		for(var/datum/president_candidate/A in SSelections.former_presidents)
			if(unique_id == A.unique_id)
				associated_candidacy = A
				SSelections.former_candidates -= A

		//if not, start one fresh
		if(!associated_candidacy)
			associated_candidacy = new /datum/president_candidate

		//transfer new data to it.
		associated_candidacy.name = full_name
		associated_candidacy.ckey = usr.client.ckey
		associated_candidacy.unique_id = unique_id
		associated_candidacy.pitch = pitch
		associated_candidacy.slogan = slogan

		//ensure nothing vote-wise is transferring.
		associated_candidacy.ckeys_voted = list()
		associated_candidacy.no_confidence_votes = list()

		SSelections.political_candidates += associated_candidacy
		registered = associated_candidacy
		index = 3

		pitch = null
		slogan = null


	if(href_list["register_new"])
		. = 1
		if(!SSelections.is_registration_days(get_game_day()))
			index = 7
			return
		index = 2


	if(href_list["enter_pitch"])
		. = 1

		var/pitch_e = sanitize(copytext(input(usr, "Enter your pitch (300 chars max)", "Candidacy Manager", pitch)  as message,1,300))
		if(!pitch_e)
			return
		pitch = pitch_e

	if(href_list["enter_slogan"])
		. = 1
		var/slogan_e = sanitize(copytext(input(usr, "Enter your slogan (50 chars max)", "Candidacy Manager", slogan)  as text,1,50))
		if(!slogan_e)
			return
		slogan = slogan_e


	if(href_list["update_pitch"])
		. = 1
		if(!registered)
			return

		var/pitch_e = sanitize(copytext(input(usr, "Enter your pitch (300 chars max)", "Candidacy Manager", pitch)  as message,1,300))
		if(!pitch_e)
			return
		registered.pitch = pitch_e

	if(href_list["update_slogan"])
		. = 1
		if(!registered)
			return

		var/slogan_e = sanitize(copytext(input(usr, "Enter your slogan (50 chars max)", "Candidacy Manager", slogan)  as text,1,50))
		if(!slogan_e)
			return
		registered.slogan = slogan_e