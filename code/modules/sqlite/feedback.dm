/proc/sqlite_report_death(var/mob/living/L)
	if(!config.sqlite_enabled || !config.sqlite_stats)
		return
	if(!L)
		return
	if(!L.key || !L.mind)
		return

	var/area/death_area = get_area(L)
	var/area_name = death_area ? death_area.name : "Unknown area"
	var/sqlite_species = L.get_species() ? sql_sanitize_text(L.get_species()) : "Unknown species"
	// The prefix of 'sqlite_' indicates that the variable is sanitzed by sql_sanitize_text().

	var/sqlite_name = sql_sanitize_text(L.real_name)
	var/sqlite_key = sql_sanitize_text(ckey(L.key))
	var/sqlite_death_area = sql_sanitize_text(area_name)
	var/sqlite_special_role = sql_sanitize_text(L.mind.special_role)
	var/sqlite_job = sql_sanitize_text(L.mind.assigned_role)

	var/sqlite_killer_name
	var/sqlite_killer_key
	if(L.lastattacker && istype(L.lastattacker, /mob/living) )
		var/mob/living/killer = L.
		sqlite_killer_name = killer.real_name ? sql_sanitize_text(killer.real_name) : "Unknown name"
		sqlite_killer_key = killer.key ? sql_sanitize_text(killer.key) : "Unknown key"

	var/sqlite_time = time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")
	var/coord = "[L.x], [L.y], [L.z]"

	establish_sqlite_connection()
	if(!sqlite_db)
		log_game("SQLite ERROR during death reporting. Failed to connect.")
	else
		var/database/query/query = new(
		"INSERT INTO death (\
		name, \
		byondkey, \
		job, \
		special_role, \
		death_area, \
		time_of_death, \
		killer_name, \
		killer_key, \
		gender, \
		species, \
		bruteloss, \
		fireloss, \
		brainloss, \
		oxyloss, \
		cloneloss, \
		coord) \
		\
		VALUES (\
		'[sqlite_name]', \
		'[sqlite_key]', \
		'[sqlite_job]', \
		'[sqlite_special_role]', \
		'[sqlite_death_area]', \
		'[sqlite_time]', \
		'[sqlite_killer_name]', \
		'[sqlite_killer_key]', \
		'[L.gender]', \
		'[sqlite_species]', \
		[L.getBruteLoss()], \
		[L.getFireLoss()], \
		[L.brainloss], \
		[L.getOxyLoss()], \
		[L.getCloneLoss()], \
		'[coord]')"
		)
		query.Execute(sqlite_db)
		sqlite_check_for_errors(query, "sqlite_report_death (1)")
/*
// Add a string to feedback table.
/proc/feedback_add_details(var/feedback_type, var/feedback_data)
	establish_sqlite_connection()
	if(!sqlite_db)
		return
	//TODO

// Overwrite a feedback table string.
/proc/feedback_set_details(var/feedback_type, var/feedback_data)
	establish_sqlite_connection()
	if(!sqlite_db)
		return
	//TODO

// Increment a feedback field.
/proc/feedback_inc(var/feedback_type, var/feedback_amt)
	establish_sqlite_connection()
	if(!sqlite_db)
		return
	//TODO

// Set a feedback val.
/proc/feedback_set(var/feedback_type, var/feedback_amt)
	establish_sqlite_connection()
	if(!sqlite_db)
		return
	//TODO
*/