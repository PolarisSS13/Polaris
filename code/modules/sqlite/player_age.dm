// here because it's similar to below
// Returns null if no DB connection can be established, or -1 if the requested key was not found in the database
/proc/get_player_sqlite_age(key)
	establish_sqlite_connection()
	if(!sqlite_db)
		return null
	if(!config.sqlite_players) // Tracking disabled.
		return

	var/sql_ckey = sql_sanitize_text(ckey(key))

	var/database/query/query = new("SELECT (julianday('now') - firstseen) AS age FROM player WHERE ckey = '[sql_ckey]'")
	query.Execute(sqlite_db)

	if(query.NextRow())
		var/list/querydata = query.GetRowData()
		return Floor(text2num(querydata["age"]))
	else
		return 0

/client/proc/log_client_to_sqlite()

	if(IsGuestKey(src.key))
		return

	player_age = 0

	establish_sqlite_connection()
	if(!sqlite_db)
		return
	world.log << "Logging player ([key]) to SQLite DB."

	player_age = get_player_sqlite_age(key)
	var/player_exists

	var/database/query/query_ip = new("SELECT ckey FROM player WHERE ip = '[address]'")
	query_ip.Execute(sqlite_db)
	sqlite_check_for_errors(query_ip, "log_client_to_sqlite (1)")
	related_accounts_ip = ""
	while(query_ip.NextRow())
		var/list/querydata = query_ip.GetRowData()
		related_accounts_ip += "[querydata["ckey"]], "
		player_exists = 1
		break

	var/database/query/query_cid = new("SELECT ckey FROM player WHERE computerid = '[computer_id]'")
	query_cid.Execute(sqlite_db)
	sqlite_check_for_errors(query_cid, "log_client_to_sqlite (2)")
	related_accounts_cid = ""
	while(query_cid.NextRow())
		var/list/querydata = query_cid.GetRowData()
		related_accounts_cid += "[querydata["ckey"]], "
		player_exists = 1
		break

	var/admin_rank = "Player"
	if(src.holder)
		admin_rank = src.holder.rank

	var/sql_ckey =       sql_sanitize_text(ckey(key))
	var/sql_ip =         sql_sanitize_text(src.address)
	var/sql_computerid = sql_sanitize_text(src.computer_id)
	var/sql_admin_rank = sql_sanitize_text(admin_rank)

	if(player_exists)
		//Player already identified previously, we need to just update the 'lastseen', 'ip' and 'computer_id' variables
		var/database/query/query_update = new(
		"UPDATE player SET lastseen = julianday('now'), ip = '[sql_ip]', computerid = '[sql_computerid]', lastadminrank = '[sql_admin_rank]' \
		WHERE ckey == '[sql_ckey]'"
		)
		query_update.Execute(sqlite_db)
		sqlite_check_for_errors(query_update, "log_client_to_sqlite (3)")
	else
		//New player!! Need to insert all the stuff
		var/database/query/query_insert = new(
		"INSERT INTO player (ckey, firstseen, lastseen, ip, computerid, lastadminrank)\
		VALUES ('[sql_ckey]', julianday('now'), julianday('now'), '[sql_ip]', '[sql_computerid]', '[sql_admin_rank]')")
		query_insert.Execute(sqlite_db)
		sqlite_check_for_errors(query_insert, "log_client_to_sqlite (4)")
