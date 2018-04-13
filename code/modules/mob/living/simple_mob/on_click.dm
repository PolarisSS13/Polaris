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

	switch(a_intent)
		if(I_HELP)
			if(isliving(A))
				custom_emote(1,"[pick(friendly)] [A]!")

		if(I_HURT)
			if(prob(special_attack_prob))
				if(special_attack_min_range <= 1)
					special_attack_target(A)

			else if(melee_damage_upper == 0 && istype(A,/mob/living))
				custom_emote(1,"[pick(friendly)] [A]!")

			else
				attack_target(A)

		if(I_GRAB)
			if(has_hands)
				A.attack_hand(src)

		if(I_DISARM)
			if(has_hands)
				A.attack_hand(src)

/mob/living/simple_mob/RangedAttack(var/atom/A)
//	setClickCooldown(get_attack_speed())
	var/distance = get_dist(src, A)

	if(prob(special_attack_prob) && (distance >= special_attack_min_range) && (distance <= special_attack_max_range))
		special_attack_target()
		return

	if(projectiletype)
		shoot_target(A)