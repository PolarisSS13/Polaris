/*
*	Here is where any supply packs
*	related to weapons live.
*/

/datum/supply_pack/munitions
	group = "Munitions"

/datum/supply_pack/randomised/munitions
	group = "Munitions"

/datum/supply_pack/munitions/weapons
	name = "Weapons - Security basic equipment"
	contains = list(
			/obj/item/device/flash = 2,
			/obj/item/reagent_containers/spray/pepper = 2,
			/obj/item/melee/baton/loaded = 2,
			/obj/item/gun/energy/taser = 2,
			/obj/item/gun/projectile/colt/detective = 2,
			/obj/item/storage/box/flashbangs = 2
			)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/lawson
	containername = "Security equipment crate"
	access = access_security

/datum/supply_pack/munitions/egunpistol
	name = "Weapons - Energy sidearms"
	contains = list(/obj/item/gun/energy/gun = 2)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/lawson
	containername = "Energy sidearms crate"
	access = access_security

/datum/supply_pack/munitions/flareguns
	name = "Weapons - Flare guns"
	contains = list(
			/obj/item/gun/projectile/sec/flash,
			/obj/item/ammo_magazine/m45/flash,
			/obj/item/gun/projectile/shotgun/doublebarrel/flare,
			/obj/item/storage/box/flashshells
			)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "Flare gun crate"
	access = access_security

/datum/supply_pack/munitions/eweapons
	name = "Weapons - Experimental weapons crate"
	contains = list(
			/obj/item/gun/energy/xray = 2,
			/obj/item/shield/energy = 2)
	cost = 100
	containertype = /obj/structure/closet/crate/secure/science
	containername = "Experimental weapons crate"
	access = access_armory

/datum/supply_pack/munitions/energyweapons
	name = "Weapons - Laser rifle crate"
	contains = list(/obj/item/gun/energy/laser = 3)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/heph
	containername = "Energy weapons crate"
	access = access_armory

/datum/supply_pack/munitions/shotgun
	name = "Weapons - Shotgun crate"
	contains = list(
			/obj/item/storage/box/shotgunammo,
			/obj/item/storage/box/shotgunshells,
			/obj/item/gun/projectile/shotgun/pump/combat = 2
			)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Shotgun crate"
	access = access_armory

/datum/supply_pack/munitions/erifle
	name = "Weapons - Energy marksman"
	contains = list(/obj/item/gun/energy/sniperrifle = 2)
	cost = 100
	containertype = /obj/structure/closet/crate/secure/heph
	containername = "Energy marksman crate"
	access = access_armory

/datum/supply_pack/munitions/burstlaser
	name = "Weapons - Burst laser"
	contains = list(/obj/item/gun/energy/gun/burst = 2)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/lawson
	containername = "Burst laser crate"
	access = access_armory

/datum/supply_pack/munitions/ionweapons
	name = "Weapons - Electromagnetic Rifles"
	contains = list(
			/obj/item/gun/energy/ionrifle = 2,
			/obj/item/storage/box/empslite
			)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/ward
	containername = "Electromagnetic weapons crate"
	access = access_armory

/datum/supply_pack/munitions/ionpistols
	name = "Weapons - Electromagnetic pistols"
	contains = list(
			/obj/item/gun/energy/ionrifle/pistol = 2,
			/obj/item/storage/box/empslite
			)
	cost = 30
	containertype = /obj/structure/closet/crate/secure/ward
	containername = "Electromagnetic weapons crate"
	access = access_armory

/datum/supply_pack/munitions/bsmg
	name = "Weapons - Ballistic SMGs"
	contains = list(/obj/item/gun/projectile/automatic/wt550 = 2)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/ward
	containername = "Ballistic weapon crate"
	access = access_armory

/datum/supply_pack/munitions/brifle
	name = "Weapons - Ballistic Rifles"
	contains = list(/obj/item/gun/projectile/automatic/z8 = 2)
	cost = 80
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Ballistic weapon crate"
	access = access_armory

/datum/supply_pack/munitions/bolt_rifles_competitive
 	name = "Weapons - Competitive shooting rifles"
 	contains = list(
 			/obj/item/device/assembly/timer,
 			/obj/item/gun/projectile/shotgun/pump/rifle/practice = 2,
 			/obj/item/ammo_magazine/clip/c762/practice = 4,
 			/obj/item/target = 2,
 			/obj/item/target/alien = 2,
 			/obj/item/target/syndicate = 2
 			)
 	cost = 40
 	containertype = /obj/structure/closet/crate/secure/weapon
 	containername = "Ballistic weapons crate"
 	access = access_security

/datum/supply_pack/munitions/caseless
	name = "Weapons - Prototype Caseless Rifle"
	contains = list(
			/obj/item/gun/projectile/caseless/prototype,
			/obj/item/ammo_magazine/m5mmcaseless = 3
			)
	cost = 60
	containertype = /obj/structure/closet/crate/secure/gilthari
	containername = "Caseless rifle crate"
	access = access_security

/datum/supply_pack/munitions/mrifle
	name = "Weapons - Magnetic Rifles"
	contains = list(/obj/item/gun/magnetic/railgun/heater = 2)
	cost = 120
	containertype = /obj/structure/closet/crate/secure/heph
	containername = "Magnetic weapon crate"
	access = access_armory

/datum/supply_pack/munitions/mpistol
	name = "Weapons - Magnetic Pistols"
	contains = list(/obj/item/gun/magnetic/railgun/heater/pistol = 2)
	cost = 200
	containertype = /obj/structure/closet/crate/secure/heph
	containername = "Magnetic weapon crate"
	access = access_armory

/datum/supply_pack/munitions/mcarbine
	name = "Weapons - Magnetic Carbines"
	contains = list(/obj/item/gun/magnetic/railgun/flechette/sif = 2)
	cost = 130
	containertype = /obj/structure/closet/crate/secure/lawson
	containername = "Magnetic weapon crate"
	access = access_security

/datum/supply_pack/munitions/mshells
	name = "Weapons - Magnetic Shells"
	contains = list(/obj/item/magnetic_ammo = 3)
	cost = 100
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Magnetic ammunition crate"
	access = access_security

/datum/supply_pack/munitions/shotgunammo
	name = "Ammunition - Shotgun shells"
	contains = list(
			/obj/item/storage/box/shotgunammo = 2,
			/obj/item/storage/box/shotgunshells = 2
			)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Ballistic ammunition crate"
	access = access_armory

/datum/supply_pack/munitions/beanbagammo
	name = "Ammunition - Beanbag shells"
	contains = list(/obj/item/storage/box/beanbags = 3)
	cost = 25
	containertype = /obj/structure/closet/crate
	containername = "Ballistic ammunition crate"
	access = null

/datum/supply_pack/munitions/bsmgammo
	name = "Ammunition - 9mm top mounted lethal"
	contains = list(/obj/item/ammo_magazine/m9mmt = 6)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Ballistic ammunition crate"
	access = access_armory

/datum/supply_pack/munitions/bsmgammorubber
	name = "Ammunition - 9mm top mounted rubber"
	contains = list(/obj/item/ammo_magazine/m9mmt/rubber = 6)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Ballistic ammunition crate"
	access = access_security

/datum/supply_pack/munitions/brifleammo
	name = "Ammunition - 7.62mm lethal"
	contains = list(/obj/item/ammo_magazine/m762 = 6)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Ballistic ammunition crate"
	access = access_armory

/datum/supply_pack/munitions/pcellammo
	name = "Ammunition - Power cell"
	contains = list(/obj/item/cell/device/weapon = 3)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Energy ammunition crate"
	access = access_security