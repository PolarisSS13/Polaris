// Similar to Summon Creature but summons harmless things and thus is very cheap.
/datum/technomancer_catalog/spell/summon_critter
	name = "Summon Critter"
	cost = 25
	category = UTILITY_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/summon/summon_critter, /datum/spell_metadata/abjuration)

/datum/spell_metadata/summon/summon_critter
	name = "Summon Critter"
	desc = "Teleports a specific harmless critter from their current location in the universe to the targeted tile, \
	after a delay. The critter summoned can be chosen by using the ability in your hand."
	icon_state = "tech_summon_critter"
	spell_path = /obj/item/weapon/spell/technomancer/summon/summon_critter
	var/static/list/critter_summon_choices = null

/datum/spell_metadata/summon/summon_critter/get_summon_choices()
	if(LAZYLEN(critter_summon_choices))
		return critter_summon_choices

	critter_summon_choices = list(
		new /datum/technomancer_summon_choice("Sivian - Glitterfly", /mob/living/simple_mob/animal/sif/glitterfly, 1),

		new /datum/technomancer_summon_choice("Cat - Orange", /mob/living/simple_mob/animal/passive/cat, 1),
		new /datum/technomancer_summon_choice("Cat - Orange Kitten", /mob/living/simple_mob/animal/passive/cat/kitten, 1),
		new /datum/technomancer_summon_choice("Cat - Black", /mob/living/simple_mob/animal/passive/cat/black, 1),

		new /datum/technomancer_summon_choice("Dog - Corgi", /mob/living/simple_mob/animal/passive/dog/corgi, 1),
		new /datum/technomancer_summon_choice("Dog - Corgi Pup", /mob/living/simple_mob/animal/passive/dog/corgi/puppy, 1),
		new /datum/technomancer_summon_choice("Dog - Tamaskan", /mob/living/simple_mob/animal/passive/dog/tamaskan, 1),

		new /datum/technomancer_summon_choice("Bird - Azure Tit", /mob/living/simple_mob/animal/passive/bird/azure_tit, 1),
		new /datum/technomancer_summon_choice("Bird - Black Bird", /mob/living/simple_mob/animal/passive/bird/black_bird, 1),
		new /datum/technomancer_summon_choice("Bird - European Robin", /mob/living/simple_mob/animal/passive/bird/european_robin, 1),
		new /datum/technomancer_summon_choice("Bird - Goldcrest", /mob/living/simple_mob/animal/passive/bird/goldcrest, 1),
		new /datum/technomancer_summon_choice("Bird - Ringneck Dove", /mob/living/simple_mob/animal/passive/bird/ringneck_dove, 1),

		new /datum/technomancer_summon_choice("Parrot - Black Headed Caique", /mob/living/simple_mob/animal/passive/bird/parrot/black_headed_caique, 1),
		new /datum/technomancer_summon_choice("Parrot - Budgerigar", /mob/living/simple_mob/animal/passive/bird/parrot/budgerigar, 1),
		new /datum/technomancer_summon_choice("Parrot - Blue Budgerigar", /mob/living/simple_mob/animal/passive/bird/parrot/budgerigar/blue, 1),
		new /datum/technomancer_summon_choice("Parrot - Blue/Green Budgerigar", /mob/living/simple_mob/animal/passive/bird/parrot/budgerigar/bluegreen, 1),
		new /datum/technomancer_summon_choice("Parrot - Cockatiel", /mob/living/simple_mob/animal/passive/bird/parrot/cockatiel, 1),
		new /datum/technomancer_summon_choice("Parrot - Grey Cockatiel", /mob/living/simple_mob/animal/passive/bird/parrot/cockatiel/grey, 1),
		new /datum/technomancer_summon_choice("Parrot - White Cockatiel", /mob/living/simple_mob/animal/passive/bird/parrot/cockatiel/white, 1),
		new /datum/technomancer_summon_choice("Parrot - Yellowish Cockatiel", /mob/living/simple_mob/animal/passive/bird/parrot/cockatiel/yellowish, 1),
		new /datum/technomancer_summon_choice("Parrot - Eclectus", /mob/living/simple_mob/animal/passive/bird/parrot/eclectus, 1),
		new /datum/technomancer_summon_choice("Parrot - Grey Parrot", /mob/living/simple_mob/animal/passive/bird/parrot/grey_parrot, 1),
		new /datum/technomancer_summon_choice("Parrot - Kea", /mob/living/simple_mob/animal/passive/bird/parrot/kea, 1),
		new /datum/technomancer_summon_choice("Parrot - Pink Cockatoo", /mob/living/simple_mob/animal/passive/bird/parrot/pink_cockatoo, 1),
		new /datum/technomancer_summon_choice("Parrot - Sulphur Cockatoo", /mob/living/simple_mob/animal/passive/bird/parrot/sulphur_cockatoo, 1),
		new /datum/technomancer_summon_choice("Parrot - White Caique", /mob/living/simple_mob/animal/passive/bird/parrot/white_caique, 1),
		new /datum/technomancer_summon_choice("Parrot - White Cockatoo", /mob/living/simple_mob/animal/passive/bird/parrot/white_cockatoo, 1),

		new /datum/technomancer_summon_choice("Critter - Mouse", /mob/living/simple_mob/animal/passive/mouse, 1),
		new /datum/technomancer_summon_choice("Critter - Lizard", /mob/living/simple_mob/animal/passive/lizard, 1),
		new /datum/technomancer_summon_choice("Critter - Chicken", /mob/living/simple_mob/animal/passive/chicken, 1),
		new /datum/technomancer_summon_choice("Critter - Chick", /mob/living/simple_mob/animal/passive/chick, 1),
		new /datum/technomancer_summon_choice("Critter - Cow", /mob/living/simple_mob/animal/passive/cow, 1),
		new /datum/technomancer_summon_choice("Critter - Penguin", /mob/living/simple_mob/animal/passive/penguin, 1),
		new /datum/technomancer_summon_choice("Critter - Crab", /mob/living/simple_mob/animal/passive/crab, 1),
		new /datum/technomancer_summon_choice("Critter - Parrot", /mob/living/simple_mob/animal/passive/bird/parrot, 1),
		new /datum/technomancer_summon_choice("Critter - Goat", /mob/living/simple_mob/animal/goat, 1),
		new /datum/technomancer_summon_choice("Critter - Tindalos", /mob/living/simple_mob/animal/passive/tindalos, 1),
		new /datum/technomancer_summon_choice("Critter - Yithian", /mob/living/simple_mob/animal/passive/yithian, 1)
	)
	return critter_summon_choices

/obj/item/weapon/spell/technomancer/summon/summon_critter
	name = "summon critter"
	desc = "Too many birds!"
