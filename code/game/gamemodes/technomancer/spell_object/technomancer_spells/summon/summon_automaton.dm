/datum/technomancer_catalog/spell/summon_automaton
	name = "Summon Automaton"
	cost = 100
	category = UTILITY_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/summon/summon_automaton, /datum/spell_metadata/abjuration)

/datum/spell_metadata/summon/summon_automaton
	name = "Summon Automaton"
	desc = "Teleports a freshly fabricated drone from your home base to an area of your choosing, \
	after a delay. Unlike most other summons, drones made by this spell are always loyal to their summoner. \
	The drone summoned can be chosen by using the ability in your hand."
	enhancement_desc = null // Scepter is redundant.
	icon_state = "tech_summon_automaton"
	spell_path = /obj/item/weapon/spell/technomancer/summon/summon_automaton
	var/static/list/automaton_summon_choices = null
	make_hearts_on_loyalty = FALSE

/datum/spell_metadata/summon/summon_automaton/get_summon_choices()
	if(LAZYLEN(automaton_summon_choices))
		return automaton_summon_choices

	automaton_summon_choices = list(
		new /datum/technomancer_summon_choice("Drone - Viscerator", /mob/living/simple_mob/mechanical/viscerator, 1),
		new /datum/technomancer_summon_choice("Drone - Combat", /mob/living/simple_mob/mechanical/combat_drone, 4),
		new /datum/technomancer_summon_choice("Hivebot - Swarmer", /mob/living/simple_mob/mechanical/hivebot/swarm, 1),
		new /datum/technomancer_summon_choice("Hivebot - Basic", /mob/living/simple_mob/mechanical/hivebot/ranged_damage/basic, 2),
		new /datum/technomancer_summon_choice("Hivebot - Laser", /mob/living/simple_mob/mechanical/hivebot/ranged_damage/laser, 3),
		new /datum/technomancer_summon_choice("Hivebot - Ion", /mob/living/simple_mob/mechanical/hivebot/ranged_damage/ion, 3),
		new /datum/technomancer_summon_choice("Hivebot - Rapid", /mob/living/simple_mob/mechanical/hivebot/ranged_damage/rapid, 4),
		new /datum/technomancer_summon_choice("Hivebot - Tough", /mob/living/simple_mob/mechanical/hivebot/ranged_damage/strong, 3),
		new /datum/technomancer_summon_choice("Hivebot - Fire", /mob/living/simple_mob/mechanical/hivebot/ranged_damage/dot, 2),
		new /datum/technomancer_summon_choice("Hivebot - Backline", /mob/living/simple_mob/mechanical/hivebot/ranged_damage/basic, 3),
		new /datum/technomancer_summon_choice("Hivebot - Anti-bullet", /mob/living/simple_mob/mechanical/hivebot/tank/armored/anti_bullet, 2),
		new /datum/technomancer_summon_choice("Hivebot - Anti-laser", /mob/living/simple_mob/mechanical/hivebot/tank/armored/anti_laser, 2),
		new /datum/technomancer_summon_choice("Hivebot - Anti-melee", /mob/living/simple_mob/mechanical/hivebot/tank/armored/anti_melee, 2),
		new /datum/technomancer_summon_choice("Hivebot - Meatshield", /mob/living/simple_mob/mechanical/hivebot/tank/meatshield, 2),
		new /datum/technomancer_summon_choice("Autonomous Exosuit - Ripley", /mob/living/simple_mob/mechanical/mecha/ripley, 2),
		new /datum/technomancer_summon_choice("Autonomous Exosuit - Firefighter Ripley", /mob/living/simple_mob/mechanical/mecha/ripley/firefighter, 3),
		new /datum/technomancer_summon_choice("Autonomous Exosuit - Odysseus", /mob/living/simple_mob/mechanical/mecha/odysseus, 4),
		new /datum/technomancer_summon_choice("Autonomous Exosuit - Hoverpod", /mob/living/simple_mob/mechanical/mecha/hoverpod, 4)
	)
	return automaton_summon_choices


/obj/item/weapon/spell/technomancer/summon/summon_automaton
	name = "summon automaton"
	desc = "Grey goo sold seperately."
	default_always_loyal = TRUE


