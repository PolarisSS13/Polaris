//lonestar civ jobs
//assistant/tourist

/decl/hierarchy/outfit/job/assistant
	name = OUTFIT_JOB_NAME("Assistant")
	id_type = /obj/item/card/id/assistant

/decl/hierarchy/outfit/job/assistant/visitor
	name = OUTFIT_JOB_NAME("Visitor")
	id_pda_assignment = "Visitor"

/decl/hierarchy/outfit/job/assistant/cityslick
	name = OUTFIT_JOB_NAME("City Slicker")
	id_pda_assignment = "City Slicker"
	uniform = /obj/item/clothing/under/suit_jacket/really_black

/decl/hierarchy/outfit/job/assistant/resident
	name = OUTFIT_JOB_NAME("Resident")
	id_pda_assignment = "Resident"
	uniform = /obj/item/clothing/under/color/white

//food service

/decl/hierarchy/outfit/job/service
	l_ear = /obj/item/radio/headset/headset_service
	hierarchy_type = /decl/hierarchy/outfit/job/service

/decl/hierarchy/outfit/job/service/bartender
	name = OUTFIT_JOB_NAME("Bartender")
	uniform = /obj/item/clothing/under/rank/bartender
	id_type = /obj/item/card/id/civilian
	pda_type = /obj/item/pda/bar
	backpack_contents = list(/obj/item/clothing/accessory/permit/gun/bar = 1)

/decl/hierarchy/outfit/job/service/bartender/post_equip(mob/living/carbon/human/H)
	..()
	for(var/obj/item/clothing/accessory/permit/gun/bar/permit in H.back.contents)
		permit.set_name(H.real_name)

/decl/hierarchy/outfit/job/service/barman
	name = OUTFIT_JOB_NAME("Bar Manager")
	uniform = /obj/item/clothing/under/suit_jacket/navy
	glasses = /obj/item/clothing/glasses/sunglasses
	shoes = /obj/item/clothing/shoes/syndigaloshes
	id_type = /obj/item/card/id/civilian
	pda_type = /obj/item/pda/bar
	backpack_contents = list(/obj/item/clothing/accessory/permit/gun/bar = 1)

/decl/hierarchy/outfit/job/service/bartender/post_equip(mob/living/carbon/human/H)
	..()
	for(var/obj/item/clothing/accessory/permit/gun/bar/permit in H.back.contents)
		permit.set_name(H.real_name)

/decl/hierarchy/outfit/job/service/chef
	name = OUTFIT_JOB_NAME("Chef")
	uniform = /obj/item/clothing/under/rank/chef
	suit = /obj/item/clothing/suit/chef
	head = /obj/item/clothing/head/chefhat
	id_type = /obj/item/card/id/civilian
	pda_type = /obj/item/pda/chef

/decl/hierarchy/outfit/job/service/chef/cook
	name = OUTFIT_JOB_NAME("Cook")
	id_pda_assignment = "Cook"

//other

/decl/hierarchy/outfit/job/mining
	name = OUTFIT_JOB_NAME("Independent Prospector")
	uniform = /obj/item/clothing/under/rank/miner
	shoes = /obj/item/clothing/shoes/boots/workboots
	l_ear = /obj/item/radio/headset/headset_mine
	backpack = /obj/item/storage/backpack/industrial
	satchel_one  = /obj/item/storage/backpack/satchel/eng
	id_type = /obj/item/card/id/cargo
	pda_type = /obj/item/pda/shaftminer
	backpack_contents = list(/obj/item/storage/bag/ore = 1)
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

/decl/hierarchy/outfit/job/service/janitor
	name = OUTFIT_JOB_NAME("Janitor")
	uniform = /obj/item/clothing/under/rank/janitor
	shoes = /obj/item/clothing/shoes/galoshes
	id_type = /obj/item/card/id/civilian
	pda_type = /obj/item/pda/janitor

/decl/hierarchy/outfit/job/gunsmith
	name = OUTFIT_JOB_NAME("Gunsmith")
	uniform = /obj/item/clothing/under/tactical
	shoes = /obj/item/clothing/shoes/boots/cowboy
	id_type = /obj/item/card/id/security
	pda_type = /obj/item/pda/security

/decl/hierarchy/outfit/job/pub_defender
	name = OUTFIT_JOB_NAME("Public Defender")
	uniform = /obj/item/clothing/under/lawyer/blue
	shoes = /obj/item/clothing/shoes/brown
	glasses = /obj/item/clothing/glasses/sunglasses/big
	id_type = /obj/item/card/id/civilian
	pda_type = /obj/item/pda/lawyer

// unused follows:

/decl/hierarchy/outfit/job/service/gardener
	name = OUTFIT_JOB_NAME("Gardener")
	uniform = /obj/item/clothing/under/rank/hydroponics
	suit = /obj/item/clothing/suit/storage/apron
	gloves = /obj/item/clothing/gloves/botanic_leather
	r_pocket = /obj/item/analyzer/plant_analyzer
	backpack = /obj/item/storage/backpack/hydroponics
	satchel_one = /obj/item/storage/backpack/satchel/hyd
	messenger_bag = /obj/item/storage/backpack/messenger/hyd
	id_type = /obj/item/card/id/civilian
	pda_type = /obj/item/pda/botanist

/decl/hierarchy/outfit/job/explorer
	name = OUTFIT_JOB_NAME("Explorer")
	shoes = /obj/item/clothing/shoes/boots/winter/explorer
	uniform = /obj/item/clothing/under/explorer
	mask = /obj/item/clothing/mask/gas/explorer
	suit = /obj/item/clothing/suit/storage/hooded/explorer
	gloves = /obj/item/clothing/gloves/black
	l_ear = /obj/item/radio/headset
	id_slot = slot_wear_id
	id_type = /obj/item/card/id/civilian
	pda_slot = slot_belt
	pda_type = /obj/item/pda/cargo // Brown looks more rugged
	r_pocket = /obj/item/gps/explorer
	id_pda_assignment = "Explorer"