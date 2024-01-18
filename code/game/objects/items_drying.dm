// Stubs/vars for use with the drying rack.
/obj/item
	var/drying_threshold_temperature = 500 // Kelvin, checked in fire_act()
	var/dried_type // If set to a type, drying this item will convert it to that type.

/obj/item/proc/is_dryable()
	return !isnull(dried_type)

// Returns null for no change, or an instance for a successful drying.
/obj/item/proc/dry_out(var/obj/rack, var/drying_power = 1)
	if(dried_type)
		. = new dried_type(loc)
		qdel(src)

// Returns a string used in drying rack examine().
/obj/item/proc/get_dryness_text(var/obj/rack)
	return "dry"

// Returns an icon_state used by drying rack update_icon().
/obj/item/proc/get_drying_state(var/obj/rack)
	return

/obj/item/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	..()
	if(exposed_temperature >= drying_threshold_temperature)
		dry_out()
