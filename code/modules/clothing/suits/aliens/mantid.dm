/obj/item/clothing/head/helmet/space/void/mantid
	name = "mantid voidsuit helmet"
	desc = "An articulated spacesuit helmet of mantid manufacture."
	icon_state = "mantid_helmet"
	armor = list(melee = 50, bullet = 25, laser = 25, energy = 15, bomb = 45, bio = 100, rad = 10)
	siemens_coefficient = 0.7
	species_restricted = list(SPECIES_MANTID)

/obj/item/clothing/suit/space/void/mantid
	name = "mantid voidsuit"
	desc = "A form-fitting spacesuit of mantid manufacture."
	icon_state = "mantid_suit"
	armor = list(melee = 50, bullet = 25, laser = 25, energy = 15, bomb = 45, bio = 100, rad = 10)
	siemens_coefficient = 0.7
	breach_threshold = 14 //These are kinda thicc
	resilience = 0.15
	species_restricted = list(SPECIES_MANTID)
	allowed = list(
/*
		/obj/item/gun/energy/particle/small,
*/
		/obj/item/clustertool,
		/obj/item/reagent_containers/drinks/cans/waterbottle/mantid,
		/obj/item/tank/mantid,
		/obj/item/weldingtool/electric/mantid,
		/obj/item/multitool/mantid
	)

// Not sure where to put this.
/obj/item/clustertool
	name = "mantid clustertool"
	desc = "A bewilderingly complex knot of tool heads."
	icon = 'icons/obj/mantid.dmi'
	icon_state = "clustertool"
	w_class = ITEMSIZE_SMALL
	var/current_index
	var/static/list/possible_tools = list(
		TOOL_WRENCH,
		TOOL_WIRECUTTER,
		TOOL_CROWBAR,
		TOOL_SCREWDRIVER
	)

/obj/item/clustertool/examine(mob/user)
	. = ..()
	if(length(tool_qualities))
		to_chat(user, "It is currently configured to function as a [tool_qualities[1]].")

/obj/item/clustertool/Initialize()
	. = ..()
	current_index = rand(1,length(possible_tools))
	update_tool()

/obj/item/clustertool/proc/update_tool()
	current_index = clamp(current_index, 1, length(possible_tools))
	tool_qualities = list(possible_tools[current_index])
	update_icon()

/obj/item/clustertool/attack_self(mob/user)
	current_index++
	if(current_index > length(tool_qualities))
		current_index = 1
	update_tool()
	if(length(tool_qualities))
		to_chat(user, SPAN_NOTICE("You configure \the [src] to function as a [tool_qualities[1]]."))

/obj/item/clustertool/update_icon()
	icon_state = initial(icon_state)
	if(is_wrench())
		icon_state = "[icon_state]-wrench"
	else if(is_wirecutter())
		icon_state = "[icon_state]-wirecutters"
	else if(is_crowbar())
		icon_state = "[icon_state]-crowbar"
	else if(is_screwdriver())
		icon_state = "[icon_state]-screwdriver"
