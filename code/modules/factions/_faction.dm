// Definitions for factions that the station can interact with in some form.
/decl/faction
	// Fluff for UI
	var/name = null			// Name shown to players in UIs.
	var/short_name = null
	var/acronym = null
	var/class = null
	var/desc = null			// A short blurb of how the faction relates to the facility.
	var/hidden = FALSE

	// Opinion
	var/opinion_low_bound = 0		// How low opinion can drop to.
	var/opinion_high_bound = 1000	// How high opinion can rise to.
	var/opinion_equilibrium = 500	// What value that opinion will try to move towards, and what it starts out as.
	var/opinion_decay_rate = 0.01	// How fast opinion decays towards the target value.

	var/list/decl/faction_opinion_threshold/opinion_thresholds = list(
		/decl/faction_opinion_threshold/great,
		/decl/faction_opinion_threshold/good,
		/decl/faction_opinion_threshold/neutral,
		/decl/faction_opinion_threshold/bad,
		/decl/faction_opinion_threshold/worse
	)

	// Influence
	var/influence_cap = 100			// How much influence can be stored.

	// Relations with other factions.
	var/list/friends = null // Making them happy makes their friends somewhat happier too.
	var/list/enemies = null // Making them happy makes their enemies mad.

// Represents a thing that exists, generally contained inside a larger overall faction.
// Making them happy helps make the faction as a whole happier.
/decl/faction/holding // TODO better name

// Faction representing the station's boss.
// Generally supportive and can give aid cheaper, even if it's not the best aid.
// Having low opinion might result in restrictions being placed on the station.
/decl/faction/suzerain
	class = "High Command"
	opinion_equilibrium = 600
	opinion_thresholds = list(
		/decl/faction_opinion_threshold/great/boss,
		/decl/faction_opinion_threshold/good/boss,
		/decl/faction_opinion_threshold/neutral/boss,
		/decl/faction_opinion_threshold/bad/boss,
		/decl/faction_opinion_threshold/worse/boss
	)

// Corporate factions generally just wanna sell stuff.
// Low opinion doesn't really do anything bad besides making it harder to get sweet discounts.
/decl/faction/corporate
	class = "Corporate"

// Faction representing governments, such as whichever one governs the place the crew exist in.
// Having low opinion is not something
/decl/faction/government
	class = "Government"

/decl/faction/ideological
	class = "Political"

// Criminal factions are generally hard to please, will actually try to hurt you if they don't like you, 
// and working with them can pose risk to relations with more upstanding factions.
/decl/faction/criminal
	class = "Criminal"
	opinion_equilibrium = 0


/decl/faction/proc/get_opinion_threshold(opinion_amount)
	for(var/type_path in opinion_thresholds)
		var/decl/faction_opinion_threshold/threshold = GET_DECL(type_path)
		if(opinion_amount > threshold.minimum_opinion)
			return threshold


// Holds information for different thresholds.
/decl/faction_opinion_threshold
	var/name = null
	var/desc = null
	var/effects = null
	var/minimum_opinion = 0
	var/color = COLOR_WHITE
	var/cargo_price_modifier = 1.0 // How much to adjust prices from cargo packs sold by this faction.

// Default templates for thresholds.
// Generally specific factions will override to add personalized descriptors.
/decl/faction_opinion_threshold/worse
	name = "Distant"
	color = COLOR_RED
	cargo_price_modifier = 2.0

/decl/faction_opinion_threshold/bad
	name = "Cold"
	minimum_opinion = 200
	color = COLOR_YELLOW
	cargo_price_modifier = 1.5

/decl/faction_opinion_threshold/neutral
	name = "Neutral"
	minimum_opinion = 400

/decl/faction_opinion_threshold/good
	name = "Warm"
	color = COLOR_LIME
	minimum_opinion = 600
	cargo_price_modifier = 0.9

/decl/faction_opinion_threshold/great
	name = "Close"
	minimum_opinion = 800
	cargo_price_modifier = 0.8
	color = COLOR_CYAN

/decl/faction_opinion_threshold/worse/boss

/decl/faction_opinion_threshold/bad/boss
	name = "Disappointed"

/decl/faction_opinion_threshold/neutral/boss
	name = "Adequate"

/decl/faction_opinion_threshold/good/boss
	name = "Pleased"

/decl/faction_opinion_threshold/great/boss

/decl/faction_opinion_threshold/neutral/corporate
	name = "Customer"

/decl/faction_opinion_threshold/proc/get_desc()
	var/list/lines = list()
	if(effects)
		lines += effects
	if(cargo_price_modifier != 1.0)
		var/percentage = abs( (1 - cargo_price_modifier) * 100)
		lines += "Prices for cargo orders from them are <b>[percentage]%</b> [cargo_price_modifier < 1.0 ? "cheaper" : "more expensive"]."
	return jointext(lines, "<br>")