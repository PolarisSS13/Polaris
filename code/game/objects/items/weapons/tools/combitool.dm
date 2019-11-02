//Combitools

/obj/item/weapon/combitool
	name = "debug combitool"
	desc = "Base form of thje hardlight combitool. This item should not appear."
	icon = 'icons/obj/tools.dmi'
	icon_state = "combitool"
	w_class = ITEMSIZE_SMALL

	var/list/allowed_modes = list(
		"off",
		"screwdiver",
		"wrench",
		"crowbar",
		"wirecutter",
		"welder",
		"multitool"
		)
	var/mode


/obj/item/weapon/holotool/examine()
	..()
	to_chat(usr, "<span class = notice>Alt-click to change tool colour.</span>")

/obj/item/weapon/combitool/is_screwdriver()
	if(mode == "screwdriver")
		return TRUE
	else
		return FALSE

/obj/item/weapon/combitool/is_welder()
	return FALSE