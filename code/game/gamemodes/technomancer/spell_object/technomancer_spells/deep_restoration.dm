/datum/technomancer_catalog/spell/deep_restoration
	name = "Deep Restoration"
	cost = 100
	category = SUPPORT_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/deep_restoration)

/datum/spell_metadata/deep_restoration
	name = "Deep Restoration"
	desc = "Greatly heals the target's wounds, both external and internal. It works on both organic and synthetic entities. \
	Restores internal organs to functioning states, even if robotic, reforms bones, patches internal bleeding, and restores missing blood. \
	Instability gained from this function is split between the caster and target, if they are different."
	aspect = ASPECT_BIOMED
	icon_state = "tech_deep_restoration"
	spell_path = /obj/item/weapon/spell/technomancer/deep_restoration
	cooldown = 1 MINUTE

/datum/spell_metadata/deep_restoration/get_spell_info()
	var/obj/item/weapon/spell/technomancer/deep_restoration/spell = spell_path
	. = list()
	.["Heal Power"] = initial(spell.heal_power)
	.["Organ Heal Power"] = initial(spell.organ_heal_power)
	.["Energy Cost"] = initial(spell.restoration_energy_cost)
	.["Instability Cost"] = initial(spell.restoration_instability_cost)


/obj/item/weapon/spell/technomancer/deep_restoration
	name = "deep restoration"
	desc = "A walking medbay is now you!"
	icon_state = "purify"
	cast_methods = CAST_MELEE
	var/restoration_energy_cost = 2000
	var/restoration_instability_cost = 20
	var/heal_power = 40
	var/organ_heal_power = 20

/obj/item/weapon/spell/technomancer/deep_restoration/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)
	if(!isliving(hit_atom))
		return FALSE
	var/mob/living/L = hit_atom

	if(!pay_energy(restoration_energy_cost))
		to_chat(span("warning", "Your energy reserves are insufficent to heal \the [L]."))
		return FALSE

	L.adjustBruteLoss(-heal_power)
	L.adjustFireLoss(-heal_power)
	L.adjustToxLoss(-heal_power)
	L.adjustCloneLoss(-heal_power / 2)
	L.radiation = max(0, L.radiation - heal_power)

	if(ishuman(L))
		fix_human_stuff(L, user)

	playsound(user, 'sound/effects/magic/technomancer/healing_cast.ogg', 75, 1)
	playsound(L, 'sound/effects/magic/technomancer/magic.ogg', 75, 1)
	new /obj/effect/temp_visual/medical_holosign/green(get_turf(L))
	for(var/i = 1 to rand(3, 5))
		new /obj/effect/temp_visual/heal(get_turf(L), "#00FF00")
	adjust_instability(restoration_instability_cost / 2)
	L.adjust_instability(restoration_instability_cost / 2)

	delete_after_cast = TRUE
	return TRUE

/obj/item/weapon/spell/technomancer/deep_restoration/proc/fix_human_stuff(mob/living/carbon/human/H, mob/living/user)
	// I hate this code.
	H.restore_blood() // Fix bloodloss
	for(var/obj/item/organ/O in H.internal_organs)
		if(O.damage > 0)
			O.damage = max(O.damage - organ_heal_power, 0)
		if(O.damage <= 5 && O.organ_tag == O_EYES) // Fix eyes.
			H.sdisabilities &= ~BLIND

	for(var/obj/item/organ/E in H.bad_external_organs)
		var/obj/item/organ/external/affected = E
		if((affected.damage < affected.min_broken_damage * config.organ_health_multiplier) && (affected.status & ORGAN_BROKEN))
			affected.status &= ~ORGAN_BROKEN // Fix broken bones.

		for(var/datum/wound/W in affected.wounds) // Fix IB
			if(istype(W, /datum/wound/internal_bleeding))
				affected.wounds -= W
				affected.update_damages()
