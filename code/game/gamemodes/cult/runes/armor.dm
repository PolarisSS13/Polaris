/obj/effect/rune/armor
	rune_name = "Armor"
	rune_desc = "When this rune is invoked, either from a rune or a talisman, it will equip its invoker with protective robes. To use this rune to its fullest extent, make sure you are not wearing any form of armor or shoes."
	rune_shorthand = "Equips its invoker a set of protective but conspicuous robes. Any articles of clothing that cannot be equipped will not be created."
	talisman_path = /obj/item/paper/talisman/armor
	circle_words = list(CULT_WORD_HELL, CULT_WORD_DESTROY, CULT_WORD_SELF)
	invocation = "Sa tatha najin!"

/obj/effect/rune/armor/invoke(list/invokers)
	var/mob/living/L = invokers[1]
	L.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hooded/cult(L), slot_wear_suit)
	L.equip_to_slot_or_del(new /obj/item/clothing/shoes/cult(L), slot_shoes)
	L.equip_to_slot_or_del(new /obj/item/storage/backpack/cultpack(L), slot_back)
	var/datum/gender/G = gender_datums[L.get_visible_gender()]
	L.visible_message(
		SPAN_DANGER("The runes crawl onto [L]'s body as they expand to cocoon [G.him], before falling away and revealing [G.his] body once more in gushing spurts of black sludge."),
		SPAN_NOTICE("The runes wrap you tightly, and you allow them to shroud you with tainted magmellite before you cast them off as you would a cocoon.")
	)
	qdel(src)
