/**
 *  A vending machine
 */
/obj/machinery/vending
	name = "Vendomat"
	desc = "A generic vending machine."
	icon = 'icons/obj/vending.dmi'
	icon_state = "generic"
	anchored = 1
	density = 1

	var/icon_vend //Icon_state when vending
	var/icon_deny //Icon_state when denying access

	// Power
	use_power = 1
	idle_power_usage = 10
	var/vend_power_usage = 150 //actuators and stuff

	// Vending-related
	var/active = 1 //No sales pitches if off!
	var/vend_ready = 1 //Are we ready to vend?? Is it time??
	var/vend_delay = 10 //How long does it take to vend?
	var/categories = CAT_NORMAL // Bitmask of cats we're currently showing
	var/datum/stored_item/vending_product/currently_vending = null // What we're requesting payment for right now
	var/status_message = "" // Status screen messages like "insufficient funds", displayed in NanoUI
	var/status_error = 0 // Set to 1 if status_message is an error

	/*
		Variables used to initialize the product list
		These are used for initialization only, and so are optional if
		product_records is specified
	*/
	var/list/products	= list() // For each, use the following pattern:
	var/list/contraband	= list() // list(/type/path = amount,/type/path2 = amount2)
	var/list/premium 	= list() // No specified amount = only one in stock
	var/list/prices     = list() // Prices for each item, list(/type/path = price), items not in the list don't have a price.

	// List of vending_product items available.
	var/list/product_records = list()


	// Variables used to initialize advertising
	var/product_slogans = "" //String of slogans spoken out loud, separated by semicolons
	var/product_ads = "" //String of small ad messages in the vending screen

	var/list/ads_list = list()

	// Stuff relating vocalizations
	var/list/slogan_list = list()
	var/shut_up = 1 //Stop spouting those godawful pitches!
	var/vend_reply //Thank you for shopping!
	var/last_reply = 0
	var/last_slogan = 0 //When did we last pitch?
	var/slogan_delay = 6000 //How long until we can pitch again?

	// Things that can go wrong
	emagged = 0 //Ignores if somebody doesn't have card access to that machine.
	var/seconds_electrified = 0 //Shock customers like an airlock.
	var/shoot_inventory = 0 //Fire items at customers! We're broken!

	var/scan_id = 1
	var/obj/item/weapon/coin/coin
	var/datum/wires/vending/wires = null

	var/list/log = list()
	var/req_log_access = access_cargo //default access for checking logs is cargo
	var/has_logs = 0 //defaults to 0, set to anything else for vendor to have logs

	var/vending_sound = "machines/vending_drop.ogg"

	var/vendor_department	//this is the department the vending machine gives money it acquires to.
	var/charge_department	//"free items" get charged from this department account, or all paid items get charged, etcetera

	var/charge_free_to_department			//free items get charged to dept account
	var/charge_paid_to_department			//paid items get charged to dept instead of going through payment

	var/auto_price			//select this if you want vending items to be autopriced based on actual cost so you don't have to use prices var

/obj/machinery/vending/examine(mob/user)
	..()
	if(vendor_department)
		to_chat(user, "<b>[src]</b> pays to the [vendor_department] account.")
	if(charge_department && charge_free_to_department)
		to_chat(user, "It charges from the [charge_department] account for free items.")
	if(charge_department && charge_paid_to_department)
		to_chat(user, "Paid items are supplied by the [charge_department] account.")

/obj/machinery/vending/New()
	..()
	wires = new(src)
	spawn(4)
		if(product_slogans)
			slogan_list += splittext(product_slogans, ";")

			// So not all machines speak at the exact same time.
			// The first time this machine says something will be at slogantime + this random value,
			// so if slogantime is 10 minutes, it will say it at somewhere between 10 and 20 minutes after the machine is crated.
			last_slogan = world.time + rand(0, slogan_delay)

		if(product_ads)
			ads_list += splittext(product_ads, ";")

		build_inventory()
		power_change()

		return

	return

/**
 *  Build produdct_records from the products lists
 *
 *  products, contraband, premium, and prices allow specifying
 *  products that the vending machine is to carry without manually populating
 *  product_records.
 */
/obj/machinery/vending/proc/build_inventory()
	var/list/all_products = list(
		list(products, CAT_NORMAL),
		list(contraband, CAT_HIDDEN),
		list(premium, CAT_COIN))

	for(var/current_list in all_products)
		var/category = current_list[2]

		for(var/entry in current_list[1])
			var/datum/stored_item/vending_product/product = new/datum/stored_item/vending_product(src, entry)

			product.price = (entry in prices) ? prices[entry] : 0

			if(!product.price && product.item_default_price && auto_price)
				product.price = product.item_default_price

			product.amount = (current_list[1][entry]) ? current_list[1][entry] : 1
			product.category = category

			product_records.Add(product)

/obj/machinery/vending/Destroy()
	qdel(wires)
	wires = null
	qdel(coin)
	coin = null
	for(var/datum/stored_item/vending_product/R in product_records)
		qdel(R)
	product_records = null
	return ..()

/obj/machinery/vending/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				qdel(src)
				return
		if(3.0)
			if(prob(25))
				spawn(0)
					malfunction()
					return
				return
		else
	return

/obj/machinery/vending/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		emagged = 1
		to_chat(user, "You short out \the [src]'s product lock.")
		return 1

/obj/machinery/vending/attackby(obj/item/weapon/W as obj, mob/user as mob)

	var/obj/item/weapon/card/id/I = W.GetID()

	if(currently_vending && vendor_account && !vendor_account.suspended)
		var/paid = 0
		var/handled = 0

		if(I) //for IDs and PDAs and wallets with IDs
			paid = pay_with_card(I,W)
			handled = 1
		else if(istype(W, /obj/item/weapon/spacecash/ewallet))
			var/obj/item/weapon/spacecash/ewallet/C = W
			paid = pay_with_ewallet(C)
			handled = 1
		else if(istype(W, /obj/item/weapon/spacecash))
			var/obj/item/weapon/spacecash/C = W
			paid = pay_with_cash(C, user)
			handled = 1
		else if(istype(W, /obj/item/weapon/card/foodstamp))
			var/obj/item/weapon/card/foodstamp/C = W
			paid = pay_with_foodstamp(C)
			handled = 1
		if(paid)
			if(vendor_department)
				department_accounts["[vendor_department]"].money += currently_vending.price

			vend(currently_vending, usr)

			return
		else if(handled)
			SSnanoui.update_uis(src)
			return // don't smack that machine with your 2 thalers

	if(I || istype(W, /obj/item/weapon/spacecash))
		attack_hand(user)
		return
	else if(istype(W, /obj/item/weapon/screwdriver))
		panel_open = !panel_open
		to_chat(user, "You [panel_open ? "open" : "close"] the maintenance panel.")
		playsound(src, W.usesound, 50, 1)
		overlays.Cut()
		if(panel_open)
			overlays += image(icon, "[initial(icon_state)]-panel")

		SSnanoui.update_uis(src)  // Speaker switch is on the main UI, not wires UI
		return
	else if(istype(W, /obj/item/device/multitool)||istype(W, /obj/item/weapon/wirecutters))
		if(panel_open)
			attack_hand(user)
		return
	else if(istype(W, /obj/item/weapon/coin) && premium.len > 0)
		user.drop_item()
		W.forceMove(src)
		coin = W
		categories |= CAT_COIN
		to_chat(user, "<span class='notice'>You insert \the [W] into \the [src].</span>")
		SSnanoui.update_uis(src)
		return
	else if(istype(W, /obj/item/weapon/wrench))
		playsound(src, W.usesound, 100, 1)
		if(anchored)
			user.visible_message("[user] begins unsecuring \the [src] from the floor.", "You start unsecuring \the [src] from the floor.")
		else
			user.visible_message("[user] begins securing \the [src] to the floor.", "You start securing \the [src] to the floor.")

		if(do_after(user, 20 * W.toolspeed))
			if(!src) return
			to_chat(user, "<span class='notice'>You [anchored? "un" : ""]secured \the [src]!</span>")
			anchored = !anchored
		return
	else

		for(var/datum/stored_item/vending_product/R in product_records)
			if(istype(W, R.item_path) && (W.name == R.item_name))
				stock(W, R, user)
				return
		..()

/**
 *  Receive payment with cashmoney.
 *
 *  usr is the mob who gets the change.
 */
/obj/machinery/vending/proc/pay_with_cash(var/obj/item/weapon/spacecash/cashmoney, mob/user)
	if(currently_vending.price > cashmoney.worth)

		// This is not a status display message, since it's something the character
		// themselves is meant to see BEFORE putting the money in
		to_chat(usr, "\icon[cashmoney] <span class='warning'>That is not enough money.</span>")
		return 0

	if(istype(cashmoney, /obj/item/weapon/spacecash))

		visible_message("<span class='info'>\The [usr] inserts some cash into \the [src].</span>")
		cashmoney.worth -= currently_vending.price

		if(cashmoney.worth <= 0)
			usr.drop_from_inventory(cashmoney)
			qdel(cashmoney)
		else
			cashmoney.update_icon()

	// Vending machines have no idea who paid with cash
	credit_purchase("(cash)")
	return 1

/**
 * Scan a chargecard and deduct payment from it.
 *
 * Takes payment for whatever is the currently_vending item. Returns 1 if
 * successful, 0 if failed.
 */
/obj/machinery/vending/proc/pay_with_ewallet(var/obj/item/weapon/spacecash/ewallet/wallet)
	visible_message("<span class='info'>\The [usr] swipes \the [wallet] through \the [src].</span>")
	if(currently_vending.price > wallet.worth)
		status_message = "Insufficient funds on chargecard."
		status_error = 1
		return 0
	else
		wallet.worth -= currently_vending.price
		credit_purchase("[wallet.owner_name] (chargecard)")
		return 1

/**
 * Scan food stamp card and dispense product.
 *
 * Returns 1 if successful, 0 if failed
 */
/obj/machinery/vending/proc/pay_with_foodstamp(var/obj/item/weapon/card/foodstamp/ebt)
	visible_message("<span class='info'>\The [usr] taps \the [ebt] against \the [src]'s scanner.</span>")
	if(istype(src, /obj/machinery/vending/foodstamp))
		if(ebt.meals_remaining > 0)
			ebt.meals_remaining = ebt.meals_remaining - 1
			return 1
		else
			status_message = "No meals remaining on social service card."
			status_error = 1
			return 0
	else
		status_message = "Social service cards cannot be used at this machine."
		status_error = 1
		return 0

/**
 * Scan a card and attempt to transfer payment from associated account.
 *
 * Takes payment for whatever is the currently_vending item. Returns 1 if
 * successful, 0 if failed
 */
/obj/machinery/vending/proc/pay_with_card(var/obj/item/weapon/card/id/I, var/obj/item/ID_container)
	if(I==ID_container || ID_container == null)
		visible_message("<span class='info'>\The [usr] swipes \the [I] through \the [src].</span>")
	else
		visible_message("<span class='info'>\The [usr] swipes \the [ID_container] through \the [src].</span>")
	var/datum/money_account/customer_account = get_account(I.associated_account_number)
	if(!customer_account)
		status_message = "Error: Unable to access account. Please contact technical support if problem persists."
		status_error = 1
		return 0

	if(customer_account.suspended)
		status_message = "Unable to access account: account suspended."
		status_error = 1
		return 0

	// Have the customer punch in the PIN before checking if there's enough money. Prevents people from figuring out acct is
	// empty at high security levels
	if(customer_account.security_level != 0) //If card requires pin authentication (ie seclevel 1 or 2)
		var/attempt_pin = input("Enter pin code", "Vendor transaction") as num
		customer_account = attempt_account_access(I.associated_account_number, attempt_pin, 2)

		if(!customer_account)
			status_message = "Unable to access account: incorrect credentials."
			status_error = 1
			return 0

	if(currently_vending.price > customer_account.money)
		status_message = "Insufficient funds in account."
		status_error = 1
		return 0
	else
		// Okay to move the money at this point

		// debit money from the purchaser's account
		customer_account.money -= currently_vending.price

		// create entry in the purchaser's account log
		var/datum/transaction/T = new()
		T.target_name = "[vendor_account.owner_name] (via [name])"
		T.purpose = "Purchase of [currently_vending.item_name]"
		if(currently_vending.price > 0)
			T.amount = "([currently_vending.price])"
		else
			T.amount = "[currently_vending.price]"
		T.source_terminal = name
		T.date = current_date_string
		T.time = stationtime2text()
		customer_account.transaction_log.Add(T)

		// Give the vendor the money. We use the account owner name, which means
		// that purchases made with stolen/borrowed card will look like the card
		// owner made them
		credit_purchase(customer_account.owner_name)
		return 1

/**
 *  Add money for current purchase to the vendor account.
 *
 *  Called after the money has already been taken from the customer.
 */
/obj/machinery/vending/proc/credit_purchase(var/target as text)
	vendor_account.money += currently_vending.price

	var/datum/transaction/T = new()
	T.target_name = target
	T.purpose = "Purchase of [currently_vending.item_name]"
	T.amount = "[currently_vending.price]"
	T.source_terminal = name
	T.date = current_date_string
	T.time = stationtime2text()
	vendor_account.transaction_log.Add(T)

/obj/machinery/vending/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/vending/attack_hand(mob/user as mob)
	if(stat & (BROKEN|NOPOWER))
		return

	if(seconds_electrified != 0)
		if(shock(user, 100))
			return

	wires.Interact(user)
	ui_interact(user)

/**
 *  Display the NanoUI window for the vending machine.
 *
 *  See NanoUI documentation for details.
 */
/obj/machinery/vending/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)

	var/list/data = list()
	if(currently_vending)
		data["mode"] = 1
		data["product"] = currently_vending.item_name
		data["price"] = currently_vending.price
		data["message_err"] = 0
		data["message"] = status_message
		data["message_err"] = status_error
	else
		data["mode"] = 0
		var/list/listed_products = list()

		for(var/key = 1 to product_records.len)
			var/datum/stored_item/vending_product/I = product_records[key]

			if(!(I.category & categories))
				continue

			listed_products.Add(list(list(
				"key" = key,
				"name" = I.item_name,
				"price" = I.price,
				"color" = I.display_color,
				"amount" = I.get_amount())))

		data["products"] = listed_products

	if(coin)
		data["coin"] = coin.name

	if(panel_open)
		data["panel"] = 1
		data["speaker"] = shut_up ? 0 : 1
	else
		data["panel"] = 0

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "vending_machine.tmpl", name, 440, 600)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/vending/Topic(href, href_list)
	if(stat & (BROKEN|NOPOWER))
		return
	if(usr.stat || usr.restrained())
		return

	if(href_list["remove_coin"] && !istype(usr,/mob/living/silicon))
		if(!coin)
			to_chat(usr, "There is no coin in this machine.")
			return

		coin.forceMove(src.loc)
		if(!usr.get_active_hand())
			usr.put_in_hands(coin)
		to_chat(usr, "<span class='notice'>You remove \the [coin] from \the [src]</span>")
		coin = null
		categories &= ~CAT_COIN

	if((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))))
		if((href_list["vend"]) && (vend_ready) && (!currently_vending))
			if((!allowed(usr)) && !emagged && scan_id)	//For SECURE VENDING MACHINES YEAH
				to_chat(usr, "<span class='warning'>Access denied.</span>")	//Unless emagged of course
				flick(icon_deny,src)
				playsound(src.loc, 'sound/machines/deniedbeep.ogg', 50, 0)
				return

			var/key = text2num(href_list["vend"])
			var/datum/stored_item/vending_product/R = product_records[key]

			// This should not happen unless the request from NanoUI was bad
			if(!(R.category & categories))
				return

			if(charge_department)
				if(charge_paid_to_department && R.price)
					department_accounts["[charge_department]"].money -= R.price
					vend(R, usr)

				if(charge_free_to_department && !R.price && R.item_default_price)
					department_accounts["[charge_department]"].money -= R.item_default_price
					vend(R, usr)

				if(vendor_department)
					department_accounts["[vendor_department]"].money += R.price

			if(R.price <= 0 && !charge_free_to_department)
				vend(R, usr)

			else if(istype(usr,/mob/living/silicon)) //If the item is not free, provide feedback if a synth is trying to buy something.
				to_chat(usr, "<span class='danger'>Lawed unit recognized.  Lawed units cannot complete this transaction.  Purchase canceled.</span>")
				return
			else
				currently_vending = R
				if(!vendor_account || vendor_account.suspended)
					status_message = "This machine is currently unable to process payments due to issues with the associated account."
					status_error = 1
				else
					status_message = "Please swipe a card or insert cash to pay for the item."
					status_error = 0

		else if(href_list["cancelpurchase"])
			currently_vending = null

		else if((href_list["togglevoice"]) && (panel_open))
			shut_up = !shut_up

		add_fingerprint(usr)
		SSnanoui.update_uis(src)

/obj/machinery/vending/proc/vend(datum/stored_item/vending_product/R, mob/user)
	if((!allowed(usr)) && !emagged && scan_id)	//For SECURE VENDING MACHINES YEAH
		to_chat(usr, "<span class='warning'>Access denied.</span>")	//Unless emagged of course
		flick(icon_deny,src)
		playsound(src.loc, 'sound/machines/deniedbeep.ogg', 50, 0)
		return
	vend_ready = 0 //One thing at a time!!
	status_message = "Vending..."
	status_error = 0
	SSnanoui.update_uis(src)

	if(R.category & CAT_COIN)
		if(!coin)
			to_chat(user, "<span class='notice'>You need to insert a coin to get this item.</span>")
			return
		if(coin.string_attached)
			if(prob(50))
				to_chat(user, "<span class='notice'>You successfully pull the coin out before \the [src] could swallow it.</span>")
			else
				to_chat(user, "<span class='notice'>You weren't able to pull the coin out fast enough, the machine ate it, string and all.</span>")
				qdel(coin)
				coin = null
				categories &= ~CAT_COIN
		else
			qdel(coin)
			coin = null
			categories &= ~CAT_COIN

	if(((last_reply + (vend_delay + 200)) <= world.time) && vend_reply)
		spawn(0)
			speak(vend_reply)
			last_reply = world.time

	use_power(vend_power_usage)	//actuators and stuff
	if(icon_vend) //Show the vending animation if needed
		flick(icon_vend,src)
	playsound(src.loc, "sound/[vending_sound]", 100, 1)
	spawn(vend_delay)
		R.get_product(get_turf(src))
		if(has_logs)
			do_logging(R, user, 1)
		if(prob(1))
			sleep(3)
			if(R.get_product(get_turf(src)))
				visible_message("<span class='notice'>\The [src] clunks as it vends an additional item.</span>")

		status_message = ""
		status_error = 0
		vend_ready = 1
		currently_vending = null
		SSnanoui.update_uis(src)

	return 1

/obj/machinery/vending/proc/do_logging(datum/stored_item/vending_product/R, mob/user, var/vending = 0)
	if(user.GetIdCard())
		var/obj/item/weapon/card/id/tempid = user.GetIdCard()
		var/list/list_item = list()
		if(vending)
			list_item += "vend"
		else
			list_item += "stock"
		list_item += tempid.registered_name
		list_item += stationtime2text()
		list_item += R.item_name
		log[++log.len] = list_item

/obj/machinery/vending/proc/show_log(mob/user as mob)
	if(user.GetIdCard())
		var/obj/item/weapon/card/id/tempid = user.GetIdCard()
		if(req_log_access in tempid.GetAccess())
			var/datum/browser/popup = new(user, "vending_log", "Vending Log", 700, 500)
			var/dat = ""
			dat += "<center><span style='font-size:24pt'><b>[name] Vending Log</b></span></center>"
			dat += "<center><span style='font-size:16pt'>Welcome [user.name]!</span></center><br>"
			dat += "<span style='font-size:8pt'>Below are the recent vending logs for your vending machine.</span><br>"
			for(var/i in log)
				dat += json_encode(i)
				dat += ";<br>"
			popup.set_content(dat)
			popup.open()
	else
		to_chat(user,"<span class='warning'>You do not have the required access to view the vending logs for this machine.</span>")

/obj/machinery/vending/verb/check_logs()
	set name = "Check Vending Logs"
	set category = "Object"
	set src in oview(1)

	show_log(usr)

/**
 * Add item to the machine
 *
 * Checks if item is vendable in this machine should be performed before
 * calling. W is the item being inserted, R is the associated vending_product entry.
 */
/obj/machinery/vending/proc/stock(obj/item/weapon/W, var/datum/stored_item/vending_product/R, var/mob/user)
	if(!user.unEquip(W))
		return

	user << "<span class='notice'>You insert \the [W] in the product receptor.</span>"
	R.add_product(W)
	if(has_logs)
		do_logging(R, user)

	SSnanoui.update_uis(src)

/obj/machinery/vending/process()
	if(stat & (BROKEN|NOPOWER))
		return

	if(!active)
		return

	if(seconds_electrified > 0)
		seconds_electrified--

	//Pitch to the people!  Really sell it!
	if(((last_slogan + slogan_delay) <= world.time) && (slogan_list.len > 0) && (!shut_up) && prob(5))
		var/slogan = pick(slogan_list)
		speak(slogan)
		last_slogan = world.time

	if(shoot_inventory && prob(2))
		throw_item()

	return

/obj/machinery/vending/proc/speak(var/message)
	if(stat & NOPOWER)
		return

	if(!message)
		return

	for(var/mob/O in hearers(src, null))
		O.show_message("<span class='game say'><span class='name'>\The [src]</span> beeps, \"[message]\"</span>",2)
	return

/obj/machinery/vending/power_change()
	..()
	if(stat & BROKEN)
		icon_state = "[initial(icon_state)]-broken"
	else
		if(!(stat & NOPOWER))
			icon_state = initial(icon_state)
		else
			spawn(rand(0, 15))
				icon_state = "[initial(icon_state)]-off"

//Oh no we're malfunctioning!  Dump out some product and break.
/obj/machinery/vending/proc/malfunction()
	for(var/datum/stored_item/vending_product/R in product_records)
		while(R.get_amount()>0)
			R.get_product(loc)
		break

	stat |= BROKEN
	icon_state = "[initial(icon_state)]-broken"
	return

//Somebody cut an important wire and now we're following a new definition of "pitch."
/obj/machinery/vending/proc/throw_item()
	var/obj/throw_item = null
	var/mob/living/target = locate() in view(7,src)
	if(!target)
		return 0

	for(var/datum/stored_item/vending_product/R in product_records)
		throw_item = R.get_product(loc)
		if(!throw_item)
			continue
		break
	if(!throw_item)
		return 0
	spawn(0)
		throw_item.throw_at(target, 16, 3, src)
	visible_message("<span class='warning'>\The [src] launches \a [throw_item] at \the [target]!</span>")
	return 1

/*
 * Vending machine types
 */

/*

/obj/machinery/vending/[vendors name here]   // --vending machine template   :)
	name = ""
	desc = ""
	icon = ''
	icon_state = ""
	vend_delay = 15
	products = list()
	contraband = list()
	premium = list()

*/

/*
/obj/machinery/vending/atmospherics //Commenting this out until someone ponies up some actual working, broken, and unpowered sprites - Quarxink
	name = "Tank Vendor"
	desc = "A vendor with a wide variety of masks and gas tanks."
	icon = 'icons/obj/objects.dmi'
	icon_state = "dispenser"
	product_paths = "/obj/item/weapon/tank/oxygen;/obj/item/weapon/tank/phoron;/obj/item/weapon/tank/emergency_oxygen;/obj/item/weapon/tank/emergency_oxygen/engi;/obj/item/clothing/mask/breath"
	productamounts = "10;10;10;5;25"
	vend_delay = 0
*/

/obj/machinery/vending/boozeomat
	name = "Booze-O-Mat"
	desc = "A technological marvel, supposedly able to mix just the mixture you'd like to drink the moment you ask for one."
	icon_state = "boozeomat"
	icon_deny = "boozeomat-deny"
	products = list(/obj/item/weapon/reagent_containers/food/drinks/glass2/square = 10,
					/obj/item/weapon/reagent_containers/food/drinks/glass2/rocks = 10,
					/obj/item/weapon/reagent_containers/food/drinks/glass2/shake = 10,
					/obj/item/weapon/reagent_containers/food/drinks/glass2/cocktail = 10,
					/obj/item/weapon/reagent_containers/food/drinks/glass2/shot = 10,
					/obj/item/weapon/reagent_containers/food/drinks/glass2/pint = 10,
					/obj/item/weapon/reagent_containers/food/drinks/glass2/mug = 10,
					/obj/item/weapon/reagent_containers/food/drinks/glass2/wine = 10,
					/obj/item/weapon/reagent_containers/food/drinks/metaglass = 10,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/gin = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/absinthe = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/bluecuracao = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/cognac = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/grenadine = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/kahlua = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/melonliquor = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/rum = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/sake = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/specialwhiskey = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/tequilla = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/vermouth = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/vodka = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/wine = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/small/ale = 15,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/small/beer = 15,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/orangejuice = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/tomatojuice = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/limejuice = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/lemonjuice = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/applejuice = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/milk = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/cream = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/cola = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/space_up = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/space_mountain_wind = 5,
					/obj/item/weapon/reagent_containers/food/drinks/cans/sodawater = 15,
					/obj/item/weapon/reagent_containers/food/drinks/cans/tonic = 15,
					/obj/item/weapon/reagent_containers/food/drinks/cans/gingerale = 15,
					/obj/item/weapon/reagent_containers/food/drinks/flask/barflask = 5,
					/obj/item/weapon/reagent_containers/food/drinks/flask/vacuumflask = 5,
					/obj/item/weapon/reagent_containers/food/drinks/ice = 10,
					/obj/item/weapon/reagent_containers/food/drinks/tea = 15,
					/obj/item/weapon/glass_extra/stick = 30,
					/obj/item/weapon/glass_extra/straw = 30)
	contraband = list()
	vend_delay = 15
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	product_slogans = "I hope nobody asks me for a bloody cup o' tea...;Alcohol is humanity's friend. Would you abandon a friend?;Quite delighted to serve you!;Is nobody thirsty on this station?"
	product_ads = "Drink up!;Booze is good for you!;Alcohol is humanity's best friend.;Quite delighted to serve you!;Care for a nice, cold beer?;Nothing cures you like booze!;Have a sip!;Have a drink!;Have a beer!;Beer is good for you!;Only the finest alcohol!;Best quality booze since 2053!;Award-winning wine!;Maximum alcohol!;Man loves beer.;A toast for progress!"
	req_access = list(access_bar)
	req_log_access = access_bar
	has_logs = 1
	vending_sound = "machines/vending_cans.ogg"


/obj/machinery/vending/assist
	products = list(	/obj/item/device/assembly/prox_sensor = 5,/obj/item/device/assembly/igniter = 3,/obj/item/device/assembly/signaler = 4,
						/obj/item/weapon/wirecutters = 1, /obj/item/weapon/cartridge/signal = 4)
	contraband = list(/obj/item/device/flashlight = 5,/obj/item/device/assembly/timer = 2)
	product_ads = "Only the finest!;Have some tools.;The most robust equipment.;The finest gear in space!"

/obj/machinery/vending/coffee
	name = "Hot Drinks machine"
	desc = "A vending machine which dispenses hot drinks."
	product_ads = "Have a drink!;Drink up!;It's good for you!;Would you like a hot joe?;I'd kill for some coffee!;The best beans in the galaxy.;Only the finest brew for you.;Mmmm. Nothing like a coffee.;I like coffee, don't you?;Coffee helps you work!;Try some tea.;We hope you like the best!;Try our new chocolate!;Admin conspiracies"
	icon_state = "coffee"
	icon_vend = "coffee-vend"
	vend_delay = 34
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	vend_power_usage = 85000 //85 kJ to heat a 250 mL cup of coffee
	products = list(/obj/item/weapon/reagent_containers/food/drinks/coffee = 25,/obj/item/weapon/reagent_containers/food/drinks/tea = 25,/obj/item/weapon/reagent_containers/food/drinks/h_chocolate = 25)
	contraband = list(/obj/item/weapon/reagent_containers/food/drinks/ice = 10)
	vending_sound = "machines/vending_coffee.ogg"

	vendor_department = "Bar"

	auto_price = 1


/obj/machinery/vending/snack
	name = "Getmore Chocolate Corp"
	desc = "A snack machine courtesy of the Getmore Chocolate Corporation, based out of Mars."
	product_slogans = "Try our new nougat bar!;Twice the calories for half the price!"
	product_ads = "The healthiest!;Award-winning chocolate bars!;Mmm! So good!;Oh my god it's so juicy!;Have a snack.;Snacks are good for you!;Have some more Getmore!;Best quality snacks straight from mars.;We love chocolate!;Try our new jerky!"
	icon_state = "snack"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/candy = 2,/obj/item/weapon/reagent_containers/food/drinks/dry_ramen = 8,/obj/item/weapon/reagent_containers/food/snacks/chips =4,
					/obj/item/weapon/reagent_containers/food/snacks/sosjerky = 2,/obj/item/weapon/reagent_containers/food/snacks/no_raisin = 3,/obj/item/weapon/reagent_containers/food/snacks/spacetwinkie = 1,
					/obj/item/weapon/reagent_containers/food/snacks/cheesiehonkers = 3, /obj/item/weapon/reagent_containers/food/snacks/tastybread = 4)
	contraband = list(/obj/item/weapon/reagent_containers/food/snacks/syndicake = 6,/obj/item/weapon/reagent_containers/food/snacks/unajerky = 6,)


	vendor_department = "Bar"
	auto_price = 1

/obj/machinery/vending/cola
	name = "Robust Softdrinks"
	desc = "A softdrink vendor provided by Robust Industries, LLC."
	icon_state = "Cola_Machine"
	product_slogans = "Robust Softdrinks: More robust than a toolbox to the head!"
	product_ads = "Refreshing!;Hope you're thirsty!;Over 1 million drinks sold!;Thirsty? Why not cola?;Please, have a drink!;Drink up!;The best drinks in space."
	products = list(/obj/item/weapon/reagent_containers/food/drinks/cans/cola = 10,/obj/item/weapon/reagent_containers/food/drinks/cans/space_mountain_wind = 10,
					/obj/item/weapon/reagent_containers/food/drinks/cans/dr_gibb = 10,/obj/item/weapon/reagent_containers/food/drinks/cans/starkist = 10,
					/obj/item/weapon/reagent_containers/food/drinks/cans/waterbottle = 10,/obj/item/weapon/reagent_containers/food/drinks/cans/space_up = 10,
					/obj/item/weapon/reagent_containers/food/drinks/cans/iced_tea = 10, /obj/item/weapon/reagent_containers/food/drinks/cans/grape_juice = 10,
					/obj/item/weapon/reagent_containers/food/drinks/cans/gingerale = 10, /obj/item/weapon/reagent_containers/food/drinks/bottle/cola = 10)
	contraband = list(/obj/item/weapon/reagent_containers/food/drinks/cans/thirteenloko = 5, /obj/item/weapon/reagent_containers/food/snacks/liquidfood = 6)

	vendor_department = "Bar"
	auto_price = 1

	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	vending_sound = "machines/vending_cans.ogg"

/obj/machinery/vending/cola/New()
	..()
	icon_state = pick("Cola_Machine",
							"cola_black",
							"space_up",
							"soda")


/obj/machinery/vending/fitness
	name = "SweatMAX"
	desc = "Fueled by your inner inadequacy!"
	icon_state = "fitness"
	products = list(/obj/item/weapon/reagent_containers/food/drinks/smallmilk = 8,
					/obj/item/weapon/reagent_containers/food/drinks/smallchocmilk = 8,
					/obj/item/weapon/reagent_containers/food/drinks/glass2/fitnessflask/proteinshake = 8,
					/obj/item/weapon/reagent_containers/food/drinks/glass2/fitnessflask = 8,
					/obj/item/weapon/reagent_containers/food/snacks/candy/proteinbar = 8,
					/obj/item/weapon/reagent_containers/food/snacks/liquidfood = 8,
					/obj/item/weapon/reagent_containers/pill/diet = 8,
					/obj/item/weapon/towel/random = 8)

	prices = list(/obj/item/weapon/reagent_containers/food/drinks/smallmilk = 3,
					/obj/item/weapon/reagent_containers/food/drinks/smallchocmilk = 3,
					/obj/item/weapon/reagent_containers/food/drinks/glass2/fitnessflask/proteinshake = 20,
					/obj/item/weapon/reagent_containers/food/drinks/glass2/fitnessflask = 5,
					/obj/item/weapon/reagent_containers/food/snacks/candy/proteinbar = 5,
					/obj/item/weapon/reagent_containers/food/snacks/liquidfood = 5,
					/obj/item/weapon/reagent_containers/pill/diet = 35,
					/obj/item/weapon/towel/random = 40)

	contraband = list(/obj/item/weapon/reagent_containers/syringe/steroid = 4)

	vendor_department = "Civilian"
	auto_price = 1


/obj/machinery/vending/cart
	name = "PTech"
	desc = "Cartridges for PDAs."
	product_slogans = "Carts to go!"
	icon_state = "cart"
	icon_deny = "cart-deny"
	req_access = list(access_hop)
	products = list(/obj/item/weapon/cartridge/medical = 10,/obj/item/weapon/cartridge/engineering = 10,/obj/item/weapon/cartridge/security = 10,
					/obj/item/weapon/cartridge/janitor = 10,/obj/item/weapon/cartridge/signal/science = 10, /obj/item/device/pda/heads = 10,
					/obj/item/weapon/cartridge/captain = 3,/obj/item/weapon/cartridge/quartermaster = 10)
	req_log_access = access_hop
	has_logs = 1

/obj/machinery/vending/cigarette
	name = "cigarette machine"
	desc = "If you want to get cancer, might as well do it in style!"
	product_slogans = "Space cigs taste good like a cigarette should.;I'd rather toolbox than switch.;Smoke!;Don't believe the reports - smoke today!"
	product_ads = "Probably not bad for you!;Don't believe the scientists!;It's good for you!;Don't quit, buy more!;Smoke!;Nicotine heaven.;Best cigarettes since 2150.;Award-winning cigs.;Feeling temperamental? Try a Temperamento!;Carcinoma Angels - go fuck yerself!;Don't be so hard on yourself, kid. Smoke a Lucky Star!"
	vend_delay = 34
	icon_state = "cigs"
	products = list(/obj/item/weapon/storage/fancy/cigarettes = 5,
					/obj/item/weapon/storage/fancy/cigarettes/dromedaryco = 5,
					/obj/item/weapon/storage/fancy/cigarettes/killthroat = 5,
					/obj/item/weapon/storage/fancy/cigarettes/luckystars = 5,
					/obj/item/weapon/storage/fancy/cigarettes/jerichos = 5,
					/obj/item/weapon/storage/fancy/cigarettes/menthols = 5,
					/obj/item/weapon/storage/rollingpapers = 5,
					/obj/item/weapon/storage/box/matches = 10,
					/obj/item/weapon/flame/lighter/random = 4,
					/obj/item/clothing/mask/smokable/ecig/util = 2,
					///obj/item/clothing/mask/smokable/ecig/deluxe = 2,
					/obj/item/clothing/mask/smokable/ecig/simple = 2,
					/obj/item/weapon/reagent_containers/ecig_cartridge/med_nicotine = 10,
					/obj/item/weapon/reagent_containers/ecig_cartridge/high_nicotine = 5,
					/obj/item/weapon/reagent_containers/ecig_cartridge/orange = 5,
					/obj/item/weapon/reagent_containers/ecig_cartridge/mint = 5,
					/obj/item/weapon/reagent_containers/ecig_cartridge/watermelon = 5,
					/obj/item/weapon/reagent_containers/ecig_cartridge/grape = 5,
					/obj/item/weapon/reagent_containers/ecig_cartridge/lemonlime = 5,
					/obj/item/weapon/reagent_containers/ecig_cartridge/coffee = 5,
					/obj/item/weapon/reagent_containers/ecig_cartridge/blanknico = 2)
	contraband = list(/obj/item/weapon/flame/lighter/zippo = 4)
	premium = list(/obj/item/weapon/storage/fancy/cigar = 5,
					/obj/item/weapon/storage/fancy/cigarettes/carcinomas = 5,
					/obj/item/weapon/storage/fancy/cigarettes/professionals = 5)
	prices = list(/obj/item/weapon/storage/fancy/cigarettes = 12,
					/obj/item/weapon/storage/fancy/cigarettes/dromedaryco = 15,
					/obj/item/weapon/storage/fancy/cigarettes/killthroat = 17,
					/obj/item/weapon/storage/fancy/cigarettes/luckystars = 17,
					/obj/item/weapon/storage/fancy/cigarettes/jerichos = 22,
					/obj/item/weapon/storage/fancy/cigarettes/menthols = 18,
					/obj/item/weapon/storage/rollingpapers = 10,
					/obj/item/weapon/storage/box/matches = 1,
					/obj/item/weapon/flame/lighter/random = 2,
					/obj/item/clothing/mask/smokable/ecig/util = 100,
					///obj/item/clothing/mask/smokable/ecig/deluxe = 300,
					/obj/item/clothing/mask/smokable/ecig/simple = 150,
					/obj/item/weapon/reagent_containers/ecig_cartridge/med_nicotine = 10,
					/obj/item/weapon/reagent_containers/ecig_cartridge/high_nicotine = 15,
					/obj/item/weapon/reagent_containers/ecig_cartridge/orange = 15,
					/obj/item/weapon/reagent_containers/ecig_cartridge/mint = 15,
					/obj/item/weapon/reagent_containers/ecig_cartridge/watermelon = 15,
					/obj/item/weapon/reagent_containers/ecig_cartridge/grape = 15,
					/obj/item/weapon/reagent_containers/ecig_cartridge/lemonlime = 15,
					/obj/item/weapon/reagent_containers/ecig_cartridge/coffee = 15,
					/obj/item/weapon/reagent_containers/ecig_cartridge/blanknico = 15)

	vendor_department = "Civilian"
	auto_price = 1

/obj/machinery/vending/medical
	name = "NanoMed Plus"
	desc = "Medical drug dispenser."
	icon_state = "med"
	icon_deny = "med-deny"
	product_ads = "Go save some lives!;The best stuff for your medbay.;Only the finest tools.;Natural chemicals!;This stuff saves lives.;Don't you want some?;Ping!"
	req_access = list(access_medical)
	products = list(/obj/item/weapon/reagent_containers/glass/bottle/antitoxin = 4,/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline = 4,
					/obj/item/weapon/reagent_containers/glass/bottle/stoxin = 4,/obj/item/weapon/reagent_containers/glass/bottle/toxin = 4,
					/obj/item/weapon/reagent_containers/syringe/antiviral = 4,/obj/item/weapon/reagent_containers/syringe = 12,
					/obj/item/device/healthanalyzer = 5,/obj/item/weapon/reagent_containers/glass/beaker = 4, /obj/item/weapon/reagent_containers/dropper = 2,
					/obj/item/stack/medical/advanced/bruise_pack = 6, /obj/item/stack/medical/advanced/ointment = 6, /obj/item/stack/medical/splint = 4,
					/obj/item/weapon/storage/pill_bottle/carbon = 2,
					/obj/item/weapon/reagent_containers/glass/bottle/alkysine = 5,
					/obj/item/weapon/reagent_containers/glass/bottle/peridaxon = 5)
	contraband = list(/obj/item/weapon/reagent_containers/pill/tox = 3,/obj/item/weapon/reagent_containers/pill/stox = 4,/obj/item/weapon/reagent_containers/pill/antitox = 6)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	req_log_access = access_cmo
	has_logs = 1

/obj/machinery/vending/phoronresearch
	name = "Toximate 3000"
	desc = "All the fine parts you need in one vending machine!"
	products = list(/obj/item/clothing/under/rank/scientist = 6,/obj/item/clothing/suit/bio_suit = 6,/obj/item/clothing/head/bio_hood = 6,
					/obj/item/device/transfer_valve = 6,/obj/item/device/assembly/timer = 6,/obj/item/device/assembly/signaler = 6,
					/obj/item/device/assembly/prox_sensor = 6,/obj/item/device/assembly/igniter = 6)
	req_log_access = access_rd
	has_logs = 1

/obj/machinery/vending/wallmed1
	name = "NanoMed"
	desc = "A wall-mounted version of the NanoMed."
	product_ads = "Go save some lives!;The best stuff for your medbay.;Only the finest tools.;Natural chemicals!;This stuff saves lives.;Don't you want some?"
	icon_state = "wallmed"
	icon_deny = "wallmed-deny"
	density = 0 //It is wall-mounted, and thus, not dense. --Superxpdude
	products = list(/obj/item/stack/medical/bruise_pack = 2,/obj/item/stack/medical/ointment = 2,/obj/item/weapon/reagent_containers/hypospray/autoinjector = 4,/obj/item/device/healthanalyzer = 1)
	contraband = list(/obj/item/weapon/reagent_containers/syringe/antitoxin = 4,/obj/item/weapon/reagent_containers/syringe/antiviral = 4,/obj/item/weapon/reagent_containers/pill/tox = 1)
	req_log_access = access_cmo
	has_logs = 1

/obj/machinery/vending/wallmed2
	name = "NanoMed"
	desc = "A wall-mounted version of the NanoMed, containing only vital first aid equipment."
	icon_state = "wallmed"
	icon_deny = "wallmed-deny"
	density = 0 //It is wall-mounted, and thus, not dense. --Superxpdude
	products = list(/obj/item/weapon/reagent_containers/hypospray/autoinjector = 10,/obj/item/weapon/reagent_containers/syringe/antitoxin = 10,/obj/item/stack/medical/bruise_pack = 10,
					/obj/item/stack/medical/ointment = 10, /obj/item/device/healthanalyzer = 2)
	contraband = list(/obj/item/weapon/reagent_containers/pill/tox = 3)
	req_log_access = access_cmo
	has_logs = 1

	prices = list(/obj/item/weapon/reagent_containers/hypospray/autoinjector = 15, /obj/item/weapon/reagent_containers/syringe/antitoxin = 10,/obj/item/stack/medical/bruise_pack = 15,
					/obj/item/stack/medical/ointment = 15,/obj/item/device/healthanalyzer = 10)

	vendor_department = "Public Healthcare"

/obj/machinery/vending/security
	name = "SecTech"
	desc = "A security equipment vendor."
	product_ads = "Crack capitalist skulls!;Beat some heads in!;Don't forget - harm is good!;Your weapons are right here.;Handcuffs!;Freeze, scumbag!;Don't tase me bro!;Tase them, bro.;Why not have a donut?"
	icon_state = "sec"
	icon_deny = "sec-deny"
	req_access = list(access_security)
	products = list(/obj/item/weapon/handcuffs = 8,/obj/item/weapon/grenade/flashbang = 4,/obj/item/device/flash = 5,
					/obj/item/weapon/reagent_containers/food/snacks/donut/normal = 12,/obj/item/weapon/storage/box/evidence = 6)
	contraband = list(/obj/item/clothing/glasses/sunglasses = 2,/obj/item/weapon/storage/box/donut = 2)
	req_log_access = access_armory
	has_logs = 1

/obj/machinery/vending/hydronutrients
	name = "NutriMax"
	desc = "A plant nutrients vendor."
	product_slogans = "Aren't you glad you don't have to fertilize the natural way?;Now with 50% less stink!;Plants are people too!"
	product_ads = "We like plants!;Don't you want some?;The greenest thumbs ever.;We like big plants.;Soft soil..."
	icon_state = "nutri"
	icon_deny = "nutri-deny"
	products = list(/obj/item/weapon/reagent_containers/glass/bottle/eznutrient = 6,/obj/item/weapon/reagent_containers/glass/bottle/left4zed = 4,/obj/item/weapon/reagent_containers/glass/bottle/robustharvest = 3,/obj/item/weapon/plantspray/pests = 20,
					/obj/item/weapon/reagent_containers/syringe = 5,/obj/item/weapon/storage/bag/plants = 5)
	premium = list(/obj/item/weapon/reagent_containers/glass/bottle/ammonia = 10,/obj/item/weapon/reagent_containers/glass/bottle/diethylamine = 5)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.

/obj/machinery/vending/hydroseeds
	name = "MegaSeed Servitor"
	desc = "When you need seeds fast!"
	product_slogans = "THIS'S WHERE TH' SEEDS LIVE! GIT YOU SOME!;Hands down the best seed selection on the station!;Also certain mushroom varieties available, more for experts! Get certified today!"
	product_ads = "We like plants!;Grow some crops!;Grow, baby, growww!;Aw h'yeah son!"
	icon_state = "seeds"

	products = list(/obj/item/seeds/bananaseed = 3,/obj/item/seeds/berryseed = 3,/obj/item/seeds/carrotseed = 3,/obj/item/seeds/chantermycelium = 3,/obj/item/seeds/chiliseed = 3,
					/obj/item/seeds/cornseed = 3, /obj/item/seeds/eggplantseed = 3, /obj/item/seeds/potatoseed = 3, /obj/item/seeds/replicapod = 3,/obj/item/seeds/soyaseed = 3,
					/obj/item/seeds/sunflowerseed = 3,/obj/item/seeds/tomatoseed = 3,/obj/item/seeds/towermycelium = 3,/obj/item/seeds/wheatseed = 3,/obj/item/seeds/appleseed = 3,
					/obj/item/seeds/poppyseed = 3,/obj/item/seeds/sugarcaneseed = 3,/obj/item/seeds/cannabisseed = 3,/obj/item/seeds/peanutseed = 3,/obj/item/seeds/whitebeetseed = 3,/obj/item/seeds/watermelonseed = 3,/obj/item/seeds/lavenderseed = 3,/obj/item/seeds/limeseed = 3,
					/obj/item/seeds/lemonseed = 3,/obj/item/seeds/orangeseed = 3,/obj/item/seeds/grassseed = 3,/obj/item/seeds/cocoapodseed = 3,/obj/item/seeds/plumpmycelium = 2,
					/obj/item/seeds/cabbageseed = 3,/obj/item/seeds/grapeseed = 3,/obj/item/seeds/pumpkinseed = 3,/obj/item/seeds/cherryseed = 3,/obj/item/seeds/plastiseed = 3,/obj/item/seeds/riceseed = 3)
	contraband = list(/obj/item/seeds/amanitamycelium = 2,/obj/item/seeds/glowshroom = 2,/obj/item/seeds/libertymycelium = 2,/obj/item/seeds/mtearseed = 2,
					  /obj/item/seeds/nettleseed = 2,/obj/item/seeds/reishimycelium = 2,/obj/item/seeds/reishimycelium = 2,/obj/item/seeds/shandseed = 2,)
	premium = list(/obj/item/toy/waterflower = 1)

/**
 *  Populate hydroseeds product_records
 *
 *  This needs to be customized to fetch the actual names of the seeds, otherwise
 *  the machine would simply list "packet of seeds" times 20
 */
/obj/machinery/vending/hydroseeds/build_inventory()
	var/list/all_products = list(
		list(products, CAT_NORMAL),
		list(contraband, CAT_HIDDEN),
		list(premium, CAT_COIN))

	for(var/current_list in all_products)
		var/category = current_list[2]

		for(var/entry in current_list[1])
			var/obj/item/seeds/S = new entry(src)
			var/name = S.name
			var/datum/stored_item/vending_product/product = new/datum/stored_item/vending_product(src, entry, name)

			product.price = (entry in prices) ? prices[entry] : 0
			product.amount = (current_list[1][entry]) ? current_list[1][entry] : 1
			product.category = category

			product_records.Add(product)

/obj/machinery/vending/magivend
	name = "MagiVend"
	desc = "A magic vending machine."
	icon_state = "MagiVend"
	product_slogans = "Sling spells the proper way with MagiVend!;Be your own Houdini! Use MagiVend!"
	vend_delay = 15
	vend_reply = "Have an enchanted evening!"
	product_ads = "FJKLFJSD;AJKFLBJAKL;1234 LOONIES LOL!;>MFW;Kill them fuckers!;GET DAT FUKKEN DISK;HONK!;EI NATH;Destroy the station!;Admin conspiracies since forever!;Space-time bending hardware!"
	products = list(/obj/item/clothing/head/wizard = 1,/obj/item/clothing/suit/wizrobe = 1,/obj/item/clothing/head/wizard/red = 1,/obj/item/clothing/suit/wizrobe/red = 1,/obj/item/clothing/shoes/sandal = 1,/obj/item/weapon/staff = 2)

/obj/machinery/vending/dinnerware
	name = "Dinnerware"
	desc = "A kitchen and restaurant equipment vendor."
	product_ads = "Mm, food stuffs!;Food and food accessories.;Get your plates!;You like forks?;I like forks.;Woo, utensils.;You don't really need these..."
	icon_state = "dinnerware"
	products = list(
	/obj/item/weapon/tray = 8,
	/obj/item/weapon/material/kitchen/utensil/fork = 6,
	/obj/item/weapon/material/knife = 6,
	/obj/item/weapon/material/kitchen/utensil/spoon = 6,
	/obj/item/weapon/material/knife = 3,
	/obj/item/weapon/material/kitchen/rollingpin = 2,
	/obj/item/weapon/reagent_containers/food/drinks/glass2/square = 8,
	/obj/item/weapon/reagent_containers/food/drinks/glass2/shake = 8,
	/obj/item/weapon/glass_extra/stick = 15,
	/obj/item/weapon/glass_extra/straw = 15,
	/obj/item/clothing/suit/chef/classic = 2,
	/obj/item/weapon/storage/bag/food = 2,
	/obj/item/weapon/storage/toolbox/lunchbox = 3,
	/obj/item/weapon/storage/toolbox/lunchbox/heart = 3,
	/obj/item/weapon/storage/toolbox/lunchbox/cat = 3,
	/obj/item/weapon/storage/toolbox/lunchbox/nt = 3,
	/obj/item/weapon/storage/toolbox/lunchbox/mars = 3,
	/obj/item/weapon/storage/toolbox/lunchbox/cti = 3,
	/obj/item/weapon/storage/toolbox/lunchbox/nymph = 3,
	/obj/item/weapon/storage/toolbox/lunchbox/syndicate = 3)
	contraband = list(/obj/item/weapon/material/knife/butch = 2)

/obj/machinery/vending/sovietsoda
	name = "BODA"
	desc = "An old sweet water vending machine,how did this end up here?"
	icon_state = "sovietsoda"
	product_ads = "For Tsar and Country.;Have you fulfilled your nutrition quota today?;Very nice!;We are simple people, for this is all we eat.;If there is a person, there is a problem. If there is no person, then there is no problem."
	products = list(/obj/item/weapon/reagent_containers/food/drinks/bottle/space_up = 30) // TODO Russian soda can
	contraband = list(/obj/item/weapon/reagent_containers/food/drinks/bottle/cola = 20) // TODO Russian cola can
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	vending_sound = "machines/vending_cans.ogg"

/obj/machinery/vending/tool
	name = "YouTool"
	desc = "Tools for tools."
	icon_state = "tool"
	icon_deny = "tool-deny"
	//req_access = list(access_maint_tunnels) //Maintenance access
	products = list(/obj/item/stack/cable_coil/random = 10,/obj/item/weapon/crowbar = 5,/obj/item/weapon/weldingtool = 3,/obj/item/weapon/wirecutters = 5,
					/obj/item/weapon/wrench = 5,/obj/item/device/analyzer = 5,/obj/item/device/t_scanner = 5,/obj/item/weapon/screwdriver = 5,
					/obj/item/device/flashlight/glowstick = 3, /obj/item/device/flashlight/glowstick/red = 3, /obj/item/device/flashlight/glowstick/blue = 3,
					/obj/item/device/flashlight/glowstick/orange =3, /obj/item/device/flashlight/glowstick/yellow = 3)
	contraband = list(/obj/item/weapon/weldingtool/hugetank = 2,/obj/item/clothing/gloves/fyellow = 2,)
	premium = list(/obj/item/clothing/gloves/yellow = 1)
	req_log_access = access_ce
	has_logs = 1

/obj/machinery/vending/engivend
	name = "Engi-Vend"
	desc = "Spare tool vending. What? Did you expect some witty description?"
	icon_state = "engivend"
	icon_deny = "engivend-deny"
	req_access = list(access_engine_equip)
	products = list(/obj/item/device/geiger = 4,/obj/item/clothing/glasses/meson = 2,/obj/item/device/multitool = 4,/obj/item/weapon/cell/high = 10,
					/obj/item/weapon/airlock_electronics = 10,/obj/item/weapon/module/power_control = 10,
					/obj/item/weapon/circuitboard/airalarm = 10,/obj/item/weapon/circuitboard/firealarm = 10,/obj/item/weapon/circuitboard/status_display = 2,
					/obj/item/weapon/circuitboard/ai_status_display = 2,/obj/item/weapon/circuitboard/newscaster = 2,/obj/item/weapon/circuitboard/holopad = 2,
					/obj/item/weapon/circuitboard/intercom = 4,/obj/item/weapon/circuitboard/security/telescreen/entertainment = 4,
					/obj/item/weapon/stock_parts/motor = 2,/obj/item/weapon/stock_parts/spring = 2,/obj/item/weapon/stock_parts/gear = 2,
					/obj/item/weapon/circuitboard/atm,/obj/item/weapon/circuitboard/guestpass,/obj/item/weapon/circuitboard/keycard_auth,
					/obj/item/weapon/circuitboard/photocopier,/obj/item/weapon/circuitboard/fax,/obj/item/weapon/circuitboard/request,
					/obj/item/weapon/circuitboard/microwave,/obj/item/weapon/circuitboard/washing,/obj/item/weapon/circuitboard/scanner_console,
					/obj/item/weapon/circuitboard/sleeper_console,/obj/item/weapon/circuitboard/body_scanner,/obj/item/weapon/circuitboard/sleeper,
					/obj/item/weapon/circuitboard/dna_analyzer)
	contraband = list(/obj/item/weapon/cell/potato = 3)
	premium = list(/obj/item/weapon/storage/belt/utility = 3)
	product_records = list()
	req_log_access = access_ce
	has_logs = 1

/obj/machinery/vending/engineering
	name = "Robco Tool Maker"
	desc = "Everything you need for do-it-yourself station repair."
	icon_state = "engi"
	icon_deny = "engi-deny"
	req_access = list(access_engine_equip)
	products = list(/obj/item/clothing/under/rank/chief_engineer = 4,/obj/item/clothing/under/rank/engineer = 4,/obj/item/clothing/shoes/orange = 4,/obj/item/clothing/head/hardhat = 4,
					/obj/item/weapon/storage/belt/utility = 4,/obj/item/clothing/glasses/meson = 4,/obj/item/clothing/gloves/yellow = 4, /obj/item/weapon/screwdriver = 12,
					/obj/item/weapon/crowbar = 12,/obj/item/weapon/wirecutters = 12,/obj/item/device/multitool = 12,/obj/item/weapon/wrench = 12,/obj/item/device/t_scanner = 12,
					/obj/item/stack/cable_coil/heavyduty = 8, /obj/item/weapon/cell = 8, /obj/item/weapon/weldingtool = 8,/obj/item/clothing/head/welding = 8,
					/obj/item/weapon/light/tube = 10,/obj/item/clothing/suit/fire = 4, /obj/item/weapon/stock_parts/scanning_module = 5,/obj/item/weapon/stock_parts/micro_laser = 5,
					/obj/item/weapon/stock_parts/matter_bin = 5,/obj/item/weapon/stock_parts/manipulator = 5,/obj/item/weapon/stock_parts/console_screen = 5)
	// There was an incorrect entry (cablecoil/power).  I improvised to cablecoil/heavyduty.
	// Another invalid entry, /obj/item/weapon/circuitry.  I don't even know what that would translate to, removed it.
	// The original products list wasn't finished.  The ones without given quantities became quantity 5.  -Sayu
	req_log_access = access_ce
	has_logs = 1

/obj/machinery/vending/robotics
	name = "Robotech Deluxe"
	desc = "All the tools you need to create your own robot army."
	icon_state = "robotics"
	icon_deny = "robotics-deny"
	req_access = list(access_robotics)
	products = list(/obj/item/clothing/suit/storage/toggle/labcoat = 4,/obj/item/clothing/under/rank/roboticist = 4,/obj/item/stack/cable_coil = 4,/obj/item/device/flash = 4,
					/obj/item/weapon/cell/high = 12, /obj/item/device/assembly/prox_sensor = 3,/obj/item/device/assembly/signaler = 3,/obj/item/device/healthanalyzer = 3,
					/obj/item/weapon/surgical/scalpel = 2,/obj/item/weapon/surgical/circular_saw = 2,/obj/item/weapon/tank/anesthetic = 2,/obj/item/clothing/mask/breath/medical = 5,
					/obj/item/weapon/screwdriver = 5,/obj/item/weapon/crowbar = 5)
	//everything after the power cell had no amounts, I improvised.  -Sayu
	req_log_access = access_rd
	has_logs = 1

/obj/machinery/vending/giftvendor
	name = "AlliCo Baubles and Confectionaries"
	desc = "For that special someone!"
	icon_state = "giftvendor"
	vend_delay = 15
	products = list(/obj/item/weapon/spacecash/ewallet/lotto = 8,
					/obj/item/weapon/storage/fancy/heartbox = 5,
					/obj/item/toy/bouquet = 5,
					/obj/item/toy/bouquet/fake = 4,
					/obj/item/weapon/melee/umbrella/random = 10,
					/obj/item/weapon/spirit_board = 2,
					/obj/item/weapon/paper/card/smile = 3,
					/obj/item/weapon/paper/card/heart = 3,
					/obj/item/weapon/paper/card/cat = 3,
					/obj/item/weapon/paper/card/flower = 3,
					/obj/item/clothing/accessory/bracelet/friendship = 5,
					/obj/item/toy/plushie/therapy/red = 2,
					/obj/item/toy/plushie/therapy/purple = 2,
					/obj/item/toy/plushie/therapy/blue = 2,
					/obj/item/toy/plushie/therapy/yellow = 2,
					/obj/item/toy/plushie/therapy/orange = 2,
					/obj/item/toy/plushie/therapy/green = 2,
					/obj/item/toy/plushie/nymph = 2,
					/obj/item/toy/plushie/mouse = 2,
					/obj/item/toy/plushie/kitten = 2,
					/obj/item/toy/plushie/lizard = 2,
					/obj/item/toy/plushie/spider = 2,
					/obj/item/toy/plushie/farwa = 2,
					/obj/item/toy/plushie/corgi = 1,
					/obj/item/toy/plushie/octopus = 1,
					/obj/item/toy/plushie/face_hugger = 1,
					/obj/item/toy/plushie/carp = 1,
					/obj/item/toy/plushie/deer = 1,
					/obj/item/toy/plushie/tabby_cat = 1)
	premium = list(/obj/item/weapon/reagent_containers/food/drinks/bottle/champagne = 1,
					/obj/item/weapon/storage/trinketbox = 2)
	prices = list(/obj/item/weapon/spacecash/ewallet/lotto = 5,
					/obj/item/weapon/storage/fancy/heartbox = 15,
					/obj/item/toy/bouquet = 10,
					/obj/item/toy/bouquet/fake = 3,
					/obj/item/weapon/spirit_board = 50,
					/obj/item/weapon/melee/umbrella/random = 15,
					/obj/item/weapon/paper/card/smile = 1,
					/obj/item/weapon/paper/card/heart = 1,
					/obj/item/weapon/paper/card/cat = 1,
					/obj/item/weapon/paper/card/flower = 1,
					/obj/item/clothing/accessory/bracelet/friendship = 5,
					/obj/item/toy/plushie/therapy/red = 20,
					/obj/item/toy/plushie/therapy/purple = 20,
					/obj/item/toy/plushie/therapy/blue = 20,
					/obj/item/toy/plushie/therapy/yellow = 20,
					/obj/item/toy/plushie/therapy/orange = 20,
					/obj/item/toy/plushie/therapy/green = 20,
					/obj/item/toy/plushie/nymph = 35,
					/obj/item/toy/plushie/mouse = 35,
					/obj/item/toy/plushie/kitten = 35,
					/obj/item/toy/plushie/lizard = 35,
					/obj/item/toy/plushie/spider = 35,
					/obj/item/toy/plushie/farwa = 35,
					/obj/item/toy/plushie/corgi = 50,
					/obj/item/toy/plushie/octopus = 50,
					/obj/item/toy/plushie/face_hugger = 50,
					/obj/item/toy/plushie/carp = 50,
					/obj/item/toy/plushie/deer = 50,
					/obj/item/toy/plushie/tabby_cat = 50)

	vendor_department = "Civilian"

// Clothing dispensers

/obj/machinery/vending/clothes
	name = "Clothes Dispenser"
	desc = "Dispenses clothes."
	icon_state = "clothes"
	//req_access_txt = "0" //Maintenance access
	products = list(
						/obj/item/clothing/under/pants = 10,
						/obj/item/clothing/under/pants/ripped = 10,
						/obj/item/clothing/under/pants/baggy/camo = 10,
						/obj/item/clothing/under/pants/baggy/track = 10,
						/obj/item/clothing/under/pants/baggy/youngfolksjeans = 10,
						/obj/item/clothing/under/pants/baggy/tan = 10,
						/obj/item/clothing/under/pants/baggy/black = 10,
						/obj/item/clothing/under/pants/baggy/blackjeans = 10,
						/obj/item/clothing/under/pants/baggy/greyjeans = 10,
						/obj/item/clothing/under/pants/baggy/mustangjeans = 10,
						/obj/item/clothing/under/pants/classicjeans = 10,
						/obj/item/clothing/under/pants/classicjeans/ripped = 10,
						/obj/item/clothing/under/pants/greyjeans = 10,
						/obj/item/clothing/under/pants/greyjeans/ripped = 10,
						/obj/item/clothing/under/pants/yogapants = 10,
						/obj/item/clothing/under/pants/baggy/red = 10,
						/obj/item/clothing/under/pants/baggy/white = 10,
						/obj/item/clothing/under/pants/blackjeans = 10,
						/obj/item/clothing/under/pants/blackjeans/ripped = 10,
						/obj/item/clothing/under/pants/chaps = 10,
						/obj/item/clothing/under/pants/chaps/black = 10,
						/obj/item/clothing/under/suit_jacket/burgundy = 10,
						/obj/item/clothing/under/suit_jacket/burgundy/skirt = 10,
						/obj/item/clothing/under/suit_jacket/charcoal = 10,
						/obj/item/clothing/under/suit_jacket/charcoal/skirt = 10,
						/obj/item/clothing/under/suit_jacket/checkered = 10,
						/obj/item/clothing/under/suit_jacket/checkered/skirt = 10,
						/obj/item/clothing/under/suit_jacket/female = 10,
						/obj/item/clothing/under/suit_jacket/female/skirt = 10,
						/obj/item/clothing/under/suit_jacket/navy = 10,
						/obj/item/clothing/under/suit_jacket/navy/skirt = 10,
						/obj/item/clothing/under/suit_jacket/really_black = 10,
						/obj/item/clothing/under/suit_jacket/really_black/skirt = 10,
						/obj/item/clothing/under/suit_jacket/red = 10,
						/obj/item/clothing/under/suit_jacket/red/skirt = 10,
						/obj/item/clothing/under/suit_jacket/tan = 10,
						/obj/item/clothing/under/suit_jacket/tan/skirt = 10,
						/obj/item/clothing/under/wedding/bride_purple = 1,
						/obj/item/clothing/under/wedding/bride_red = 1,
						/obj/item/clothing/under/wedding/bride_blue = 1,
						/obj/item/clothing/under/wedding/bride_orange = 1,
						/obj/item/clothing/under/wedding/bride_white = 10,
						/obj/item/clothing/under/sexyclown = 10,
						/obj/item/clothing/under/kilt = 10,
						/obj/item/clothing/under/oldwoman = 10,
						/obj/item/clothing/under/dress/dress_orange = 10,
						/obj/item/clothing/under/dress/flamenco = 10,
						/obj/item/clothing/under/dress/westernbustle = 10,
						/obj/item/clothing/under/dress/flower_dress = 10,
						/obj/item/clothing/under/dress/red_swept_dress = 10,
						/obj/item/clothing/under/dress/dress_green = 10,
						/obj/item/clothing/under/dress/blacktango = 10,
						/obj/item/clothing/under/dress/redeveninggown = 10,
						/obj/item/clothing/under/dress/stripeddress = 10,
						/obj/item/clothing/under/dress/dress_saloon = 10,
						/obj/item/clothing/under/dress/dress_fire = 10,
						/obj/item/clothing/under/dress/dress_hr = 10,
						/obj/item/clothing/under/dress/dress_green = 10,
						/obj/item/clothing/under/dress/black_corset = 10,
						/obj/item/clothing/under/sundress = 10,
						/obj/item/clothing/under/sundress_white = 10,
						/obj/item/clothing/under/skirt = 10,
						/obj/item/clothing/under/skirt/khaki = 10,
						/obj/item/clothing/under/skirt/blue = 10,
						/obj/item/clothing/under/skirt/red = 10,
						/obj/item/clothing/under/skirt/swept = 10,
						/obj/item/clothing/under/skirt/denim = 10,
						/obj/item/clothing/under/shorts = 10,
						/obj/item/clothing/under/shorts/black = 10,
						/obj/item/clothing/under/shorts/red = 10,
						/obj/item/clothing/under/shorts/white = 10,
						/obj/item/clothing/under/shorts/white/female = 10,
						/obj/item/clothing/under/shorts/blue = 10,
						/obj/item/clothing/under/shorts/green = 10,
						/obj/item/clothing/under/shorts/grey = 10,
						/obj/item/clothing/under/shorts/jeans = 10,
						/obj/item/clothing/under/shorts/jeans/female = 10,
						/obj/item/clothing/under/shorts/jeans/black = 10,
						/obj/item/clothing/under/shorts/jeans/black/female = 10,
						/obj/item/clothing/under/shorts/jeans/classic = 10,
						/obj/item/clothing/under/shorts/jeans/classic/female = 10,
						/obj/item/clothing/under/shorts/jeans/grey = 10,
						/obj/item/clothing/under/shorts/jeans/grey/female = 10,
						/obj/item/clothing/under/shorts/jeans/mustang = 10,
						/obj/item/clothing/under/shorts/jeans/mustang/female = 10,
						/obj/item/clothing/under/shorts/jeans/youngfolks = 10,
						/obj/item/clothing/under/shorts/jeans/youngfolks/female = 10,
						/obj/item/clothing/under/croptop = 10,
						/obj/item/clothing/under/croptop/grey = 10,
						/obj/item/clothing/under/croptop/red = 10,
						/obj/item/clothing/under/cuttop = 10,
						/obj/item/clothing/under/cuttop/red = 10)

	prices = list(
						/obj/item/clothing/under/pants = 35,
						/obj/item/clothing/under/pants/ripped = 35,
						/obj/item/clothing/under/pants/baggy/camo = 35,
						/obj/item/clothing/under/pants/baggy/track = 35,
						/obj/item/clothing/under/pants/baggy/youngfolksjeans = 35,
						/obj/item/clothing/under/pants/baggy/tan = 35,
						/obj/item/clothing/under/pants/baggy/black = 35,
						/obj/item/clothing/under/pants/baggy/blackjeans = 35,
						/obj/item/clothing/under/pants/baggy/greyjeans = 35,
						/obj/item/clothing/under/pants/baggy/mustangjeans = 35,
						/obj/item/clothing/under/pants/classicjeans = 35,
						/obj/item/clothing/under/pants/classicjeans/ripped = 35,
						/obj/item/clothing/under/pants/greyjeans = 35,
						/obj/item/clothing/under/pants/greyjeans/ripped = 35,
						/obj/item/clothing/under/pants/yogapants = 35,
						/obj/item/clothing/under/pants/baggy/red = 35,
						/obj/item/clothing/under/pants/baggy/white = 35,
						/obj/item/clothing/under/pants/blackjeans = 35,
						/obj/item/clothing/under/pants/blackjeans/ripped = 35,
						/obj/item/clothing/under/pants/chaps = 25,
						/obj/item/clothing/under/pants/chaps/black = 25,
						/obj/item/clothing/under/suit_jacket/burgundy = 50,
						/obj/item/clothing/under/suit_jacket/burgundy/skirt = 50,
						/obj/item/clothing/under/suit_jacket/charcoal = 50,
						/obj/item/clothing/under/suit_jacket/charcoal/skirt = 50,
						/obj/item/clothing/under/suit_jacket/checkered = 50,
						/obj/item/clothing/under/suit_jacket/checkered/skirt = 50,
						/obj/item/clothing/under/suit_jacket/female = 50,
						/obj/item/clothing/under/suit_jacket/female/skirt = 50,
						/obj/item/clothing/under/suit_jacket/navy = 50,
						/obj/item/clothing/under/suit_jacket/navy/skirt = 50,
						/obj/item/clothing/under/suit_jacket/really_black = 50,
						/obj/item/clothing/under/suit_jacket/really_black/skirt = 50,
						/obj/item/clothing/under/suit_jacket/red = 50,
						/obj/item/clothing/under/suit_jacket/red/skirt = 50,
						/obj/item/clothing/under/suit_jacket/tan = 50,
						/obj/item/clothing/under/suit_jacket/tan/skirt = 50,
						/obj/item/clothing/under/wedding/bride_purple = 120,
						/obj/item/clothing/under/wedding/bride_red = 120,
						/obj/item/clothing/under/wedding/bride_blue = 120,
						/obj/item/clothing/under/wedding/bride_orange = 120,
						/obj/item/clothing/under/wedding/bride_white = 150,
						/obj/item/clothing/under/sexyclown = 30,
						/obj/item/clothing/under/kilt = 20,
						/obj/item/clothing/under/oldwoman = 20,
						/obj/item/clothing/under/dress/dress_orange = 50,
						/obj/item/clothing/under/dress/flamenco = 55,
						/obj/item/clothing/under/dress/westernbustle = 60,
						/obj/item/clothing/under/dress/flower_dress = 60,
						/obj/item/clothing/under/dress/red_swept_dress = 60,
						/obj/item/clothing/under/dress/dress_green = 60,
						/obj/item/clothing/under/dress/blacktango = 60,
						/obj/item/clothing/under/dress/redeveninggown = 60,
						/obj/item/clothing/under/dress/stripeddress = 60,
						/obj/item/clothing/under/dress/dress_saloon = 50,
						/obj/item/clothing/under/dress/dress_fire = 60,
						/obj/item/clothing/under/dress/dress_hr = 40,
						/obj/item/clothing/under/dress/dress_green = 40,
						/obj/item/clothing/under/dress/black_corset = 60,
						/obj/item/clothing/under/sundress = 60,
						/obj/item/clothing/under/sundress_white = 50,
						/obj/item/clothing/under/skirt = 40,
						/obj/item/clothing/under/skirt/khaki = 60,
						/obj/item/clothing/under/skirt/blue = 50,
						/obj/item/clothing/under/skirt/red = 70,
						/obj/item/clothing/under/skirt/swept = 70,
						/obj/item/clothing/under/skirt/denim = 50,
						/obj/item/clothing/under/shorts = 40,
						/obj/item/clothing/under/shorts/black = 30,
						/obj/item/clothing/under/shorts/red = 30,
						/obj/item/clothing/under/shorts/white = 30,
						/obj/item/clothing/under/shorts/white/female = 30,
						/obj/item/clothing/under/shorts/blue = 30,
						/obj/item/clothing/under/shorts/green = 30,
						/obj/item/clothing/under/shorts/grey = 30,
						/obj/item/clothing/under/shorts/jeans = 30,
						/obj/item/clothing/under/shorts/jeans/female = 30,
						/obj/item/clothing/under/shorts/jeans/black = 30,
						/obj/item/clothing/under/shorts/jeans/black/female = 30,
						/obj/item/clothing/under/shorts/jeans/classic = 30,
						/obj/item/clothing/under/shorts/jeans/classic/female = 30,
						/obj/item/clothing/under/shorts/jeans/grey = 30,
						/obj/item/clothing/under/shorts/jeans/grey/female = 30,
						/obj/item/clothing/under/shorts/jeans/mustang = 30,
						/obj/item/clothing/under/shorts/jeans/mustang/female = 30,
						/obj/item/clothing/under/shorts/jeans/youngfolks = 30,
						/obj/item/clothing/under/shorts/jeans/youngfolks/female = 30,
						/obj/item/clothing/under/croptop = 30,
						/obj/item/clothing/under/croptop/grey = 30,
						/obj/item/clothing/under/croptop/red = 30,
						/obj/item/clothing/under/cuttop = 30,
						/obj/item/clothing/under/cuttop/red = 30)
	vendor_department = "Civilian"

/obj/machinery/vending/suitdispenser
	name = "\improper Suitlord 9000"
	desc = "You wonder for a moment why all of your shirts and pants come conjoined. This hurts your head and you stop thinking about it."
	icon_state = "suits"
	product_ads = "Pre-Ironed, Pre-Washed, Pre-Wor-*BZZT*;Blood of your enemies washes right out!;Who are YOU wearing?;Look dapper! Look like an idiot!;Dont carry your size? How about you shave off some pounds you fat lazy- *BZZT*"
	products = list(/obj/item/clothing/suit/storage/toggle/bomber = 10,
						 /obj/item/clothing/suit/storage/bomber/alt = 10,
						 /obj/item/clothing/suit/storage/flannel = 10,
						 /obj/item/clothing/suit/storage/flannel/aqua = 10,
						 /obj/item/clothing/suit/storage/flannel/brown = 10,
						 /obj/item/clothing/suit/storage/flannel/red = 10,
						 /obj/item/clothing/suit/varsity = 10,
						 /obj/item/clothing/suit/varsity/blue = 10,
						 /obj/item/clothing/suit/varsity/brown = 10,
						 /obj/item/clothing/suit/varsity/green = 10,
						 /obj/item/clothing/suit/varsity/purple = 10,
						 /obj/item/clothing/suit/varsity/red = 10,
						 /obj/item/clothing/suit/whitedress = 10,
						 /obj/item/clothing/suit/storage/toggle/denim_jacket = 10,
						 /obj/item/clothing/suit/storage/toggle/denim_jacket/sleeveless = 10,
						 /obj/item/clothing/accessory/poncho = 10,
						 /obj/item/clothing/accessory/poncho/green = 10,
						 /obj/item/clothing/accessory/poncho/red = 10,
						 /obj/item/clothing/accessory/poncho/purple = 10,
						 /obj/item/clothing/accessory/poncho/blue = 10,
						 /obj/item/clothing/suit/storage/duster = 10,
						 /obj/item/clothing/suit/storage/greyjacket = 10,
						 /obj/item/clothing/suit/jacket/puffer = 10,
						 /obj/item/clothing/suit/jacket/puffer/vest = 10,
						 /obj/item/clothing/suit/storage/toggle/leather_jacket = 10,
						 /obj/item/clothing/suit/storage/toggle/leather_jacket/sleeveless = 10,
						 /obj/item/clothing/suit/storage/toggle/leather_jacket/nanotrasen = 10,
						 /obj/item/clothing/suit/storage/toggle/brown_jacket = 10,
						 /obj/item/clothing/suit/storage/toggle/brown_jacket/sleeveless = 10,
						 /obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen = 10,
						 /obj/item/clothing/suit/storage/toggle/hoodie = 10,
						 /obj/item/clothing/suit/storage/toggle/hoodie/black = 10,
						 /obj/item/clothing/suit/storage/toggle/hoodie/blue = 10,
						 /obj/item/clothing/suit/storage/toggle/hoodie/green = 10,
						 /obj/item/clothing/suit/storage/toggle/hoodie/mu = 10,
						 /obj/item/clothing/suit/storage/toggle/hoodie/nt = 10,
						 /obj/item/clothing/suit/storage/toggle/hoodie/orange = 10,
						 /obj/item/clothing/suit/storage/toggle/hoodie/red = 10,
						 /obj/item/clothing/suit/storage/toggle/hoodie/smw = 10,
						 /obj/item/clothing/suit/storage/toggle/hoodie/yellow = 10,
						 /obj/item/clothing/suit/suspenders = 10,
						 /obj/item/clothing/accessory/wcoat = 10,
						 /obj/item/clothing/suit/storage/apron/overalls = 10,
						 /obj/item/clothing/suit/nun = 10,
						 /obj/item/clothing/suit/pirate = 10,
						 /obj/item/clothing/suit/hgpirate = 10,
						 /obj/item/clothing/suit/leathercoat = 10,
						 /obj/item/clothing/suit/storage/toggle/track = 10,
						 /obj/item/clothing/suit/storage/toggle/track/blue = 10,
						 /obj/item/clothing/suit/storage/toggle/track/green = 10,
						 /obj/item/clothing/suit/storage/toggle/track/red = 10,
						 /obj/item/clothing/suit/storage/toggle/track/white = 10,
						 /obj/item/clothing/suit/storage/trench = 10,
						 /obj/item/clothing/suit/storage/trench/grey = 10,
						 /obj/item/clothing/suit/storage/miljacket = 10,
						 /obj/item/clothing/suit/storage/miljacket/alt = 10,
						 /obj/item/clothing/suit/storage/miljacket/green = 10,
						 /obj/item/clothing/suit/storage/snowsuit = 10,
						 /obj/item/clothing/suit/storage/hooded/wintercoat = 10)

	prices = list(/obj/item/clothing/suit/storage/toggle/bomber = 80,
						 /obj/item/clothing/suit/storage/bomber/alt = 50,
						 /obj/item/clothing/suit/storage/flannel = 30,
						 /obj/item/clothing/suit/storage/flannel/aqua = 30,
						 /obj/item/clothing/suit/storage/flannel/brown = 30,
						 /obj/item/clothing/suit/storage/flannel/red = 30,
						 /obj/item/clothing/suit/varsity = 60,
						 /obj/item/clothing/suit/varsity/blue = 60,
						 /obj/item/clothing/suit/varsity/brown = 60,
						 /obj/item/clothing/suit/varsity/green = 60,
						 /obj/item/clothing/suit/varsity/purple = 60,
						 /obj/item/clothing/suit/varsity/red = 30,
						 /obj/item/clothing/suit/whitedress = 30,
						 /obj/item/clothing/suit/storage/toggle/denim_jacket = 35,
						 /obj/item/clothing/suit/storage/toggle/denim_jacket/sleeveless = 30,
						 /obj/item/clothing/accessory/poncho = 20,
						 /obj/item/clothing/accessory/poncho/green = 20,
						 /obj/item/clothing/accessory/poncho/red = 20,
						 /obj/item/clothing/accessory/poncho/purple = 20,
						 /obj/item/clothing/accessory/poncho/blue = 20,
						 /obj/item/clothing/suit/storage/duster = 40,
						 /obj/item/clothing/suit/storage/greyjacket = 60,
						 /obj/item/clothing/suit/jacket/puffer = 40,
						 /obj/item/clothing/suit/jacket/puffer/vest = 40,
						 /obj/item/clothing/suit/storage/toggle/leather_jacket = 40,
						 /obj/item/clothing/suit/storage/toggle/leather_jacket/sleeveless = 40,
						 /obj/item/clothing/suit/storage/toggle/leather_jacket/nanotrasen = 40,
						 /obj/item/clothing/suit/storage/toggle/brown_jacket = 40,
						 /obj/item/clothing/suit/storage/toggle/brown_jacket/sleeveless = 40,
						 /obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen = 40,
						 /obj/item/clothing/suit/storage/toggle/hoodie = 30,
						 /obj/item/clothing/suit/storage/toggle/hoodie/black = 30,
						 /obj/item/clothing/suit/storage/toggle/hoodie/blue = 30,
						 /obj/item/clothing/suit/storage/toggle/hoodie/green = 30,
						 /obj/item/clothing/suit/storage/toggle/hoodie/mu = 30,
						 /obj/item/clothing/suit/storage/toggle/hoodie/nt = 30,
						 /obj/item/clothing/suit/storage/toggle/hoodie/orange = 30,
						 /obj/item/clothing/suit/storage/toggle/hoodie/red = 30,
						 /obj/item/clothing/suit/storage/toggle/hoodie/smw = 30,
						 /obj/item/clothing/suit/storage/toggle/hoodie/yellow = 30,
						 /obj/item/clothing/suit/suspenders = 30,
						 /obj/item/clothing/accessory/wcoat = 25,
						 /obj/item/clothing/suit/storage/apron/overalls = 20,
						 /obj/item/clothing/suit/nun = 30,
						 /obj/item/clothing/suit/pirate = 30,
						 /obj/item/clothing/suit/hgpirate = 30,
						 /obj/item/clothing/suit/leathercoat = 30,
						 /obj/item/clothing/suit/storage/toggle/track = 35,
						 /obj/item/clothing/suit/storage/toggle/track/blue = 35,
						 /obj/item/clothing/suit/storage/toggle/track/green = 35,
						 /obj/item/clothing/suit/storage/toggle/track/red = 35,
						 /obj/item/clothing/suit/storage/toggle/track/white = 35,
						 /obj/item/clothing/suit/storage/trench = 60,
						 /obj/item/clothing/suit/storage/trench/grey = 60,
						 /obj/item/clothing/suit/storage/miljacket = 80,
						 /obj/item/clothing/suit/storage/miljacket/alt = 80,
						 /obj/item/clothing/suit/storage/miljacket/green = 80,
						 /obj/item/clothing/suit/storage/snowsuit = 40,
						 /obj/item/clothing/suit/storage/hooded/wintercoat = 40)

	vendor_department = "Civilian"
/obj/machinery/vending/shoedispenser
	name = "\improper Shoe O Mat"
	desc = "Wow, hatlord looked fancy, suitlord looked streamlined, and this is just normal. The guy who designed these must be an idiot."
	icon_state = "shoes"
	product_ads = "Put your foot down!;One size fits all!;IM WALKING ON SUNSHINE!;No hobbits allowed.;NO PLEASE WILLY, DONT HURT ME- *BZZT*"
	products = list(/obj/item/clothing/shoes/sandal = 10,
						/obj/item/clothing/shoes/black = 10,
						/obj/item/clothing/shoes/brown = 10,
						/obj/item/clothing/shoes/blue = 10,
						/obj/item/clothing/shoes/green = 10,
						/obj/item/clothing/shoes/yellow = 10,
						/obj/item/clothing/shoes/purple = 10,
						/obj/item/clothing/shoes/orange = 10,
						/obj/item/clothing/shoes/red = 10,
						/obj/item/clothing/shoes/white = 10,
						/obj/item/clothing/shoes/hitops = 10,
						/obj/item/clothing/shoes/hitops/black = 10,
						/obj/item/clothing/shoes/hitops/brown = 10,
						/obj/item/clothing/shoes/hitops/blue = 10,
						/obj/item/clothing/shoes/hitops/green = 10,
						/obj/item/clothing/shoes/hitops/yellow = 10,
						/obj/item/clothing/shoes/hitops/purple = 10,
						/obj/item/clothing/shoes/hitops/orange = 10,
						/obj/item/clothing/shoes/hitops/red = 10,
						/obj/item/clothing/shoes/swimmingfins = 10,
						/obj/item/clothing/shoes/leather = 10,
						/obj/item/clothing/shoes/dress = 10,
						/obj/item/clothing/shoes/dress/white = 10,
						/obj/item/clothing/shoes/boots/winter = 10,
						/obj/item/clothing/shoes/boots/winter = 10,
						/obj/item/clothing/shoes/skater =10,
						/obj/item/clothing/shoes/laceup = 10,
						/obj/item/clothing/shoes/slippers = 10,
						/obj/item/clothing/shoes/heels = 10)

	prices = list(/obj/item/clothing/shoes/sandal = 30,
						/obj/item/clothing/shoes/black = 35,
						/obj/item/clothing/shoes/brown = 35,
						/obj/item/clothing/shoes/blue = 35,
						/obj/item/clothing/shoes/green = 35,
						/obj/item/clothing/shoes/yellow = 35,
						/obj/item/clothing/shoes/purple = 35,
						/obj/item/clothing/shoes/orange = 35,
						/obj/item/clothing/shoes/red = 35,
						/obj/item/clothing/shoes/white = 35,
						/obj/item/clothing/shoes/hitops = 35,
						/obj/item/clothing/shoes/hitops/black = 35,
						/obj/item/clothing/shoes/hitops/brown = 35,
						/obj/item/clothing/shoes/hitops/blue = 35,
						/obj/item/clothing/shoes/hitops/green = 35,
						/obj/item/clothing/shoes/hitops/yellow = 35,
						/obj/item/clothing/shoes/hitops/purple = 35,
						/obj/item/clothing/shoes/hitops/orange = 35,
						/obj/item/clothing/shoes/hitops/red = 35,
						/obj/item/clothing/shoes/swimmingfins = 35,
						/obj/item/clothing/shoes/leather = 35,
						/obj/item/clothing/shoes/dress = 35,
						/obj/item/clothing/shoes/dress/white = 35,
						/obj/item/clothing/shoes/boots/winter = 35,
						/obj/item/clothing/shoes/skater =40,
						/obj/item/clothing/shoes/laceup = 50,
						/obj/item/clothing/shoes/slippers = 15,
						/obj/item/clothing/shoes/heels = 30)

	premium = list(/obj/item/clothing/shoes/rainbow = 1)
	vendor_department = "Civilian"

/obj/machinery/vending/hatdispenser
	name = "\improper Hatlord 9000"
	desc = "It doesn't seem the slightest bit unusual. This frustrates you immensely."
	icon_state = "hats"
	product_ads = "Warning, not all hats are dog/monkey compatible. Apply forcefully with care.;Apply directly to the forehead.;Who doesn't love spending cash on hats?!;From the people that brought you collectable hat crates, Hatlord!"
	products = list(/obj/item/clothing/head/bowlerhat = 10,
						/obj/item/clothing/head/beaverhat = 10,
						/obj/item/clothing/head/boaterhat = 10,
						/obj/item/clothing/head/fedora = 10,
						/obj/item/clothing/head/fez = 10,
						/obj/item/clothing/head/feathertrilby = 10,
						/obj/item/clothing/head/flatcap = 20,
						/obj/item/clothing/head/hasturhood = 3,
						/obj/item/clothing/head/soft/blue = 10,
						/obj/item/clothing/head/soft/black = 10,
						/obj/item/clothing/head/soft/rainbow = 10,
						/obj/item/clothing/head/soft/mime = 10,
						/obj/item/clothing/head/bandana = 10,
						/obj/item/clothing/head/orangebandana = 10,
						/obj/item/clothing/head/greenbandana = 10,
						/obj/item/clothing/head/pin/butterfly = 10,
						/obj/item/clothing/head/pin/flower = 10,
						/obj/item/clothing/head/pin/flower/blue = 10,
						/obj/item/clothing/head/pin/flower/orange = 10,
						/obj/item/clothing/head/pin/flower/pink = 10,
						/obj/item/clothing/head/pin/flower/violet = 10,
						/obj/item/clothing/head/pin/flower/white = 10,
						/obj/item/clothing/head/pin/flower/yellow = 10,
						/obj/item/clothing/head/pin/pink = 10,
						/obj/item/clothing/head/beanie = 10,
						/obj/item/clothing/head/soft/green = 10,
						/obj/item/clothing/head/soft/grey = 10,
						/obj/item/clothing/head/soft/mime = 10,
						/obj/item/clothing/head/soft/purple = 10,
						/obj/item/clothing/head/soft/orange = 10,
						/obj/item/clothing/head/soft/purple = 10,
						/obj/item/clothing/head/soft/red = 10,
						/obj/item/clothing/head/soft/yellow = 10,
						/obj/item/clothing/head/lavender_crown = 10,
						/obj/item/clothing/head/poppy_crown = 10,
						/obj/item/clothing/head/sunflower_crown = 10,
						/obj/item/clothing/head/that = 30)

	prices = list(/obj/item/clothing/head/bowlerhat = 10,
						/obj/item/clothing/head/beaverhat = 10,
						/obj/item/clothing/head/boaterhat = 10,
						/obj/item/clothing/head/fedora = 10,
						/obj/item/clothing/head/fez = 10,
						/obj/item/clothing/head/feathertrilby = 10,
						/obj/item/clothing/head/flatcap = 20,
						/obj/item/clothing/head/hasturhood = 3,
						/obj/item/clothing/head/soft/blue = 10,
						/obj/item/clothing/head/soft/black = 10,
						/obj/item/clothing/head/soft/rainbow = 10,
						/obj/item/clothing/head/soft/mime = 10,
						/obj/item/clothing/head/bandana = 10,
						/obj/item/clothing/head/orangebandana = 10,
						/obj/item/clothing/head/greenbandana = 10,
						/obj/item/clothing/head/pin/butterfly = 1,
						/obj/item/clothing/head/pin/flower = 1,
						/obj/item/clothing/head/pin/flower/blue = 1,
						/obj/item/clothing/head/pin/flower/orange = 1,
						/obj/item/clothing/head/pin/flower/pink = 1,
						/obj/item/clothing/head/pin/flower/violet = 1,
						/obj/item/clothing/head/pin/flower/white = 1,
						/obj/item/clothing/head/pin/flower/yellow = 1,
						/obj/item/clothing/head/pin/pink = 1,
						/obj/item/clothing/head/beanie = 10,
						/obj/item/clothing/head/soft/green = 10,
						/obj/item/clothing/head/soft/grey = 10,
						/obj/item/clothing/head/soft/mime = 10,
						/obj/item/clothing/head/soft/purple = 10,
						/obj/item/clothing/head/soft/orange = 10,
						/obj/item/clothing/head/soft/purple = 10,
						/obj/item/clothing/head/soft/red = 10,
						/obj/item/clothing/head/soft/yellow = 10,
						/obj/item/clothing/head/lavender_crown = 10,
						/obj/item/clothing/head/poppy_crown = 10,
						/obj/item/clothing/head/sunflower_crown = 10,
						/obj/item/clothing/head/that = 30)

	contraband = list(/obj/item/clothing/head/bearpelt = 5)
	premium = list(/obj/item/clothing/head/soft/rainbow = 1)

	vendor_department = "Civilian"

/obj/machinery/vending/crittercare//Paradise port.
	name = "\improper CritterCare"
	desc = "A vending machine for pet supplies."
	product_slogans = "Stop by for all your animal's needs!;Cuddly pets deserve a stylish collar!;Pets in space, what could be more adorable?;Freshest fish eggs in the system!;Rocks are the perfect pet, buy one today!"
	product_ads = "House-training costs extra!;Now with 1000% more cat hair!;Allergies are a sign of weakness!;Dogs are man's best friend. Remember that Vulpkanin!; Heat lamps for Unathi!; Vox-y want a cracker?"
	vend_delay = 15
	icon_state = "crittercare"
	products = list(/obj/item/fishfood = 10, /obj/machinery/fishtank/bowl = 3, /obj/item/weapon/storage/firstaid/aquatic_kit/full =5, /obj/item/fish_eggs/goldfish = 5,
					/obj/item/fish_eggs/clownfish = 5, /obj/item/fish_eggs/shark = 5, /obj/item/fish_eggs/feederfish = 10,
					/obj/item/fish_eggs/salmon = 5, /obj/item/fish_eggs/catfish = 5, /obj/item/fish_eggs/glofish = 5,
					/obj/item/fish_eggs/electric_eel = 5, /obj/item/fish_eggs/shrimp = 10, /obj/item/toy/pet_rock = 5,
					)
	prices = list(/obj/item/fishfood = 3, /obj/machinery/fishtank/bowl = 100, /obj/item/weapon/storage/firstaid/aquatic_kit/full = 60, /obj/item/fish_eggs/goldfish = 10,
					/obj/item/fish_eggs/clownfish = 10, /obj/item/fish_eggs/shark = 10, /obj/item/fish_eggs/feederfish = 5,
					/obj/item/fish_eggs/salmon = 10, /obj/item/fish_eggs/catfish = 10, /obj/item/fish_eggs/glofish = 10,
					/obj/item/fish_eggs/electric_eel = 10, /obj/item/fish_eggs/shrimp = 5, /obj/item/toy/pet_rock = 100,
					)
	contraband = list(/obj/item/fish_eggs/babycarp = 5)
	premium = list(/obj/item/toy/pet_rock/fred = 1, /obj/item/toy/pet_rock/roxie = 1)

	vendor_department = "Civilian"


/obj/machinery/vending/crittercare/free
	prices = list()



/obj/machinery/vending/dna
	name = "\improper DNA mods"
	desc = "A vending machine for dispensing DNA modifiers."
	product_slogans = "Become the best version of yourself!; Why stick with ordinary?"
	product_ads = "Wear glasses? Fix that with our eyesight correctors!; Fat? Not for long!"
	vend_delay = 15
	icon_state = "gene"
	products = list(/obj/item/weapon/dnainjector/regenerate = 3,
					/obj/item/weapon/dnainjector/antiblind = 3,
					/obj/item/weapon/dnainjector/antihulk = 3,
					/obj/item/weapon/dnainjector/xraymut = 3,
					/obj/item/weapon/dnainjector/antixray= 3,
					/obj/item/weapon/dnainjector/antifire = 3,
					/obj/item/weapon/dnainjector/antitele = 3,
					/obj/item/weapon/dnainjector/nobreath = 3,
					/obj/item/weapon/dnainjector/antinobreath = 3,
					/obj/item/weapon/dnainjector/antirunfast = 3,
					/obj/item/weapon/dnainjector/runfast = 3,
					/obj/item/weapon/dnainjector/antimorph = 3,
					/obj/item/weapon/dnainjector/antinoprints = 3,
					/obj/item/weapon/dnainjector/insulation = 3,
					/obj/item/weapon/dnainjector/antiinsulation = 3,
					/obj/item/weapon/dnainjector/antiglasses = 3,
					/obj/item/weapon/dnainjector/antiepi = 3,
					/obj/item/weapon/dnainjector/anticough = 3,
					/obj/item/weapon/dnainjector/anticlumsy = 3,
					/obj/item/weapon/dnainjector/antitour = 3,
					/obj/item/weapon/dnainjector/antistutt = 3,
					/obj/item/weapon/dnainjector/antideaf = 3,
					/obj/item/weapon/dnainjector/antihallucination = 3,
					/obj/item/weapon/dnainjector/dnacorrector = 10

					)
	prices = list(/obj/item/weapon/dnainjector/regenerate = 1500,
					/obj/item/weapon/dnainjector/antiblind = 700,
					/obj/item/weapon/dnainjector/antihulk = 500,
					/obj/item/weapon/dnainjector/xraymut = 750,
					/obj/item/weapon/dnainjector/antixray= 450,
					/obj/item/weapon/dnainjector/antifire = 300,
					/obj/item/weapon/dnainjector/antitele = 300,
					/obj/item/weapon/dnainjector/nobreath = 400,
					/obj/item/weapon/dnainjector/antinobreath = 400,
					/obj/item/weapon/dnainjector/antirunfast = 300,
					/obj/item/weapon/dnainjector/runfast = 900,
					/obj/item/weapon/dnainjector/antimorph = 300,
					/obj/item/weapon/dnainjector/antinoprints = 400,
					/obj/item/weapon/dnainjector/insulation = 1000,
					/obj/item/weapon/dnainjector/antiinsulation = 500,
					/obj/item/weapon/dnainjector/antiglasses = 900,
					/obj/item/weapon/dnainjector/antiepi = 400,
					/obj/item/weapon/dnainjector/anticough = 400,
					/obj/item/weapon/dnainjector/anticlumsy = 300,
					/obj/item/weapon/dnainjector/antitour = 400,
					/obj/item/weapon/dnainjector/antistutt = 300,
					/obj/item/weapon/dnainjector/antideaf = 400,
					/obj/item/weapon/dnainjector/antihallucination = 500,
					/obj/item/weapon/dnainjector/dnacorrector = 3000
					)


	vendor_department = "Public Healthcare"

//ration vending machines
/obj/machinery/vending/foodstamp/rations
	name = "Ration Dispenser"
	desc = "A vending machine holding self-contained complete meals."
	product_slogans = "Have you tried Menu #2? It's pizza time!; It's always Taco Tuesday with Menu #5!; Want something to spice up your life? Try Menu #8: Hot Chili!"
	product_ads = ""
	vend_delay = 15
	icon_state = "rations"
	products = list(/obj/item/weapon/storage/mre/menu2 = 5,
					/obj/item/weapon/storage/mre/menu3 = 5,
					/obj/item/weapon/storage/mre/menu4 = 5,
					/obj/item/weapon/storage/mre/menu5 = 5,
					/obj/item/weapon/storage/mre/menu6 = 5,
					/obj/item/weapon/storage/mre/menu7 = 5,
					/obj/item/weapon/storage/mre/menu8 = 5,
					/obj/item/weapon/storage/mre/menu9 = 5,
					/obj/item/weapon/storage/mre/menu10 = 5
					)
	contraband = list(/obj/item/weapon/storage/mre/menu12 = 5)
	prices = list(/obj/item/weapon/storage/mre/menu2 = 50,
					/obj/item/weapon/storage/mre/menu3 = 50,
					/obj/item/weapon/storage/mre/menu4 = 50,
					/obj/item/weapon/storage/mre/menu5 = 50,
					/obj/item/weapon/storage/mre/menu6 = 50,
					/obj/item/weapon/storage/mre/menu7 = 50,
					/obj/item/weapon/storage/mre/menu8 = 50,
					/obj/item/weapon/storage/mre/menu9 = 50,
					/obj/item/weapon/storage/mre/menu10 = 50
					)

/obj/machinery/vending/foodstamp/rations/psp
	name = "Ration Dispenser"
	desc = "A vending machine holding self-contained complete meals. This particular machine has the Planetary Security Party's emblem on it."
	product_slogans = "Have you tried Menu #2? It's pizza time!; It's always Taco Tuesday with Menu #5!; Liberals leave you thirsting for freedom? Wash that despair down with an Instant Grape packet!; Want something to spice up your life? Try Menu #8: Hot Chili!"
	product_ads = "Order. Unity. Conduct.; Remember the Pillars of civilized society and we shall be successful.; The True Citizen knows the true value of Charity.; Remember, it is great to be part of the Greater Good."
	vend_delay = 15
	vend_reply = "Enjoy your delicious ration pack! Remember: it is great to be part of the Greater Good!"
	icon_state = "rations-psp"
	shut_up = 0
	products = list(/obj/item/weapon/storage/mre/menu2 = 5,
					/obj/item/weapon/storage/mre/menu3 = 5,
					/obj/item/weapon/storage/mre/menu4 = 5,
					/obj/item/weapon/storage/mre/menu5 = 5,
					/obj/item/weapon/storage/mre/menu6 = 5,
					/obj/item/weapon/storage/mre/menu7 = 5,
					/obj/item/weapon/storage/mre/menu8 = 5,
					/obj/item/weapon/storage/mre/menu9 = 5,
					/obj/item/weapon/storage/mre/menu10 = 5
					)
	contraband = list(/obj/item/weapon/storage/mre/menu12 = 5)
	prices = list(/obj/item/weapon/storage/mre/menu2 = 50,
					/obj/item/weapon/storage/mre/menu3 = 50,
					/obj/item/weapon/storage/mre/menu4 = 50,
					/obj/item/weapon/storage/mre/menu5 = 50,
					/obj/item/weapon/storage/mre/menu6 = 50,
					/obj/item/weapon/storage/mre/menu7 = 50,
					/obj/item/weapon/storage/mre/menu8 = 50,
					/obj/item/weapon/storage/mre/menu9 = 50,
					/obj/item/weapon/storage/mre/menu10 = 50
					)

