/mob/living/carbon/proc/ingest(var/datum/reagents/from, var/datum/reagents/target, var/amount = 1, var/multiplier = 1, var/copy = 0) //we kind of 'sneak' a proc in here for ingesting stuff so we can play with it.
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		var/braintype = H.get_FBP_type()
		if(braintype == FBP_DRONE || braintype == FBP_POSI)
			return from.trans_to_holder(target,amount,multiplier,copy) //skip the taste, complete transfer

	if(last_taste_time + 50 < world.time)
		var/datum/reagents/temp = new(amount) //temporary holder used to analyse what gets transfered.
		from.trans_to_holder(temp, amount, multiplier, 1)

		var/text_output = temp.generate_taste_message(src)
		if(text_output != last_taste_text || last_taste_time + 100 < world.time) //We dont want to spam the same message over and over again at the person. Give it a bit of a buffer.
			to_chat(src, "<span class='notice'>You can taste [text_output].</span>")//no taste means there are too many tastes and not enough flavor.

			last_taste_time = world.time
			last_taste_text = text_output
	return from.trans_to_holder(target,amount,multiplier,copy) //complete transfer

/* what this does:
catalogue the 'taste strength' of each one
calculate text size per text.
*/
/datum/reagents/proc/generate_taste_message(mob/living/carbon/taster = null)
	var/minimum_percent = 10
	var/taster_species = taster?.get_species_name()
	if(ishuman(taster))
		var/mob/living/carbon/human/H = taster
		minimum_percent = round(10/ (H.isSynthetic() ? TASTE_DULL : H.species.taste_sensitivity))

	var/list/out = list()
	var/list/tastes = list() //descriptor = strength
	if(minimum_percent <= 100)
		for(var/datum/reagent/R in reagent_list)
			if(!R.taste_mult)
				continue
			var/list/reagent_data = R.get_taste_data()
			if(!reagent_data)
				continue
			reagent_data = cached_json_decode(reagent_data)
			if(!islist(reagent_data) || !length(reagent_data))
				continue
			var/list/taste_data
			if(taster_species in reagent_data)
				taste_data = reagent_data[taster_species]
			else if(TASTE_STRING_DEFAULT in reagent_data)
				taste_data = reagent_data[TASTE_STRING_DEFAULT]
			else
				continue
			for(var/taste in taste_data)
				tastes[taste] += taste_data[taste]

		//deal with percentages
		var/total_taste = 0
		for(var/taste_desc in tastes)
			total_taste += tastes[taste_desc]
		for(var/taste_desc in tastes)
			var/percent = tastes[taste_desc]/total_taste * 100
			if(percent < minimum_percent)
				continue
			var/intensity_desc = "a hint of"
			if(percent > minimum_percent * 2 || percent == 100)
				intensity_desc = "the flavor of"
			else if(percent > minimum_percent * 3)
				intensity_desc = "the strong flavor of"
			out += "[intensity_desc] [taste_desc]"

	return english_list(out, "something indescribable")
