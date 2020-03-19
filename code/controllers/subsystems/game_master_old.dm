// This is a sort of successor to the various event systems created over the years.  It is designed to be just a tad smarter than the
// previous ones, checking various things like player count, department size and composition, individual player activity,
// individual player (IC) skill, and such, in order to try to choose the best actions to take in order to add spice or variety to
// the round.

SUBSYSTEM_DEF(game_master_old)
	name = "Events (Game Master)"
	wait = 2 SECONDS
	init_order = INIT_ORDER_GAME_MASTER
	flags = SS_KEEP_TIMING
	runlevels = RUNLEVEL_GAME

	// List of `/datum/event2/event`s that are currently active, and receiving process() ticks.
	var/list/active_events = list()

	// List of `/datum/event2/event`s that finished, and are here for showing at roundend, if that's desired.
	var/list/finished_events = list()

	// List of `/datum/event2/meta`s that hold meta-information about events.
	var/list/all_meta_events = list()

	var/list/available_actions = list()	// A list of 'actions' that the GM has access to, to spice up a round, such as events.
	var/danger = 0						// The GM's best guess at how chaotic the round is.  High danger makes it hold back.
	var/staleness = -20					// Determines liklihood of the GM doing something, increases over time.

	// Multiplier for how much 'danger' is accumulated. Higer generally makes it possible for more dangerous events to be picked.
	var/danger_modifier = 1.0

	// Ditto.  Higher numbers generally result in more events occuring in a round.
	var/staleness_modifier = 1.0

	// If an event was done for a specific department, it is written here, so it doesn't do it again.
	var/last_department_used = null

	var/next_action = 0								// Minimum amount of time of nothingness until the GM can pick something again.
	var/decision_cooldown_lower_bound = 5 MINUTES	// Lower bound for how long to wait until -the potential- for another action being decided.
	var/decision_cooldown_upper_bound = 20 MINUTES	// Same, but upper bound.

	var/ignore_time_restrictions = FALSE// Useful for debugging without needing to wait 20 minutes each time.
	var/ignore_round_chaos = FALSE		// If true, the system will happily choose back to back intense events like meteors and blobs, Dwarf Fortress style.

/datum/controller/subsystem/game_master/Initialize()
//	available_actions = init_subtypes(/datum/gm_action)
//	for(var/A in available_actions)
//		var/datum/gm_action/action = A
//		action.gm = src

	var/list/subtypes = subtypesof(/datum/event2/meta)
	for(var/T in subtypes)
		var/datum/event2/meta/M = new T(src)
		all_meta_events += M

	if(config && !config.enable_game_master)
		can_fire = FALSE

	return ..()

/datum/controller/subsystem/game_master/fire(resumed)
	// Process active events.
	for(var/E in active_events)
		var/datum/event2/event/event = E
		event.process()
		if(event.finished)
			event_finished(event)

	// Decide if a new event is a good idea, and if so, which one.
	if(times_fired % (1 MINUTE / wait) == 0) // Run once a minute, even if `wait` gets changed in the future or something.
		adjust_staleness(1)
		adjust_danger(-1)

		var/global_afk = metric.assess_all_living_mobs()
		global_afk = abs(global_afk - 100)
		global_afk = round(global_afk / 100, 0.1)
		adjust_staleness(global_afk) // Staleness increases faster if more people are less active.

		if(ignore_time_restrictions || next_action < world.time)
			if(prob(staleness) && pre_action_checks())
				log_debug("Game Master is going to start something.")
				start_action()

/datum/controller/subsystem/game_master/proc/event_started(datum/event2/event/E)
	active_events += E

/datum/controller/subsystem/game_master/proc/event_finished(datum/event2/event/E)
	active_events -= E
	finished_events += E


// These are ran before committing to an action or event.
// Returns TRUE if the system is allowed to procede, otherwise returns FALSE.
/datum/controller/subsystem/game_master/proc/pre_action_checks(quiet = FALSE)
	if(!ticker || ticker.current_state != GAME_STATE_PLAYING)
		if(!quiet)
			log_debug("Game Master unable to start event: Ticker is nonexistant, or the game is not ongoing.")
		return FALSE
	if(ignore_time_restrictions)
		return TRUE
	if(next_action > world.time) // Sanity.
		if(!quiet)
			log_debug("Game Master unable to start event: Time until next action is approximately [round((next_action - world.time) / (1 MINUTE))] minute(s)")
		return FALSE

	// Last minute antagging is bad for humans to do, so the GM will respect the start and end of the round.
	var/mills = round_duration_in_ticks
	var/mins = round((mills % 36000) / 600)
	var/hours = round(mills / 36000)

//	if(hours < 1 && mins <= 20) // Don't do anything for the first twenty minutes of the round.
//		if(!quiet)
//			log_debug("Game Master unable to start event: It is too early.")
//		return FALSE
	if(hours >= 2 && mins >= 40) // Don't do anything in the last twenty minutes of the round, as well.
		if(!quiet)
			log_debug("Game Master unable to start event: It is too late.")
		return FALSE
	return TRUE

/datum/controller/subsystem/game_master/proc/start_action()
	log_debug("Game Master now starting action decision.")

	var/list/most_active_departments = metric.assess_all_departments(3, list(last_department_used))
	var/list/best_actions = decide_best_action(most_active_departments)

	if(best_actions && best_actions.len)
		var/list/weighted_actions = list()

		for(var/A in best_actions)
			var/datum/gm_action/action = A
			if(danger >= action.chaos_threshold)
				continue // We skip dangerous events when bad stuff is already occuring.
			weighted_actions[action] = action.get_weight()

		var/datum/gm_action/choice = pickweight(weighted_actions)

		if(choice)
			log_debug("[choice.name] was chosen by the Game Master, and is now being ran.")
			run_action(choice)

/datum/controller/subsystem/game_master/proc/run_action(datum/gm_action/action)
	log_debug("[action.name] is being ran.")
	action.set_up()
	action.start()
	action.announce()
	if(action.chaotic)
		danger += action.chaotic

	next_action = world.time + rand(decision_cooldown_lower_bound, decision_cooldown_upper_bound)
	last_department_used = LAZYACCESS(action.departments, 1)

/datum/controller/subsystem/game_master/proc/decide_best_action(list/most_active_departments)
	if(!LAZYLEN(most_active_departments))// Server's empty?
		log_debug("Game Master failed to find any active departments.")
		return list()

	var/list/best_actions = list() // List of actions which involve the most active departments.
	if(most_active_departments.len >= 2)
		for(var/A in available_actions)
			var/datum/gm_action/action = A
			if(!action.enabled)
				continue
			// Try to incorporate an action with the top two departments first.
			if(most_active_departments[1] in action.departments && most_active_departments[2] in action.departments)
				best_actions.Add(action)
				log_debug("[action.name] is being considered because both most active departments are involved.")

		if(best_actions.len) // We found something for those two, let's do it.
			return best_actions

	// Otherwise we probably couldn't find something for the second highest group, so let's ignore them.
	for(var/A in available_actions)
		var/datum/gm_action/action = A
		if(!action.enabled)
			continue
		if(most_active_departments[1] in action.departments)
			best_actions.Add(action)
			log_debug("[action.name] is being considered because the most active department is involved.")

	if(best_actions.len) // Found something for the one guy.
		return best_actions

	// At this point we should expand our horizons.
	for(var/A in available_actions)
		var/datum/gm_action/action = A
		if(!action.enabled)
			continue
		if(DEPARTMENT_EVERYONE in action.departments)
			best_actions.Add(action)
			log_debug("[action.name] is being considered because it involves everyone.")

	if(best_actions.len) // Finally, perhaps?
		return best_actions

	// Just give a random event if for some reason it still can't make up its mind.
	for(var/A in available_actions)
		var/datum/gm_action/action = A
		if(!action.enabled)
			continue
		best_actions.Add(action)
		log_debug("[action.name] is being considered because everything else failed.")

	if(best_actions.len) // Finally, perhaps?
		return best_actions

	log_debug("Game Master failed to find a suitable event, something very wrong is going on.")
	return list()


// Tell the game master that something dangerous happened, e.g. someone dying, station explosions.
/datum/controller/subsystem/game_master/proc/adjust_danger(amount)
	amount *= danger_modifier
	danger = round(between(0, danger + amount, 1000), 0.1)

// Tell the game master that things are getting boring if positive, or something interesting if negative..
/datum/controller/subsystem/game_master/proc/adjust_staleness(amount)
	amount *= staleness_modifier
	staleness = round( between(-20, staleness + amount, 100), 0.1)


/*
Admin UI
*/

/client/proc/show_gm_status()
	set category = "Debug"
	set name = "Show GM Status"
	set desc = "Shows you what the GM is thinking.  If only that existed in real life..."

	if(check_rights(R_ADMIN|R_EVENT|R_DEBUG))
		SSgame_master.interact(usr)
	else
		to_chat(usr, span("warning", "You do not have sufficent rights to view the GM panel, sorry."))

/datum/controller/subsystem/game_master/proc/interact(var/client/user)
	if(!user)
		return

	// Using lists for string tree conservation.
	var/list/dat = list("<html><head><title>Automated Game Master Event System</title></head><body>")

	// Makes the system turn on or off.
	dat += href(src, list("toggle" = 1), "\[Toggle GM\]")
	dat += " | "

	// Makes the system not care about staleness or being near round-end.
	dat += href(src, list("toggle_time_restrictions" = 1), "\[Toggle Time Restrictions\]")
	dat += " | "

	// Makes the system not care about how chaotic the round might be.
	dat += href(src, list("toggle_chaos_throttle" = 1), "\[Toggle Chaos Throttling\]")
	dat += " | "

	// Makes the system immediately choose an event, while still bound to factors like danger, weights, and department staffing.
	dat += href(src, list("force_choose_event" = 1), "\[Force Event Decision\]")
	dat += "<br>"

	dat += "State: [can_fire ? "Active": "Inactive"]<br>"
	dat += "Status: [pre_action_checks(TRUE) ? "Ready" : "Suppressed"]<br><br>"

	dat += "Staleness: [staleness] "
	dat += href(src, list("set_staleness" = 1), "\[Set\]")
	dat += "<br>"
	dat += "<i>Staleness is an estimate of how boring the round might be, and if an event should be done. It is increased passively over time, \
	and increases faster if people are AFK. It deceases when events and certain 'interesting' things happen in the round.</i><br>"

	dat += "Danger: [danger] "
	dat += href(src, list("set_danger" = 1), "\[Set\]")
	dat += "<br>"
	dat += "<i>Danger is an estimate of how chaotic the round has been so far. It is decreased passively over time, and is increased by having \
	certain chaotic events be selected, or chaotic things happen in the round. A sufficently high amount of danger will make the system \
	avoid using destructive events, to avoid pushing the station over the edge.</i><br>"

	dat += "<h2>Player Activity:</h2>"

	dat += "<table border='1' style='width:100%'>"
	dat += "<tr>"
	dat += "<th>Category</th>"
	dat += "<th>Activity Percentage</th>"
	dat += "</tr>"

	dat += "<tr>"
	dat += "<td>All Living Mobs</td>"
	dat += "<td>[metric.assess_all_living_mobs()]%</td>"
	dat += "</tr>"

	dat += "<tr>"
	dat += "<td>All Ghosts</td>"
	dat += "<td>[metric.assess_all_dead_mobs()]%</td>"
	dat += "</tr>"

	dat += "<tr>"
	dat += "<th colspan='2'>Departments</td>"
	dat += "</tr>"

	for(var/D in metric.departments)
		dat += "<tr>"
		dat += "<td>[D]</td>"
		dat += "<td>[metric.assess_department(D)]%</td>"
		dat += "</tr>"

	dat += "<tr>"
	dat += "<th colspan='2'>Players</td>"
	dat += "</tr>"

	for(var/P in player_list)
		var/mob/M = P
		dat += "<tr>"
		dat += "<td>[M] ([M.ckey])</td>"
		dat += "<td>[metric.assess_player_activity(M)]%</td>"
		dat += "</tr>"

	dat += "</table>"

	dat += "<h2>Actions available:</h2>"
	dat += "<table border='1' style='width:100%'>"

	dat += "<tr>"
	dat += "<th>Action Name</th>"
	dat += "<th>Involved Departments</th>"
	dat += "<th>Chaos</th>"
	dat += "<th>Current Weight</th>"
	dat += "<th>Buttons</th>"
	dat += "</tr>"

	for(var/A in available_actions)
		var/datum/gm_action/action = A
		dat += "<tr>"
		dat += "<td>[action.name]</td>"
		dat += "<td>[english_list(action.departments)]</td>"
		dat += "<td>[action.chaotic]</td>"
		dat += "<td>[action.get_weight()]</td>"
		dat += "<td>[href(action, list("force" = 1), "\[Force\]")] [href(action, list("toggle" = 1), "\[Toggle\]")]</td>"
		dat += "</tr>"

	dat += "</table>"

	dat += "</body></html>"

	var/datum/browser/popup = new(user, "game_master_debug", "Automated Game Master Event System", 800, 500, src)
	popup.set_content(dat.Join())
	popup.open()

//	HTML += "Actions available;<br>"
//	for(var/datum/gm_action/action in available_actions)
//		if(action.enabled == FALSE)
//			continue
//		HTML += "[action.name] ([english_list(action.departments)]) (weight: [action.get_weight()]) <a href='?src=\ref[action];force=1'>\[Force\]</a> <br>"

//	HTML += "<br>"
//	HTML += "All living mobs activity: [metric.assess_all_living_mobs()]%<br>"
//	HTML += "All ghost activity: [metric.assess_all_dead_mobs()]%<br>"
//
//	HTML += "<br>"
//	HTML += "Departmental activity;<br>"
//	for(var/department in metric.departments)
//		HTML += "    [department] : [metric.assess_department(department)]%<br>"
//
//	HTML += "<br>"
//	HTML += "Activity of players;<br>"
//	for(var/mob/player in player_list)
//		HTML += "    [player] ([player.key]) : [metric.assess_player_activity(player)]%<br>"
//
//	HTML +="</body></html>"
//	user << browse(HTML, "window=log;size=400x450;border=1;can_resize=1;can_close=1;can_minimize=1")


/datum/controller/subsystem/game_master/Topic(href, href_list)
	if(..())
		return

	if(!check_rights(R_ADMIN|R_EVENT|R_DEBUG))
		message_admins("[usr] has attempted to modify the Game Master values without being an admin.")
		return

	if(href_list["toggle"])
		can_fire = !can_fire
		message_admins("GM was [!can_fire ? "dis" : "en"]abled by [usr.key].")

	if(href_list["toggle_time_restrictions"])
		ignore_time_restrictions = !ignore_time_restrictions
		message_admins("GM event time restrictions was [ignore_time_restrictions ? "dis" : "en"]abled by [usr.key].")

	if(href_list["toggle_chaos_throttle"])
		ignore_round_chaos = !ignore_round_chaos
		message_admins("GM event chaos restrictions was [ignore_round_chaos ? "dis" : "en"]abled by [usr.key].")

	if(href_list["force_choose_event"])
		start_action()
		message_admins("[usr.key] forced the Game Master to choose an event immediately.")

	if(href_list["set_staleness"])
		var/amount = input(usr, "How much staleness should there be?", "Game Master") as null|num
		if(!isnull(amount))
			staleness = amount
			message_admins("GM staleness was set to [amount] by [usr.key].")

	if(href_list["set_danger"])
		var/amount = input(usr, "How much danger should there be?", "Game Master") as null|num
		if(!isnull(amount))
			danger = amount
			message_admins("GM danger was set to [amount] by [usr.key].")

	interact(usr) // To refresh the UI.