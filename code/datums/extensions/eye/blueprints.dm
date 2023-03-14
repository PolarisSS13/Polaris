/datum/extension/eye/blueprints
	expected_type = /obj/item/blueprints
	eye_type = /mob/observer/eye/blueprints

	action_type = /datum/action/eye/blueprints

/datum/action/eye/blueprints
	eye_type = /mob/observer/eye/blueprints

/datum/action/eye/blueprints/mark_new_area
	name = "Mark new area"
	procname = "create_area"
	button_icon_state = "pencil"
	target_type = EYE_TARGET

/datum/action/eye/blueprints/remove_selection
	name = "Remove selection"
	procname = "remove_selection"
	button_icon_state = "eraser"
	target_type = EYE_TARGET

/datum/action/eye/blueprints/edit_area
	name = "Edit area"
	procname = "edit_area"
	button_icon_state = "edit_area"
	target_type = EYE_TARGET

/datum/action/eye/blueprints/remove_area
	name = "Remove area"
	procname = "remove_area"
	button_icon_state = "remove_area"
	target_type = EYE_TARGET