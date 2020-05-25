/datum/technomancer_catalog/spell/summon_creature
	name = "Summon Creature"
	cost = 100
	category = UTILITY_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/summon/summon_creature, /datum/spell_metadata/abjuration)

/datum/spell_metadata/summon/summon_creature
	name = "Summon Creature"
	desc = "Teleports a specific creature from their current location in the universe to the targeted tile, \
	after a delay. Note that creatures brought to you are not inherently loyal to you. \
	The creature summoned can be chosen by using the ability in your hand."
	icon_state = "tech_summon_creature"
	spell_path = /obj/item/weapon/spell/technomancer/summon/summon_creature
	var/static/list/creature_summon_choices = null

/datum/spell_metadata/summon/summon_creature/get_summon_choices()
	if(LAZYLEN(creature_summon_choices))
		return creature_summon_choices

	creature_summon_choices = list(
		new /datum/technomancer_summon_choice("Giant Spider - Guard", /mob/living/simple_mob/animal/giant_spider, 2),
		new /datum/technomancer_summon_choice("Giant Spider - Hunter", /mob/living/simple_mob/animal/giant_spider/hunter, 3),
		new /datum/technomancer_summon_choice("Giant Spider - Nurse", /mob/living/simple_mob/animal/giant_spider/nurse, 1),
		new /datum/technomancer_summon_choice("Giant Spider - Carrier", /mob/living/simple_mob/animal/giant_spider/carrier, 5),
		new /datum/technomancer_summon_choice("Giant Spider - Electric", /mob/living/simple_mob/animal/giant_spider/electric, 3),
		new /datum/technomancer_summon_choice("Giant Spider - Frost", /mob/living/simple_mob/animal/giant_spider/frost, 2),
		new /datum/technomancer_summon_choice("Giant Spider - Lurker", /mob/living/simple_mob/animal/giant_spider/lurker, 4),
		new /datum/technomancer_summon_choice("Giant Spider - Pepper", /mob/living/simple_mob/animal/giant_spider/pepper, 2),
		new /datum/technomancer_summon_choice("Giant Spider - Thermic", /mob/living/simple_mob/animal/giant_spider/thermic, 2),
		new /datum/technomancer_summon_choice("Giant Spider - Tunneler", /mob/living/simple_mob/animal/giant_spider/tunneler, 3),
		new /datum/technomancer_summon_choice("Giant Spider - Webslinger", /mob/living/simple_mob/animal/giant_spider/lurker, 2),

		new /datum/technomancer_summon_choice("Spaceborne - Bat", /mob/living/simple_mob/animal/space/bats, 1),
		new /datum/technomancer_summon_choice("Spaceborne - Space Carp", /mob/living/simple_mob/animal/space/carp, 2),
		new /datum/technomancer_summon_choice("Spaceborne - Large Space Carp", /mob/living/simple_mob/animal/space/carp/large, 3),

		new /datum/technomancer_summon_choice("Sivian - Diyaab", /mob/living/simple_mob/animal/sif/diyaab, 1),
		new /datum/technomancer_summon_choice("Sivian - Crystal Feather Duck", /mob/living/simple_mob/animal/sif/duck, 1),
		new /datum/technomancer_summon_choice("Sivian - Frostfly", /mob/living/simple_mob/animal/sif/frostfly, 1),
		new /datum/technomancer_summon_choice("Sivian - Hooligan Crab", /mob/living/simple_mob/animal/sif/hooligan_crab, 4),
		new /datum/technomancer_summon_choice("Sivian - Kururak", /mob/living/simple_mob/animal/sif/kururak, 3),
		new /datum/technomancer_summon_choice("Sivian - Sakimm", /mob/living/simple_mob/animal/sif/sakimm, 1),
		new /datum/technomancer_summon_choice("Sivian - Savik", /mob/living/simple_mob/animal/sif/savik, 3),
		new /datum/technomancer_summon_choice("Sivian - Shantak", /mob/living/simple_mob/animal/sif/shantak, 2),

		new /datum/technomancer_summon_choice("Animal - Bear", /mob/living/simple_mob/animal/space/bear, 3),
		new /datum/technomancer_summon_choice("Animal - Goose", /mob/living/simple_mob/animal/space/goose, 10)
	)
	return creature_summon_choices

/obj/item/weapon/spell/technomancer/summon/summon_creature
	name = "summon creature"
	desc = "Chitter chitter."
