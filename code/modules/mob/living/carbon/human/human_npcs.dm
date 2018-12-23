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

/mob/living/carbon/human/npc
	var/stop_automated_movement = 0 //Use this to temporarely stop random movement or to if you write special movement code for animals.
	var/turns_per_move = 1
	var/turns_since_move = 0
	var/moving_to = 0
	var/wander = 1	// Does the mob wander around when idle?
	var/stop_automated_movement_when_pulled = 1 //When set to 1 this stops the animal from moving when someone is pulling it.



/mob/living/carbon/human/npc/random/New()
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

/mob/living/carbon/human/npc/random/child/New()
	..()
	age = rand(8,12)
	set_species("Human Child")
	h_style = random_hair_style(gender, "Human Child")


/mob/living/carbon/human/npc/random/teen/New()
	..()
	age = rand(13,17)
	h_style = random_hair_style(gender, "Human Child")
	f_style = random_facial_hair_style(gender, "Human Adolescent")
	set_species("Human Adolescent")

/mob/living/carbon/human/npc/random/moving/
	stop_automated_movement = 0


/mob/living/carbon/human/npc/Life(var/mob/living/carbon/human/D)
	set invisibility = 0
	set background = BACKGROUND_ENABLED

	if (transforming)
		return

	//Apparently, the person who wrote this code designed it so that
	//blinded get reset each cycle and then get activated later in the
	//code. Very ugly. I dont care. Moving this stuff here so its easy
	//to find it.
	blinded = 0
	fire_alert = 0 //Reset this here, because both breathe() and handle_environment() have a chance to set it.

	//TODO: seperate this out
	// update the current life tick, can be used to e.g. only do something every 4 ticks
	life_tick++

	// This is not an ideal place for this but it will do for now.
	if(wearing_rig && wearing_rig.offline)
		wearing_rig = null

	if(life_tick%30==15)
		hud_updateflag = 1022

	voice = GetVoice()
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
	//Update our name based on whether our face is obscured/disfigured
	name = get_visible_name()

	pulse = handle_pulse()

/mob/living/carbon/human/npc/random/moving/child/New()
	..()
	age = rand(8,12)
	set_species("Human Child")
	h_style = random_hair_style(gender, "Human Child")


/mob/living/carbon/human/npc/random/moving/teen/New()
	..()
	age = rand(13,17)
	h_style = random_hair_style(gender, "Human Child")
	f_style = random_facial_hair_style(gender, "Human Adolescent")
	set_species("Human Adolescent")


//NPC BEHAVIOUR

/mob/living/carbon/human/npc/random/barfly
	var/wanted_drink
	var/has_no_drink
	var/thirsty = 1
	var/held_drink
	var/chatter_time = 90
	var/drink_time = 130
	var/obj/item/weapon/reagent_containers/food/drinks/served
	stop_automated_movement = 1


	var/list_of_drinks = list(
	"whiskey",
	"beer",
	"ale",
	"rum",
	"vermouth",
	"vodka",
	"gin",
	"wine")

	var/asking_msg


/mob/living/carbon/human/npc/random/barfly/New()
	..()
	pick_drink()
	sleep(3)
	chatter()

/mob/living/carbon/human/npc/random/barfly/proc/pick_drink()
	wanted_drink = pick(list_of_drinks)


/mob/living/carbon/human/npc/random/barfly/proc/chatter()
	if(thirsty)

		asking_msg = pick("Hey bartender, can I get a [wanted_drink] please?",
		"Hey, can I have a [wanted_drink] if that's okay?",
		"I've honestly had a day and need a good [wanted_drink], as soon as possible.",
		"Oi, [wanted_drink] now please.",
		"I'm craving a good [wanted_drink], make it your best one.",
		"Your best [wanted_drink] please, with ice.",
		"You know what I fancy? A cold glass of [wanted_drink]!",
		"I hope this isn't a funny request, but I'd love a good [wanted_drink], with a cute stick in it...",
		"Hi, if you don't mind, a [wanted_drink], please.")

		src.say("[asking_msg]")
	else
		if(!thirsty && served)
			var/sip_msg = pick("takes a long sip from the [held_drink] before swirling it around in their hand.",
			"sips daintily from the [held_drink].",
			"contently drinks from the [held_drink].",
			"takes their [held_drink] slowly, savoring the taste as it is brought to their lips.",
			"sighs deeply, clearly enjoying the flavours they experience from the [held_drink].",
			"exhales a hearty sigh after chugging a few mouthfuls of [held_drink]!")
			src.visible_message("<b>[src]</b> [sip_msg]")
			playsound(loc,'sound/items/drink.ogg', rand(10,50), 1)
		else
			var/banter = pick(
			"Nice weather, eh?",
			"It's nice to get away from home isn't it keep?",
			"*yawn",
			"Sometimes I wonder if I come to this place to get away from the real world.",
			"So, how's life been?",
			"Been a bit tired and stressed recently... I'll get through it.",
			"It's nice coming here after work, you know?",
			"The service here is usually good. I like it.",
			"What do you think of the newcomers to the city?",
			"Man, I think I drank too fast.",
			"I've been thinking that settling down would be great for me.",
			"You think I should go after that person I'm pining after?",
			"I wonder if there's anything else to do in this horrible city.",
			"You seem genuine. Wouldn't mind being friends with you.",
			"I try not to get too much into politics, gets me depressed.",
			"I shouldn't really be here, should be paying the bills with this money.",
			"How long have you been here?",
			"I like your style, by the way.")
			src.say("[banter]")



/mob/living/carbon/human/npc/random/barfly/Life(var/mob/living/carbon/human/D)
	..()

	for(served in oview(src,1))
		if(served.reagents.has_reagent("[wanted_drink]"))
			var/thanks_msg = pick("Thanks!",
			"That looks refreshing!",
			"You're a lifesaver!",
			"Oh! Thanks!",
			"That's just what I wanted, thank you!",
			"Thank you very much!",
			"Awesome!")
			src.say("[thanks_msg]")
			//save position of glass before they pick it up.
			var/drink_area
			drink_area = served.loc
			held_drink = served
			thirsty = 0
			sleep(chatter_time)
			chatter()
			sleep(chatter_time)
			chatter()
			sleep(drink_time)
			chatter()
			served.reagents.trans_to_mob(src, served.reagents.total_volume)
			sleep(3)
			thanks_msg = pick("That hit the spot!", "Best I've had in a while.", "Again, thank you.")
			src.say("[thanks_msg]")
			sleep(3)
			src.say("Here's the payment, keep the change.")
			new /obj/item/weapon/spacecash/c10(drink_area)
			served = null
			held_drink = null

			sleep(chatter_time)
			chatter()
			sleep(chatter_time)
			chatter()
			pick_drink()
			sleep(drink_time)
			thirsty = 1
			chatter()







