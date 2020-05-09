/datum/technomancer_catalog/spell/abjuration
	name = "Abjuration"
	cost = 0 // It's also bundled with all the Summon X spells.
	category = UTILITY_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/abjuration)

/datum/spell_metadata/abjuration
	name = "Abjuration"
	desc = "This ability attempts to send summoned or teleported entities or anomalies to the place from whence they came, \
	or at least far away from the caster. Failing that, it may inhibit those entities in some form."
	aspect = ASPECT_TELE
	icon_state = "tech_abjuration"
	spell_path = /obj/item/weapon/spell/technomancer/abjuration

/datum/spell_metadata/abjuration/get_spell_info()
	var/obj/item/weapon/spell/technomancer/abjuration/spell = spell_path
	. = list()
	.["Energy Cost"] = initial(spell.abjurate_energy_cost)
	.["Instability Cost"] = initial(spell.abjurate_instability_cost)


/obj/item/weapon/spell/technomancer/abjuration
	name = "abjuration"
	desc = "Useful for unruly minions, hostile summoners, or for fighting the horrors that may await you with your hubris."
	icon_state = "generic"
	cast_methods = CAST_RANGED
	var/abjurate_energy_cost = 500
	var/abjurate_instability_cost = 5


/obj/item/weapon/spell/technomancer/abjuration/on_ranged_cast(atom/hit_atom, mob/user)
	if(istype(hit_atom, /mob/living/simple_mob) && pay_energy(abjurate_energy_cost) && within_range(hit_atom))
		var/mob/living/simple_mob/SM = hit_atom

		playsound(user, 'sound/effects/magic/technomancer/teleport.ogg', 75, 1)

		if(istype(SM, /mob/living/simple_mob/construct))
			var/mob/living/simple_mob/construct/evil = SM
			to_chat(evil, span("danger", "\The [user]'s abjuration purges your form!"))
			to_chat(user, span("notice", "You purge \the [evil]'s form, weakening them for a period of time."))
			evil.purge = 3
			playsound(SM, 'sound/effects/magic/technomancer/repulse.ogg', 75, 1)

		else if(SM.summoned || SM.supernatural)
			if(SM.client) // Player-controlled mobs are immune to being killed by this.
				to_chat(user, span("warning", "\The [SM] resists your attempt to banish it!"))
				to_chat(SM, span("danger", "\The [user] tried to teleport you far away, but failed."))
				return FALSE
			else
				visible_message(span("notice", "\The [SM] vanishes!"))
				playsound(SM, 'sound/effects/magic/technomancer/teleport_diss.ogg', 75, 1)
				new /obj/effect/temp_visual/phase_out(get_turf(SM))
				qdel(SM)

		adjust_instability(abjurate_instability_cost)

	// In case NarNar comes back someday.
	if(istype(hit_atom, /obj/singularity/narsie))
		to_chat(user, span("danger", "One does not simply abjurate Nar'sie away."))
		adjust_instability(200)
	return TRUE