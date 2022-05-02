/******************************** BRUTE WOUNDS ********************************/

// Just your average hickey. It'll get better over time.
// Catch-all for brute when there aren't more specialized wounds to apply it to.
// Treatable via chems, or bandages.
// Too much damage can lead to limb pulverization and auto-amputation.
/datum/wound/bruise
	name = "bruise"
	closed = TRUE
	autohealing = TRUE

/datum/wound/bruise/New(var/obj/item/organ/affecting = null, var/brute_dam)
	..(affecting, list(BRUTE = brute_dam))

	// Gibbing starts at 200% of an organ's max health,
	// With a 25% chance that scales linearly above that threshold.
	if(brute_dam > 2 * affecting.max_health &&
	   prob(25 * brute_dam / (2 * affecting.max_health)))
		affecting.gib()

/datum/wound/bruise/get_examine_tag()
	switch(damage[BRUTE])
		if(0 to 10)
			return "small bruise"
		if(10 to 20)
			return "bruise"
		if(20 to 40)
			return "medium bruise"
		if(40 to INFINITY)
			return "large bruise"

// Cut -- Bleeding scales with brute damage.
// Treatable via bandage, surgical sutures, or chems.
// If it's actively bleeding, chems don't work as well.
// Too much damage can lead to auto-amputation, because cuts involve sharp things.
/datum/wound/cut
	name = "cut"
	autohealing = FALSE
	closed = FALSE
	healing_chem_scale_factor = 0.1 // You're leaking.
	surgery_steps = list( /* SUTURE */ )
	var/bleeding_scale_factor = 0.01 // Organ requests 10 blood, and has a cut with 10 brute -> bleed 1u blood. Scales with both blood received, and damage.

/datum/wound/cut/New(var/obj/item/organ/affecting = null, var/brute_dam)
	..(affecting, list(BRUTE = brute_dam))

	// Decapitation starts at 80% of an organ's max health,
	// With a 25% chance that scales linearly above that threshold.
	if(brute_dam > 0.8 * affecting.max_health &&
	   prob(25 * brute_dam / (0.8 * affecting.max_health)))
		affecting.decapitate()

/datum/wound/cut/process()
	..()
	try_bleed(BRUTE, bleeding_scale_factor)
	healing_chem_scale_factor = min(healing_chem_scale_factor + 0.06 / damage[BRUTE], 1) // The blood will congeal over ~30s per point of brute
	if(closed && !LAZYLEN(damage))
		qdel(src)

/datum/wound/cut/get_examine_tag()
	switch(damage[BRUTE])
		if(0 to 10)
			return "small cut"
		if(10 to 20)
			return "cut"
		if(20 to 40)
			return "laceration"
		if(40 to INFINITY)
			return "gaping stab wound"

/datum/wound/cut/close()
	healing_chem_scale_factor = 1 // You're not leaking any more!


// Internal bleeding. You're leaking, but inside!
// Treatable via surgery, or some chems. Bloodloss scales with attached BRUTE
// If it's actively bleeding, chems don't work as well.
/datum/wound/internal_bleeding
	name = "ruptured blood vessel"
	autohealing = FALSE
	var/bleeding_scale_factor = 0.01 // Organ requests 10 blood, and has a cut with 10 brute -> bleed 1u blood. Scales with both blood received, and damage.
	closed = FALSE
	healing_chem_scale_factor = 0.1 // You're leaking.
	surgery_steps = list( /* SUTURE */ )

/datum/wound/internal_bleeding/New(var/obj/item/organ/affecting = null, var/brute_dam)
	..(affecting, list(BRUTE = brute_dam))

/atum/wound/internal_bleeding/process()
	..()
	var/bloodloss = min(affecting?.reagents.total_volume * damage[damage_scale_type] * bleeding_scale_factor,
	                    affecting?.reagents.total_volume)
	if(bloodloss > 0)
		affecting.reagents.remove_any(bloodloss)

/datum/wound/internal_bleeding/get_examine_tag()
	return "swollen spot"

/datum/wound/internal_bleeding/get_surgery_steps()
	// If there's a surgical opening to access the bleeding,
	if(FALSE)
		return surgery_steps
	return list()

// Embedded object (Shrapnel)
// Treatable via surgery, but you don't strictly need to open someone up to remove the object.
/datum/wound/embedded_object
	name = "embedded object"
	autohealing = FALSE
	remove_when_no_damage = FALSE
	closed = FALSE
	surgery_steps = list(list(/* No surgical incision: higher risk */),
						 list(/* Surgical incision: The right way to do it*/))
	var/obj/item/encased = null

/datum/wound/embedded_object/New(var/obj/item/organ/affecting = null, var/brute_dam, var/obj/encased)
	..(affecting, list(BRUTE = brute_dam))
	src.encased = encased
	// Register for signal: movement makes it worse!

/datum/wound/embedded_object/process()
	..()
	// Moving causes damage?

/datum/wound/embedded_object/get_examine_tag()
	return "swollen spot"

/datum/wound/embedded_object/get_surgery_steps()
	// If there's a surgical opening to access the bleeding,
	if(FALSE)
		return surgery_steps[1]
	return surgery_steps[2]
