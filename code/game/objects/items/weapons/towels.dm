/obj/item/weapon/towel
	name = "towel"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "towel"
	slot_flags = SLOT_HEAD | SLOT_BELT | SLOT_OCLOTHING
	force = 3.0
	w_class = ITEMSIZE_NORMAL
	force = 0
	attack_verb = list("whipped")
	hitsound = 'sound/weapons/towelwhip.ogg'
	desc = "A soft cotton towel."
	drop_sound = 'sound/items/drop/clothing.ogg'

/obj/item/weapon/towel/attack_self(mob/living/user as mob)
	var/mob/living/carbon/human/H = user
	user.visible_message(text("<span class='notice'>[] uses [] to towel themselves off.</span>", user, src))
	playsound(user, 'sound/weapons/towelwipe.ogg', 25, 1)
	H.remove_face_style()
	H.update_icons_body()
	if(user.fire_stacks > 0)
		user.fire_stacks = (max(0, user.fire_stacks - 1.5))
	else if(user.fire_stacks < 0)
		user.fire_stacks = (min(0, user.fire_stacks + 1.5))



/obj/item/weapon/towel/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(user.zone_sel.selecting == BP_HEAD) // lipstick wiping
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H == user)
				user << "<span class='notice'>You wipe your face with the [src].</span>"
				H.remove_face_style()
				H.update_icons_body()
			else
				user.visible_message("<span class='warning'>[user] begins to wipe [H]'s face off with \the [src].</span>", \
								 	 "<span class='notice'>You begin to wipe off [H]'s face.</span>")
				if(do_after(user, 10) && do_after(user, 20, H, 5))	//user needs to keep their active hand, H does not.
					user.visible_message("<span class='notice'>[user] wipes [H]'s face off with \the [src].</span>", \
										 "<span class='notice'>You wipe off [H]'s face.</span>")
					H.remove_face_style()
					H.update_icons_body()


/obj/item/weapon/towel/random/New()
	..()
	color = "#"+get_random_colour()