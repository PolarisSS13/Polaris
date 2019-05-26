
// Returns TRUE if everything is fine.
// Things might not be fine if, for example, the player can't afford all the skills chosen.
// Note that invalid setups are allowed to be saved, its just that they will not be able to join the round.
/datum/skill_manager/proc/is_valid()
//	return TRUE //TODO
	return total_spent_points() <= get_max_point_budget()

// Switches the list.
/datum/skill_manager/proc/change_skill_list(list/new_skill_list_ref)
	skill_list_ref = new_skill_list_ref

// Safely returns numerical index of the skill in an assoc list.
// This is only intended for frontend UIs, use a different proc for in-game skill checks (since front-end can change constantly).
/datum/skill_manager/proc/get_skill_level(list/skill_list, skill_id)
	var/answer = skill_list[skill_id]
	if(isnull(answer))
		return SKILL_LEVEL_ZERO
	return answer

/datum/skill_manager/proc/get_points_in_skill(skill_id)
	var/datum/category_item/skill/item = GLOB.skill_collection.skills_by_id[skill_id]
	if(!item) // In case the skill got removed or something.
		return 0
	var/level_index = get_skill_level(skill_list_ref, skill_id)
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
	var/level_index = get_skill_level(skill_list_ref, skill_id)
	var/datum/skill_level/level = item.levels[level_index]
	return level.name

// Override this for getting the age.
/datum/skill_manager/proc/get_age()
	return -1

// Override this for getting the species.
// Note that it needs to return the instantiated datum, not the species string. Use the global all_species list to get it.
/datum/skill_manager/proc/get_species()
	return null

// Override this for determining if they're a robot, and if so, what kind.
/datum/skill_manager/proc/get_FBP_type()
	return null

// By default, uses a sigmoid curve in order to determine how many skill points someone will have.
// A sigmoid curve is used because it grows fast in the start, but slows down, and it is impossible for it to go over a 'max' number.
/datum/skill_manager/proc/get_max_point_budget()
//	return 150
/*
	// TODOs
	var/min_age = 17 // TODO read from species.
	var/max_age = 150 // TODO read from species.
	var/age = get_age()
	var/datum/species/S = get_species()
	var/robot_type = get_FBP_type()

	// Curve modifiers.
	var/curve_starting_age = 0		// Determines when the curve starts. Effectively shifts the origin towards the right on a graph.
	var/dimishing_point = 0			// Influences the curve. Lower numbers relative to species max age make the curve steeper.
	var/base_points = 0				// How many points that the character will always have, regardless of age. Effectively shifts the origin upward on a graph.
	var/max_points_from_scaling = 0	// How many points can be gained from the age curve. This plus base_points determines max point potential.

	// Posis and drones have their own curves. MMIs have the same curves as their species.
	if(robot_type in list(PREF_FBP_POSI, PREF_FBP_SOFTWARE))
		// Sadly they're hardcoded here.
		curve_starting_age = 0
		switch(robot_type)
			if(PREF_FBP_POSI)
				// Posibrains learn mostly like humans, just quicker.
				// It might be neat to add another curve going backwards to simulate posi lore better, somehow.
				dimishing_point = 15
				base_points = 20
				max_points_from_scaling = 130
			if(PREF_FBP_SOFTWARE)
				// Drones are literally software, so their initial points are high, but scales poorly.
				// In the future, we could have different scales for different classes of drones.
				dimishing_point = 20
				base_points = 75
				max_points_from_scaling = 75

	else if(istype(S))
		curve_starting_age = S.skill_point_curve_start()
		dimishing_point = S.skill_point_diminishing_point()
		base_points = S.skill_point_base()
		max_points_from_scaling = S.skill_point_max_points_from_scaling

	// Determine the position of the curve. 0 is the start, 1 is at dimishing_point, and higher numbers are beyond that.
	var/position = (age - curve_starting_age) / (dimishing_point - curve_starting_age)
	// Turns the position var into a number between 0 and 1. It is impossible to exceed 1.
	var/growth_factor = position / sqrt(1+(position**2))
	// Now multiply
	var/points_from_scaling = CEILING(base_points + (max_points_from_scaling * growth_factor), 1)

	return points_from_scaling

	//=(B100)/SQRT(1+(B100^2))
*/
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
/*
// Returns someone's max amount of points.
/datum/skill_manager/proc/calculate_max_points(age, min_age, max_age, point_floor, multiplier)
	var/A = max(age - min_age, 0)
	var/B = max(max_age - min_age, 0)
	var/scale = min(sqrt(A / B), 1) // Scale cannot exceed 1.
	return FLOOR( (scale + base_points) * multiplier )
*/

// ROUNDDOWN(((MIN(SQRT( MAX(age - min_age,0) / MAX(max_age-min_age, 0)), 1) + base_points ) * multiplier ) )

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

/datum/skill_manager/proc/can_write_skill_level(skill_id, new_skill_level)
	return !read_only

// Modifies the referenced list of skills.
// Can be overrided to do additional things after the fact.
/datum/skill_manager/proc/write_skill_level(skill_id, new_skill_level)
	if(read_only)
		return FALSE
	skill_list_ref[skill_id] = new_skill_level
	return TRUE