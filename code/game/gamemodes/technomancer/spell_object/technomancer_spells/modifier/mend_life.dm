/datum/technomancer_catalog/spell/mend_life
	name = "Mend Life"
	cost = 50
	category = SUPPORT_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/modifier/mend_life)

/datum/spell_metadata/modifier/mend_life
	name = "Mend Life"
	desc = "Heals minor wounds, such as cuts, bruises, burns, and other non-lifethreatening injuries, \
	as well as harm from toxins and mild oxygen deprivation.  \
	Instability is split between the target and technomancer, if seperate.  The function will end prematurely \
	if the target is completely healthy, preventing further instability."
	icon_state = "tech_mend_wounds"
	spell_path = /obj/item/weapon/spell/technomancer/modifier/mend_life

/datum/spell_metadata/modifier/mend_life/get_spell_info()
	var/obj/item/weapon/spell/technomancer/modifier/mend_life/spell = spell_path
	var/datum/modifier/mend_life/modifier = initial(spell.modifier_type)
	// Feel free to replace the hardcoded 2 SECONDS with a future mob ticker's `wait` var, e.g. SSMob.wait, if that ever happens.
	. = list()
	.["Heal Power"] = "[initial(modifier.heal_power)] every [DisplayTimeText(2 SECONDS)]"
	.["Instability Cost Over Time"] = "[initial(modifier.instability_per_tick)] every [DisplayTimeText(2 SECONDS)]"
	. += ..()


/obj/item/weapon/spell/technomancer/modifier/mend_life
	name = "mend life"
	desc = "Watch your wounds close up before your eyes."
	icon_state = "mend_life"
	cast_methods = CAST_MELEE
	modifier_type = /datum/modifier/mend_life
	modifier_duration = 1 MINUTE
	modifier_energy_cost = 500
	modifier_instability_cost = 5


/datum/modifier/mend_life
	name = "mend life"
	desc = "You feel rather refreshed."
	mob_overlay_state = "green_sparkles"

	on_created_text = "<span class='warning'>Sparkles begin to appear around you, and you feel really.. refreshed.</span>"
	on_expired_text = "<span class='notice'>The sparkles have faded, although you feel healthier than before.</span>"
	stacks = MODIFIER_STACK_EXTEND
	technomancer_dispellable = TRUE
	var/heal_power = 4
	var/instability_per_tick = 1

/datum/modifier/mend_life/tick()
	if(holder.isSynthetic()) // Don't heal synths!
		expire()
		return
	if(!holder.getBruteLoss() && !holder.getFireLoss()) // No point existing if the spell can't heal.
		expire()
		return
	holder.adjustBruteLoss(-heal_power)
	holder.adjustFireLoss(-heal_power)
	holder.adjustToxLoss(-heal_power)
	holder.adjustOxyLoss(-heal_power)
	holder.adjust_instability(instability_per_tick)
	if(origin)
		var/mob/living/L = origin.resolve()
		if(istype(L))
			L.adjust_instability(instability_per_tick)
