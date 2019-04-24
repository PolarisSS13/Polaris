/decl/hierarchy/outfit/job/nanotrasen
	hierarchy_type = /decl/hierarchy/outfit/job/nanotrasen
	uniform = /obj/item/clothing/under/rank/centcom
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/white
	l_ear = /obj/item/device/radio/headset/government
	glasses = /obj/item/clothing/glasses/sunglasses
	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/centcom	//station
	pda_slot = slot_r_store
	pda_type = /obj/item/device/pda/heads
	backpack_contents = list(/obj/item/clothing/accessory/permit/gun = 1)

/decl/hierarchy/outfit/job/nanotrasen/post_equip(mob/living/carbon/human/H)
	..()
	for(var/obj/item/clothing/accessory/permit/gun/permit in H.back.contents)
		permit.set_name(H.real_name)

/decl/hierarchy/outfit/job/nanotrasen/representative
	name = "Nanotrasen Representative"
	uniform = /obj/item/clothing/under/suit_jacket/charcoal
	belt = /obj/item/weapon/gun/projectile/pistol
	l_hand = /obj/item/weapon/paper
	r_hand = /obj/item/weapon/clipboard
	id_pda_assignment = "Nanotrasen Representative"

/decl/hierarchy/outfit/job/nanotrasen/guard //Deployed to keep NT officials safe, like the city hall guard -- not death squad
	name = "Nanotrasen Security" //Name also subject to lore nerds, Nanotrasen Guard just seemed wimpy
	uniform = /obj/item/clothing/under/utility/sifguard
	suit = /obj/item/clothing/suit/armor/pcarrier/medium/nt
	head = /obj/item/clothing/head/helmet/dermal
	shoes = /obj/item/clothing/shoes/boots/jackboots
	belt = /obj/item/weapon/storage/belt/security
	gloves = /obj/item/clothing/gloves/swat
	glasses = /obj/item/clothing/glasses/sunglasses/sechud/tactical
	back = /obj/item/weapon/storage/backpack/messenger/black
	backpack_contents = list(/obj/item/clothing/accessory/permit/gun = 1, /obj/item/weapon/handcuffs = 1,
							 /obj/item/clothing/accessory/holster/leg = 1,
							 /obj/item/clothing/accessory/armband/med/color = 1,
							 /obj/item/weapon/gun/energy/stunrevolver = 1,
							 /obj/item/weapon/gun/projectile/p92x/large = 1)
	id_pda_assignment = "Nanotrasen Security"

/decl/hierarchy/outfit/job/nanotrasen/officer
	name = "Nanotrasen Officer"
	uniform = /obj/item/clothing/under/suit_jacket/charcoal
	suit = /obj/item/clothing/suit/dress/expedition
	head = /obj/item/clothing/head/dress/expedition
	belt = /obj/item/weapon/gun/energy
	id_pda_assignment = "Nanotrasen Officer"

/decl/hierarchy/outfit/job/nanotrasen/captain
	name = "Nanotrasen Regional Commander" //Name subject to change depending on what lore nerds think fits
	uniform = /obj/item/clothing/under/suit_jacket/really_black
	suit = /obj/item/clothing/suit/storage/toggle/dress/fleet/command
	head = /obj/item/clothing/head/beret/centcom/captain
	belt = /obj/item/weapon/gun/energy/toxgun //Fancy gun for bosses that like melting the insides of people
	id_pda_assignment = "Nanotrasen Regional Commander"

/decl/hierarchy/outfit/job/nanotrasen/cbia
	name = "Nanotrasen CBIA Agent"
	head = /obj/item/clothing/head/beret/centcom/officer
	uniform = /obj/item/clothing/under/rank/centcom
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/white
	glasses = /obj/item/clothing/glasses/sunglasses
	belt = /obj/item/weapon/gun/energy
	id_pda_assignment = "Nanotrasen CBIA Agent"