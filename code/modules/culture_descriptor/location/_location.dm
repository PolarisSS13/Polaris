/decl/cultural_info/location
	category = TAG_HOMEWORLD
	var/distance = 0
	var/ruling_body = "Other Faction"
	var/capital

	// Used by the random news generator. Populate with subtypes of /decl/location_event. 
	var/list/viable_random_events = list()
	var/list/viable_mundane_events = list()

/decl/cultural_info/location/get_text_details()
	. = list()
	if(!isnull(capital))
		. += "<b>Capital:</b> [capital]."
	if(!isnull(ruling_body))
		. += "<b>Territory:</b> [ruling_body]."
	if(!isnull(distance))
		. += "<b>Distance from Sol:</b> [distance]."
	. += ..()
