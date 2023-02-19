/datum/lore/system
	var/name = "" //the system's name
	var/desc = "" // short description probably stolen from places on the wiki
	var/history = "" //unused, but included for parity with /lore/organizations
	var/autogenerate_destinations = TRUE // should probably be true for most systems, might be false for Sif or weird shit like Isavau's / Terminus / Silk
	var/list/planets = list() //planetary destinations will automatically pick an inhabited terrestrial planet to be on. no planet == no planetary destinations. major planets only
	var/list/space_destinations = list("a dockyard", "a station", "a vessel", "a waystation", "a satellite", "a spaceport", "an anomaly", "a habitat", "an outpost", "a facility") // should be just fine for most systems, some might want individual entries culled from the autogen
	var/list/planetary_destinations = list("a colony", "a dome", "an outpost", "a city", "a facility") //likewise
	var/list/locations = list() // locations within the system. list of strings for now, might involve fancier logic later

/datum/lore/system/New()
	..()
	if(autogenerate_destinations)
		var/i = 3
		while(i) // three random places per system per round should be plenty
			var/initial = ""
			var/mission = list()
			if(rand(length(planets))) // equal chance of an event in local space or any individual planet
				initial = pick(planetary_destinations)
				if(initial in list("an outpost", "a facility")) //clunky but w/e
					mission = list(ATC_TYPICAL)
				else
					mission = list(ATC_ALL)
				locations += new /datum/lore/location((initial + " on " + pick(planets) + ", " + name), mission)
			else
				initial = pick(space_destinations)
				if(initial in list("a waystation", "a satellite"))
					mission = list(ATC_TRANS, ATC_FREIGHT, ATC_DEF, ATC_INDU) //generally unmanned so no medical or science jobs
				else if(initial in list("an anomaly"))
					mission = list(ATC_DEF, ATC_SCI) //theres kinda only two things to do about mysterious space wedgies)
				else if(initial in list("a dockyard", "a station", "a vessel", "a spaceport", "an outpost", "a facility"))
					mission = list(ATC_TYPICAL)
				else
					mission = list(ATC_ALL)
				locations += new /datum/lore/location("[initial] in [name]", mission)
			i--
		locations += new /datum/lore/location("in [name]", list(ATC_ALL)) //disable after testing?

/datum/lore/system/ganesha
	name = "Ganesha"
	desc = "Can you believe that shit has been on the timeline since like 2016 and its never even made it onto the map. the south dakota of space."
	planets = list("It Probably Has One??")

/datum/lore/system/sol
	name = "Sol"
/*
/datum/lore/system/vir
	name = "Vir"
	desc = "Vir's government stabilized comparatively recently, and as a result has a smaller population \
	than most other garden worlds. Its position along the Almach Stream and centralized between the Core Worlds, \
	the Sagittarius Heights, and the Golden Crescent made it a veritable trade hub for many years prior to the \
	Tachyon Downtick, attracting the interest of a number of Trans-Stellar Corporations, most prominently \
	Nanotrasen. Traditionally considered a fairly \"safe\" system, its immense volume of trade has always attracted \
	a number of pirates, and the high concentration of xenoarchaeological artifacts made it a focal point for the \
	devastating Skathari Incursion, which has rendered some regions of the system particularly dangerous to this day, \
	including some of Sif's surface, most notably the Anomalous Region. Vir is the capital system of the Golden Crescent Alliance Bloc."
	history = ""
	autogenerate_destination_names = FALSE // Vir is detailed enough to not need autogeneration
	planets.Add("Sif") //not necessary but nice for parsimony
	locations = list(
		"New Reykjavik",
		"Kalmar",
		"Ekmanshalvo",
		"a settlement on Sif",
		"a corporate facility on Sif",
		"the Ullran Expanse",
		"Kaltsandur",
		"Amundsen",
		"Londuneyja",
		"the Thorvaldsson Plains",
		"the NCS Northern Star in Karan orbit",
		"a location in the Sivian wilderness",
		"Sif orbit",
		"the rings of Kara",
	"the rings of Rota",
		"Firnir orbit",
		"Tyr orbit",
		"Magni orbit",
		"a vessel in Vir territory",
		"a mining outpost")
*/