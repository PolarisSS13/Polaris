/**
 * tgui external
 *
 * Contains all external tgui declarations.
 */

/**
 * public
 *
 * Used to open and update UIs.
 * If this proc is not implemented properly, the UI will not update correctly.
 *
 * required user mob The mob who opened/is using the UI.
 * optional ui datum/tgui The UI to be updated, if it exists.
 * optional parent_ui datum/tgui A parent UI that, when closed, closes this UI as well.
 */

/datum/proc/tgui_interact(mob/user, datum/tgui/ui = null, datum/tgui/parent_ui = null)
	return FALSE // Not implemented.

/**
 * public
 *
 * Data to be sent to the UI.
 * This must be implemented for a UI to work.
 *
 * required user mob The mob interacting with the UI.
 *
 * return list Data to be sent to the UI.
 */
/datum/proc/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	return list() // Not implemented.

/**
 * public
 *
 * Static Data to be sent to the UI.
 * Static data differs from normal data in that it's large data that should be
 * sent infrequently. This is implemented optionally for heavy uis that would
 * be sending a lot of redundant data frequently. Gets squished into one
 * object on the frontend side, but the static part is cached.
 *
 * required user mob The mob interacting with the UI.
 *
 * return list Statuic Data to be sent to the UI.
 */
/datum/proc/tgui_static_data(mob/user)
	return list()

/**
 * public
 *
 * Forces an update on static data. Should be done manually whenever something
 * happens to change static data.
 *
 * required user the mob currently interacting with the ui
 * optional ui ui to be updated
 */
/datum/proc/update_tgui_static_data(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	// If there was no ui to update, there's no static data to update either.
	if(!ui)
		ui = SStgui.get_open_ui(user, src)
	if(ui)
		ui.send_full_update()

/**
 * public
 *
 * Called on a UI when the UI receives a href.
 * Think of this as Topic().
 *
 * required action string The action/button that has been invoked by the user.
 * required params list A list of parameters attached to the button.
 *
 * return bool If the UI should be updated or not.
 */
/datum/proc/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	// If UI is not interactive or usr calling Topic is not the UI user, bail.
	if(!ui || ui.status != STATUS_INTERACTIVE)
		return TRUE

/**
 * public
 *
 * Called on an object when a tgui object is being created, allowing you to
 * push various assets to tgui, for examples spritesheets.
 *
 * return list List of asset datums or file paths.
 */
/datum/proc/ui_assets(mob/user)
	return list()

/**
 * private
 *
 * The UI's host object (usually src_object).
 * This allows modules/datums to have the UI attached to them,
 * and be a part of another object.
 */
/datum/proc/tgui_host(mob/user)
	return src // Default src.

/**
 * private
 *
 * The UI's state controller to be used for created uis
 * This is a proc over a var for memory reasons
 */
/datum/proc/tgui_state(mob/user)
	return GLOB.tgui_default_state

/**
 * global
 *
 * Associative list of JSON-encoded shared states that were set by
 * tgui clients.
 */

/datum/var/list/tgui_shared_states

/**
 * global
 *
 * Tracks open UIs for a user.
 */
/mob/var/list/tgui_open_uis = list()

/**
 * global
 *
 * Tracks open windows for a user.
 */
/client/var/list/tgui_windows = list()

/**
 * public
 *
 * Called on a UI's object when the UI is closed, not to be confused with
 * client/verb/uiclose(), which closes the ui window
 */
/datum/proc/tgui_close(mob/user)

/**
 * verb
 *
 * Used by a client to fix broken TGUI windows caused by opening a UI window before assets load.
 * Probably not very performant and forcibly destroys a bunch of windows, so it has some warnings attached.
 * Conveniently, also allows devs to force a dev server reattach without relogging, since it yeets windows.
 */
/client/verb/tgui_fix_white()
	set desc = "Only use this if you have a broken TGUI window occupying your screen!"
	set name = "Fix TGUI"
	set category = "OOC"

	if(alert(src, "Only use this verb if you have a white TGUI window stuck on your screen.", "Fix TGUI", "Continue", "Nevermind") != "Continue")
		return

	SStgui.close_user_uis(mob)
	if(alert(src, "Did that fix the problem?", "Fix TGUI", "Yes", "No") == "No")
		SStgui.force_close_all_windows(mob)
		alert(src, "UIs should be fixed now. If not, please cry to your nearest coder.", "Fix TGUI")

/**
 * verb
 *
 * Called by UIs when they are closed.
 * Must be a verb so winset() can call it.
 *
 * required uiref ref The UI that was closed.
 */
/client/verb/tguiclose(window_id as text)
	// Name the verb, and hide it from the user panel.
	set name = "uiclose"
	set hidden = TRUE

	var/mob/user = src && src.mob
	if(!user)
		return
	// Close all tgui datums based on window_id.
	SStgui.force_close_window(user, window_id)

/**
 * Middleware for /client/Topic.
 *
 * return bool Whether the topic is passed (TRUE), or cancelled (FALSE).
 */
/proc/tgui_Topic(href_list)
	// Skip non-tgui topics
	if(!href_list["tgui"])
		return TRUE
	var/type = href_list["type"]
	// Unconditionally collect tgui logs
	if(type == "log")
		log_tgui(usr, href_list["message"])
	// Locate window
	var/window_id = href_list["window_id"]
	var/datum/tgui_window/window
	if(window_id)
		window = usr.client.tgui_windows[window_id]
		if(!window)
			log_tgui(usr, "Error: Couldn't find the window datum, force closing.")
			SStgui.force_close_window(usr, window_id)
			return FALSE
	// Decode payload
	var/payload
	if(href_list["payload"])
		payload = json_decode(href_list["payload"])
	// Pass message to window
	if(window)
		window.on_message(type, payload, href_list)
	return FALSE
