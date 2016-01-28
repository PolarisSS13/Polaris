/obj/item/gun_component/chamber/ballistic/pistol/auto
	name = "autoloader"
	max_shots = 10
	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=5,    burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0))
		)

/obj/item/gun_component/chamber/ballistic/shotgun/auto
	name = "autoloader"
	max_shots = 22
	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=0),
		list(mode_name="3-round bursts", burst=3, move_delay=6, burst_accuracy = list(0,-1,-1,-2,-2), dispersion = list(0.0, 0.6, 0.6)),
		)

/obj/item/gun_component/chamber/ballistic/smg
	name = "autoloader"
	weapon_type = GUN_SMG
	load_method = MAGAZINE|SPEEDLOADER
	max_shots = 22
	ammo_indicator_state = "ballistic_smg"
	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=5,    burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0))
		)

/obj/item/gun_component/chamber/ballistic/smg/small
	name = "small autoloader"
	max_shots = 15

/obj/item/gun_component/chamber/ballistic/assault
	name = "autoloader"
	weapon_type = GUN_ASSAULT
	load_method = MAGAZINE
	max_shots = 22
	ammo_indicator_state = "ballistic_assault"
	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="5-round bursts", burst=3, fire_delay=null, move_delay=5,    burst_accuracy=list(0,-1,-1), dispersion=list(0.0, 0.6, 1.0))
		)

/obj/item/gun_component/chamber/ballistic/assault/large
	name = "extended-capacity autoloader"
	max_shots = 50
	var/breech_open

/obj/item/gun_component/chamber/ballistic/assault/large/consume_next_projectile()
	return breech_open ? null : ..()

/obj/item/gun_component/chamber/ballistic/assault/large/can_load(var/mob/user)
	return breech_open

/obj/item/gun_component/chamber/ballistic/assault/large/do_user_interaction(var/mob/user)
	playsound(user, 'sound/weapons/empty.ogg', 50, 1)
	breech_open = !breech_open
	user << "<span class='notice'>You [breech_open ? "work open" : "snap shut"] \the [holder].</span>"

/obj/item/gun_component/chamber/ballistic/assault/eject
	name = "self-ejecting autoloader"
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'

/obj/item/gun_component/chamber/ballistic/autocannon
	weapon_type = GUN_CANNON
	max_shots = 20
	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=5,    burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0))
		)
