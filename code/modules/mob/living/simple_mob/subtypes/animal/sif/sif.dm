// Mobs intended to be on Sif. As such, they won't die to the cold.
/mob/living/simple_mob/animal/sif
	minbodytemp = 175
	cold_resist = 0.75
	heat_resist = -0.5

	tame_items = list(
		/obj/item/reagent_containers/food/snacks/meat/crab = 20,
		/obj/item/reagent_containers/food/snacks/meat = 10
	)

	// Healing threshold for grafadreka healing spit effect.
	var/sap_heal_threshold
	var/sap_heal_gradient = 0.25 // 25% of health each regen threshold

/mob/living/simple_mob/animal/sif/Initialize()
	. = ..()
	sap_heal_threshold = round(maxHealth * 0.15)

/mob/living/simple_mob/animal/sif/updatehealth()
	. = ..()
	var/sap_threshold = round(maxHealth * sap_heal_gradient)
	sap_heal_threshold = min(maxHealth, min(sap_heal_threshold, n_ceil(health % sap_threshold)*sap_threshold))

/mob/living/simple_mob/animal/sif/rejuvenate()
	sap_heal_threshold = maxHealth
	. = ..()
