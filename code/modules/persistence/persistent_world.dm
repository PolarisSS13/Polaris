
/proc/save_world()
	//saves all department accounts
	persistent_economy.save_economy()

	//save politics related data
	SSelections.save_data.save_candidates()

	//save news
	news_data.save_main_news()

	//save emails
	save_all_emails()

	//saves all characters
	for (var/mob/living/carbon/human/H in mob_list) //only humans, we don't really save AIs or robots.
		handle_jail(H)	// make sure the pesky criminals get what's coming to them.
		H.save_mob_to_prefs()

	return 1
