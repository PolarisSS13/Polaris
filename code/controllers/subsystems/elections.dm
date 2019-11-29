//
// Handles initialization of political parties and assigning presidents on the server.
//

var/global/list/government_emails = list("president@nanotrasen.gov.nt", "vice-president@nanotrasen.gov.nt")

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

	var/last_election_date

	var/president_email


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
	var/prez
	if(SSelections.current_president && current_president.ckey)
		prez = "<b>[SSelections.current_president.name]</b> - Played by </b>[SSelections.current_president.ckey]</b> (Won [SSelections.current_president.ckeys_voted.len] out of [SSelections.last_election_votes].)"
	return prez

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


/datum/controller/subsystem/elections/proc/SetupEmails()
	//makes sure an email exists for these emails.
	for(var/E in government_emails)
		if(!check_persistent_email(E))
			new_persistent_email(E)

/datum/controller/subsystem/elections/proc/CheckNoConfidence()
	if(!current_president) // This shouldn't happen except for when you start the same anew.
		snap_election = 1
		if(!vice_president)
			current_president = new/datum/president_candidate()
			current_president.name = "NanoTrasen"
		else
			current_president = vice_president
			vice_president = null

		return 1

	if(current_president && current_president.no_confidence_votes)
		if(current_president.no_confidence_votes.len > 29)
			snap_election = 1
			former_presidents += current_president
			if(!vice_president)
				current_president = new/datum/president_candidate()
				current_president.name = "NanoTrasen"
			else
				current_president = vice_president
				vice_president = null
			return 1

/datum/controller/subsystem/elections/proc/SetNewPresident()
	if(!last_election_date)
		last_election_date = full_game_time()
		return 0

	if(!(Days_Difference(last_election_date , full_game_time() ) > 28 && is_election_day(get_game_day()) ))
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

	if(!winning_vote)
//		message_admins("ERROR: No winning vote chosen at election.", 1)
		return 0


//	message_admins("Picked [winning_vote.name] as winning vote.", 1)

	//clear the current president's votes and make them into a former president
	current_president.no_confidence_votes = list()
	current_president.ckeys_voted = list()
	former_presidents += current_president

	//make way for the new president.
	current_president = winning_vote // make the winning vote the president
	political_candidates -= current_president // remove president from candidate pool


	//get rid of all votes and candidates
	for(var/datum/president_candidate/PC in political_candidates)
		PC.ckeys_voted = list()
	former_candidates += political_candidates
	political_candidates = list() // yeet the current candidates

	//make things fresh for the next election
	last_election_votes = total_votes
	total_votes = 0
	snap_election = 0
	last_election_date = full_game_time()

	if(!current_president) // shouldn't happen, but just in case.
		CheckNoConfidence()

	return 1

/datum/controller/subsystem/elections/proc/clear_president()
	//clear the current president's votes and make them into a former president
	current_president.no_confidence_votes = list()
	current_president.ckeys_voted = list()
	former_presidents += current_president
	current_president = null

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
