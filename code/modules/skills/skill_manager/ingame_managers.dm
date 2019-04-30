// Skill manages for use in-game, where the skill list is attached to a mind datum, as opposed to character setup, where the list is inside prefs.
// Used mostly for inheritence.

/datum/skill_manager/in_game
	var/datum/mind/skill_owner = null	// The mind holding onto the skill list.

/datum/skill_manager/in_game/New(client/new_user, list/new_skill_list_ref, datum/mind/new_mind)
	..()
	if(istype(new_mind))
		skill_owner = new_mind
	else
		crash_with("/datum/skill_manager/in_game/New() suppled with improper list reference argument '[new_skill_list_ref]'.")
		qdel(src)


/datum/skill_manager/in_game/refresh_ui()
	make_window()
	return ..()


// This subtype is for players to look at their own character's skills while in round.
// The skills that are in their character setup might not match their current character's skills (e.g. off-station antags).
/datum/skill_manager/in_game/local_viewer
	read_only = TRUE

/datum/skill_manager/in_game/local_viewer/make_window()
	var/list/dat = list()
	dat += skill_point_total_content()
	dat += skill_table_content()

	var/datum/browser/popup = new(user, "skill_manager_window_\ref[user]", "[skill_owner.current.real_name]'s Skills", 800, 500, src)
	popup.set_content(dat.Join(null))
	popup.open()

/mob/living
	var/datum/skill_manager/in_game/local_viewer/local_skill_viewer = null

/mob/living/verb/show_own_skills()
	set name = "Show Own Skills"
	set desc = "Opens a window displaying your current character's skillset."
	set category = "IC"

	if(!client || !mind)
		return

	if(!local_skill_viewer)
		local_skill_viewer = new(client, mind.skills, mind)

	local_skill_viewer.make_window()


// This subtype is for admins to be able to look at, and set a player's skills.
// There are no restrictions placed on what skills can be set to. Use responsibly.
/datum/skill_manager/in_game/admin_viewer


/datum/skill_manager/in_game/admin_viewer/make_window()
	var/list/dat = list()
	dat += "<b><h2>Modifications to skills are applied instantly.</h2></b>"
	dat += display_skill_setup_ui()

	var/datum/browser/popup = new(user, "skill_manager_window_\ref[user]", "[skill_owner.current.real_name]'s Skills", 800, 500, src)
	popup.set_content(dat.Join("<br>"))
	popup.open()

// Some simple logging.
/datum/skill_manager/in_game/admin_viewer/write_skill_level(skill_id, new_skill_level)
	var/current_skill_level = skill_list_ref[skill_id]
	if(..()) // Only do this on successful edits.
		log_and_message_admins("[key_name(usr)] has modified [key_name(skill_owner.current)]'s '[skill_id]' skill level \
		from <b>[current_skill_level-1]</b> to <b>[new_skill_level-1]</b>.")