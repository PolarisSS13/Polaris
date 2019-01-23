GLOBAL_LIST_EMPTY(all_cataloguers)
GLOBAL_LIST_EMPTY(all_cataloguer_discoveries)

/*
	This is a special scanner which exists to give explorers something to do besides shoot things.
	The scanner is able to be used on certain things in the world, and after a variable delay, the scan finishes,
	giving the person who scanned it some fluff and information about what they just scanned,
	as well as points that currently do nothing but measure epeen,
	and will be used as currency in The Future(tm) to buy things explorers care about.

	Scanning hostile mobs and objects is tricky since only mobs that are alive are scannable, so scanning
	them requires careful position to stay out of harms way until the scan finishes. That is why
	the person with the scanner gets a visual box that shows where they are allowed to move to
	without inturrupting the scan.
*/
/obj/item/device/cataloguer
	name = "cataloguer"
	desc = "A hand-held device, used for compiling information about an object by scanning it."
	icon = 'icons/obj/device.dmi'
	icon_state = "locator" // wip.
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_MATERIAL = 2, TECH_DATA = 3, TECH_MAGNET = 3)
	force = 0
	var/scan_range = 3
	var/credit_sharing_range = 14 // If another person is within this radius, they will also be credited with a successful scan.
	var/datum/category_item/catalogue/displayed_data = null // Used for viewing a piece of data in the UI.
	var/busy = FALSE // Set to true when scanning, to stop multiple scans.
	var/debug = FALSE // If true, can view all catalogue data defined, regardless of unlock status.

/obj/item/device/cataloguer/advanced
	name = "advanced cataloguer"
	desc = "A hand-held device, used for compiling information about an object by scanning it. This one is an upgraded model, \
	with a scanner that both can scan from farther away, and with less time."
	scan_range = 4
	toolspeed = 0.8

// Able to see all defined catalogue data regardless of if it was unlocked, intended for testing.
/obj/item/device/cataloguer/debug
	toolspeed = 0.1
	scan_range = 7
	debug = TRUE

/obj/item/device/cataloguer/Initialize()
	GLOB.all_cataloguers += src
	return ..()

/obj/item/device/cataloguer/Destroy()
	GLOB.all_cataloguers -= src
	return ..()

/obj/item/device/cataloguer/afterattack(atom/target, mob/user, proximity_flag)
	// Things that invalidate the scan immediately.
	if(busy)
		to_chat(user, span("warning", "\The [src] is already scanning something."))
		return

	if(isturf(target) && (!target.can_catalogue()))
		var/turf/T = target
		for(var/a in T) // If we can't scan the turf, see if we can scan anything on it, to help with aiming.
			var/atom/A = a
			if(A.can_catalogue())
				target = A
				break

	if(!target.can_catalogue(user)) // This will tell the user what is wrong.
		return

	if(get_dist(target, user) > scan_range)
		to_chat(user, span("warning", "You are too far away from \the [target] to catalogue it. Get closer."))
		return

	// Get the atom's scanning information, like the delay.
	var/scan_delay = target.get_catalogue_delay() * toolspeed

	// Start the special effects.
	var/datum/beam/scan_beam = user.Beam(target, icon_state = "holo_beam", time = scan_delay)
	var/filter = filter(type = "outline", size = 1, color = "#FFFFFF")
	target.filters += filter
	var/list/box_segments = list()
	if(user.client)
		box_segments = draw_box(target, scan_range, user.client)
		color_box(box_segments, "#00FF00", scan_delay)

	playsound(src.loc, 'sound/machines/beep.ogg', 50)
	// The delay, and test for if the scan succeeds or not.
	busy = TRUE
	if(do_after(user, scan_delay, target, ignore_movement = TRUE, max_distance = scan_range))
		to_chat(user, span("notice", "You successfully scan \the [target] with \the [src]."))
		playsound(src.loc, 'sound/machines/ping.ogg', 50)
		catalogue_object(target, user)
	else
		to_chat(user, span("warning", "You failed to scan \the [target] with \the [src]."))
		playsound(src.loc, 'sound/machines/buzz-two.ogg', 50)
		color_box(box_segments, "#FF0000", 3)
		sleep(3)
	busy = FALSE

	// Now clean up the effects.
	QDEL_NULL(scan_beam)
	if(target)
		target.filters -= filter
	if(user.client) // If for some reason they logged out mid-scan the box will be gone anyways.
		delete_box(box_segments, user.client)

// Todo: Display scanned information, increment points, etc.
/obj/item/device/cataloguer/proc/catalogue_object(atom/target, mob/living/user)
	// Figure out who may have helped out.
	var/list/contributers = list()
	for(var/thing in player_list)
		var/mob/M = thing
		if(get_dist(M, user) <= credit_sharing_range)
			contributers += M.name

	var/points_gained = 0

	if(LAZYLEN(target.catalogue_data))
		for(var/data_type in target.catalogue_data)
			var/datum/category_item/catalogue/I = GLOB.catalogue_data.resolve_item(data_type)
			if(istype(I) && I.discover(user, contributers))
				points_gained += I.value

	if(points_gained)
		to_chat(user, span("notice", "Gained [points_gained] points in total."))

	/*
	// OLD SHIT
	var/value_gained = 0

	// Now insert it into the mysterious magical global information holder.
	var/datum/catalogue_data/data = new(target.get_catalogue_name(), target.get_catalogue_desc(), target.get_catalogue_value(), contributers)
	if(!is_duplicate_data(data))
		GLOB.all_cataloguer_discoveries += data
		data.display_in_chatlog(user)
		value_gained += data.value

	// See if target had any bonus stuff.
	if(LAZYLEN(target.catalogue_bonus_data))
		for(var/data_type in target.catalogue_bonus_data)
			var/datum/catalogue_data/extra_data = new data_type(new_cataloguers = contributers)
			if(!is_duplicate_data(extra_data))
				GLOB.all_cataloguer_discoveries += extra_data
				to_chat(user, span("notice", "Additional data found from scanning \the [target]."))
				extra_data.display_in_chatlog(user)
				value_gained += data.value
	*/

		// Increment points.

/obj/item/device/cataloguer/proc/add_catalogue_data(atom/target, mob/living/user)


/obj/item/device/cataloguer/attack_self(mob/living/user)
	interact(user)

/obj/item/device/cataloguer/interact(mob/user)
	var/list/dat = list()
	var/title = "Cataloguer Data Display"

	// If displayed_data exists, we show that, otherwise we show a list of all data in the mysterious global list.
	if(displayed_data)
		title = uppertext(displayed_data.name)
		dat += "<h1>[uppertext(displayed_data.name)]</h1>"
		dat += "<i>[displayed_data.desc]</i>"
		if(LAZYLEN(displayed_data.cataloguers))
			dat += "Cataloguers : <b>[english_list(displayed_data.cataloguers)]</b>."
		else
			dat += "Catalogued by nobody."
		dat += "Worth <b>[displayed_data.value]</b> exploration points."
		if(debug && !displayed_data.visible)
			dat += "<br><a href='?src=\ref[src];debug_unlock=\ref[displayed_data]'>\[(DEBUG) Force Discovery\]</a>"
		dat += "<br><a href='?src=\ref[src];show_data=null'>\[Back to List\]</a>"

	else
		for(var/G in GLOB.catalogue_data.categories)
			var/datum/category_group/group = G
			var/list/group_dat = list()
			var/show_group = FALSE

			group_dat += "<b>[group.name]</b>"
			for(var/I in group.items)
				var/datum/category_item/catalogue/item = I
				if(item.visible || debug)
					group_dat += "\t<a href='?src=\ref[src];show_data=\ref[item]'>[item.name]</a>"
					show_group = TRUE

			if(show_group || debug) // Avoid showing 'empty' groups on regular cataloguers.
				dat += group_dat

	dat += "<a href='?src=\ref[src];refresh=1'>\[Refresh\]</a> <a href='?src=\ref[src];close=1'>\[Close\]</a>"
	var/datum/browser/popup = new(user, "cataloguer_display", title, 500, 400, src)
	popup.set_content(dat.Join("<br>"))
	popup.open()
	add_fingerprint(user)

/obj/item/device/cataloguer/Topic(href, href_list)
	if(..())
		usr << browse(null, "window=cataloguer_display")
	//	usr.unset_machine()
		return 0
	if(href_list["close"] )
		usr << browse(null, "window=cataloguer_display")
	//	usr.unset_machine()
		return 0

	if(href_list["show_data"])
		displayed_data = locate(href_list["show_data"])

	if(href_list["debug_unlock"] && debug)
		var/datum/category_item/catalogue/item = locate(href_list["debug_unlock"])
		item.discover(usr, list("Debugger"))

	interact(usr) // So it refreshes the window.
	return 1

