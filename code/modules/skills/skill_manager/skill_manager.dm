// This holds the visual UIs, state, and logic for interacting with the skill system.
// It is intended to be able to be used in many different places.
// The actual storage for skills is just an assoc list, so that it is easy to store.
// This holds the logic for skill allocating, as well as displaying the skills to users.
// It's in its own datum to allow for it to be used in many places to minimize code duplication.

/datum/skill_manager
	var/client/user = null				// The client using this UI.
	var/read_only = FALSE				// If true, the skill list cannot be altered.
	var/list/skill_list_ref = null		// Reference to the true list to display/modify.

/datum/skill_manager/New(client/new_user, list/new_skill_list_ref)
	..()
	if(istype(new_user))
		user = new_user
	else if(ismob(new_user))
		var/mob/M = new_user
		user = M.client
	else
		crash_with("/datum/skill_manager/New() suppled with non-client or non-mob argument '[new_user]'.")
		qdel(src)

	if(islist(new_skill_list_ref))
		skill_list_ref = new_skill_list_ref
	else
		crash_with("/datum/skill_manager/New() suppled with improper list reference argument '[new_skill_list_ref]'.")
		qdel(src)

/datum/skill_manager/Destroy()
	user = null
	skill_list_ref = null // Don't cut the list, since the list is shared with other things.
	return ..()

/datum/skill_manager/proc/change_skill_list(list/new_skill_list_ref)
	skill_list_ref = new_skill_list_ref

/datum/skill_manager/proc/make_window()
	var/list/dat = list()
	dat += display_skill_setup_ui()

	var/datum/browser/popup = new(user, "skill_manager_window_\ref[user]", "Skills", 800, 500, src)
	popup.set_content(dat.Join("<br>"))
	popup.open()


/datum/skill_manager/proc/display_skill_setup_ui()
	. = list()
//	. += "<b>Select your Skills</b><br>"
	. += "[user.prefs.real_name] - <b>[get_fluff_title()]</b><br>"
	. += skill_point_total_content()
	. += href(src, list("premade_template" = 1), "Select Premade Template (TODO)")

	. += skill_table_content()

	. = jointext(.,null)

/datum/skill_manager/proc/skill_point_total_content()
	return "Current skill points: <b>[total_spent_points()]/TODO</b><br>"

// Outputs a table with all the skills according to skill_list_ref, and buttons to modify the referenced list.
/datum/skill_manager/proc/skill_table_content()
	. = list()
	. += "<p style='center'>"
	. += "<table style = width:90%>"
	for(var/datum/category_group/skill/group in GLOB.skill_collection.categories)
		. += "<tr>"
		. += "<th colspan = 6><b>[group.name]</b></th>"
		. += "</tr>"

		for(var/datum/category_item/skill/item in group.items)
			. += "<tr>"
			var/invested = get_points_in_skill(item.id)
			var/displayed_skill_name = "[item.name][invested > 0 ? " ([invested])":""]"
			. += "<th style='text-align:center'>[href(src, list("info" = item), displayed_skill_name)]</th>"

			var/i = 1
			for(var/datum/skill_level/level in item.levels)
				var/displayed_name = level.name
				if(level.cost > 0)
					displayed_name = "[displayed_name] ([level.cost])"

				var/cell_content = null
				if(get_skill_level(item.id) == i)
					cell_content = "<span class='linkOn'>[displayed_name]</span>"
				else if(read_only)
					cell_content = displayed_name
				else
					cell_content = href(src, list("chosen_skill" = item, "chosen_level" = i), displayed_name)

				. += "<td style='text-align:center'>[cell_content]</td>"
				i++

			. += "</tr>"
	. += "</table>"
	. += "</p>"
	. = jointext(.,null)


// Opens a standalone window describing what the skill and all its levels do.
// Also provides an alternative means of selecting the desired skill level, if allowed to do so.
/datum/skill_manager/proc/display_skill_info(datum/category_item/skill/item, user)
	var/list/dat = list()
	dat += "<i>[item.flavor_desc]</i>"
	dat += "<b>[item.govern_desc]</b>"
	dat += item.typical_desc

	dat += "<hr>"
	var/i = 1
	for(var/datum/skill_level/level in item.levels)
		if(get_skill_level(item.id) == i)
			dat += "<span class='linkOn'>[level.name]</span>"
		else if(read_only)
			dat += "<b>[level.name]</b>"
		else
			dat += href(src, list("chosen_skill" = item, "chosen_level" = i, "refresh_info" = 1), level.name)
		i++

		dat += "<i>[level.flavor_desc]</i>"
		if(level.mechanics_desc && config.mechanical_skill_system) // No point showing mechanical effects if they are disabled in the config.
			dat += "<span class='highlight'>[level.mechanics_desc]</span>"
		if(level.cost > 0)
			dat += "Costs <b>[level.cost]</b> skill points."
		dat += "<br>"

	var/datum/browser/popup = new(user, "skill_info_\ref[user]", item.name, 500, 800, src)
	popup.set_content(dat.Join("<br>"))
	popup.open()

// Returns TRUE if everything is fine.
// Things might not be fine if, for example, the player can't afford all the skills chosen.
/datum/skill_manager/proc/is_valid()
	return TRUE //TODO

// Safely returns numerical index of the skill in an assoc list.
// This is only intended for frontend UIs, use a different proc for in-game skill checks (since front-end can change constantly).
/datum/skill_manager/proc/get_skill_level(skill_id)
	var/answer = skill_list_ref[skill_id]
	if(isnull(answer))
		return SKILL_LEVEL_ZERO
	return answer

/datum/skill_manager/proc/get_points_in_skill(skill_id)
	var/datum/category_item/skill/item = GLOB.skill_collection.skills_by_id[skill_id]
	if(!item) // In case the skill got removed or something.
		return 0
	var/level_index = get_skill_level(skill_id)
	var/datum/skill_level/level = item.levels[level_index]
	return level.cost

/datum/skill_manager/proc/total_spent_points()
	. = 0
	for(var/id in skill_list_ref)
		. += get_points_in_skill(id)

/datum/skill_manager/proc/get_name_in_skill(skill_id)
	var/datum/category_item/skill/item = GLOB.skill_collection.skills_by_id[skill_id]
	if(!item) // In case the skill got removed or something.
		return "ERROR"
	var/level_index = get_skill_level(skill_id)
	var/datum/skill_level/level = item.levels[level_index]
	return level.name
/*
/datum/skill_manager/proc/get_discount_modifier(skill_group, point_cap, max_discount_factor)
	var/
	for(var/id in skill_list_ref)
		var/datum/category_item/skill/item = GLOB.skill_collection.skills_by_id[skill_id]
		if(!item)
			continue

	return X * (1 - (X / point_cap) * max_discount_factor)
*/
/*
Skill specialization discount formula;
	point_cap = 100
	max_discount_factor = 0.5
	X = point total inside specific group
	Y = Discount factor (Capped at max_discount_factor)

	discount_modifier = 1 - (X / point_cap) * max_discount_factor
	true_point_cost = X * discount_modifier
*/

// Returns the most expensive skill level rank.
// Used for flavor, and is only shown to the user.
/datum/skill_manager/proc/get_fluff_title()
	var/highest_investment = 0
	var/highest_skill = null

	for(var/id in skill_list_ref)
		var/cost = get_points_in_skill(id)
		if(cost > highest_investment)
			highest_skill = id
			highest_investment = cost

	if(highest_skill)
		return get_name_in_skill(highest_skill)
	return "Unremarkable"

// Refreshes the window displaying this.
// Overrided for subtypes which use a different window (like character setup).
/datum/skill_manager/proc/refresh_ui()
	return

// Modifies the referenced list of skills.
// Can be overrided to do additional things after the fact.
/datum/skill_manager/proc/write_skill_level(skill_id, new_skill_level)
	if(read_only)
		return FALSE
	skill_list_ref[skill_id] = new_skill_level
	return TRUE

/datum/skill_manager/Topic(var/href,var/list/href_list)
	if(..())
		return 1
	world << "wew [href]!"

	if(href_list["info"])
		var/datum/category_item/skill/item = locate(href_list["info"])
		display_skill_info(item, usr)
		return TOPIC_HANDLED

	if(href_list["chosen_skill"])
		if(read_only) // Protect against bugs and href exploits.
			return TOPIC_HANDLED

		var/datum/category_item/skill/item = locate(href_list["chosen_skill"])
		var/chosen_level = text2num(href_list["chosen_level"])

		if(item && !isnull(chosen_level))
			world << "[item.name] | [chosen_level]"
			write_skill_level(item.id, chosen_level)

		refresh_ui()
		// If they clicked the button in the info window, refresh that too.
		if(href_list["refresh_info"])
			display_skill_info(item, usr)
		return TOPIC_REFRESH

//	if(href_list["close"])
//		qdel(src)
//		return TOPIC_HANDLED

	return ..()
