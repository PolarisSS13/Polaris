// This is a sort of successor to the various event systems created over the years.  It is designed to be just a tad smarter than the
// previous ones, checking various things like player count, department size and composition, individual player activity,
// individual player (IC) skill, and such, in order to try to choose the best events to take in order to add spice or variety to
// the round.

// This subsystem holds the logic that chooses events. Actual event processing is handled in a seperate subsystem.
SUBSYSTEM_DEF(game_master)
	name = "Events (Game Master)"
	wait = 1 MINUTE
	runlevels = RUNLEVEL_GAME

	// The GM object is what actually chooses events.
	// It's held in a seperate object for better encapsulation, and allows for different 'flavors' of GMs to be made, that choose events differently.
	var/datum/game_master/GM = null
	var/game_master_type = /datum/game_master/default

	var/list/available_events = list() // A list of meta event objects.

	var/danger = 0						// The GM's best guess at how chaotic the round is.  High danger makes it hold back.
	var/staleness = -20					// Determines liklihood of the GM doing something, increases over time.

	var/next_event = 0								// Minimum amount of time of nothingness until the GM can pick something again.

	var/debug_messages = FALSE // If true, debug information is written to `log_debug()`.

/datum/controller/subsystem/game_master/Initialize()
	var/list/subtypes = subtypesof(/datum/event2/meta)
	for(var/T in subtypes)
		var/datum/event2/meta/M = new T(src)
		if(!M.name)
			continue
		available_events += M

	GM = new game_master_type(src)

	if(config && !config.enable_game_master)
		can_fire = FALSE

	// Remove when finished.
	debug_gm()

	return ..()

/datum/controller/subsystem/game_master/fire(resumed)
	adjust_staleness(1)
	adjust_danger(-1)

	var/global_afk = metric.assess_all_living_mobs()
	global_afk = abs(global_afk - 100)
	global_afk = round(global_afk / 100, 0.1)
	adjust_staleness(global_afk) // Staleness increases faster if more people are less active.

	if(GM.ignore_time_restrictions || next_event < world.time)
		if(prob(staleness) && pre_event_checks())
			do_event_decision()


/datum/controller/subsystem/game_master/proc/do_event_decision()
	log_game_master("Going to choose an event.")
	var/datum/event2/meta/event_picked = GM.choose_event()
	if(event_picked)
		run_event(event_picked)
		next_event = world.time + rand(GM.decision_cooldown_lower_bound, GM.decision_cooldown_upper_bound)

/datum/controller/subsystem/game_master/proc/debug_gm()
	can_fire = TRUE
	staleness = 100
	debug_messages = TRUE

/datum/controller/subsystem/game_master/proc/run_event(datum/event2/meta/chosen_event)
	var/datum/event2/event/E = chosen_event.make_event()
	SSevent_ticker.event_started(E)
	adjust_danger(chosen_event.chaos)
	adjust_staleness(-(10 + chosen_event.chaos)) // More chaotic events reduce staleness more, e.g. a 25 chaos event will reduce it by 35.


// Tell the game master that something dangerous happened, e.g. someone dying, station explosions.
/datum/controller/subsystem/game_master/proc/adjust_danger(amount)
	amount *= GM.danger_modifier
	danger = round(between(0, danger + amount, 1000), 0.1)

// Tell the game master that things are getting boring if positive, or something interesting if negative..
/datum/controller/subsystem/game_master/proc/adjust_staleness(amount)
	amount *= GM.staleness_modifier
	staleness = round( between(-20, staleness + amount, 100), 0.1)

// These are ran before committing to an event.
// Returns TRUE if the system is allowed to procede, otherwise returns FALSE.
/datum/controller/subsystem/game_master/proc/pre_event_checks(quiet = FALSE)
	if(!ticker || ticker.current_state != GAME_STATE_PLAYING)
		if(!quiet)
			log_game_master("Unable to start event: Ticker is nonexistant, or the game is not ongoing.")
		return FALSE
	if(GM.ignore_time_restrictions)
		return TRUE
	if(next_event > world.time) // Sanity.
		if(!quiet)
			log_game_master("Unable to start event: Time until next event is approximately [round((next_event - world.time) / (1 MINUTE))] minute(s)")
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
			log_game_master("Unable to start event: It is too late.")
		return FALSE
	return TRUE

/datum/controller/subsystem/game_master/proc/choose_game_master(mob/user)
	var/list/subtypes = subtypesof(/datum/game_master)
	var/new_gm_path = input(user, "What kind of Game Master do you want?", "New Game Master", /datum/game_master/default) as null|anything in subtypes
	if(new_gm_path)
		log_and_message_admins("has swapped the current GM ([GM.type]) for a new GM ([new_gm_path]).")
		GM = new new_gm_path(src)

/datum/controller/subsystem/game_master/proc/log_game_master(message)
	if(debug_messages)
		log_debug("GAME MASTER: [message]")


// This object makes the actual decisions.
/datum/game_master
	var/datum/controller/subsystem/game_master/ticker = null
	// Multiplier for how much 'danger' is accumulated. Higer generally makes it possible for more dangerous events to be picked.
	var/danger_modifier = 1.0

	// Ditto.  Higher numbers generally result in more events occuring in a round.
	var/staleness_modifier = 1.0

	var/decision_cooldown_lower_bound = 5 MINUTES	// Lower bound for how long to wait until -the potential- for another event being decided.
	var/decision_cooldown_upper_bound = 20 MINUTES	// Same, but upper bound.

	var/ignore_time_restrictions = FALSE 	// Useful for debugging without needing to wait 20 minutes each time.
	var/ignore_round_chaos = FALSE			// If true, the system will happily choose back to back intense events like meteors and blobs, Dwarf Fortress style.

/datum/game_master/New(datum/controller/subsystem/game_master/new_ticker)
	ticker = new_ticker

// Push button, receive event.
// Returns a selected event datum.
/datum/game_master/proc/choose_event()

/datum/game_master/proc/log_game_master(message)
	SSgame_master.log_game_master(message)

// The default game master tries to choose events with these goals in mind.
// * Don't choose an event if the crew can't take it. E.g. no meteors after half of the crew died.
// * Try to involve lots of people, particuarly in active departments.
// * Avoid giving events to the same department multiple times in a row.
/datum/game_master/default
	// If an event was done for a specific department, it is written here, so it doesn't do it again.
	var/last_department_used = null


/datum/game_master/default/choose_event()
	log_game_master("Now starting event decision.")

	var/list/most_active_departments = metric.assess_all_departments(3, list(last_department_used))
	var/list/best_events = decide_best_events(most_active_departments)

	if(LAZYLEN(best_events))
		log_game_master("Got [best_events.len] choice\s for the next event.")
		var/list/weighted_events = list()

		for(var/E in best_events)
			var/datum/event2/meta/event = E
			weighted_events[event] = event.get_weight()

		var/datum/event2/meta/choice = pickweight(weighted_events)

		if(choice)
			log_game_master("[choice.name] was chosen, and is now being ran.")
			last_department_used = LAZYACCESS(choice.departments, 1)
			return choice

/datum/game_master/default/proc/decide_best_events(list/most_active_departments)
	if(!LAZYLEN(most_active_departments)) // Server's empty?
		log_game_master("Game Master failed to find any active departments.")
		return list()

	var/list/best_events = list()
	if(most_active_departments.len >= 2)
		var/list/top_two = list(most_active_departments[1], most_active_departments[2])
		best_events = filter_events_by_departments(top_two)

		if(LAZYLEN(best_events)) // We found something for those two, let's do it.
			return best_events

	// Otherwise we probably couldn't find something for the second highest group, so let's ignore them.
	best_events = filter_events_by_departments(most_active_departments[1])

	if(LAZYLEN(best_events))
		return best_events

	// At this point we should expand our horizons.
	best_events = filter_events_by_departments(list(DEPARTMENT_EVERYONE))

	if(LAZYLEN(best_events))
		return best_events

	// Just give a random event if for some reason it still can't make up its mind.
	best_events = filter_events_by_departments()

	if(LAZYLEN(best_events))
		return best_events

	log_game_master("Game Master failed to find a suitable event, something very wrong is going on.")
	return list()

// Filters the available events down to events for specific departments.
// Pass DEPARTMENT_EVERYONE if you want events that target the general population, like gravity failure.
// If no list is passed, all the events will be returned.
/datum/game_master/default/proc/filter_events_by_departments(list/departments)
	. = list()
	for(var/E in ticker.available_events)
		var/datum/event2/meta/event = E
		if(!event.enabled)
			continue
		if(event.chaotic_threshold && !ignore_round_chaos)
			if(ticker.danger > event.chaotic_threshold)
				continue
		// An event has to involve all of these departments to pass.
		var/viable = TRUE
		if(LAZYLEN(departments))
			for(var/department in departments)
				if(!LAZYFIND(departments, department))
					viable = FALSE
					break
		if(viable)
			. += event


// The `old_like` game master tries to act like the old system, choosing events without any specific goals.
// * Has no goals, and instead operates purely off of the weights of the events it has.
// * Does not react to danger at all.
/datum/game_master/old_like/choose_event()
	var/list/weighted_events = list()
	for(var/E in ticker.available_events)
		var/datum/event2/meta/event = E
		weighted_events[event] = event.get_weight()

	var/datum/event2/meta/choice = pickweight(weighted_events)

	if(choice)
		log_game_master("[choice.name] was chosen, and is now being ran.")
		return choice

// The `super_random` game master chooses events purely at random, ignoring weights entirely.
// * Has no goals, and instead chooses randomly, ignoring weights.
// * Does not react to danger at all.
/datum/game_master/super_random/choose_event()
	return pick(ticker.available_events)

// The `brutal` game master tries to run dangerous events frequently.
// * Chaotic events have their weights artifically boosted.
// * Ignores accumulated danger.
/datum/game_master/brutal
	ignore_round_chaos = TRUE

/datum/game_master/brutal/choose_event()
	var/list/weighted_events = list()
	for(var/E in ticker.available_events)
		var/datum/event2/meta/event = E
		weighted_events[event] = event.get_weight() + (event.chaos * 2)

	var/datum/event2/meta/choice = pickweight(weighted_events)

	if(choice)
		log_game_master("[choice.name] was chosen, and is now being ran.")
		return choice

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

	// Swaps out the current GM for a new one with different ideas on what a good event might be.
	dat += href(src, list("change_gm" = 1), "\[Change GM\]")
	dat += "<br>"

	dat += "Current GM Type: [GM.type]<br>"
	dat += "State: [can_fire ? "Active": "Inactive"]<br>"
	dat += "Status: [pre_event_checks(TRUE) ? "Ready" : "Suppressed"]<br><br>"

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

	dat += "<h2>Events available:</h2>"

	dat += "<table border='1' style='width:100%'>"
	dat += "<tr>"
	dat += "<th>Event Name</th>"
	dat += "<th>Involved Departments</th>"
	dat += "<th>Chaos</th>"
	dat += "<th>Current Weight</th>"
	dat += "<th>Buttons</th>"
	dat += "</tr>"

	for(var/E in available_events)
		var/datum/event2/meta/event = E
		dat += "<tr>"
		if(!event.enabled)
			dat += "<td><strike>[event.name]</strike></td>"
		else
			dat += "<td>[event.name]</td>"
		dat += "<td>[english_list(event.departments)]</td>"
		dat += "<td>[event.chaos]</td>"
		dat += "<td>[event.get_weight()]</td>"
		dat += "<td>[href(event, list("force" = 1), "\[Force\]")] [href(event, list("toggle" = 1), "\[Toggle\]")]</td>"
		dat += "</tr>"
	dat += "</table>"

	dat += "<h2>Events active:</h2>"

	dat += "Current time: [world.time]"
	dat += "<table border='1' style='width:100%'>"
	dat += "<tr>"
	dat += "<th>Event Type</th>"
	dat += "<th>Time Started</th>"
	dat += "<th>Time to Announce</th>"
	dat += "<th>Time to End</th>"
	dat += "<th>Announced</th>"
	dat += "<th>Started</th>"
	dat += "<th>Ended</th>"
	dat += "<th>Buttons</th>"
	dat += "</tr>"

	for(var/E in SSevent_ticker.active_events)
		var/datum/event2/event/event = E
		dat += "<tr>"
		dat += "<td>[event.type]</td>"
		dat += "<td>[event.time_started]</td>"
		dat += "<td>[event.time_to_announce ? event.time_to_announce : "NULL"]</td>"
		dat += "<td>[event.time_to_end ? event.time_to_end : "NULL"]</td>"
		dat += "<td>[event.announced ? "Yes" : "No"]</td>"
		dat += "<td>[event.started ? "Yes" : "No"]</td>"
		dat += "<td>[event.ended ? "Yes" : "No"]</td>"
		dat += "<td>[href(event, list("abort" = 1), "\[Abort\]")]</td>"
		dat += "</tr>"
	dat += "</table>"
	dat += "</body></html>"

	dat += "<h2>Events completed:</h2>"

	dat += "<table border='1' style='width:100%'>"
	dat += "<tr>"
	dat += "<th>Event Type</th>"
	dat += "<th>Start Time</th>"
	dat += "<th>Finish Time</th>"
	dat += "</tr>"

	for(var/E in SSevent_ticker.finished_events)
		var/datum/event2/event/event = E
		dat += "<tr>"
		dat += "<td>[event.type]</td>"
		dat += "<td>[event.time_started]</td>"
		dat += "<td>[event.time_finished]</td>"
		dat += "</tr>"

	dat += "</body></html>"

	var/datum/browser/popup = new(user, "game_master_debug", "Automated Game Master Event System", 800, 500, src)
	popup.set_content(dat.Join())
	popup.open()


/datum/controller/subsystem/game_master/Topic(href, href_list)
	if(..())
		return

	if(href_list["close"]) // Needed or the window re-opens after closing, making it last forever.
		return

	if(!check_rights(R_ADMIN|R_EVENT|R_DEBUG))
		message_admins("[usr] has attempted to modify the Game Master values without sufficent privilages.")
		return

	if(href_list["toggle"])
		can_fire = !can_fire
		message_admins("GM was [!can_fire ? "dis" : "en"]abled by [usr.key].")

	if(href_list["toggle_time_restrictions"])
		GM.ignore_time_restrictions = !GM.ignore_time_restrictions
		message_admins("GM event time restrictions was [GM.ignore_time_restrictions ? "dis" : "en"]abled by [usr.key].")

	if(href_list["toggle_chaos_throttle"])
		GM.ignore_round_chaos = !GM.ignore_round_chaos
		message_admins("GM event chaos restrictions was [GM.ignore_round_chaos ? "dis" : "en"]abled by [usr.key].")

	if(href_list["force_choose_event"])
		do_event_decision()
		message_admins("[usr.key] forced the Game Master to choose an event immediately.")

	if(href_list["change_gm"])
		choose_game_master(usr)

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