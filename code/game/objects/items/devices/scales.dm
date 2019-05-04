/obj/item/device/weightscales
	name = "weight scales"
	desc = "Scales design"
	icon_state = "w_scales"
	density = 0

/obj/item/device/weightscales/attack_hand(mob/living/user)
	if(user.loc != src.loc)
		to_chat(user, "<span class='warning'>You need to step on the scales to measure your weight.</span>")
		return
	else
		if(!ishuman(user))
			to_chat(user, "<span class='warning'>You need to be human to use these scales.</span>")
			return
		else
			var/mob/living/carbon/human/H = user
			to_chat(H, "<span class='notice'>You stand on the scales.</span>")
			spawn(3)
			H.visible_message("''Weight: <b>[H.weight]lbs</b> - [get_weight(H.calories,H.species)]' appears on the screen of [src] as [H] steps onto it.", "Your weight is <b>[H.weight]lbs. You are <b>[get_weight(H.calories,H.species)]</b>.")
			return

/obj/item/device/weightscales/attack_self(mob/living/user)
	to_chat(user, "<span class='warning'>You need to stand on the scales to measure your weight.</span>")
	return
