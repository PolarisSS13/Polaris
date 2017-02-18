var/list/jobbans = list()
var/list/serverbans = list()
var/list/allbans = list()

/hook/startup/proc/rs_load_bans()
	world.log << "Loading ban database."
	sqlite_load_bans()
	return 1


// Try to avoid using this, since it can cause significant lag.  Use update_datum() on the specific datum if you just
// changed one thing.
/proc/sqlite_load_bans()
	establish_sqlite_connection()
	if(!sqlite_db)
		return FALSE
	serverbans.Cut()
	jobbans.Cut()
	for(var/thing in allbans)
		qdel(thing)
	allbans.Cut()
	var/database/query/query = new("SELECT * FROM ban")
	query.Execute(sqlite_db)
	while(query.NextRow())
		new /datum/ban(query.GetRowData())
	return TRUE

/proc/sqlite_add_ban(var/_ckey = "Undefined", var/_cid, var/_ip, var/_job, var/_reason = "Undefined", var/_banningkey = "Undefined", var/_expires)
	establish_sqlite_connection()
	if(!sqlite_db)
		return FALSE

	if(!_cid || _cid == "")
		_cid = "NULL"
		for(var/client/C in clients)
			if(C.ckey == _ckey)
				_cid = C.computer_id
				break

	if(!_ip || _ip == "")
		_ip = "NULL"
		for(var/client/C in clients)
			if(C.ckey == _ckey)
				_ip = C.address
				break

	var/bantype = BAN_SERVERBAN

	if(_job)
		_job = lowertext(_job)
		bantype = BAN_JOBBAN

	_job		= sql_sanitize_text(_job)
	_reason		= sql_sanitize_text(_reason)
	_banningkey	= sql_sanitize_text(_banningkey)

	var/database/query/insert = new(
		"INSERT INTO ban (bantype, reason, job, expiration_datetime, ckey, computerid, ip, banning_ckey, banning_datetime)\
		VALUES ('[bantype]', '[_reason]', '[_job]', [_expires ? "datetime('now','+[_expires] minutes')" : "NULL"], '[_ckey]', '[_cid]', '[_ip]', '[_banningkey]', datetime('now') )"
		)

	insert.Execute(sqlite_db)
	sqlite_check_for_errors(insert, "sqlite_add_ban (1)")

	message_admins("<span class='danger'>[_banningkey] has banned [_ckey] from [_job ? "from job ([_job])" : "the server"] for reason: [_reason]</span>")
	for(var/client/C in clients)
		if(C.ckey == _ckey)
			C << "<span class='danger'><big>You have been banned from [_job ? "job ([_job])" : "the server"] by [_banningkey] for the following reason: [_reason]</big></span>"

			if(!_expires)
				C << "<span class='danger'>This is a permanent ban.</span>"
			else
				C << "<span class='danger'>The ban will be lifted automatically in [_expires] minute\s.</span>"

			if(config.banappeals)
				C << "<span class='danger'>To try to resolve this matter, head to [config.banappeals].</span>"
			else
				C << "<span class='danger'>No ban appeals URL has been set.</span>"

			if(!_job)
				del(C) // qdel() complains if it takes a client.
			break

	var/database/query/select = new(
		"SELECT * FROM ban \
		ORDER BY id DESC LIMIT 1;"
		)
	select.Execute(sqlite_db)
	sqlite_check_for_errors(insert, "sqlite_add_ban (2)")
	if(select.NextRow())
		new /datum/ban(select.GetRowData())