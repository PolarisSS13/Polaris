/datum/category_item/player_setup_item/general/records
	name = "Records"
	sort_order = 5

/datum/category_item/player_setup_item/general/records/load_character(var/savefile/S)
	S["med_record"]				>> pref.med_record
	S["sec_record"]				>> pref.sec_record
	S["gen_record"]				>> pref.gen_record
	S["economic_status"]		>> pref.economic_status

/datum/category_item/player_setup_item/general/records/save_character(var/savefile/S)
	S["med_record"]				<< pref.med_record
	S["sec_record"]				<< pref.sec_record
	S["gen_record"]				<< pref.gen_record
	S["economic_status"]		<< pref.economic_status

/datum/category_item/player_setup_item/general/records/sanitize_character()

	pref.economic_status = sanitize_inlist(pref.economic_status, ECONOMIC_CLASS, initial(pref.economic_status))

// Moved from /datum/preferences/proc/copy_to()
/datum/category_item/player_setup_item/general/records/copy_to_mob(var/mob/living/carbon/human/character)
	. = ..()
	character.med_record		= pref.med_record
	character.sec_record		= pref.sec_record
	character.gen_record		= pref.gen_record

/datum/category_item/player_setup_item/general/records/content(var/mob/user)
	. = ..()
	. += "<br/><b>Records</b>:<br/>"
	if(jobban_isbanned(user, "Records"))
		. += "<span class='danger'>You are banned from using character records.</span><br>"
	else
		. += "Medical Records:<br>"
		. += "<a href='?src=\ref[src];set_medical_records=1'>[TextPreview(pref.med_record,40)]</a><br><br>"
		. += "Employment Records:<br>"
		. += "<a href='?src=\ref[src];set_general_records=1'>[TextPreview(pref.gen_record,40)]</a><br><br>"
		. += "Security Records:<br>"
		. += "<a href='?src=\ref[src];set_security_records=1'>[TextPreview(pref.sec_record,40)]</a><br>"

/datum/category_item/player_setup_item/general/records/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["econ_status"])
		var/new_class = input(user, "Choose your economic status. This will affect the amount of money you will start with.", "Character Preference", pref.economic_status)  as null|anything in ECONOMIC_CLASS
		if(new_class && CanUseTopic(user))
			pref.economic_status = new_class
			return TOPIC_REFRESH

	else if(href_list["set_medical_records"]) //2023-03-18, we're using sanitizeSafe() in order to remove <> entirely, allowing us to safely decode it on the pref screen
		var/new_medical = html_decode(sanitizeSafe(input(user,"Enter medical information here.","Character Preference", html_decode(pref.med_record)) as message|null, MAX_RECORD_LENGTH, extra = 0))
		if(!isnull(new_medical) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.med_record = new_medical
		return TOPIC_REFRESH

	else if(href_list["set_general_records"]) //2023-03-20, this allows people to use apostrophes in their records!
		var/new_general = html_decode(sanitizeSafe(input(user,"Enter employment information here.","Character Preference", html_decode(pref.gen_record)) as message|null, MAX_RECORD_LENGTH, extra = 0))
		if(!isnull(new_general) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.gen_record = new_general
		return TOPIC_REFRESH

	else if(href_list["set_security_records"]) //Note that html exploits still won't work here because we removed <> earlier.
		var/sec_medical = html_decode(sanitizeSafe(input(user,"Enter security information here.","Character Preference", html_decode(pref.sec_record)) as message|null, MAX_RECORD_LENGTH, extra = 0))
		if(!isnull(sec_medical) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.sec_record = sec_medical
		return TOPIC_REFRESH

	return ..()
