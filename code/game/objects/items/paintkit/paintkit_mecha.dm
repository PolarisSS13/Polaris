/obj/item/kit/paint
	name = "mecha customisation kit"
	desc = "A kit containing all the needed tools and parts to repaint a mech."
	accepted_refit_types = list(/obj/mecha)
	var/list/accepted_base_icon_states = list()
	var/removable = null

/obj/item/kit/paint/can_customize(var/mob/user, var/obj/I)
	. = ..()
	if(!.)
		return
	var/obj/mecha/M = I
	if(M.occupant)
		to_chat(user, SPAN_WARNING("You can't customize a mech while someone is piloting it - that would be unsafe!"))
		return FALSE
	if(length(accepted_base_icon_states))
		. = FALSE
		for(var/base_icon_type in accepted_base_icon_states)
			if(base_icon_type == M.initial_icon)
				. = TRUE
				break
		if(!. && user)
			to_chat(user, SPAN_WARNING("That kit isn't meant for use on this class of exosuit."))

/obj/item/kit/paint/show_customization_message(var/mob/user, var/obj/I, var/old_name)
	user.visible_message("\The [user] opens \the [src] and spends some quality time customising \the [old_name].")

/obj/item/kit/paint/set_info(var/kit_name, var/kit_desc, var/kit_icon, var/kit_icon_file = CUSTOM_ITEM_OBJ, var/kit_icon_override_file = CUSTOM_ITEM_MOB, var/additional_data)
	..()
	accepted_base_icon_states = splittext(additional_data, ", ")

/obj/item/kit/paint/examine()
	. = ..()
	. += "This kit will convert an exosuit into: [new_name]."
	. += "This kit can be used on the following exosuit models:"
	for(var/exotype in accepted_base_icon_states)
		. += "- [capitalize(exotype)]"

//Ripley APLU kits.
/obj/item/kit/paint/ripley
	name = "\"Classic\" APLU customisation kit"
	new_name = "APLU \"Classic\""
	new_desc = "A very retro APLU unit; didn't they retire these back in 2543?"
	new_icon = "ripley-old"
	accepted_base_icon_states = list("ripley")

/obj/item/kit/paint/ripley/death
	name = "\"Reaper\" APLU customisation kit"
	new_name = "APLU \"Reaper\""
	new_desc = "A terrifying, grim power loader. Why do those clamps have spikes?"
	new_icon = "deathripley"
	accepted_base_icon_states = list("ripley","firefighter")

/obj/item/kit/paint/ripley/flames_red
	name = "\"Firestarter\" APLU customisation kit"
	new_name = "APLU \"Firestarter\""
	new_desc = "A standard APLU exosuit with stylish orange flame decals."
	new_icon = "ripley_flames_red"

/obj/item/kit/paint/ripley/flames_blue
	name = "\"Burning Chrome\" APLU customisation kit"
	new_name = "APLU \"Burning Chrome\""
	new_desc = "A standard APLU exosuit with stylish blue flame decals."
	new_icon = "ripley_flames_blue"

// Durand kits.
/obj/item/kit/paint/durand
	name = "\"Classic\" Durand customisation kit"
	new_name = "Durand \"Classic\""
	new_desc = "An older model of Durand combat exosuit. This model was retired for rotating a pilot's torso 180 degrees."
	new_icon = "old_durand"
	accepted_base_icon_states = list("durand")

/obj/item/kit/paint/durand/seraph
	name = "\"Cherubim\" Durand customisation kit"
	new_name = "Durand \"Cherubim\""
	new_desc = "A Durand combat exosuit modelled after ancient Earth entertainment. Your heart goes doki-doki just looking at it."
	new_icon = "old_durand"

/obj/item/kit/paint/durand/phazon
	name = "\"Sypher\" Durand customisation kit"
	new_name = "Durand \"Sypher\""
	new_desc = "A Durand combat exosuit with some very stylish neons and decals. Seems to blur slightly at the edges; probably an optical illusion."
	new_icon = "phazon"

// Gygax kits.
/obj/item/kit/paint/gygax
	name = "\"Jester\" Gygax customisation kit"
	new_name = "Gygax \"Jester\""
	new_desc = "A Gygax exosuit modelled after the infamous combat-troubadors of Earth's distant past. Terrifying to behold."
	new_icon = "honker"
	accepted_base_icon_states = list("gygax")

/obj/item/kit/paint/gygax/darkgygax
	name = "\"Silhouette\" Gygax customisation kit"
	new_name = "Gygax \"Silhouette\""
	new_desc = "An ominous Gygax exosuit modelled after the fictional corporate 'death squads' that were popular in pulp action-thrillers back in 2554."
	new_icon = "darkgygax"

/obj/item/kit/paint/gygax/recitence
	name = "\"Gaoler\" Gygax customisation kit"
	new_name = "Durand \"Gaoler\""
	new_desc = "A bulky silver Gygax exosuit. The extra armour appears to be painted on, but it's very shiny."
	new_icon = "recitence"
