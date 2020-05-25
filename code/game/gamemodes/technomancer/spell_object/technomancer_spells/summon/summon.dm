// Generic summon spell, used by subtypes of this one to summon things to fight for the Technomancer and/or murder their own summoner.

/datum/spell_metadata/summon
	aspect = ASPECT_TELE
	cooldown = 5 SECONDS
	enhancement_desc = "Summoned entities will never harm their summoner or their apprentices."
	var/summon_delay = 5 SECONDS
	var/summoned_mob_type = null // The type to try to use when summoning a mob.
	var/summoned_mob_summon_slot_cost = 1 // How many slots the currently selected mob type will need.
	var/make_hearts_on_loyalty = TRUE // Set to false if you don't want heart visuals when using a scepter, e.g. robits.

/datum/spell_metadata/summon/get_spell_info()
	var/obj/item/weapon/spell/technomancer/summon/spell = spell_path
	. = list()
	.["Energy Cost per Summon Slot"] = initial(spell.summon_energy_cost_per_slot)
	.["Instability Cost per Summon Slot"] = initial(spell.summon_instability_cost_per_slot)

// This is in the metadata object and not the spell object due to the likelyhood of the spell getting dropped while a summon is underway.
/datum/spell_metadata/summon/proc/start_summon(new_mob_type, new_mob_slot_cost, turf/T, mob/living/user, obj/item/weapon/technomancer_core/core, always_loyal = FALSE)
	var/obj/effect/temp_visual/summoning/visual = new(T)
	visual.duration = summon_delay
	addtimer(CALLBACK(src, .proc/finish_summon, new_mob_type, new_mob_slot_cost, T, user, core, always_loyal), summon_delay)
	addtimer(CALLBACK(src, .proc/summon_sound, T), max(summon_delay - 1 SECOND, 1))

/datum/spell_metadata/summon/proc/finish_summon(new_mob_type, new_mob_slot_cost, turf/T, mob/living/user, obj/item/weapon/technomancer_core/core, always_loyal = FALSE)
	var/mob/living/simple_mob/SM = new new_mob_type(T)
	SM.summoned = TRUE
	var/image/summon_overlay = image('icons/obj/objects.dmi',"anom")
	summon_overlay.alpha = 127
	summon_overlay.plane = MOB_PLANE
	summon_overlay.layer = BELOW_MOB_LAYER
	SM.add_overlay(summon_overlay, TRUE)

	if(always_loyal)
		for(var/datum/mind/technomancer_mind in technomancers.current_antagonists)
			SM.friends |= technomancer_mind.current
		if(make_hearts_on_loyalty)
			new /obj/effect/temp_visual/love_heart(T)

	core.add_summon_slot(SM, new_mob_slot_cost)
	to_chat(user, span("notice", "You've successfully teleported \a [SM] to you!"))
	SM.visible_message(span("danger", "\A [SM] appears from no-where!"))
	log_and_message_admins("[user] has summoned \a [SM] at [T.x],[T.y],[T.z].")
	new /obj/effect/temp_visual/phase_in(T)

/datum/spell_metadata/summon/proc/summon_sound(turf/T)
	playsound(T, 'sound/effects/magic/technomancer/summoned.ogg', 75, FALSE)

// Override for subtypes which should return a list of `/datum/technomancer_summon_choice`s.
/datum/spell_metadata/summon/proc/get_summon_choices()
	return list()


/obj/item/weapon/spell/technomancer/summon
	name = "generic summon spell"
	desc = "Someone did an oopsie and made a bug if you can read this."
	icon_state = "summon"
	cast_methods = CAST_RANGED|CAST_USE
	var/summon_energy_cost_per_slot = 1000 // Scales based on how many slots a summon takes. E.g. a three slot thing costs 3000 energy.
	var/summon_instability_cost_per_slot = 5
	var/default_always_loyal = FALSE // If true, the Scepter of Enhancement isn't needed.

/obj/item/weapon/spell/technomancer/summon/on_ranged_cast(atom/hit_atom, mob/living/user)
	var/datum/spell_metadata/summon/summon_meta = meta
	var/turf/T = get_turf(hit_atom)

	if(!istype(T))
		return FALSE

	if(!summon_meta.summoned_mob_type)
		to_chat(user, span("warning", "You don't appear to have selected anything to summon. \
		Use the function in hand to select what you want to kidnap for your own purposes first."))
		return FALSE

	if(!core.can_afford_summon_slot(summon_meta.summoned_mob_summon_slot_cost))
		to_chat(user, span("warning", "\The [core] on your back can't support more summoned entities. \
		Abjurate away or otherwise get rid of some of your summoned things and try again."))
		return FALSE

	if(!within_range(T))
		to_chat(user, span("warning", "You're too far away to summon something at \the [T]. Get closer."))
		return FALSE

	if(!pay_energy(summon_energy_cost_per_slot * summon_meta.summoned_mob_summon_slot_cost))
		to_chat(user, span("warning", "You don't have enough energy to summon that."))
		return FALSE

	adjust_instability(summon_instability_cost_per_slot * summon_meta.summoned_mob_summon_slot_cost)

	var/always_loyal = default_always_loyal || check_for_scepter()
	summon_meta.start_summon(summon_meta.summoned_mob_type, summon_meta.summoned_mob_summon_slot_cost, T, user, core, always_loyal)
	playsound(user, 'sound/effects/magic/technomancer/generic_cast.ogg', 75, 1)
	playsound(T, 'sound/effects/magic/technomancer/smoke.ogg', 75, 1)
	return TRUE

/obj/item/weapon/spell/technomancer/summon/on_use_cast(mob/living/user)
	var/datum/spell_metadata/summon/summon_meta = meta

	var/list/choices = summon_meta.get_summon_choices()

	if(!LAZYLEN(choices))
		to_chat(user, span("warning", "It appears you have no choices for what to summon. This is probably a bug."))
		return FALSE

	var/list/displayed_list = list()
	for(var/thing in choices)
		var/datum/technomancer_summon_choice/choice = thing
		var/line = "[choice.name] ([choice.slot_cost] slot\s)"
		displayed_list[line] = thing

	var/chosen_option = input(user, "Choose something to kidnap from somewhere else and bring here!", "Summon") as null|anything in displayed_list
	if(!chosen_option)
		to_chat(user, span("notice", "You decide against changing what you'll summon."))
		return FALSE

	var/datum/technomancer_summon_choice/selected_choice = displayed_list[chosen_option]
	summon_meta.summoned_mob_type = selected_choice.summon_typepath
	summon_meta.summoned_mob_summon_slot_cost = selected_choice.slot_cost
	to_chat(user, span("notice", "You'll now summon a [selected_choice.name] next time you invoke this function at a distant target."))
	playsound(user, 'sound/effects/magic/technomancer/magic.ogg', 75, 1)

	return FALSE // It doesn't make sense to put the spell on cooldown for five seconds just for switching which mob gets summoned.