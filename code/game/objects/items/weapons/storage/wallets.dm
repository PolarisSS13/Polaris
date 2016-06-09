/obj/item/weapon/storage/wallet
	name = "wallet"
	desc = "It can hold a few small and personal things."
	storage_slots = 10
	icon = 'icons/obj/wallet.dmi'
	icon_state = "wallet"
	w_class = 2
	can_hold = list(
		/obj/item/weapon/spacecash,
		/obj/item/weapon/card,
		/obj/item/clothing/mask/smokable/cigarette/,
		/obj/item/device/flashlight/pen,
		/obj/item/seeds,
		/obj/item/stack/medical,
		/obj/item/weapon/coin,
		/obj/item/weapon/dice,
		/obj/item/weapon/disk,
		/obj/item/weapon/implanter,
		/obj/item/weapon/flame/lighter,
		/obj/item/weapon/flame/match,
		/obj/item/weapon/paper,
		/obj/item/weapon/pen,
		/obj/item/weapon/photo,
		/obj/item/weapon/reagent_containers/dropper,
		/obj/item/weapon/screwdriver,
		/obj/item/weapon/stamp)
	slot_flags = SLOT_ID

	var/obj/item/weapon/card/id/front_id = null


/obj/item/weapon/storage/wallet/remove_from_storage(obj/item/W as obj, atom/new_location)
	. = ..(W, new_location)
	if(.)
		if(W == front_id)
			front_id = null
			name = initial(name)
			update_icon()

/obj/item/weapon/storage/wallet/handle_item_insertion(obj/item/W as obj, prevent_warning = 0)
	. = ..(W, prevent_warning)
	if(.)
		if(!front_id && istype(W, /obj/item/weapon/card/id))
			front_id = W
			name = "[name] ([front_id])"
			update_icon()

/obj/item/weapon/storage/wallet/update_icon()
	if(front_id)
		switch(front_id.icon_state)
			if("id") //The plain assistant ID
				var/icon/new_wallet = new/icon("icon" = initial(icon), "icon_state" = initial(icon_state))
				var/icon/id_overlay = new/icon("icon" = initial(icon), "icon_state" = "wallet_id")
				new_wallet.Blend(id_overlay, ICON_OVERLAY)
				del id_overlay
				icon = new_wallet
				return
			if("silver") //HoP's ID has a special overlay.
				var/icon/new_wallet = new/icon("icon" = initial(icon), "icon_state" = initial(icon_state))
				var/icon/id_overlay = new/icon("icon" = initial(icon), "icon_state" = "wallet_idsilver")
				new_wallet.Blend(id_overlay, ICON_OVERLAY)
				del id_overlay
				icon = new_wallet
			if("gold") //Captain's ID has a special overlay.
				var/icon/new_wallet = new/icon("icon" = initial(icon), "icon_state" = initial(icon_state))
				var/icon/id_overlay = new/icon("icon" = initial(icon), "icon_state" = "wallet_idgold")
				new_wallet.Blend(id_overlay, ICON_OVERLAY)
				del id_overlay
				icon = new_wallet
			if("centcom") //Centcom ID has a special overlay.
				var/icon/new_wallet = new/icon("icon" = initial(icon), "icon_state" = initial(icon_state))
				var/icon/id_overlay = new/icon("icon" = initial(icon), "icon_state" = "wallet_idcentcom")
				new_wallet.Blend(id_overlay, ICON_OVERLAY)
				del id_overlay
				icon = new_wallet
			else //Doesn't match a special overlay type.
				if(front_id.primary_color && front_id.secondary_color) //Colored ID with stripe and oval colors (pri/sec).
					var/icon/new_wallet = new/icon("icon" = initial(icon), "icon_state" = initial(icon_state))
					var/icon/id_icon = new/icon("icon" = initial(icon), "icon_state" = "wallet_id")
					var/icon/pri_overlay = new/icon("icon" = initial(icon), "icon_state" = "wallet_idprimary")
					var/icon/sec_overlay = new/icon("icon" = initial(icon), "icon_state" = "wallet_idsecondary")

					pri_overlay.Blend(front_id.primary_color, ICON_ADD)
					sec_overlay.Blend(front_id.secondary_color, ICON_ADD)

					new_wallet.Blend(id_icon, ICON_OVERLAY)
					del id_icon
					new_wallet.Blend(pri_overlay, ICON_OVERLAY)
					del pri_overlay
					new_wallet.Blend(sec_overlay, ICON_OVERLAY)
					del sec_overlay

					icon = new_wallet
					return

				else //Dunno what to do. Resort to plain assistant ID.
					icon_state = initial(icon_state) + "id"
					return
	else
		icon = initial(icon)
		icon_state = initial(icon_state)

/obj/item/weapon/storage/wallet/GetID()
	return front_id

/obj/item/weapon/storage/wallet/GetAccess()
	var/obj/item/I = GetID()
	if(I)
		return I.GetAccess()
	else
		return ..()

/obj/item/weapon/storage/wallet/random/New()
	..()
	var/amount = rand(50, 100) + rand(50, 100) // Triangular distribution from 100 to 200
	var/obj/item/weapon/spacecash/SC = null
	for(var/i in list(100, 50, 20, 10, 5, 1))
		if(amount < i)
			continue
		SC = new(src)
		while(amount >= i)
			amount -= i
			SC.adjust_worth(i, 0)
		SC.update_icon()

/obj/item/weapon/storage/wallet/grey
	icon_state = "greywallet"

/obj/item/weapon/storage/wallet/green
	icon_state = "greenwallet"

/obj/item/weapon/storage/wallet/purple
	icon_state = "purplewallet"

/obj/item/weapon/storage/wallet/red
	icon_state = "redwallet"

/obj/item/weapon/storage/wallet/blue
	icon_state = "bluewallet"

/obj/item/weapon/storage/wallet/white
	icon_state = "whitewallet"
