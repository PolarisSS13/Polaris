/*
*	Here is where any supply packs that may or may not be legal
*	  and require modification of the supply controller live.
*/


/datum/supply_pack/randomised/contraband
	num_contained = 5
	contains = list(
			/obj/item/seeds/bloodtomatoseed,
			/obj/item/weapon/storage/pill_bottle/zoom,
			/obj/item/weapon/storage/pill_bottle/ecstasy,
			/obj/item/weapon/reagent_containers/food/drinks/bottle/pwine
			)

	name = "Contraband crate"
	cost = 25
	containertype = /obj/structure/closet/crate
	containername = "Unlabeled crate"
	contraband = 1
	group = "Supplies"

/datum/supply_pack/security/specialops
	name = "Special Ops supplies"
	contains = list(
			/obj/item/weapon/storage/box/emps,
			/obj/item/weapon/grenade/smokebomb = 4,
			/obj/item/weapon/grenade/chem_grenade/incendiary
			)
	cost = 25
	containertype = /obj/structure/closet/crate
	containername = "Special Ops crate"
	contraband = 1
/*
/datum/supply_pack/supply/moghes
	name = "Moghes imports"
	contains = list(
			/obj/item/weapon/reagent_containers/food/drinks/bottle/redeemersbrew = 2,
			/obj/item/weapon/reagent_containers/food/snacks/unajerky = 4
			)
	cost = 25
	containertype = /obj/structure/closet/crate
	containername = "Moghes imports crate"
	contraband = 1
*/
/datum/supply_pack/munitions/bolt_rifles_militia
 	name = "Weapon - Surplus militia rifles"
 	contains = list(
 			/obj/item/weapon/gun/projectile/shotgun/pump/rifle = 3,
 			/obj/item/ammo_magazine/clip/c762 = 6
 			)
 	cost = 50
 	contraband = 1
 	containertype = /obj/structure/closet/crate/secure/weapon
 	containername = "Ballistic weapons crate"

/datum/supply_pack/randomised/misc/telecrate //you get something awesome, a couple of decent things, and a few weak/filler things
	name = "ERR_NULL_ENTRY" //null crate! also dream maker is hell,
	num_contained = 1
	contains = list(
			list( //drug hydroponicist
					/obj/item/seeds/chacruna = 2,
					/obj/item/seeds/caapi = 2,
					/obj/item/seeds/coca = 2,
					/obj/item/seeds/poppyseed = 2,
					/obj/machinery/portable_atmospherics/hydroponics{anchored = 0} = 3,
					/obj/item/weapon/reagent_containers/glass/bottle/ammonia = 2
					),
			list( //the infiltrator,
					/obj/item/weapon/gun/projectile/silenced,
					/obj/item/device/chameleon,
					/obj/item/weapon/storage/box/syndie_kit/chameleon,
					/obj/item/device/encryptionkey/syndicate,
					/obj/item/weapon/card/id/syndicate,
					/obj/item/clothing/mask/gas/voice
					),
			list( //the professional,
					/obj/item/weapon/gun/projectile/silenced,
					/obj/item/weapon/gun/energy/ionrifle/pistol,
					/obj/item/clothing/glasses/thermal/syndi,
					/obj/item/weapon/card/emag,
					/obj/item/ammo_magazine/m45/ap,
					/obj/item/weapon/material/knife/tacknife/combatknife,
					/obj/item/clothing/mask/balaclava
					),
			list( //poxball
					/obj/item/weapon/gun/energy/poxball/street = 2,
					/obj/item/clothing/suit/armor/poxball = 2,
					/obj/item/clothing/head/helmet/poxball = 2,
					/obj/item/clothing/shoes/leg_guard/poxball = 2,
					/obj/item/clothing/gloves/arm_guard/poxball = 2
					),
			list( //the operator,
					/obj/item/weapon/gun/projectile/shotgun/pump/combat,
					/obj/item/clothing/suit/storage/vest/heavy/merc,
					/obj/item/clothing/glasses/night,
					/obj/item/weapon/storage/box/anti_photons,
					/obj/item/ammo_magazine/clip/c12g/pellet,
					/obj/item/ammo_magazine/clip/c12g
					)
			)
	cost = 2500 //very expensive to curb abuse at the factory
	contraband = 1
	containertype = /obj/structure/largecrate/suspicious
	containername = "Suspicious crate"