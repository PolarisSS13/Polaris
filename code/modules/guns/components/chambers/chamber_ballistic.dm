/obj/item/gun_component/chamber/ballistic
	projectile_type = GUN_TYPE_BALLISTIC

	var/load_method = SINGLE_CASING|SPEEDLOADER
	var/handle_casings = EJECT_CASINGS
	var/list/loaded = list()
	var/obj/item/ammo_casing/chambered
	var/obj/item/ammo_magazine/magazine
	var/auto_eject_sound // If null, will not autoeject.
	var/ammo_type // Either a casing or magazine type; used to pre-load the component in New().

/obj/item/gun_component/chamber/ballistic/update_ammo_overlay()
	if(ammo_indicator_state)
		if(!loaded.len && !magazine)
			if(!ammo_overlay)
				if(model)
					ammo_overlay = image(icon = model.ammo_indicator_icon)
				else
					ammo_overlay = image(icon = 'icons/obj/gun_components/unbranded_load_overlays.dmi')
			ammo_overlay.icon_state = ""
			return
		..()

/obj/item/gun_component/chamber/ballistic/empty()
	loaded.Cut()
	chambered = null
	magazine = null
	..()

/obj/item/gun_component/chamber/ballistic/Destroy()
	loaded.Cut()
	if(chambered)
		qdel(chambered)
		chambered = null
	if(magazine)
		qdel(magazine)
		magazine = null
	return ..()

/obj/item/gun_component/chamber/ballistic/get_shots_remaining()
	var/bullets = 0
	if(loaded)
		bullets += loaded.len
	if(magazine && magazine.stored_ammo)
		bullets += magazine.stored_ammo.len
	if(chambered)
		bullets += 1
	return bullets

/obj/item/gun_component/chamber/ballistic/New()
	if(ammo_type)
		switch(load_method)
			// Assumes the supplied path is a single casing.
			if(SINGLE_CASING, SPEEDLOADER)
				for(var/i in 1 to max_shots)
					loaded += new ammo_type(src)
			// Assumes the supplied path is a magazine.
			if(MAGAZINE)
				magazine = new ammo_type(src)
	..()

/obj/item/gun_component/chamber/ballistic/handle_post_fire()

	if(chambered)
		chambered.expend()
		process_chambered_round()

	if(auto_eject_sound && magazine && magazine.stored_ammo && !magazine.stored_ammo.len)
		var/turf/T = get_turf(src)
		magazine.forceMove(T)
		T.visible_message("<span class='warning'>\The [holder]'s [magazine.name] falls out and clatters on the floor!</span>")
		playsound(T, auto_eject_sound, 40, 1)
		magazine.update_icon()
		magazine = null

	..()

/obj/item/gun_component/chamber/ballistic/handle_click_empty()
	process_chambered_round()

/obj/item/gun_component/chamber/ballistic/proc/process_chambered_round()

	if (!chambered)
		return

	// Aurora forensics port, gunpowder residue.
	if(chambered.leaves_residue)
		var/mob/living/carbon/human/H = holder.loc
		if(istype(H))
			if(!H.gloves)
				H.gunshot_residue = chambered.caliber
			else
				var/obj/item/clothing/G = H.gloves
				G.gunshot_residue = chambered.caliber

	// Eject or contain casings.
	switch(handle_casings)
		if(EJECT_CASINGS) //eject casing onto ground.
			chambered.forceMove(get_turf(src))
		if(CYCLE_CASINGS) //cycle the casing back to the end.
			if(magazine)
				magazine.stored_ammo += chambered
			else
				loaded += chambered
		if(DESTROY_CASINGS)
			qdel(chambered)
			chambered = null
	// If this is a gun that doesn't need unloading, clear the casing slot.
	if(handle_casings != HOLD_CASINGS)
		chambered = null

/obj/item/gun_component/chamber/ballistic/consume_next_projectile()
	if(loaded.len)
		chambered = loaded[1] //load next casing.
		if(handle_casings != HOLD_CASINGS)
			loaded -= chambered
	else if(magazine && magazine.stored_ammo.len)
		chambered = magazine.stored_ammo[1]
		if(handle_casings != HOLD_CASINGS)
			magazine.stored_ammo -= chambered
	if(chambered)
		return chambered.projectile
	return null

/obj/item/gun_component/chamber/ballistic/proc/can_load(var/mob/user)
	return 1

/obj/item/gun_component/chamber/ballistic/load_ammo(var/obj/item/A, var/mob/user)

	if(istype(A, /obj/item/ammo_magazine))
		var/obj/item/ammo_magazine/AM = A
		if(!(load_method & AM.mag_type) || holder.caliber != AM.caliber)
			return //incompatible

		switch(AM.mag_type)

			if(MAGAZINE)

				if(magazine)
					user << "<span class='warning'>\The [holder] already has a magazine loaded.</span>" //already a magazine here
					return

				if(!can_load(user))
					return

				user.unEquip(AM)
				AM.forceMove(src)
				magazine = AM
				user.visible_message("<span class='danger'>\The [user] inserts \the [AM] into \the [holder].</span>")
				playsound(src.loc, 'sound/weapons/flipblade.ogg', 50, 1)

			if(SPEEDLOADER)

				if(!can_load(user))
					return

				if(loaded.len >= max_shots)
					user << "<span class='warning'>\The [holder] is full!</span>"
					return

				var/count = 0
				for(var/obj/item/ammo_casing/C in AM.stored_ammo)
					if(loaded.len >= max_shots)
						break
					if(C.caliber == holder.caliber)
						C.forceMove(src)
						loaded += C
						AM.stored_ammo -= C
						count++

				if(count)
					user << "<span class='notice'>You load [count] round\s into \the [holder].</span>"
					user.visible_message("<span class='danger'>\The [user] reloads \the [holder].</span>")
					playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1)
				else
					user << "<span class='warning'>\The [holder] is full!</span>"
					return

	else if(istype(A, /obj/item/ammo_casing))

		var/obj/item/ammo_casing/C = A
		if(!(load_method & SINGLE_CASING) || holder.caliber != C.caliber)
			return //incompatible
		if(loaded.len >= max_shots)
			user << "<span class='warning'>\The [holder] is full.</span>"
			return

		if(!can_load(user))
			return

		user.unEquip(C)
		C.forceMove(src)
		loaded.Insert(1, C) //add to the head of the list
		user.visible_message("<span class='danger'>\The [user] inserts \a [C] into \the [holder].</span>")
		playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1)

	holder.update_icon()
	update_ammo_overlay()

/obj/item/gun_component/chamber/ballistic/unload_ammo(var/mob/user)

	if(magazine)
		magazine.forceMove(get_turf(src))
		user.put_in_hands(magazine)
		user.visible_message("</span class='notice'>\The [user] removes \the [magazine] from \the [holder].</span>")
		playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1)
		magazine.update_icon()
		magazine = null
	else if(loaded.len)

		var/obj/item/ammo_casing/C = loaded[loaded.len]
		C.forceMove(get_turf(src))
		loaded.len--
		user.put_in_hands(C)
		user.visible_message("<span class='notice'>[user] removes \a [C] from \the [holder].</span>")
	else
		user << "<span class='warning'>\The [holder] is empty.</span>"

	holder.update_icon()
	update_ammo_overlay()

/obj/item/gun_component/chamber/ballistic/pistol
	weapon_type = GUN_PISTOL
	load_method = MAGAZINE
	max_shots = 8

/obj/item/gun_component/chamber/ballistic/shotgun
	handle_casings = HOLD_CASINGS
	max_shots = 4
