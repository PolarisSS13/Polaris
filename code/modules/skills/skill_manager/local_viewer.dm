// This subtype is for character to look at their own character's skills while in round.
// The skills that are in their character setup might not match their current character's skills (e.g. off-station antags).
/mob/living
	var/datum/skill_manager/local_viewer/local_skill_viewer = null

/mob/living/verb/show_own_skills()
	set name = "Show Own Skills"
	set desc = "Opens a window displaying your current character's skillset."
	set category = "IC"

	if(!client || !mind)
		return

	if(!local_skill_viewer)
		local_skill_viewer = new(client, mind.skills)

	local_skill_viewer.make_window()



/datum/skill_manager/local_viewer
	read_only = TRUE

/datum/skill_manager/local_viewer/make_window()
	var/list/dat = list()
	dat += skill_point_total_content()
	dat += skill_table_content()

	var/datum/browser/popup = new(user, "skill_manager_window_\ref[user]", "[user.mob.mind.current.real_name]'s Skills", 800, 500, src)
	popup.set_content(dat.Join(null))
	popup.open()

/*
	. = list()
	. += "<b>Select your Skills</b><br>"
	. += "[user.prefs.real_name] - <b>[get_fluff_title()]</b><br>"
	. += "Current skill points: <b>[total_spent_points()]/TODO</b><br>"
	. += href(src, list("premade_template" = 1), "Select Premade Template (TODO)")

	. += display_skill_table()

	. = jointext(.,null)
*/