
/mob/living/proc/make_grab(var/mob/living/attacker, var/mob/living/victim, var/grab_tag)
	var/obj/item/grab/G

	if(!grab_tag)
		if(attacker.current_grab_type)
			G = new attacker.current_grab_type(attacker, victim)
		else
			var/obj/item/grab/default_grab_type = all_grabobjects[GRAB_NORMAL]
			G = new default_grab_type(attacker, victim)
	else
		var/obj/item/grab/given_grab_type = all_grabobjects[grab_tag]
		G = new given_grab_type(attacker, victim)

	if(!G.pre_check())
		qdel(G)
		return 0

	if(G.can_grab())
		G.init()
		return 1
	else
		qdel(G)
		return 0

/mob/living/proc/add_grab_prints(var/mob/living/printer)
	return 0

/mob/living/carbon/human/add_grab_prints(var/mob/living/printer)
	if(w_uniform)
		w_uniform.add_fingerprint(printer)

/mob/proc/get_organ(var/zone)
	return 0