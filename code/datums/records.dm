/datum/record
	var/name = "generic record"
	var/author = "unnamed author"
	var/date_added									// Date record was created IC'ly.

	var/details											// Bulk of the record.

	//ooc info
	var/author_ckey = "n/a"			// Ckey of the person who created this record.
	var/game_id_created				// what game id this record was made on


/datum/record/proc/set_record(r_name, r_author, r_ckey, r_date_added, r_details)
	name = r_name
	author = r_author
	author_ckey = r_ckey
	if(!date_added)
		date_added = full_game_time()
	else
		date_added = r_date_added

	details = r_details
	game_id_created = game_id


/proc/make_new_record(r_name, r_author, r_ckey, r_date_added, r_details)
	var/datum/record/R = new /datum/record()
	R.set_record(r_name, r_author, r_ckey, r_date_added, r_details)

	return R


