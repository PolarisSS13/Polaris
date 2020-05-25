/datum/technomancer_catalog/spell/mend_synthetic
	name = "Mend Synthetic"
	cost = 50
	category = SUPPORT_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/modifier/mend_synthetic)

/datum/spell_metadata/modifier/mend_synthetic
	name = "Mend Synthetic"
	desc = "Repairs minor damage to prosthetics, and removes soft errors resulting from radiation exposure. \
	Instability is split between the target and technomancer, if seperate.  The function will end prematurely \
	if the target is completely healthy, preventing further instability."
	icon_state = "tech_mend_synthetic"
	spell_path = /obj/item/weapon/spell/technomancer/modifier/mend_synthetic

/datum/spell_metadata/modifier/mend_synthetic/get_spell_info()
	var/obj/item/weapon/spell/technomancer/modifier/mend_synthetic/spell = spell_path
	var/datum/modifier/mend_synthetic/modifier = initial(spell.modifier_type)
	// Feel free to replace the hardcoded 2 SECONDS with a future mob ticker's `wait` var, e.g. SSMob.wait, if that ever happens.
	. = list()
	.["Heal Power"] = "[initial(modifier.heal_power)] every [DisplayTimeText(2 SECONDS)]"
	.["Instability Cost Over Time"] = "[initial(modifier.instability_per_tick)] every [DisplayTimeText(2 SECONDS)]"
	. += ..()


/obj/item/weapon/spell/technomancer/modifier/mend_synthetic
	name = "mend synthetic"
	desc = "Watch your wounds close up before your eyes."
	icon_state = "mend_synthetic"
	cast_methods = CAST_MELEE
	modifier_type = /datum/modifier/mend_synthetic
	modifier_duration = 1 MINUTE
	modifier_energy_cost = 500
	modifier_instability_cost = 5


/datum/modifier/mend_synthetic
	name = "mend synthetic"
	desc = "Something seems to be repairing you."
	mob_overlay_state = "cyan_sparkles"

	on_created_text = "<span class='warning'>Sparkles begin to appear around you, and your systems report integrity rising.</span>"
	on_expired_text = "<span class='notice'>The sparkles have faded, although your systems seem to be better than before.</span>"
	stacks = MODIFIER_STACK_EXTEND
	technomancer_dispellable = TRUE
	var/heal_power = 4
	var/instability_per_tick = 1

/datum/modifier/mend_synthetic/tick()
	if(!holder.getActualBruteLoss() && !holder.getActualFireLoss()) // No point existing if the spell can't heal.
		expire()
		return

	if(ishuman(holder))
		var/mob/living/carbon/human/H = holder
		for(var/obj/item/organ/external/E in H.organs)
			var/obj/item/organ/external/O = E
			if(O.robotic >= ORGAN_ROBOT)
				O.heal_damage(heal_power, heal_power, 0, 1)
		if(H.isSynthetic())
			H.adjustToxLoss(-heal_power) // Fix radiation stuff.
	else
		if(holder.isSynthetic())
			holder.adjustBruteLoss(-heal_power)
			holder.adjustFireLoss(-heal_power)

	holder.adjust_instability(instability_per_tick)
	if(origin)
		var/mob/living/L = origin.resolve()
		if(istype(L))
			L.adjust_instability(instability_per_tick)
