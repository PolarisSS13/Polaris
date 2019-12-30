/datum/computer_file/program/crim_record
	filename = "crim_record"
	filedesc = "Criminal Record Management"
	program_icon_state = "comm"
	nanomodule_path = /datum/nano_module/program/crim_record
	extended_desc = "Used to view and edit prison sentences post-trial."
	requires_ntnet = 1
	size = 12
	required_access = access_judge

/datum/nano_module/program/crim_record
	name = "Criminal Record Management"
	var/datum/data/record/current_record

	var/index
	var/unique_id
	var/user_name
	var/page_msg = " "
	var/error_msg = " "

/datum/nano_module/program/crim_record/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/list/data = list()
	if(program)
		data = program.get_header_data()

	var/obj/item/weapon/card/id/I = user.GetIdCard()

	if(!istype(I) || !I.registered_name)
		index = 0
	else
		if(!index)
			index = 1
		unique_id = I.unique_ID
		user_name = I.registered_name

	data["index"] = index
	data["page_msg"] = page_msg

	if(index == 0)
		page_msg = "You are not authorized to use this system. Please check your ID details for validity."

	else if(index == 1)
		page_msg = "Welcome to the official criminal record management program, everything within this program is covered by data protection laws. \
		This is a list of all police records of the local district.<br><br> Please select from the list: <br><br>"

		for(var/datum/data/record/R in data_core.security)
			page_msg += "<a href='?src=\ref[src];choice=select_record;selected_record=\ref[R]'>[R.fields["id"]]: [R.fields["name"]]</a> <br>"

	else if(index == 2)
		if(!current_record)
			index = 1
		page_msg = "<h2>[current_record.fields["name"]]</h2><br>This is [current_record.fields["name"]]'s criminal record.<br>"
		var/list/criminal_record = current_record.fields["crim_record"]

		page_msg += text("<BR>\n<a href='?src=\ref[src];choice=criminal_record_add'>Add Criminal Record</a><br>")

		if(!isemptylist(criminal_record))
			for(var/datum/record/C in criminal_record)
				page_msg += text("<BR>\n<a href='?src=\ref[src];choice=criminal_record_remove;criminal_record_r=\ref[C]'>(Remove)</a> <b>[C.name]</b>: [C.details] - [C.author] <i>([C.date_added])</i><br>")
		else
			page_msg += text("<BR>No records found.")

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "criminal_records.tmpl", "Presidential Candidate Registration", 690, 680, state = state)
		if(program.update_layout())
			ui.auto_update_layout = 1
		ui.set_auto_update(1)
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/crim_record/proc/clear_data()
	error_msg = " "
	current_record = null

/datum/nano_module/program/crim_record/Topic(href, href_list)
	if(..()) return 1

	if(href_list["back"])
		. = 1
		clear_data()
		index = 1

	switch(href_list["choice"])

		if("select_record")
			var/R = locate(href_list["selected_record"])
			if(!R) return
			set_profile(R)

		if("criminal_record_add")
			if(!current_record) return
			add_crim_record(usr)

		if("criminal_record_remove")
			if(!current_record) return
			var/datum/record/record = locate(href_list["criminal_record_r"])
			if(!record) return
			remove_record(record)



/datum/nano_module/program/crim_record/proc/remove_record(var/datum/record/record)
	if(!(unique_id == current_record.fields["unique_id"]))
		current_record.fields["crim_record"] -= record


/datum/nano_module/program/crim_record/proc/set_profile(var/datum/data/record/R)
	current_record = R
	index = 2


/datum/nano_module/program/crim_record/proc/add_crim_record(mob/user)

	if(!current_record) return

	var/laws_list = get_law_names()
	var/crime = input(user, "Select a crime.", "Edit Criminal Records") as null|anything in laws_list
	var/sec = sanitize(input(user,"Enter security information here.","Character Preference") as message|null, MAX_RECORD_LENGTH, extra = 0)
	if(isnull(sec)) return

	if(!isnull(crime) && !jobban_isbanned(user, "Records"))
		var/officer_name = user_name

		current_record.fields["crim_record"] += make_new_record(/datum/record/police, crime, officer_name, user.ckey, "[get_game_day()]/[get_game_month()]/[get_game_year()]", sec)
