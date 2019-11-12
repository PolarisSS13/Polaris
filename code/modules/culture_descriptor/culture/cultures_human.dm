/decl/cultural_info/culture/generic
	name = CULTURE_OTHER
	description = "You are from one of the many small, relatively unknown cultures scattered across the galaxy. But which?"

	other_tag = "custculture"

/decl/cultural_info/culture/human
	name = CULTURE_HUMAN
	description = "You are from one of various planetary cultures of humankind."
	secondary_langs = list(
		LANGUAGE_SOL_COMMON,
		LANGUAGE_TRADEBAND,
		LANGUAGE_TERMINUS,
		LANGUAGE_GUTTER,
		LANGUAGE_SIGN
	)

/decl/cultural_info/culture/human/earthling
	name = CULTURE_HUMAN_EARTH
	description = "You are from Earth, home of humanity. Earth culture is much as it has been for centuries, with the old nation states, while no longer politically important, still \
	culturally significant to many humans across the galaxy, as all trace their roots to somewhere on the planet. While not as geographically diverse as they were in the past, most \
	countries have at least two arcologies which make up much of the population, with the remaining humans living in small villages or from one of the many nature preserve communes. \
	The long recovery period of Earth has resulted in much of the population being environmentally aware and heavily conservationist, eager to avoid past mistakes. Most Earthers are \
	a content folk who see themselves as close to nature and keepers of the heritage of humanity."
	economic_power = 1.1
	language = LANGUAGE_SOL_COMMON

/decl/cultural_info/culture/human/other
	name = CULTURE_HUMAN_OTHER
	description = "Some people are from places no one has ever heard of or places too wild and fantastical to make it into Encyclopedia Galactica. You are one of these. "
	economic_power = 1

	other_tag = "custculture"
