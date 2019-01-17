/datum/organization/gov/solgov
	name = "Solar Confederate Government"
	short_name = "SolGov"
	acronym = "SCG"
	desc = "SolGov is a decentralized confederation of human governmental entities based on Luna, Sol, which defines top-level law for their member states.  \
	Member states receive various benefits such as defensive pacts, trade agreements, social support and funding, and being able to participate \
	in the Colonial Assembly.  The majority, but not all human territories are members of SolGov.  As such, SolGov is a major power and \
	defacto represents humanity on the galactic stage."
	history = "" // Todo
	work = "governing polity of humanity's Confederation"
	headquarters = "Luna, Sol"
	motto = "Nil Mortalibus Ardui Est" // Latin, because latin.  Says 'Nothing is too steep for mortals'.
	autogenerate_destination_names = TRUE

	ship_prefixes = list("SCG-T" = "transportation", "SCG-D" = "diplomatic", "SCG-F" = "freight")
	destination_names = list(
						"Venus",
						"Earth",
						"Luna",
						"Mars",
						"Titan"
						)// autogen will add a lot of other places as well.
