/decl/hierarchy/outfit/job/engineering
	hierarchy_type = /decl/hierarchy/outfit/job/engineering
	l_ear = /obj/item/radio/headset/headset_eng
	shoes = /obj/item/clothing/shoes/boots/workboots
	r_pocket = /obj/item/t_scanner
	backpack = /obj/item/storage/backpack/industrial
	satchel_one = /obj/item/storage/backpack/satchel/eng
	messenger_bag = /obj/item/storage/backpack/messenger/engi
	pda_slot = slot_l_store
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

/decl/hierarchy/outfit/job/engineering/chief_engineer
	name = OUTFIT_JOB_NAME("Chief engineer")
	head = /obj/item/clothing/head/hardhat/white
	uniform = /obj/item/clothing/under/rank/chief_engineer
	l_ear = /obj/item/radio/headset/heads/ce
	gloves = /obj/item/clothing/gloves/black
	id_type = /obj/item/card/id/engineering/head
	pda_type = /obj/item/pda/heads/ce

/decl/hierarchy/outfit/job/engineering/engineer
	name = OUTFIT_JOB_NAME("Engineer")
	head = /obj/item/clothing/head/hardhat
	uniform = /obj/item/clothing/under/rank/engineer
	belt = /obj/item/storage/belt/utility/full
	id_type = /obj/item/card/id/engineering
	pda_type = /obj/item/pda/engineering

/decl/hierarchy/outfit/job/engineering/atmos
	name = OUTFIT_JOB_NAME("Atmospheric technician")
	uniform = /obj/item/clothing/under/rank/atmospheric_technician
	head = /obj/item/clothing/head/hardhat/dblue
	belt = /obj/item/storage/belt/utility/atmostech
	id_type = /obj/item/card/id/engineering
	pda_type = /obj/item/pda/atmos

/decl/hierarchy/outfit/job/engineering/pest
	name = OUTFIT_JOB_NAME("Pest Control")
	uniform = /obj/item/clothing/under/hazard
	head = /obj/item/clothing/head/hardhat/orange
	id_type = /obj/item/card/id/engineering
	pda_type = /obj/item/pda/cargo
