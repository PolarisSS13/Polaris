var/global/list/businesses = list()

/datum/business
	var/name = "Unnamed Business"
	var/category = "General"
	var/slogan = "Generic slogan."
	var/description = "Generic description."
	var/creation_time
	var/uid
	var/password
	var/email

	var/owner_name
	var/owner_uid

	var/status = "Active"

	var/associated_account_no

	var/gets_business_tax = TRUE                // no one is safe.

	var/primary_color = "#000000"
	var/secondary_color = "#ffffff"

	var/list/blacklisted_employees = list()     // by unique id

	var/list/datum/job/specific_jobs = list()

	var/list/employees = list()
	var/list/applicants = list()

/proc/get_all_businesses(mob/user) //Displays all businesses in a table.
	var/dat = list()
	dat += "<center>"
	if(!businesses.len)
		dat += "<br>There are no registered businesses.<br>"
	else
		dat += "<br>Currently, there are [businesses.len] registered businesses.<br>"

		for(var/datum/business/B in businesses)

			dat += "<table style=\"width: 85%;\" border=1>"
			dat += "<thead><tr>"
			dat += "<th style=\"text-align: center; padding: 10px; background-color: [B.primary_color];\">"
			dat += "<span style=\"font-family: Tahoma, Geneva, sans-serif; font-size: 24px; color: [B.secondary_color];\">[B.name]</span></th></tr>"
			dat += "</thead><tbody><tr><td style=\"width: 100.0000%; padding: 10px;\">"
			dat += "<p style=\"text-align: center;\"><em><span style=\"font-size: 18px; color: [B.secondary_color]; font-family: Georgia, serif;\">[B.slogan]</span></em></p>"
			dat += "<hr>"

			dat += "<p>[B.description]</p>"

			dat += "</td></tr></tbody></table>"

			dat += "</br>"

	dat += "</center>"

	var/datum/browser/popup = new(usr, "Businesses", "Businesses", 640, 600, src)
	popup.set_content(jointext(dat,null))
	popup.open()

/proc/check_business_name_exist(var/name) //Compares a business 'B' to the master list to see if it exists.
	for(var/datum/business/B in businesses)
		if(name == B.name)
			message_admins("Found [B.name].")
			return 1
	return 0

/proc/get_business_by_name(var/name) //Compares a business 'B' to the master list and returns the business if found.
	for(var/datum/business/B in businesses)
		if(B.name == name)
			return B


/proc/try_auth_business(var/datum/business/B, var/name, var/pass)   //Handles logins
	if(B.name == name && B.password == pass)
		return 1
	return 0

/proc/create_new_business(var/name, var/description, var/slogan, var/pass, var/category, var/owner_uid, var/owner_name) // Makes a new business

	var/datum/business/B = new()
	B.name = name
	B.description = description
	B.slogan = slogan
	B.creation_time = get_game_time()
	B.password = pass
	B.owner_uid = owner_uid
	B.owner_name = owner_name
	B.uid = md5("[B.name]")
	B.email = get_business_email(B)

	var/datum/computer_file/data/email_account/EA = new/datum/computer_file/data/email_account()
	EA.password = GenerateKey()
	EA.login = 	B.email

	B.creation_time = current_date_string

	businesses += B

	return B

/*************************

	Employee Stuff here

*************************/

/datum/employee
	var/name
	var/manager // If this person is a manager or not
	var/position = "Employee"
	var/unique_ID
	var/empl_ID
	var/email
	var/blacklisted = FALSE

	var/join_date //date this person joined

/datum/applicant
	var/name
	var/message //The application message someone applies with.
	var/unique_ID
	var/email
	var/blacklisted = FALSE
	var/is_employee

	var/apply_date //date this person applied

/proc/blacklist_employee(var/datum/business/B, var/datum/employee/M)
	M.blacklisted = TRUE
	B.blacklisted_employees += M
	B.employees -= M

/proc/terminate_employee(var/datum/business/B, var/datum/employee/M)
	B.employees -= M

/proc/delete_applicant(var/datum/business/B, var/datum/applicant/A)
	B.applicants -= A

/proc/hire_applicant(var/datum/business/B, var/datum/applicant/A)
	delete_applicant(B, A)
	create_employee(A.name, A.unique_ID, "Employee", B)

/proc/email_applicant(var/datum/business/B, var/datum/applicant/A, var/title, var/msg)

	var/datum/computer_file/data/email_account/address = get_email(A.email)

	var/datum/computer_file/data/email_message/message = new()
	message.title = title

	message.stored_data = msg

	message.source = B.email

	address.receive_mail(message, 1)

/proc/email_employee(var/datum/business/B, var/datum/applicant/A, var/title, var/msg)

	var/datum/computer_file/data/email_account/address = get_email(A.email)

	var/datum/computer_file/data/email_message/message = new()
	message.title = title

	message.stored_data = msg

	message.source = B.email

	address.receive_mail(message, 1)


/proc/create_business_applicant(var/name, var/uid, var/email, var/msg, var/datum/business/business)

	var/datum/applicant/A = new()
	A.name = name
	A.unique_ID = uid
	A.message = msg
	A.email = email
	A.apply_date = current_date_string

	business.applicants += A

	return A

/proc/is_employee(var/uid, var/datum/business/business)
	for(var/datum/employee/M in business.employees)
		if(M.unique_ID == uid)
			return 1
	return 0

/proc/create_employee(var/name, var/uid, var/position, var/datum/business/business)

	var/datum/employee/M = new()
	M.name = name
	M.manager = 1
	M.position = position
	M.unique_ID = uid
	M.email = get_employee_email(business, M)

	var/datum/computer_file/data/email_account/EA = new/datum/computer_file/data/email_account()
	EA.password = GenerateKey()
	EA.login = 	M.email

	business.employees += M

	M.join_date = current_date_string

	// Send an email to the new employee.

	var/datum/computer_file/data/email_account/address = get_email(M.email)

	var/datum/computer_file/data/email_message/message = new()
	message.title = "Congratulations! You've been hired!: [business.name]"

	message.stored_data = "This is a confirmation email showing that your application to join [business.name] has been approved.\n\n \
	A manager will contact you shortly to give you additional information. \n \
	Thank you for using the Business Management Utility!"

	message.source = "noreply@businessmanagementutility.techsoft.nt"

	address.receive_mail(message, 1)

	return M

/proc/get_employee_email(var/datum/business/B, var/datum/employee/M)
	var/domain = get_business_domain(B)
	var/prefix = replacetext(lowertext(B.name), " ", "_")
	var/email = "[prefix]@[domain]"
	if(ntnet_global.does_email_exist(email))
		email = "[prefix][rand(100, 999)]@[domain]"
	if(ntnet_global.does_email_exist(email))
		email = get_business_email(B)

	return email

/proc/get_business_email(var/datum/business/B)
	var/domain = get_business_domain(B)
	var/email = "admin@[domain]"

	return email

/proc/get_business_domain(var/datum/business/B)
	var/domain = "[replacetext(lowertext(B.name), " ", "_")].businesses.nanotrasen.gov"

	return domain