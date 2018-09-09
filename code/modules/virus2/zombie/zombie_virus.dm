/datum/disease2/effect/zombie_transformation
	name = "Zombie Transformation"
	stage = 4
	badness = 3

/datum/disease2/effect/zombie_transformation/activate(var/mob/living/carbon/mob,var/multiplier)
	if(istype(mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = mob
		var/obj/item/organ/external/O = pick(H.organs)
		if(prob(25))
			mob << "<span class='warning'>It feels like your [O.name] is on fire and your blood is boiling!</span>"
			H.adjust_fire_stacks(1)
		if(prob(10))
			mob << "<span class='warning'>Flames erupt from your skin, your entire body is burning!</span>"
			H.adjust_fire_stacks(2)
			H.IgniteMob()

/obj/item/weapon/reagent_containers/glass/bottle/zombie
	name = "Zombie culture bottle"
	desc = "A small bottle. Contains a small dosage of zombitis."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"
	New()
		..()
		var/datum/disease2/disease/F = new /datum/disease2/disease/zombie_virus(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 20, data)
		update_icon()

/datum/disease2/disease/zombie_virus
	infectionchance = 100
	speed = 1
	spreadtype = "Blood" // Can also be "Contact" or "Airborne"
	max_stage = 5
	affected_species = SPECIES_HUMAN
	list/datum/disease2/effectholder/effects = list(
	/datum/disease2/effect/groan,
	/datum/disease2/effect/hallucinations,
	/datum/disease2/effect/confusion,
	/datum/disease2/effect/scream,
	/datum/disease2/effect/fridge,
	/datum/disease2/effect/twitch,
	/datum/disease2/effect/zombie_transformation
	)

/datum/disease2/disease/zombie_virus/name()
	.= "zombie #[add_zero("[uniqueID]", 4)]"
	if ("[uniqueID]" in virusDB)
		var/datum/data/record/V = virusDB["[uniqueID]"]
		.= V.fields["name"]