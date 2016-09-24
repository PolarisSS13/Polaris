/obj/item/weapon/gun/energy/gun
	name = "energy gun"
	desc = "Another bestseller of Lawson Arms and the FTU, the LAEP90 Perun is a versatile energy based sidearm, capable of switching between low and high capacity projectile settings. In other words: Stun or Kill."
	icon_state = "energystun100"
	item_state = null	//so the human update icon uses the icon_state instead.
	fire_sound = 'sound/weapons/Taser.ogg'
	max_shots = 10
	fire_delay = 10 // Handguns should be inferior to two-handed weapons.
	slot_flags = SLOT_BELT|SLOT_HOLSTER

	projectile_type = /obj/item/projectile/beam/stun
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	modifystate = "energystun"

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun/weak, modifystate="energystun", fire_sound='sound/weapons/Taser.ogg'),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, modifystate="energykill", fire_sound='sound/weapons/Laser.ogg'),
		)

/obj/item/weapon/gun/energy/gun/mounted
	name = "mounted energy gun"
	self_recharge = 1
	use_external_power = 1


/obj/item/weapon/gun/energy/gun/burst
	name = "burst laser"
	desc = "The FM-2t is a versatile energy based weapon, capable of switching between stun or kill with a three round burst option for both settings."
	icon_state = "fm-2tstun100"
	item_state = null	//so the human update icon uses the icon_state instead.
	fire_sound = 'sound/weapons/Taser.ogg'
	max_shots = 18
	force = 8
	w_class = ITEMSIZE_NORMAL	//Same as SMGs
	fire_delay = 6
	slot_flags = SLOT_BELT

	projectile_type = /obj/item/projectile/beam/stun/weak
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 2, TECH_ILLEGAL = 3)
	modifystate = "fm-2tstun"

//	requires_two_hands = 1
	one_handed_penalty = 2

	firemodes = list(
		list(mode_name="stun", burst=1, projectile_type=/obj/item/projectile/beam/stun/weak, modifystate="fm-2tstun", fire_sound='sound/weapons/Taser.ogg'),
		list(mode_name="stun burst", burst=3, fire_delay=null, move_delay=4, burst_accuracy=list(0,0,0), dispersion=list(0.0, 0.2, 0.5), projectile_type=/obj/item/projectile/beam/stun/weak, modifystate="fm-2tstun", fire_sound='sound/weapons/Taser.ogg'),
		list(mode_name="lethal", burst=1, projectile_type=/obj/item/projectile/beam/burstlaser, modifystate="fm-2tkill", fire_sound='sound/weapons/Laser.ogg'),
		list(mode_name="lethal burst", burst=3, fire_delay=null, move_delay=4, burst_accuracy=list(0,0,0), dispersion=list(0.0, 0.2, 0.5), projectile_type=/obj/item/projectile/beam/burstlaser, modifystate="fm-2tkill", fire_sound='sound/weapons/Laser.ogg'),
		)

/obj/item/weapon/gun/energy/gun/nuclear
	name = "advanced energy gun"
	desc = "An energy gun with an experimental miniaturized reactor."
	icon_state = "nucgun"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_POWER = 3)
	slot_flags = SLOT_BELT
	force = 8 //looks heavier than a pistol
	w_class = ITEMSIZE_NORMAL	//Can't be bigger than the various SMGs
	fire_delay = 6	//This one's not a handgun, it should have the same fire delay as everything else
	self_recharge = 1
	modifystate = null

//	requires_two_hands = 1
	one_handed_penalty = 1 // It's rather bulky, so holding it in one hand is a little harder than with two, however it's not 'required'.

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, fire_sound='sound/weapons/Taser.ogg'),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, fire_sound='sound/weapons/Laser.ogg'),
		)

	var/lightfail = 0

//override for failcheck behaviour
/obj/item/weapon/gun/energy/gun/nuclear/process()
	charge_tick++
	if(charge_tick < 4) return 0
	charge_tick = 0
	if(!power_supply) return 0
	if((power_supply.charge / power_supply.maxcharge) != 1)
		power_supply.give(charge_cost)
		update_icon()
	return 1

/obj/item/weapon/gun/energy/gun/nuclear/proc/update_charge()
	var/ratio = power_supply.charge / power_supply.maxcharge
	ratio = round(ratio, 0.25) * 100
	overlays += "nucgun-[ratio]"

/obj/item/weapon/gun/energy/gun/nuclear/proc/update_reactor()
	if(lightfail)
		overlays += "nucgun-medium"
	else if ((power_supply.charge/power_supply.maxcharge) <= 0.5)
		overlays += "nucgun-light"
	else
		overlays += "nucgun-clean"

/obj/item/weapon/gun/energy/gun/nuclear/proc/update_mode()
	var/datum/firemode/current_mode = firemodes[sel_mode]
	switch(current_mode.name)
		if("stun") overlays += "nucgun-stun"
		if("lethal") overlays += "nucgun-kill"

/obj/item/weapon/gun/energy/gun/nuclear/update_icon()
	overlays.Cut()
	update_charge()
	update_reactor()
	update_mode()
