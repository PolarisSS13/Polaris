/mob/proc/try_interaction()
	return
/*
/mob/MouseDrop(var/mob/dropped_on, mob/user as mob)
	if(src != dropped_on && !src.restrained())
		try_interaction(dropped_on)
		return
	return ..()
*/

/mob/living/carbon/human/MouseDrop_T(mob/M as mob, mob/user as mob)
	if(M == src || src == usr || M != usr)		return
	if(usr.restrained())		return

	user.try_interaction(src)

/mob/living/simple_animal/hostile/deathclaw/MouseDrop_T(mob/M as mob, mob/user as mob)
	if(M == src || src == usr || M != usr)		return
	if(usr.restrained())		return

	visible_message("Attempting")
	user.try_interaction(src)
	visible_message("Through!")

/mob/verb/interact_with()
	set name = "Interact With"
	set desc = "Perform an interaction with someone."
	set category = "IC"
	set src in view()

	if(usr != src && !usr.restrained())
		usr.try_interaction(src)

/mob/living/carbon/human/try_interaction(var/mob/partner)

	var/dat = "<B><HR><FONT size=3>Interacting with \the [partner]...</FONT></B><HR>"

	dat += "You...<br>[list_interaction_attributes()]<hr>"
	dat += "They...<br>[partner.list_interaction_attributes()]<hr>"

	make_interactions()
	for(var/interaction_key in interactions)
		var/datum/interaction/I = interactions[interaction_key]
		if(I.evaluate_user(src) && I.evaluate_target(src, partner))
			dat += I.get_action_link_for(src, partner)

	var/datum/browser/popup = new(usr, "interactions", "Interactions", 340, 480)
	popup.set_content(dat)
	popup.open()

/mob/living/simple_animal/hostile/deathclaw/try_interaction(var/mob/partner)

	var/dat = "<B><HR><FONT size=3>Interacting with \the [partner]...</FONT></B><HR>"

	dat += "You...<br>[list_interaction_attributes()]<hr>"
	dat += "They...<br>[partner.list_interaction_attributes()]<hr>"

	make_interactions()
	for(var/interaction_key in interactions)
		var/datum/interaction/I = interactions[interaction_key]
		if(I.evaluate_user(src) && I.evaluate_target(src, partner))
			dat += I.get_action_link_for(src, partner)

	var/datum/browser/popup = new(usr, "interactions", "Interactions", 340, 480)
	popup.set_content(dat)
	popup.open()
/*
/atom/movable/attack_hand(mob/living/user)
	. = ..()
	if(can_buckle && buckled_mob)
		if(user_unbuckle_mob(user))
			return 1

/atom/movable/MouseDrop_T(mob/living/M, mob/living/user)
	. = ..()
	if(can_buckle && istype(M) && !buckled_mob)
		if(user_buckle_mob(M, user))
			return 1

*/