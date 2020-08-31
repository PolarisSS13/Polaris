//Switch to taur sprites if a taur equips
/obj/item/clothing/suit
	var/taurized = FALSE //Easier than trying to 'compare icons' to see if it's a taur suit
//	sprite_sheets = list(
//		SPECIES_TESHARI = 'icons/mob/species/seromi/suit.dmi',
//		SPECIES_VOX = 'icons/mob/species/vox/suit.dmi',
//		SPECIES_WEREBEAST = 'icons/mob/species/werebeast/suit.dmi')

/obj/item/clothing/suit/equipped(var/mob/user, var/slot)
	var/normalize = TRUE

	//Pyramid of doom-y. Improve somehow?
	if(!taurized && slot == slot_wear_suit && ishuman(user))
		var/mob/living/carbon/human/H = user
		if(isTaurTail(H.tail_style))
			var/datum/sprite_accessory/tail/taur/taurtail = H.tail_style
			if(taurtail.suit_sprites && (get_worn_icon_state(slot_wear_suit_str) in cached_icon_states(taurtail.suit_sprites)))
				icon_override = taurtail.suit_sprites
				normalize = FALSE
				taurized = TRUE

	if(normalize && taurized)
		icon_override = initial(icon_override)
		taurized = FALSE

	return ..()

// Taur suits need to be shifted so its centered on their taur half.
/obj/item/clothing/suit/make_worn_icon(var/body_type,var/slot_name,var/inhands,var/default_icon,var/default_layer = 0,var/icon/clip_mask)
	var/image/standing = ..()
	if(taurized) //Special snowflake var on suits
		standing.pixel_x = -16
		standing.layer = BODY_LAYER + 15 // 15 is above tail layer, so will not be covered by taurbody.
	return standing

/obj/item/clothing/suit/apply_accessories(var/image/standing)
	if(LAZYLEN(accessories) && taurized)
		for(var/obj/item/clothing/accessory/A in accessories)
			var/image/I = new(A.get_mob_overlay())
			I.pixel_x = 16 //Opposite of the pixel_x on the suit (-16) from taurization to cancel it out and puts the accessory in the correct place on the body.
			standing.add_overlay(I)
	else
		return ..()