/*
*	Here is where any supply packs
*	related to civilian tasks live
*/

/datum/supply_pack/supply
	group = "Supplies"

/datum/supply_pack/supply/food
	name = "Kitchen supply crate"
	contains = list(
			/obj/item/reagent_containers/food/condiment/flour = 6,
			/obj/item/reagent_containers/food/drinks/milk = 3,
			/obj/item/reagent_containers/food/drinks/soymilk = 2,
			/obj/item/storage/fancy/egg_box = 2,
			/obj/item/reagent_containers/food/snacks/tofu = 4,
			/obj/item/reagent_containers/food/snacks/meat = 4,
			/obj/item/reagent_containers/food/condiment/yeast = 3
			)
	cost = 10
	containertype = /obj/structure/closet/crate/freezer/centauri
	containername = "Food crate"

/datum/supply_pack/supply/toner
	name = "Toner cartridges"
	contains = list(/obj/item/device/toner = 6)
	cost = 10
	containertype = /obj/structure/closet/crate/ummarcar
	containername = "Toner cartridges"

/datum/supply_pack/supply/janitor
	name = "Janitorial supplies"
	contains = list(
			/obj/item/reagent_containers/glass/bucket,
			/obj/item/mop,
			/obj/item/clothing/under/rank/janitor,
			/obj/item/cartridge/janitor,
			/obj/item/clothing/gloves/black,
			/obj/item/clothing/head/soft/purple,
			/obj/item/storage/belt/janitor,
			/obj/item/clothing/shoes/galoshes,
			/obj/item/clothing/suit/caution = 4,
			/obj/item/storage/bag/trash,
			/obj/item/device/lightreplacer,
			/obj/item/reagent_containers/spray/cleaner,
			/obj/item/reagent_containers/glass/rag,
			/obj/item/grenade/chem_grenade/cleaner = 3,
			/obj/structure/mopbucket
			)
	cost = 10
	containertype = /obj/structure/closet/crate/galaksi
	containername = "Janitorial supplies"

/datum/supply_pack/supply/shipping
	name = "Shipping supplies"
	contains = list(
				/obj/fiftyspawner/cardboard,
				/obj/item/packageWrap = 4,
				/obj/item/wrapping_paper = 2,
				/obj/item/device/destTagger,
				/obj/item/hand_labeler,
				/obj/item/tool/wirecutters,
				/obj/item/tape_roll = 2)
	cost = 10
	containertype = /obj/structure/closet/crate/ummarcar
	containername = "Shipping supplies crate"

/datum/supply_pack/supply/bureaucracy
	contains = list(
			/obj/item/clipboard = 2,
			/obj/item/pen/red,
			/obj/item/pen/blue,
			/obj/item/pen/blue,
			/obj/item/device/camera_film,
			/obj/item/folder/blue,
			/obj/item/folder/red,
			/obj/item/folder/yellow,
			/obj/item/hand_labeler,
			/obj/item/tape_roll,
			/obj/structure/filingcabinet/chestdrawer{anchored = 0},
			/obj/item/paper_bin
			)
	name = "Office supplies"
	cost = 15
	containertype = /obj/structure/closet/crate/ummarcar
	containername = "Office supplies crate"

/datum/supply_pack/supply/sticky_notes
	name = "Stationery - sticky notes (50)"
	contains = list(/obj/item/sticky_pad/random)
	cost = 10
	containertype = /obj/structure/closet/crate/ummarcar
	containername = "\improper Sticky notes crate"

/datum/supply_pack/supply/spare_pda
	name = "Spare PDAs"
	cost = 10
	containertype = /obj/structure/closet/crate/thinktronic
	containername = "Spare PDA crate"
	contains = list(/obj/item/device/pda = 3)

/datum/supply_pack/supply/minergear
	name = "Shaft miner equipment"
	contains = list(
			/obj/item/storage/backpack/industrial,
			/obj/item/storage/backpack/satchel/eng,
			/obj/item/clothing/suit/storage/hooded/wintercoat/miner,
			/obj/item/device/radio/headset/headset_cargo,
			/obj/item/clothing/under/rank/miner,
			/obj/item/clothing/gloves/black,
			/obj/item/clothing/shoes/black,
			/obj/item/device/analyzer,
			/obj/item/storage/bag/ore,
			/obj/item/device/flashlight/lantern,
			/obj/item/shovel,
			/obj/item/pickaxe,
			/obj/item/mining_scanner,
			/obj/item/clothing/glasses/material,
			/obj/item/clothing/glasses/meson
			)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/xion
	containername = "Shaft miner equipment"
	access = access_mining

/datum/supply_pack/supply/mule
	name = "Mulebot Crate"
	contains = list()
	cost = 20
	containertype = /obj/structure/largecrate/animal/mulebot
	containername = "Mulebot Crate"

/datum/supply_pack/supply/cargotrain
	name = "Cargo Train Tug"
	contains = list(/obj/vehicle/train/engine)
	cost = 35
	containertype = /obj/structure/closet/crate/large/xion
	containername = "Cargo Train Tug Crate"

/datum/supply_pack/supply/cargotrailer
	name = "Cargo Train Trolley"
	contains = list(/obj/vehicle/train/trolley)
	cost = 15
	containertype = /obj/structure/closet/crate/large/xion
	containername = "Cargo Train Trolley Crate"