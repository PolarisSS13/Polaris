// Surgical incision (Surgery)
// Tracks steps to get to all of the surgery steps for poking around inside someone.
/datum/wound/surgical_incision
	name = "surgical incision"
	autohealing = FALSE
	closed = FALSE
	surgery_steps = list(list(/* Clamp bleeders */),
	                     list(/* Retractor */), // Short-circuits to the last if not encased
						 list(/* Cut encasement */),
						 list(/* Pry encasement */),
						 list(/* Like, all of them */))
	var/stage = 1 // Tracks surgery steps internal to opening up the incision

/datum/wound/surgical_incision/New(var/obj/item/organ/affecting = null, var/brute_dam = 1)
	..(affecting, list(BRUTE = brute_dam))

/datum/wound/surgical_incision/close()
	damage[BRUTE] = 0
	closed = TRUE

/datum/wound/surgical_incision/get_surgery_steps()
	// Handle encased organs, there's extra steps
	return surgery_steps[stage]

/datum/wound/surgical_incision/get_examine_tag()
	switch(stage)
		if(1)
			return "cut"
		if(2)
			return "cleaned cut"
		if(3 to 5)
			return "surgical opening"

// Broken Bones
// Treatable via splints, surgery, or chems
/datum/wound/broken_bone
	name = "broken bone"
	autohealing = FALSE
	var/is_splinted
	var/surgery_stage = 1
	var/surgery_steps = list(list(/* Set bone */),
							 list(/* Glue bone */),
							 list(/* Clamp bone */))

// Broken bones are also closely associated with hurting like a bitch
/datum/wound/broken_bone/New(var/obj/item/organ/affecting = null, var/brute_dam)
	..(affecting, list(BRUTE = brute_dam, HALLOSS = brute_dam * 2))
	if(brute_dam >= 20)
		// Add a cut: your bones are sticking out of your flesh.

/datum/wound/broken_bone/get_examine_tag()
	switch(damage[BRUTE])
		if(0 to 10) // Fracture
			return "large swelling"
		if(10 to 20) // Proper break
			return "bent limb"
		if(20 to INFINITY) // Bones sticking out of skin
			return "exposed bone"

/datum/wound/broken_bone/process()
	// Oh gods it hurts!
	// Handle splint healing - really slow
	if(is_splinted)
		damage[BRUTE] = max(damage[BRUTE] - 0.04, 0) // ~8min for a 10 BRUTE break

// Stump (Limb removal)
// Disfigured (Head)
// Brain Reattachment Procedure (Surgery)
