/client/proc/log_playtime_to_sqlite(var/department, var/amount)
	establish_sqlite_connection()
	if(!sqlite_db)
		return null
	if(!config.sqlite_playtime) // Tracking disabled.
		return

	if(!department || department == ROLE_UNKNOWN)
		return


	var/sqlite_ckey = sql_sanitize_text(ckey(key))
	var/sqlite_department = sql_sanitize_text(department)

	var/record_exists = FALSE

	var/database/query/query_record = new(
		"SELECT ckey, department \
		FROM playtime \
		WHERE ckey = '[sqlite_ckey]'")

	query_record.Execute(sqlite_db)
	sqlite_check_for_errors(query_record, "log_playtime_to_sqlite (1)")

	while(query_record.NextRow())
		var/list/querydata = query_record.GetRowData()
		if(querydata["ckey"] == sqlite_ckey && querydata["department"] == sqlite_department)
			record_exists = TRUE
			break

	if(!record_exists)
		// New data!
		var/database/query/query_insert = new(
		"INSERT INTO playtime (ckey, department, time)\
		VALUES ('[sqlite_ckey]', '[sqlite_department]', [amount])")
		query_insert.Execute(sqlite_db)
		sqlite_check_for_errors(query_insert, "log_playtime_to_sqlite (2)")

	else
		// Existing record to update.
		var/database/query/query_update = new(
		"UPDATE playtime \
		SET time = time + [amount] \
		WHERE ckey = '[sqlite_ckey]' AND department = '[sqlite_department]'"
		)
		query_update.Execute(sqlite_db)
		sqlite_check_for_errors(query_update, "log_playtime_to_sqlite (3)")

/client/proc/get_playtime_from_sqlite(var/department)
	establish_sqlite_connection()
	if(!sqlite_db)
		return null
	if(!config.sqlite_playtime) // Tracking disabled.
		return

	var/sqlite_ckey = sql_sanitize_text(ckey(key))
	var/sqlite_department = sql_sanitize_text(department)

	if(!department)
		department = ROLE_EVERYONE

	if(department != ROLE_EVERYONE)
		var/database/query/query_record = new(
			"SELECT time \
			FROM playtime \
			WHERE ckey = '[sqlite_ckey]' AND department = '[sqlite_department]'")

		query_record.Execute(sqlite_db)
		sqlite_check_for_errors(query_record, "get_playtime_from_sqlite (1)")

		if(query_record.NextRow())
			var/list/data = query_record.GetRowData()
			return text2num(data["time"])

	else
		var/database/query/query_record = new(
			"SELECT sum(time) AS result \
			FROM playtime \
			WHERE ckey = '[sqlite_ckey]'")

		query_record.Execute(sqlite_db)
		sqlite_check_for_errors(query_record, "get_playtime_from_sqlite (2)")

		if(query_record.NextRow())
			var/list/data = query_record.GetRowData()
			return text2num(data["result"])

/client/
	var/playtime_to_log = 0 // Buffer so we don't need to write to the SQLite database every minute.

// This is called once a minute.  Every ten minutes the player accumulates will have those minutes written to the SQLite database.
// Use the immediate argument if you want to write the minutes to the database regardless of the amount without adding, like
// if the round is about to restart.
/client/proc/increment_playtime(var/immediate = 0)
	if(mob.stat == DEAD)
		return
	if(is_afk(5 MINUTES))
		return

	var/list/roles = list()

	var/job_name = metric.guess_job(src.mob)
	var/datum/job/J = metric.role_name_to_job_datum(job_name)
	if(J)
		roles = J.department_groups
	else
		roles = metric.guess_department(src.mob)

	if(!roles.len || ROLE_UNKNOWN in roles)
		return

	if(!immediate)
		playtime_to_log++

	if( (playtime_to_log >= 10) || immediate)
		for(var/dept in roles)
			log_playtime_to_sqlite(dept, playtime_to_log)
		playtime_to_log = 0

/proc/check_if_playtime_is_sufficent(var/client/C, var/datum/job/J, var/department = null)
	if(!sqlite_db || !config.sqlite_playtime)
		return TRUE
	for(var/dept in J.required_playtime)
		var/time_gate = J.required_playtime[dept]
		if(C.get_playtime_from_sqlite(J.department) < time_gate)
			return FALSE
	return TRUE