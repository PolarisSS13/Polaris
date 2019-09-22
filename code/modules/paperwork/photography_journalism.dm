

//Journalistic Features

/obj/item/device/camera/proc/get_sensationalist_value(turf/the_turf as turf)

	var/sensational			//pictures of high ranking people, depending on rank

	// How valuable is their job to the media?

	for(var/mob/living/carbon/human/A in the_turf)
		// Sensational Points.
		// What's their job?
		if(A.mind)
			var/job = A.mind.assigned_role

			if(job in command_positions)
				sensational += 10

			if(job in gov_positions)
				sensational += 25

			if(job == "President")
				sensational += 10		// A few extra points to that gov member being a president.

			if(job == "Nanotrasen CEO")
				sensational += 20		// GET HIM

			if(A.mind.prefs)
				if(A.mind.prefs.economic_status == CLASS_UPPER)
					sensational += 5
					
			// If this person is unimportant, we don't care if they were arrested
			// If they're in an important role or upper class, check to see if they look arrested.
			
			if(sensational > 0) 
				if(A.w_uniform)
					var/obj/item/clothing/C = A.w_uniform
					if (istype(C, /obj/item/clothing/under/color/orange))
						sensational = sensational * 2
				if(A.handcuffed)
					sensational = sensational * 2
	return sensational

/obj/item/device/camera/proc/get_gruesome_value(turf/the_turf as turf)
	var/gruesome			//people covered with blood, dead bodies, etc

	for(var/obj/effect/decal/cleanable/blood/B in the_turf)
		gruesome++

	for(var/mob/living/M in the_turf)
		if(M.stat == DEAD)	// oh lord ded bodies.
			gruesome += 3
			if(ishuman(M))
				gruesome += 5	// another 5 points if they're actually human

	return gruesome

/obj/item/device/camera/proc/get_scandalous_value(turf/the_turf as turf)
	var/scandalous			//people looking suspicious, or something that would be embarrassing

	for(var/mob/living/carbon/human/H in the_turf)
		if(!(H.wear_mask && (H.wear_mask.flags_inv&HIDEFACE)) && !(H.head && (H.head.flags_inv&HIDEFACE)))
			if(H.bloody_hands || H.feet_blood_color)	// suspicious!
				scandalous += 3


			if(H.worn_clothing.len > 0)
				var/list/clothing_list = H.worn_clothing
				for(var/obj/item/clothing/C in clothing_list)
					if(C.blood_color)
						scandalous += 4				// oh my there's blood on your clothes?!
			else // ha ha, they're naked
				if(H.species)
					if((H.age > 17) && (istype(H.species, /datum/species/human)))
						scandalous += 4

			if(istype(H.r_hand, /obj/item/weapon/material/knife) || istype(H.l_hand, /obj/item/weapon/material/knife))
				scandalous += 4			// oi got a loisence for that knife?

			if(istype(H.r_hand, /obj/item/weapon/gun) || istype(H.l_hand, /obj/item/weapon/gun))
				if(H.mind)
					var/job = H.mind.assigned_role

					if(!job in security_positions)
						scandalous += 10	// this person got a gun and ain't police?!
		else
			scandalous += 3 // a mystery!

			if(istype(H.r_hand, /obj/item/weapon/material/knife) || istype(H.l_hand, /obj/item/weapon/material/knife))
				scandalous += 6			// the masked stabber!

			if(istype(H.r_hand, /obj/item/weapon/gun) || istype(H.l_hand, /obj/item/weapon/gun))
				scandalous += 7			// mystery person with a gun!

	return scandalous

/obj/item/device/camera/proc/get_scary_value(turf/the_turf as turf)
	var/scary			//spoopy things


	for(var/obj/item/weapon/bone/B in the_turf)
		scary += 2	// spoopy spoopy skeletons

	for(var/mob/living/simple_animal/A in the_turf)
		if(istype(A, /mob/living/simple_animal/construct))
			scary += 40	// constructs are very spoopy!

		if(istype(A, /mob/living/simple_animal/shade))
			scary += 25	// literally living ghost demons.

		if(istype(A, /mob/living/simple_animal/hostile/clown))
			scary += 80	// SWEET JESUS

		if(istype(A, /mob/living/simple_animal/hostile/giant_spider))
			var/mob/living/simple_animal/hostile/giant_spider/S = A
			scary += S.melee_damage_lower	// I don't care what you say, these fucks are always scary.

	for(var/obj/singularity/narsie/N in the_turf)
		scary += 5000	// I DIE FOR THE PRESS


	return scary
