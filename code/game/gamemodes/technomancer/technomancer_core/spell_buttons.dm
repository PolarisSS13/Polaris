// Contains awful code made many years ago that makes the spell button HUDs on the top right of the screen work.


// This is what is clicked on to place a spell in the user's hands.
// In the stat panel, this object is clicked directly, while the HUD buttons redirect the click to this object.
/obj/spellbutton
	name = "generic spellbutton"
	var/spellpath = null
	var/obj/item/weapon/technomancer_core/core = null
	var/ability_icon_state = null
	var/spell_metadata_path = null

/obj/spellbutton/Initialize(mapload, datum/spell_metadata/meta)
	core = loc
	name = meta.name
	spellpath = meta.spell_path
	ability_icon_state = meta.icon_state
	spell_metadata_path = meta.type
	return ..()

/obj/spellbutton/Destroy()
	core = null
	return ..()

/obj/spellbutton/Click()
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		var/obj/item/weapon/spell/technomancer/spell = H.place_spell_in_hand(spellpath, core.spell_metas[spell_metadata_path])
		if(istype(spell) && !QDELETED(spell))
			spell.on_spell_given(usr)

/obj/spellbutton/DblClick()
	return Click()


// Adds a new button for a spell, used by the catalog object when buying spells.
// Don't call this directly.
/obj/item/weapon/technomancer_core/proc/add_spell(datum/spell_metadata/meta)
	var/obj/spellbutton/spell_button = new(src, meta)
	spells += spell_button
	if(wearer)
		wearer.ability_master.add_technomancer_ability(spell_button, meta.icon_state)

// Ditto, but removes a spell.
/obj/item/weapon/technomancer_core/proc/remove_spell(var/obj/spellbutton/spell_to_remove)
	if(spell_to_remove in spells)
		spells.Remove(spell_to_remove)
		if(wearer)
			var/obj/screen/ability/obj_based/technomancer/A = wearer.ability_master.get_ability_by_instance(spell_to_remove)
			if(A)
				wearer.ability_master.remove_ability(A)
		qdel(spell_to_remove)

/obj/item/weapon/technomancer_core/proc/remove_all_spells()
	for(var/obj/spellbutton/spell in spells)
		spells.Remove(spell)
		qdel(spell)


// Add the spell buttons to the HUD.
/obj/item/weapon/technomancer_core/equipped(mob/user)
	wearer = user
	for(var/obj/spellbutton/spell in spells)
		wearer.ability_master.add_technomancer_ability(spell, spell.ability_icon_state)
	..()

// Removes the spell buttons from the HUD.
/obj/item/weapon/technomancer_core/dropped(mob/user)
	for(var/obj/screen/ability/obj_based/technomancer/A in wearer.ability_master.ability_objects)
		wearer.ability_master.remove_ability(A)
	wearer = null
	..()