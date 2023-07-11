// Generic use
/obj/attackby(obj/item/W, mob/user)
	return attempt_customization(W, user) || ..()

/obj/proc/attempt_customization(var/obj/item/W, var/mob/user)
	if(!istype(W, /obj/item/kit))
		return FALSE
	var/obj/item/kit/K = W
	if(!K.can_customize(src))
		return FALSE
	var/old_name = name
	if(!K.try_customize(src, user))
		return FALSE
	K.use(1, user)
	K.show_customization_message(user, src, old_name)
	return TRUE

/obj/item/kit
	icon_state = "modkit"
	icon = 'icons/obj/device.dmi'
	pickup_sound = 'sound/items/pickup/device.ogg'
	drop_sound = 'sound/items/drop/device.ogg'
	w_class = ITEMSIZE_SMALL

	/// A string to use to modify the obj name.
	var/new_name = "custom item"
	/// A string to use to modify the obj desc.
	var/new_desc = "A custom item."
	/// A new string to set icon_state to.
	var/new_icon
	/// A new .dmi to set icon to.
	var/new_icon_file
	/// A new .dmi to set icon_override to.
	var/new_icon_override_file
	/// Number of uses before the kit is consumed.
	var/uses = 1 // Uses before the kit deletes itself.
	/// A list of base types that are accepted for use by this kit.
	var/list/accepted_refit_types

/obj/item/kit/examine()
	. = ..()
	. += "It has [uses] use\s left."

/obj/item/kit/proc/use(var/amt, var/mob/user)
	if(uses)
		uses -= amt
		playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
	if(uses <= 0)
		user.drop_item()
		qdel(src)

/obj/item/kit/proc/set_info(var/kit_name, var/kit_desc, var/kit_icon, var/kit_icon_file = CUSTOM_ITEM_OBJ, var/kit_icon_override_file = CUSTOM_ITEM_MOB, var/additional_data)
	new_name = kit_name
	new_desc = kit_desc
	new_icon = kit_icon
	new_icon_file = kit_icon_file
	new_icon_override_file = kit_icon_override_file
	for(var/path in splittext(additional_data, ", "))
		var/refit_type = text2path(path)
		if(ispath(refit_type, /obj))
			LAZYDISTINCTADD(accepted_refit_types, refit_type)
		else
			crash_with("Invalid path value supplied to custom item serde: [refit_type || "NULL"]")

/obj/item/kit/proc/can_customize(var/obj/I)
	return istype(I) && is_type_in_list(I, accepted_refit_types)

/obj/item/kit/proc/try_customize(var/obj/I, var/mob/user)
	if(!can_customize(I))
		return

/obj/item/kit/proc/show_customization_message(var/mob/user, var/obj/I, var/old_name)
	user.visible_message("\The [user] opens \the [src] and converts \the [old_name] into \a [I].")
