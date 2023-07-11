// Root hardsuit kit defines.
// Icons for modified hardsuits need to be in the proper .dmis because suit cyclers may cock them up.
/obj/item/kit/suit
	name = "voidsuit modification kit"
	desc = "A kit for modifying a voidsuit."
	uses = 2
	accepted_refit_types = list(/obj/item/clothing/suit/space/void)
	var/new_light_overlay

/obj/item/kit/suit/set_info(var/kit_name, var/kit_desc, var/kit_icon, var/kit_icon_file = CUSTOM_ITEM_OBJ, var/kit_icon_override_file = CUSTOM_ITEM_MOB, var/additional_data)
	..()
	new_light_overlay = additional_data
