SUBSYSTEM_DEF(reputation)
	name = "Reputation"
	init_order = INIT_ORDER_REPUTATION
	flags = SS_NO_FIRE
	var/list/datum/faction_relationship/relationships = list()

/datum/controller/subsystem/reputation/Initialize(timeofday)
	// Make the factions we care about.
	var/list/faction_types = decls_repository.get_decls_of_subtype(/decl/faction)
	for(var/type_path in faction_types)
		var/decl/faction/F = faction_types[type_path]
		if(!F.name)
			continue
		var/datum/faction_relationship/R = new(F)
		relationships[type_path] = R
	
	// Sort the list to be where we want them to be in the UI.
	relationships = sortTim(relationships, /proc/cmp_faction_relationships, TRUE)

	// TODO deserialize stuff here when serializer is in.

	return ..()

/proc/cmp_faction_relationships(datum/faction_relationship/A, datum/faction_relationship/B)
	var/decl/faction/faction_A = GET_DECL(A.faction_tag)
	var/decl/faction/faction_B = GET_DECL(B.faction_tag)

	. = faction_B.sorting_order - faction_A.sorting_order // First, sort by the sorting order vars.
	if(. == 0) // If they have the same var, then sort by name.
		. = sorttext(faction_B.name, faction_A.name)

/datum/controller/subsystem/reputation/proc/adjust_opinion(faction_path, amount, reason)
	var/datum/faction_relationship/R = relationships[faction_path]
	ASSERT(istype(R))
	var/old_opinion = R.opinion
	R.set_opinion(R.opinion + amount)
	log_debug("Faction opinion for [faction_path] was changed from [old_opinion] to [R.opinion]. \
	Reason: [reason ? reason : "Unspecified"].")
	if(reason)
		R.make_ingame_log(amount, reason)

/datum/controller/subsystem/reputation/proc/adjust_influence(faction_path, amount, reason)
	var/datum/faction_relationship/R = relationships[faction_path]
	ASSERT(istype(R))
	var/old_influence = R.influence
	R.set_influence(R.influence + amount)
	log_debug("Faction influence for [faction_path] was changed from [old_influence] to [R.influence]. \
	Reason: [reason ? reason : "Unspecified"].")
	if(reason)
		R.make_ingame_log(amount, reason)

/datum/controller/subsystem/reputation/proc/propagate_opinion_shift(faction_path, amount)

/datum/faction_relationship/proc/make_ingame_log(amount, reason)
	// TODO: Truncate after a certain number of logs so we don't someday get ten thousand long lists.
	var/line = "[stationtime2text()] - [reason]"
	relationship_log += line

/datum/controller/subsystem/reputation/proc/get_opinion(faction_path)
	var/datum/faction_relationship/R = relationships[faction_path]
	ASSERT(istype(R))
	return R.opinion

/datum/controller/subsystem/reputation/proc/get_opinion_threshold(faction_path)
	var/decl/faction/faction = GET_DECL(faction_path)
	return faction.get_opinion_threshold(get_opinion(faction_path))

/datum/controller/subsystem/reputation/proc/get_influence(faction_path)
	var/datum/faction_relationship/R = relationships[faction_path]
	ASSERT(istype(R))
	return R.influence

/client/verb/test_opinion_change()
	var/amount = input(usr, "How much?", "Opinion Change", 0) as null|num
	if(isnull(amount))
		return
	var/faction_path = input(usr, "Which faction?", "Opinion Change") as null|anything in SSreputation.relationships
	SSreputation.adjust_opinion(faction_path, amount, "Test Verb")

// A small datum to hold the numbers.
// The actual faction information is held inside of /decls.
/datum/faction_relationship
	var/faction_tag = null
	var/opinion = 0
	var/influence = 0
	var/list/relationship_log = list()

/datum/faction_relationship/New(decl/faction/faction_owner)
	if(faction_owner)
		faction_tag = faction_owner.type
		opinion = faction_owner.opinion_equilibrium
		influence = faction_owner.starting_influence

/datum/faction_relationship/proc/set_opinion(amount)
	var/decl/faction/F = GET_DECL(faction_tag)
	opinion = between(F.opinion_low_bound, amount, F.opinion_high_bound)

/datum/faction_relationship/proc/set_influence(amount)
	var/decl/faction/F = GET_DECL(faction_tag)
	influence = between(0, amount, F.influence_cap)