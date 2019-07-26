/obj/machinery/selling_machine
	name = "Sellatron 5000 Selling Machine"
	desc = "The NT Sellatron 5000 uses the latest in quantum entanglement technology to transport your goods to NanoTrasen. \
	All products sold will be compensated for. Please note all compensation enters the employer savings, and is not accessible by the employee."

	icon = 'icons/obj/buysell.dmi'
	icon_state = "sell"
	unacidable = 1
	light_range = 4
	light_power = 2
	light_color = "#ebf7fe"  //white blue
	density = 1
	anchored = 1
	bounds = "64,32"
	plane = ABOVE_PLANE
	layer = ABOVE_MOB_LAYER

	var/selected_department = "Civilian"
	var/list/sale_log						// List of sale logs.

	var/obj/item/stored_item				// What's in it, right now.

	var/allow_select_department = 0			// If this is set to 0, it will pull your department from your ID instead.

	var/department_charged					// If we want this to charge a certain department. If left null, it will charge from city account.

/obj/machinery/selling_machine/attackby(obj/item/I as obj, mob/user as mob)
	if(stored_item)
		src.visible_message("\icon[src] \icon[I]<span class='warning'>Error: [src] already has an item stored, please sell or eject this item before continuing.</span>")
		return
	// First check if item has a valid price
	var/price = I.get_item_cost()
	if(isnull(price))
		playsound(src, 'sound/machines/buzz-sigh.ogg', 25)
		src.visible_message("\icon[src] \icon[I]<span class='warning'>Ineligible item. Only commercially accepted items can be sold at this vendor.</span>")
		return

	stored_item = I
	user.drop_from_inventory(I, src)
	I.forceMove(src)
	src.visible_message("\icon[src] \icon[I] [user] places [I] into [src].")
	interact(user)


/obj/machinery/selling_machine/verb/eject_item(mob/user as mob)
	set name = "Eject Item"
	set category = "Object"
	set desc = "Ejects an item from the machine."
	set src in view(1)

	if(user.stat)
		to_chat (user, "<span class='warning'>You can't operate [src] while in this state!</span>")
		return

	add_fingerprint(user)


	if(stored_item)
		if(ishuman(user) && !user.get_active_hand())
			user.put_in_hands(stored_item)
		else
			stored_item.forceMove(loc)
		stored_item = null
		return 1
	else
		to_chat (user, "<span class='warning'>There's no items stored within [src]!</span>")
		return 0

/obj/machinery/selling_machine/proc/sell_item(mob/user as mob)
	if(!stored_item)
		to_chat (user, "<span class='warning'>No item found!</span>")
		return 0

	if(!selected_department)
		to_chat (user, "<span class='warning'>No department found!</span>")
		return 0


	var/item_cost = stored_item.get_item_cost()

	// Charge either the city, or the department noted in "department_charged" var.
	if(!department_charged)
		department_charged = "[station_name()] Funds"

	department_accounts["[department_charged]"].money -= item_cost

	// Give the department their money.
	department_accounts["[selected_department]"].money += item_cost

	//create an entry for the payroll (for the payee).
	var/datum/transaction/T = new()
	T.target_name = department_accounts["[selected_department]"].owner_name
	T.purpose = "[department_charged]: Invoiced Payment For [stored_item] ([item_cost]CR)"
	T.amount = item_cost
	T.date = "[get_game_day()] [get_month_from_num(get_game_month())], [get_game_year()]"
	T.time = stationtime2text()
	T.source_terminal = "[department_charged] Account"

	department_accounts[selected_department].transaction_log.Add(T)

	playsound(src, 'sound/machines/chime.ogg', 25)
	src.visible_message("\icon[src] \icon[stored_item] <b>[src]</b> chimes, \"<span class='notice'>Transaction complete! [stored_item] sold for [item_cost]CR.</span>\"")

	qdel(stored_item) // Deletes the item once sold. eh - maybe in future we'll have it send the item somewhere.
	stored_item = null

	return 1



/obj/machinery/selling_machine/proc/change_department(mob/user as mob)
	if(!station_departments)
		return 0

	var/S = input(user, "Please select a department to lock [src] onto.", "Select Department") as null|anything in station_departments
	if(!S)
		return 0

	selected_department = S
	return 1

/obj/machinery/selling_machine/attack_hand(mob/user as mob)
	add_fingerprint(usr)


	if(istype(user, /mob/living/silicon))
		to_chat (user, "<span class='warning'>A firewall prevents you from interfacing with this device!</span>")
		return

	interact(user)
	updateDialog()

/obj/machinery/selling_machine/interact(mob/user as mob)
	var/noID
	var/department

	var/obj/item/weapon/card/id/I = user.GetIdCard()

	if(I && I.rank)
		var/datum/job/has_job = job_master.GetJob(I.rank)
		department = has_job.department

		var/eligible_departments

		eligible_departments += station_departments
		eligible_departments += "[station_name()] Funds"

		if(!(department in eligible_departments))
			noID = 1
		else
			if(!allow_select_department)
				selected_department = department
	else
		noID = 1

	if(get_dist(src,user) <= 1)
		//js replicated from obj/machinery/computer/card
		var/dat = "<h1>[src]</h1>"
		dat += "<p><i>\"The revolution in merchant technology!\"</i><br>"
		dat += "<br><b>Selling is easy, quick, and flawless.</b> Insert your item into [src] and recieve an instant quote for your goods. "
		dat += "Using a patented, secret, and safe technology your products will be transported to our warehouse - once recieved, \
		the funds will be sent to your company.<br><br>"

		if(noID && !allow_select_department)
			dat += "<b>We apologize, this [src] requires you to have an identification card confirming your employment status before \
			you can sell goods.</b></br>"
		else
			dat += "<b>Current Department:</b> [selected_department]"
			if(allow_select_department)
				dat += " <a href='?src=\ref[src];change_dept=1'>Change Department</a>"

			dat += "<br>"



			if(stored_item)
				var/icon/i = new(stored_item.icon, stored_item.icon_state)
				user << browse_rsc(i, "[stored_item.name]_[stored_item.icon_state].png")

				dat += "<b>Currently Entered Item:</b> <img src='[stored_item.name]_[stored_item.icon_state].png' style='width: 32px; height: 32px;'> [stored_item.name]  <a href='?src=\ref[src];eject_item=1'>Eject</a>"
				dat += "<p>"
				dat += "<b>Standard Price:</b> [stored_item.get_item_cost()]CR"
				dat += "<p>"
				dat += "<b>Tax Deducted from Sale Price:</b> 0%"
				dat += "<br><p>"
				dat += "<b>Total Offered Price (after tax):</b> [stored_item.get_item_cost()]CR"

				dat += "<br>"
				dat += "<br><a href='?src=\ref[src];sell_item=1'>Sell</a>"
			else
				dat += "<b>Please enter a product into [src] to recieve a quote.</b>"

		var/datum/browser/popup = new(user, "sellatron", "[src]", 550, 650, src)
		popup.set_content(jointext(dat,null))
		popup.open()

		onclose(user, "sellatron")

/obj/machinery/selling_machine/Topic(var/href, var/href_list)
	if(..())
		return 1


	if(href_list["sell_item"])
		sell_item()

	if(href_list["eject_item"])
		eject_item(usr)

	if(href_list["change_dept"])
		change_department(usr)

	updateDialog()