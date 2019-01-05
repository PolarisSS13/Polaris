
/mob/living/carbon/human/proc/electrify(mob/living/M as mob, var/damage)
	if(istype(M.loc,/obj/mecha))	return 0	//feckin mechs are dumb
	if(issilicon(M))	return 0	//No more robot shocks from machinery
	if(istype(M,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(H.species.siemens_coefficient <= 0)
			return
		if(H.gloves)
			var/obj/item/clothing/gloves/G = H.gloves
			if(G.siemens_coefficient == 0)	return 0		//to avoid spamming with insulated glvoes on


	//If all these checks are passed, then...
	playsound(M, 'sound/effects/sparks3.ogg', 100, 1)

	// The actual damage/electrocution is here.
	M.Paralyse(3)
	M.Weaken(1)
	M.emp_act(1)
	to_chat(M, span("critical", "You've been electricuted!"))
	M.burn_skin(damage)
	return 1
