/obj/item/robot_parts/robot_component/armour/exosuit
	name = "exosuit armour plating"
	armor = list(
		melee = 70,
		bullet = 30,
		laser = 40,
		energy = 10,
		bomb = 30,
		bio = 100,
		rad = 20
		)
	origin_tech = list(TECH_MATERIAL = 1)

/obj/item/robot_parts/robot_component/armour/exosuit/radproof
	name = "radiation-proof armour plating"
	desc = "A fully enclosed radiation hardened shell designed to protect the pilot from radiation"
	armor = list(
		melee = 70,
		bullet = 30,
		laser = 40,
		energy = 10,
		bomb = 30,
		bio = 100,
		rad = 100
		)
	origin_tech = list(TECH_MATERIAL = 3)

/obj/item/robot_parts/robot_component/armour/exosuit/em
	name = "EM-shielded armour plating"
	desc = "A shielded plating that surrounds the eletronics and protects them from electromagnetic radiation"
	armor = list(
		melee =70,
		bullet = 25,
		laser = 25,
		energy = 100,
		bomb = 10,
		bio = 100,
		rad = 20
		)
	origin_tech = list(TECH_MATERIAL = 3)

/obj/item/robot_parts/robot_component/armour/exosuit/combat
	name = "heavy combat plating"
	desc = "Plating designed to deflect incoming attacks and explosions"
	armor = list(
		melee = 70,
		bullet = 60,
		laser = 70,
		energy = 10,
		bomb = 60,
		bio = 100,
		rad = 20
		)
	origin_tech = list(TECH_MATERIAL = 5)
