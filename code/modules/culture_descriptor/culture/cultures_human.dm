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

	lazysetup_species = list(SPECIES_ALL, SPECIES_HUMAN)

/*
/decl/cultural_info/culture/human/earthling
	name = CULTURE_HUMAN_EARTH
	description = "You are from Earth, home of humanity. Earth culture is much as it has been for centuries, with the old nation states, while no longer politically important, still \
	culturally significant to many humans across the galaxy, as all trace their roots to somewhere on the planet. While not as geographically diverse as they were in the past, most \
	countries have at least two arcologies which make up much of the population, with the remaining humans living in small villages or from one of the many nature preserve communes. \
	The long recovery period of Earth has resulted in much of the population being environmentally aware and heavily conservationist, eager to avoid past mistakes. Most Earthers are \
	a content folk who see themselves as close to nature and keepers of the heritage of humanity."
	economic_power = 1.1
	language = LANGUAGE_SOL_COMMON
*/

/decl/cultural_info/culture/human/other
	name = CULTURE_HUMAN_OTHER
	description = "Some people are from places no one has ever heard of or places too wild and fantastical to make it into Encyclopedia Galactica. You are one of these. "
	economic_power = 1

	other_tag = "custculture"

/decl/cultural_info/culture/human/rimworlder
	name = CULTURE_HUMAN_RIM
	description = "You identify with a small, local culture on the frontier of human colonization, outside of any major interstellar cultural spheres. Life on the frontier is usually cold,\
	hard, and lonely, with the only sporadic contact with the rest of civilization coming from occasional visits from tax collectors and Free Traders and perhaps a low-quality Exonet connection.\
	Successful frontier colonies band together tightly, sometimes becoming almost insular, while failed colonies dissolve as, bit by bit, colonists trickle back to the core worlds."
	economic_power = 0.7 // ??? i dont know what im doing with these econ power numbers tbh

/decl/cultural_info/culture/human/coreworlder
	name = CULTURE_HUMAN_CORE
	description = "You come from a small settlement within the human Core Worlds. The Core Worlds are densely populated and heavily developed, most relying on imports from other Solar member states \
	to fuel their economy. The culture of the Core heavily influences the rest of Solar society by way of media, painting the Core as glamorous, cosmopolitan... and largely biological human."
	economic_power = 1.2

/decl/cultural_info/culture/human/almachi
	name = CULTURE_HUMAN_ALMACHI
	description = "The culture of the Almach Rim is heavily technophilic, individualistic, and in many ways anti-establishment. Owing to the Rim's isolation and opposition to mainstream culture, \
	it recently seceded from Sol, sparking a four-year war and leading to its annexation by the Skrell. Almachi expatriates are viewed with mistrust by most of Sol and are often targetted for harassment \
	by law enforcement."
	economic_power = 0.9

/decl/cultural_info/culture/human/crescenti
	name = CULTURE_HUMAN_CRESCENT
	description = "The Golden Crescent is a cultural region containing Vir and many of its neighbors. Crescenti people are rugged and self-reliant, and the region has an eclectic and cosmopolitan culture \
	from centuries of welcoming alien and positronic migrants and refugees."
	economic_power = 1.0

/decl/cultural_info/culture/human/bowler
	name = CULTURE_HUMAN_BOWL
	description = "The Bowl is the poorest and least developed region of Solar space, plagued by organized crime and resource scarcity, and this is reflected in the culture of the people who call the region \
	home. Bowlers tend to be distrustful of outsiders and value keeping their noses down and themselves out of trouble. People from other regions often associate 'Bowler' with either 'hick' or 'crimina', and \
	prejudge Bowlers accordingly."
	economic_power = 0.8

/decl/cultural_info/culture/human/crypter
	name = CULTURE_HUMAN_CRYPT
	description = "Crypters come from the stations of the Precursor's Crypt, the region of Solar space where positronics were first discovered. The culture that grew in this region is technophilic, neophilic, \
	tightly interconnected, and constantly racing to outdo itself. Crypt systems are usually sparsely inhabited, but most of their population is well-off, with intellectual services the backbone of the Crypt's \
	economy. Crypter culture is also influenced by the officers and servicepeople of the region's heavy Fleet presence, and by the legacy of the Hegemony invasion during the First Contact War."
	economic_power = 1.1

/decl/cultural_info/culture/human/sagittarian
	name = CULTURE_HUMAN_SAGIT
	description = "Most known garden worlds in human space are found in the wealthy, idyllic Sagittarian Heights, which also benefits from extensive trade with Skrellian business interests. Sagittarians are often \
	stereotyped as arrogant or snobbish, though in truth the average Sagitarrian is a miner or farmer whose living conditions differ little from those elsewhere in Solar space."
	economic_power = 1

/decl/cultural_info/culture/human/secessionist
	name = CULTURE_HUMAN_SECEED
	description = "You come from a small system on the fringes of Sol space that is formally independent from SolGov's influence. Such seccessionists are often very poor and horribly isolated, leading many born in \
	these systems to attempt to re-join Solar society, where they face discrimination and mistrust."
	economic_power = 0.7

/decl/cultural_info/culture/human/freetrader
	name = CULTURE_HUMAN_FREETRADE
	description = "You belong to the Free Traders, nomadic traders that service the fringe of colonized space in aging freighters often passed down family lines for upwards of a century. Free Traders see themselves \
	as members of no true stationary culture even if they're first-generation hires. The decline in Sol's rate of colonization has lead to hard times for Free Traders, some of which have been forced to sell or scrap \
	ancestral ships and make their way into sedentary society."
	economic_power = 0.7

/decl/cultural_info/culture/human/terran
	name = CULTURE_HUMAN_TERRAN
	description = "The cradle of humanity, Earth has undergone something of a revitalization since the bulk of industry and resource extraction was relocated to the wider galaxy. While large portions of the surface are \
	now covered by vast metropolises, efforts have been made to preserve and restore the planet's natural and historical beauty, with vast nature preserves, parks and forestry plantations maintained across the world.\
	Though all existing under the Solar Confederate Government, Earth remains divided between hundreds of 'old-world' nations, many of which have fragmented further since the formation of the SCG. As such, Earth remains \
	as culturally diverse as it ever has been. However, due to the percieved prestige of the homeworld, the population skews towards the wealthy and sentimental, with provisions for affordable housing and services in many \
	of Earth's wealthiest nations quite lacking, and many 'lower class' service workers expected to commute from those who do provide, or habitats elsewhere in the system."
	economic_power = 1.2
	subversive_potential = 0.8

/decl/cultural_info/culture/human/martian
	name = CULTURE_HUMAN_MARS
	description = "The most heavily populated world in Sol space, Mars is the industrial center of Sol, home to billions in great domed cities and billions more in various tin-can towns and underground warrens. \
	The stereotypical Martian is staid, laid-back, and a hard worker. Mars, like Earth, is fragmented into nation-states: some corresponding to some Earthly colonial venture but many others reflecting ethnocultures \
	formed over four centuries of life on the red planet."
	economic_power = 1.0
	subversive_potential = 1 //look mars is like the default

/decl/cultural_info/culture/human/venusian
	name = CULTURE_HUMAN_VENUS
	description = "Despite its hellish atmosphere, Venus is concidered the breadbasket of Sol. Aerostat habitats in the upper stratosphere keep vast bays of crops away from the misery of Venus' surface. Much of this production \
	is wholely automated; Venusian farmers are well-paid technicians keeping the whole ediface up-and-running, and much of the rest of the world's population caters to their needs."
	economic_power = 1.1
	subversive_potential = 0.8

/decl/cultural_info/culture/human/lunar
	name = CULTURE_HUMAN_LUNAR
	description = "Someone should finish this."

/decl/cultural_info/culture/human/titanian
	name = CULTURE_HUMAN_TITAN
	description = "Someone should finish this."

/decl/cultural_info/culture/human/sivian
	name = CULTURE_HUMAN_SIF
	description = "Someone should finish this."

/decl/cultural_info/culture/human/karan
	name = CULTURE_HUMAN_KARAN
	description = "Someone should finish this."

/decl/cultural_info/culture/human/heavener
	name = CULTURE_HUMAN_HEAVEN
	description = "Someone should finish this."

/decl/cultural_info/culture/human/binmasian
	name = CULTURE_HUMAN_BINMA
	description = "Someone should finish this."

/decl/cultural_info/culture/human/nispean
	name = CULTURE_HUMAN_NISP
	description = "You hail from Nisp, a garden world known for its vast scarlet jungles and ferocious wildlife. Boasting a significant tourism industry with the lush foliage and idyllic year-round summer, the eco-conservatism \
	movement has held strong since Nisp's first colonies were established amid the climate crises of Earth. With the warmer, more humid climate, Nisp is also home to one of the largest core system Skrellian populations, and was \
	an early adopted of the Tradeband language, which remains the primary language in most settlements to date. In order to defend this tropical paradise from hungry wildlife, some of which can be larger than an automobile and pose \
	an actual danger to buildings, Nisp boasts a particularly large ground-based army, and a number of PMCs and arms manufacturers have facilities on the surface. Pharmaceutical corporations have a long history of studying Nisp's \
	unique biosphere looking for drugs and reagents. The planet is governed primarily by individual city-states, with smaller settlements adhering to the laws of their larger neighbors, but each city with a population of at least 5 \
	million is given a seat on a parlaimentary council that handles global concerns and international diplomacy."
	economic_power = 1.0

/decl/cultural_info/culture/human/sophian
	name = CULTURE_HUMAN_SOPHIA
	description = "Someone should finish this."

/decl/cultural_info/culture/human/terminian
	name = CULTURE_HUMAN_TERMINUS
	description = "Someone should finish this."

/decl/cultural_info/culture/human/kyotojin
	name = CULTURE_HUMAN_KYOTO
	description = "Modelled closely on an idealized version of Edo period Japan, the independent human colony of New Kyoto is fiercly traditionalist and openly hostile to outside influence. A highly regimented society with outside trade \
	heavily restricted, and the influence of trans-stellar corporations and their products kept to a minimum, New Kyoto instills in its populace a strong sense of national loyalty, self-sufficiency and of course, militarism."
	economic_power = 0.9
	subversive_potential = 1.1

/decl/cultural_info/culture/human/eutopian
	name = CULTURE_HUMAN_EUTOPIA
	description = "Created as an 'objectivist paradise', Eutopia typifies the cut-throat ideology of anarcho-capitalism. Less than 10 percent of the population own all property in the system, with the remainder rent-paying tenants, or \
	indentured servants - though the latter rarely have the opportunity to leave. Most of Eutopia's economy exists to serve the unregulated banking and entertainment needs of Trans-stellar Corporation and Skrell moguls from across the \
	galaxy. To be Eutopian is to become ultra-rich, or die trying."
	economic_power = 1.1
	subversive_potential = 1.2

/decl/cultural_info/culture/human/casini
	name = CULTURE_HUMAN_CASINI
	description = "The communes of Casini's Reach vary in size and prosperity, united only by a defensive pact and a shared sense of mutual aid. Most consist of small, tight-knit communities focused around the extraction or production of \
	a particular resource, supplied to other colonies in exchange for their own necessities. Though minerals are abundant, life is tough and there is always work to be done, most Casini know they can always rely on their neighbors in times of need."
	economic_power = 0.7
	subversive_potential = 1.1

/decl/cultural_info/culture/human/taron
	name = CULTURE_HUMAN_TARON
	description = "Despite being a settled planet, living on Taron feels more like living on an uninhabitable moon. The planet lacks oxygen in its atmosphere, so human settlement is in domes and other constructions. The loss of the rest of the Relan \
	system in a hard-fought war and the following economic collapse led to habitats shutting down and political chaos followed by a decade of dictatorship. During this time, many left the planet, going mostly to Solar space. Since the end of this \
	period in the mid-40s, Taron has seen a slow recovery and growth, and managed to stay neutral during the Almach-Sol conflict and subsequent Skrell occupation and vacating of the rest of the Relan system. Taron has seen tough times, but it is far from broken."
	economic_power = 0.7
	subversive_potential = 1.1

/decl/cultural_info/culture/human/taron_diaspora
	name = CULTURE_HUMAN_TAROND
	description = "A large number of people left Taron during its darkest years. Many settled in the rest of the Relan system, but a large number came to the Solar Confederate Government as well, settling mostly in the Golden Crescent, including Vir. The original \
	émigrés are aging now, and their children, raised in Solar space, are often young adults. Taron communities are not uncommon in many major cities in the Crescent, and Little Taron in New Reykjavik is a vibrant community today."
	economic_power = 0.9 //they're not THAT much worse off than most people in Vir
	subversive_potential = 1.1 //people in the future are still shitty about immigration

/decl/cultural_info/culture/human/relani
	name = CULTURE_HUMAN_RELAN
	description = "The Second Free Relan Federation consists of the entire Relan system except for the planet of Taron and its orbit. Since the end of the control of Artemis Mineral Extraction over the system, Relan has been fairly stable, if economically uninspiring. \
	Despite a recent war with Sol and a brief Skrellian occupation, Relan has maintained its independence, at least offically. The system consists of a number of large 'hub' stations and spaceport-cities that house workers and a large number of smaller mining stations. \
	Recent developments have seen more non-mining industry develop, but the system is still largely dependent on the two mineral-rich asteroid belts.  It is a nation of spacers, and from a young age people in Relan are taught the value of the station and its artificial \
	environment, and almost everyone knows how to handle EVA and basic maintenance as naturally as someone from a sparsely-populated planet would know how to drive. The Relani engineer more protective of their station or ship than the life forms aboard it is a common, if \
	inaccurate, stereotype."
	economic_power = 0.8
	subversive_potential = 1.3 //Recent war and now who knows how much influence the Far Kingdoms Skrell really have

/decl/cultural_info/culture/human/shelfican
	name = CULTURE_HUMAN_SHELF
	description = "Built on shared hardship, the culture of the Shelf flotilla is sarcastic, darkly humorous, and absolutely dripping in irony. Considered inscrutable or outright crude to some, Shelf as a whole nonetheless maintains polite diplomatic and legal relations \
	with its neighbors - most of the time. Almost wholly positronic, with only a fraction of the flotilla's ships supporting unassisted organic life, Shelf has become something of a 'home' to the positronic self-determination movement, which is often expressed through Shelficans' \
	unconventional naming schemes."
	economic_power = 0.8
	subversive_potential = 1.1

/decl/cultural_info/culture/human/angessian
	name = CULTURE_HUMAN_ANGESSA
	description = "Someone should finish this."

/decl/cultural_info/culture/human/natunan
	name = CULTURE_HUMAN_NATUNA
	description = "Until very recently, Natuna Bhumi Barisal existed as a collection of autonomous colonies on the border of Human and Skrell space, notable for being the first system to accept the two species living alongside one another. Heavily embargoed by all major governments, \
	the system became notorious as a haven for society's dregs from both sides of the border - casteless skrell, refugees, deserters, and gangsters alike. The system was known as something of a hub for pirates in the region, until early 2563 when it was 'occupied' by Moghes Hegemony \
	security forces, placing the system under strict rule and displacing a great many of its residents."
	economic_power = 0.5 //its LOW babey
	subversive_potential = 1.4 //Hive of scum and villainy. Or, was.
