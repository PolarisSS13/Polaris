var/list/trait_datums = list() // Assoc list using name = instance.  Traits are saved as a list of strings.
var/list/trait_type_to_ref = list() // Similar to above but uses paths, which is more reliable but more risky to save.

/hook/startup/proc/populate_trait_list()

	//create a list of trait datums
	for(var/trait_type in typesof(/datum/trait) - list(/datum/trait, /datum/trait/modifier))
		var/datum/trait/T = new trait_type


		if(!T.name)
			error("Trait Menu - Missing name: [T]")
			continue

		trait_datums[T.name] = T
		trait_type_to_ref[T.type] = T

	return 1

/datum/category_item/player_setup_item/traits
	name = "Traits"
	sort_order = 1

/datum/category_item/player_setup_item/loadout/load_character(var/savefile/S)
	S["traits"] >> pref.traits

/datum/category_item/player_setup_item/loadout/save_character(var/savefile/S)
	S["traits"] << pref.traits


/datum/category_item/player_setup_item/traits/content()
	. = list()

	. += "<tr><td colspan=3><hr></td></tr>"
	. += "<tr><td colspan=3><b><center>Traits</center></b></td></tr>"
	. += "<tr><td colspan=3><hr></td></tr>"

	for(var/trait_name in trait_datums)
		var/datum/trait/T = trait_datums[trait_name]
		var/ticked = (T.name in pref.traits)
		var/style_class
		if(!T.validate(pref.traits))
			style_class = "linkOff"
		else if(ticked)
			style_class = "linkOn"
		. += "<tr style='vertical-align:top;'><td width=25%><div align='center'><a style='white-space:normal;' [style_class ? "class='[style_class]' " : ""]href='?src=\ref[src];toggle_trait=[html_encode(T.name)]'>[T.name]</a></div></td>"
//		. += "<td width = 10% style='vertical-align:top'>[G.cost]</td>"
		. += "<td width = 75%><font size=2><i>[T.desc]</i></font></td></tr>"
//		if(ticked)
//			. += "<tr><td colspan=3>"
//			for(var/datum/gear_tweak/tweak in G.gear_tweaks)
//				. += " <a href='?src=\ref[src];gear=[G.display_name];tweak=\ref[tweak]'>[tweak.get_contents(get_tweak_metadata(G, tweak))]</a>"
//			. += "</td></tr>"
	. += "</table>"
	. = jointext(., null)

/datum/category_item/player_setup_item/traits/sanitize_character()
	var/mob/preference_mob = preference_mob()
	if(!islist(pref.traits))
		pref.traits = list()

	for(var/trait_name in pref.traits)
		if(!(trait_name in trait_datums))
			pref.traits -= trait_name

	for(var/trait_name in pref.traits)
		if(!trait_datums[trait_name])
			preference_mob << "<span class='warning'>You cannot have more than one of trait: [trait_name]</span>"
			pref.traits -= trait_name
		else
			var/datum/trait/T = trait_datums[trait_name]
			var/invalidity = T.test_for_invalidity()
			if(invalidity)
				pref.traits -= trait_name
				preference_mob << "<span class='warning'>You cannot take the [trait_name] trait.  Reason: [invalidity]</span>"

			var/conflicts = T.test_for_trait_conflict(pref.traits)
			if(conflicts)
				pref.traits -= trait_name
				to_chat(preference_mob, "<span class='warning'>The [trait_name] trait is muturally exclusive with [conflicts].</span>")

/datum/category_item/player_setup_item/traits/OnTopic(href, href_list, user)
	if(href_list["toggle_trait"])
		var/datum/trait/T = trait_datums[href_list["toggle_trait"]]
		if(T.name in pref.traits)
			pref.traits -= T.name
		else
			var/invalidity = T.test_for_invalidity()
			if(invalidity)
				user << "<span class='warning'>You cannot take the [T.name] trait.  Reason: [invalidity]</span>"
				return TOPIC_NOACTION

			var/conflicts = T.test_for_trait_conflict(pref.traits)
			if(conflicts)
				to_chat(user, "<span class='warning'>The [T.name] trait is muturally exclusive with [conflicts].</span>")
				return TOPIC_NOACTION

			pref.traits += T.name
		return TOPIC_REFRESH_UPDATE_PREVIEW
	return ..()


/datum/trait
	var/name = "I'm bugged!"							// Name to show on UI
	var/desc = "If you can read this, something broke."	// Description of what it does, also shown on UI.
	var/list/muturally_exclusive = list()				// List of trait types which cannot be taken alongside this trait.

// Applies effects to the newly spawned mob.
/datum/trait/proc/apply_trait_post_spawn(var/mob/living/L)
	return

// Used to forbid a trait based on certain criteria (e.g. if they are an FBP).
// Returns a string explaining why the trait is invalid.  Returns null if valid.
/datum/trait/proc/test_for_invalidity()
	return null

// Checks muturally_exclusive.  current_traits needs to be a list of strings.
// Returns null if everything is well, similar to the above proc.  Otherwise returns an english_list() of conflicting traits.
/datum/trait/proc/test_for_trait_conflict(var/list/current_traits)
	var/list/conflicts = list()
	var/result

	if(muturally_exclusive.len)
		for(var/trait_name in current_traits)
			var/datum/trait/T = trait_datums[trait_name]
			if(T.type in muturally_exclusive)
				conflicts.Add(T.name)

	if(conflicts.len)
		result = english_list(conflicts)

	return result

// Similar to above, but uses the above two procs, in one place.
// Returns TRUE is everything is well.
/datum/trait/proc/validate(var/list/current_traits)
	if(test_for_invalidity())
		return FALSE
	if(test_for_trait_conflict(current_traits))
		return FALSE
	return TRUE


/mob/living/proc/apply_traits()
	if(!mind || !mind.traits || !mind.traits.len)
		return
	for(var/trait in mind.traits)
		var/datum/trait/T = trait_datums[trait]
		if(istype(T))
			T.apply_trait_post_spawn(src)