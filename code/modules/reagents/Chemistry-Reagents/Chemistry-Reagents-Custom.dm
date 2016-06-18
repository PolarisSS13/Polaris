/*Custom*/

/datum/reagent/piss
	name = "Urine"
	id = "piss"
	description = "Certainly a strong smell."
	var/nutriment_factor = 5 // Per unit
	var/injectable = 0
	color = "#DFD7AF"

	glass_icon_state = "beerglass"
	glass_name = "glass of urine"
	glass_desc = "Ewwww..."

/datum/reagent/piss/touch_turf(var/turf/simulated/T)
	if(!istype(T))
		return
	if(volume >= 1)
		if(T.wet >= 2)
			return
		T.wet = 2
		spawn(800)
			if(!T || !istype(T))
				return
			T.wet = 0
			if(T.wet_overlay)
				T.overlays -= T.wet_overlay
				T.wet_overlay = null


/datum/reagent/cum
	name = "Semen"
	id = "cum"
	description = "Not quite babies!"
	var/nutriment_factor = 30 // Per unit
	var/injectable = 0
	color = "#DFD7AF"

	glass_icon_state = "glass_white"
	glass_name = "glass of semen"
	glass_desc = "Ewwww..."

/datum/reagent/femcum
	name = "Femjuice"
	id = "femcum"
	description = "Not quite babies!"
	var/nutriment_factor = 30 // Per unit
	var/injectable = 0
	color = "#DFD7AF"

	glass_icon_state = "glass_clear"
	glass_name = "glass of femjuice"
	glass_desc = "Ewwww..."

/datum/reagent/lustium
	name = "Lustium"
	id = "lustium"
	description = "It seems to have some lewd properties."
	reagent_state = LIQUID
	color = "#CCFFCC"

/datum/reagent/aphrodisiac
	name = "Aphrodesiac"
	id = "aphrodesiac"
	description = "An illegal drug used to increase lust."
	reagent_state = LIQUID
	color = "#60A584"

/datum/reagent/aphrodisiac/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(prob(10))
		M.emote(pick("drool", "moan", "giggle", "orgasm"))