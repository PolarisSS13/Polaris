/*
Slime definitions, Life and New live here.
*/
/mob/living/simple_animal/xeno/slime //Adult values are found here
	nameVar = "grey"		//When mutated, nameVar might change.
	desc = "A shifting, mass of goo."
	faction = "slime"
	speak_emote = list("garbles", "chirps", "blurbles")
	colored = 1
	color = "#CACACA"
	icon = 'icons/mob/slime2.dmi'
	icon_state = "slime adult"
	icon_living = "slime adult"
	icon_dead = "slime adult dead"
	internal_vol = 200
	mut_max = 50
	mutable = COLORMUT
	var/is_child = 1
	var/cores = 3
	var/growthcounter = 0
	var/growthpoint = 25 //At what point they grow up.
	var/shiny = 0
	move_to_delay = 17 //Slimes shouldn't be able to go faster than humans.
	default_chems = list(/datum/reagent/slimejelly = 5)
	attacktext = "absorbed some of"
	response_help = "pats"
	response_disarm = "tries to stop"
	response_harm = "hits"

	var/emote_on = null

	maleable = MAX_MALEABLE

	//Slimes can speak all of the languages, oh no!
	universal_speak = 1
	speak_chance = 1
	speak = list("Hello?",
				"Where is this going?",
				"What is that?",
				"What is in the box?",
				"Cargo.",
				"Transport?",
				"Special?",
				"Slime?")

	//Overlay information
	var/overlay = 1 // 1 = normal lighting, 0 = shiny, 2 = too shiny, -1 = no overlay

	chemreact = list(	/datum/reagent/nutriment = list("nutr" = 0.5),
						/datum/reagent/radium = list("toxic" = 0.3, "mut" = 1),
						/datum/reagent/mutagen = list("nutr" = 0.4, "mut" = 2),
						/datum/reagent/water = list("nutr" = -0.1),
						/datum/reagent/drink/milk = list("nutr" = 0.3),
						/datum/reagent/acid = list("toxic" = 1),
						/datum/reagent/acid/polyacid = list("toxic" = 2),
						/datum/reagent/chlorine = list("toxic" = 0.5),
						/datum/reagent/ammonia = list("toxic" = 0.5),
						/datum/reagent/sodawater = list("toxic" = 0.1, "nutr" = -0.1),
						/datum/reagent/ethanol/beer = list("nutr" = 0.6),
						/datum/reagent/diethylamine = list("nutr" = 0.9),
						/datum/reagent/sugar = list("toxic" = 0.4, "nutr" = 0.2),
						/datum/reagent/toxin/nutriment/eznutrient = list("nutr" = 0.8),
						/datum/reagent/cryoxadone = list("toxic" = 0.4),
						/datum/reagent/flourine = list("toxic" = 0.1),
						/datum/reagent/toxin/fertilizer/robustharvest = list("nutr" = 1.5),
						/datum/reagent/nutriment/glucose = list("nutr" = 0.5),
						/datum/reagent/blood = list("nutr" = 0.75, "toxic" = 0.05, "mut" = 0.45),
						/datum/reagent/fuel = list("toxic" = 0.4),
						/datum/reagent/toxin = list("toxic" = 0.5),
						/datum/reagent/toxin/carpotoxin = list("toxic" = 1, "mut" = 1.5),
						/datum/reagent/toxin/phoron = list("toxic" = 1.5, "mut" = 0.03),
						/datum/reagent/nutriment/virus_food = list("nutr" = 1.5, "mut" = 0.32),
						/datum/reagent/toxin/cyanide = list("toxic" = 3.5),
						/datum/reagent/slimejelly = list("nutr" = 0.5),
						/datum/reagent/slimetoxin = list("toxic" = 0.1, "heal" = 1, "mut" = 1.5),
						/datum/reagent/gold = list("heal" = 0.3, "nutr" = 0.7, "mut" = 0.3),
						/datum/reagent/uranium = list("heal" = 0.3, "toxic" = 0.7, "mut" = 1.2),
						/datum/reagent/nutriment/glycerol = list("nutr" = 0.6),
						/datum/reagent/woodpulp = list("heal" = 0.1, "nutr" = 0.7),
						/datum/reagent/aslimetoxin = list("nutr" = 0.3)	)

/mob/living/simple_animal/xeno/slime/New()
	..()
	for(var/datum/language/L in (typesof(/datum/language) - /datum/language))
		languages += L
	speak += "[station_name()]?"
	traitdat.source = "Slime"
	resistances[BURN] = 4
	resistances[BRUTE] = 0.2
	resistances[TOX] = 1.5
	GenerateChild()
	return 1
