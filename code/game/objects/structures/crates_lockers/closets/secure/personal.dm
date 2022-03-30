/obj/structure/closet/secure_closet/personal
	name = "personal closet"
	desc = "It's a secure locker for personnel. The first card swiped gains control."
	req_access = list(access_all_personal_lockers)
	var/registered_name = null

	starts_with = list(
		/obj/item/device/radio/headset)

/obj/structure/closet/secure_closet/personal/Initialize()
	if(prob(50))
		starts_with += /obj/item/storage/backpack
	else
		starts_with += /obj/item/storage/backpack/satchel/norm
	return ..()

/obj/structure/closet/secure_closet/personal/patient
	name = "patient's closet"
	closet_appearance = /decl/closet_appearance/secure_closet/patient

	starts_with = list(
		/obj/item/clothing/under/medigown,
		/obj/item/clothing/under/color/white,
		/obj/item/clothing/shoes/white)


/obj/structure/closet/secure_closet/personal/cabinet
	closet_appearance = /decl/closet_appearance/cabinet/secure
	door_anim_time = 0 //Unsupported
	open_sound = 'sound/machines/closet/closet_wood_open.ogg'
	close_sound = 'sound/machines/closet/closet_wood_close.ogg'

	starts_with = list(
		/obj/item/storage/backpack/satchel/withwallet,
		/obj/item/device/radio/headset
		)

/obj/structure/closet/secure_closet/personal/attackby(obj/item/W as obj, mob/user as mob)
	if (src.opened)
		if (istype(W, /obj/item/grab))
			var/obj/item/grab/G = W
			src.MouseDrop_T(G.affecting, user)      //act like they were dragged onto the closet
		user.drop_item()
		if (W) W.forceMove(src.loc)
	else if(W.GetID())
		var/obj/item/card/id/I = W.GetID()

		if(src.broken)
			to_chat(user, "<span class='warning'>It appears to be broken.</span>")
			return
		if(!I || !I.registered_name)	return
		if(src.allowed(user) || !src.registered_name || (istype(I) && (src.registered_name == I.registered_name)))
			//they can open all lockers, or nobody owns this, or they own this locker
			src.locked = !( src.locked )

			if(!src.registered_name)
				src.registered_name = I.registered_name
				src.desc = "Owned by [I.registered_name]."
		else
			to_chat(user, "<span class='warning'>Access Denied</span>")
	else if(istype(W, /obj/item/melee/energy/blade))
		if(emag_act(INFINITY, user, "The locker has been sliced open by [user] with \an [W]!", "You hear metal being sliced and sparks flying."))
			var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread()
			spark_system.set_up(5, 0, src.loc)
			spark_system.start()
			playsound(src, 'sound/weapons/blade1.ogg', 50, 1)
			playsound(src, "sparks", 50, 1)
	else
		to_chat(user, "<span class='warning'>Access Denied</span>")
	update_icon()

/obj/structure/closet/secure_closet/personal/emag_act(var/remaining_charges, var/mob/user, var/visual_feedback, var/audible_feedback)
	if(!broken)
		broken = 1
		locked = 0
		desc = "It appears to be broken."
		update_icon()
		if(visual_feedback)
			visible_message("<span class='warning'>[visual_feedback]</span>", "<span class='warning'>[audible_feedback]</span>")
		return 1

/obj/structure/closet/secure_closet/personal/verb/reset()
	set src in oview(1) // One square distance
	set category = "Object"
	set name = "Reset Lock"
	if(!usr.canmove || usr.stat || usr.restrained()) // Don't use it if you're not able to! Checks for stuns, ghost and restrain
		return
	if(ishuman(usr))
		src.add_fingerprint(usr)
		if (src.locked || !src.registered_name)
			to_chat(usr, "<span class='warning'>You need to unlock it first.</span>")
		else if (src.broken)
			to_chat(usr, "<span class='warning'>It appears to be broken.</span>")
		else
			if (src.opened)
				if(!src.close())
					return
			src.locked = 1
			update_icon()
			src.registered_name = null
			src.desc = "It's a secure locker for personnel. The first card swiped gains control."
