/datum/gm_action
	var/name = "no name"				// Simple name, for organization.
	var/enabled = TRUE					// If not enabled, this action is never taken.
	var/departments = list()			// What kinds of departments are affected by this action.  Multiple departments can be listed.
	var/chaotic = 0						// A number showing how chaotic the action may be.  If danger is high, the GM will avoid it.
	var/chaos_threshold = 0				// If the GM's danger score is at this number or higher, the event won't get picked.
	var/reusable = FALSE				// If true, the event does not become disabled upon being used.  Should be used sparingly.
	var/observers_used = FALSE			// Determines if the GM should check if ghosts are available before using this.
	var/length = 0						// Determines how long the event lasts, until end() is called.
	var/datum/game_master/gm = null
	var/severity = 1					// The severity of the action. This is here to prevent continued future defining of this var on actions, un-used.

/datum/gm_action/proc/set_up()
	return

/datum/gm_action/proc/get_weight()
	return

/datum/gm_action/proc/start()
	if(!reusable)
		enabled = FALSE
	return

/datum/gm_action/proc/end()
	return

/datum/gm_action/proc/announce()
	return

/datum/gm_action/proc/should_end()
	return TRUE

/datum/gm_action/Topic(href, href_list)
	if(..())
		return

	if(!is_admin(usr))
		message_admins("[usr] has attempted to force an event without being an admin.")
		return

	if(href_list["force"])
//		gm.run_action(src)
		message_admins("GM event [name] was forced by [usr.key].")

	if(href_list["toggle"])
		enabled = !enabled
		message_admins("GM event [name] was toggled [enabled ? "on" : "off"] by [usr.key].")

	SSgame_master.interact(usr) // To refresh the UI.