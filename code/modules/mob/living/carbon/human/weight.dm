

/mob/living/carbon/human/proc/handle_weight()
	if(!species.uses_calories)
		return
	weight = calories_to_weight(calories)
	var/body_weight = get_weight(calories, species)

	// MIN TO THINNER
	if (body_weight == "very underweight")
		if(!has_modifier_of_type(/datum/modifier/trait/thinner))
			reset_weight()
			add_modifier(/datum/modifier/trait/thinner, null, src)

			return

	// THINNER TO THIN
	else if (body_weight == "underweight")
		if(!has_modifier_of_type(/datum/modifier/trait/thin))
			reset_weight()
			add_modifier(/datum/modifier/trait/thin, null, src)
			return

	// THIN TO NORMAL
	else if (body_weight == "average")
		if(has_modifier_of_type(/datum/modifier/trait/fat) | has_modifier_of_type(/datum/modifier/trait/thin) | has_modifier_of_type(/datum/modifier/trait/thinner) | has_modifier_of_type(/datum/modifier/trait/obese))
			reset_weight()

			return

	// NORMAL to FAT
	else if (body_weight == "overweight")
		if(!has_modifier_of_type(/datum/modifier/trait/fat))
			reset_weight()
			add_modifier(/datum/modifier/trait/fat, null, src)
			return

	// FAT to OBESE
	else if (body_weight == "obese")
		if(!has_modifier_of_type(/datum/modifier/trait/obese))
			reset_weight()
			add_modifier(/datum/modifier/trait/obese, null, src)
			return


/proc/calories_to_weight(var/calories)
	var/pounds
	pounds = calories / CALORIES_MUL //Weight is in pounds here.

	return pounds

/proc/weight_to_calories(var/weight)
	var/cals
	cals = weight * CALORIES_MUL //Weight is in pounds here.

	return cals

proc/get_weight(var/calories, var/datum/species/spec)

	// MIN TO THINNER
	if (calories <= spec.thinner_calories)
		return "very underweight"

	// THINNER TO THIN
	else if ((calories >= spec.thinner_calories) && (calories <= spec.thin_calories))
		return "underweight"

	// THIN TO NORMAL
	else if ((calories >= spec.thin_calories) && (calories <= spec.normal_calories))
		return "average"

	// NORMAL to FAT
	else if ((calories >= spec.normal_calories) && (calories <= spec.fat_calories))
		return "overweight"

	// FAT to OBESE
	else if (calories > spec.fat_calories)
		return "obese"