/datum/species
	var/list/default_emotes = list()

/mob/living/carbon/update_emotes(var/skip_sort)
	. = ..(skip_sort = TRUE)
	if(species)
		for(var/emote in species.default_emotes)
			var/datum/emote/emote_datum = GLOB.emotes_by_type[emote]
			if(emote_datum.check_user(src))
				usable_emotes[emote_datum.key] = emote_datum
	if(!skip_sort)
		usable_emotes = sortAssoc(usable_emotes)
