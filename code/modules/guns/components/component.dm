var/list/gun_component_icon_cache = list()

/obj/item/gun_component
	name = "gun component"
	desc = "A mysterious gun component."
	icon = 'icons/obj/gun_components/unbranded.dmi'

	var/weapon_type = GUN_PISTOL             // What kind of weapon does this fit into?
	var/component_type = COMPONENT_BARREL    // What part of the gun is this?
	var/projectile_type = GUN_TYPE_BALLISTIC // What is this component designed to help fire?
	var/obj/item/weapon/gun/composite/holder // Reference to composite gun that this is part of.
	var/decl/weapon_model/model              // Does this component have a particular model/manufacturer?
	var/accepts_accessories                  // Can this component have accessories installed?

	var/has_user_interaction                 // Can this component be interacted with via gun attack_self()?
	var/has_alt_interaction                  // Can this component be interacted with via gun AltClick()?

/obj/item/gun_component/New(var/newloc, var/weapontype, var/componenttype, var/use_model)
	..(newloc)
	if(weapontype)    weapon_type = weapontype
	if(componenttype) component_type = componenttype
	if(use_model)
		model = get_gun_model_by_path(use_model)
	update_icon()
	update_strings()

/obj/item/gun_component/update_icon()
	..()
	if(model)
		icon = model.use_icon
		icon_state = component_type
	else
		icon = initial(icon)
		if(weapon_type)
			if(projectile_type)
				icon_state = "[projectile_type]_[weapon_type]_[component_type]"
			else
				icon_state = "[weapon_type]_[component_type]"
		else
			if(projectile_type)
				icon_state = "[projectile_type]_[component_type]"
			else
				icon_state = "[component_type]"

/obj/item/gun_component/proc/empty()
	for(var/obj/item/I in contents)
		I.forceMove(get_turf(src))

/obj/item/gun_component/proc/update_strings()
	if(model)
		name = "[get_gun_name(src, projectile_type, weapon_type)] [initial(name)]"
	else
		name = "[initial(name)]"

	if(model)
		desc = "The casing is stamped with '[model.model_name]'. [initial(desc)] This one seems like it was produced by [model.produced_by.manufacturer_name]."
	else
		desc = "[initial(desc)]"

/obj/item/gun_component/attackby(var/obj/item/thing, var/mob/user)
	if(istype(thing, /obj/item/weapon/gun_assembly))
		var/obj/item/weapon/gun_assembly/GA = thing
		GA.attackby(src, user)
		return
	return ..()


/obj/item/gun_component/proc/installed()
	return

/obj/item/gun_component/proc/do_user_interaction(var/mob/user)
	return

/obj/item/gun_component/proc/do_user_alt_interaction(var/mob/user)
	return
