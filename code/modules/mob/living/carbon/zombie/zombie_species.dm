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
	slowdown = 1
	blood_color = "#257a03" //dark green
	flesh_color = "#282846"
	name_language = null // Use the first-name last-name generator rather than a language scrambler
	blurb = "Looks like just another night-shift worker, nothing to be worried about. Right?"
	unarmed_types = list(/datum/unarmed_attack/bite/zombie)

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
	brute_mod = 0.25
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
	slowdown = 1 //zombies are slow as fuck

	has_organ = list(
		"zombie" =    /obj/item/organ/parasite/zombie,
		"brain" =    /obj/item/organ/internal/brain/zombie
		)

	has_fine_manipulation = FALSE
	ambiguous_genders = TRUE
	has_organ = list()
	var/evolution = STANDARD_EVOLUTION
	var/heal_rate = 0.5 // Temp. Regen per tick.


	inherent_verbs = list(
		/mob/living/carbon/human/proc/tackle,
		/mob/living/carbon/human/proc/gut,
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
	else
		H.adjustToxLoss(2*heal_rate)	// Doubled because 0.5 is miniscule, and fire_stacks are capped in both directions


/datum/unarmed_attack/bite/zombie
	attack_verb = list("bit", "chomped on")
	attack_sound = 'sound/weapons/bite.ogg'
	shredding = 0
	sharp = 1
	edge = 1

/datum/unarmed_attack/bite/zombie/apply_effects(var/mob/living/carbon/human/user,var/mob/living/carbon/human/target,var/armour,var/attack_damage,var/zone)
	..()
	if(target && target.stat == DEAD)
		return
	if(target.internal_organs_by_name["zombie"])
		to_chat(user, "<span class='danger'>You feel that \the [target] has been already infected!</span>")

	var/infection_chance = 80
	var/armor = target.run_armor_check(zone,"melee")
	infection_chance -= armor
	if(prob(infection_chance))
		if(target.reagents)
			target.reagents.add_reagent("trioxin", 10)

/datum/reagent/toxin/trioxin
	name = "Trioxin"
	id = "trioxin"
	description = "A synthetic compound of unknown origins, designated originally as a performance enhancing substance."
	reagent_state = LIQUID
	color = "#E7E146"
	strength = 1
	metabolism = REM
	affects_dead = TRUE

/datum/reagent/toxin/trioxin/affect_blood(var/mob/living/carbon/M, var/removed)
	..()
	if(istype(M,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = M

		if(H.reagents.has_reagent("spaceacillin", 15))
			return

		if(H.internal_organs_by_name[O_ZOMBIE])
			return

		if(!isemptylist(H.search_contents_for(/obj/item/organ/parasite/zombie)))
			return
		else
			if(!H.internal_organs_by_name[O_ZOMBIE])
				var/obj/item/organ/external/chest/affected = H.get_organ(BP_TORSO)
				var/obj/item/organ/parasite/zombie/infest = new(affected)
				infest.replaced(H,affected)

		if(ishuman(H))
			if(!H.internal_organs_by_name[O_ZOMBIE])	//destroying the brain stops trioxin from bringing the dead back to life
				return

			if(H && H.stat != DEAD)
				return

			for(var/datum/language/L in H.languages)
				H.remove_language(L.name)
			H.set_species("Zombie")
			H.revive()
			infected.add_antagonist(H.mind)
			playsound(H.loc, 'sound/hallucinations/far_noise.ogg', 50, 1)
			to_chat(H,"<font size='3'><span class='cult'>You return back to life as the undead, all that is left is the hunger to consume the living and the will to spread the infection.</font></span>")