
/obj/structure/cult/altar
	name = "altar"
	desc = "An alchemical altar used for research into the arcane arts."
	icon_state = "altar"

	var/obj/item/device/crystalball/spellfocus = null

	var/obj/item/weapon/book/tome/tome = null

	var/image/orb
	var/orb_state = "crystalball"
	var/image/book
	var/tome_state = "tome"

/obj/structure/cult/altar/Destroy()
	var/turf/T = get_turf(src)
	if(T)
		if(spellfocus)
			spellfocus.forceMove(T)
			spellfocus = null
		if(tome)
			tome.forceMove(T)
			tome = null

	else
		if(spellfocus)
			qdel(spellfocus)
			spellfocus = null
		if(tome)
			qdel(tome)
			tome = null

	..()

/obj/structure/cult/altar/update_icon()
	..()
	cut_overlays()

	if(!orb)
		orb = image(icon=src.icon,icon_state=orb_state)

	if(!book)
		book = image(icon=src.icon,icon_state=tome_state)

	if(spellfocus)
		orb.icon_state = spellfocus.icon_state

		if(spellfocus.color)
			orb.color = spellfocus.color
		else
			orb.color = null

		add_overlay(orb)

	if(tome)
		book.icon_state = tome.icon_state

		if(tome.color)
			book.color = tome.color
		else
			book.color = null

		add_overlay(book)

/obj/structure/cult/altar/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/material/kitchen/utensil/fork/tuning))
		if(do_after(user, 3 SECONDS, src))
			playsound(get_turf(src),W.usesound, 50, 1)
			anchored = !anchored
			update_icon()
			return

	if(!spellfocus && istype(W, /obj/item/device/crystalball))
		user.drop_from_inventory(W)

		spellfocus = W

		spellfocus.forceMove(src)
		update_icon()
		return

	if(!tome && istype(W, /obj/item/weapon/book/tome))
		user.drop_from_inventory(W)

		tome = W

		tome.forceMove(src)
		update_icon()
		return

	return ..()
