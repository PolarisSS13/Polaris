/datum/economy/elections
	var/path = "data/persistent/elections.sav"

	var/list/datum/president_candidate/political_candidates = list()

	var/snap_election
	var/total_votes = 0
	var/last_election_votes = 0

	var/datum/president_candidate/current_president		// The head honcho
	var/datum/president_candidate/vice_president		// His bitch

	var/list/datum/president_candidate/former_presidents = list()
	var/list/datum/president_candidate/former_candidates = list()




/datum/economy/elections/proc/save_candidates()
//	message_admins("SAVE: Save all department accounts.", 1)
	if(!path)				return 0
	var/savefile/S = new /savefile(path)
	if(!fexists(path))		return 0
	if(!S)					return 0
	S.cd = "/"

	if(!SSelections)
		return

	total_votes = SSelections.total_votes
	last_election_votes = SSelections.last_election_votes
	snap_election = SSelections.snap_election

	current_president = SSelections.current_president
	political_candidates = SSelections.political_candidates
	vice_president = SSelections.vice_president
	former_presidents = SSelections.former_presidents
	former_candidates = SSelections.former_candidates

	S["total_votes"] << total_votes
	S["last_election_votes"] << last_election_votes
	S["snap_election"] << snap_election
	S["current_president"] << current_president
	S["political_candidates"] << political_candidates
	S["vice_president"] << vice_president
	S["former_presidents"] << former_presidents
	S["former_candidates"] << former_candidates

	message_admins("Saved election data.", 1)
	return 1

/datum/economy/elections/proc/load_candidates()
//	message_admins("BEGIN: Loaded all department accounts.", 1)
	if(!path)				return 0
	if(!fexists(path))
		save_candidates()
		return 0
	var/savefile/S = new /savefile(path)
	if(!S)					return 0
	S.cd = "/"


	S["total_votes"] >> total_votes
	S["last_election_votes"] >> last_election_votes
	S["snap_election"] >> snap_election
	S["current_president"] >> current_president
	S["political_candidates"] >> political_candidates
	S["vice_president"] >> vice_president
	S["former_presidents"] >> former_presidents
	S["former_candidates"] >> former_candidates

	SSelections.total_votes = total_votes
	SSelections.last_election_votes = last_election_votes
	SSelections.snap_election = snap_election

	SSelections.current_president = current_president
	SSelections.political_candidates = political_candidates
	SSelections.vice_president = vice_president
	SSelections.former_presidents = former_presidents
	SSelections.former_candidates = former_candidates

	message_admins("Loaded election data.", 1)
	return 1