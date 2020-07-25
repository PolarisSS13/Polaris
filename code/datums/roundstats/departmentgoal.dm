
GLOBAL_LIST(department_goals)
GLOBAL_LIST(active_department_goals)

/hook/startup/proc/initializeDepartmentGoals()
	GLOB.department_goals = list(GOAL_GENERAL, GOAL_MEDICAL, GOAL_SECURITY, GOAL_ENGINEERING, GOAL_CARGO, GOAL_RESEARCH)
	GLOB.active_department_goals = list(GOAL_GENERAL, GOAL_MEDICAL, GOAL_SECURITY, GOAL_ENGINEERING, GOAL_CARGO, GOAL_RESEARCH)

	for(var/category in GLOB.department_goals)
		GLOB.department_goals[category] = list()

		for(var/subtype in subtypesof(/datum/goal))
			var/datum/goal/SG = initial(subtype)

			if(SG.name == "goal")
				continue

			if(SG.category == category)
				GLOB.department_goals[category] |= new subtype()

	for(var/category in GLOB.active_department_goals)
		GLOB.active_department_goals[category] = list()
		var/list/cat_goals = GLOB.department_goals[category].Copy()

		var/goal_count = rand(2,4)

		for(var/count = 1 to goal_count)
			var/datum/goal/G = pick(cat_goals)

			G.active_goal = TRUE
			cat_goals -= G

			GLOB.active_department_goals[category] |= G

/datum/goal
	var/name = "goal"

	var/goal_text = "Do nothing! Congratulations."

	var/active_goal = FALSE

	var/category = GOAL_GENERAL

/datum/goal/proc/check_completion()
	return FALSE

/datum/goal/common
	name = "goal"

	goal_text = "Congratulations, you still do nothing."

/datum/goal/medical
	name = "goal"

	goal_text = "Congratulations, you still do nothing."
	category = GOAL_MEDICAL

/datum/goal/security
	name = "goal"

	goal_text = "Congratulations, you still do nothing."
	category = GOAL_SECURITY

/datum/goal/engineering
	name = "goal"

	goal_text = "Congratulations, you still do nothing."
	category = GOAL_ENGINEERING

/datum/goal/cargo
	name = "goal"

	goal_text = "Congratulations, you still do nothing."
	category = GOAL_CARGO

/datum/goal/research
	name = "goal"

	goal_text = "Congratulations, you still do nothing."
	category = GOAL_RESEARCH
