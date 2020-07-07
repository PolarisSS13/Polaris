// The base core object, worn on the wizard's back.
// Without it, they're powerless.

/obj/item/weapon/technomancer_core
	name = "manipulation core"
	desc = "A bewilderingly complex 'black box' that allows the wearer to accomplish amazing feats."
	icon = 'icons/obj/technomancer.dmi'
	icon_state = "technomancer_core"
	item_state = "technomancer_core"
	w_class = ITEMSIZE_HUGE
	slot_flags = SLOT_BACK
	unacidable = 1
	origin_tech = list(
		TECH_MATERIAL = 8, TECH_ENGINEERING = 8, TECH_POWER = 8, TECH_BLUESPACE = 10,
		TECH_COMBAT = 7, TECH_MAGNET = 9, TECH_DATA = 5
		)
	sprite_sheets = list(
		"Teshari" = 'icons/mob/species/seromi/back.dmi'
		)
	var/desc_to_append = null // Some more text to add to the description on init, to avoid copypasta.
	var/mob/living/wearer = null	// Reference to the mob wearing the core.

	var/instability_modifier = 0.8	// Multiplier on how much instability is added.
	var/energy_cost_modifier = 1.0	// Multiplier on how much spells will cost.
	var/spell_power_modifier = 1.0	// Multiplier on how strong spells are.
	var/cooldown_modifier 	 = 1.0	// Multiplier on cooldowns for spells.

	var/list/spells = list()		// This contains the button objects used to make spells in the user's hand.
	var/list/spell_metas = list()	// Assoc list containing `/datum/spell_metadata`s, with the path being the key, and the instance being the value.
	var/list/spell_catalog_entries_bought = list()	// Used by the catalog object to prevent buying the same entry twice.
													// Some entries have duplicate spells, but that's allowed (yet doesn't do anything).

/obj/item/weapon/technomancer_core/Initialize(mapload)
	if(desc_to_append)
		desc = initial(desc) + desc_to_append
	START_PROCESSING(SSobj, src)
	return ..()

/obj/item/weapon/technomancer_core/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/mob/living/carbon/human/Stat()
	. = ..()
	if(. && istype(back,/obj/item/weapon/technomancer_core))
		var/obj/item/weapon/technomancer_core/core = back
		setup_technomancer_stat(core)

/mob/living/carbon/human/proc/setup_technomancer_stat(var/obj/item/weapon/technomancer_core/core)
	if(core && statpanel("Spell Core"))
		var/charge_status = "[core.energy]/[core.max_energy] ([round( (core.energy / core.max_energy) * 100)]%) \
		([round(core.energy_delta)]/s)"
		var/instability_delta = instability - last_instability
		var/instability_status = "[src.instability] ([round(instability_delta, 0.1)]/s)"
		stat("Core charge", charge_status)
		stat("User instability", instability_status)
		for(var/obj/spellbutton/button in core.spells)
			stat(button)


/obj/item/weapon/technomancer_core/Initialize()
	add_inventory_overlay("[canremove ? "un" : ""]locked_overlay")
	return ..()

/obj/item/weapon/technomancer_core/verb/toggle_lock()
	set name = "Toggle Core Lock"
	set category = "Object"
	set desc = "Toggles the locking mechanism on your manipulation core."

	canremove = !canremove
	remove_inventory_overlay("[canremove ? "" : "un"]locked_overlay")
	add_inventory_overlay("[canremove ? "un" : ""]locked_overlay")

	to_chat(usr, span("notice", "You [canremove ? "de" : ""]activate the locking mechanism on \the [src]."))
	playsound(src, 'sound/effects/seatbelt.ogg', 50, TRUE)