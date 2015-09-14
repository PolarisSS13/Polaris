/obj/item/clothing
	var/poise = 0 //This is used to defend against stagger.

/mob/living/silicon
	var/poise = 2 //Borgs can't wear armor so they innately get poise.

/mob/living/silicon/ai
	poise = 8 //It'll be amusing if someone sends the AI flying with a sledgehammer or something.

/mob/living/proc/get_poise()
	return 0

/mob/living/silicon/get_poise()
	return poise

/mob/living/carbon/human/get_poise()
	var/total_poise = 0
	var/worn_items = get_equipped_items()
	for(var/obj/item/clothing/I in worn_items)
		var/worn_poise =  I.poise
		total_poise = total_poise + worn_poise

	return total_poise
