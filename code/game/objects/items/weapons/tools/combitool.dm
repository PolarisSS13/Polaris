//Combitools
#define POWER_USE_SCREWDRIVER 20 //24 uses
#define POWER_USE_CROWBAR 40 //12 uses
#define POWER_USE_WIRECUTTER 20 //24 uses
#define POWER_USE_WRENCH 20 //24 uses
#define POWER_USE_WELDER 48 //10 uses
#define POWER_USE_MULTITOOL 32 //15 uses


/obj/item/weapon/holotool
	name = "debug combitool"
	desc = "Base form of thje hardlight combitool. This item should not appear."
	icon = 'icons/obj/tools.dmi'
	icon_state = "combitool"
	w_class = ITEMSIZE_SMALL
	var/use_cell = 0 //debug version shouldn't use power
	var/obj/item/weapon/cell/power_supply //cell for supply
	var/cell_type = /obj/item/weapon/cell/device
	var/poweruse // use is amount of power used when it goes through an isTool proc or an attack
	var/list/allowed_modes = list(
		"off",
		"screwdriver",
		"crowbar",
		"wirecutter",
		"wrench",
		"welder",
		"multitool"
	)
	var/lcolor //light colour
	var/static/radial_off = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_off")
	var/static/radial_screwdriver = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_screwdriver")
	var/static/radial_crowbar = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_crowbar")
	var/static/radial_wirecutter = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_wirecutter")
	var/static/radial_wrench = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_wrench")
	var/static/radial_welder = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_welder")
	var/static/radial_multitool = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_multitool")



/obj/item/weapon/holotool/proc/enervate
	poweruse = 0
	update_icon()

/obj/item/weapon/holotool/proc/empower(var/chosen, mob/user)
	poweruse = POWER_USE_[chosen]
	update_icon()

/obj/item/weapon/holotool/examine(mob/user)
	..()
	to_chat(user, "<span class = notice>Alt-click to change tool colour.</span>")
	if(use_cell)
		if(power_supply)
			to_chat(user, "<span class='notice'>The blade is [round(power_supply.percent())]% charged.</span>")
		if(!power_supply)
			to_chat(user, "<span class='warning'>The blade does not have a power source installed.</span>")

/obj/item/weapon/holotool/AltClick(mob/living/user)
	if(!in_range(src, user))	//Basic checks to prevent abuse
		return
	if(user.incapacitated() || !istype(user))
		to_chat(user, "<span class='warning'>You can't do that right now!</span>")
		return

	if(alert("Are you sure you want to recolor your tool?", "Confirm Recolor", "Yes", "No") == "Yes")
		var/energy_color_input = input(usr,"","Choose Energy Color",lcolor) as color|null
		if(energy_color_input)
			lcolor = sanitize_hexcolor(energy_color_input)
		update_icon()

/obj/item/weapon/holotool/update_icon()
	. = ..()
	var/mutable_appearance/blade_overlay = mutable_appearance(icon, "[icon_state]_[tool_behavior]")
	blade_overlay.color = lcolor
	cut_overlays()		//So that it doesn't keep stacking overlays non-stop on top of each other
	if(tool_behavior)
		add_overlay(blade_overlay)
	if(istype(usr,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = usr
		H.update_inv_l_hand()
		H.update_inv_r_hand()


/obj/item/weapon/holotool/attack_self(mob/user)
	var/list/options = list()
	if("off" in allowed_modes)
		options["off"] = radial_off
	if("screwdriver" in allowed_modes)
		options["screwdriver"] = radial_screwdriver
	if("crowbar" in allowed_modes)
		options["crowbar"] = radial_crowbar
	if("wirecutter" in allowed_modes)
		options["wirecutter"] = radial_wirecutter
	if("wrench" in allowed_modes)
		options["wrench"] = radial_wrench
	if("welder" in allowed_modes)
		options["welder"] = radial_welder
	if("multitool" in allowed_modes)
		options["multitool"] = radial_multitool

	if(length(options) < 1)
		return
	var/list/choice = list()
	if(length(options) == 1)
		for(var/key in options)
			choice = key
	else
		choice = show_radial_menu(user, src, options, require_near = !issilicon(user))
	switch(choice)
		if("off")
			enervate(user)
		else
			empower(choice, user)
		add_fingerprint(user)


