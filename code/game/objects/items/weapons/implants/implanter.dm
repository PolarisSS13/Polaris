/obj/item/implanter
	name = "implanter"
	icon = 'icons/obj/items.dmi'
	icon_state = "implanter0_1"
	item_state = "syringe_0"
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_SMALL
	matter = list(MAT_STEEL = 1000, MAT_GLASS = 1000)
	var/obj/item/implant/imp = null
	var/active = 1

/obj/item/implanter/attack_self(var/mob/user)
	active = !active
	to_chat(user, "<span class='notice'>You [active ? "" : "de"]activate \the [src].</span>")
	update()

/obj/item/implanter/verb/remove_implant(var/mob/user)
	set category = "Object"
	set name = "Remove Implant"
	set src in usr

	if(!imp)
		return
	imp.loc = get_turf(src)
	user.put_in_hands(imp)
	to_chat(user, "<span class='notice'>You remove \the [imp] from \the [src].</span>")
	name = "implanter"
	imp = null
	update()

/obj/item/implanter/proc/update()
	if (src.imp)
		src.icon_state = "implanter1"
	else
		src.icon_state = "implanter0"
	src.icon_state += "_[active]"

/obj/item/implanter/attack(mob/M as mob, mob/user as mob)
	if (!istype(M, /mob/living/carbon))
		return
	if(active)
		if (imp)
			M.visible_message("<span class='warning'>[user] is attempting to implant [M].</span>")

			user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
			user.do_attack_animation(M)

			var/turf/T1 = get_turf(M)
			if (T1 && ((M == user) || do_after(user, 50)))
				if(user && M && (get_turf(M) == T1) && src && src.imp)
					M.visible_message("<span class='warning'>[M] has been implanted by [user].</span>")

					add_attack_logs(user,M,"Implanted with [imp.name] using [name]")

					if(imp.handle_implant(M))
						imp.post_implant(M)

						if(ishuman(M))
							var/mob/living/carbon/human/H = M
							BITSET(H.hud_updateflag, IMPLOYAL_HUD)

					src.imp = null
					update()
	else
		to_chat(user, "<span class='warning'>You need to activate \the [src.name] first.</span>")
	return

/obj/item/implanter/loyalty
	name = "implanter-loyalty"

/obj/item/implanter/loyalty/Initialize()
	src.imp = new /obj/item/implant/loyalty( src )
	. = ..()
	update()

/obj/item/implanter/explosive
	name = "implanter (E)"

/obj/item/implanter/explosive/Initialize()
	src.imp = new /obj/item/implant/explosive( src )
	. = ..()
	update()

/obj/item/implanter/adrenalin
	name = "implanter-adrenalin"

/obj/item/implanter/adrenalin/Initialize()
	src.imp = new /obj/item/implant/adrenalin(src)
	. = ..()
	update()

/obj/item/implanter/compressed
	name = "implanter (C)"
	icon_state = "cimplanter1"

/obj/item/implanter/compressed/Initialize()
	imp = new /obj/item/implant/compressed( src )
	. = ..()
	update()

/obj/item/implanter/compressed/update()
	if (imp)
		var/obj/item/implant/compressed/c = imp
		if(!c.scanned)
			icon_state = "cimplanter1"
		else
			icon_state = "cimplanter2"
	else
		icon_state = "cimplanter0"

/obj/item/implanter/compressed/attack(mob/M as mob, mob/user as mob)
	var/obj/item/implant/compressed/c = imp
	if (!c)	return
	if (c.scanned == null)
		to_chat(user, "Please scan an object with the implanter first.")
		return
	..()

/obj/item/implanter/compressed/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity)
		return
	if(!active)
		to_chat(user, "<span class='warning'>Activate \the [src.name] first.</span>")
		return
	if(istype(A,/obj/item) && imp)
		var/obj/item/implant/compressed/c = imp
		if (c.scanned)
			to_chat(user, "<span class='warning'>Something is already scanned inside the implant!</span>")
			return
		c.scanned = A
		if(istype(A, /obj/item/storage))
			to_chat(user, "<span class='warning'>You can't store \the [A.name] in this!</span>")
			c.scanned = null
			return
		if(istype(A.loc,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = A.loc
			H.remove_from_mob(A)
		else if(istype(A.loc,/obj/item/storage))
			var/obj/item/storage/S = A.loc
			S.remove_from_storage(A)
		A.loc.contents.Remove(A)
		update()

/obj/item/implanter/restrainingbolt
	name = "implanter (bolt)"

/obj/item/implanter/restrainingbolt/Initialize()
	src.imp = new /obj/item/implant/restrainingbolt( src )
	. = ..()
	update()
