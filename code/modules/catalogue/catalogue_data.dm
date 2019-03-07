GLOBAL_DATUM_INIT(catalogue_data, /datum/category_collection/catalogue, new)

// The collection holds everything together and is GLOB accessible.
/datum/category_collection/catalogue
	category_group_type = /datum/category_group/catalogue

/datum/category_collection/catalogue/proc/resolve_item(item_path)
	for(var/group in categories)
		var/datum/category_group/G = group

		var/datum/category_item/catalogue/C = item_path
		var/name_to_search = initial(C.name)
		if(G.items_by_name[name_to_search])
			return G.items_by_name[name_to_search]

	//	for(var/item in G.items)
	//		var/datum/category_item/I = item
	//		if(I.type == item_path)
	//			return I


// Groups act as sections for the different data.
/datum/category_group/catalogue

// Plants.
/datum/category_group/catalogue/flora
	name = "Flora"
	category_item_type = /datum/category_item/catalogue/flora

// Animals.
/datum/category_group/catalogue/fauna
	name = "Fauna"
	category_item_type = /datum/category_item/catalogue/fauna

// Gadgets, tech, and robots.
/datum/category_group/catalogue/technology
	name = "Technology"
	category_item_type = /datum/category_item/catalogue/technology

// Abstract information.
/datum/category_group/catalogue/information
	name = "Information"
	category_item_type = /datum/category_item/catalogue/information

// Weird stuff.
/datum/category_group/catalogue/anomalous
	name = "Anomalous"
	category_item_type = /datum/category_item/catalogue/anomalous

// Physical material things like crystals.
/datum/category_group/catalogue/material
	name = "Material"
	category_item_type = /datum/category_item/catalogue/material


// Items act as individual data for each object.
/datum/category_item/catalogue
	var/desc = null		// Paragraph or two about what the object is.
	var/value = 0		// How many 'exploration points' you get for scanning it. Suggested to use the CATALOGUER_REWARD_* defines for easy tweaking.
	var/visible = FALSE	// When someone scans the correct object, this gets set to TRUE and becomes viewable in the databanks.
	var/list/cataloguers = null // List of names of those who helped 'discover' this piece of data, in string form.
	var/list/unlocked_by_any = null // List of types that, if they are discovered, it will also make this datum discovered.
	var/list/unlocked_by_all = null // Similar to above, but all types on the list must be discovered for this to be discovered.

// Discovers a specific datum, and any datums associated with this datum by unlocked_by_[any|all].
// Returns null if nothing was found, otherwise returns a list of datum instances that was discovered, usually for the cataloguer to use.
/datum/category_item/catalogue/proc/discover(mob/user, list/new_cataloguers)
	if(visible) // Already found.
		return

	. = list(src)
	visible = TRUE
	cataloguers = new_cataloguers
	display_in_chatlog(user)
	. += attempt_chain_discoveries(user, new_cataloguers, type)

// Calls discover() on other datums if they include the type that was just discovered is inside unlocked_by_[any|all].
// Returns discovered datums.
/datum/category_item/catalogue/proc/attempt_chain_discoveries(mob/user, list/new_cataloguers, type_to_test)
	. = list()
	for(var/G in category.collection.categories) // I heard you like loops.
		var/datum/category_group/catalogue/group = G
		for(var/I in group.items)
			var/datum/category_item/catalogue/item = I
			// First, look for datums unlocked with the 'any' list.
			if(LAZYLEN(item.unlocked_by_any))
				for(var/T in item.unlocked_by_any)
					if(ispath(type_to_test, T) && item.discover(user, new_cataloguers))
						. += item

			// Now for the more complicated 'all' list.
			if(LAZYLEN(item.unlocked_by_all))
				if(type_to_test in item.unlocked_by_all)
					// Unlike the 'any' list, the 'all' list requires that all datums inside it to have been found first.
					var/should_discover = TRUE
					for(var/T in item.unlocked_by_all)
						var/datum/category_item/catalogue/thing = GLOB.catalogue_data.resolve_item(T)
						if(istype(thing))
							if(!thing.visible)
								should_discover = FALSE
								break
					if(should_discover && item.discover(user, new_cataloguers))
						. += item

/datum/category_item/catalogue/proc/display_in_chatlog(mob/user)
	to_chat(user, "<br>")
	to_chat(user, span("notice", "<b>[uppertext(name)]</b>"))

	// Some entries get very long so lets not totally flood the chatlog.
	var/desc_length_limit = 500
	var/displayed_desc = desc
	if(length(desc) > desc_length_limit)
		displayed_desc = copytext(displayed_desc, 1, desc_length_limit + 1)
		displayed_desc += "..."

	to_chat(user, span("notice", "<i>[displayed_desc]</i>"))
	to_chat(user, span("notice", "Cataloguers : <b>[english_list(cataloguers)]</b>."))
	to_chat(user, span("notice", "Contributes <b>[value]</b> points to personal exploration fund."))

/*
		// Truncates text to limit if necessary.
		var/size = length(message)
		if (size <= length)
			return message
		else
			return copytext(message, 1, length + 1)
*/

/datum/category_item/catalogue/flora

/datum/category_item/catalogue/fauna

/datum/category_item/catalogue/technology

/datum/category_item/catalogue/information

// For these we can piggyback off of the lore datums that are already defined and used in some places.
/datum/category_item/catalogue/information/organization
	value = CATALOGUER_REWARD_TRIVIAL
	var/datum_to_copy = null

/datum/category_item/catalogue/information/organization/New()
	..()
	if(datum_to_copy)
		// I'd just access the loremaster object but it might not exist because its ugly.
		var/datum/lore/organization/O = new datum_to_copy()
		// I would also change the name based on the org datum but changing the name messes up indexing in some lists in the category/collection object attached to us.

		// Now lets combine the data in the datum for a slightly more presentable entry.
		var/constructed_desc = ""

		if(O.motto)
			constructed_desc += "<center><b><i>\"[O.motto]\"</i></b></center><br><br>"

		constructed_desc += O.desc

		desc = constructed_desc
		qdel(O)

/datum/category_item/catalogue/information/organization/nanotrasen
	name = "TSC - NanoTrasen Incorporated"
	datum_to_copy = /datum/lore/organization/tsc/nanotrasen

/datum/category_item/catalogue/information/organization/hephaestus
	name = "TSC - Hephaestus Industries"
	datum_to_copy = /datum/lore/organization/tsc/hephaestus

/datum/category_item/catalogue/information/organization/vey_med
	name = "TSC - Vey-Medical"
	datum_to_copy = /datum/lore/organization/tsc/vey_med

/datum/category_item/catalogue/information/organization/zeng_hu
	name = "TSC - Zeng Hu Pharmaceuticals"
	datum_to_copy = /datum/lore/organization/tsc/zeng_hu

/datum/category_item/catalogue/information/organization/ward_takahashi
	name = "TSC - Ward-Takahashi General Manufacturing Conglomerate"
	datum_to_copy = /datum/lore/organization/tsc/ward_takahashi

/datum/category_item/catalogue/information/organization/bishop
	name = "TSC - Bishop Cybernetics"
	datum_to_copy = /datum/lore/organization/tsc/bishop

/datum/category_item/catalogue/information/organization/morpheus
	name = "TSC - Morpheus Cyberkinetics"
	datum_to_copy = /datum/lore/organization/tsc/morpheus

/datum/category_item/catalogue/information/organization/xion
	name = "TSC - Xion Manufacturing Group"
	datum_to_copy = /datum/lore/organization/tsc/xion

/datum/category_item/catalogue/information/organization/major_bills
	name = "TSC - Major Bill's Transportation"
	datum_to_copy = /datum/lore/organization/tsc/mbt


/datum/category_item/catalogue/information/organization/solgov
	name = "Government - Solar Confederate Government"
	datum_to_copy = /datum/lore/organization/gov/solgov

/datum/category_item/catalogue/information/organization/virgov
	name = "Government - Vir Governmental Authority"
	datum_to_copy = /datum/lore/organization/gov/virgov



/datum/category_item/catalogue/anomalous

/datum/category_item/catalogue/material
