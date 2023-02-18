/obj/item/mech_equipment/mounted_system/projectile/attackby(var/obj/item/O, var/mob/user)
	var/obj/item/gun/projectile/automatic/A = holding
	if(!istype(A))
		return
	if(O.has_tool_quality(TOOL_CROWBAR))
		A.unload_ammo(user)
		to_chat(user, SPAN_NOTICE("You remove the ammo magazine from the [src]."))
	else if(istype(O, A.magazine_type))
		A.load_ammo(O, user)
		to_chat(user, SPAN_NOTICE("You load the ammo magazine into the [src]."))

/obj/item/mech_equipment/mounted_system/projectile/attack_self(var/mob/user)
	. = ..()
	if(. && holding)
		var/obj/item/gun/M = holding
		return M.switch_firemodes(user)

/obj/item/gun/projectile/automatic/get_hardpoint_status_value()
	if(!isnull(ammo_magazine))
		return ammo_magazine.stored_ammo.len

/obj/item/gun/projectile/automatic/get_hardpoint_maptext()
	if(!isnull(ammo_magazine))
		return "[ammo_magazine.stored_ammo.len]/[ammo_magazine.max_ammo]"
	return 0

//Weapons below this.
/obj/item/mech_equipment/mounted_system/projectile
	name = "mounted submachine gun"
	icon_state = "mech_ballistic"
	holding_type = /obj/item/gun/projectile/automatic/advanced_smg/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_WEAPONS)
	origin_tech = list(TECH_DATA = 4, TECH_COMBAT = 6, TECH_ENGINEERING = 5)

/obj/item/gun/projectile/automatic/advanced_smg/mech
	caliber = "9mm"
	one_handed_penalty = FALSE
	magazine_type = /obj/item/ammo_magazine/mech/smg_top
	allowed_magazines = list(/obj/item/ammo_magazine/mech/smg_top)

	firemodes = list(
		list(mode_name="semi auto",      burst=1, fire_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 1.6, 2.4, 2.4), autofire_enabled=0),
		list(mode_name="short bursts",   burst=5, fire_delay=null, burst_accuracy=list(0,-1,-1,-1,-2), dispersion=list(1.6, 1.6, 2.0, 2.0, 2.4), autofire_enabled=0),
		list(mode_name="full auto",      burst=1, fire_delay=null, burst_delay=1,                      burst_accuracy=list(0,-1,-1,-1,-2), dispersion=list(1.6, 1.6, 2.0, 2.0, 2.4), autofire_enabled=1)
	)

/obj/item/mech_equipment/mounted_system/projectile/assault_rifle
	name = "mounted assault rifle"
	icon_state = "mech_ballistic2"
	holding_type = /obj/item/gun/projectile/automatic/sts35/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_WEAPONS)
	origin_tech = list(TECH_DATA = 4, TECH_COMBAT = 8, TECH_ENGINEERING = 6)

/obj/item/gun/projectile/automatic/sts35/mech
	caliber = "5.45mm"
	magazine_type = /obj/item/ammo_magazine/mech/rifle
	allowed_magazines = list(/obj/item/ammo_magazine/mech/rifle)

	firemodes = list(
		list(mode_name="semi auto",      burst=1,    fire_delay=null,  burst_accuracy=null,            dispersion=null, autofire_enabled=0),
		list(mode_name="3-round bursts", burst=3,    fire_delay=null,  burst_accuracy=list(0,-1,-1),   dispersion=list(0.0, 0.6, 1.0), autofire_enabled=0),
		list(mode_name="full auto",      burst=1,    fire_delay=null, burst_delay=1,                   burst_accuracy = list(0,-1,-1), dispersion=list(0.0, 0.6, 1.0), autofire_enabled=1)
	)

/obj/item/mech_equipment/mounted_system/projectile/machine
	name = "mounted machine gun"
	icon_state = "mech_machine_gun"
	holding_type = /obj/item/gun/projectile/automatic/l6_saw/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_WEAPONS)

/obj/item/gun/projectile/automatic/l6_saw/mech
	caliber = "5.45mm"
	one_handed_penalty = FALSE
	magazine_type = /obj/item/ammo_magazine/mech/rifle/drum
	allowed_magazines = list(/obj/item/ammo_magazine/mech/rifle/drum)

// Magazines below this.

/obj/item/ammo_magazine/mech
	icon_state = "ashot-mag"
	desc = "A large magazine for a mech's gun. Looks way too big for a normal gun."

/obj/item/ammo_magazine/mech/attack_self(mob/user)
	to_chat(user, SPAN_WARNING("It's pretty hard to extract ammo from a magazine that fits on a mech. You'll have to do it one round at a time."))
	return

/obj/item/ammo_magazine/mech/smg_top
	name = "large 7mm magazine"
	ammo_type = /obj/item/ammo_casing/a9mm
	caliber = "9mm"
	max_ammo = 90

/obj/item/ammo_magazine/mech/rifle
	name = "large assault rifle magazine"
	caliber = "5.45mm"
	icon_state = "m545"
	ammo_type = /obj/item/ammo_casing/a545
	max_ammo = 100

/obj/item/ammo_magazine/mech/rifle/drum
	name = "large machine gun magazine"
	caliber = "5.45mm"
	icon_state = "a545"
	ammo_type = /obj/item/ammo_casing/a545
	max_ammo = 300
/*
// Handling for auto-fire mechanic
/mob/living/exosuit/can_autofire(obj/item/gun/autofiring, atom/autofiring_at)
	if(autofiring.autofiring_by != src)
		return FALSE
	var/client/C = current_user ? current_user.client : client

	if(!C || !C.mob || C.mob.incapacitated())
		return FALSE

	if(!(autofiring_at in view(C.view, src)))
		return FALSE
	if(!(get_dir(src, autofiring_at) & dir))
		return FALSE
	if(!(autofiring in selected_system)) // Make sure the gun is still selected.
		return FALSE
	return TRUE

/obj/item/mech_equipment/mounted_system/projectile/MouseDownInteraction(atom/object, location, control, params, mob/user)
	var/obj/item/gun/gun = holding
	if(istype(object) && (isturf(object) || isturf(object.loc)) && istype(gun))
		if(user != src)
			if(!user.incapacitated())
				gun.set_autofire(object, owner, FALSE) // Passed gun-firer is still the exosuit since all checks need to be done on the suit.
				owner.current_user = user
		else
			if(!owner.incapacitated())
				gun.set_autofire(object, owner, FALSE)
				owner.current_user = null

/obj/item/mech_equipment/mounted_system/projectile/MouseUpInteraction(atom/object, location, control, params, mob/user)
	var/obj/item/gun/gun = holding
	if(istype(gun))
		gun.clear_autofire()
	if(owner) // In case the owning exosuit has been gibbed etc.
		owner.current_user = null

/obj/item/mech_equipment/mounted_system/projectile/MouseDragInteraction(atom/src_object, atom/over_object, src_location, over_location, src_control, over_control, params, mob/user)
	var/obj/item/gun/gun = holding
	if(!owner)
		gun?.clear_autofire()
		return
	if(!istype(gun))
		owner?.current_user = null
		return
	if(istype(over_object) && (isturf(over_object) || isturf(over_object.loc)))
		if(user.incapacitated() || (user != owner && user != owner.current_user))
			gun.clear_autofire()
			return
		gun.set_autofire(over_object, owner, FALSE)
		return

	gun.clear_autofire()
*/
