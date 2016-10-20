var/database/sqlite_db

/proc/establish_sqlite_connection()

	if(!config.sqlite_enabled)
		del sqlite_db
		sqlite_db = null
		return FALSE

	if(!sqlite_db)
		// Create or load the DB.
		sqlite_db = new("[config.sqlite_path]")
		//sqlite_db = new("data/sqlite/station.db")

		world.log << "SQLite database loaded."

		// Playerdata table.
		var/database/query/init_schema = new(
			"CREATE TABLE IF NOT EXISTS player \
			(\
			ckey TEXT PRIMARY KEY NOT NULL UNIQUE, \
			firstseen datetime NOT NULL, \
			lastseen datetime NOT NULL, \
			ip TEXT NOT NULL, \
			computerid TEXT NOT NULL, \
			lastadminrank TEXT NOT NULL DEFAULT 'Player' \
			);")
		init_schema.Execute(sqlite_db)

		// Ban table.
		init_schema = new(
			"CREATE TABLE IF NOT EXISTS ban \
			(\
			id INTEGER PRIMARY KEY NOT NULL, \
			bantype TEXT NOT NULL, \
			reason text NOT NULL, \
			job TEXT DEFAULT NULL, \
			expiration_datetime datetime DEFAULT NULL, \
			ckey TEXT NOT NULL, \
			computerid TEXT DEFAULT NULL, \
			ip TEXT DEFAULT NULL, \
			banning_ckey TEXT NOT NULL, \
			banning_datetime datetime NOT NULL, \
			unbanned_ckey TEXT DEFAULT NULL, \
			unbanned_datetime datetime DEFAULT NULL \
			);")
		init_schema.Execute(sqlite_db)

		// Playtime table.
		init_schema = new(
			"CREATE TABLE IF NOT EXISTS playtime \
			(\
			ckey TEXT NOT NULL, \
			department TEXT NOT NULL, \
			time INTEGER NOT NULL\
			);")
		init_schema.Execute(sqlite_db)

		// Death table.
		init_schema = new(
			"CREATE TABLE IF NOT EXISTS death \
			(\
			id INTEGER PRIMARY KEY NOT NULL UNIQUE, \
			death_area TEXT NOT NULL, \
			coord TEXT NOT NULL, \
			time_of_death DATETIME NOT NULL, \
			job TEXT NOT NULL, \
			special_role TEXT NOT NULL, \
			name TEXT NOT NULL, \
			byondkey TEXT NOT NULL, \
			killer_name TEXT NOT NULL, \
			killer_key TEXT NOT NULL, \
			gender TEXT NOT NULL, \
			species TEXT NOT NULL, \
			bruteloss INTEGER NOT NULL, \
			brainloss INTEGER NOT NULL, \
			fireloss INTEGER NOT NULL, \
			oxyloss INTEGER NOT NULL, \
			cloneloss INTEGER NOT NULL \
			);")
		init_schema.Execute(sqlite_db)

		if(!sqlite_db)
			world.log << "Failed to load or create an SQLite database."

// Run all strings to be used in an SQL query through this proc first to properly escape out injection attempts.
/proc/sql_sanitize_text(var/t = "")
	// removes all non upper/lower/numbers and hyphens    strFirstName = strFirstName.replace(/[^A-Za-z0-9-]/gim, '');
	// only 0 to 9                                        strPhone = strPhone.replace(/[^0-9]/gim, '');
	t = replacetext(t, "'", "''")
	t = replacetext(t, ";", "")
	t = replacetext(t, "&", "")
	return sanitize(t)

// General error checking for SQLite.
/proc/sqlite_check_for_errors(var/database/query/query_used, var/desc)
	if(query_used && query_used.ErrorMsg())
		log_debug("SQLite Error: [desc] : [query_used.ErrorMsg()]")