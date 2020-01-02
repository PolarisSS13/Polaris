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

	if(get_game_day() > 27)
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

/datum/controller/subsystem/elections/proc/getcandidatenames()
	var/list/names = list()
	for(var/datum/president_candidate/C in political_candidates)
		names += C.name

	return names

/datum/controller/subsystem/elections/proc/getformernames()
	var/list/names = list()
	for(var/datum/president_candidate/C in former_candidates)
		names += C.name

	return names

/datum/controller/subsystem/elections/proc/SetNewPresident(var/debug = 0)

	if(!debug)
		if(!last_election_date)
			last_election_date = full_game_time()
			return 0

		if(!(Days_Difference(last_election_date , full_game_time() ) > 28 && is_election_day(get_game_day()) ))
	//		message_admins("Returned: [get_next_election_month()] vs current month: [get_game_month()] and test day being [get_game_day()]", 1)
			return 0


		if(!political_candidates) //No people running? Either not registration period or no election boys, pack it up - the dictatorship begins.
	//		message_admins("Returned: No candidates available.", 1)
			return 0

	recount_votes()

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
	former_presidents += current_president

	//make way for the new president.
	current_president = winning_vote // make the winning vote the president
	political_candidates -= current_president // remove president from candidate pool

	former_candidates = list() // yet old candidates
	former_candidates = political_candidates
	political_candidates = list() // yeet the current candidates

	//make things fresh for the next election
	last_election_votes = total_votes
	total_votes = 0
	snap_election = 0
	last_election_date = full_game_time()

	if(!current_president) // shouldn't happen, but just in case.
		CheckNoConfidence()

	postelection_news_article()

	// change the prez email so the old president can't get back into the email...
	SSemails.change_persistent_email_password(using_map.president_email, GenerateKey())

	postelection_email()

	return winning_vote

/datum/controller/subsystem/elections/proc/clear_president()
	//clear the current president's votes and make them into a former president
	current_president.no_confidence_votes = list()
	current_president.ckeys_voted = list()
	former_presidents += current_president
	current_president = null

	CheckNoConfidence()
	return 1


/datum/controller/subsystem/elections/proc/recount_votes()
	var/votes = 0
	for(var/datum/president_candidate/PC in political_candidates)
		votes += PC.ckeys_voted.len

	total_votes = votes

	return votes


/datum/controller/subsystem/elections/proc/postelection_email()
	if(!using_map.president_email) return
	if(!current_president) return
	if(!current_president.ckey) return // In case it's NT officials

	var/datum/computer_file/data/email_account/prez_email = get_email(using_map.president_email)

	if(!prez_email) return

	var/datum/computer_file/data/email_message/message = new/datum/computer_file/data/email_message()

	var/eml_cnt


	eml_cnt = "Dear [current_president], \[editorbr\]"


	eml_cnt += "Congratulations on winning the presidential race this month, you are now President of the colony. Your presidency shall last a month, \
	so make the most of it.\[br\] Being a President is an arduous duty with many responsibilities - it involves keeping a colony in line \
	and retaining the appeal of the citizens, during your presidency you must also adhere to the company's guidelines."


	eml_cnt += "You must keep the following in mind at all times:\[br\]"

	eml_cnt += "\[list\] \
	\[*\] Image: Do not debase or slander the corporation in a way that would make it lose credibility in the eyes of our citizens, \
	or to Sol. Our main institution is in Sol, if we lose face on our colony, we lose our most secure footing. Retain as much PR as possible or face removal.\
	\[br\]\[*\] Profit: Do not cause the colony to fall into debt, or allow it to remain in debt. You must sure profits are kept to a healthy level so company \
	growth can continue. You have freedom in what methods you utilize to do this, as long as they are within the charter. \[br\] \
	\[*\] Power: Nanotrasen owns this colony, a president has access to the steering wheel but not the vehicle; ensure that it is kept under control. \
	If agents on the colony try to gain power you must utilize the resources given to you to stop it. Do not form militias to usurp power from Nanotrasen \
	or delibrately cause chaos on the colony. Remember that Nanotrasen has a blue space artiltery - do you? \[/list\]"

	eml_cnt += "\[editorbr\]As president, you are able to modify various aspects of the colony such as taxes, laws, contraband, et cetera, \
	and can do this through the presidential portal. You may also assign a vice president and some ministers to help you get work done in the short \
	time that you have. \[editorbr\]"

	eml_cnt += "\[br\]Your work email is \[b]\[prez_email.login]\[\b]\ and the password is \[b]\[prez_email.password]\[\b]\ - do not share these details. If your account does \
	become compromised, you may request a password change from the Nanotrasen IT department sector, but this will come at a cost of 5,500 credits. \[editorbr\]"

	eml_cnt += "\[br\]As you manage the colony it is important to be mindful of your own image, citizens can vote against you - if thirty no confidence \
	votes are reached you will be removed from your post, please beware.\[editorbr\] We hope you have a fruitful term, and wish you all the best. \[editorbr\] \
	Best Regards, \[editorbr\]Nanotrasen Headquarters"

	eml_cnt = jointext(eml_cnt,null)

	message.stored_data = eml_cnt
	message.title = "Congratulations on Presidency: [current_president.name]"
	message.source = "noreply@nanotrasen.gov.nt"
	message.timestamp = stationtime2text()

	prez_email.send_mail(prez_email.login, message)

	prez_email.save_email()

	return 1


/datum/controller/subsystem/elections/proc/postelection_news_article()

	// Generates a news article on election day. Fluff.

	var/multiple = 0 // if 0, it means the president was the only one running

	var/message
	var/list/electoral_assistants = list("Sana Zheng", "Jason Lake", "Kevin Darbour", "Luke Oath", "Mineral Shay")
	var/list/prospectors = list("were certain that", "believed that", "placed bets hoping that")
	var/list/negative_reaction = list("We were expecting that, to be honest.",
	"Goodness this colony is getting worse.",
	"They always vote for <i>those</i> types.",
	"The system is rigged to hell, let me tell you!",
	"I pressed the wrong button on the voting computer! Can I take it back or no?",
	"Ugh, another month of torture.",
	"I'm not saying I would ever become a terrorist, but <i>if</i> I was a terrorist, they'd be my main target.",
	"My mommy tells me that they eat children and anyone who votes from them is from Sol.",
	"What's the point even voting?!")

	var/list/positive_reaction = list("I've been rooting for them since day one, I'm genuinely happy that they won.",
	"Yes! I fucking won my bet! Hey fellas, let's hit the bar!",
	"Words cannot describe how happy I am that they won. Out of all candidates they really shined the most.",
	"Best of luck to them, for once I can proudly say my vote wasn't wasted. I'd like to think my own vote got them there...",
	"I voted for them because I got dared to. I didn't realise it would actually happen.",
	"Ha! Watch, the colony will get CBA them any time now. By that, I mean, caring, blessing, and assuring.",
	"They just look like someone you could have a beer with...",
	"Oh, I don't know anything about their policies, I just thought they were cute.")

	if(former_candidates.len > 1)
		multiple = 1

	message = "<b>Castor Headquarters: [full_game_time()]</b> - Electoral Assistants of [using_map.boss_name] have counted the final votes and \
	presented the electoral results to all, there were [last_election_votes] total. \
	People from several continents on Pollux watched as the name was pulled from the traditional ballot hat. \
	<br><br>Millions of people gathered in-person to watch the event, others stayed home to observe their televisions and communicator screens \
	as they watch Pollux's moon through their screens. Many [pick(prospectors)] [pick(getformernames())] would win based on the monthly election president website \
	electionpredictions.nt."


	message += "<br><br>The very trustworthy and experienced electoral asssistant, [pick(electoral_assistants)] pulls a piece of paper from the hat, \
	revealing to viewers the winner of the election: <b>[current_president]</b> who won with [current_president.ckeys_voted.len] votes out of [last_election_votes]. \
	It would have appear that the new president's slogan \"[current_president.slogan]\" resonated with the populace.<br><br>"

	message += "[random_name(pick("male","female"), SPECIES_HUMAN)] from [pick(citizenship_choices)] commented, \"[pick(positive_reaction)]\", many citizens were \
	very pleased with the results. Some however, were not as happy. A [pick(citizenship_choices)] civilian, [random_name(pick("male","female"), SPECIES_HUMAN)], commented on live television,\
	 \"[pick(negative_reaction)]\". <br><br>Regardless of the mixed views, many await the [current_president]'s inaugeration to see how they will deliver on their promises."

	if(multiple)
		message += "<br><br>Prompty shown on a digital screen were the names: "
		for(var/N in getformernames())
			message += "[N], "

		message += "and then followed by the name of the president, [current_president.name], in big bold letters, perhaps a symbolic show of their defeat.<br>"


	message += "<br><br><b>Full Results:</b><br>"
	for(var/datum/president_candidate/PC in former_candidates)
		message += "<b>[PC.name]</b> - [PC.ckeys_voted.len] votes(s)<br>"

	news_network.SubmitArticle(message, pick(electoral_assistants), "Geminus Standard", null, null, "", "[current_president.name] Wins [get_month_from_num(get_game_month())] [get_game_year()] Election with [current_president.ckeys_voted.len] Votes Out of [last_election_votes]")
	news_data.save_main_news()

	return 1

//Testing only.
/*
/hook/startup/proc/populate_election()
	var/datum/president_candidate/M = new /datum/president_candidate()
	var/datum/president_candidate/L = new /datum/president_candidate()
	var/datum/president_candidate/P = new /datum/president_candidate()
	var/datum/president_candidate/S = new /datum/president_candidate()

	M.name = "Nyla Cooper"
	M.ckey = "basicbitch"
	M.ckeys_voted = list("superman","niceone")

	L.name = "Jeremy Hunt"
	L.ckey = "mastertoker"
	L.ckeys_voted = list("angelbaker")

	P.name = "Neem Khan"
	P.ckey = "funnylover"
	P.ckeys_voted = list("angelbaker", "oops", "bam", "shoo shoo")

	S.name = "Rue Root"
	S.ckey = "rootbeer"
	S.ckeys_voted = list()	// oof

	SSelections.political_candidates += L
	SSelections.political_candidates += M
	SSelections.political_candidates += P
	SSelections.political_candidates += S

	return 1
*/


