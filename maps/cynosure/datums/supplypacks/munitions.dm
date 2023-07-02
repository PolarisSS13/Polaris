/*
*	Here is where any supply packs
*	related to sc weapons live.
*/

/datum/supply_pack/munitions/bolt_rifles_explorer
 	name = "Weapons - Surplus Hunting Rifles"
 	contains = list(
 			/obj/item/gun/projectile/shotgun/pump/rifle = 2,
 			/obj/item/ammo_magazine/clip/c762/hunter = 6
 			)
 	cost = 50
 	containertype = /obj/structure/closet/crate/secure/hedberg
 	containername = "Hunting Rifle crate"
 	access = access_explorer

/datum/supply_pack/munitions/phase_carbines_explorer
 	name = "Weapons - Surplus Phase Carbines"
 	contains = list(
 			/obj/item/gun/energy/phasegun = 2,
 			)
 	cost = 25
 	containertype = /obj/structure/closet/crate/secure/ward
 	containername = "Phase Carbine crate"
 	access = access_explorer

/datum/supply_pack/munitions/phase_rifles_explorer
 	name = "Weapons - Phase Rifles"
 	contains = list(
 			/obj/item/gun/energy/phasegun/rifle = 2,
 			)
 	cost = 50
 	containertype = /obj/structure/closet/crate/secure/ward
 	containername = "Phase Rifle crate"
 	access = access_explorer

/datum/supply_pack/munitions/tranq_pistols_xenofauna
 	name = "Weapons - Surplus Tranquilizer Pistols"
 	contains = list(
		/obj/item/gun/energy/phasegun/tranq_pistol = 2,
	)
 	cost = 25
 	containertype = /obj/structure/closet/crate/secure/ward
 	containername = "tranquilizer pistol crate"
 	access = access_xenofauna

/datum/supply_pack/munitions/tranq_rifles_xenofauna
 	name = "Weapons - Surplus Tranquilizer Rifles"
 	contains = list(
		/obj/item/gun/energy/phasegun/tranq_rifle = 2,
	)
 	cost = 50
 	containertype = /obj/structure/closet/crate/secure/ward
 	containername = "tranquilizer rifle crate"
 	access = access_xenofauna
