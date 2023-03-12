/obj/effect/newrune/armor
	rune_name = "Armor"
	rune_desc = "When this rune is invoked, either from a rune or a talisman, it will equip its invoker with the armor of the followers of Nar-Sie. To use this rune to its fullest extent, make sure you are not wearing any form of headgear, armor, gloves or shoes, and make sure you are not holding anything in your hands."
	rune_shorthand = "Creates and equips a set of protective robes as well as a sword."
	talisman_path = /obj/item/paper/newtalisman/armor
	circle_words = list(CULT_WORD_HELL, CULT_WORD_DESTROY, CULT_WORD_OTHER)
	invocation = "Sa tatha najin!"

/obj/effect/newrune/armor/invoke(list/invokers)
	var/mob/living/L = invokers[1]
	L.equip_to_slot_or_del(new /obj/item/clothing/head/culthood/alt(L), slot_head)
	L.equip_to_slot_or_del(new /obj/item/clothing/suit/cultrobes/alt(L), slot_wear_suit)
	L.equip_to_slot_or_del(new /obj/item/clothing/shoes/cult(L), slot_shoes)
	L.equip_to_slot_or_del(new /obj/item/storage/backpack/cultpack(L), slot_back)
	L.put_in_hands(new /obj/item/melee/cultblade(L))
	var/datum/gender/G = gender_datums[L.get_visible_gender()]
	L.visible_message(
		SPAN_DANGER("The runes crawl onto [L]'s body as they expand to cocoon [G.him], before falling away and revealing [G.his] body once more in gushing spurts of black sludge."),
		SPAN_DANGER("The runes wrap you tightly, and you allow them to shroud you with tainted magmellite before you cast them off as you would a cocoon.")
	)
	qdel(src)
