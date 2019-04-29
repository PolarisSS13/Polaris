// This subtype is used to refresh the character setup window when the window changes.
/datum/skill_manager/character_setup

/datum/skill_manager/character_setup/refresh_ui()
	user.prefs.ShowChoices(usr)
	return ..()