/obj/item/gun_component/chamber/ballistic/breech
	name = "breech loader"
	weapon_type = GUN_SHOTGUN
	max_shots = 4
	load_method = SINGLE_CASING|SPEEDLOADER
	handle_casings = HOLD_CASINGS
	has_user_interaction = 1
	var/breech_open

/obj/item/gun_component/chamber/ballistic/breech/consume_next_projectile()
	return breech_open ? null : ..()

/obj/item/gun_component/chamber/ballistic/breech/rifle
	weapon_type = GUN_RIFLE
	handle_casings = EJECT_CASINGS
	max_shots = 1

/obj/item/gun_component/chamber/ballistic/breech/can_load(var/mob/user)
	return breech_open

/obj/item/gun_component/chamber/ballistic/breech/do_user_interaction(var/mob/user)
	playsound(user, 'sound/weapons/empty.ogg', 50, 1)
	breech_open = !breech_open
	user << "<span class='notice'>You [breech_open ? "work open" : "snap shut"] \the [holder].</span>"

