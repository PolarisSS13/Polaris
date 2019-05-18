/* Gifts and wrapping paper
 * Contains:
 *		Gifts
 *		Wrapping Paper
 */

/*
 * Gifts
 */
/obj/item/weapon/a_gift
	name = "gift"
	desc = "PRESENTS!!!! eek!"
	icon = 'icons/obj/items.dmi'
	icon_state = "gift1"
	item_state = "gift1"
	drop_sound = 'sound/items/drop/box.ogg'

/obj/item/weapon/a_gift/New()
	..()
	pixel_x = rand(-10,10)
	pixel_y = rand(-10,10)
	if(w_class > 0 && w_class < ITEMSIZE_LARGE)
		icon_state = "gift[w_class]"
	else
		icon_state = "gift[pick(1, 2, 3)]"
	return

/obj/item/weapon/gift/attack_self(mob/user as mob)
	user.drop_item()
	playsound(src.loc, 'sound/items/package_unwrap.ogg', 50,1)
	if(src.gift)
		user.put_in_active_hand(gift)
		src.gift.add_fingerprint(user)
	else
		user << "<span class='warning'>The gift was empty!</span>"
	qdel(src)
	return

/obj/item/weapon/a_gift/ex_act()
	qdel(src)
	return

/obj/effect/spresent/relaymove(mob/user as mob)
	if (user.stat)
		return
	user << "<span class='warning'>You can't move.</span>"

/obj/effect/spresent/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()

	if (!istype(W, /obj/item/weapon/scissors))
		user << "<span class='warning'>I need wirecutters for that.</span>"
		return

	user << "<span class='notice'>You cut open the present.</span>"

	for(var/mob/M in src) //Should only be one but whatever.
		M.loc = src.loc
		if (M.client)
			M.client.eye = M.client.mob
			M.client.perspective = MOB_PERSPECTIVE

	qdel(src)

/obj/item/weapon/a_gift/attack_self(mob/M as mob)
	var/gift_type = pick(
		/obj/item/weapon/ore/coal, //for the very bad kids.
		/obj/item/toy/bouquet,
		/obj/item/toy/stickhorse,
		/obj/item/toy/eight_ball,
		/obj/item/toy/eight_ball/conch,
		/obj/item/toy/griffin,
		/obj/item/toy/snappop,
		/obj/item/weapon/spacecash/c10,
		/obj/item/weapon/dice,
		/obj/item/weapon/lipstick/random,
		/obj/item/device/camera,
		/obj/item/device/binoculars,
		/obj/item/weapon/bikehorn/rubberducky,
		/obj/item/weapon/deck/tarot,
		/obj/item/weapon/flame/lighter/random,
		/obj/item/weapon/flame/lighter/zippo/ironic,
		/obj/item/weapon/flame/lighter/zippo/gold,
		/obj/item/weapon/pen/fountain,
		/obj/item/device/laptop,
		/obj/item/toy/plushie/corgi,
		/obj/item/clothing/accessory/bracelet/friendship,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey,
		/obj/item/weapon/haircomb,
		/obj/item/weapon/inflatable_duck,
		/obj/item/toy/balloon,
		/obj/item/weapon/beach_ball/holoball,
		/obj/item/weapon/soap/deluxe,
		/obj/item/weapon/toy/xmas_cracker,
		/obj/item/toy/waterflower,
		/obj/item/weapon/melee/umbrella/random,
		/obj/item/weapon/paper/card/smile,
		/obj/item/weapon/storage/fancy/heartbox,
		/obj/item/clothing/accessory/locket,
		/obj/item/clothing/suit/xenos,
		/obj/item/stack/material/diamond,
		/obj/item/clothing/gloves/ring/material/silver,
		/obj/item/clothing/gloves/ring/material/gold,
		/obj/random/soap,
		/obj/random/drinkbottle)

	if(!ispath(gift_type,/obj/item))	return

	var/obj/item/I = new gift_type(M)
	M.remove_from_mob(src)
	M.put_in_hands(I)
	I.add_fingerprint(M)
	qdel(src)
	return

/*
 * Wrapping Paper
 */
/obj/item/weapon/wrapping_paper
	name = "wrapping paper"
	desc = "You can use this to wrap items in."
	icon = 'icons/obj/items.dmi'
	icon_state = "wrap_paper"
	var/amount = 20.0

/obj/item/weapon/wrapping_paper/attackby(obj/item/weapon/W as obj, mob/living/user as mob)
	..()
	if (!( locate(/obj/structure/table, src.loc) ))
		user << "<span class='warning'>You MUST put the paper on a table!</span>"
	if (W.w_class < ITEMSIZE_LARGE)
		if (user.get_type_in_hands(/obj/item/weapon/scissors))
			var/a_used = 2 ** (src.w_class - 1)
			if (src.amount < a_used)
				user << "<span class='warning'>You need more paper!</span>"
				return
			else
				if(istype(W, /obj/item/smallDelivery) || istype(W, /obj/item/weapon/gift)) //No gift wrapping gifts!
					return

				src.amount -= a_used
				user.drop_item()
				var/obj/item/weapon/gift/G = new /obj/item/weapon/gift( src.loc )
				G.size = W.w_class
				G.w_class = G.size + 1
				G.icon_state = text("gift[]", G.size)
				G.gift = W
				W.loc = G
				G.add_fingerprint(user)
				W.add_fingerprint(user)
				src.add_fingerprint(user)
			if (src.amount <= 0)
				new /obj/item/weapon/c_tube( src.loc )
				qdel(src)
				return
		else
			user << "<span class='warning'>You need scissors!</span>"
	else
		user << "<span class='warning'>The object is FAR too large!</span>"
	return


/obj/item/weapon/wrapping_paper/examine(mob/user)
	if(..(user, 1))
		user << text("There is about [] square units of paper left!", src.amount)

/obj/item/weapon/wrapping_paper/attack(mob/target as mob, mob/user as mob)
	if (!istype(target, /mob/living/carbon/human)) return
	var/mob/living/carbon/human/H = target

	if (istype(H.wear_suit, /obj/item/clothing/suit/straight_jacket) || H.stat)
		if (src.amount > 2)
			var/obj/effect/spresent/present = new /obj/effect/spresent (H.loc)
			src.amount -= 2

			if (H.client)
				H.client.perspective = EYE_PERSPECTIVE
				H.client.eye = present

			H.loc = present

			add_attack_logs(user,H,"Wrapped with [src]")
		else
			user << "<span class='warning'>You need more paper.</span>"
	else
		user << "They are moving around too much. A straightjacket would help."
