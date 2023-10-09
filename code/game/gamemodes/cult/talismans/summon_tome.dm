/obj/item/paper/talisman/summon_tome
	talisman_name = "Summon Tome"
	talisman_desc = "Manifests another copy of the Geometer's scripture."
	tome_desc = "Ditto."
	invocation = "N'ath reth sh'yro eth d'raggathnor!"

/obj/item/paper/talisman/summon_tome/invoke(mob/living/user)
	to_chat(user, SPAN_WARNING("You quietly congeal space into a blank book in your hand as the talisman's etchings slither into its pages."))
	user.drop_item()
	user.put_in_active_hand(new /obj/item/arcane_tome(get_turf(src)))
