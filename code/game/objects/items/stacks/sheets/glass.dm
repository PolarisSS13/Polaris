/* Glass stack types
 * Contains:
 *		Glass sheets
 *		Reinforced glass sheets
 *		Phoron Glass Sheets
 *		Reinforced Phoron Glass Sheets (AKA Holy fuck strong windows)
 *		Glass shards - TODO: Move this into code/game/object/item/weapons
 */

/*
 * Glass sheets
 */
/obj/item/stack/material/glass
	name = "glass"
	singular_name = "glass sheet"
	icon_state = "sheet-glass"
	var/is_reinforced = 0
	default_type = "glass"

/obj/item/stack/material/glass/attack_self(mob/user as mob)
	construct_window(user)

/obj/item/stack/material/glass/attackby(obj/item/W, mob/user)
	..()
	if(!is_reinforced)
		if(istype(W,/obj/item/stack/cable_coil))
			var/obj/item/stack/cable_coil/CC = W
			if (get_amount() < 1 || CC.get_amount() < 5)
				user << "<span class='warning'>You need five lengths of coil and one sheet of glass to make wired glass.</span>"
				return

			CC.use(5)
			use(1)
			user << "<span class='notice'>You attach wire to the [name].</span>"
//			new /obj/item/stack/light_w(user.loc)
		else if(istype(W, /obj/item/stack/rods))
			var/obj/item/stack/rods/V  = W
			if (V.get_amount() < 1 || get_amount() < 1)
				user << "<span class='warning'>You need one rod and one sheet of glass to make reinforced glass.</span>"
				return

			var/obj/item/stack/material/glass/reinforced/RG = new (user.loc)
			RG.add_fingerprint(user)
			RG.add_to_stacks(user)
			var/obj/item/stack/material/glass/G = src
			src = null
			var/replace = (user.get_inactive_hand()==G)
			V.use(1)
			G.use(1)
			if (!G && replace)
				user.put_in_hands(RG)


/obj/item/stack/material/glass/proc/construct_window(mob/user as mob)
	if(!user || !src)	return 0
	if(!istype(user.loc,/turf)) return 0
	if(!user.IsAdvancedToolUser())
		user << "\red You don't have the dexterity to do this!"
		return 0
	var/title = "Sheet-Glass"
	title += " ([src.amount] sheet\s left)"
	switch(alert(title, "Would you like full tile glass or one direction?", "one direct", "full (2 sheets)", "cancel", null))
		if("one direct")
			if(!src)	return 1
			if(src.loc != user)	return 1
			var/list/directions = new/list(cardinal)
			for (var/obj/structure/window/win in user.loc)
				directions-=win.dir
				if(!(win.ini_dir in cardinal))
					user << "\red Can't let you do that."
					return 1
			var/dir_to_set = 2
			//yes, this could probably be done better but hey... it works...
			for(var/obj/structure/window/WT in user.loc)
				if (WT.dir == dir_to_set)
					dir_to_set = 4
			for(var/obj/structure/window/WT in user.loc)
				if (WT.dir == dir_to_set)
					dir_to_set = 1
			for(var/obj/structure/window/WT in user.loc)
				if (WT.dir == dir_to_set)
					dir_to_set = 8
			for(var/obj/structure/window/WT in user.loc)
				if (WT.dir == dir_to_set)
					dir_to_set = 2
			var/obj/structure/window/W
			W = new /obj/structure/window/basic( user.loc, 0 )
			W.dir = dir_to_set
			W.ini_dir = W.dir
			W.anchored = 0
			src.use(1)
		if("full (2 sheets)")
			if(!src)	return 1
			if(src.loc != user)	return 1
			if(locate(/obj/structure/window) in user.loc)
				user << "\red There is a window in the way."
				return 1
			var/obj/structure/window/W
			W = new /obj/structure/window/basic( user.loc, 0 )
			W.dir = SOUTHWEST
			W.ini_dir = SOUTHWEST
			W.anchored = 0
			src.use(2)
	return 0

/*
 * Reinforced glass sheets
 */
/obj/item/stack/material/glass/reinforced
	name = "reinforced glass"
	singular_name = "reinforced glass sheet"
	icon_state = "sheet-rglass"
	default_type = "reinforced glass"
	is_reinforced = 1

/*
 * Phoron Glass sheets
 */
/obj/item/stack/material/glass/phoronglass
	name = "phoron glass"
	singular_name = "phoron glass sheet"
	icon_state = "sheet-phoronglass"
	default_type = "phoron glass"
	associated_reagent = "phoron"

/obj/item/stack/material/glass/phoronglass/attackby(obj/item/W, mob/user)
	..()
	if( istype(W, /obj/item/stack/rods) )
		var/obj/item/stack/rods/V  = W
		var/obj/item/stack/material/glass/phoronrglass/RG = new (user.loc)
		RG.add_fingerprint(user)
		RG.add_to_stacks(user)
		V.use(1)
		var/obj/item/stack/material/glass/G = src
		src = null
		var/replace = (user.get_inactive_hand()==G)
		G.use(1)
		if (!G && !RG && replace)
			user.put_in_hands(RG)
	else
		return ..()

/*
 * Reinforced phoron glass sheets
 */
/obj/item/stack/material/glass/phoronrglass
	name = "reinforced phoron glass"
	singular_name = "reinforced phoron glass sheet"
	icon_state = "sheet-phoronrglass"
	default_type = "reinforced phoron glass"
	is_reinforced = 1