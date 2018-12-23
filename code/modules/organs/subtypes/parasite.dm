/obj/item/organ/internal/parasite
	name = "parasite"
	icon = 'icons/mob/alien.dmi'
	icon_state = "burst_lie"
	dead_icon = "bursted_lie"

	organ_tag = "parasite"
	var/stage = 1
	var/max_stage = 4
	var/stage_ticker = 0
	var/stage_interval = 600 //time between stages, in seconds
	var/subtle = 0 //will the body reject the parasite naturally?

/obj/item/organ/internal/parasite/process()
	..()

	if(!owner)
		return

	if(stage < max_stage)
		stage_ticker += 2 //process ticks every ~2 seconds

	if(stage_ticker >= stage*stage_interval)
		stage = min(stage+1,max_stage)

/obj/item/organ/internal/parasite/handle_rejection()
	if(subtle)
		return ..()
	else
		if(rejecting)
			rejecting = 0
		return


/obj/item/organ/internal/parasite/zombie
	name = "cordyceps vessel"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "vessel"
	dead_icon = "vessel_burst"
	organ_tag = "zombie"
	parent_organ = "head"
	stage_interval = 70

/obj/item/organ/internal/parasite/zombie/process()
	if (!owner)
		visible_message("<span class='warning'>[src] sizzles and pops open, revealing a gooey green mass!</span>")
		die()
		return
	if(!isundead(owner))
		if(prob(10) && !(owner.species.flags & NO_PAIN))
			owner << "<span class='warning'>You feel a burning sensation on your skin!</span>"
			owner.make_jittery(10)

		else if(prob(10))
			owner.emote("groan")

		if(stage >= 2)
			if(prob(15))
				owner.emote("scream")
				if(!isundead(owner))
					owner.adjustBrainLoss(2, 55)

			else if(prob(10))
				if(!isundead(owner))
					owner << "<span class='warning'>You feel sick.</span>"
					owner.adjustToxLoss(5)

		if(stage >= 3)
			if(prob(10))
				if(isundead(owner))
					owner.adjustBruteLoss(-30)
					owner.adjustFireLoss(-30)
				else
					owner << "<span class='cult'>You feel an insatiable hunger.</span>"
					owner.nutrition = -1

		if(stage >= 4)
			if(prob(90))
				if(ishuman(owner))
					for(var/datum/language/L in owner.languages)
						owner.remove_language(L.name)
					owner << "<span class='warning'>You feel life leaving your husk, but death rejects you...</span>"
					playsound(loc, 'sound/hallucinations/far_noise.ogg', 50, 1)
					owner.zombify()

				else
					owner.adjustToxLoss(50)
	else
		return

	..()