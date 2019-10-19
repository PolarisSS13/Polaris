/decl/hierarchy/outfit/job/heads/captain
	name = OUTFIT_JOB_NAME("Mayor")
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/rank/captain
	suit = /obj/item/clothing/suit/tailcoat/mayor
	l_ear = /obj/item/device/radio/headset/heads/captain
	shoes = /obj/item/clothing/shoes/brown
	backpack = /obj/item/weapon/storage/backpack/captain
	satchel_one = /obj/item/weapon/storage/backpack/satchel/cap
	messenger_bag = /obj/item/weapon/storage/backpack/messenger/com
	id_type = /obj/item/weapon/card/id/gold/captain
	pda_type = /obj/item/device/pda/captain
	backpack_contents = list(/obj/item/clothing/accessory/permit/gun = 1)

/decl/hierarchy/outfit/job/heads/captain/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.identifying_gender == FEMALE)
		uniform = /obj/item/clothing/under/rank/captain/skirt

/decl/hierarchy/outfit/job/heads/captain/post_equip(var/mob/living/carbon/human/H)
	..()
	if(H.back)
		for(var/obj/item/clothing/accessory/permit/gun/permit in H.back.contents)
			permit.set_name(H.real_name)
	if(H.age>49)
		// Since we can have something other than the default uniform at this
		// point, check if we can actually attach the medal
		var/obj/item/clothing/uniform = H.w_uniform
		if(uniform)
			var/obj/item/clothing/accessory/medal/gold/captain/medal = new()
			var/obj/item/clothing/accessory/tie/sash/sash = new()
			if(uniform.can_attach_accessory(medal))
				uniform.attach_accessory(null, medal)
			else
				qdel(medal)
			if(uniform.can_attach_accessory(sash))
				uniform.attach_accessory(null, sash)
			else
				qdel(sash)
/decl/hierarchy/outfit/job/heads/hop
	name = OUTFIT_JOB_NAME("City Clerk")
	uniform = /obj/item/clothing/under/rank/head_of_personnel_whimsy
	l_ear = /obj/item/device/radio/headset/heads/hop
	shoes = /obj/item/clothing/shoes/brown
	id_type = /obj/item/weapon/card/id/silver/hop
	pda_type = /obj/item/device/pda/heads/hop
	backpack_contents = list(/obj/item/clothing/accessory/permit/gun = 1)

/decl/hierarchy/outfit/job/heads/hop/post_equip(mob/living/carbon/human/H)
	..()
	if(H.back)
		for(var/obj/item/clothing/accessory/permit/gun/permit in H.back.contents)
			permit.set_name(H.real_name)

/decl/hierarchy/outfit/job/heads/secretary
	name = OUTFIT_JOB_NAME("City Hall Guard")
	l_ear = /obj/item/device/radio/headset/headset_com
	shoes = /obj/item/clothing/shoes/brown
	id_type = /obj/item/weapon/card/id/silver/secretary
	pda_type = /obj/item/device/pda/heads/hop
	r_hand = /obj/item/weapon/clipboard
	backpack_contents = list(/obj/item/clothing/accessory/permit/gun = 1)

/decl/hierarchy/outfit/job/heads/secretary/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/suit_jacket/female/skirt
	else
		uniform = /obj/item/clothing/under/suit_jacket/charcoal

/decl/hierarchy/outfit/job/heads/secretary/post_equip(mob/living/carbon/human/H)
	..()
	for(var/obj/item/clothing/accessory/permit/gun/permit in H.back.contents)
		permit.set_name(H.real_name)

