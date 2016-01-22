/obj/item/gun_component/barrel/laser/variable
	name = "variable-output projector"
	caliber = "variable"
	weapon_type = GUN_PISTOL
	override_name = "variable-output"
	firemodes = list(
		list(mode_name="stun",   caliber = CALIBER_LASER_TASER),
		list(mode_name="lethal", caliber = CALIBER_LASER),
		)

/obj/item/gun_component/barrel/laser/variable/New()
	..()
	var/list/fmode = firemodes[1]
	caliber = (fmode["caliber"] ? fmode["caliber"] : CALIBER_LASER)

/obj/item/gun_component/barrel/laser/variable/assault
	weapon_type = GUN_ASSAULT

/obj/item/gun_component/barrel/laser/variable/smg
	weapon_type = GUN_SMG
	firemodes = list(
		list(mode_name="stun",                  caliber = CALIBER_LASER_TASER),
		list(mode_name="stun 3-round bursts",   caliber = CALIBER_LASER_SHOCK, burst=3, fire_delay = null, move_delay = 4, burst_accuracy=list(0,-1,-1), dispersion=list(0.0, 0.6, 1.0)),
		list(mode_name="lethal",                caliber = CALIBER_LASER_WEAK),
		list(mode_name="lethal 3-round bursts", caliber = CALIBER_LASER,       burst=3, fire_delay = null, move_delay = 4, burst_accuracy=list(0,-1,-1), dispersion=list(0.0, 0.6, 1.0)),
		)

/obj/item/gun_component/barrel/laser/variable/pulse
	weapon_type = GUN_SMG
	firemodes = list(
		list(mode_name="stun",    caliber = CALIBER_LASER_SHOCK, fire_delay = null),
		list(mode_name="lethal",  caliber = CALIBER_LASER,       fire_delay = null),
		list(mode_name="DESTROY", caliber = CALIBER_LASER_PULSE, fire_delay = 25),
		)