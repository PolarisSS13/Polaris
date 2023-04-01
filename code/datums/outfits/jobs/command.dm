/decl/hierarchy/outfit/job/captain
	name = OUTFIT_JOB_NAME("Steward")
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/costume/captain_fly
	head = /obj/item/clothing/head/cowboy_hat
	l_ear = /obj/item/radio/headset/heads/captain
	shoes = /obj/item/clothing/shoes/boots/cowboy/classic
	backpack = /obj/item/storage/backpack/captain
	satchel_one = /obj/item/storage/backpack/satchel/cap
	messenger_bag = /obj/item/storage/backpack/messenger/com
	id_type = /obj/item/card/id/gold
	pda_type = /obj/item/pda/captain

/decl/hierarchy/outfit/job/captain/post_equip(var/mob/living/carbon/human/H)
	..()
	if(H.age>49)
		// Since we can have something other than the default uniform at this
		// point, check if we can actually attach the medal
		var/obj/item/clothing/uniform = H.w_uniform
		if(uniform)
			var/obj/item/clothing/accessory/medal/gold/captain/medal = new()
			if(uniform.can_attach_accessory(medal))
				uniform.attach_accessory(null, medal)
			else
				qdel(medal)

/decl/hierarchy/outfit/job/hop
	name = OUTFIT_JOB_NAME("Facility Manager")
	l_ear = /obj/item/radio/headset/heads/hop
	shoes = /obj/item/clothing/shoes/boots/cowboy/classic
	id_type = /obj/item/card/id/silver
	pda_type = /obj/item/pda/heads/hop

/decl/hierarchy/outfit/job/hop/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/suit_jacket/female/skirt
	else
		uniform = /obj/item/clothing/under/suit_jacket/charcoal

/decl/hierarchy/outfit/job/secretary
	name = OUTFIT_JOB_NAME("Command Secretary")
	l_ear = /obj/item/radio/headset/headset_com
	uniform = /obj/item/clothing/under/rank/head_of_personnel
	shoes = /obj/item/clothing/shoes/boots/cowboy
	id_type = /obj/item/card/id/silver
	pda_type = /obj/item/pda/heads

