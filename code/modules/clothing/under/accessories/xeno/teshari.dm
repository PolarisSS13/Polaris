/obj/item/clothing/accessory/scarf/teshari/neckscarf
	name = "small neckscarf"
	desc = "A neckscarf that is too small for a human's neck"
	icon_state = "tesh_neckscarf"
	species_restricted = list(SPECIES_TESHARI)

/obj/item/clothing/accessory/teshtail
	name = "teshari tail accessory master item"
	desc = "you shouldn't see this!"
	species_restricted = list(SPECIES_TESHARI)

/obj/item/clothing/accessory/teshtail/wrap
	name = "teshari tail wrap"
	desc = "A strip of cloth to decorate a teshari's tail."
	icon_state = "tailwrap"

/obj/item/clothing/accessory/teshtail/wrap/alt
	icon_state = "tailwrap2"

/obj/item/clothing/accessory/teshtail/wrap/long
	name = " long teshari tail wrap"
	icon_state = "tailwrap_long"

/obj/item/clothing/accessory/teshtail/bells
	name = "teshari tail bells"
	desc = "A set of lightweight, jangly tail bells."
	icon_state = "tailbells"
	gender = PLURAL
	var/static/list/dingaling_sound = list(
		'sound/misc/dingaling1.ogg',
		'sound/misc/dingaling2.ogg',
		'sound/misc/dingaling3.ogg',
		'sound/misc/dingaling4.ogg'
	)
	var/tmp/dingaling_volume = 260
	var/tmp/dingaling_chance = 30
	var/tmp/dingaling_vary = FALSE

/obj/item/clothing/accessory/teshtail/bells/is_mob_movement_sensitive()
	return TRUE

/obj/item/clothing/accessory/teshtail/bells/handle_movement()
	..()
	if(dingaling_sound && prob(dingaling_chance))
		if(islist(dingaling_sound) && length(dingaling_sound))
			playsound(get_turf(src), pick(dingaling_sound), dingaling_volume, dingaling_vary)
		else
			playsound(get_turf(src), dingaling_sound, dingaling_volume, dingaling_vary)

/obj/item/clothing/accessory/teshtail/bangle
	name = "teshari tail bangle, base"
	desc = "A loose fitting bangle to decorate a teshari's tail, this one sits near the base of the tail."
	icon_state = "tailbangle1"

/obj/item/clothing/accessory/teshtail/bangle/middle
	name = "teshari tail bangle, middle"
	desc = "A loose fitting bangle to decorate a teshari's tail, this one sits around the middle of the tail."
	icon_state = "tailbangle2"

/obj/item/clothing/accessory/teshtail/bangle/end
	name = "teshari tail bangle, end"
	desc = "A loose fitting bangle to decorate a teshari's tail, this one sits towards the end of the tail."
	icon_state = "tailbangle3"

/obj/item/clothing/accessory/teshtail/chains
	name = "teshari tail chains"
	desc = "Small connected chains for decorating a teshari's tail."
	icon_state = "tailchain"
	gender = PLURAL

/obj/item/clothing/accessory/teshtail/chains/dangle
	name = "dangling teshari tail chains"
	icon_state = "tailchain_dangle"

/obj/item/clothing/accessory/teshtail/chains/long
	name = "long teshari tail chains"
	icon_state = "tailchain_long"

/obj/item/clothing/accessory/teshtail/chains/longdangle
	name = "long dangling teshari tail chains"
	icon_state = "tailchain_longdangle"

/obj/item/clothing/accessory/teshtail/plumage
	name = "artifical tailplume"
	desc = "A set of tied together tail feathers for a teshari that has lost their real ones. Often used with prosthetic tails."
	icon_state = "tailplume"