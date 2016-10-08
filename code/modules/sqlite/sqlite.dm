/client/verb/sqlite_connect_test()
	set category = "sqlite"
	set name = "connect to sqlite"
	establish_sqlite_connection()


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
			"CREATE TABLE IF NOT EXISTS player ( \
			ckey TEXT PRIMARY KEY NOT NULL UNIQUE, \
			firstseen datetime NOT NULL, \
			lastseen datetime NOT NULL, \
			ip TEXT NOT NULL, \
			computerid TEXT NOT NULL, \
			lastadminrank TEXT NOT NULL DEFAULT 'Player' \
			);")

		init_schema.Execute(sqlite_db)

		if(init_schema.ErrorMsg())
			world.log << "SQL ERROR: player: [init_schema.ErrorMsg()]."

		// Death table.
		init_schema = new(
			"CREATE TABLE IF NOT EXISTS death ( \
			id INTEGER PRIMARY KEY NOT NULL UNIQUE, \
			pod TEXT NOT NULL, \
			coord TEXT NOT NULL, \
			tod DATETIME NOT NULL, \
			job TEXT NOT NULL, \
			special TEXT NOT NULL, \
			name TEXT NOT NULL, \
			byondkey TEXT NOT NULL, \
			laname TEXT NOT NULL, \
			lakey TEXT NOT NULL, \
			gender TEXT NOT NULL, \
			bruteloss INTEGER NOT NULL, \
			brainloss INTEGER NOT NULL, \
			fireloss INTEGER NOT NULL, \
			oxyloss INTEGER NOT NULL, \
			cloneloss INTEGER NOT NULL \
			);")

		init_schema.Execute(sqlite_db)
		if(init_schema.ErrorMsg())
			world.log << "SQL ERROR: death: [init_schema.ErrorMsg()]."

// Run all strings to be used in an SQL query through this proc first to properly escape out injection attempts.
/proc/sql_sanitize_text(var/t = "")
	// removes all non upper/lower/numbers and hyphens    strFirstName = strFirstName.replace(/[^A-Za-z0-9-]/gim, '');
	// only 0 to 9                                        strPhone = strPhone.replace(/[^0-9]/gim, '');
	t = replacetext(t, "'", "''")
	t = replacetext(t, ";", "")
	t = replacetext(t, "&", "")
	return sanitize(t)