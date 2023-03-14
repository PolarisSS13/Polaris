/obj/item/paper/talisman/armor
	talisman_name = "Armor"
	talisman_desc = "Equips its invoker with a set of followers' armor, equivalent to the rune from which it was drawn."
	tome_desc = "Ditto."
	invocation = "Sa tatha najin!"

/obj/item/paper/talisman/armor/invoke(mob/living/user)
	user.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hooded/cult(user), slot_wear_suit)
	user.equip_to_slot_or_del(new /obj/item/clothing/shoes/cult(user), slot_shoes)
	user.equip_to_slot_or_del(new /obj/item/storage/backpack/cultpack(user), slot_back)
	var/datum/gender/G = gender_datums[user.get_visible_gender()]
	user.visible_message(
		SPAN_DANGER("\The [src] expands to briefly envelop \the [user]'s body before [G.he] tears through it in a gushing spurt of black sludge."),
		SPAN_NOTICE("The talisman expands to wrap you tightly, and you allow it to shroud you with tainted magmellite before you tear through the un-paper.")
	)
