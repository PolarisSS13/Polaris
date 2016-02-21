//Defines Xenomorphic variables, also contains New()

/mob/living/xenomorphic
	name = "Xeno"
	real_name = "Xeno"
	desc = "Something's broken, yell at a developer."
	speak_emote = list("whines")
	var/icon_living = ""
	var/icon_dead = ""
	var/revivable = 1
	var/speed = 1000
	health = 2
	maxHealth = 2
	var/pullFreeze = 1
	var/moveTiming = 20
	var/sinceLastMove = 0
	var/internal_vol = 1000 //Internal volume for ingesting/injected reagents.
	//var/blood_vol = 1000 //Blood stream volume
	var/attack_type = brute
	var/target
	
	//Internal reagent container related lists of reagents for processing reagents
	var/toxic_internal = list()
	var/beneficial_internal = list()
	var/mut_internal = list()
	
	/*
	//Blood-related lists of reagents
	var/toxic_blood = list()
	var/beneficial_blood = list()
	var/mut_blood = list()
	*/
	
	//Utilized in blob code, leaving for availability for further expansion.
	var/colored = 0
	var/mutation
	var/friendly = list()
	var/colorVar
	var/mutable = 0 // 0 is non-mutable, 1 is mutable
	var/nameVar = "Blah" //Name might change, based on what mutations take place.
	var/instability = 0
	
	var/burn_resistance = 0
	var/brute_resistance = 0
	
	//Reagent holders
	var/internal_reagents = null
	//var/bloodstream = null
	
	//Temperature effect
	var/minbodytemp = 250
	var/maxbodytemp = 350
	var/heat_damage_per_tick = 3	//amount of damage applied if animal's body temperature is higher than maxbodytemp
	var/cold_damage_per_tick = 2	//same as heat_damage_per_tick, only if the bodytemperature it's lower than minbodytemp
	var/fire_alert = 0
	
	//Atmos effect - Yes, you can make creatures that require phoron or co2 to survive. N2O is a trace gas and handled separately, hence why it isn't here. It'd be hard to add it. Hard and me don't mix (Yes, yes make all the dick jokes you want with that.) - Errorage
	var/min_oxy = 5
	var/max_oxy = 0					//Leaving something at 0 means it's off - has no maximum
	var/min_tox = 0
	var/max_tox = 1
	var/min_co2 = 0
	var/max_co2 = 5
	var/min_n2 = 0
	var/max_n2 = 0
	var/unsuitable_atoms_damage = 2	//This damage is taken when atmos doesn't fit all the requirements above
	
/mob/living/xenomorphic/New()
	..()
	if(colored)
		colorVar = color
	var/internal_reagents = new/datum/reagents(internal_vol, src)
