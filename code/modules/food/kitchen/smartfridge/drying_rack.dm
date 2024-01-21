/obj/machinery/smartfridge/drying_oven
	name = "drying oven"
	desc = "A machine for drying plants."
	wrenchable = 1
	icon_state = "drying_rack"
	icon_base = "drying_rack"

/obj/machinery/smartfridge/drying_oven/accept_check(var/obj/item/O)
	return istype(O) && O.is_dryable()

/obj/machinery/smartfridge/drying_oven/process()
	..()
	if(stat & (BROKEN|NOPOWER))
		return
	var/do_update = FALSE
	for(var/obj/item/thing in contents)
		var/obj/item/product = thing.dry_out(src, silent = TRUE)
		if(product)
			product.dropInto(loc)
			do_update = TRUE
			if(QDELETED(thing) || !(thing in contents))
				for(var/datum/stored_item/I in item_records)
					I.instances -= thing
	if(do_update)
		update_icon()

/obj/machinery/smartfridge/drying_oven/update_icon()
	var/not_working = stat & (BROKEN|NOPOWER)
	var/hasItems
	for(var/datum/stored_item/I in item_records)
		if(I.get_amount())
			hasItems = TRUE
			break
	if(hasItems)
		if(not_working)
			icon_state = "[icon_base]-plant-off"
		else
			icon_state = "[icon_base]-plant"
	else
		if(not_working)
			icon_state = "[icon_base]-off"
		else
			icon_state = "[icon_base]"
