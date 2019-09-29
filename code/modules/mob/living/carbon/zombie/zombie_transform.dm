


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

		if(H.reagents.has_reagent("penicillin", 15))
			return

		if(H.stat == DEAD)
			H.zombify()
			playsound(H.loc, 'sound/hallucinations/far_noise.ogg', 50, 1)
			to_chat(H,"<font size='3'><span class='cult'>You return back to life as the undead, all that is left is the hunger to consume the living and the will to spread the infection.</font></span>")
		if(H.internal_organs_by_name[O_ZOMBIE])
			return

		if(!isemptylist(H.search_contents_for(/obj/item/organ/internal/parasite/zombie)))
			return
		else
			if(!H.internal_organs_by_name[O_ZOMBIE])
				var/obj/item/organ/external/head/affected = H.get_organ(BP_HEAD)
				var/obj/item/organ/internal/parasite/zombie/infest = new(affected)
				infest.replaced(H,affected)

		if(ishuman(H))
			if(!H.internal_organs_by_name[O_ZOMBIE])	//destroying the brain stops trioxin from bringing the dead back to life
				return

			if(H && H.stat != DEAD)
				return

			for(var/datum/language/L in H.languages)
				H.remove_language(L.name)

/mob/living/carbon/human/proc/zombify()
	for(var/datum/antagonist/zombie/W)
		W.add_antagonist(mind)

	set_species("Zombie")

	for(var/obj/item/W in src)
		src.drop_from_inventory(W)

	revive()

