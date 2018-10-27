/mob/living/carbon/human/jesus
	name = "Jesus"

	f_style = "Long Beard"
	h_style = "Unkept"
	does_not_breathe = 1
	g_hair = 102
	r_hair = 153
	status_flags = null

/mob/living/carbon/human/jesus/New()
	..()
	src.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(src), slot_shoes)
	src.equip_to_slot_or_del(new /obj/item/clothing/under/pants/baggy/white(src), slot_w_uniform)
	src.equip_to_slot_or_del(new /obj/item/clothing/suit/kimono(src), slot_wear_suit)
	src.equip_to_slot_or_del(new /obj/item/weapon/storage/bible/booze(src), slot_r_hand)
	src.equip_to_slot_or_del(new /obj/item/weapon/reagent_containers/food/drinks/bottle/holywater(src), slot_l_hand)
	name = "Jesus Christ"
	real_name = "Jesus Christ"

	src.mutations.Add(HEAL)
	src.mutations.Add(TK)
	src.mutations.Add(XRAY)
	src.mutations.Add(COLD_RESISTANCE)
	src.sight |= (SEE_MOBS|SEE_OBJS|SEE_TURFS)
	src.see_in_dark = 8
	src.see_invisible = SEE_INVISIBLE_LEVEL_TWO
	src.update_mutations()
	src.mind.special_role = "Jesus"