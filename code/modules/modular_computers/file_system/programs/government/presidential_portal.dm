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
		if(1 to 80)
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

	if(index == -1)
		page_msg = "This isn't a thing yet, sorry."

	data["index"] = index
	data["page_msg"] = page_msg
	data["full_name"] = full_name
	data["unique_id"] = unique_id
	data["error_msg"] = error_msg

	var/wc = (tax_rate_lower * 100)
	var/mc = (tax_rate_middle * 100)
	var/uc = (tax_rate_upper * 100)

	data["working_tax"] = wc
	data["middle_tax"] = mc
	data["upper_tax"] = uc

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
		working_tax = tax_rate_lower * 100


		working_tax = input(usr, "Please input the new tax rate for working class citizens. (Min 0% - Max 80%)", "Taxes for Working Class", working_tax) as num|null
		working_tax = sanitize_integer(working_tax, 0, 100, initial(working_tax))
		if(!working_tax)
			error_msg = "You must enter a tax range."
			return

		if(!tax_range(working_tax))
			error_msg = "This tax range is incorrect. You must enter a decimal between 1 and 80."
			return

		tax_rate_lower = working_tax / 100

	if(href_list["adjust_mc_taxes"])
		. = 1

		middle_tax = tax_rate_middle * 100


		middle_tax = input(usr, "Please input the new tax rate for middle class citizens. (Min 0% - Max 80%)", "Taxes for Middle Class", middle_tax) as num|null
		middle_tax = sanitize_integer(middle_tax, 0, 100, initial(middle_tax))
		if(!middle_tax)
			error_msg = "You must enter a tax range."
			return

		if(!tax_range(middle_tax))
			error_msg = "This tax range is incorrect. You must enter a decimal between 1 and 80."
			return

		tax_rate_middle = middle_tax / 100


	if(href_list["adjust_uc_taxes"])
		. = 1
		upper_tax = tax_rate_upper * 100

		upper_tax = input(usr, "Please input the new tax rate for upper class citizens. (Min 0% - Max 80%)", "Taxes for Upper Class", upper_tax) as num|null
		upper_tax = sanitize_integer(upper_tax, 0, 100, initial(upper_tax))
		if(!upper_tax)
			error_msg = "You must enter a tax range."
			return

		if(!tax_range(upper_tax))
			error_msg = "This tax range is incorrect. You must enter a decimal between 1 and 80."
			return

		tax_rate_upper = upper_tax / 100




