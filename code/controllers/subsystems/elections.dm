//
// Handles initialization of political parties and assigning presidents on the server.
//



SUBSYSTEM_DEF(elections)
	name = "Elections"
	init_order = INIT_ORDER_ELECTIONS
	flags = SS_NO_FIRE

/datum/controller/subsystem/elections/Initialize(timeofday)
	SetupPolitics()
	save_data = new /datum/economy/elections

	if(!save_data.load_candidates())
		save_data.save_candidates()

	..()

/datum/controller/subsystem/elections
	var/datum/economy/elections/save_data

	var/list/datum/president_candidate/political_candidates = list()

	var/total_votes = 0
	var/last_election_votes = 0

	var/datum/president_candidate/current_president		// The head honcho
	var/datum/president_candidate/vice_president		// His bitch

	var/list/datum/president_candidate/former_presidents = list()
	var/list/datum/president_candidate/former_candidates = list()

	var/snap_election


/datum/president_candidate
	var/name = "Anonymous Candidate"
	var/unique_id
	var/ckey
	var/datum/party/polticial_party
	var/slogan = "Vote for me!"
	var/pitch = "Make Pollux Great Again."
	var/list/ckeys_voted = list()
	var/list/no_confidence_votes = list()
	var/party


/datum/controller/subsystem/elections/proc/is_registration_days(day)
	switch(day)
		if(10 to 16)
			return TRUE

/datum/controller/subsystem/elections/proc/is_campaign_days(day)
	switch(day)
		if(17 to 20)
			return TRUE

/datum/controller/subsystem/elections/proc/is_voting_days(day)
	switch(day)
		if(21 to 27)
			return TRUE

/datum/controller/subsystem/elections/proc/is_election_day(day)
	switch(day)
		if(28)
			return TRUE

/datum/controller/subsystem/elections/proc/get_next_election_month()
	var/info

	if(get_game_day() > 28)
		if(get_game_month() == 12) // If it's december, the next year will be January.
			info = 1
		else
			info = get_game_month() + 1 // Otherwise it's just the next month.
	else
		info = get_game_month()

	return info

/datum/controller/subsystem/elections/proc/get_president()
	return "<b>[SSelections.current_president.name]</b> - Played by </b>[SSelections.current_president.ckey]</b> (Won [SSelections.current_president.ckeys_voted.len] out of [SSelections.last_election_votes].)"

/proc/get_president_info()
	var/info
	if(SSelections)
		info = "The current democratically voted president is [SSelections.get_president()]. \
		Presidential Elections are IC'ly done and player chosen, you can vote for a new president \
		via the ballot boxes or applying for presidency online via the computers in-game.\
		<br>\
		The next registration day will be on [get_month_from_num(SSelections.get_next_election_month())] 10th, \
		and election day will be on [get_month_from_num(SSelections.get_next_election_month())] 28th."
	else
		info = "<b>No presidential info available at this time.</b>"

	return info

/datum/controller/subsystem/elections/proc/SetupPolitics()
	CheckNoConfidence()
	SetNewPresident()

/datum/controller/subsystem/elections/proc/GetLastElectionTotalVotes()
	var/votes = 0
	for(var/datum/president_candidate/cand in former_candidates)
		if(cand.ckeys_voted)
			votes += cand.ckeys_voted.len

	if(current_president.ckeys_voted)
		votes += current_president.ckeys_voted.len

	return votes


/datum/controller/subsystem/elections/proc/CheckNoConfidence()
	if(!current_president) // This shouldn't happen except for when you start the same anew.
		snap_election = 1
		if(!vice_president)
			current_president = new/datum/president_candidate()
			current_president.name = "NanoTrasen Officials"
		else
			current_president = vice_president

		return 1

	if(current_president && current_president.no_confidence_votes)
		if(current_president.no_confidence_votes.len > 29)
			snap_election = 1
			former_presidents += current_president
			if(!vice_president)
				current_president = new/datum/president_candidate()
				current_president.name = "NanoTrasen Officials"
			else
				current_president = vice_president
			return 1

/datum/controller/subsystem/elections/proc/SetNewPresident()
	if(!(get_next_election_month() == get_game_month() && get_game_day() > 27))
//		message_admins("Returned: [get_next_election_month()] vs current month: [get_game_month()] and test day being [get_game_day()]", 1)
		return 0


	if(!political_candidates) //No people running? Either not registration period or no election boys, pack it up - the dictatorship begins.
//		message_admins("Returned: No candidates available.", 1)
		return 0

	var/list/highest_voted = list()
	var/list/datum/president_candidate/winning_vote
	var/highest_vote = 0


	for(var/datum/president_candidate/option in political_candidates)
		if(option.ckeys_voted.len)
			var/votes = 0

			votes = option.ckeys_voted.len

			if(votes > highest_vote)
				highest_vote = votes
				highest_voted = option


	if(!highest_voted)
//		message_admins("No candidates returned from draw.", 1)
		return 0

	winning_vote = highest_voted

	if(winning_vote)
//		message_admins("Picked [winning_vote.name] as winning vote.", 1)
	else
		message_admins("ERROR: No winning vote chosen at election.", 1)
		return 0


	//get rid of all votes so things are fresh again for next time.
	for(var/datum/president_candidate/PC in political_candidates)
		PC.ckeys_voted = null

	former_presidents += current_president // make the current president into the former president

	current_president.no_confidence_votes = null // fuck em
	current_president = winning_vote // make the winning vote the president


	political_candidates -= current_president // remove president from candidate pool

	former_candidates = political_candidates // make the current candidates into the former ones.
	political_candidates = null // yeet the current candidates

	last_election_votes = total_votes
	total_votes = 0
	snap_election = 0

	if(!current_president)
		CheckNoConfidence()

	return 1

//Testing only.
/*
/hook/startup/proc/populate_election()
	var/datum/president_candidate/M = new /datum/president_candidate()
	var/datum/president_candidate/L = new /datum/president_candidate()

	M.name = "Nyla Cooper"
	M.ckey = "basicbitch"
	M.ckeys_voted = list("superman","niceone")

	L.name = "Jeremy Hunt"
	L.ckey = "mastertoker"
	L.ckeys_voted = list("angelbaker")

	SSelections.political_candidates += L
	SSelections.political_candidates += M

	return 1

*/

