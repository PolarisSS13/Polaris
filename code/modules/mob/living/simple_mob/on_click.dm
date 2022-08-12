/*
	Animals
*/
/mob/living/simple_mob/UnarmedAttack(var/atom/A, var/proximity)
	if(!(. = ..()))
		return

//	setClickCooldown(get_attack_speed())

	if(has_hands && istype(A,/obj) && a_intent != I_HURT)
		var/obj/O = A
		return O.attack_hand(src)

	return do_interaction(A)

/mob/living/simple_mob/RangedAttack(var/atom/A)
//	setClickCooldown(get_attack_speed())

	if(can_special_attack(A) && special_attack_target(A))
		return

	if(projectiletype)
		shoot_target(A)

/mob/living/simple_mob/proc/do_interaction(var/atom/A)
	switch(a_intent)
		if(I_HURT)
			return do_hurt_interaction(A)
		if(I_GRAB)
			return do_grab_interaction(A)
		if(I_DISARM)
			return do_disarm_interaction(A)
	return do_help_interaction(A)

/mob/living/simple_mob/proc/do_help_interaction(var/atom/A)
	if(isliving(A))
		custom_emote(1,"[pick(friendly)] \the [A]!")
		return TRUE
	return FALSE

/mob/living/simple_mob/proc/do_hurt_interaction(var/atom/A)
	if(can_special_attack(A) && special_attack_target(A))
		return
	else if(melee_damage_upper == 0 && istype(A,/mob/living))
		custom_emote(1,"[pick(friendly)] \the [A]!")
	else
		attack_target(A)

/mob/living/simple_mob/proc/do_disarm_interaction(var/atom/A)
	if(has_hands)
		A.attack_hand(src)
	else
		attack_target(A)

/mob/living/simple_mob/proc/do_grab_interaction(var/atom/A)
	if(has_hands)
		A.attack_hand(src)
	else
		attack_target(A)
