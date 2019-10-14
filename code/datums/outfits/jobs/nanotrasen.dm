/decl/hierarchy/outfit/job/nanotrasen
	hierarchy_type = /decl/hierarchy/outfit/job/nanotrasen
	uniform = /obj/item/clothing/under/rank/centcom
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/white
	l_ear = /obj/item/device/radio/headset/government
	glasses = /obj/item/clothing/glasses/sunglasses
	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/nanotrasen/ntrep	//station
	pda_slot = slot_r_store
	pda_type = /obj/item/device/pda/heads
	backpack_contents = list(/obj/item/clothing/accessory/permit/gun = 1)

/decl/hierarchy/outfit/job/nanotrasen/post_equip(mob/living/carbon/human/H)
	..()
	if(H.back)
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
	name = "NanoTrasen CEO" //Name subject to change depending on what lore nerds think fits
	uniform = /obj/item/clothing/under/suit_jacket/really_black
	suit = /obj/item/clothing/suit/storage/toggle/dress/fleet/command
	head = /obj/item/clothing/head/beret/centcom/captain
	belt = /obj/item/weapon/gun/energy/toxgun //Fancy gun for bosses that like melting the insides of people
	id_pda_assignment = "Nanotrasen Regional Commander"
	id_type = /obj/item/weapon/card/id/nanotrasen/ceo

/decl/hierarchy/outfit/job/nanotrasen/cbia
	name = "Nanotrasen CBIA Agent"
	head = /obj/item/clothing/head/beret/centcom/officer
	uniform = /obj/item/clothing/under/rank/centcom
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/white
	glasses = /obj/item/clothing/glasses/sunglasses
	belt = /obj/item/weapon/gun/energy
	id_pda_assignment = "Nanotrasen CBIA Agent"
	id_type = /obj/item/weapon/card/id/nanotrasen/cbia

/decl/hierarchy/outfit/job/heads/president
	name = OUTFIT_JOB_NAME("President")
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/rank/president
	suit = /obj/item/clothing/suit/storage/toggle/presidential_jacket
	l_ear = /obj/item/device/radio/headset/headset_com
	shoes = /obj/item/clothing/shoes/leather
	backpack = /obj/item/weapon/storage/backpack
	satchel_one = /obj/item/weapon/storage/backpack/satchel
	messenger_bag = /obj/item/weapon/storage/backpack/messenger/com
	id_type = /obj/item/weapon/card/id/nanotrasen/president
	pda_type = /obj/item/device/pda/captain

/decl/hierarchy/outfit/job/heads/president/post_equip(var/mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/uniform = H.w_uniform
	if(uniform)
		var/obj/item/clothing/accessory/tie/president/tie = new()
		if(uniform.can_attach_accessory(tie))
			uniform.attach_accessory(null, tie)
		else
			qdel(tie)
