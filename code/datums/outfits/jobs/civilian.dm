/decl/hierarchy/outfit/job/assistant
	name = OUTFIT_JOB_NAME("Civilian")
	id_type = /obj/item/weapon/card/id/assistant
	uniform = /obj/item/clothing/under/rank/orderly

/decl/hierarchy/outfit/job/assistant/visitor
	name = OUTFIT_JOB_NAME("Visitor")
	id_pda_assignment = "Visitor"
	uniform = /obj/item/clothing/under/assistantformal

/decl/hierarchy/outfit/job/assistant/resident
	name = OUTFIT_JOB_NAME("Resident")
	id_pda_assignment = "Resident"
	uniform = /obj/item/clothing/under/scratch

/decl/hierarchy/outfit/job/service
	l_ear = /obj/item/device/radio/headset/headset_service
	hierarchy_type = /decl/hierarchy/outfit/job/service

/decl/hierarchy/outfit/job/service/bartender
	name = OUTFIT_JOB_NAME("Bartender")
	uniform = /obj/item/clothing/under/rank/bartender
	id_type = /obj/item/weapon/card/id/civilian/bartender
	pda_type = /obj/item/device/pda/bar
	backpack_contents = list(/obj/item/clothing/accessory/permit/gun/bar = 1)

/decl/hierarchy/outfit/job/service/bartender/post_equip(mob/living/carbon/human/H)
	..()
	for(var/obj/item/clothing/accessory/permit/gun/bar/permit in H.back.contents)
		permit.set_name(H.real_name)

/decl/hierarchy/outfit/job/service/bartender/barista
	name = OUTFIT_JOB_NAME("Barista")
	id_pda_assignment = "Barista"
	backpack_contents = null

/decl/hierarchy/outfit/job/service/chef
	name = OUTFIT_JOB_NAME("Chef")
	uniform = /obj/item/clothing/under/rank/chef
	suit = /obj/item/clothing/suit/chef
	head = /obj/item/clothing/head/chefhat
	id_type = /obj/item/weapon/card/id/civilian/chef
	pda_type = /obj/item/device/pda/chef

/decl/hierarchy/outfit/job/service/chef/cook
	name = OUTFIT_JOB_NAME("Cook")
	id_pda_assignment = "Cook"

/decl/hierarchy/outfit/job/service/gardener
	name = OUTFIT_JOB_NAME("Gardener")
	uniform = /obj/item/clothing/under/rank/hydroponics
	suit = /obj/item/clothing/suit/storage/apron
	gloves = /obj/item/clothing/gloves/botanic_leather
	backpack = /obj/item/weapon/storage/backpack/hydroponics
	satchel_one = /obj/item/weapon/storage/backpack/satchel/hyd
	messenger_bag = /obj/item/weapon/storage/backpack/messenger/hyd
	id_type = /obj/item/weapon/card/id/civilian/botanist
	pda_type = /obj/item/device/pda/botanist

/decl/hierarchy/outfit/job/service/janitor
	name = OUTFIT_JOB_NAME("Janitor")
	uniform = /obj/item/clothing/under/rank/janitor
	id_type = /obj/item/weapon/card/id/civilian/janitor
	pda_type = /obj/item/device/pda/janitor

/decl/hierarchy/outfit/job/civilian/journalist
	name = OUTFIT_JOB_NAME("Journalist")
	uniform = /obj/item/clothing/under/suit_jacket/red
	l_hand = /obj/item/weapon/barcodescanner
	id_type = /obj/item/weapon/card/id/civilian/journalist
	pda_type = /obj/item/device/pda/librarian

/decl/hierarchy/outfit/job/civilian/chaplain
	name = OUTFIT_JOB_NAME("Chaplain")
	uniform = /obj/item/clothing/under/rank/chaplain
	l_hand = /obj/item/weapon/storage/bible
	id_type = /obj/item/weapon/card/id/civilian/chaplain
	pda_type = /obj/item/device/pda/chaplain

/decl/hierarchy/outfit/job/explorer
	name = OUTFIT_JOB_NAME("Explorer")
	shoes = /obj/item/clothing/shoes/boots/winter/explorer
	uniform = /obj/item/clothing/under/explorer
	mask = /obj/item/clothing/mask/gas/explorer
	suit = /obj/item/clothing/suit/storage/hooded/explorer
	gloves = /obj/item/clothing/gloves/black
	l_ear = /obj/item/device/radio/headset
	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/civilian
	pda_slot = slot_belt
	pda_type = /obj/item/device/pda/cargo // Brown looks more rugged
	r_pocket = /obj/item/device/gps/explorer
	id_pda_assignment = "Explorer"

/decl/hierarchy/outfit/job/civilian/barber
	name = OUTFIT_JOB_NAME("Barber")
	id_type = /obj/item/weapon/card/id/civilian/barber
	uniform = /obj/item/clothing/under/rank/barber
	r_pocket = /obj/item/weapon/scissors/barber


/decl/hierarchy/outfit/job/heads/judge
	name = OUTFIT_JOB_NAME("Judge")
	l_ear = /obj/item/device/radio/headset/headset_judge
	uniform = /obj/item/clothing/under/suit_jacket/charcoal
	head = /obj/item/clothing/head/powdered_wig
	suit = /obj/item/clothing/suit/judgerobe
	shoes = /obj/item/clothing/shoes/laceup
	l_hand = /obj/item/weapon/clipboard
	id_type = /obj/item/weapon/card/id/heads/judge
	pda_type = /obj/item/device/pda/lawyer
	backpack_contents = list(/obj/item/clothing/accessory/permit/gun = 1)

/decl/hierarchy/outfit/job/heads/judge/post_equip(mob/living/carbon/human/H)
	..()
	for(var/obj/item/clothing/accessory/permit/gun/permit in H.back.contents)
		permit.set_name(H.real_name)

/decl/hierarchy/outfit/job/civilian/defense/defense
	name = OUTFIT_JOB_NAME("Defense Attorney")
	l_ear = /obj/item/device/radio/headset/headset_legal
	uniform = /obj/item/clothing/under/lawyer/blue
	suit = /obj/item/clothing/suit/storage/toggle/lawyer/bluejacket
	shoes = /obj/item/clothing/shoes/black
	glasses = /obj/item/clothing/glasses/sunglasses/big
	l_hand = /obj/item/weapon/clipboard
	id_type = /obj/item/weapon/card/id/civilian/defense
	pda_type = /obj/item/device/pda/lawyer

/decl/hierarchy/outfit/job/prosecution
	name = OUTFIT_JOB_NAME("District Prosecutor")
	l_ear = /obj/item/device/radio/headset/ia
	uniform = /obj/item/clothing/under/lawyer/purpsuit
	suit = /obj/item/clothing/suit/storage/toggle/lawyer/purpjacket
	shoes = /obj/item/clothing/shoes/brown
	glasses = /obj/item/clothing/glasses/sunglasses/big
	l_hand = /obj/item/weapon/clipboard
	id_type = /obj/item/weapon/card/id/security/prosecutor
	pda_type = /obj/item/device/pda/lawyer

/decl/hierarchy/outfit/job/civilian/secretary
	name = OUTFIT_JOB_NAME("Secretary")
	l_ear = /obj/item/device/radio/headset/headset_com
	r_ear = /obj/item/weapon/pen
	shoes = /obj/item/clothing/shoes/brown
	id_type = /obj/item/weapon/card/id/civilian/secretary
	r_hand = /obj/item/weapon/folder
	l_hand = /obj/item/weapon/paper

/decl/hierarchy/outfit/job/civilian/secretary/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/suit_jacket/checkered/skirt
	else
		uniform = /obj/item/clothing/under/suit_jacket/checkered


/decl/hierarchy/outfit/job/civilian/prisoner
	name = OUTFIT_JOB_NAME("Prisoner")
	id_pda_assignment = "Prisoner"
	uniform = /obj/item/clothing/under/color/orange
	shoes = /obj/item/clothing/shoes/orange