
/datum/wound
	var/autohealing = TRUE
	var/list/damage = list() // list(DAM_TYPE = DAMAGE)
	var/obj/item/organ/affecting = null
	var/closed = TRUE
	var/remove_when_no_damage = TRUE  // Some wounds have effects beyond simple damage
	var/healing_chem_scale_factor = 1 // Smaller numbers mean chems are less effective against this wound.
	var/list/surgery_steps = list()   // The list of surgery steps added by this wound
	var/is_infected = FALSE           // If the wound has become infected. Open wounds can become infected, and other wounds may have separate logic

/datum/wound/New(var/obj/item/organ/affecting = null, var/list/damage = null)
	if(!istype(affecting))
		return // Wounds exist only to apply suffering.
	src.affecting = affecting
	if(LAZYLEN(damage))
		src.damage = damage

/datum/wound/Destroy()
	affecting?.clear_wound(src)
	affecting = null
	return ..()

/datum/wound/proc/get_damage(var/damage_type)
	return LAZYFIND(damage, damage_type)

/datum/wound/proc/get_damage_total()
	. = 0
	for(var/damage_type in damage)
		. += damage[damage_type]

/datum/wound/proc/process()
	if(!istype(affecting))
		qdel(src)
		return
	
	for(var/damage_type in damage)
		if(autohealing)
			damage[damage_type] -= 0.1
		if(damage[damage_type <= 0])
			damage.Remove(damage_type)
	
	if(!LAZYLEN(damage) && remove_when_no_damage)
		qdel(src)
		return
	
	if(!closed)
		// Infections!
	
	// do the pain

// Oops, you seem to be leaking!
// Only functional if called during affecting's process step, because affecting won't have reagents to bleed otw!
/datum/wound/proc/try_bleed(var/damage_scale_type, var/bleeding_scale_factor)
	var/bloodloss = min(affecting?.reagents.total_volume * damage[damage_scale_type] * bleeding_scale_factor,
	                    affecting?.reagents.total_volume)
	if(bloodloss <= 0)
		return
	
	var/turf/T = get_turf(affecting)
	var/obj/effect/decal/cleanable/blood/drip/D = new(T)
	D.blood_DNA += affecting.dna
	D.basecolor = affecting.reagents.get_color()
	D.update_icon()
	affecting.reagents.remove_any(bloodloss)

// Used to count up the different kinds of injury when examining oneself.
/datum/wound/proc/get_examine_tag()
	return "injury" // That looks painful!

/datum/wound/proc/close(var/obj/item/bandage)
	closed = TRUE

/datum/wound/proc/get_surgery_steps()
	return surgery_steps

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

/******************************** BURN WOUNDS ********************************/
// Burn
// Treatable via burn cream, burn chems, or surgery, up to a point.
// If a limb is too burnt, it can be husked, and require amputation, or ashed, and amputate itself.
/datum/wound/burn
	name = "burn"
	surgery_steps = list(/* Clean wound */)

/datum/wound/burn/New(var/obj/item/organ/affecting = null, var/burn_dam)
	..(affecting, list(BURN = burn_dam))
	autohealing = (burn_dam < 20) // Severe burns can't get better on their own.
	closed = (burn_dam < 20)      // And too much burns will expose flesh.
	
	// Ashing starts at 150% affecting's max health,
	// with a 50% chance that increases above that threshold.
	if(burn_dam > 1.5 * affecting.max_health && \
	   prob(50 * burn_dam / (1.5 * affecting.max_health)))
		affecting.ash()

	// Husking starts at 75% affecting's max health,
	// with a 50% chance that increases above that threshold.
	else if(burn_dam > 0.75 * affecting.max_health && \
	        prob(50 * burn_dam / (0.75 * affecting.max_health)))
		affecting.husk()

/datum/wound/burn/get_examine_tag()
	switch(damage[BURN])
		if(0 to 10)
			return "small welt"
		if(10 to 20)
			return "blister"
		if(20 to 40)
			return "burn"
		if(40 to INFINITY)
			return "severe burn"

// Can't clean the burn if the limb is toast
/datum/wound/burn/get_surgery_steps()
	return affecting.husked ? list() : ..()
	

/******************************** TOX WOUNDS ********************************/
// Infection -- Ticks up toxloss over time
// Treatable by surgical excision (quick), or by chems
/datum/wound/infection
	name = "infection"
	autohealing = FALSE
	var/tox_damage_increment = 0.05 // 1.5 TOX / minute
	surgery_steps = list(/* Excise */)

/datum/wound/infection/New(var/obj/item/organ/affecting = null, var/tox_dam)
	..(affecting, list(TOX = tox_dam))

/datum/wound/infection/get_examine_tag()
	return "swollen spot"

/datum/wound/infection/process()
	// It gets worse over time until treated
	damage[TOX] += tox_damage_increment

/datum/wound/infection/get_surgery_steps()
	// If there's a surgical opening to access the infected tissue,
	if(FALSE)
		return surgery_steps
	return list()

// Gangrene (Rot)

// Rash -- annoying itchy messages
// Treatable by applying ointment, or with chems
/datum/wound/rash
	name = "rash"
	autohealing = FALSE
	var/p_message = 0 // Ticks up probability of making itchy messages

/datum/wound/rash/New(var/obj/item/organ/affecting = null, var/itchiness = 1)
	..(affecting, list(HALLOSS = itchiness))

/datum/wound/rash/get_examine_tag()
	return "rash"

/datum/wound/rash/process()
	// Oh gods, it's so itchy!
	if(prob(p_message++))
		to_chat(affecting?.holder, span("warning", "Your [affecting] itches."))
		p_message = 0

/*
Wound qualities

** External ORGANS
Stump (Limb removal)
Disfigured (Head)


** Internal ORGANS
Organ Rupture
Brain Reattachment Procedure (Surgery)

Organ Death -- Not really a wound, just the organ itself is dead.
*/