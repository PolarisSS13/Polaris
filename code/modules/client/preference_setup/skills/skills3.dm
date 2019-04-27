/datum/category_item/player_setup_item/skills
	name = "Skills"
	sort_order = 1
	var/datum/skill_manager/skill_manager = null // Object that holds UI and logical information about skills.

// 'skill_list' is the new skill system save format, to avoid any potential conflicts from overwriting 'skills' from the old system.
/datum/category_item/player_setup_item/skills/load_character(var/savefile/S)
	S["skill_list"]				>> pref.skill_list

/datum/category_item/player_setup_item/skills/save_character(var/savefile/S)
	S["skill_list"]				<< pref.skill_list

/datum/category_item/player_setup_item/skills/sanitize_character()
	if(!pref.skill_list)
		pref.skill_list = list()

	make_skill_manager(pref.skill_list)

/datum/category_item/player_setup_item/skills/proc/make_skill_manager(new_skill_list)
	if(!skill_manager)
		skill_manager = new(pref.client, new_skill_list)
	else
		skill_manager.skill_list_ref = new_skill_list // In case we swapped characters or something.

/datum/category_item/player_setup_item/skills/content(mob/user)
	. = list()
	. += skill_manager.display_skill_table()
	. = jointext(.,null)