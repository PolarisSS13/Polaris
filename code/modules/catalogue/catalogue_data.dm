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

/datum/category_group/catalogue/flora
	name = "Flora"
	category_item_type = /datum/category_item/catalogue/flora

/datum/category_group/catalogue/fauna
	name = "Fauna"
	category_item_type = /datum/category_item/catalogue/fauna

/datum/category_group/catalogue/technology
	name = "Technology"
	category_item_type = /datum/category_item/catalogue/technology

/datum/category_group/catalogue/anomalous
	name = "Anomalous"
	category_item_type = /datum/category_item/catalogue/anomalous



// Items act as individual data for each object.
/datum/category_item/catalogue
	var/desc = null		// Paragraph or two about what the object is.
	var/value = 0		// How many 'exploration points' you get for scanning it.
	var/visible = FALSE	// When someone scans the correct object, this gets set to TRUE and becomes viewable in the databanks.
	var/list/cataloguers = null // List of names of those who helped 'discover' this piece of data, in string form.
	var/list/unlocked_by_any = null // List of types that, if they are discovered, it will also make this datum discovered.
	var/list/unlocked_by_all = null // Similar to above, but all types on the list must be discovered for this to be discovered.

/datum/category_item/catalogue/proc/discover(mob/user, list/new_cataloguers)
	if(visible) // Already found.
		return FALSE

	visible = TRUE
	cataloguers = new_cataloguers
	display_in_chatlog(user)
	attempt_chain_discoveries(user, new_cataloguers, type)
	return TRUE

// Calls discover() on other datums if they include the type that was just discovered is inside unlocked_by_[any|all]().
/datum/category_item/catalogue/proc/attempt_chain_discoveries(mob/user, list/new_cataloguers, type_to_test)
	for(var/group in category.collection.categories) // I heard you like loops.
		var/datum/category_group/catalogue/G = group
		for(var/item in G.items)
			var/datum/category_item/catalogue/I = item
			// First, look for datums unlocked with the 'any' list.
			if(LAZYLEN(I.unlocked_by_any))
				for(var/t in I.unlocked_by_any)
					if(istype(t, type_to_test))
						I.discover(new_cataloguers)

			// Now for the more complicated 'all' list.
			if(LAZYLEN(I.unlocked_by_all))
				if(type_to_test in I.unlocked_by_all)
					// Unlike the 'any' list, the 'all' list requires that all datums inside it to have been found first.
					var/should_discover = TRUE
					for(var/t in I.unlocked_by_all)
						var/datum/category_item/catalogue/thing = GLOB.catalogue_data.resolve_item(t)
						if(istype(thing))
							if(!thing.visible)
								should_discover = FALSE
								break
					if(should_discover)
						I.discover(new_cataloguers)

/datum/category_item/catalogue/proc/display_in_chatlog(mob/user)
	to_chat(user, "<br>")
	to_chat(user, span("notice", "<b>[uppertext(name)]</b>"))
	to_chat(user, span("notice", "<i>[desc]</i>"))
	to_chat(user, span("notice", "Cataloguers : <b>[english_list(cataloguers)]</b>."))
	to_chat(user, span("notice", "Contributes <b>[value]</b> points to personal exploration fund."))

/datum/category_item/catalogue/flora

/datum/category_item/catalogue/fauna

/datum/category_item/catalogue/technology

/datum/category_item/catalogue/anomalous

// Datum that holds some values.
/datum/catalogue_data
	var/name = null // The identifier for what was just scanned, and is used to compare if something has been scanned before or not.
	var/desc = null // Some informative information and fluff about the thing that was just catalogued.
	var/value = 0 // How many points scanning this was worth.
	var/list/cataloguers = null // List of people's names who received credit for scanning.

/datum/catalogue_data/New(new_name, new_desc, new_value, list/new_cataloguers)
	if(new_name)
		name = new_name
		desc = new_desc
		value = new_value
	cataloguers = new_cataloguers

/datum/catalogue_data/proc/display_in_chatlog(mob/user)
	to_chat(user, "<br>")
	to_chat(user, span("notice", "<b>[uppertext(name)]</b>"))
	to_chat(user, span("notice", "<i>[desc]</i>"))
	to_chat(user, span("notice", "Cataloguers : <b>[english_list(cataloguers)]</b>."))
	to_chat(user, span("notice", "Contributes <b>[value]</b> points to personal exploration fund."))

// Pre-defined datums.

// Scanning any spider gives you this.
/datum/catalogue_data/giant_spiders
	name = "Giant Spiders"
	desc = "Giant Spiders are massive arachnids genetically descended from conventional Earth spiders, \
	however what caused ordinary arachnids to evolve into these are disputed. \
	Different initial species of spider have co-evolved and interbred to produce a robust biological caste system \
	capable of producing many varieties of giant spider. They are considered by most people to be a dangerous \
	invasive species, due to their hostility, venom, and high rate of reproduction. A strong resistance to \
	various poisons and toxins has been found, making it difficult to indirectly control their population."
	value = 10