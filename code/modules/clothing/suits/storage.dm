/obj/item/clothing/suit/storage
	var/obj/item/weapon/storage/internal/pockets

/obj/item/clothing/suit/storage/New()
	..()
	pockets = new/obj/item/weapon/storage/internal(src)
	pockets.max_w_class = ITEMSIZE_SMALL		//fit only pocket sized items
	pockets.max_storage_space = ITEMSIZE_COST_SMALL * 2

/obj/item/clothing/suit/storage/Destroy()
	QDEL_NULL(pockets)
	return ..()

/obj/item/clothing/suit/storage/attack_hand(mob/user as mob)
	if (pockets.handle_attack_hand(user))
		..(user)

/obj/item/clothing/suit/storage/MouseDrop(obj/over_object as obj)
	if (pockets.handle_mousedrop(usr, over_object))
		..(over_object)

/obj/item/clothing/suit/storage/attackby(obj/item/W as obj, mob/user as mob)
	..()
	pockets.attackby(W, user)

/obj/item/clothing/suit/storage/emp_act(severity)
	pockets.emp_act(severity)
	..()

//Jackets with buttons, used for labcoats, IA jackets, First Responder jackets, and brown jackets.
/obj/item/clothing/suit/storage/toggle
	flags_inv = HIDEHOLSTER
	var/open = 0	//0 is closed, 1 is open, -1 means it won't be able to toggle
	verb/toggle()
		set name = "Toggle Coat Buttons"
		set category = "Object"
		set src in usr
		if(!usr.canmove || usr.stat || usr.restrained())
			return 0

		if(open == 1) //Will check whether icon state is currently set to the "open" or "closed" state and switch it around with a message to the user
			open = 0
			icon_state = initial(icon_state)
			flags_inv = HIDETIE|HIDEHOLSTER
			usr << "You button up the coat."
		else if(open == 0)
			open = 1
			icon_state = "[icon_state]_open"
			flags_inv = HIDEHOLSTER
			usr << "You unbutton the coat."
		else //in case some goofy admin switches icon states around without switching the icon_open or icon_closed
			usr << "You attempt to button-up the velcro on your [src], before promptly realising how silly you are."
			return
		update_clothing_icon()	//so our overlays update


/obj/item/clothing/suit/storage/hooded/toggle
	flags_inv = HIDEHOLSTER
	var/open = 0	//0 is closed, 1 is open, -1 means it won't be able to toggle
	verb/toggle()
		set name = "Toggle Coat Buttons"
		set category = "Object"
		set src in usr
		if(!usr.canmove || usr.stat || usr.restrained())
			return 0

		if(open == 1) //Will check whether icon state is currently set to the "open" or "closed" state and switch it around with a message to the user
			open = 0
			if(hood_up) // Also will check if hood is on to prevent icon mess up.
				icon_state = "[initial(icon_state)]_t"
			else
				icon_state = initial(icon_state)
			flags_inv = HIDETIE|HIDEHOLSTER
			usr << "You button up the coat."
		else if(open == 0)
			open = 1
			if(hood_up) // Ditto.
				icon_state = "[initial(icon_state)]_open_t"
			else
				icon_state = "[initial(icon_state)]_open"
			flags_inv = HIDEHOLSTER
			usr << "You unbutton the coat."
		else //in case some goofy admin switches icon states around without switching the icon_open or icon_closed
			usr << "You attempt to button-up the velcro on your [src], before promptly realising how silly you are."
			return
		update_clothing_icon()	//so our overlays update

// It is basicly hood code but it checks storage toggle to prevent icon mess up.
/obj/item/clothing/suit/storage/hooded/toggle/RemoveHood()
	if(open == 1)
		icon_state = "[toggleicon]_open"
	else
		icon_state = toggleicon
	hood_up = FALSE
	hood.canremove = TRUE
	if(ishuman(hood.loc))
		var/mob/living/carbon/H = hood.loc
		H.unEquip(hood, 1)
		H.update_inv_wear_suit()
	hood.forceMove(src)

/obj/item/clothing/suit/storage/hooded/toggle/ToggleHood()
	if(!hood_up)
		if(ishuman(loc))
			var/mob/living/carbon/human/H = src.loc
			if(H.wear_suit != src)
				to_chat(H, "<span class='warning'>You must be wearing [src] to put up the hood!</span>")
				return
			if(H.head)
				to_chat(H, "<span class='warning'>You're already wearing something on your head!</span>")
				return
			else
				H.equip_to_slot_if_possible(hood,slot_head,0,0,1)
				hood_up = TRUE
				hood.canremove = FALSE
				if(open == 1)
					icon_state = "[toggleicon]_open_t"
				else
					icon_state = "[toggleicon]_t"
				H.update_inv_wear_suit()
	else
		RemoveHood()


//New Vest 4 pocket storage and badge toggles, until suit accessories are a thing.
/obj/item/clothing/suit/storage/vest/heavy/New()
	..()
	pockets = new/obj/item/weapon/storage/internal(src)
	pockets.max_w_class = ITEMSIZE_SMALL
	pockets.max_storage_space = ITEMSIZE_COST_SMALL * 4

/obj/item/clothing/suit/storage/vest
	var/icon_badge
	var/icon_nobadge
	verb/toggle()
		set name ="Adjust Badge"
		set category = "Object"
		set src in usr
		if(!usr.canmove || usr.stat || usr.restrained())
			return 0

		if(icon_state == icon_badge)
			icon_state = icon_nobadge
			usr << "You conceal \the [src]'s badge."
		else if(icon_state == icon_nobadge)
			icon_state = icon_badge
			usr << "You reveal \the [src]'s badge."
		else
			usr << "\The [src] does not have a badge."
			return
		update_clothing_icon()

