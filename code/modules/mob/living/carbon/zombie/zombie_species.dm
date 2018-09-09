//**** EVOLUTIONS *****//

/mob/living/carbon/human/zombie
	name = "Zombie"
	desc = "A shambling abomination of a once-human. As you look at this thing you realise dinner can go both ways."

#define STANDARD_EVOLUTION 1
#define EXPULSOR_EVOLUTION 2
#define BOMBER_EVOLUTION 3
#define SHAMBLER_EVOLUTION 4
#define CHASER_EVOLUTION 5

/datum/species/zombie
	name= "Zombie"
	name_plural = "Zombies"
	slowdown = 1
	blood_color = "#257a03" //dark green
	flesh_color = "#282846"
	icobase = 'icons/mob/human_races/r_zombie.dmi'
	deform = 'icons/mob/human_races/r_zombie.dmi'
	death_message = "screeches and growls as it becomes completely motionless... is it dead?"
	language = "Zombie"
	default_language = "Zombie"
	has_fine_manipulation = 0
	siemens_coefficient = 0
	flags = NO_PAIN|NO_SCAN|NO_POISON|NO_INFECT|NO_HALLUCINATION|NO_SLIP
	vision_flags = SEE_SELF|SEE_MOBS
	spawn_flags = SPECIES_IS_RESTRICTED
	virus_immune = 1
	brute_mod = 0.25
	burn_mod = 2
	speech_chance  = 5
	speech_sounds = list('sound/voice/zombie_groan.ogg')
	gluttonous = 1
	breath_type = null
	poison_type = null
	warning_low_pressure = 0
	hazard_low_pressure = 0
	cold_level_1 = -1
	cold_level_2 = -1
	cold_level_3 = -1
//	hud_type = /datum/hud_data/zombie
	has_fine_manipulation = FALSE
	ambiguous_genders = TRUE
	has_organ = list()
	var/evolution = STANDARD_EVOLUTION
	var/heal_rate = 0.5 // Temp. Regen per tick.


	inherent_verbs = list(
		/mob/living/carbon/human/proc/tackle,
		/mob/living/carbon/human/proc/gut,
		/mob/living/carbon/human/proc/leap,
		/mob/living/carbon/human/proc/regurgitate,
		/mob/living/carbon/human/proc/corrosive_acid,
		/mob/living/carbon/human/proc/neurotoxin,
		/mob/living/carbon/human/proc/acidspit
		)


/datum/species/zombie/handle_post_spawn(var/mob/living/carbon/human/H)
	if(H.mind)
		H.mind.assigned_role = "Zombie"
		H.mind.special_role = "Zombie"
	H.real_name = "zombie ([rand(1, 1000)])"
	H.name = H.real_name
	..()

/datum/species/zombie/handle_environment_special(var/mob/living/carbon/human/H)

	// Heal remaining damage.
	if(H.fire_stacks >= 0)
		if(H.getBruteLoss() || H.getFireLoss() || H.getOxyLoss() || H.getToxLoss())
			H.adjustBruteLoss(-heal_rate)
			H.adjustFireLoss(-heal_rate)
			H.adjustOxyLoss(-heal_rate)
			H.adjustToxLoss(-heal_rate)
	else
		H.adjustToxLoss(2*heal_rate)	// Doubled because 0.5 is miniscule, and fire_stacks are capped in both directions
