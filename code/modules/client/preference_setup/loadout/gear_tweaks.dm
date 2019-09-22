/datum/gear_tweak/proc/get_contents(var/metadata)
	return

/datum/gear_tweak/proc/get_metadata(var/user, var/metadata)
	return

/datum/gear_tweak/proc/get_default()
	return

/datum/gear_tweak/proc/tweak_gear_data(var/metadata, var/datum/gear_data)
	return

/datum/gear_tweak/proc/tweak_item(var/obj/item/I, var/metadata)
	return

/*
* Color adjustment
*/

/datum/gear_tweak/color
	var/list/valid_colors

/datum/gear_tweak/color/New(var/list/valid_colors)
	src.valid_colors = valid_colors
	..()

/datum/gear_tweak/color/get_contents(var/metadata)
	return "Color: <font color='[metadata]'>&#9899;</font>"

/datum/gear_tweak/color/get_default()
	return valid_colors ? valid_colors[1] : COLOR_GRAY

/datum/gear_tweak/color/get_metadata(var/user, var/metadata, var/title = "Character Preference")
	if(valid_colors)
		return input(user, "Choose a color.", title, metadata) as null|anything in valid_colors
	return input(user, "Choose a color.", title, metadata) as color|null

/datum/gear_tweak/color/tweak_item(var/obj/item/I, var/metadata)
	if(valid_colors && !(metadata in valid_colors))
		return
	I.color = metadata

/*
* Path adjustment
*/

/datum/gear_tweak/path
	var/list/valid_paths

/datum/gear_tweak/path/New(var/list/valid_paths)
	src.valid_paths = valid_paths
	..()

/datum/gear_tweak/path/get_contents(var/metadata)
	return "Type: [metadata]"

/datum/gear_tweak/path/get_default()
	return valid_paths[1]

/datum/gear_tweak/path/get_metadata(var/user, var/metadata)
	return input(user, "Choose a type.", "Character Preference", metadata) as null|anything in valid_paths

/datum/gear_tweak/path/tweak_gear_data(var/metadata, var/datum/gear_data/gear_data)
	if(!(metadata in valid_paths))
		return
	gear_data.path = valid_paths[metadata]

/*
* Content adjustment
*/

/datum/gear_tweak/contents
	var/list/valid_contents

/datum/gear_tweak/contents/New()
	valid_contents = args.Copy()
	..()

/datum/gear_tweak/contents/get_contents(var/metadata)
	return "Contents: [english_list(metadata, and_text = ", ")]"

/datum/gear_tweak/contents/get_default()
	. = list()
	for(var/i = 1 to valid_contents.len)
		. += "Random"

/datum/gear_tweak/contents/get_metadata(var/user, var/list/metadata)
	. = list()
	for(var/i = metadata.len to valid_contents.len)
		metadata += "Random"
	for(var/i = 1 to valid_contents.len)
		var/entry = input(user, "Choose an entry.", "Character Preference", metadata[i]) as null|anything in (valid_contents[i] + list("Random", "None"))
		if(entry)
			. += entry
		else
			return metadata

/datum/gear_tweak/contents/tweak_item(var/obj/item/I, var/list/metadata)
	if(metadata.len != valid_contents.len)
		return
	for(var/i = 1 to valid_contents.len)
		var/path
		var/list/contents = valid_contents[i]
		if(metadata[i] == "Random")
			path = pick(contents)
			path = contents[path]
		else if(metadata[i] == "None")
			continue
		else
			path = 	contents[metadata[i]]
		new path(I)

/*
* Ragent adjustment
*/

/datum/gear_tweak/reagents
	var/list/valid_reagents

/datum/gear_tweak/reagents/New(var/list/reagents)
	valid_reagents = reagents.Copy()
	..()

/datum/gear_tweak/reagents/get_contents(var/metadata)
	return "Reagents: [metadata]"

/datum/gear_tweak/reagents/get_default()
	return "Random"

/datum/gear_tweak/reagents/get_metadata(var/user, var/list/metadata)
	. = input(user, "Choose an entry.", "Character Preference", metadata) as null|anything in (valid_reagents + list("Random", "None"))
	if(!.)
		return metadata

/datum/gear_tweak/reagents/tweak_item(var/obj/item/I, var/list/metadata)
	if(metadata == "None")
		return
	if(metadata == "Random")
		. = valid_reagents[pick(valid_reagents)]
	else
		. = valid_reagents[metadata]
	I.reagents.add_reagent(., I.reagents.get_free_space())


/*
		I have no idea what this does exactly or how it works, but goddamnit I'm gonna make it work.
																								-Tori -Also Nestor, but mostly Tori
*/

/datum/gear_tweak/polychrome
	var/primary
	var/secondary
	var/tertiary

/datum/gear_tweak/polychrome/New()
	src.primary = primary
	src.secondary = secondary
	src.tertiary = tertiary
	..()

/datum/gear_tweak/polychrome/get_contents(var/metadata)
	return "Colors: <font color='[primary]'>&#9899;</font> <font color='[secondary]'>&#9899;</font> <font color='[tertiary]'>&#9899;</font>"

/datum/gear_tweak/polychrome/get_metadata(var/user, var/list/metadata)
	. = list()
	var/primary_color_input = input(usr,"","Choose Primary Color",primary) as color|null	//color input menu, the "|null" adds a cancel button to it.
	if(primary_color_input)	//Checks if the color selected is NULL, rejects it if it is NULL.
		primary = sanitize_hexcolor(primary_color_input, primary)	//formats the selected color properly
		. += primary

	var/secondary_color_input = input(usr,"","Choose Secondary Color",secondary) as color|null
	if(secondary_color_input)
		secondary = sanitize_hexcolor(secondary_color_input, secondary)
		. += secondary

	var/tertiary_color_input = input(usr,"","Choose Tertiary Color",tertiary) as color|null
	if(tertiary_color_input)
		tertiary = sanitize_hexcolor(tertiary_color_input, tertiary)
		. += tertiary
	else return metadata

/datum/gear_tweak/polychrome/get_default()
	. = list()
	for(var/i in 1 to 3)
		. += "#000000"

/datum/gear_tweak/polychrome/tweak_item(var/obj/item/clothing/PC, var/list/metadata)
	PC.primary_color = metadata[1]
	PC.secondary_color = metadata[2]
	PC.tertiary_color = metadata[3]
	PC.update_icon()