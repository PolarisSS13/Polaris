
/obj/item/device/crystalball
	name = "glass ball"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "crystalball"
	item_state = "electronic"
	desc = "A perfectly smooth, glass ball."
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 4, TECH_ARCANE = 1)

	var/list/spells = list()

	var/mob/living/wearer = null

	var/networked = FALSE	// Is this spell focus linkable to a specific network? (Default Global)
	var/weakref/bnetref = null

	var/crude = TRUE	// Can this spell focus be used by non-cultists, albeit ineffectively?

	var/efficiency = 2	// Multiplier for spell costs.

	toolspeed = 2

/obj/item/device/crystalball/Initialize()
	..()

	if(networked)
		bnetref = weakref(GLOB.blood_networks[CULT_BLOODNETWORK_GLOBAL])

/obj/item/device/crystalball/Destroy()
	if(bnetref)
		bnetref = null
	remove_all_spells()
	..()

/obj/item/device/crystalball/attackby(obj/item/W as obj, mob/user as mob)
	if(iscultist(user) && networked && istype(W, /obj/item/weapon/material/kitchen/utensil/fork/tuning))
		if(do_after(user, 5 SECONDS * W.toolspeed * toolspeed, src))
			var/datum/bloodnet/BN = bnetref.resolve()
			if(BN == GLOB.blood_networks[CULT_BLOODNETWORK_GLOBAL] || BN != user.getBloodnet())
				var/datum/bloodnet/usernet = user.getBloodnet()
				if(usernet)
					bnetref = weakref(usernet)
					to_chat(user, "<span class='cult'>You change \the [src]'s network to yours.</span>")
			else if(BN == user.getBloodnet())
				bnetref = weakref(GLOB.blood_networks[CULT_BLOODNETWORK_GLOBAL])
				to_chat(user, "<span class='cult'>You change \the [src]'s network to the universal flow.</span>")
			return

	return ..()

/obj/item/device/crystalball/proc/getBloodnet()
	if(bnetref)
		return bnetref.resolve()

	return FALSE

/*
 * This is where Mechoid goes to die.
 */

/obj/item/device/crystalball/equipped(mob/user)
	wearer = user
	for(var/obj/spellbutton/spell in spells)
		wearer.ability_master.add_cultist_ability(spell, spell.ability_icon_state)
	..()

/obj/item/device/crystalball/dropped(mob/user)
	if(wearer)
		for(var/obj/screen/ability/obj_based/cultist/A in wearer.ability_master.ability_objects)
			wearer.ability_master.remove_ability(A)
		wearer = null
	..()

/obj/item/device/crystalball/proc/add_spell(var/path, var/new_name, var/ability_icon_state)
	if(!path || !ispath(path))
		message_admins("ERROR: /obj/item/device/crystalball/add_spell() was not given a proper path!  \
		The path supplied was [path].")
		return
	var/obj/spellbutton/spell = new(src, path, new_name, ability_icon_state)
	spells.Add(spell)
	if(wearer)
		wearer.ability_master.add_cultist_ability(spell, ability_icon_state)

/obj/item/device/crystalball/proc/remove_spell(var/obj/spellbutton/spell_to_remove)
	if(spell_to_remove in spells)
		spells.Remove(spell_to_remove)
		if(wearer)
			var/obj/screen/ability/obj_based/cultist/A = wearer.ability_master.get_ability_by_instance(spell_to_remove)
			if(A)
				wearer.ability_master.remove_ability(A)
		qdel(spell_to_remove)

/obj/item/device/crystalball/proc/remove_all_spells()
	for(var/obj/spellbutton/spell in spells)
		spells.Remove(spell)
		qdel(spell)

/obj/item/device/crystalball/proc/has_spell(var/obj/item/weapon/spell/construct/C)
	for(var/obj/spellbutton/spell in spells)
		if(spell.spellpath == C)
			return 1
	return 0

/obj/item/device/crystalball/proc/has_spell_datum(var/datum/cultist/spell_to_check)
	for(var/obj/spellbutton/spell in spells)
		if(spell.spellpath == spell_to_check.obj_path)
			return 1
	return 0

/obj/item/device/crystalball/advanced
	name = "pristine sphere"
	desc = "A heavy, perfectly smooth crystalline ball."

	icon_state = "crystalball_adv"

	networked = TRUE

	crude = FALSE
