///////// Smart Mags /////////

/obj/item/ammo_magazine/smart
	name = "smart magazine"
	icon_state = "smartmag-empty"
	desc = "A Hephaistos Industries brand Smart Magazine. It uses advanced matter manipulation technology to create bullets from energy. Simply present your loaded gun or magazine to the Smart Magazine."
	multiple_sprites = 1
	max_ammo = 20
	mag_type = MAGAZINE

	caliber = null 	 //Set later
	ammo_type = null //Set later
	initial_ammo = 0 //Ensure no problems with no ammo_type or caliber set

	var/production_time = 3 //20 bullets per minute
	var/last_production_time = 0
	var/production_cost = null
	var/production_modifier = 2.5

	var/obj/item/weapon/cell/attached_cell = null

	var/emagged = 0

/obj/item/ammo_magazine/smart/New()
	processing_objects |= src
	..()

/obj/item/ammo_magazine/smart/Destroy()
	processing_objects -= src
	..()

/obj/item/ammo_magazine/smart/examine(mob/user)
	..()
	if(attached_cell)
		user << "<span class='notice'>\The [src] is loaded with a [attached_cell.name]. It is [round(attached_cell.percent())]% charged.</span>"
	if(!attached_cell)
		user << "<span class='warning'>\The [src] does not appear to have a power source installed.</span>"

/obj/item/ammo_magazine/smart/update_icon()
	if(attached_cell)
		icon_state = "smartmag-filled"
	else if(!(attached_cell))
		icon_state = "smartmag-empty"

/obj/item/ammo_magazine/smart/proc/chargereduction()
	if(attached_cell)
		if(attached_cell.checked_use(production_cost))
			return 1
		else
			return 0

	return null

/obj/item/ammo_magazine/smart/proc/set_production_cost(var/obj/item/ammo_casing/A)
	var/list/matters = ammo_repository.get_materials_from_object(A)
	var/tempcost
	for(var/key in matters)
		var/value = matters[key]
		world << "Value: [value]"
		tempcost += value*production_modifier
		world << "Tempcost: [tempcost]"
	production_cost = tempcost
	world << "Production cost is: [production_cost]"

/obj/item/ammo_magazine/smart/attack_self(mob/user)
	if(emagged)
		return ..()
	else
		user << "<span class='notice'>\The [src] is not designed to be unloaded.</span>"
		return

/obj/item/ammo_magazine/smart/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		user << "<span class='notice'>You overload \the [src]'s security measures causing widespread destabilisation. It is likely you could empty \the [src] now.</span>"
		emagged = 1
		return 1

/obj/item/ammo_magazine/smart/attackby(var/obj/item/I as obj, mob/user)
	if(istype(I, /obj/item/weapon/cell))
		if(attached_cell)
			user << "<span class='notice'>\The [src] already has a [attached_cell.name] attached.</span>"
			return
		else
			user << "You begin inserting \the [I] into \the [src]."
			if(do_after(user, 25))
				user.drop_item()
				I.loc = src
				attached_cell = I
				user.visible_message("[user] installs a cell in \the [src].", "You install \the [I] into \the [src].")
				update_icon()
				return

	else if(istype(I, /obj/item/weapon/screwdriver))
		if(attached_cell)
			user << "You begin removing \the [attached_cell] from \the [src]."
			if(do_after(user, 25))
				attached_cell.update_icon()
				attached_cell.loc = get_turf(src.loc)
				attached_cell = null
				user.visible_message("[user] removes a cell from \the [src].", "You remove \the [attached_cell] from \the [src].")
				update_icon()
				return


	var/obj/item/ammo_magazine/A
	var/obj/item/weapon/gun/projectile/G
	if(istype(I, /obj/item/ammo_magazine))
		A = I
	else if(istype(I, /obj/item/weapon/gun/projectile))
		G = I
	else
		return

	if(G && caliber == G.caliber && ammo_type == G.ammo_type || A && caliber == A.caliber && ammo_type == A.ammo_type)
		..()
	else
		user << "<span class='notice'>You scan \the [I] with \the [src], copying \the [I]'s caliber and ammunition type.</span>"
		if(A || G)
			if(G)
				A = G.ammo_magazine
			if(A.caliber)
				caliber = A.caliber
			if(A.ammo_type)
				set_production_cost(A.ammo_type)
				ammo_type = A.ammo_type
			else
				return
		else
			return

		stored_ammo.Cut()

/obj/item/ammo_magazine/smart/proc/produce()
	if(chargereduction())
		var/obj/item/ammo_casing/W = new ammo_type(src.loc)
		W.loc = src
		stored_ammo.Insert(1, W) //add to the head of the list
		chargereduction()
		return 1
	return 0

/obj/item/ammo_magazine/smart/process()
	if(caliber && ammo_type && attached_cell)
		if(stored_ammo.len == max_ammo)
			return
		if(last_production_time == 0)
			last_production_time = world.time
			produce()
		if(world.time > last_production_time + production_time)
			last_production_time = world.time
			produce()
