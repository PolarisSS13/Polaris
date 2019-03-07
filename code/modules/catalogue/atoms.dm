/atom
	var/catalogue_delay = 3 SECONDS // How long it take to scan.
	// List of types of /datum/category_item/catalogue that should be 'unlocked' when scanned by a Cataloguer.
	// It is null by default to save memory by not having everything hold onto empty lists. Use macros like LAZYLEN() to check this var.
	var/list/catalogue_data = null

/mob
	catalogue_delay = 10 SECONDS

// Tests if something can be catalogued.
// If something goes wrong and a mob was supplied, the mob will be told why they can't catalogue it.
/atom/proc/can_catalogue(mob/user)
	// First check if anything is even on here.
	if(!LAZYLEN(catalogue_data))
		to_chat(user, span("warning", "\The [src] is not interesting enough to catalogue."))
		return FALSE
	else
		// Check if this has nothing new on it.
		var/has_new_data = FALSE
		for(var/t in catalogue_data)
			var/datum/category_item/catalogue/item = GLOB.catalogue_data.resolve_item(t)
			if(!item.visible)
				has_new_data = TRUE
				break

		if(!has_new_data)
			to_chat(user, span("warning", "Scanning \the [src] would provide no new information."))
			return FALSE

	return TRUE

/mob/living/can_catalogue(mob/user) // Dead mobs can't be scanned.
	if(stat >= DEAD)
		to_chat(user, span("warning", "Entities must be alive for a comprehensive scan."))
		return FALSE
	return ..()

/obj/item/can_catalogue(mob/user) // Items must be identified to be scanned.
	if(!is_identified())
		to_chat(user, span("warning", "The properties of this object has not been determined. Identify it first."))
		return FALSE
	return ..()

/atom/proc/get_catalogue_delay()
	return catalogue_delay
