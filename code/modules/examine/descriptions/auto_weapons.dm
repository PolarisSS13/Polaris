/obj/item/weapon/proc/describe_weapon_force()
	switch(force)
		if(0)
			return "You wouldn't be able to hurt anyone if you attacked them with this."
		if(1 to 4)
			return "\A [src] would barely do any harm to someone if you hit someone with them."
		if(5)
			return "This would make a rather poor weapon."
		if (5 to 9)
			return "This [src] would make for a below average improvised weapon."
		if(10 to 14)
			return "This seems to be an average potential to harm someone."
		if(15 to 29)
			return "You'd be able to hurt someone pretty badly with this."
		if(30 to 49)
			return "This would make for a very effective weapon."
		if(50 to 80)
			return "This [src] is a very deadly weapon."
		if(81 to 100)
			return "You could do massive amounts of harm with this object."
		if(101 to INFINITY)
			return "You could kill someone in a few hits with this.  Truly, this weapon is extremely dangerous."



/obj/item/weapon/get_description_info()
	..()
	var/weapon_stats = description_info + "\
	<br>"

	weapon_stats += "[describe_weapon_force()] \n"

	switch(stagger)
		if(1 to 2)
			weapon_stats += "You could knock someone off balance with enough effort using this. \n"
		if(3 to 4)
			weapon_stats += "This can knock someone off their feet fairly well. \n"
		if(5 to 6)
			weapon_stats += "Foes are easily floored with this object. \n"

	if(sharp)
		weapon_stats += "This is sharp. \n"
	if(edge)
		weapon_stats += "This has a bladed edge. \n"

	return weapon_stats