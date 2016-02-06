/obj/item/gun_component/chamber/ballistic/breech/revolver
	name = "revolver cylinder"
	weapon_type = GUN_PISTOL
	handle_casings = CYCLE_CASINGS
	max_shots = 6
	has_alt_interaction = 1
	revolver = 1

	var/chamber_offset = 0

/obj/item/gun_component/chamber/ballistic/breech/revolver/consume_next_projectile()
	if(chamber_offset)
		chamber_offset--
		return
	return ..()

/obj/item/gun_component/chamber/ballistic/breech/revolver/load_ammo(var/obj/item/A, var/mob/user)
	chamber_offset = 0
	return ..()

/obj/item/gun_component/chamber/ballistic/breech/revolver/unload_ammo(var/mob/user)
	chamber_offset = 0
	return ..()

/obj/item/gun_component/chamber/ballistic/breech/revolver/do_user_alt_interaction(var/mob/user)
	chamber_offset = 0
	visible_message("<span class='warning'>\The [user] spins the cylinder of \the [holder]!</span>")
	playsound(src.loc, 'sound/weapons/revolver_spin.ogg', 100, 1)
	loaded = shuffle(loaded)
	if(rand(1,max_shots) > loaded.len)
		chamber_offset = rand(0,max_shots-loaded.len)
	return 1

/obj/item/gun_component/chamber/ballistic/breech/revolver/stun
	name = "rotating cartridge rack"
	max_shots = 8
