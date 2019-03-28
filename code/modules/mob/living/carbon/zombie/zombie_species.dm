//**** EVOLUTIONS *****//

/mob/living/carbon/human/zombie
	name = "Zombie"
	desc = "A shambling abomination of a once-human. As you look at this thing you realise dinner can go both ways."
	a_intent = I_HURT

#define STANDARD_EVOLUTION 1
#define EXPULSOR_EVOLUTION 2
#define TANKER_EVOLUTION 3
#define SHAMBLER_EVOLUTION 4
#define CHASER_EVOLUTION 5

/datum/species/zombie
	name= "Zombie"
	name_plural = "Zombies"
	blood_color = "#257a03" //dark green
	flesh_color = "#282846"
	name_language = null // Use the first-name last-name generator rather than a language scrambler
	blurb = "Looks like just another night-shift worker, nothing to be worried about. Right?"
	unarmed_types = list(/datum/unarmed_attack/bite/zombie)
	has_glowing_eyes = 0
	genders = list(NEUTER)
	icobase = 'icons/mob/human_races/r_zombie.dmi'
	deform = 'icons/mob/human_races/r_zombie.dmi'

	death_message = "screeches and growls as it becomes completely motionless... is it dead?"
	default_language = "Zombie Hivemind"
	language = "Zombie Hivemind"
	has_fine_manipulation = 0
	siemens_coefficient = 0

	hunger_factor = 0
	metabolic_rate = 0

	taste_sensitivity = TASTE_DULL
	flags = NO_SCAN | NO_PAIN | NO_SLIP | NO_POISON | NO_MINOR_CUT | UNDEAD | NO_HALLUCINATION
	appearance_flags = HAS_UNDERWEAR | HAS_EYE_COLOR | HAS_HAIR_COLOR | HAS_SKIN_TONE | HAS_LIPS
	vision_flags = SEE_SELF|SEE_MOBS
	spawn_flags = SPECIES_IS_RESTRICTED
	show_ssd = null
	virus_immune = 1
	brute_mod = 2
	burn_mod = 2
	speech_chance  = 80
	speech_sounds = list('sound/voice/zombie_groan.ogg')
	death_sound = 'sound/voice/zombie_groan.ogg'
	gluttonous = 1
	breath_type = null
	poison_type = null
	warning_low_pressure = 0
	hazard_low_pressure = 0
	cold_level_1 = -1
	cold_level_2 = -1
	cold_level_3 = -1
//	hud_type = /datum/hud_data/zombie
	slowdown = 1.5 //zombies are slow as fuck
	can_drive = 0

	has_fine_manipulation = FALSE
	ambiguous_genders = TRUE
	var/evolution = STANDARD_EVOLUTION
	var/heal_rate = 1 // Temp. Regen per tick.

	has_organ = list(
		O_BRAIN =    /obj/item/organ/internal/brain/zombie
		)


	inherent_verbs = list(
//		/mob/living/carbon/human/proc/tackle,
//		/mob/living/carbon/human/proc/gut,
		/mob/living/carbon/human/proc/revive_undead,
		/mob/living/carbon/human/proc/fermented_goo

		)


/datum/species/zombie/handle_post_spawn(var/mob/living/carbon/human/H)
	if(H.mind)
		H.mind.assigned_role = "Zombie"
		H.mind.special_role = "Zombie"
	H.real_name = "[src] ([rand(1, 1000)])"
	H.name = H.real_name
	H.mutations.Add(CLUMSY)

	..()


/datum/species/zombie/handle_npc(var/mob/living/carbon/human/H)
//Zombies just drool and make funny noises if left alone, not much
//different from anyone else.
	if(H.stat != CONSCIOUS)
		return
	if(prob(33) && H.canmove && isturf(H.loc) && !H.pulledby) //won't move if being pulled
		step(H, pick(cardinal))
	if(prob(1))
		H.emote(pick("growl","scream","drool","blink"))

/datum/species/zombie/handle_environment_special(var/mob/living/carbon/human/H)
	// Heal remaining damage.
	if(H.fire_stacks >= 0)
		if(H.getBruteLoss() || H.getFireLoss() || H.getOxyLoss() || H.getToxLoss())
			H.adjustBruteLoss(-heal_rate)
			H.adjustFireLoss(-heal_rate)
			H.adjustOxyLoss(-heal_rate)
			H.adjustToxLoss(-heal_rate)
			H.SetStunned(0)
	else
		H.adjustToxLoss(2*heal_rate)	// Doubled because 0.5 is miniscule, and fire_stacks are capped in both directions


/datum/unarmed_attack/bite/zombie
	attack_verb = list("bit", "chomped on")
	attack_sound = 'sound/weapons/bite.ogg'
	shredding = 1
	sharp = 1
	edge = 1

/datum/unarmed_attack/bite/zombie/apply_effects(var/mob/living/carbon/human/user,var/mob/living/carbon/human/target,var/armour,var/attack_damage,var/zone)
	..()
	if(target && target.stat == DEAD)
		return
	if(target.internal_organs_by_name["zombie"])
		to_chat(user, "<span class='danger'>You feel that \the [target] has been already infected!</span>")

	var/infection_chance = 25
	var/armor = target.run_armor_check(zone,"melee")
	infection_chance -= armor
	if(prob(infection_chance))
		if(target.reagents)
			target.reagents.add_reagent("trioxin", 10)

