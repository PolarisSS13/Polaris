/obj/item/gun_component/chamber/ballistic/pump
	name = "pump-action loader"
	weapon_type = GUN_SHOTGUN
	max_shots = 4
	load_method = SINGLE_CASING
	handle_casings = HOLD_CASINGS
	has_user_interaction = 1

/obj/item/gun_component/chamber/ballistic/pump/large
	name = "extended-capacity pump-action loader"
	max_shots = 8

/obj/item/gun_component/chamber/ballistic/pump/consume_next_projectile()
	if(chambered)
		return chambered.projectile
	return null

/obj/item/gun_component/chamber/ballistic/pump/do_user_interaction(var/mob/user)
	playsound(user, 'sound/weapons/shotgunpump.ogg', 60, 1)
	if(chambered)//We have a shell in the chamber
		chambered.forceMove(get_turf(src))
		chambered = null
	if(loaded.len)
		var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
		loaded -= AC //Remove casing from loaded list.
		chambered = AC
	update_ammo_overlay()
	return 1

// For grenade launchers.
/obj/item/gun_component/chamber/ballistic/pump/cannon
	weapon_type = GUN_CANNON
	handle_casings = EJECT_CASINGS
	max_shots = 6