proc/random_outfit(var/mob/living/carbon/human/M)

	var/outfit

	/var/random_dress = pick(
	/obj/item/clothing/under/dress/black_corset,
	/obj/item/clothing/under/dress/dress_hr,
	/obj/item/clothing/under/dress/dress_pink,
	/obj/item/clothing/under/dress/dress_saloon,
	/obj/item/clothing/under/dress/dress_green,
	/obj/item/clothing/under/dress/dress_fire,
	/obj/item/clothing/under/sundress_white,
	/obj/item/clothing/under/suit_jacket/female,
	/obj/item/clothing/under/dress/flower_dress,
	/obj/item/clothing/under/dress/sailordress,
	/obj/item/clothing/under/dress/stripeddress,
	/obj/item/clothing/under/dress/westernbustle,
	/obj/item/clothing/under/dress/darkred)

	if(M.gender == MALE)
		if(M.age < 90)
			outfit = pick (
				"hip_man",
				"classy_man",
				"slob_man",
				"rad_guy",
				"hippy_man",
				"tourist",
				"pink_tourist",
				"middleaged_man",
				"plain",
				"wealthy_man",
				"hooligan_man")
		else
			outfit = pick (
				"old_man")
	if(M.gender == FEMALE)
		if(M.age < 90)
			outfit = pick (
				"hip_woman",
				"orange_woman",
				"floral_dress_woman",
				"hr",
				"tourist",
				"pink_tourist",
				"pink",
				"harlot",
				"azn",
				"evening_lady",
				"exec",
				"striped",
				"tango",
				"maid",
				"sailor femme",
				"dorothy",
				"diva",
				"red diva",
				"red mini",
				"black mini",
				"fire",
				"white")
		else
			outfit = pick (
				"old_woman")


	switch(outfit)

		if ("striped")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/dress/stripeddress(M), slot_w_uniform)

		if ("tango")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/heels(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/dress/blacktango(M), slot_w_uniform)

		if ("maid")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/dress/maid(M), slot_w_uniform)

		if ("sailor femme")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/dress/sailordress(M), slot_w_uniform)

		if ("plain")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/navy(M), slot_w_uniform)

		if ("red diva")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/heels(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/dress/flamenco(M), slot_w_uniform)

		if ("diva")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/heels(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/female/skirt(M), slot_w_uniform)

		if ("red mini")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/heels(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/cuttop/red(M), slot_w_uniform)

		if ("black mini")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/heels(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/cuttop(M), slot_w_uniform)

		if ("pink_tourist")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/burgundy(M), slot_w_uniform)

		if ("tourist")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/focal(M), slot_w_uniform)

		if ("evening_lady")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/dress/redeveninggown(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(M), slot_gloves)

		if ("classy_man")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/charcoal(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/greyjacket(M), slot_wear_suit)

		if ("slob_man")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/track(M), slot_wear_suit)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/overalls(M), slot_w_uniform)

		if ("rad_guy")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/scratch(M), slot_w_uniform)

		if ("hippy_man")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/rainbow(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/checkered(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/prescription(M), slot_glasses)


		if ("old_man")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/leather(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/boaterhat(M), slot_head)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(M), slot_glasses)

			M.equip_to_slot_or_del(new /obj/item/weapon/cane(M), slot_r_hand)
		if ("hr")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/dress/dress_hr(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(M), slot_glasses)

		if ("pink")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/dress/dress_pink(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big(M), slot_glasses)

		if ("harlot")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/boots/winter(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/dress/black_corset(M), slot_w_uniform)

		if ("exec")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/female(M), slot_w_uniform)
		if ("dorothy")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/blue(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/skirt/denim(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(M), slot_glasses)

		if ("fire")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/blue(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/dress/dress_fire(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(M), slot_glasses)

		if ("white")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/blue(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/sundress_white(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(M), slot_glasses)

		if ("azn")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/blue(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/cheongsam(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(M), slot_glasses)


		if ("old_woman")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/blue(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/oldwoman(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/pin/flower/white(M), slot_head)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(M), slot_glasses)


			M.equip_to_slot_or_del(new /obj/item/weapon/cane(M), slot_r_hand)
		if ("hip_woman")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/dress/flower_dress(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/bomber/alt(M), slot_wear_suit)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big(M), slot_glasses)

		if ("orange_woman")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/dress/dress_orange(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/poppy_crown(M), slot_head)
			M.equip_to_slot_or_del(new /obj/item/clothing/gloves/white(M), slot_gloves)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big(M), slot_glasses)

		if ("hip_man")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/boots/winter(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/burgundy(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/brown_jacket(M), slot_wear_suit)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big(M), slot_glasses)
		if ("middleaged_man")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/leather(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/tan(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/brown_jacket(M), slot_wear_suit)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/prescription(M), slot_glasses)
		if ("wealthy_man")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/leather(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/checkered(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/hoodie(M), slot_wear_suit)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/prescription(M), slot_glasses)
		if ("floral_dress_woman")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/purple(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/sundress_white(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/hoodie/yellow(M), slot_wear_suit)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/prescription(M), slot_glasses)

		if ("hooligan_man")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/flatcap(M), slot_head)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/rank/vice(M), slot_w_uniform)
		if ("street")
			M.equip_to_slot_or_del(new /obj/item/clothing/under/mbill(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/hitops/black(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/beanie(M), slot_head)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/hoodie/black(M), slot_wear_suit)

	return


//Now, for the actual NPCs.

/mob/living/carbon/human/random
/mob/living/carbon/human/random/New()
	..()
	gender = pick(MALE,FEMALE)

	age = rand(18,90)

//	age = random_age
	s_tone = random_skin_tone()
	h_style = random_hair_style(gender, "Human")
	f_style = random_facial_hair_style(gender, "Human")

	if(gender == MALE)
		name = "[pick(first_names_male)] [pick(last_names)]"
		real_name = name
	else
		name = "[pick(first_names_female)] [pick(last_names)]"
		real_name = name

	//randomize hair color
	var/hair_color = random_hair_color(src)
	r_hair = hair_color[1]
	g_hair = hair_color[2]
	b_hair = hair_color[3]

	//randomize facial hair color
	r_facial = r_hair
	g_facial = g_hair
	b_facial = b_hair

	//randomize eye color
	var/eye_color = random_eye_color()
	r_eyes = eye_color[1]
	g_eyes = eye_color[2]
	b_eyes = eye_color[3]

	random_outfit(src)

/mob/living/carbon/human/random/child/New()
	..()
	age = rand(8,12)
	set_species("Human Child")
	h_style = random_hair_style(gender, "Human Child")


/mob/living/carbon/human/random/teen/New()
	..()
	age = rand(13,17)
	h_style = random_hair_style(gender, "Human Child")
	f_style = random_facial_hair_style(gender, "Human Adolescent")
	set_species("Human Adolescent")

/mob/living/carbon/human/random/moving/
	var/turns_per_move = 1
	var/turns_since_move = 0
	var/moving_to = 0
	var/stop_automated_movement = 0 //Use this to temporarely stop random movement or to if you write special movement code for animals.
	var/wander = 1	// Does the mob wander around when idle?
	var/stop_automated_movement_when_pulled = 1 //When set to 1 this stops the animal from moving when someone is pulling it.


/mob/living/carbon/human/random/moving/Life()
	//Movement
	if(!client && !stop_automated_movement && wander && !anchored)
		if(isturf(src.loc) && !resting && !buckled && canmove)		//This is so it only moves if it's not inside a closet, gentics machine, etc.
			turns_since_move++
			if(turns_since_move >= turns_per_move)
				if(!(stop_automated_movement_when_pulled && pulledby)) //Soma animals don't move when pulled
					moving_to = pick(cardinal)
					dir = moving_to			//How about we turn them the direction they are moving, yay.
					Move(get_step(src,moving_to))
					turns_since_move = 0

/mob/living/carbon/human/random/moving/child/New()
	..()
	age = rand(8,12)
	set_species("Human Child")
	h_style = random_hair_style(gender, "Human Child")


/mob/living/carbon/human/random/moving/teen/New()
	..()
	age = rand(13,17)
	h_style = random_hair_style(gender, "Human Child")
	f_style = random_facial_hair_style(gender, "Human Adolescent")
	set_species("Human Adolescent")