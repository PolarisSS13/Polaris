/decl/hierarchy/outfit/job/cargo
	l_ear = /obj/item/radio/headset/headset_cargo
	hierarchy_type = /decl/hierarchy/outfit/job/cargo

/decl/hierarchy/outfit/job/cargo/qm
	name = OUTFIT_JOB_NAME("Cargo")
	uniform = /obj/item/clothing/under/rank/cargo/jeans
	shoes = /obj/item/clothing/shoes/brown
	glasses = /obj/item/clothing/glasses/sunglasses
	id_type = /obj/item/card/id/cargo/head
	pda_type = /obj/item/pda/quartermaster

/decl/hierarchy/outfit/job/cargo/cargo_tech
	name = OUTFIT_JOB_NAME("Cargo technician")
	uniform = /obj/item/clothing/under/rank/cargotech/jeans
	id_type = /obj/item/card/id/cargo
	pda_type = /obj/item/pda/cargo

/decl/hierarchy/outfit/job/cargo/pilot
	name = OUTFIT_JOB_NAME("Delivery Pilot")
	shoes = /obj/item/clothing/shoes/black
	uniform = /obj/item/clothing/under/rank/cargotech/jeans
	suit = /obj/item/clothing/suit/storage/toggle/bomber
	gloves = /obj/item/clothing/gloves/fingerless
	glasses = /obj/item/clothing/glasses/fakesunglasses/aviator
	id_slot = slot_wear_id
	pda_slot = slot_belt
	pda_type = /obj/item/pda/cargo // Brown looks more rugged
	id_type = /obj/item/card/id/cargo
	id_pda_assignment = "Delivery Pilot"
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_COMPREHENSIVE_SURVIVAL
