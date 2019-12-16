/**************************************************

	This file will contain a ton of comments
	to aid in modifying it in the future, once
	businesses are fully fleshed out. DO NOT
	remove any comments lest our posterity be
	forced to reverse engineer this word wall of
	confounding variables.

**************************************************/

/datum/computer_file/program/business_manager
	filename = "bizmgmt"
	filedesc = "Business Management Utility"
	extended_desc = "This program allows you to register a new business or manage an existing one."
	requires_ntnet = 1
	size = 8
	nanomodule_path = /datum/nano_module/program/business_manager/

/datum/nano_module/program/business_manager
	name = "Business Management Utility"
	var/index = 0
	var/page_msg

/**********************

	User Variables

**********************/

	var/user_uid
	var/user_name
	var/can_login

/*****************************

	Registration Variables

*****************************/

	var/b_name = " "
	var/b_slogan = " "
	var/b_desc = " "
	var/b_category = " "

	var/acc_no
	var/acc_pin

	var/business_pass = " "
	var/reg_error = "*Fields marked with an asterisk are required."

	var/datum/business/current_business

	var/sort_by = "empl_ID"

/datum/nano_module/program/business_manager/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/list/data = list()
	if(program)
		data = program.get_header_data()

	data["index"] = index
	data["page_msg"] = page_msg

/************************************************
	Login is handled below. If the user does not
 	have an ID equipped or is not a human, they
 	will be logged in as 'Anonymous' and will not
 	be able to access business management functions
 	or register a business.
 ***********************************************/

	var/obj/item/weapon/card/id/I = user.GetIdCard()

	if(!ishuman(user) || !istype(I) || !I.registered_name)
		data["authuser"] = "Anonymous"
		can_login = 0
	else
		var/mob/living/carbon/human/H = user
		data["authuser"] = "[I.registered_name] - [I.assignment ? I.assignment : "(Unknown)"]"
		can_login = 1
		user_name = I.registered_name
		user_uid = H.client.prefs.unique_id
		data["user_uid"] = user_uid

	if(current_business)
		data["current_business"] = current_business
		data["current_business_name"] = current_business.name

	if(can_login)
		data["unique_id"] = user_uid
		acc_no = I.associated_account_number
		acc_pin = I.associated_pin_number

/************************

	Registration Data

************************/

	data["b_name"] = b_name
	data["b_slogan"] = b_slogan
	data["b_desc"] = b_desc
	data["b_category"] = b_category
	data["acc_no"] = acc_no
	data["acc_pin"] = acc_pin
	data["reg_error"] = reg_error
	data["business_pass"] = business_pass

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "business_manager.tmpl", "Business Management Utility", 690, 680, state = state)
		if(program.update_layout())
			ui.auto_update_layout = 1
		ui.set_auto_update(1)
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/business_manager/proc/reset_fields()
	b_name = initial(b_name)
	b_desc = initial(b_desc)
	b_slogan = initial(b_slogan)
	b_category = initial(b_category)
	business_pass = initial(business_pass)

/datum/nano_module/program/business_manager/Topic(href, href_list)
	if(..()) return 1

	if(href_list["return_to_main_menu"])
		. = 1
		index = 0
		reset_fields()

	if(href_list["return_to_business_page"])
		. = 1
		index = 5

/*******************

	Registration

*******************/

	if(href_list["login"])
		. = 1
		index = 4
		reset_fields()

	if(href_list["register_business"])
		. = 1
		if(!ishuman(usr) || !can_login)
			index = 2
		else
			index = 1
			page_msg = "You are not authorized to access this page."

	if(href_list["view_businesses"])
		. = 1
		get_all_businesses(usr)

	if(href_list["set_business_name"])
		. = 1
		var/biz_name = sanitize(copytext(input(usr, "Enter your business name (40 chars max)", "Business Management Utility", null)  as text,1,40))
		if(!biz_name)
			return
		b_name = biz_name

	if(href_list["edit_business_name"])
		. = 1

		var/biz_name = sanitize(copytext(input(usr, "Enter your business name (40 chars max)", "Business Management Utility", null)  as text,1,40))
		if(!biz_name)
			return
		b_name = biz_name

	if(href_list["set_business_slogan"])
		. = 1
		b_slogan = sanitize(copytext(input(usr, "Enter your business slogan (80 chars max)", "Business Management Utility", null)  as text,1,80))
		if(!b_slogan)
			b_slogan = initial(b_slogan)
			return

	if(href_list["set_business_desc"])
		. = 1
		b_desc = sanitize(copytext(input(usr, "Enter your business description (200 chars max)", "Business Management Utility", null)  as message,1,200))
		if(!b_desc)
			return

	if(href_list["set_business_category"])
		. = 1
		b_category = sanitize(copytext(input(usr, "Enter your business category (40 chars max)", "Business Management Utility", null)  as message,1,40))
		if(!b_category)
			return

	if(href_list["set_business_pass"])
		. = 1
		business_pass = sanitize(copytext(input(usr, "Enter the password for your business account (15 characters max)", "Business Management Utility", null)  as text,1,15))
		if(!business_pass)
			return

	if(href_list["submit_new_business"])
		. = 1
		if(b_name == initial(b_name) || b_name == null)
			reg_error = "You need to enter a business name!"
			return

		if(check_business_name_exist(b_name))
			reg_error = "This business name already exists. Please choose another."
			return

		if(b_slogan == initial(b_slogan) || b_slogan == null)
			reg_error = "A business slogan is required!"
			return

		if(b_desc == initial(b_desc) || b_desc == null)
			reg_error = "The business description cannot be left blank!"
			return

		if(business_pass == initial(business_pass) || business_pass == null)
			reg_error = "A password is required!"
			return

		for(var/datum/business/B in businesses)
			if(B.name == b_name)
				reg_error = "The name \"[b_name]\" has already been registered."
				break
				return


		if("No" == alert("Register [b_name] for 3,500 credits?", "Register Business", "No", "Yes"))
			return

		if(!attempt_account_access(acc_no, acc_pin, 2) || !charge_to_account(acc_no, "Business Registrar", "[b_name] registration", "Polluxian Business Registration", -3500))
			reg_error = "There was an error charging your bank account. Please contact your bank's administrator."
			return
		else

			var/datum/computer_file/data/email_account/EA = new/datum/computer_file/data/email_account()
			EA.password = business_pass
			EA.login = "[replacetext(lowertext(b_name), " ", "-")]@businesses.nanotrasen.gov"

			var/datum/business/B = create_new_business(b_name, b_desc, b_slogan, business_pass, b_category, user_uid, user_name)
			log_and_message_admins("New Business registered: [b_name].") //To prevent rule breaking names

			B.email = EA.login

			index = 2
			page_msg = "Business Registered <br><br>\
			<b>Business Owner:</b> [B.owner_name]<p>\
			<b>Business Name:</b> [B.name]<p>\
			<b>Business Unique ID:</b> [B.uid]<p>\
			<b>Business Category:</b> [B.category]<p>\
			<b>Business Descripton:</b> [B.description]<p>\
			<b>Business Slogan:</b> [B.slogan]<p>\
			<b>Business Email:</b> [B.email]<p>\
			<b>Business Password:</b> [business_pass]<p>\
			<br>\
			Please note that your business account and email passwords are linked."

			create_employee(user_name, usr.client.prefs.unique_id, "CEO", B)
			reset_fields()

/*****************************

	Login to Business Account

*****************************/

	if(href_list["business_logout"])
		reset_fields()
		current_business = null
		page_msg = "Successfully logged out!"
		index = 2

	if(href_list["business_login"])
		. = 1

		if(b_name == initial(b_name))
			reg_error = "You need to enter a business name!"
			return

		if(!check_business_name_exist(b_name))
			reg_error = "This business does not exist."
			return

		var/datum/business/B

		B = get_business_by_name(b_name)

		if(!B)
			page_msg = "Unable to login to this business."
			return

		if(try_auth_business(B, b_name, business_pass))
			page_msg = "Login successful!"
			current_business = B
			index = 5
		else
			page_msg = "Login failed. Please check the password or business name."

/***********************

	Business Settings

************************/

	if(href_list["business_settings"])
		. = 1
		index = 6

	if(href_list["rename_business"])
		. = 1
		var/new_name
		new_name = sanitize(copytext(input(usr, "Enter a new business name.", "Business Name", current_business.name)  as text,1,40))
		if(!new_name)
			return

		if("No" == alert("Rebrand [current_business.name] for 500 credits?", "Rebrand Business", "No", "Yes"))
			return

		if(!attempt_account_access(acc_no, acc_pin, 2) || !charge_to_account(acc_no, "Business Registrar", "[current_business.name] Rebranding", "Polluxian Business Registration", -500))
			reg_error = "There was an error charging your bank account. Please contact your bank's administrator."
			return

		else if(current_business)
			log_and_message_admins("The [current_business.name] business has been renamed to [new_name].") // To prevent names that break the rules
			current_business.name = new_name

	if(href_list["set_primary_color"])
		. = 1
		var/prim_color
		prim_color = input(usr,"Choose Color") as color
		if(!prim_color)
			return

		current_business.primary_color = prim_color


	if(href_list["set_secondary_color"])
		. = 1
		var/sec_color
		sec_color = input(usr,"Choose Color") as color
		if(!sec_color)
			return

		current_business.secondary_color = sec_color

	if(href_list["edit_business_slogan"])
		. = 1
		var/new_slogan
		new_slogan = sanitize(copytext(input(usr, "Enter a new business slogan.", "Business Slogan", current_business.slogan)  as text,1,80))
		if(!new_slogan)
			return
		if(current_business)
			current_business.slogan = new_slogan

	if(href_list["edit_business_desc"])
		. = 1
		var/new_desc
		new_desc = sanitize(copytext(input(usr, "Enter a new business description.", "Business Description", current_business.description)  as text,1,200))
		if(!new_desc)
			return
		if(current_business)
			current_business.description = new_desc

	if(href_list["edit_business_category"])
		. = 1
		var/new_category
		new_category = sanitize(copytext(input(usr, "Enter a new business category.", "Business Category", current_business.category)  as text,1,40))
		if(!new_category)
			return
		if(current_business)
			current_business.category = new_category

	if(href_list["change_password"])
		. = 1
		var/new_pass
		new_pass = sanitize(copytext(input(usr, "Enter a new password.", "Business Password", current_business.password)  as text,1,15))
		if(!new_pass)
			return
		if(current_business)
			current_business.password = new_pass

/***************************************************

	Temporarily commented out.

/**************************

	Employee Management

**************************/

	if(href_list["manage_employees"])
		. = 1
		index = 7

	if(href_list["return_to_manage_employees"])
		. = 1
		index = 7

	if(href_list["terminate_employee"])
		. = 1
		var/employee = input(usr, "Select an employee to terminate", "Terminate Employee") as null|anything in list(current_business.employees)

		switch(alert(usr, "Are you sure you want to terminate [employee]?","Yes","No"))
			if("Yes")

				terminate_employee(current_business, employee)

			if("No")
				return

	if(href_list["blacklist_employee"])
		. = 1
		var/employee = input(usr, "Select an employee to blacklist", "Blacklist Employee") as null|anything in list(current_business.employees)

		switch(alert(usr, "Are you sure you want to blacklist [employee]?","Yes","No"))
			if("Yes")

				blacklist_employee(current_business, employee)

			if("No")
				return

	if(href_list["view_applicant"])
		. = 1

	if(href_list["check_applications"])
		. = 1
		index = 8

	if(href_list["return_to_applications"])
		. = 1
		index = 8


	if(href_list["email_employee"])
		. = 1

/*******************

	Application

*******************/

	if(href_list["apply_to_business"])
		. = 1

		if(!ishuman(usr))
			return

		var/mob/living/carbon/human/H = usr

		var/obj/item/weapon/card/id/I = H.GetIdCard()

		if(!I)
			return

		var/UID = I.unique_ID
		var/email = get_email(I.associated_email_login["login"])
		var/reg_name = I.registered_name


		var/list/avail_business

		for(var/datum/business/business in businesses)
			avail_business += business.name

		if(!avail_business)
			return

		var/applied_business = input(usr, "Select a business to apply to", "Apply to Business")  as null|anything in list(avail_business)

		var/choice = input(usr,"Apply for a position at [applied_business]?", "Apply to Business") in list("Yes","No")

		if(choice == "Yes")

			var/applied

			for(var/datum/business/business in businesses)
				if(applied_business == business.name)
					applied = business
					break

			var/app_msg = sanitize(copytext(input(usr, "Enter your application message. This will be reviewed by the business owner or managers. (300 chars max)", "Application Message", null)  as message,1,300))

			create_business_applicant(reg_name, UID, email, app_msg, applied)

		if(choice == "No")
			return


	if(href_list["delete_applicant"])
		. = 1

	if(href_list["email_applicant"])
		. = 1

	if(href_list["hire_applicant"])
		. = 1

***********************************************************************/