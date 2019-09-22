////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	Polychromic Uniforms:																							 					  //
//																													 					  //
//		Polychromic clothes simply consist of 4 sprites: A base, unrecoloured sprite, and up to 3 greyscaled sprites. 					  //
//	In order to add more polychromic clothes, simply create a base sprite, and up to 3 recolourable overlays for it,  					  //
//	and then name them as follows: [name], [name]-primary, [name]-secondary, [name]-tertiary. The sprites should	  					  //
//	ideally be in 'modular_citadel/icons/polyclothes/item/uniform.dmi' and 'modular_citadel/icons/polyclothes/mob/uniform.dmi' for the	  //
//	worn sprites. After that, copy paste the code from any of the example clothes and 													  //
//	change the names around. [name] should go in BOTH icon_state and item_color. You can preset colors and disable	  					  //
//	any overlays using the self-explainatory vars.																	  					  //
//																													  					  //
//																								-Tori (Original Code by Toriate)			  					  //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/item/clothing/under/polychromic	//enables all three overlays to reduce copypasta and defines basic stuff
	name = "polychromic suit"
	desc = "For when you want to show off your horrible colour coordination skills."
	icon = 'icons/obj/clothing/polychromic_uniforms.dmi'
	icon_override = 'icons/mob/clothing/onmob/polychromic_uniforms.dmi'
	icon_state = "polysuit"
	item_color = "polysuit"
	item_state = "sl_suit"
	hasprimary = TRUE
	hassecondary = TRUE
	hastertiary = TRUE
	primary_color = "#FFFFFF" //RGB in hexcode
	secondary_color = "#FFFFFF"
	tertiary_color = "#808080"
	rolled_down = -1 //0 = unrolled, 1 = rolled, -1 = cannot be toggled
	rolled_sleeves = -1 //0 = unrolled, 1 = rolled, -1 = cannot be toggled
	sprite_sheets = null	//To prevent alternate species sprite sheets from popping up
	ispolychromic = 1
	/* Stuff from Cit
	mutantrace_variation = NO_MUTANTRACE_VARIATION // because I'm too lazy to port these to digi-compatible and to prove a point from /tg/ whining - Pooj
	suit_style = NORMAL_SUIT_STYLE
	*/

/obj/item/clothing/under/polychromic/get_mob_overlay(slot)	//this is where the main magic happens. Also mandates that ALL polychromic stuff MUST USE icon_override
	var/image/ret = ..()
	if(hasprimary | hassecondary | hastertiary)
		var/list/ret_overlays = list()
//		if(slot == slot_w_uniform_str)	// no need for this as it's already checked in the items.dm
		ret.icon_state = icon_state	//Because the callback at the start DOESN'T FUGGING WORK FOR WHATEVER REASON, we need to copypasta the base worn icon.
		if(hasprimary)	//checks if overlays are enabled
			var/mutable_appearance/primary_worn = mutable_appearance(icon_override, "[item_color]-primary")	//automagical sprite selection
			primary_worn.color = primary_color	//colors the overlay
			ret_overlays += primary_worn	//adds the overlay onto the buffer list to draw on the mob sprite.
		if(hassecondary)
			var/mutable_appearance/secondary_worn = mutable_appearance(icon_override, "[item_color]-secondary")
			secondary_worn.color = secondary_color
			ret_overlays += secondary_worn
		if(hastertiary)
			var/mutable_appearance/tertiary_worn = mutable_appearance(icon_override, "[item_color]-tertiary")
			tertiary_worn.color = tertiary_color
			ret_overlays += tertiary_worn
		ret.overlays += ret_overlays
	return ret

/obj/item/clothing/under/polychromic/apply_polychromic(var/image/standing)
	if(ispolychromic)
		standing.add_overlay(get_mob_overlay())

/obj/item/clothing/under/polychromic/shirt	//COPY PASTE THIS TO MAKE A NEW THING
	name = "polychromic button-up shirt"
	desc = "A fancy button-up shirt made with polychromic threads."
	icon_state = "polysuit"
	item_color = "polysuit"
	item_state = "sl_suit"
	primary_color = "#FFFFFF" //RGB in hexcode
	secondary_color = "#353535"
	tertiary_color = "#353535"

/obj/item/clothing/under/polychromic/kilt
	name = "polychromic kilt"
	desc = "It's not a skirt!"
	icon_state = "polykilt"
	item_color = "polykilt"
	item_state = "kilt"
	primary_color = "#FFFFFF" //RGB in hexcode
	secondary_color = "#F08080"
	hastertiary = FALSE // so it doesn't futz with digilegs
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/under/polychromic/skirt
	name = "polychromic skirt"
	desc = "A fancy skirt made with polychromic threads."
	icon_state = "polyskirt"
	item_color = "polyskirt"
	item_state = "rainbow"
	primary_color = "#FFFFFF" //RGB in hexcode
	secondary_color = "#F08080"
	tertiary_color = "#808080"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/under/polychromic/shorts
	name = "polychromic shorts"
	desc = "For ease of movement and style."
	icon_state = "polyshorts"
	item_color = "polyshorts"
	item_state = "rainbow"
	primary_color = "#353535" //RGB in hexcode
	secondary_color = "#808080"
	tertiary_color = "#808080"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/under/polychromic/jumpsuit
	name = "polychromic tri-tone jumpsuit"
	desc = "A fancy jumpsuit made with polychromic threads."
	icon_state = "polyjump"
	item_color = "polyjump"
	item_state = "rainbow"
	primary_color = "#FFFFFF" //RGB in hexcode
	secondary_color = "#808080"
	tertiary_color = "#FF3535"

/obj/item/clothing/under/polychromic/shortpants
	name = "polychromic athletic shorts"
	desc = "95% Polychrome, 5% Spandex!"
	icon_state = "polyshortpants"
	item_color = "polyshortpants"
	item_state = "rainbow"
	hastertiary = FALSE
	primary_color = "#FFFFFF" //RGB in hexcode
	secondary_color = "#F08080"
	gender = PLURAL	//Because shortS
	body_parts_covered = LOWER_TORSO	//Because there's no shirt included

/obj/item/clothing/under/polychromic/pleat
	name = "polychromic pleated skirt"
	desc = "A magnificent pleated skirt complements the woolen polychromatic sweater."
	icon_state = "polypleat"
	item_color = "polypleat"
	item_state = "rainbow"
	primary_color = "#8CC6FF" //RGB in hexcode
	secondary_color = "#808080"
	tertiary_color = "#FF3535"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/under/polychromic/femtank
	name = "polychromic feminine tank top"
	desc = "Great for showing off your chest in style. Not recommended for males."
	icon_state = "polyfemtankpantsu"
	item_color = "polyfemtankpantsu"
	item_state = "rainbow"
	hastertiary = FALSE
	primary_color = "#808080" //RGB in hexcode
	secondary_color = "#FF3535"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/under/polychromic/shortpants/pantsu
	name = "polychromic panties"
	desc = "Topless striped panties. Now with 120% more polychrome!"
	icon_state = "polypantsu"
	item_color = "polypantsu"
	item_state = "rainbow"
	hastertiary = FALSE
	primary_color = "#FFFFFF" //RGB in hexcode
	secondary_color = "#8CC6FF"
	body_parts_covered = LOWER_TORSO

/obj/item/clothing/under/polychromic/bottomless
	name = "polychromic bottomless shirt"
	desc = "Great for showing off your junk in dubious style."
	icon_state = "polybottomless"
	item_color = "polybottomless"
	item_state = "rainbow"
	hastertiary = FALSE
	primary_color = "#808080" //RGB in hexcode
	secondary_color = "#FF3535"
	body_parts_covered = UPPER_TORSO|ARMS	//Because there's no bottom included

/obj/item/clothing/under/polychromic/shimatank
	name = "polychromic tank top"
	desc = "For those lazy summer days."
	icon_state = "polyshimatank"
	item_color = "polyshimatank"
	item_state = "rainbow"
	primary_color = "#808080" //RGB in hexcode
	secondary_color = "#FFFFFF"
	tertiary_color = "#8CC6FF"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO