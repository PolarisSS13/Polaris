/atom
	var/catalogue_name = null // Name of the thing being catalogued, if it's different than the regular name.
	var/catalogue_desc = null // Information about what this is, shown after successfully scanning it with a cataloguer. Required to be scannable.
	var/catalogue_value = 0 // How many points explorers will receive for scanning it.
	var/catalogue_delay = 3 SECONDS // How long it take to scan.
	var/list/catalogue_bonus_data = null // List of additional /datum/catalogue_data types to add when scanned.
	var/list/catalogue_data = null // List of types of /datum/category_item/catalogue that should be 'unlocked' when scanned by a Cataloguer.

// Tests if something can be catalogued.
// If something goes wrong and a mob was supplied, the mob will be told why they can't catalogue it.
/atom/proc/can_catalogue(mob/user)
//	if(isnull(get_catalogue_desc()))
	if(!LAZYLEN(catalogue_data))
		to_chat(user, span("warning", "\The [src] is not interesting enough to catalogue."))
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

// Override these for special behaviour, like human species.
/atom/proc/get_catalogue_name()
	return catalogue_name ? catalogue_name : name

// This attaches the classification to the title.
/mob/living/simple_mob/get_catalogue_name()
	return "[..()][tt_desc ? " ([tt_desc])" : ""]"

// Humans get their species displayed instead of their individual names.
/mob/living/carbon/human/get_catalogue_name()
	return species.name


/atom/proc/get_catalogue_desc()
	return catalogue_desc

/mob/living/carbon/human/get_catalogue_desc()
	return species.blurb


/atom/proc/get_catalogue_value()
	return catalogue_value

/mob/living/carbon/human/get_catalogue_value()
	return species.catalogue_value


/atom/proc/get_catalogue_delay()
	return catalogue_delay