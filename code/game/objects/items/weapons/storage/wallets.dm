/obj/item/storage/wallet
	name = "wallet"
	desc = "It can hold a few small and personal things."
	storage_slots = 10
	icon = 'icons/obj/wallet.dmi'
	icon_state = "wallet-orange"
	w_class = ITEMSIZE_SMALL
	can_hold = list(
		/obj/item/spacecash,
		/obj/item/card,
		/obj/item/clothing/mask/smokable/cigarette/,
		/obj/item/flashlight/pen,
		/obj/item/tape,
		/obj/item/cartridge,
		/obj/item/encryptionkey,
		/obj/item/seeds,
		/obj/item/stack/medical,
		/obj/item/coin,
		/obj/item/dice,
		/obj/item/disk,
		/obj/item/implanter,
		/obj/item/flame/lighter,
		/obj/item/flame/match,
		/obj/item/forensics,
		/obj/item/glass_extra,
		/obj/item/haircomb,
		/obj/item/hand,
		/obj/item/key,
		/obj/item/lipstick,
		/obj/item/paper,
		/obj/item/pen,
		/obj/item/photo,
		/obj/item/reagent_containers/dropper,
		/obj/item/sample,
		/obj/item/tool/screwdriver,
		/obj/item/stamp,
		/obj/item/clothing/accessory/permit,
		/obj/item/clothing/accessory/badge,
		/obj/item/makeover
		)
	cant_hold = list(/obj/item/tool/screwdriver/power)
	slot_flags = SLOT_ID

	var/obj/item/card/id/front_id = null

/obj/item/storage/wallet/remove_from_storage(obj/item/W as obj, atom/new_location)
	. = ..(W, new_location)
	if(.)
		if(W == front_id)
			front_id = null
			name = initial(name)
			update_icon()

/obj/item/storage/wallet/handle_item_insertion(obj/item/W as obj, prevent_warning = 0)
	. = ..(W, prevent_warning)
	if(.)
		if(!front_id && istype(W, /obj/item/card/id))
			front_id = W
			name = "[name] ([front_id])"
			update_icon()

/obj/item/storage/wallet/update_icon()
	overlays.Cut()
	if(front_id)
		var/tiny_state = "id-generic"
		if("id-"+front_id.icon_state in icon_states(icon))
			tiny_state = "id-"+front_id.icon_state
		var/image/tiny_image = new/image(icon, icon_state = tiny_state)
		tiny_image.appearance_flags = RESET_COLOR
		overlays += tiny_image

/obj/item/storage/wallet/GetID()
	return front_id

/obj/item/storage/wallet/GetAccess()
	var/obj/item/I = GetID()
	if(I)
		return I.GetAccess()
	else
		return ..()

/obj/item/storage/wallet/random/New()
	..()
	var/amount = rand(50, 100) + rand(50, 100) // Triangular distribution from 100 to 200
	var/obj/item/spacecash/SC = null
	SC = new(src)
	for(var/i in list(100, 50, 20, 10, 5, 1))
		if(amount < i)
			continue
		while(amount >= i)
			amount -= i
			SC.adjust_worth(i, 0)
		SC.update_icon()

/obj/item/storage/wallet/poly
	name = "polychromic wallet"
	desc = "You can recolor it! Fancy! The future is NOW!"
	icon_state = "wallet-white"

/obj/item/storage/wallet/poly/New()
	..()
	verbs |= /obj/item/storage/wallet/poly/proc/change_color
	color = "#"+get_random_colour()
	update_icon()

/obj/item/storage/wallet/poly/proc/change_color()
	set name = "Change Wallet Color"
	set category = "Object"
	set desc = "Change the color of the wallet."
	set src in usr

	if(usr.stat || usr.restrained() || usr.incapacitated())
		return

	var/new_color = input(usr, "Pick a new color", "Wallet Color", color) as color|null

	if(new_color && (new_color != color))
		color = new_color

/obj/item/storage/wallet/poly/emp_act()
	var/original_state = icon_state
	icon_state = "wallet-emp"
	update_icon()

	spawn(200)
		if(src)
			icon_state = original_state
			update_icon()

/obj/item/storage/wallet/womens
	name = "women's wallet"
	desc = "A stylish wallet typically used by women."
	icon_state = "girl_wallet"
	item_state_slots = list(slot_r_hand_str = "wowallet", slot_l_hand_str = "wowallet")
