/***************************************
* Highly Visible and Dangerous Weapons *
***************************************/
/datum/uplink_item/item/visible_weapons
	category = /datum/uplink_category/visible_weapons

/datum/uplink_item/item/visible_weapons/ranged
	new_args = list(TRUE)

/datum/uplink_item/item/visible_weapons/tactknife
	name = "Tactical Knife"
	item_cost = 10
	path = /obj/item/weapon/material/hatchet/tacknife

/datum/uplink_item/item/visible_weapons/combatknife
	name = "Combat Knife"
	item_cost = 20
	path = /obj/item/weapon/material/hatchet/tacknife/combatknife

/datum/uplink_item/item/visible_weapons/energy_sword
	name = "Energy Sword"
	item_cost = 40
	path = /obj/item/weapon/melee/energy/sword

/datum/uplink_item/item/visible_weapons/riggedlaser
	name = "Exosuit Rigged Laser"
	item_cost = 60
	path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/riggedlaser

/datum/uplink_item/item/visible_weapons/ranged/dartgun
	name = "Dart Gun"
	item_cost = 30
	path = /obj/item/weapon/gun/projectile/dartgun

/datum/uplink_item/item/visible_weapons/ranged/crossbow
	name = "Energy Crossbow"
	item_cost = 40
	path = /obj/item/weapon/gun/energy/crossbow

/datum/uplink_item/item/visible_weapons/ranged/silenced_45
	name = "Silenced .45"
	item_cost = 40
	path = /obj/item/weapon/gun/projectile/silenced

/datum/uplink_item/item/visible_weapons/ranged/Derringer
	name = ".357 Derringer Pistol"
	item_cost = 40
	path = /obj/item/weapon/gun/projectile/derringer

/datum/uplink_item/item/visible_weapons/ranged/ionrifle
	name = "Ion Rifle"
	item_cost = 40
	path = /obj/item/weapon/gun/energy/ionrifle

/datum/uplink_item/item/visible_weapons/ranged/tommygun
	name = "Tommygun (.45)" // We're keeping this because it's CLASSY. -Spades
	item_cost = 60
	path = /obj/item/weapon/gun/projectile/automatic/tommygun

//These are for traitors (or other antags, perhaps) to have the option of purchasing some merc gear.
/datum/uplink_item/item/visible_weapons/ranged/submachinegun
	name = "Submachine Gun (10mm)"
	item_cost = 60
	path = /obj/item/weapon/gun/projectile/automatic/c20r

/datum/uplink_item/item/visible_weapons/ranged/egun
	name = "Energy Gun"
	item_cost = 60
	path = /obj/item/weapon/gun/energy/gun

/datum/uplink_item/item/visible_weapons/ranged/lasercannon
	name = "Laser Cannon"
	item_cost = 60
	path = /obj/item/weapon/gun/energy/lasercannon

/datum/uplink_item/item/visible_weapons/ranged/assaultrifle
	name = "Assault Rifle (7.62mm)"
	item_cost = 75
	path = /obj/item/weapon/gun/projectile/automatic/sts35

/*/datum/uplink_item/item/visible_weapons/bullpuprifle
	name = "Assault Rifle (5.56mm)"
	item_cost = 7
	path = /obj/item/weapon/gun/projectile/automatic/carbine
*/
/datum/uplink_item/item/visible_weapons/ranged/combatshotgun
	name = "Combat Shotgun"
	item_cost = 75
	path = /obj/item/weapon/gun/projectile/shotgun/pump/combat

/datum/uplink_item/item/visible_weapons/lasercarbine
	name = "Laser Carbine"
	item_cost = 75
	path = /obj/item/weapon/gun/energy/laser

/datum/uplink_item/item/visible_weapons/ranged/revolver
	name = "Revolver"
	item_cost = 70
	path = /obj/item/weapon/gun/projectile/revolver

/datum/uplink_item/item/visible_weapons/ranged/xray
	name = "Xray Gun"
	item_cost = 85
	path = /obj/item/weapon/gun/energy/xray

/datum/uplink_item/item/visible_weapons/ranged/heavysniper
	name = "Anti-Materiel Rifle (14.5mm)"
	item_cost = DEFAULT_TELECRYSTAL_AMOUNT
	path = /obj/item/weapon/gun/projectile/heavysniper