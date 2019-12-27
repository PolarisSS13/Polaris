
/obj/machinery/ballot_box
	name = "ballot box"
	desc = "The one object used to rise people to the presidential throne. Use wisely."
	icon = 'icons/obj/democracy.dmi'
	icon_state = "ballot"
	density = 1
	anchored = 1

	var/voting_period_only = TRUE			// If set to true, you can only use this during election period.


/obj/machinery/ballot_box/interact(mob/living/carbon/human/H)
	var/real_name = H.real_name
	var/ckey
	var/has_voted
	var/no_confidence_voted
	var/eligible = 1

	if(H.client)
		ckey = H.ckey

	var/dat = "<h1>Official Voting Ballot</h1>"
	dat += "<i>All votes matter, [real_name]</i>. This is one of the many Polluxian ballot boxes vital to this election. <p>Here, you may place <b>one</b> vote for a candidate you believe should be the next president during the voting period during the 21st to the 27th. Your votes are anonymous.<br>"

	if(get_dist(src,H) <= 1)
		if(SSelections && SSelections.current_president)
			for(var/datum/president_candidate/P in SSelections.political_candidates)
				if(ckey in P.ckeys_voted)
					has_voted = 1
					break

			//eligibility
			if(is_voting_eligible(H))
				eligible = 0

			if(ckey in SSelections.current_president.no_confidence_votes)
				no_confidence_voted = 1

			if(SSelections.current_president)
				dat += "The current president is <b>[SSelections.current_president.name]</b>.<br>"

			if(SSelections.is_registration_days(get_game_day()))
				dat += "<br>Registration period is in effect, people can register to be a candidate via the \"Presidential Candidate Registration\" program available on public and private computers."

				if(SSelections.political_candidates)
					dat += "<h3>Currently Registered Candidates for [get_month_from_num(get_game_month())] [get_game_year()]:</h3><hr>"
					for(var/datum/president_candidate/P in SSelections.political_candidates)
						dat += "<h4>[P.name]</h4> - <i>[P.slogan]</i><p>"
						dat += "I will:</b> \"[P.pitch]\"<br><hr><br>"
				else
					dat += "<b>No political candidates registered.</b> "

			else if(!SSelections.snap_election && SSelections.is_campaign_days(get_game_day()))
				dat += "<br>It is currently campaign period. <i>No further registrations can be registered at this time.</i> Voting starts on the 21st to the 27th.<p>"

				dat += "<h3>Currently Registered Candidates for [get_month_from_num(get_game_month())] [get_game_year()]:</h3><hr>"
				if(SSelections.political_candidates)
					for(var/datum/president_candidate/P in SSelections.political_candidates)
						dat += "<b>[P.name]</b> - <i>[P.slogan]</i><p>"
						dat += "<br>I will:</b> \"[P.pitch]\"<br><hr>"
				else
					dat += "<b>No political candidates registered.</b>"

			else if(SSelections.is_voting_days(get_game_day()))
				dat += "<h3>List of Candidates for [get_month_from_num(get_game_month())] [get_game_year()]:</h3><hr>"

				for(var/datum/president_candidate/P in SSelections.political_candidates)
					dat += "<h4>[P.name]</h4> - <i>[P.slogan]</i><p>"
					dat += "<b>I will:</b> \"[P.pitch]\"<br><hr>"
					if(!has_voted && eligible)
						dat += "<br><a href='?src=\ref[src];vote=1;candidate=\ref[P]'>Vote for [P.name]</a><hr>"
				if(!eligible)
					dat += "<br><i>You currently do not qualify for voting as you do not possess the legal rights to do so.</i>"

			else if(SSelections.snap_election)
				dat += "<h4>A snap election is in progress.</h4>"

				dat += "<h3>List of Candidates for [get_month_from_num(get_game_month())] [get_game_year()]:</h3><hr>"
				if(SSelections.political_candidates)
					for(var/datum/president_candidate/P in SSelections.political_candidates)
						dat += "<h4>[P.name]</h4> - <i>[P.slogan]</i><p>"
						dat += "<b>I will:</b> \"[P.pitch]\"<br>"
						if(!has_voted && eligible)
							dat += "<br><a href='?src=\ref[src];vote=1;candidate=\ref[P]'>Vote for [P.name]</a><hr>"
				else
					dat += "<b>No political candidates registered.</b>"

				if(!eligible)
					dat += "<br><i>You currently do not qualify for voting as you do not possess the legal rights to do so.</i>"

			else if(SSelections.is_election_day(get_game_day()))
				dat += "<br><center>Election day is here. The <i>new</i> elected president is:<br>"
				dat += "<h1>[SSelections.current_president.name]</h1><p>"
				if(SSelections.current_president.ckeys_voted)
					dat += "(Won [SSelections.current_president.ckeys_voted.len] out of [SSelections.last_election_votes] votes.)</center>"
			else
				dat += "<h3>Candidates that ran this election:</h3><hr>"
				for(var/datum/president_candidate/P in SSelections.political_candidates)
					dat += "<b>[P.name]</b> - <i>[P.slogan]</i><p>"

				dat += "<br>Currently there is no election in progress. Candidate registration periods start on the <b>10th</b> of every month."

			if(!SSelections.snap_election)
				if(SSelections.current_president.no_confidence_votes)
					dat += "<hr><h3>Vote of No Confidence/Impeachment:</h3><p>"
					if(SSelections.current_president.no_confidence_votes.len)
						dat += "<p>A <b>vote of no confidence</b> has been raised against [SSelections.current_president.name] to be impeached. This is completely anonymous."
					dat += "<p>At present, there are <b>[SSelections.current_president.no_confidence_votes.len]</b>."
					dat += "<p>If this reaches 30, [SSelections.current_president.name] will be removed from office, and the Vice President (if any) will take over - if there is no Vice, a new election will occur.</b>"
					if(!no_confidence_voted)
						dat += "<br><a href='?src=\ref[src];no_confidence=1;votee=\ref[SSelections.current_president]'>Vote \"No Confidence\" against [SSelections.current_president.name]</a>"
					else
						dat += "<b>You already have a no confidence vote raised against [SSelections.current_president.name].</b>"

				else
					dat += "<p>It is within the citizen rights to vote a vote of no confidence against a president. If you gain 30 votes, they will be removed from presidency."
					dat += "<br><a href='?src=\ref[src];no_confidence=1;votee=\ref[SSelections.current_president]'>Vote \"No Confidence\" against [SSelections.current_president.name]</a>"

			if(has_voted)
				dat += "<hr>Thank <b>you</b> for taking part in the election by voting. Your vote matters!"

			dat += "<hr><b>OOC Note:</b> One vote per ckey only."
		else
			dat += "<br>No election data found."

		var/datum/browser/popup = new(usr, "voting", "[src]", 550, 650, src)
		popup.set_content(jointext(dat,null))
		popup.open()

		onclose(usr, "voting")


/obj/machinery/ballot_box/attack_hand(mob/user as mob)
	add_fingerprint(usr)

	if(istype(user, /mob/living/silicon))
		to_chat (user, "<span class='warning'>A firewall prevents you from interfacing with this device!</span>")
		return

	interact(user)


/obj/machinery/ballot_box/Topic(var/href, var/href_list)
	if(..())
		return 1

	if(href_list["no_confidence"])
		if(!Adjacent(usr)) return

		var/list/datum/president_candidate/prez = locate(href_list["votee"])
		if(!prez)
			to_chat(usr, SPAN_WARNING("ERROR: Somehow, no president exists."))
			return

		for(var/P in SSelections.current_president.no_confidence_votes)
			if(usr.client.ckey == P)
				to_chat(usr, SPAN_WARNING("You cannot vote as you have already voted."))
				return

		if("No" == alert(usr, "Vote a vote of no confidence against [prez.name]?", "Vote Against a President", "No", "Yes"))
			to_chat(usr, SPAN_WARNING("You decide not to ruin [prez.name]'s whole career."))
			return
		else
			prez.no_confidence_votes += usr.client.ckey
			SSelections.CheckNoConfidence()

	if(href_list["vote"])

		if(!Adjacent(usr)) return

		var/list/datum/president_candidate/candidate = locate(href_list["candidate"])

		if(!candidate)
			to_chat(usr, SPAN_WARNING("ERROR: This candidate does not exist."))
			return

		for(var/datum/president_candidate/P in SSelections.political_candidates)
			if(usr.client.ckey in P.ckeys_voted)
				to_chat(usr, SPAN_WARNING("You cannot vote as you have already voted."))

				return


		if("No" == alert(usr, "Vote for [candidate.name]? Once this is done this CANNOT be undone.", "Vote for President", "No", "Yes"))
			to_chat(usr, SPAN_WARNING("You decide to refrain participating in the system for now."))
			return
		else
			log_election(usr, candidate.name)
			candidate.ckeys_voted += usr.client.ckey
			SSelections.recount_votes()

	updateDialog()


