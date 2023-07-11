/obj/proc/customize_with_kit(var/mob/user, var/obj/item/kit/suit/kit)
	SHOULD_CALL_PARENT(TRUE)
	if(!istype(kit))
		return FALSE
	if(kit.new_name)
		name = kit.new_name
	if(kit.new_desc)
		desc = kit.new_desc
	return TRUE

/obj/mecha/customize_with_kit(var/mob/user, var/obj/item/kit/suit/kit)
	. = ..()
	if(.)
		if(kit.new_icon)
			initial_icon = kit.new_icon
		if(kit.new_icon_file)
			icon = kit.new_icon_file
		update_icon()

/obj/item/customize_with_kit(var/mob/user, var/obj/item/kit/suit/kit)
	. = ..()
	if(.)
		if(kit.new_icon)
			icon_state = kit.new_icon
		if(kit.new_icon_file)
			icon = kit.new_icon_file
		if(kit.new_icon_override_file)
			icon_override = kit.new_icon_override_file

/obj/item/clothing/customize_with_kit(var/mob/user, var/obj/item/kit/suit/kit)
	. = ..()
	if(.)
		var/species_name = istype(user) && user.get_species_name()
		if(species_name && species_name != SPECIES_HUMAN)
			species_restricted = list(species_name)
			if(kit.new_icon_override_file)
				LAZYSET(sprite_sheets, species_name, kit.new_icon_override_file)

/obj/item/clothing/under/customize_with_kit(var/mob/user, var/obj/item/kit/suit/kit)
	. = ..()
	if(.)
		worn_state = icon_state
		update_rolldown_status()

/obj/item/clothing/head/helmet/space/void/customize_with_kit(var/mob/user, var/obj/item/kit/suit/kit)
	. = ..()
	if(.)
		name       = "[kit.new_name] suit helmet"
		icon_state = "[kit.new_icon]_helmet"
		item_state = "[kit.new_icon]_helmet"
		if(kit.new_light_overlay)
			light_overlay = kit.new_light_overlay

/obj/item/clothing/suit/storage/hooded/customize_with_kit(var/mob/user, var/obj/item/kit/suit/kit)
	. = ..()
	if(.)
		name       = "[kit.new_name] suit"
		icon_state = "[kit.new_icon]_suit"
		toggleicon = "[kit.new_icon]_suit"
		if(hood)
			hood.customize_with_kit(user, kit)

/obj/item/clothing/head/hood/customize_with_kit(var/mob/user, var/obj/item/kit/suit/kit)
	. = ..()
	if(.)
		name =       "[kit.new_name] hood"
		icon_state = "[kit.new_icon]_helmet"
		item_state = "[kit.new_icon]_helmet"

/obj/item/clothing/accessory/storage/poncho/customize_with_kit(var/mob/user, var/obj/item/kit/suit/kit)
	. = ..()
	if(.)
		icon_override_state = kit.new_icon_override_file
		item_state = kit.new_icon

/obj/item/rig/customize_with_kit(var/mob/user, var/obj/item/kit/suit/kit)
	. = ..()
	if(.)
		if(kit.new_icon)
			suit_state = kit.new_icon
			item_state = kit.new_icon
		suit_type = "customized [initial(suit_type)]"

		if(istype(helmet, /obj/item/clothing/head/helmet) && kit.new_light_overlay)
			var/obj/item/clothing/head/helmet/helm_ref = helmet
			helm_ref.light_overlay = kit.new_light_overlay

		for(var/obj/item/piece in list(gloves, helmet, boots, chest))
			piece.name = "[suit_type] [initial(piece.name)]"
			piece.desc = "It seems to be part of \a [name]."
			piece.icon_state = "[suit_state]"
			piece.customize_with_kit(user, kit, src)
			if(istype(piece, /obj/item/clothing/shoes))
				piece.icon = 'icons/mob/custom_items_rig_boots.dmi'
				piece.icon_override = 'icons/mob/custom_items_rig_boots.dmi'
			if(istype(piece, /obj/item/clothing/suit))
				piece.icon = 'icons/mob/custom_items_rig_suit.dmi'
				piece.icon_override = 'icons/mob/custom_items_rig_suit.dmi'
			if(istype(piece, /obj/item/clothing/head))
				piece.icon = 'icons/mob/custom_items_rig_helmet.dmi'
				piece.icon_override = 'icons/mob/custom_items_rig_helmet.dmi'
			if(istype(piece, /obj/item/clothing/gloves))
				piece.icon = 'icons/mob/custom_items_rig_gloves.dmi'
				piece.icon_override = 'icons/mob/custom_items_rig_gloves.dmi'
