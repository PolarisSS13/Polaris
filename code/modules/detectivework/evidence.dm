//CONTAINS: Evidence bags and fingerprint cards

/obj/item/weapon/evidencebag
	name = "evidence bag"
	desc = "An empty evidence bag."
	icon = 'icons/obj/storage.dmi'
	icon_state = "evidenceobj"
	item_state = ""
	w_class = 2
	var/obj/item/stored_item = null

/obj/item/weapon/evidencebag/MouseDrop(var/obj/item/I as obj)
	if (!ishuman(usr))
		return

	var/mob/living/carbon/human/user = usr

	if (!(user.l_hand == src || user.r_hand == src))
		return //bag must be in your hands to use

	if (isturf(I.loc))
		if (!user.Adjacent(I))
			return
	else
		//If it isn't on the floor. Do some checks to see if it's in our hands or a box. Otherwise give up.
		if(istype(I.loc,/obj/item/weapon/storage))	//in a container.
			var/sdepth = I.storage_depth(user)
			if (sdepth == -1 || sdepth > 1)
				return	//too deeply nested to access

			var/obj/item/weapon/storage/U = I.loc
			user.client.screen -= I
			U.contents.Remove(I)
		else if(user.l_hand == I)					//in a hand
			user.drop_l_hand()
		else if(user.r_hand == I)					//in a hand
			user.drop_r_hand()
		else
			return

	if(!istype(I) || I.anchored)
		return

	if(istype(I, /obj/item/weapon/evidencebag))
		user << "<span class='notice'>You find putting an evidence bag in another evidence bag to be slightly absurd.</span>"
		return

	if(I.w_class > 3)
		user << "<span class='notice'>[I] won't fit in [src].</span>"
		return

	if(contents.len)
		user << "<span class='notice'>[src] already has something inside it.</span>"
		return

	user.visible_message("[user] puts [I] into [src]", "You put [I] inside [src].",\
	"You hear a rustle as someone puts something into a plastic bag.")

	icon_state = "evidence"

	var/xx = I.pixel_x	//save the offset of the item
	var/yy = I.pixel_y
	I.pixel_x = 0		//then remove it so it'll stay within the evidence bag
	I.pixel_y = 0
	var/image/img = image("icon"=I, "layer"=FLOAT_LAYER)	//take a snapshot. (necessary to stop the underlays appearing under our inventory-HUD slots ~Carn
	I.pixel_x = xx		//and then return it
	I.pixel_y = yy
	overlays += img
	overlays += "evidence"	//should look nicer for transparent stuff. not really that important, but hey.

	desc = "An evidence bag containing [I]."
	I.loc = src
	stored_item = I
	w_class = I.w_class
	return


/obj/item/weapon/evidencebag/attack_self(mob/user as mob)
	if(contents.len)
		var/obj/item/I = contents[1]
		user.visible_message("[user] takes [I] out of [src]", "You take [I] out of [src].",\
		"You hear someone rustle around in a plastic bag, and remove something.")
		overlays.Cut()	//remove the overlays

		user.put_in_hands(I)
		stored_item = null

		w_class = initial(w_class)
		icon_state = "evidenceobj"
		desc = "An empty evidence bag."
	else
		user << "[src] is empty."
		icon_state = "evidenceobj"
	return

/obj/item/weapon/evidencebag/examine(mob/user)
	..(user)
	if (stored_item) user.examinate(stored_item)

/obj/item/weapon/storage/box/evidence
	name = "evidence bag box"
	desc = "A box claiming to contain evidence bags. Also holds fingerprint cards."
	icon = 'icons/obj/storage.dmi'
	icon_state = "box"
	storage_slots= 14
	max_w_class = 3
	max_storage_space = 38
	can_hold = list(/obj/item/weapon/f_card, /obj/item/weapon/evidencebag)
	use_to_pickup = 1
	New()
		new /obj/item/weapon/evidencebag(src)
		new /obj/item/weapon/evidencebag(src)
		new /obj/item/weapon/evidencebag(src)
		new /obj/item/weapon/evidencebag(src)
		new /obj/item/weapon/evidencebag(src)
		new /obj/item/weapon/evidencebag(src)
		..()
		return

/obj/item/weapon/f_card
	name = "finger print card"
	desc = "Used to take fingerprints."
	icon = 'icons/obj/card.dmi'
	icon_state = "fingerprint0"
	var/amount = 10.0
	item_state = "paper"
	throwforce = 1
	w_class = 1.0
	slot_flags = SLOT_EARS
	throw_speed = 3
	throw_range = 5

/obj/item/weapon/f_card/add_fingerprint(mob/living/M as mob, ignoregloves = 0)
	if(..())
		var/mob/living/carbon/human/H = M
		var/full_print = md5(H.dna.uni_identity)
		fingerprints[full_print] = full_print

/obj/item/weapon/f_card/examine(mob/user)
	..()
	if(fingerprints.len)
		user << "<span class='notice'>Fingerprints on this card:</span>"
		for(var/print in fingerprints)
			user << "<span class='notice'>\t[fingerprints[print]]</span>"

/obj/item/weapon/fcardholder
	name = "fingerprint card case"
	desc = "Apply finger print card."
	icon = 'icons/obj/items.dmi'
	icon_state = "fcardholder0"
	item_state = "clipboard"
