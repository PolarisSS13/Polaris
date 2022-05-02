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
