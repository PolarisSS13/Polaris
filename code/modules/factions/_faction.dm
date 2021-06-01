/** Defines a faction that is relevant to players in the game. 
Actual numbers are held inside a seperate, non-singleton object.*/
/decl/faction
	// Fluff for UI
	/// The 'full name' of the faction.
	var/name = null

	/// A shorter version of the faction's full name.
	var/short_name = null

	/// A very short version of the faction's full name.
	var/acronym = null

	/// A string used to classify the 'kind' of faction, mostly for flavor.
	var/class = null

	/// A short blurb of how the faction relates to players.
	var/desc = null

	/// If TRUE, UIs should not display the faction.
	var/hidden = FALSE

	/// Used to determine sorting order for factions. Higher numbers mean it will come before those with lower numbers.
	var/sorting_order = 0


	// Opinion
	/// How low opinion can drop to, acting as a minimum value.
	var/opinion_low_bound = 0

	/// How high opinion can rise to, acting as a maximum value.
	var/opinion_high_bound = 1000

	/** What value that opinion will try to move towards.
	If persistence is disabled, the faction will start out with this much opinion every round,
	otherwise it will be the initial opinion value if there is no serialized data for this faction.*/
	var/opinion_equilibrium = 500

	/** Every real life day, opinion is shifted towards the equilibrium value, 
	whether opinion is above or below equilibrium.
	Numbers closer to 1 makes opinion change slower, and numbers farther from 1 make it change faster.
	Example: 0.98 will make opinion decay 2% every day, towards the equilibrium value.
	This value must be between 0 and 1, inclusive.*/
	var/opinion_decay_rate = 0.95

	/// What opinion is called on the UI. Used for flavor.
	var/opinion_name = "Opinion"

	/** A list containing threshold decl types. It should be ordered from highest to lowest.
	At least one threshold is required, but you can have as many as you want on a per-faction basis.*/
	var/list/decl/faction_opinion_threshold/opinion_thresholds = list(
		/decl/faction_opinion_threshold/great,
		/decl/faction_opinion_threshold/good,
		/decl/faction_opinion_threshold/neutral,
		/decl/faction_opinion_threshold/bad,
		/decl/faction_opinion_threshold/worse
	)

	// Influence
	/** How much influence the station starts with, if it's the first time the station has seen this faction, 
	or if persistence is turned off.*/
	var/starting_influence = 0

	/// How much influence can be stored at once, acting as a cap.
	var/influence_cap = 100

	/// What Influence is called in the UI. Used for flavor.
	var/influence_name = "Influence"

	/// A list of faction favor decl types. This determines what players can spent influence on.
	var/list/decl/faction_favor/favors = null

	// Relations with other factions.
	/** Opinion shift can also affect friendly factions, generally to a lesser degree.
	The opinion shift sent to friends is not taken out from the original shift.
	Both positive and negative shifts are spread to friends.*/
	var/list/decl/faction/friends = null

	/** If a faction is friends with another faction, a portion of opinion shift is also sent to 
	that faction's friends. The opinion sent is not taken out of the original faction's opinion shift.
	Higher numbers makes opinion shifts with friends follow the original faction more closely.*/
	var/friend_opinion_multiplier = 0.5

	/** Opinion shift can also affect hostile factions, generally to a lesser degree.
	The opinion shift sent to enemies is not taken out from the original shift.
	Unlike friendly factions, the opinion shift sent to enemies is inverted, meaning that
	positive shifts to the original action result in negative shifts to their enemies, and 
	vice versa.*/
	var/list/decl/faction/enemies = null

	/** If a faction is enemies with another faction, an inverted portion of opinion shift is also sent to 
	that faction's enemies. The opinion sent is not taken out of the original faction's opinion shift.
	Higher numbers make it difficult or impossible to please 'both sides' at the same time.*/
	var/enemy_opinion_multiplier = 0.5

// Faction representing the station's boss.
// Generally supportive and can give aid cheaper, even if it's not the best aid.
// Having low opinion might result in restrictions being placed on the station.
/decl/faction/suzerain
	class = "High Command"
	sorting_order = 1000
	opinion_equilibrium = 600
	starting_influence = 20
	influence_name = "Clout"
	opinion_thresholds = list(
		/decl/faction_opinion_threshold/great/suzerain,
		/decl/faction_opinion_threshold/good/suzerain,
		/decl/faction_opinion_threshold/neutral/suzerain,
		/decl/faction_opinion_threshold/bad/suzerain,
		/decl/faction_opinion_threshold/worse/suzerain
	)

/decl/faction_opinion_threshold/worse/suzerain
	name = "Angry"

/decl/faction_opinion_threshold/bad/suzerain
	name = "Disappointed"

/decl/faction_opinion_threshold/neutral/suzerain
	name = "Adequate"

/decl/faction_opinion_threshold/good/suzerain
	name = "Pleased"

/decl/faction_opinion_threshold/great/suzerain
	name = "Approving"


/** Represents a thing that exists, generally contained inside a larger overall faction.
Making them happy helps make the faction as a whole happier.*/
/decl/faction/holding // TODO better name
	class = "Holding"
	sorting_order = 60

/** Faction representing governments, such as whichever one governs the place the crew exist in.
Having low opinion is not something the crew wants.*/
/decl/faction/government
	class = "Government"
	sorting_order = 50

/** Corporate factions generally just wanna sell stuff.
Low opinion doesn't really do anything bad besides making it harder to get sweet discounts.*/
/decl/faction/corporate
	class = "Corporate"
	sorting_order = 40
	opinion_thresholds = list(
		/decl/faction_opinion_threshold/great/corporate,
		/decl/faction_opinion_threshold/good/corporate,
		/decl/faction_opinion_threshold/neutral/corporate,
		/decl/faction_opinion_threshold/bad/corporate,
		/decl/faction_opinion_threshold/worse/corporate
	)

/** Media factions represent the press, in many flavors such as corporate media giants, 
state-controlled propaganda, yellow journalism, clickbait, and perhaps even honest news.
Having a low opinion with media factions make opinion decline with other factions periodically, 
due to bad press, while having high opinion can be great to fix opinion issues with other factions 
as a result of a few PR campaigns.
*/
/decl/faction/media
	class = "Media"
	sorting_order = 30

/decl/faction/ideological
	class = "Ideological"
	sorting_order = 20
	enemy_opinion_multiplier = 0.8

/** PMCs tend to be difficult to please, and might try to hurt you if someone else pays them enough to do it.
Having sufficently high opinion can protect from this. Whether or not that's a racket is up to you.*/
/decl/faction/paramilitary
	class = "Paramilitary"
	sorting_order = 10
	opinion_equilibrium = 300
	opinion_thresholds = list(
		/decl/faction_opinion_threshold/great/paramilitary,
		/decl/faction_opinion_threshold/good/paramilitary,
		/decl/faction_opinion_threshold/neutral/paramilitary,
		/decl/faction_opinion_threshold/bad/paramilitary,
		/decl/faction_opinion_threshold/worse/paramilitary
	)

/decl/faction_opinion_threshold/worse/paramilitary
	name = "Danger"

/decl/faction_opinion_threshold/bad/paramilitary
	name = "Unprotected"

/decl/faction_opinion_threshold/neutral/paramilitary
	name = "At Risk"

/decl/faction_opinion_threshold/good/paramilitary
	name = "Safe"

/decl/faction_opinion_threshold/great/paramilitary
	name = "Protected"


/** Criminal factions are generally hard to please, will actually try to hurt you if they don't like you, 
and working with them can pose risk to relations with more upstanding factions.*/
/decl/faction/criminal
	class = "Criminal"
	sorting_order = 0
	opinion_equilibrium = 0


/decl/faction/proc/get_opinion_threshold(opinion_amount)
	for(var/type_path in opinion_thresholds)
		var/decl/faction_opinion_threshold/threshold = GET_DECL(type_path)
		if(opinion_amount >= threshold.minimum_opinion)
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

/decl/faction_opinion_threshold/worse/corporate

/decl/faction_opinion_threshold/bad/corporate

/decl/faction_opinion_threshold/neutral/corporate
	name = "Customer"

/decl/faction_opinion_threshold/good/corporate
	name = "Valued Customer"

/decl/faction_opinion_threshold/great/corporate
	name = "Special Customer"

/decl/faction_opinion_threshold/proc/get_desc()
	var/list/lines = list()
	if(effects)
		lines += effects
	if(cargo_price_modifier != 1.0)
		var/percentage = abs( (1 - cargo_price_modifier) * 100)
		lines += "Prices for cargo orders from them are <b>[percentage]%</b> [cargo_price_modifier < 1.0 ? "cheaper" : "more expensive"]."
	return jointext(lines, "<br>")