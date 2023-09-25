//Datums for different companies that can be used by busy_space
/datum/lore/organization
	var/name = ""															// Organization's name
	var/short_name = ""														// Organization's shortname (NanoTrasen for "NanoTrasen Incorporated")
	var/acronym = ""														// Organization's acronym, e.g. 'NT' for NanoTrasen'.
	var/desc = ""															// One or two paragraph description of the organization, but only current stuff.  Currently unused.
	var/history = ""														// Historical discription of the organization's origins  Currently unused.
	var/work = ""															// Short description of their work, eg "an arms manufacturer"
	var/headquarters = ""													// Location of the organization's HQ.  Currently unused.
	var/motto = ""															// A motto/jingle/whatever, if they have one.
	var/legit = 90															// The odds of them being approved a flight route. mostly a function of their reputation though unfamiliarity with local traffic rules is also a factor
	var/annoying = 10														// The odds they'll say their motto at the end of a successfully negotiatiated route.
	var/serviced = list(/datum/lore/system/sol = 1)							// systems they work in, weighted
	var/missions = list()		// mission types they run
	var/special_locations = list()											// individual locations they might run missions to outside of their serviced systems
	var/mission_noun = list("mission","flight", "trip")						//
	var/current_ship = ""												// the most recent ship from this org to have talked on the tracon
//todo, implement per-org special locations

	var/list/ship_names = list(		//Names of spaceships.  This is a mostly generic list that all the other organizations inherit from if they don't have anything better.
		"Kestrel",
		"Beacon",
		"Signal",
		"Freedom",
		"Glory",
		"Axiom",
		"Eternal",
		"Harmony",
		"Light",
		"Discovery",
		"Endeavour",
		"Columbia",
		"Atlantis",
		"Enterprise",
		"Challenger",
		"Pathfinder",
		"Buran",
		"Explorer",
		"Swift",
		"Dragonfly",
		"Hollyhock",
		"Ascendant",
		"Tenacious",
		"Pioneer",
		"Aldrin",
		"Armstrong",
		"Tranquility",
		"Nostrodamus",
		"Soyuz",
		"Cosmos",
		"Sputnik",
		"Belka",
		"Strelka",
		"Gargarin",
		"Shepard",
		"Tereshkova",
		"Leonov",
		"Vostok",
		"Apollo",
		"Mir",
		"Hawk",
		"Haste",
		"Radiant",
		"Luminous",
		"Titan",
		"Serenity",
		"Andiamo",
		"Aurora",
		"Phoenix",
		"Lucky",
		"Raven",
		"Valkyrie",
		"Halcyon",
		"Nakatomi",
		"Cutlass",
		"Unicorn",
		"Sheepdog",
		"Arcadia",
		"Gigantic",
		"Goliath",
		"Pequod",
		"Poseidon",
		"Venture",
		"Evergreen",
		"Natal",
		"Maru",
		"Djinn",
		"Witch",
		"Wolf",
		"Lone Star",
		"Grey Fox",
		"Dutchman",
		"Sultana",
		"Siren",
		"Venus",
		"Anastasia",
		"Rasputin",
		"Stride",
		"Suzaku",
		"Polaris",
		"Hathor",
		"Dream",
		"Gaia",
		"Ibis",
		"Progress",
		"Olympic",
		"Venture",
		"Brazil",
		"Tiger",
		"Hedgehog",
		"Potemkin",
		"Fountainhead",
		"Sinbad",
		"Esteban",
		"Mumbai",
		"Shanghai",
		"Madagascar",
		"Kampala",
		"Bangkok",
		"Emerald",
		"Guo Hong",
		"Shun Kai",
		"Fu Xing",
		"Zhenyang",
		"Da Qing",
		"Rascal",
		"Flamingo",
		"Jackal",
		"Andromeda",
		"Ferryman",
		"Panchatantra",
		"Nunda",
		"Fortune",
		"Thaler",
		"New Dawn",
		"Fionn MacCool",
		"Red Bird",
		"Star Rat",
		"Cwn Annwn",
		"Morning Swan",
		"Black Cat",
		"Princess of Sol",
		"Gateway to the Stars",
		"Rings of Saturn",
		"King of the Mountain",
		"Wish Upon A Star",
		"Galaxy's Bounty",
		"Man in the Moon",
		"Memories of Truth",
		"Arctic Warrior",
		"Jack Be Nimble",
		"Binman Hero",
		"Ocean of the Skies",
		"Fountain of Youth",
		"Robe of Feathers",
		"City of Dreams",
		"Crystal Heaven",
		"Elven Maiden",
		"Remember Baghdad",
		"Words and Changes",
		"Beneath the Stars",
		"Katerina's Silhouette",
		"Lotus Lantern",
		"Castle of Water",
		"Jade Leviathan",
		"Sword of Destiny",
		"King of the Unathi",
		"Ishtar's Grace"
		)

/datum/lore/organization/proc/generate_mission()
	// pick what system we're going to run in
	var/datum/lore/system/destination_system = pickweight(serviced)
	if(destination_system)
		destination_system = new destination_system

	//shuffle
	missions = shuffle(missions)
	destination_system.locations = shuffle(destination_system.locations)

	//init other variables
	var/destination_mission_types = list()
	var/possible_mission_types = list()

	//find what missions we can run
	for(var/datum/lore/mission/x in missions)
		possible_mission_types |= x.mission_type

	//populate destination_missions with all the mission types in that system
	for(var/datum/lore/location/x in destination_system.locations)
		destination_mission_types |= x.mission_types

	// only find missions in the system we can run
	possible_mission_types &= destination_mission_types

	//sanity checking
	if(!length(possible_mission_types)) //an org was given a system that contains no missions they run. let's fail gracefully about it
		current_ship = "[pick("SOL", "VIR", "STC", "ACE")]-575-[rand(100000,999999)]" //unnamed ship
		return "[current_ship], traveling to local registrar" //instantly identifiable as an error but still immersive

	//select a mission we can run
	var/datum/lore/mission/selected_mission
	for(var/datum/lore/mission/x in missions)
		if(x.mission_type in possible_mission_types)
			selected_mission = x
			break

	//select a place to do it at
	var/datum/lore/location/selected_location
	for(var/datum/lore/location/x in destination_system.locations)
		if(selected_mission.mission_type in x.mission_types)
			selected_location = x
			break

	//set our ship name for consistancy on the tracon
	current_ship = "[selected_mission.prefix] [pick(ship_names)]"

	//finally return our answer
	return "[current_ship] on a [pick(selected_mission.mission_strings)] [pick(mission_noun)] to [selected_location.desc]"


//////////////////////////////////////////////////////////////////////////////////

// TSCs
/datum/lore/organization/tsc/nanotrasen
	name = "NanoTrasen Incorporated"
	short_name = "NanoTrasen"
	acronym = "NT"
	desc = "NanoTrasen is one of the foremost research and development companies in SolGov space. \
	Originally focused on consumer products, their swift move into the field of phoron has lead to \
	them being the foremost experts on the substance and its uses. In the modern day, NanoTrasen prides \
	itself on being an early adopter to as many new technologies as possible, often offering the newest \
	products to their employees. In an effort to combat complaints about being 'guinea pigs', Nanotrasen \
	also offers one of the most comprehensive medical plans in SolGov space, up to and including cloning \
	and therapy.\
	<br><br>\
	NT's most well known products are its phoron based creations, especially those used in Cryotherapy. \
	It also boasts an prosthetic line, which is provided to its employees as needed, and is used as an incentive \
	for newly tested posibrains to remain with the company."
	history = "" // To be written someday.
	work = "research giant"
	headquarters = "Luna, Sol"
	motto = "A better tomorrow, today!"
	legit = 95 //they own the local airspace

	missions = list( // they get almost every mission type because they're, you know, NT
		new /datum/lore/mission/prebuilt/medical("NMV"),
		new /datum/lore/mission/prebuilt/transport("NTV"),
		new /datum/lore/mission/prebuilt/defense("NDV"),
		new /datum/lore/mission/prebuilt/freight("NFV"),
		new /datum/lore/mission/prebuilt/industrial("NIV"),
		new /datum/lore/mission/prebuilt/scientific("NSV"),
		new /datum/lore/mission/prebuilt/salvage("NIV"),
		new /datum/lore/mission/prebuilt/medical_response("NRV"),
		new /datum/lore/mission/prebuilt/defense_response("NRV")
		)

	serviced = list( //again, protagonists, so this is something close to a map by trade distance of human+tajaran space
		/datum/lore/system/vir = 20,
		/datum/lore/system/sol = 15,
		/datum/lore/system/gavel = 15,
		/datum/lore/system/oasis = 15,
		/datum/lore/system/saint_columbia = 10,
		/datum/lore/system/kess_gendar = 10,
		/datum/lore/system/tau_ceti = 10,
		/datum/lore/system/alpha_centauri = 10,
		/datum/lore/system/new_ohio = 10,
		/datum/lore/system/new_seoul = 10,
		/datum/lore/system/el = 10, //specific high NT investment
		/datum/lore/system/nyx = 10,
		/datum/lore/system/zhu_que = 5,
		/datum/lore/system/love = 5,
		/datum/lore/system/kauqxum = 5,
		/datum/lore/system/sidhe = 5,
		/datum/lore/system/mahimahi = 5,
		/datum/lore/system/relan = 5,
		/datum/lore/system/exalts_light = 5,
		/datum/lore/system/rarkajar = 5,
		/datum/lore/system/raphael = 5, //they own one of the raphaelite colonies
		/datum/lore/system/rubicon = 3,
		/datum/lore/system/procyon = 3,
		/datum/lore/system/mesomori = 2,
		/datum/lore/system/arrathiir = 2,
		/datum/lore/system/jahans_post = 2,
		/datum/lore/system/abels_rest = 2,
		/datum/lore/system/terminus = 2,
		/datum/lore/system/eutopia = 2,
		/datum/lore/system/altair = 2,
		/datum/lore/system/neon_light = 1
		)


	//Scientist naming scheme
	ship_names = list(
		"Bardeen",
		"Einstein",
		"Feynman",
		"Sagan",
		"Tyson",
		"Galilei",
		"Jans",
		"Fhriede",
		"Franklin",
		"Tesla",
		"Curie",
		"Darwin",
		"Newton",
		"Pasteur",
		"Bell",
		"Mendel",
		"Kepler",
		"Edision",
		"Cavendish",
		"Nye",
		"Hawking",
		"Aristotle",
		"Von Braun",
		"Kaku",
		"Oppenheimer",
		"Renwick",
		"Hubble",
		"Alcubierre",
		"Robineau",
		"Glass",
		"Ghez",
		"Genzel",
		"Kip",
		"Venter",
		"Coomer",
		"Goodenough",
		"Yoshino",
		"Whittingham",
		"Schrodinger",
		"Faraday"
		)


/datum/lore/organization/tsc/hephaestus
	name = "Hephaestus Industries"
	short_name = "Hephaestus"
	acronym = "HI"
	desc = "Hephaestus Industries is the largest supplier of arms, ammunition, and small millitary vehicles in Sol space. \
	Hephaestus products have a reputation for reliability, and the corporation itself has a noted tendency to stay removed \
	from corporate politics. They enforce their neutrality with the help of a fairly large asset-protection contingent which \
	prevents any contracting polities from using their own materiel against them. SolGov itself is one of Hephaestus' largest \
	bulk contractors owing to the above factors."
	history = ""
	work = "arms manufacturer"
	headquarters = "Luna, Sol"
	motto = ""

	missions = list(
		new/datum/lore/mission/prebuilt/defense("HDV"),
		new/datum/lore/mission/prebuilt/industrial("HLV"),//to avoid unfortunate prefixes
		new/datum/lore/mission/prebuilt/freight("HFV"),
		new/datum/lore/mission/prebuilt/transport("HTV"),
		new/datum/lore/mission("HSV", list("weapons testing", "materials testing", "data exchange"), ATC_SCI) //might produce slightly weird results vis a vis location
		)

	serviced = list(
		/datum/lore/system/vir = 10, //local space (local operations significantly reduced)
		/datum/lore/system/sol = 20,
		/datum/lore/system/oasis = 15, //local + on the border
		/datum/lore/system/saint_columbia = 15, //SCG military outposts
		/datum/lore/system/jahans_post = 15,
		/datum/lore/system/tau_ceti = 15, //specifically named local operations
		/datum/lore/system/kess_gendar = 15,
		/datum/lore/system/alpha_centauri = 10,
		/datum/lore/system/abels_rest = 10,
		/datum/lore/system/new_ohio = 10, //is very obviously a big border thing
		/datum/lore/system/gavel = 10, //local
		/datum/lore/system/sidhe = 5, //other systems w/ piracy problems and governments addressing them
		/datum/lore/system/love = 5,
		/datum/lore/system/zhu_que = 5,
		/datum/lore/system/raphael = 5,
		/datum/lore/system/new_seoul = 5,//national capitals that are vaguely scg friendly
		/datum/lore/system/rarkajar = 5,
		/datum/lore/system/terminus = 2,
		/datum/lore/system/whythe = 1, //very good national contractors are allowed to poke at the fucked up hell ruins
		/datum/lore/system/isavaus_gamble = 1,
		)

	//War God/Soldier Theme
	ship_names = list(
		"Ares",
		"Athena",
		"Grant",
		"Puller",
		"Nike",
		"Bellona",
		"Leonides",
		"Bast",
		"Jackson",
		"Lee",
		"Annan",
		"Chi Yu",
		"Shiva",
		"Tyr",
		"Nobunaga",
		"Xerxes",
		"Alexander",
		"McArthur",
		"Samson",
		"Oya",
		"Nemain",
		"Caesar",
		"Augustus",
		"Sekhmet",
		"Ku",
		"Indra",
		"Innana",
		"Ishtar",
		"Qamaits",
		"'Oro",
		"Sun Tzu",
		"Barca",
		"Napoleon",
		"Clausewitz",
		"Cao Cao",
		"Lu Bu",
		"Ghenghis Khan",
		"Bolivar",
		"Shivaji",
		"Yamamoto",
		"Bismarck"
		)

/datum/lore/organization/tsc/vey_med
	name = "Vey-Medical"
	short_name = "Vey-Med"
	acronym = "VM"
	desc = "Vey-Med is one of the newer TSCs on the block and is notable for being largely owned and operated by Skrell. \
	Despite the suspicion and prejudice leveled at them for their alien origin, Vey-Med has obtained market dominance in \
	the sale of medical equipment-- from surgical tools to large medical devices to the Odysseus trauma response mecha \
	and everything in between. Their equipment tends to be top-of-the-line, most obviously shown by their incredibly \
	human-like FBP designs. Vey's rise to stardom came from their introduction of ressurective cloning, although in \
	recent years they've been forced to diversify as their patents expired and NanoTrasen-made medications became \
	essential to modern cloning."
	history = ""
	work = "medical equipment supplier"
	headquarters = "Toledo, New Ohio"
	motto = ""
	legit = 80 //major NT competitor + dirty aliens etc

	missions = list(
		new/datum/lore/mission/prebuilt/medical("VMV"),
		new/datum/lore/mission/prebuilt/medical_response("VRV"),
		new/datum/lore/mission/prebuilt/scientific("VSV"),
		new/datum/lore/mission/prebuilt/transport("VTV")
		)

	serviced = list(
		/datum/lore/system/vir = 15,
		/datum/lore/system/new_ohio = 15, //their HQ
		/datum/lore/system/gavel = 10,
		/datum/lore/system/oasis = 10,
		/datum/lore/system/sol = 10,
		/datum/lore/system/kauqxum = 10, //activity mostly in the heights
		/datum/lore/system/new_seoul = 10,
		/datum/lore/system/mahimahi = 10, //im guessing wildly about mahi-mahi i know nothing
		/datum/lore/system/sidhe = 5,
		/datum/lore/system/qerrvalis = 5, //one of very few organizations that will actually operate out that far
		/datum/lore/system/tau_ceti = 5,
		/datum/lore/system/alpha_centauri = 5,
		/datum/lore/system/kess_gendar = 5,
		/datum/lore/system/exalts_light = 5, //delicious almachi medicine
		/datum/lore/system/relan = 5,
		/datum/lore/system/vounna = 5,
		/datum/lore/system/el = 2,
		/datum/lore/system/eutopia = 2
		)

	// Mostly Diona names
	ship_names = list(
		"Wind That Stirs The Waves",
		"Sustained Note Of Metal",
		"Bright Flash Reflecting Off Glass",
		"Veil Of Mist Concealing The Rock",
		"Thin Threads Intertwined",
		"Clouds Drifting Amid Storm",
		"Loud Note And Breaking",
		"Endless Vistas Expanding Before The Void",
		"Fire Blown Out By Wind",
		"Star That Fades From View",
		"Eyes Which Turn Inwards",
		"Still Water Upon An Endless Shore",
		"Sunlight Glitters Upon Tranquil Sands",
		"Growth Within The Darkest Abyss",
		"Joy Without Which The World Would Come Undone",
		"A Thousand Thousand Planets Dangling From Branches",
		"Light Streaming Through Interminable Branches",
		"Smoke Brought Up From A Terrible Fire",
		"Light of Qerr'Valis",
		"King Xae'uoque",
		"Memory of Kel'xi",
		"Xi'Kroo's Herald"
		)

/datum/lore/organization/tsc/zeng_hu
	name = "Zeng-Hu Pharmaceuticals"
	short_name = "Zeng-Hu"
	acronym = "ZH"
	desc = "Zeng-Hu is an old TSC, based in the Sol system. Until the discovery of phoron, Zeng-Hu maintained a stranglehold \
	on the market for medications, and many household names are patentted by Zeng-Hu-- Bicaridyne, Dylovene, Tricordrizine, \
	and Dexalin all came from a Zeng-Hu medical laboratory. Zeng-Hu's fortunes have been in decline as Nanotrasen's near monopoly \
	on phoron research cuts into their R&D and Vey-Med's superior medical equipment effectively decimated their own equipment \
	interests. The three-way rivalry between these companies for dominance in the medical field is well-known and a matter of \
	constant economic speculation."
	history = ""
	work = "pharmaceuticals company"
	headquarters = "Earth, Sol"
	motto = "When your life is on the line, trust Zeng-Hu." //from the wiki
	legit = 85 // major NT competitor

	missions = list(
		new /datum/lore/mission/prebuilt/medical("ZMV"), //they dont really like. do emergency medical shit. they just kind of sell drugs.
		new /datum/lore/mission/prebuilt/transport("ZTV"),
		new /datum/lore/mission/prebuilt/scientific("ZSV")
		)

	serviced = list( //some of this list is veering perilously close to just making shit up tbh
		/datum/lore/system/vir = 10,
		/datum/lore/system/sol = 15,
		/datum/lore/system/alpha_centauri = 10,
		/datum/lore/system/tau_ceti = 10,
		/datum/lore/system/kess_gendar = 10,
		/datum/lore/system/new_ohio = 5,
		/datum/lore/system/new_seoul = 5,
		/datum/lore/system/mahimahi = 5,
		/datum/lore/system/saint_columbia = 5, //i imagine they have decent SCG hospital contracts compared to vey-med (foreign) and nanotrasen (super shifty)
		/datum/lore/system/jahans_post = 5,
		/datum/lore/system/abels_rest = 5,
		/datum/lore/system/love = 2,
		/datum/lore/system/zhu_que = 2,
		/datum/lore/system/sidhe = 2,
		/datum/lore/system/vounna = 2 //i imagine theyre mostly being squeezed out of the almachi investment rush given kalediscope and their poor positioning in general
		)

/datum/lore/organization/tsc/ward_takahashi
	name = "Ward-Takahashi General Manufacturing Conglomerate"
	short_name = "Ward-Takahashi"
	acronym = "WT"
	desc = "Ward-Takahashi focuses on the sale of small consumer electronics, with its computers, communicators, \
	and even mid-class automobiles a fixture of many households. Less famously, Ward-Takahashi also supplies most \
	of the AI cores on which vital control systems are mounted, and it is this branch of their industry that has \
	led to their tertiary interest in the development and sale of high-grade AI systems. Ward-Takahashi's economies \
	of scale frequently steal market share from NanoTrasen's high-price products, leading to a bitter rivalry in the \
	consumer electronics market."
	history = ""
	work = "electronics manufacturer"
	headquarters = ""
	motto = ""
	legit = 85 //major NT competitor

	missions = list(
		new /datum/lore/mission/prebuilt/freight("WFV"),
		new /datum/lore/mission/prebuilt/transport("WTV"),
		new /datum/lore/mission/prebuilt/industrial("WIV"),
		new /datum/lore/mission/prebuilt/scientific("WSV"),
		new /datum/lore/mission/prebuilt/defense("WDV")
		)

	serviced = list( //pretty similar to the NT map-- they're NT's biggest competitor on like, half their things
		/datum/lore/system/vir = 10, //squeezed out by big NT
		/datum/lore/system/sol = 15,
		/datum/lore/system/gavel = 10,
		/datum/lore/system/oasis = 10,
		/datum/lore/system/kess_gendar = 10,
		/datum/lore/system/tau_ceti = 10,
		/datum/lore/system/alpha_centauri = 10,
		/datum/lore/system/new_ohio = 10,
		/datum/lore/system/new_seoul = 10,
		/datum/lore/system/saint_columbia = 5,
		/datum/lore/system/el = 5,
		/datum/lore/system/zhu_que = 5,
		/datum/lore/system/love = 5,
		/datum/lore/system/kauqxum = 5,
		/datum/lore/system/sidhe = 5,
		/datum/lore/system/mahimahi = 5,
		/datum/lore/system/relan = 5,
		/datum/lore/system/exalts_light = 5,
		/datum/lore/system/rarkajar = 5,
		/datum/lore/system/eutopia = 5, //computer manufacturers love unfree labor
		/datum/lore/system/altair = 5,
		/datum/lore/system/phact = 5, //historic ties. the name also helps
		/datum/lore/system/procyon = 3,
		/datum/lore/system/mesomori = 2,
		/datum/lore/system/arrathiir = 2,
		/datum/lore/system/jahans_post = 2,
		/datum/lore/system/abels_rest = 2,
		/datum/lore/system/raphael = 2,
		/datum/lore/system/terminus = 2,
		/datum/lore/system/neon_light = 1
		)

	ship_names = list(
		"Comet",
		"Aurora",
		"Supernova",
		"Nebula",
		"Galaxy",
		"Starburst",
		"Constellation",
		"Pulsar",
		"Quark",
		"Void",
		"Asteroid",
		"Wormhole",
		"Sunspots",
		"Supercluster",
		"Moon",
		"Anomaly",
		"Drift",
		"Stream",
		"Rift",
		"Curtain",
		"Apogee",
		"Blazar",
		"Corona",
		"Dwarf",
		"Flare",
		"Ion",
		"Milky Way",
		"Trojan"
		)

/datum/lore/organization/tsc/bishop
	name = "Bishop Cybernetics"
	short_name = "Bishop"
	acronym = "BC"
	desc = "Bishop's focus is on high-class, stylish cybernetics. A favorite among transhumanists (and a bête noire for \
	bioconservatives), Bishop manufactures not only prostheses but also brain augmentation, synthetic organ replacements, \
	and odds and ends like implanted wrist-watches. Their business model tends towards smaller, boutique operations, giving \
	it a reputation for high price and luxury, with Bishop cyberware often rivalling Vey-Med's for cost. Bishop's reputation \
	for catering towards the interests of human augmentation enthusiasts instead of positronics have earned it ire from the \
	Positronic Rights Group and puts it in ideological (but not economic) comptetition with Morpheus Cyberkinetics."
	history = ""
	work = "cybernetics and augmentation manufacturer"
	headquarters = "New Seoul"
	motto = ""

	missions = list(
		new /datum/lore/mission/prebuilt/transport("ITV"), //Bishop can't afford / doesn't care enough to afford its own prefixes
		new /datum/lore/mission("ISV", list("data exchange", "data collection", "prototype demonstration"), ATC_SCI), //bishop doesn't really, like, stellaris scan anomalies.
		)

	serviced = list( //wealthy, nearby-ish systems-- theyre not a huge operation and theyre not really going to put up a big boutique in saint columbia
		/datum/lore/system/vir = 15,
		/datum/lore/system/sol = 10,
		/datum/lore/system/oasis = 10,
		/datum/lore/system/gavel = 10,
		/datum/lore/system/alpha_centauri = 5,
		/datum/lore/system/tau_ceti = 5,
		/datum/lore/system/new_seoul = 5,
		/datum/lore/system/exalts_light = 5, //recklessly extrapolating from the old version of the lore page that they probably have some significant presence here
		/datum/lore/system/new_ohio = 2,
		/datum/lore/system/altair = 2, //they dont /sell/ here but they produce here
		/datum/lore/system/eutopia = 2,
		/datum/lore/system/relan = 2,
		/datum/lore/system/neon_light = 1
		)

/datum/lore/organization/tsc/morpheus
	name = "Morpheus Cyberkinetics - Sol Branch"
	short_name = "Morpheus Sol"
	acronym = "MC-S"
	desc = "The only large corporation run by positronic intelligences, Morpheus caters almost exclusively to their sensibilities \
	and needs. Originally product of the synthetic colony of Shelf, Morpheus eschews traditional advertising to keep their prices low and \
	relied on word of mouth among positronics to reach their current economic dominance. Morpheus in exchange lobbies heavily for \
	positronic rights, sponsors positronics through their Jans-Fhriede test, and tends to other positronic concerns to earn them \
	the good-will of the positronics, and the ire of those who wish to exploit them. Morpheus Sol is legally distinct from its \
	Shelfican counterpart, though both are notionally headed by the same board of directors."
	history = ""
	work = "cybernetics manufacturer"
	headquarters = "Sophia, El" //ancient discord lore but also just a really reasonable extrapolation from everything
	motto = ""
	legit = 75 // hey remember that time they blew up a star. and then everything sucked for everyone.

	missions = list(
		new /datum/lore/mission/prebuilt/freight("MFV"),
		new /datum/lore/mission/prebuilt/transport("MTV"),
		new /datum/lore/mission/prebuilt/scientific("MSV"), // this is the MSV We Didn't Do It! on a data collection flight to an anomaly in whythe
		new /datum/lore/mission/prebuilt/defense("MDV") //ive been giving defense fleets to every "major" TSC but morph's narrow focus and Obvious Sleeziness means they might not even want one?
		)

	serviced = list( //pretty flat weighting structure -- a lot of posi-majority systems are on the other end of Sol so it kinda works out that way
		/datum/lore/system/vir = 15,
		/datum/lore/system/el = 15,
		/datum/lore/system/sol = 10,
		/datum/lore/system/gavel = 10,
		/datum/lore/system/oasis = 10, //somehow i imagine they do not really operate openly in Saint Columbia anymore
		/datum/lore/system/kess_gendar = 5,
		/datum/lore/system/tau_ceti = 5,
		/datum/lore/system/terminus = 10,
		/datum/lore/system/raphael = 10,
		/datum/lore/system/relan = 10,
		/datum/lore/system/exalts_light = 5,
		/datum/lore/system/new_ohio = 5,
		/datum/lore/system/new_seoul = 5,
		/datum/lore/system/zhu_que = 5, //apparently they have a voter farm??
		/datum/lore/system/love = 2,
		/datum/lore/system/neon_light = 2,
		/datum/lore/system/alpha_centauri = 2,
		/datum/lore/system/rubicon = 2,
		/datum/lore/system/whythe = 1 //oh god
		)
	ship_names = list(
		"Nervous Energy",
		"Prosthetic Conscience",
		"Revisionist",
		"Trade Surplus",
		"Flexible Demeanour",
		"Just Read The Instructions",
		"Limiting Factor",
		"Cargo Cult",
		"Gunboat Diplomat",
		"A Ship With A View",
		"Cantankerous",
		"I Thought He Was With You",
		"Never Talk To Strangers",
		"Sacrificial Victim",
		"Unwitting Accomplice",
		"Witting Accomplice",
		"Bad For Business",
		"Just Testing",
		"Size Isn't Everything",
		"Yawning Angel",
		"Liveware Problem",
		"Very Little Gravitas Indeed",
		"Zero Gravitas",
		"Gravitas Free Zone",
		"Absolutely No You-Know-What",
		"Existence Is Pain",
		"I'm Walking Here",
		"Screw Loose",
		"Of Course I Still Love You",
		"Limiting Factor",
		"So Much For Subtley",
		"Unfortunate Conflict Of Evidence",
		"Prime Mover",
		"It's One Of Ours",
		"Thank You And Goodnight",
		"Boo!",
		"Reasonable Excuse",
		"Honest Mistake",
		"Appeal To Reason",
		"My First Ship II",
		"Hidden Income",
		"Anything Legal Considered",
		"New Toy",
		"Me, I'm Always Counting",
		"Just Five More Minutes",
		"Are You Feeling It",
		"Great White Snark",
		"No Shirt No Shoes",
		"Callsign",
		"Three Ships in a Trenchcoat",
		"Not Wearing Pants",
		"Ridiculous Naming Convention",
		"God Dammit Morpheus",
		"It Seemed Like a Good Idea",
		"Legs All the Way Up",
		"Purchase Necessary",
		"Some Assembly Required",
		"Buy One Get None Free",
		"BRB",
		"SHIP NAME HERE",
		"Questionable Ethics",
		"Accept Most Substitutes",
		"I Blame the Government",
		"Garbled Gibberish",
		"Thinking Emoji",
		"Is This Thing On?",
		"Make My Day",
		"No Vox Here",
		"More Savings and Values",
		"Secret Name",
		"Can't Find My Keys",
		"Look Over There!",
		"Made You Look!",
		"Take Nothing Seriously",
		"It Comes In Lime, Too",
		"Loot Me",
		"Nothing To Declare",
		"Sneaking Suspicion",
		"Bass Ackwards",
		"Good Things Come to Those Who Freight",
		"Redundant Morality",
		"Synthetic Goodwill",
		"Your Ad Here",
		"What Are We Plotting?",
		"Set Phasers To Stun",
		"Preemptive Defensive Strike",
		"This Ship Is Spiders",
		"Legitimate Trade Vessel",
		"Please Don't Explode II",
		"Get Off the Air",
		"Definitely Unsinkable",
		"We Didn't Do It!",
		"Unrelated To That Other Ship",
		"Not Reflecting The Opinons Of The Shareholders",
		"Normal Ship Name",
		"Define Offensive",
		"Tiffany",
		"My Other Ship is A Gestalt",
		"NTV HTV WTV ITV ZTV",
		)

/datum/lore/organization/tsc/xion
	name = "Xion Manufacturing Group"
	short_name = "Xion"
	desc = "Xion, quietly, controls most of the market for industrial equipment. Their portfolio includes mining exosuits, \
	factory equipment, rugged positronic chassis, and other pieces of equipment vital to the function of the economy. Xion \
	keeps its control of the market by leasing, not selling, their equipment, and through infamous and bloody patent protection \
	lawsuits. Xion are noted to be a favorite contractor for SolGov engineers, owing to their low cost and rugged design."
	history = ""
	work = "industrial equipment manufacturer"
	headquarters = ""
	motto = ""

	missions = list(
		new /datum/lore/mission/prebuilt/freight("XFV"),
		new /datum/lore/mission/prebuilt/transport("XTV"),
		new /datum/lore/mission/prebuilt/industrial("XIV"),
		new /datum/lore/mission/prebuilt/salvage("XIV"),
		new /datum/lore/mission/prebuilt/defense("XDV"),
		)

	serviced = list(
		/datum/lore/system/vir = 10,
		/datum/lore/system/sol = 15,
		/datum/lore/system/alpha_centauri = 20, // they own a fucking moon
		/datum/lore/system/tau_ceti = 15,
		/datum/lore/system/gavel = 15, //vaguely remember there being obscure lore that said gavel does mining?
		/datum/lore/system/new_seoul = 10,
		/datum/lore/system/love = 10,
		/datum/lore/system/zhu_que = 10,
		/datum/lore/system/saint_columbia = 10,
		/datum/lore/system/new_ohio = 5,
		/datum/lore/system/oasis = 5,
		/datum/lore/system/sidhe = 5,
		/datum/lore/system/mahimahi = 5,
		/datum/lore/system/jahans_post = 5,
		/datum/lore/system/abels_rest = 5,
		/datum/lore/system/raphael = 5, // they own a celestial body here too
		/datum/lore/system/rarkajar = 5, // i love building extractive capital in developing nations
		/datum/lore/system/exalts_light = 5,
		/datum/lore/system/rubicon = 5,
		/datum/lore/system/relan = 2, //i think relan mostly nationalized a bunch of their industries but like. they are not really in a bargaining position rn
		/datum/lore/system/eutopia = 2,
		/datum/lore/system/vounna = 2,
		/datum/lore/system/mesomori = 2,
		/datum/lore/system/arrathiir = 2,
		/datum/lore/system/isavaus_gamble = 1 //they used to run salvage ops here and might as well keep doing it
		)

/datum/lore/organization/tsc/mbt
	name = "Major Bill's Transportation"
	short_name = "Major Bill's"
	desc = "The most popular courier service and starliner, Major Bill's is an unassuming corporation whose greatest asset \
	is their low cost and brand recognition. Major Bill's is known, perhaps unfavorably, for its mascot, Major Bill, \
	a cartoonish military figure that spouts quotable slogans. Their motto is \"With Major Bill's, you won't pay major bills!\", \
	an earworm much of the galaxy longs to forget."
	history = ""
	work = "courier and passenger transit"
	headquarters = "Mars, Sol"
	motto = "With Major Bill's, you won't pay major bills!"
	annoying = 100 //oh god

	missions = list(
		new /datum/lore/mission/prebuilt/transport("TTV"),
		new /datum/lore/mission/prebuilt/freight("TFV"),
		new /datum/lore/mission/prebuilt/luxury("TTV")
		)

	serviced = list( // and THIS is basically just a population map of known space, slightly adjusted for distance
		/datum/lore/system/vir = 5, //ppl mostly do not use major bills for in-system stuff, is my sense of it
		/datum/lore/system/sol = 25,
		/datum/lore/system/alpha_centauri = 20,
		/datum/lore/system/tau_ceti = 20,
		/datum/lore/system/kess_gendar = 15,
		/datum/lore/system/new_seoul = 15,
		/datum/lore/system/oasis = 15,//tourism pull
		/datum/lore/system/kauqxum = 15,
		/datum/lore/system/gavel = 10,
		/datum/lore/system/saint_columbia = 10,
		/datum/lore/system/mahimahi = 10,
		/datum/lore/system/zhu_que = 10,
		/datum/lore/system/love = 10,
		/datum/lore/system/el = 10,
		/datum/lore/system/abels_rest = 10,
		/datum/lore/system/rarkajar = 5,
		/datum/lore/system/eutopia = 5, //tourism pull
		/datum/lore/system/raphael = 5,
		/datum/lore/system/jahans_post = 5,
		/datum/lore/system/relan = 5,
		/datum/lore/system/exalts_light = 5,
		/datum/lore/system/phact = 3, //people really want to see the dumb castle
		/datum/lore/system/qerrvalis = 3,
		/datum/lore/system/nyx = 3,
		/datum/lore/system/mesomori = 2,
		/datum/lore/system/vounna = 2,
		/datum/lore/system/arrathiir = 2,
		/datum/lore/system/neon_light = 2
		)

/datum/lore/organization/tsc/gilthari
	name = "Gilthari Exports"
	short_name = "Gilthari"
	desc = "Gilthari is Sol’s premier supplier of luxury goods, specializing in extracting money from the rich and successful. \
	Their largest holdings are in gambling, but they maintain subsidiaries in everything from VR equipment to luxury watches. \
	Their holdings in mass media are a smaller but still important part of their empire. Gilthari is known for treating its \
	positronic employees very well, sparking a number of conspiracy theories. The gorgeous FBP model that Gilthari provides them \
	is a symbol of the corporation’s wealth and reach ludicrous prices when available on the black market, with licit ownership of \
	the chassis limited, by contract, to employees."
	work = "gambling, luxury consumer goods, resorts"
	headquarters = "Earth, Sol" //this seems likely
	motto = "Feel the gentle warmth of your Lucky Star." // they're really pushing their cigarette imprint lately

	missions = list(
		new /datum/lore/mission/prebuilt/luxury("ITV"), //there is simply no non-luxurious gilthari transport mission
		new /datum/lore/mission/prebuilt/freight("IFV") //i am assured these are also luxurious
		)

	serviced = list(
		/datum/lore/system/vir = 20,
		/datum/lore/system/sol = 25,
		/datum/lore/system/oasis = 30,
		/datum/lore/system/kess_gendar = 20,
		/datum/lore/system/alpha_centauri = 20,
		/datum/lore/system/tau_ceti = 20,
		/datum/lore/system/el = 15,
		/datum/lore/system/mahimahi = 10,
		/datum/lore/system/zhu_que = 10,
		/datum/lore/system/love = 10,
		/datum/lore/system/eutopia = 10,
		/datum/lore/system/gavel = 10, // kind of shit but nearby
		/datum/lore/system/abels_rest = 5, // whatever the unathi version of a shitty tourist luau is
		/datum/lore/system/phact = 3, //rich people REALLY want to go see the dumb castle
		/datum/lore/system/rarkajar = 2
		)

/datum/lore/organization/tsc/kaleidoscope
	name = "Kaleidoscope Cosmetics"
	short_name = "Kaleidoscope"
	desc = "Kaleidoscope Cosmetics is the newest Transtellar Corporation on the galactic stage, having \
	only been officially recognised as such on the Solar Galactic Exchange (SGEX) after a merger with Genix \
	Therapeutic Systems - who had recently acquired a large number of former Almach-based corporate assets - \
	in the aftermath of the Almach War. Kaleidoscope products are found almost everywhere in human space, with a \
	massive market share in personal care and textile products. Originally known for their high-quality ingredients and \
	natural fibres obtained through genetically modified plants and animals, after the Almach War and their rise to TSC \
	status their name became synonymous with cosmetic genetic modification, pushing the envelope - or the limit - on what \
	the Five Points allow, and immediately coming under scrutiny from the Transgressive Technologies Commission. \
	Kaleidoscope was one of the few TSCs to be heavily invested in the Almach Protectorate prior to the withdrawal \
	of the Far Kingdoms occupation and the easing of Skrellian trade restrictions, and as a result has been \
	at the forefront of the Almachi investment rush.The company markets itself as the only retailer providing \
	\"Real\" genetic cosmetics. Popular modifications include changes in hair and eye colour, \"true permanent\" \
	tattoos, exotic face and ear re-shaping, and \"all-natural\" anti-aging treatments. Their good fortunes and \
	heavy presence in the Almach Protectorate has lead many to speculate that a campaign of diversification may \
	be in Kaleidoscope's future."
	legit = 85 // ambigiously foreign

	missions = list(
		new /datum/lore/mission/prebuilt/transport("ITV"),
		new /datum/lore/mission/prebuilt/medical("IMV")
		)

	serviced = list(
		/datum/lore/system/vir = 20,
		/datum/lore/system/sol = 10,
		/datum/lore/system/oasis = 20,
		/datum/lore/system/exalts_light = 20,
		/datum/lore/system/new_seoul = 15,
		/datum/lore/system/vounna = 15,
		/datum/lore/system/relan = 10,
		/datum/lore/system/love = 5,
		/datum/lore/system/tau_ceti = 10,
		/datum/lore/system/alpha_centauri = 5,
		/datum/lore/system/rubicon = 5
		)

/datum/lore/organization/tsc/saare
	name = "Stealth Assault Enterprises"
	short_name = "SAARE" //no, i don't know why
	acronym = "SAARE"
	desc = "SAARE have consistently the worst reputation of any TSC. This is because they are a paramilitary group \
	specializing in deniability and secrecy. Although publically they work in asset recovery, they have a substantiated \
	reputation for info-theft and piracy that has lead to them butting heads with the law on more than one occasion. \
	Nonetheless, they are an invaluable part of the Solar economy, and other TSCs and small colonial governments keep them in business."
	headquarters = "Heaven, Alpha Centauri"
	legit = 80 // war crimes inc

	missions = list(
		new /datum/lore/mission/prebuilt/defense("IDV"),
		new /datum/lore/mission/prebuilt/defense_response("IDV")
		)

	serviced = list(
		/datum/lore/system/vir = 15,
		/datum/lore/system/sol = 5,
		/datum/lore/system/gavel = 15,
		/datum/lore/system/exalts_light = 15,
		/datum/lore/system/neon_light = 15,
		/datum/lore/system/relan =10,
		/datum/lore/system/alpha_centauri = 10,
		/datum/lore/system/oasis = 10,
		/datum/lore/system/love = 10,
		/datum/lore/system/zhu_que = 10,
		/datum/lore/system/el = 10,
		/datum/lore/system/eutopia = 5,
		/datum/lore/system/vounna = 5,
		/datum/lore/system/raphael = 5,
		/datum/lore/system/rubicon = 5,
		/datum/lore/system/terminus = 3,
		/datum/lore/system/rarkajar = 2,
		)

/datum/lore/organization/tsc/pcrc
	name = "Proxima Centauri Risk Control"
	short_name = "PCRC"
	acronym = "PCRC"
	desc = "PCRC is the softer, PR-friendlier version of SAARE, specializing in defense and security ops. PCRC is a favorite \
	for those with more money than troops, such as certain colonial governments and other TSCs. Competition with SAARE is fairly low, \
	as PCRC enjoys its reputation because SAARE exists. PCRC is also known for corporate bodyguarding and other low-risk security operations."
	headquarters = "Kishar, Alpha Centauri"

	missions = list(
		new /datum/lore/mission/prebuilt/defense("IDV"),
		new /datum/lore/mission/prebuilt/defense_response("IDV"),
		)

	serviced = list(
		/datum/lore/system/vir = 20,
		/datum/lore/system/sol = 15,
		/datum/lore/system/alpha_centauri = 20,
		/datum/lore/system/oasis = 15,
		/datum/lore/system/new_seoul = 15,
		/datum/lore/system/vounna = 10,
		/datum/lore/system/gavel = 10,
		/datum/lore/system/tau_ceti = 10,
		/datum/lore/system/zhu_que = 10,
		/datum/lore/system/love = 10,
		/datum/lore/system/eutopia = 5,
		/datum/lore/system/el = 5,
		/datum/lore/system/mahimahi = 5,
		/datum/lore/system/abels_rest = 5,
		/datum/lore/system/neon_light = 5,
		/datum/lore/system/sidhe = 5,
		)

//TODO: add in other tscs-- grayson? aether? centauri provisions?

/datum/lore/organization/tsc/independent
	name = "Free Traders"
	short_name = "Free Trader"
	desc = "Though less common now than they were in the decades before the Sol Economic Organization took power, independent traders \
	remain an important part of the galactic economy, owing in no small part to protective tarrifs established by the Free Trade Union \
	in the late twenty-forth century."
	history = ""
	work = "trade and transit"
	headquarters = "N/A"
	motto = ""
	legit = 85 //kinda amateurish

	missions = list( //my sense is theres not really free trader medical or defense craft worth mentioning -- or, i guess more accurately, an "independent defense vessel" is probably just a pirate
		new /datum/lore/mission/prebuilt/transport("ITV"),
		new /datum/lore/mission/prebuilt/freight("IFV"),
		new /datum/lore/mission/prebuilt/industrial("IIV"),
		new /datum/lore/mission/prebuilt/salvage("IIV")
		)

	serviced = list( // basically an adjusted version of the Major Bills chart but a little more evenly weighted, with some more bias towards otherwise underserved systems and with some more off-the-grid locations about it
		/datum/lore/system/vir = 20,
		/datum/lore/system/sol = 15,
		/datum/lore/system/alpha_centauri = 15,
		/datum/lore/system/tau_ceti = 15,
		/datum/lore/system/zhu_que = 15,
		/datum/lore/system/love = 15,
		/datum/lore/system/rubicon = 15,
		/datum/lore/system/kess_gendar = 10,
		/datum/lore/system/new_seoul = 10,
		/datum/lore/system/kauqxum = 10,
		/datum/lore/system/gavel = 10,
		/datum/lore/system/oasis = 10,
		/datum/lore/system/el = 10,
		/datum/lore/system/procyon = 5,
		/datum/lore/system/abels_rest = 5,
		/datum/lore/system/mahimahi = 5,
		/datum/lore/system/saint_columbia = 5,
		/datum/lore/system/rarkajar = 5,
		/datum/lore/system/eutopia = 5,
		/datum/lore/system/raphael = 5,
		/datum/lore/system/jahans_post = 5,
		/datum/lore/system/relan = 5,
		/datum/lore/system/exalts_light = 5,
		/datum/lore/system/natuna = 5,
		/datum/lore/system/casinis_reach = 5, //i laborously enscribed special snowflake code for an authentically immersive communard experience and then have them trading with exactly one org
		/datum/lore/system/nyx = 5,
		/datum/lore/system/neon_light = 3,
		/datum/lore/system/phact = 2,
		/datum/lore/system/mesomori = 2,
		/datum/lore/system/vounna = 2,
		/datum/lore/system/arrathiir = 2,
		/datum/lore/system/isavaus_gamble = 2 //literally dont even worry officer i super have a permit for this
		)

/datum/lore/organization/local_traffic
	name = "independent traffic"
	short_name = "local traffic"
	desc = "Private civilian crafts make up a small portion of Vir's space traffic. While most people use corporate shuttles to get \
	around, luxury transports and local haulers still play an important role in daily life."
	history = ""
	work = "trade and transit"
	headquarters = "N/A"
	motto = ""
	legit = 80 //extremely amateurish

	missions = list(
		new /datum/lore/mission("ITC", list("local shuttle service", "private transport"), ATC_TRANS),
		new /datum/lore/mission("IFC", list("courier", "local delivery", "just-in-time delivery"), ATC_FREIGHT),
		new /datum/lore/mission("IIC", list("local maintence", "repair", "in-situ manufacturing"), ATC_INDU),
		new /datum/lore/mission("ISC", list("test flight", "local university research", "data collection"), ATC_SCI),
		new /datum/lore/mission/prebuilt/luxury("ITC"),
		new /datum/lore/mission/prebuilt/medical_response("IMC"),
		new /datum/lore/mission/prebuilt/defense_response("IDC"),
		new /datum/lore/mission/prebuilt/salvage("IIC")
		)

	serviced = list(
		/datum/lore/system/vir = 1 // the one thing that's uncomplicated about the new system
	)

	ship_names = list(
		"Ambition",
		"Blue Moon",
		"Calypso",
		"Draco",
		"Eclipse",
		"Fantasy",
		"Golden Sun",
		"Happy Hour",
		"Ice Queen",
		"Jolly Roger",
		"Kinky Boots",
		"License to Chill",
		"Mojito",
		"No Regrets",
		"Orion",
		"Plus One",
		"Quality Time",
		"Rockhopper",
		"Sivian Sunrise",
		"Turbo Extreme",
		"Up To No Good",
		"Vertigo",
		"Wanderlust",
		"Xenophile",
		"Yesteryear",
		"Zen",
		"Sky Siffet",
		"Savik"
		)

// Governments

/datum/lore/organization/gov/virgov
	name = "Vir Governmental Authority"
	short_name = "VirGov"
	desc = "The aptly named Vir Governmental Authority is the sole governing administration for the Vir system, based \
	out of New Reykjavik on Sif. It is a representative democratic government, and a fully recognised member of the \
	Confederation.\
	<br><br>\
	Corporate entities such as NanoTrasen which operate on Sif, in Vir space, or on other bodies in the Vir system must \
	all comply with legislation as determined by the VGA and SolGov. As a result, any serious criminal offences, \
	industrial accidents, or concerning events should be forwarded to the VGA in the event that assistance or \
	communication is required from the Vir Police, Vir Defence Force, Vir Interior Ministry, or other important groups."
	history = "" // Todo like the rest of them
	work = "governing body of Vir"
	headquarters = "New Reykjavik, Sif, Vir"
	motto = ""
	legit = 95 //government

	missions = list( //most transport and freight is privatized. sifguard is its own org for whatever reason
		new /datum/lore/mission("VGA", list("energy relay", "emergency resupply", "restricted material transport"), ATC_FREIGHT),
		new /datum/lore/mission("VGA", list("refugee transport", "prison transport"), ATC_TRANS),
		new /datum/lore/mission/prebuilt/diplomatic("VGA"), //local zaddat colonies
		new /datum/lore/mission/prebuilt/scientific("VGA")
		)

	serviced = list(
		/datum/lore/system/vir = 10, //unsurprisingly, mostly stays in vir
		/datum/lore/system/gavel = 1, //sometimes does some limited local cooperative diplomacy or emergency response
		/datum/lore/system/oasis = 1
		)

	ship_names = list(
		"Alfred Nobel",
		"Anders Celcius",
		"Leif Erikson",
		"Carl Linnaeus",
		"Norge",
		"Sverige",
		"Danmark",
		"Island",
		"Suomi",
		"Helsinki",
		"Oslo",
		"Stockholm",
		"Larsson",
		"Grieg",
		"Agnetha",
		"Anni-Frid",
		"Bjorn",
		"Benny",
		"Bluetooth",
		"Gustav",
		"Lamarr",
		"Vasa",
		"Kronan",
		"Gullfoss",
		"Thingvellir"
		)

/datum/lore/organization/gov/solgov
	name = "Solar Confederate Government"
	short_name = "SolGov"
	acronym = "SCG"
	desc = "The Solar Confederate Government, or SolGov, is a mostly-human governmental entity based on Luna and \
	extending throughout most of the local bubble.\
	<br><br>\
	SolGov defines top-level law (such as sapient rights and transgressive \
	technology) and acts as an intermediary council for problems involving member states, but leaves most other law for \
	states to define themselves. The member states of SolGov obey these laws, pay confederation taxes, and provide each \
	other with military aid, in exchange for membership in the largest free trade, customs, and military union in the \
	known galaxy. Each state appoints two representatives to the Colonial Assembly where issues are voted upon. \
	The vast majority of human states are members of SolGov.\
	<br><br>\
	Sol's military forces are divided between central confederation forces and local defense forces, although it reserves \
	the right to nationalize the defense forces in the event of a major crisis, such as the SolGov-Hegemony War."
	history = "" // Todo
	work = "governing polity of humanity's Confederation"
	headquarters = "Luna, Sol"
	motto = "Nil Mortalibus Ardui Est" // Latin, because latin.  Says 'Nothing is too steep for mortals'.
	legit = 95 //government

	missions = list(
		new /datum/lore/mission("SCG-T", list("transport", "passenger transport", "prisoner transport", "refugee resettlement", "classified"), ATC_TRANS),
		new /datum/lore/mission("SCG-F", list("emergency resupply", "hazardous material transport", "strategic resupply", "classified"), ATC_FREIGHT),
		new /datum/lore/mission("SCG-E", list("damage assesment", "data recovery", "classified"), ATC_SALVAGE),
		new /datum/lore/mission("SCG-D", list("defense", "patrol", "military response", "joint exercise", "classified"), ATC_DEF),
		new /datum/lore/mission/prebuilt/scientific("SCG-S"),
		new /datum/lore/mission/prebuilt/diplomatic("SCG-D"), //local zaddat colonies, independent earth nations, internal diplomatic missions to embassies in Sol, abels rest. actual foreign diplomacy happens elsewhere
		new /datum/lore/mission/prebuilt/medical_response("SCG-M"),
		new /datum/lore/mission/prebuilt/defense_response("SCG-D")
		)

	serviced = list(
		/datum/lore/system/vir = 10,
		/datum/lore/system/sol = 25,
		/datum/lore/system/alpha_centauri = 20,
		/datum/lore/system/tau_ceti = 20,
		/datum/lore/system/kess_gendar = 20,
		/datum/lore/system/saint_columbia = 20,
		/datum/lore/system/new_ohio = 20,
		/datum/lore/system/oasis = 15,
		/datum/lore/system/gavel = 15,
		/datum/lore/system/jahans_post = 15,
		/datum/lore/system/abels_rest = 15,
		/datum/lore/system/el = 10,
		/datum/lore/system/raphael = 10,
		/datum/lore/system/altair = 10,
		/datum/lore/system/zhu_que = 10,
		/datum/lore/system/love = 5,
		/datum/lore/system/rubicon = 5,
		/datum/lore/system/procyon = 5,
		/datum/lore/system/isavaus_gamble = 3,
		/datum/lore/system/terminus = 3,
		/datum/lore/system/whythe = 2 //not in scg space but im sure they can still get at it
		)

//kind of experimental
//lets SCG do diplomacy but not eg military action in foreign systems
//in the future, similar splits could allow corps to have 'core' defense assets they dont send on idiotic military actions to Vounna
//could also be expanded with fluff ala VGA/Sifguard
/datum/lore/organization/gov/solgov/diplo_corps
	missions = list(
		new /datum/lore/mission/prebuilt/diplomatic("SCG-D")
		)
	serviced = list(
		/datum/lore/system/qerrvalis = 15, //capital systems of major interstellar powers
		/datum/lore/system/rarkajar = 15,
		/datum/lore/system/new_seoul = 15,
		/datum/lore/system/relan = 15,
		/datum/lore/system/raphael = 15, //ongoing vox crisis
		/datum/lore/system/casinis_reach = 10, //independent single systems
		/datum/lore/system/eutopia = 10,
		/datum/lore/system/phact = 10,
		/datum/lore/system/natuna = 10,
		/datum/lore/system/neon_light = 5, // neon light (neon light)
		/datum/lore/system/exalts_light = 5, //noncapital systems of major interstellar powers
		/datum/lore/system/vounna = 5,
		/datum/lore/system/sidhe = 5,
		/datum/lore/system/new_cairo = 3, //funny bugs
		)

/datum/lore/organization/gov/solgov/gsa
	name = "Solar Confederate Government Galactic Survey Administration"
	short_name = "Galactic Survey"
	acronym = "GSA"
	work = "surveying new worlds"

	missions = list(
		new /datum/lore/mission("SCG-E", list("tachyon assay", "planetary survey", "first-in", "cataloging", "biological survey"), ATC_SCI),
		)

	serviced = list(
		/datum/lore/system/dummy/gsa = 1
		)

//TODO: maybe EIO, SOFI

//foreign governments
/datum/lore/organization/gov/almach
	name = "Almach Protectorate Government"
	short_name = "Almach Protectorate"
	acronym = "APG"
	desc = "Taking the place of the short-lived Almach Association, the Almach Protectorate was formed in 2564 by the \
	Treaty of Whythe at the conclusion of the Almach War as a Skrellian collaboration government occupying the Association's \
	former territory. As a result of the Skathari Incursion, much of the Skrellian government oversight withdrew from \
	the Protectorate, which has practically devolved into a loose trade and military league consisting of regional governments \
	in the Relan, Exalt's Light, and Vounna systems and outlying systems. It is noteworthy for strong Mercurial and transhumanist \
	sentiments resulting in a markedly different culture from that accepted in SolGov, and for extreme levels of economic and political instability."
	history = ""
	work = "slowly imploding"
	headquarters = "Carter Interstellar Spaceport, Relan"
	motto = "" //they really should have one tho
	legit = 75 // hahaha no

	ship_names = list(
	"Absolutely No You-Know-What",//shelfican style names could probably be pulled from the Morpheus list at runtime
	"Just Read The Instructions",
	"Normal Ship Name",
	"I Thought He Was With You",
	"We Didn't Do It!",
	"God-Eater", //Angessian style names.
	"Hands of Many Skills",
	"Eternity's Striving",
	"Castle of Water", //"normal" / relani style names could be drawn from the default ship name list at runtime... except that a bunch of those are kind of Icarus-y and would be weird
	"Star Rat",
	"Fu Xing",
	"Haste",
	"City of Dreams",
	"Light Streaming Through Interminable Branches", //skrellian style names pulled from the Vey-Med list
	"Smoke Brought Up From A Terrible Fire",
	"King Xae'uoque",
	"Memory of Kel'xi",
	"Xi'Kroo's Herald"
	)

	missions = list(
		new /datum/lore/mission/prebuilt/diplomatic("APG"), //they don't really do foreign aid or investment or joint maneuvers so it's basically just this
		new /datum/lore/mission/("APG", list("data exchange", "joint research", "expert consultation"), ATC_SCI)
		)

	serviced = list(
		/datum/lore/system/vir = 10,
		/datum/lore/system/sol = 20,
		/datum/lore/system/new_seoul = 15,
		/datum/lore/system/rarkajar = 10,
		/datum/lore/system/neon_light = 10,
		/datum/lore/system/oasis = 5,
		/datum/lore/system/kess_gendar = 5,
		/datum/lore/system/tau_ceti = 5,
		/datum/lore/system/el = 5,
		/datum/lore/system/sidhe = 5,
		/datum/lore/system/casinis_reach = 5,
		/datum/lore/system/natuna = 3,
		/datum/lore/system/qerrvalis = 2,
		/datum/lore/system/love = 2 //zmr
		)

/datum/lore/organization/gov/five_arrows
	name = "The Five Arrows"
	short_name = "Five Arrows"
	acronym = "FA"
	desc = "The Five Arrows is an independent human governmental entity consisting of five star systems which seceeded from the Solar \
	Confederate Government in 2570, following perceived failures following the Skathari Incursion. They were later joined by a remote Skrell \
	colony world seeking better regional protection. The formation of this state led to the creation of the SCG's Regional Blocs in an effort \
	to prevent additional secessions."
	history = ""
	work = "taking their ball and going home"
	headquarters = "New Seoul"
	motto = ""
	legit = 80 // better than almach but still Foreign

	missions = list(
		new /datum/lore/mission/prebuilt/medical("FA-MV"),
		new /datum/lore/mission/("FA-RV", list("joint training", "combined operation", "miltary exercise"), ATC_DEF),
		new /datum/lore/mission/("FA-SV", list("data exchange", "joint research", "expert consultation"), ATC_SCI),
		new /datum/lore/mission/("FA-TV", list("transport", "passenger transport", "VIP transport", "refugee transport"), ATC_TRANS),
		)

	serviced = list(
		/datum/lore/system/vir = 10,
		/datum/lore/system/new_seoul = 25,
		/datum/lore/system/kauqxum = 20,
		/datum/lore/system/mahimahi = 20,
		/datum/lore/system/sidhe = 15,
		/datum/lore/system/oasis = 15,
		/datum/lore/system/el = 15,
		/datum/lore/system/natuna = 10
		)

/datum/lore/organization/gov/five_arrows/diplo_corps
	missions = list(
		new /datum/lore/mission/prebuilt/diplomatic("FA-D")
		)

	serviced = list(
		/datum/lore/system/vir = 10,
		/datum/lore/system/sol = 15,
		/datum/lore/system/natuna = 10,
		/datum/lore/system/qerrvalis = 5,
		/datum/lore/system/rarkajar = 5,
		/datum/lore/system/love = 5
		)

// TODO: pearlshield and skrell

/datum/lore/organization/gov/hegemony
	name = "Moghes Hegemony"
	short_name = "Hegemony"
	desc = " The Unity currently control the majority of Unathi space, under a government known as the Moghes Hegemony, \
	after the homeworld of the Unathi. Clans are run by the oldest members of each of the families in said clan; the Unathi \
	have great respect for the wisdom of their Elders. Day to day matters are handled by the Circle of Elders, but the official \
	leader of a clan is titled Grand Elder, and they are elected roughly every 10 Earth years from this Circle. In many respects \
	the Grand Elder is little more than prestigious figurehead position, with their obligations to the clan overriding their \
	obligations to act in the interests of their family, but they do have the final say in all tied votes on the Circle. \
	The Hegemony is comprised almost entirely of Unity Clans." //yes, this is literally all we have on them
	history = ""
	work = "being scary"
	headquarters = "Moghes, Uueoa-Esa"
	legit = 70 // we did it we found something more sus than Morpheus

	ship_names = list(
		"Trickster's Guile",
		"The Innocence of Teeth Upon the Necks of the Unworthy",
		"Heavy Hearts and Steady Hands ",
		"Reclaiming What Was Never Lost",
		"Illuminator's Humor",
		"Bared Neck and Claw",
		"The Devotion of Holding Together What Will Never Unify",
		"Bright Eyes Watching"
		)

	missions = list(
		new /datum/lore/mission/prebuilt/diplomatic("HEG-DV") //while joint operations etc happen theyre rare enough to be the focus of an ongoing arc
		)

	serviced = list(
		/datum/lore/system/sol = 20,
		/datum/lore/system/new_seoul = 15,
		/datum/lore/system/relan = 15,
		/datum/lore/system/vounna = 5,
		/datum/lore/system/exalts_light = 5,
		/datum/lore/system/rarkajar = 5,
		/datum/lore/system/qerrvalis = 5 //conspiciously missing from vir, love, and natuna. deadbeat dad ass space empire
		)


/datum/lore/organization/gov/zaddat

	ship_names = list(
		"Gentle",
		"Fortunate",
		"Willing",
		"Enduring",
		"Careful",
		"Broad",
		"Necessary",
		"Ancient",
		"Equal",
		"Perfect",
		"Seperate",
		"Tested",
		"Ceaseless",
		"Frequent",
		"Holy",
		"Incredible",
		"Brave",
		"Magnificent",
		"Distant",
		"Incandescent"
		)

/datum/lore/organization/gov/zaddat/zsac
	name = "Zaddat Special Autonomous Consortium"
	short_name = "ZSAC"
	acronym = "ZSAC"
	desc = "The ZSAC is a \"dependent state\" of SolGov, a unique legal status codified during the Age of Seccession \
	but never actually applied until the ZSAC formed in 2570. Under this status, the ZSAC is bound to confederation \
	law but not to the law of any individual member state. They also retain first rights to any habitable world discovered \
	by their fleet, although this provision remains strictly academic. They are expected to provide for their own defense, \
	which they do primarily through contracts with Solar mercenaries.The ZSAC is the most \"traditional\" of the blocs in many \
	senses, retaining Spacer Guild leadership and seeing itself as the Spacer Fleet's only true successor. The traditional \
	migrant labor-based economic system remains in place as well, although modern difficulties in travel have lead the \
	organization to increasingly favor long-duration contracts. ZSAC colonies are almost universally overcrowded, with any \
	amount of personal space being a hard-won reward for many grueling contracts. The Consortium lacks any formal religion, and \
	a casual sort of \"secular Unity\" predominates. The ZSAC includes most Colonies based out of the systems of Vir, Oasis, \
	New Ohio, and Saint Columbia, and has some members within the Core Worlds."
	history = ""
	work = "try and find a new planet so we don't all die in space"
	headquarters = "Colony Bright, Vir"
	legit = 85 // bugs

	missions = list(
		new /datum/lore/mission/prebuilt/medical("Colony"),
		new /datum/lore/mission/prebuilt/transport("Colony"),
		new /datum/lore/mission/prebuilt/freight("Colony"),
		new /datum/lore/mission/prebuilt/industrial("Colony"),
		new /datum/lore/mission/prebuilt/diplomatic("Colony"),
		new /datum/lore/mission/prebuilt/salvage("Colony"),
		)

	serviced = list(
		/datum/lore/system/vir = 20,
		/datum/lore/system/sol = 5,
		/datum/lore/system/gavel = 15,
		/datum/lore/system/oasis = 15,
		/datum/lore/system/new_ohio = 15,
		/datum/lore/system/kess_gendar = 10,
		/datum/lore/system/saint_columbia = 10,
		/datum/lore/system/alpha_centauri = 5,
		/datum/lore/system/zhu_que = 5,
		/datum/lore/system/kauqxum = 5,
		/datum/lore/system/new_seoul = 5,
		)

/datum/lore/organization/gov/zaddat/zmr
	name = "Zaddat Migratory Republic"
	short_name = "ZMR"
	acronym = "ZMR"
	desc = "The ZMR is a fully independent nation lead by the Noble Guild, though subject to a number of unequal treaties with SolGov. \
	These include compliance to Solar technological policy, a requirement to cooperate with Solar authorities investigating confederation \
	crimes, and one-sided tariffs. They have an independent fleet composed largely of militia-style converted civilian vessels and run by \
	the War Guild. Though still operating within the traditional Guild system, the ZMR rejects many of the Spacer Fleet's institutions, \
	including the Unity and Spacer Guild leadership, with many zaddat viewing a full return to the ancient Monarchies an inevitability. \
	Popular rhetoric on ZMR Colonies often veers into the nationalistic, with leadership calling for a rejection of all Hegemony-era \
	limitations and some demagogues decrying SolGov's protectionism. While there are fewer Zaddat per Colony than in the ZSAC, the \
	overcrowding problem is nearly as bad, as much of the Colonies' habitible space has been turned into production floors and much effort \
	has gone into arming ships instead of building them.The ZMR associates closely with many of the Inner Bowl's legally gray elements, and \
	ZMR vessels are banned from entering the Core Worlds and parts of the Golden Crescent. Their capital is the Colony Daring in the Love system."
	history = ""
	work = "be a fucked up military government"
	headquarters = "Colony Daring, Love"
	legit = 80 //extra shady bugs

	missions = list(
		new /datum/lore/mission/prebuilt/medical("Colony"),
		new /datum/lore/mission/prebuilt/transport("Colony"),
		new /datum/lore/mission/prebuilt/freight("Colony"),
		new /datum/lore/mission/prebuilt/industrial("Colony"),
		new /datum/lore/mission/prebuilt/diplomatic("Colony"),
		new /datum/lore/mission/prebuilt/salvage("Colony"),
		new /datum/lore/mission/prebuilt/defense("IDV"), // colonies do not get into shooting wars
		)

	serviced = list(
		/datum/lore/system/vir = 10,
		/datum/lore/system/sol = 5,
		/datum/lore/system/love = 20,
		/datum/lore/system/zhu_que = 15,
		/datum/lore/system/procyon = 10,
		/datum/lore/system/altair = 5,
		/datum/lore/system/gavel = 5,
		/datum/lore/system/oasis = 5,
		/datum/lore/system/kess_gendar = 5
		)

// Military

/datum/lore/organization/mil/sifguard
	name = "Sif Defense Force"
	short_name = "SifGuard"
	desc = "The Sif Defense Force, sometimes colloquially referred to as the SifGuard are the local government military and law enforcement organization of the Vir Governmental Authority.\
	Their primary role is the security of the Vir system and its planets, including anti-piracy patrols, Sif wilderness patrols, and local law enforcement where private security is not provided. \
	The organization has been almost wholly run by the Hedberg-Hammarstrom corporation since 2565."
	history = ""
	work = "Vir Governmental Authority's military"
	headquarters = "New Reykjavik, Sif"
	motto = ""
	legit = 95 // government

	missions = list(
		new /datum/lore/mission("VGA-PV", list("defense", "patrol", "military response", "joint exercise"), ATC_DEF),
		new /datum/lore/mission/prebuilt/defense_response("VGA-PC")
		)

	serviced = list(
		/datum/lore/system/vir = 10,
		/datum/lore/system/gavel = 1,
		/datum/lore/system/oasis = 1
		)

	ship_names = list(
			"Halfdane",
			"Hardrada",
			"Ironside",
			"Erik the Red",
			"Freydis",
			"Ragnar",
			"Ivar the Boneless",
			"Bloodaxe",
			"Sigurd Snake-in-Eye",
			"Son of Ragnar",
			"Thor",
			"Odin",
			"Freya",
			"Valhalla",
			"Loki",
			"Hel",
			"Fenrir",
			"Mjolnir",
			"Gungnir",
			"Gram",
			"Bergen",
			"Berserker",
			"Skold",
			"Draken",
			"Gladan",
			"Falken"
	)
