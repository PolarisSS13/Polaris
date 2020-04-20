//The base core object, worn on the wizard's back.
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
	var/energy = 10000
	var/max_energy = 10000
	var/regen_rate = 50				// 200 seconds to full
	var/energy_delta = 0			// How much we're gaining (or perhaps losing) every process().
	var/mob/living/wearer = null	// Reference to the mob wearing the core.
	var/instability_modifier = 0.8	// Multiplier on how much instability is added.
	var/energy_cost_modifier = 1.0	// Multiplier on how much spells will cost.
	var/spell_power_modifier = 1.0	// Multiplier on how strong spells are.
	var/cooldown_modifier 	 = 1.0	// Multiplier on cooldowns for spells.
	var/list/spells = list()		// This contains the buttons used to make spells in the user's hand.
	var/list/spell_metas = list()	// Assoc list containing `/datum/spell_metadata`s, with the path being the key, and the instance being the value.
	var/list/spell_catalog_entries_bought = list()
	var/list/appearances = list(	// Assoc list containing possible icon_states that the wiz can change the core to.
		"default"			= "technomancer_core",
		"wizard's cloak"	= "wizard_cloak"
		)

	// Some spell-specific variables go here, since spells themselves are temporary.  Cores are more long term and more accessable than \
	// mind datums.  It may also allow creative players to try to pull off a 'soul jar' scenario.
	var/list/summoned_mobs = list()	// Maintained horribly with maintain_summon_list().
	var/list/wards_in_use = list()	// Wards don't count against the cap for other summons.
	var/max_summons = 10			// Maximum allowed summoned entities.  Some cores will have different caps.

/obj/item/weapon/technomancer_core/New()
	..()
	START_PROCESSING(SSobj, src)

/obj/item/weapon/technomancer_core/Destroy()
	dismiss_all_summons()
	STOP_PROCESSING(SSobj, src)
	return ..()

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

// 'pay_energy' is too vague of a name for a proc at the mob level.
/mob/proc/technomancer_pay_energy(amount)
	return 0

/mob/living/carbon/human/technomancer_pay_energy(amount)
	if(istype(back, /obj/item/weapon/technomancer_core))
		var/obj/item/weapon/technomancer_core/TC = back
		return TC.pay_energy(amount)
	return 0

/obj/item/weapon/technomancer_core/proc/pay_energy(amount)
	amount = round(amount * energy_cost_modifier, 0.1)
	if(amount <= energy)
		energy = max(energy - amount, 0)
		return 1
	return 0

// Adds energy to the core.
// Returns how much energy was actually given. E.g. 9900/10000 would return 100 if 100 or more was given.
/obj/item/weapon/technomancer_core/proc/give_energy(amount)
	. = min(max_energy - energy, amount)
	energy = min(energy + amount, max_energy)

// Subtracts energy while ignoring any core modifiers.
// Also returns how much energy was actually taken.
/obj/item/weapon/technomancer_core/proc/drain_energy(amount)
	. = min(energy, amount)
	energy = between(0, energy - amount, max_energy)

/*
// recharge the cell
/obj/item/weapon/cell/proc/give(var/amount)
	if(rigged && amount > 0)
		explode()
		return 0

	if(maxcharge < amount)	return 0
	var/amount_used = min(maxcharge-charge,amount)
	charge += amount_used
	update_icon()
	if(loc)
		loc.update_icon()
	return amount_used

// use power from a cell, returns the amount actually used
/obj/item/weapon/cell/proc/use(var/amount)
	if(rigged && amount > 0)
		explode()
		return 0
	var/used = min(charge, amount)
	charge -= used
	last_use = world.time
	update_icon()
	return used
*/

/obj/item/weapon/technomancer_core/process()
	var/old_energy = energy
	regenerate()
	pay_dues()
	energy_delta = energy - old_energy
	if(world.time % 5 == 0) // Maintaining fat lists is expensive, I imagine.
		maintain_summon_list()
	if(wearer && wearer.mind)
		if(!(technomancers.is_antagonist(wearer.mind))) // In case someone tries to wear a stolen core.
			wearer.adjust_instability(20)
	if(!wearer || wearer.stat == DEAD) // Unlock if we're dead or not worn.
		canremove = TRUE

/obj/item/weapon/technomancer_core/proc/regenerate()
	energy = min(max(energy + regen_rate, 0), max_energy)
	if(wearer && ishuman(wearer))
		var/mob/living/carbon/human/H = wearer
		H.wiz_energy_update_hud()

// We pay for on-going effects here.
/obj/item/weapon/technomancer_core/proc/pay_dues()
	if(summoned_mobs.len)
		pay_energy( round(summoned_mobs.len * 5) )

// Because sometimes our summoned mobs will stop existing and leave a null entry in the list, we need to do cleanup every
// so often so .len remains reliable.
/obj/item/weapon/technomancer_core/proc/maintain_summon_list()
	if(!summoned_mobs.len) // No point doing work if there's no work to do.
		return
	for(var/A in summoned_mobs)
		// First, a null check.
		if(isnull(A))
			summoned_mobs -= A
			continue
		// Now check for dead mobs who shouldn't be on the list.
		if(istype(A, /mob/living))
			var/mob/living/L = A
			if(L.stat == DEAD)
				summoned_mobs -= L
				spawn(1)
					L.visible_message("<span class='notice'>\The [L] begins to fade away...</span>")
					animate(L, alpha = 255, alpha = 0, time = 30) // Makes them fade into nothingness.
					sleep(30)
					qdel(L)

// Deletes all the summons and wards from the core, so that Destroy() won't have issues.
/obj/item/weapon/technomancer_core/proc/dismiss_all_summons()
	for(var/mob/living/L in summoned_mobs)
		summoned_mobs -= L
		qdel(L)
	for(var/mob/living/ward in wards_in_use)
		wards_in_use -= ward
		qdel(ward)

// This is what is clicked on to place a spell in the user's hands.
/obj/spellbutton
	name = "generic spellbutton"
	var/spellpath = null
	var/obj/item/weapon/technomancer_core/core = null
	var/ability_icon_state = null
	var/spell_metadata_path = null

/obj/spellbutton/Initialize(new_loc, datum/spell_metadata/meta)
	name = meta.name
	spellpath = meta.spell_path
	core = new_loc
	ability_icon_state = meta.icon_state
	spell_metadata_path = meta.type
	return ..()

/obj/spellbutton/Destroy()
	core = null
	return ..()

/obj/spellbutton/Click()
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		var/obj/item/weapon/spell/technomancer/spell = H.place_spell_in_hand(spellpath)
		if(istype(spell))
			spell.spell_metadata_path = spell_metadata_path
			spell.new_spell_icon_visuals()
			spell.on_spell_given()

/obj/spellbutton/DblClick()
	return Click()

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

/obj/item/weapon/technomancer_core/proc/add_spell(datum/spell_metadata/meta)
	var/obj/spellbutton/spell_button = new(src, meta)
	spells += spell_button
	if(wearer)
		wearer.ability_master.add_technomancer_ability(spell_button, meta.icon_state)

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

/obj/item/weapon/technomancer_core/proc/get_spell_metadata(spell_meta_path)
	var/datum/spell_metadata/meta = spell_metas[spell_meta_path]
	if(!istype(meta))
		return FALSE
	return meta

/mob/living/carbon/human/proc/wiz_energy_update_hud()
	if(client && hud_used)
		if(istype(back, /obj/item/weapon/technomancer_core)) //I reckon there's a better way of doing this.
			var/obj/item/weapon/technomancer_core/core = back
			wiz_energy_display.invisibility = 0
			var/ratio = core.energy / core.max_energy
			ratio = max(round(ratio, 0.05) * 100, 5)
			wiz_energy_display.icon_state = "wiz_energy[ratio]"
		else
			wiz_energy_display.invisibility = 101

//Resonance Aperture

//Variants which the wizard can buy.

//High risk, high reward core.
/obj/item/weapon/technomancer_core/unstable
	name = "unstable core"
	desc = "A bewilderingly complex 'black box' that allows the wearer to accomplish amazing feats.  This one is rather unstable, \
	and could prove dangerous to the user, as it feeds off unstable energies that can occur with overuse of this machine."
	energy = 13000
	max_energy = 13000
	regen_rate = 35 //~371 seconds to full, 118 seconds to full at 50 instability (rate of 110)
	instability_modifier = 1.2
	energy_cost_modifier = 0.7
	spell_power_modifier = 1.1

/obj/item/weapon/technomancer_core/unstable/regenerate()
	var/instability_bonus = 0
	if(loc && ishuman(loc))
		var/mob/living/carbon/human/H = loc
		instability_bonus = H.instability * 1.5
	energy = min(energy + regen_rate + instability_bonus, max_energy)
	if(loc && ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.wiz_energy_update_hud()

//Lower capacity but safer core.
/obj/item/weapon/technomancer_core/rapid
	name = "rapid core"
	desc = "A bewilderingly complex 'black box' that allows the wearer to accomplish amazing feats.  This one has a superior \
	recharge rate, at the price of storage capacity.  It also includes integrated motion assistance, increasing agility somewhat."
	energy = 7000
	max_energy = 7000
	regen_rate = 70 //100 seconds to full
	slowdown = -1
	instability_modifier = 0.9
	cooldown_modifier = 0.9

//Big batteries but slow regen, buying energy spells is highly recommended.
/obj/item/weapon/technomancer_core/bulky
	name = "bulky core"
	desc = "A bewilderingly complex 'black box' that allows the wearer to accomplish amazing feats.  This variant is more \
	cumbersome and bulky, due to the additional energy capacitors installed, which allows for a massive energy storage, as well \
	as stronger function usage.  It also comes at a price of a subpar fractal \
	reactor."
	energy = 20000
	max_energy = 20000
	regen_rate = 25 //800 seconds to full
	slowdown = 1
	instability_modifier = 1.0
	spell_power_modifier = 1.4

// Using this can result in abilities costing less energy.  If you're lucky.
/obj/item/weapon/technomancer_core/recycling
	name = "recycling core"
	desc = "A bewilderingly complex 'black box' that allows the wearer to accomplish amazing feats.  This type tries to recover \
	some of the energy lost from using functions due to inefficiency."
	energy = 12000
	max_energy = 12000
	regen_rate = 40 //300 seconds to full
	instability_modifier = 0.6
	energy_cost_modifier = 0.8

/obj/item/weapon/technomancer_core/recycling/pay_energy(amount)
	var/success = ..()
	if(success)
		if(prob(30))
			give_energy(round(amount / 2))
			if(amount >= 50) // Managing to recover less than half of this isn't worth telling the user about.
				to_chat(wearer, "<span class='notice'>\The [src] has recovered [amount/2 >= 1000 ? "a lot of" : "some"] energy.</span>")
	return success

// For those dedicated to summoning hoards of things.
/obj/item/weapon/technomancer_core/summoner
	name = "summoner core"
	desc = "A bewilderingly complex 'black box' that allows the wearer to accomplish amazing feats.  This type is optimized for \
	plucking hapless creatures and machines from other locations, to do your bidding.  The maximum amount of entities that you can \
	bring over at once is higher with this core, up to 40 entities, and the maintenance cost is significantly lower."
	energy = 8000
	max_energy = 8000
	regen_rate = 35 //228 seconds to full
	max_summons = 40
	instability_modifier = 1.2
	spell_power_modifier = 1.2

/obj/item/weapon/technomancer_core/summoner/pay_dues()
	if(summoned_mobs.len)
		pay_energy( round(summoned_mobs.len) )

// For those who hate instability.
/obj/item/weapon/technomancer_core/safety
	name = "safety core"
	desc = "A bewilderingly complex 'black box' that allows the wearer to accomplish amazing feats.  This type is designed to be \
	the closest thing you can get to 'safe' for a Core.  Instability from this is significantly reduced.  You can even dance if \
	you want to, and leave your apprentice behind."
	energy = 7000
	max_energy = 7000
	regen_rate = 30 //233 seconds to full
	instability_modifier = 0.3
	spell_power_modifier = 0.7

// For those who want to blow everything on a few spells.
/obj/item/weapon/technomancer_core/overcharged
	name = "overcharged core"
	desc = "A bewilderingly complex 'black box' that allows the wearer to accomplish amazing feats.  This type will use as much \
	energy as it can in order to pump up the strength of functions used to insane levels."
	energy = 15000
	max_energy = 15000
	regen_rate = 40 //375 seconds to full
	instability_modifier = 1.1
	spell_power_modifier = 1.75
	energy_cost_modifier = 2.0

// For use only for the GOLEM.
/obj/item/weapon/technomancer_core/golem
	name = "integrated core"
	desc = "A bewilderingly complex 'black box' that allows the wearer to accomplish amazing feats.  This type is not meant \
	to be worn on the back like other cores.  Instead it is meant to be installed inside a synthetic shell.  As a result, it's \
	a lot more robust."
	energy = 25000
	max_energy = 25000
	regen_rate = 100 //250 seconds to full
	instability_modifier = 0.75


/obj/item/weapon/technomancer_core/verb/toggle_lock()
	set name = "Toggle Core Lock"
	set category = "Object"
	set desc = "Toggles the locking mechanism on your manipulation core."

	canremove = !canremove
	to_chat(usr, "<span class='notice'>You [canremove ? "de" : ""]activate the locking mechanism on \the [src].</span>")