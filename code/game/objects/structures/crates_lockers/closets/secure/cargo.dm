/obj/structure/closet/secure_closet/cargotech
	name = "cargo technician's locker"
	req_access = list(access_cargo)
	closet_appearance = /decl/closet_appearance/secure_closet/cargo

	starts_with = list(
		/obj/item/clothing/under/rank/cargotech,
		/obj/item/clothing/suit/storage/hooded/wintercoat/cargo,
		/obj/item/clothing/shoes/boots/winter/supply,
		/obj/item/clothing/shoes/black,
		/obj/item/radio/headset/headset_cargo,
		/obj/item/radio/headset/headset_cargo/alt,
		/obj/item/clothing/gloves/duty,
		/obj/item/clothing/gloves/fingerless,
		/obj/item/clothing/head/soft,
		/obj/item/clothing/accessory/storage/poncho/roles/cloak/cargo
	)

/obj/structure/closet/secure_closet/cargotech/Initialize()
	if(prob(75))
		starts_with += /obj/item/storage/backpack
	else
		starts_with += /obj/item/storage/backpack/satchel/norm
	if(prob(25))
		starts_with += /obj/item/storage/backpack/dufflebag
	return ..()

/obj/structure/closet/secure_closet/quartermaster
	name = "quartermaster's locker"
	req_access = list(access_qm)
	closet_appearance = /decl/closet_appearance/secure_closet/cargo/qm

	starts_with = list(
		/obj/item/clothing/under/rank/cargo,
		/obj/item/clothing/shoes/brown,
		/obj/item/radio/headset/headset_cargo,
		/obj/item/radio/headset/headset_cargo/alt,
		/obj/item/clothing/gloves/duty,
		/obj/item/clothing/gloves/fingerless,
		/obj/item/clothing/suit/fire,
		/obj/item/tank/emergency/oxygen,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/glasses/meson,
		/obj/item/clothing/head/soft,
		/obj/item/clothing/suit/storage/hooded/wintercoat/cargo,
		/obj/item/clothing/suit/storage/hooded/wintercoat/cargo/qm,
		/obj/item/clothing/shoes/boots/winter/supply,
		/obj/item/clothing/accessory/storage/poncho/roles/cloak/cargo
	)

/obj/structure/closet/secure_closet/quartermaster/Initialize()
	if(prob(75))
		starts_with += /obj/item/storage/backpack
	else
		starts_with += /obj/item/storage/backpack/satchel/norm
	if(prob(25))
		starts_with += /obj/item/storage/backpack/dufflebag
	return ..()

/obj/structure/closet/secure_closet/miner
	name = "miner's equipment"
	req_access = list(access_mining)
	closet_appearance = /decl/closet_appearance/secure_closet/mining

	starts_with = list(
		/obj/item/radio/headset/headset_mine,
		/obj/item/clothing/under/rank/miner,
		/obj/item/clothing/accessory/storage/overalls,
		/obj/item/clothing/gloves/duty,
		/obj/item/clothing/shoes/black,
		/obj/item/analyzer,
		/obj/item/storage/bag/ore,
		/obj/item/flashlight/lantern,
		/obj/item/shovel,
		/obj/item/pickaxe,
		/obj/item/clothing/glasses/material,
		/obj/item/clothing/suit/storage/hooded/wintercoat/miner,
		/obj/item/clothing/shoes/boots/winter/mining,
		/obj/item/stack/marker_beacon/thirty,
		/obj/item/clothing/accessory/storage/poncho/roles/cloak/mining
	)

/obj/structure/closet/secure_closet/miner/Initialize()
	if(prob(50))
		starts_with += /obj/item/storage/backpack/industrial
	else
		starts_with += /obj/item/storage/backpack/satchel/eng
	return ..()
