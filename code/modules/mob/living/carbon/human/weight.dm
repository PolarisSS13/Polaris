

/mob/living/carbon/human/proc/handle_weight()
	if(!species.uses_calories)
		return

	weight = calories_to_weight()

	// MIN TO THINNER
	if (calories <= species.thinner_calories)
		if(!has_modifier_of_type(/datum/modifier/trait/thinner))
			reset_weight()
			add_modifier(/datum/modifier/trait/thinner, null, src)

			return

	// THINNER TO THIN
	else if ((calories >= species.thinner_calories) && (calories <= species.thin_calories))
		if(!has_modifier_of_type(/datum/modifier/trait/thin))
			reset_weight()
			add_modifier(/datum/modifier/trait/thin, null, src)
			return

	// THIN TO NORMAL
	else if ((calories >= species.thin_calories) && (calories <= species.normal_calories))
		if(has_modifier_of_type(/datum/modifier/trait/fat) | has_modifier_of_type(/datum/modifier/trait/thin) | has_modifier_of_type(/datum/modifier/trait/thinner) | has_modifier_of_type(/datum/modifier/trait/obese))
			reset_weight()

			return

	// NORMAL to FAT
	else if ((calories >= species.normal_calories) && (calories <= species.fat_calories))
		if(!has_modifier_of_type(/datum/modifier/trait/fat))
			reset_weight()
			add_modifier(/datum/modifier/trait/fat, null, src)
			return

	// FAT to OBESE
	else if (calories > species.fat_calories)
		if(!has_modifier_of_type(/datum/modifier/trait/obese))
			reset_weight()
			add_modifier(/datum/modifier/trait/obese, null, src)
			return


/mob/living/carbon/human/proc/calories_to_weight()
	var/pounds
	pounds = calories / 3500 //Weight is in pounds here.

	return pounds

/mob/living/carbon/human/proc/weight_to_calories()
	var/cals
	cals = weight * 3500 //Weight is in pounds here.

	return cals