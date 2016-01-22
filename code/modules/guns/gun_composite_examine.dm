/obj/item/weapon/gun/composite/description_fluff = null
/obj/item/weapon/gun/composite/description_info =  null
/obj/item/weapon/gun/composite/description_antag = null

/obj/item/weapon/gun/composite/examine()
	..()

	if(usr && usr.Adjacent(get_turf(src)))
		if(dam_type == GUN_TYPE_LASER)
			usr << "This one is \a [caliber] projector."
		else
			usr << "This one fires [caliber] rounds."
		usr << "It has [chamber.get_shots_remaining()] shots remaining."

		if(accessories.len)
			var/accessory_list = list()
			for(var/obj/item/acc in accessories)
				accessory_list += "\a [acc.name]"
			usr << "[english_list(accessories)] [accessories.len == 1 ? "is" : "are"] installed."

/obj/item/weapon/gun/composite/get_description_info()
	var/result = ""

	if(model && model.produced_by)
		result += "This weapon has the following manufacturer-specific modifiers:"
		result += "<table>"
		if(!isnull(model.produced_by.accuracy))   result += "<tr><td>Accuracy:</td><td>[model.produced_by.accuracy >= 1 ? "+" : ""][(model.produced_by.accuracy*100)-100]%</td></tr>"
		if(!isnull(model.produced_by.capacity))   result += "<tr><td>Ammo capacity:</td><td>[model.produced_by.capacity >= 1 ? "+" : ""][(model.produced_by.capacity*100)-100]%</td></tr>"
		if(!isnull(model.produced_by.damage_mod)) result += "<tr><td>Damage modifier:</td><td>[model.produced_by.damage_mod >= 1 ? "+" : ""][(model.produced_by.damage_mod*100)-100]%</td></tr>"
		if(!isnull(model.produced_by.recoil))     result += "<tr><td>Recoil reduction:</td><td>[model.produced_by.recoil >= 1 ? "+" : ""][(model.produced_by.recoil*100)-100]%</td></tr>"
		if(!isnull(model.produced_by.fire_rate))  result += "<tr><td>Fire delay:</td><td>[model.produced_by.fire_rate >= 1 ? "+" : ""][(model.produced_by.fire_rate*100)-100]%</td></tr>"
		result += "</table>"
	else
		result += "<br>This weapon has no manufacturer-specific modifiers. "
	result += "<br><br>"


	var/fdelay = fire_delay/10
	result += "It has a fire delay of [fdelay] second[fdelay==1 ? "" : "s"].<br>"
	result += "It can hold a maximum of [max_shots] shot[max_shots==1 ? "" : "s"].<br>"
	result += "<br>"

	if(dam_type == GUN_TYPE_LASER)
		result += "This weapon is an energy weapon; they run on battery charge rather than traditional ammunition. You can recharge \
			an energy weapon by placing it in a wall-mounted or table-mounted charger, such as those found in Security or around the \
			station. Additionally, most energy weapons can go straight through windows and hit whatever is on the other side, and are \
			hitscan, making them accurate and useful against distant targets."
	else
		result += "This weapon is a ballistic weapon; it fires solid shots using a magazine or loaded rounds of ammunition. You can \
			unload it by holding it and clicking it with an empty hand, and reload it by clicking it with a magazine, or in the case of \
			shotguns or some rifles, by opening the breech and clicking it with individual rounds."

	if(firemodes.len)
		result += "<br><br>This weapon has multiple fire modes, which can be changed by clicking the gun in-hand."

	result += "<br><br>This weapon can have accessories removed, or be field-stripped into its component parts, by using a pen, screwdriver, \
		or other small, edged object on it (such as forks)."

	return result

/obj/item/weapon/gun/composite/get_description_fluff()
	var/result = ""
	if(model && model.produced_by)
		result += "This weapon was manufacured by [model.produced_by.manufacturer_name]. [model.produced_by.manufacturer_description]<br><br>"
	else
		result += "This weapon is a custom-built aftermarket job with no single manufacturer or model.<br><br>"

	if(dam_type == GUN_TYPE_LASER)
		result += "A <b>C</b>oherent <b>R</b>adiation <b>E</b>mission <b>W</b>eapon, or C.R.E.W, uses pulses of \
			'hard light' to burn, damage or disrupt the target, or simply mark them for the purposes of laser tag \
			or practice. They are extremely popular amongst spacebound peacekeepers, security officers and bounty \
			hunters due to the lack of risk from ricochets or penetrating shots destroying the hull or injuring \
			bystanders."
	else
		result += "Ballistic weapons are very popular even in the 2550's due to the relative expense of decent laser \
			weapons, difficulties in maintaining them, and the sheer stopping and wounding power of solid slugs or \
			composite shot. Using a ballistic weapon on a spacebound habitat is usually considered a serious undertaking, \
			as a missed shot or careless use of automatic fire could rip open the hull or injure bystanders with ease."
	return result

// TODO.
/obj/item/weapon/gun/composite/get_description_antag()
	var/result = description_antag
	return result
