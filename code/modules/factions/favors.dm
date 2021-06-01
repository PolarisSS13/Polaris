// Favors are requests that the station can make to a specific faction, generally with a cost.
/decl/faction_favor
	var/name = null
	var/desc = null			// Shown in the UI, explains what the favor actually does.
	var/fluff = null
	var/influence_cost = 0
	var/opinion_cost = 0
	var/minimum_opinion_threshold = /decl/faction_opinion_threshold/neutral
	var/success_chance = 100
	var/available = TRUE
	var/repeatable = FALSE // If true, the same favor can be used multiple times in the same round.
	var/refusal_message = null

/decl/faction_favor/proc/can_use_favor(datum/faction_relationship/R)
	if(!available)
		return FALSE
	if(R.influence < influence_cost)
		return FALSE
//	var/decl/faction/F = GET_DECL(R.faction_tag)
//	var/decl/faction_opinion_threshold/T = GET_DECL(minimum_opinion_threshold)
//	if(F.get_opinion_threshold(R.opinion) < T.minimum_opinion)
//		return FALSE
	return TRUE

/decl/faction_favor/proc/pay_for_favor(datum/faction_relationship/R)
	if(influence_cost)
		SSreputation.adjust_influence(R.faction_tag, -influence_cost, name)
	if(opinion_cost)
		SSreputation.adjust_opinion(R.faction_tag, -opinion_cost, name)

 // TODO Better name.
/decl/faction_favor/proc/pre_favor()
	if(!prob(success_chance))
		return FALSE
	return TRUE

 // TODO Better name.
/decl/faction_favor/proc/post_favor()
	if(!repeatable)
		available = FALSE

/decl/faction_favor/proc/execute_favor(datum/faction_relationship/R)
	if(!can_use_favor(R)) // Some extra sanity.
		return FALSE
	pay_for_favor(R) // Paying prior to RNG potentially saying no is intentional.
	if(!pre_favor())
		return FALSE
	do_favor()
	post_favor()

 // TODO Better name.
/decl/faction_favor/proc/do_favor()
// Custom logic goes here.

/decl/faction_favor/proc/get_success_chance()
	return success_chance

// Used to obfuscate pure numbers into less precise words.
/decl/faction_favor/proc/get_eligibility_string(datum/faction_relationship/R)
	if(!available)
		return "Unavailable"
	if(R.influence < influence_cost)
		return "Impossible"
	switch(get_success_chance())
		if(-INFINITY to 0)
			return "Impossible"
		if(0 to 20)
			return "Very Unlikely"
		if(20 to 40)
			return "Unlikely"
		if(40 to 60)
			return "Coinflip"
		if(60 to 80)
			return "Likely"
		if(80 to 99)
			return "Very Likely"
		if(100 to INFINITY)
			return "Guaranteed"

/decl/faction_favor/generic/discount
	name = "Negotiate Discount"
	desc = "The Cargo department will receive a discount for supply packs sourced from this organization, lasting for the current shift."
	success_chance = 50
	influence_cost = 20

/decl/faction_favor/generic/discount/nanotrasen
	success_chance = 75
	influence_cost = 10

/decl/faction_favor/nanotrasen/bailout
	name = "Request Bailout"
	desc = "Requests an injection of funds from the Company, into the facility's account. \
	Doing this will reflect poorly on the facility's performance."
	influence_cost = 40
	opinion_cost = 300

/decl/faction_favor/nanotrasen/bailout/do_favor()


/decl/faction_favor/nanotrasen/medical_aid
	name = "Request Medical Aid"
	desc = "Requests an emergency shipment of medical supplies to be sent to the facility."
	influence_cost = 15

/decl/faction_favor/nanotrasen/combat_drones
	name = "Request Combat Drones"
	desc = "Requests a group of allied combat drones to be sent to the facility. \
	A remote control is also included, which is used to direct the drones. \
	The drones are expendable and there is no penalty if they are destroyed."
	influence_cost = 20