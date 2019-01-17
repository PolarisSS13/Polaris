//The different interstellar entites.
//Could be a government too, to be honest.
/datum/organization
	var/abstract_type = /datum/organization

	var/name = ""				// Organization's name
	var/short_name = ""			// Organization's shortname (NanoTrasen for "NanoTrasen Incorporated")
	var/acronym = ""			// Organization's acronym, e.g. 'NT' for NanoTrasen'.
	var/desc = ""				// One or two paragraph description of the organization, but only current stuff.  Currently unused.
	var/history = ""			// Historical discription of the organization's origins  Currently unused.
	var/work = ""				// Short description of their work, eg "an arms manufacturer"
	var/headquarters = ""		// Location of the organization's HQ.  Currently unused.
	var/motto = ""				// A motto/jingle/whatever, if they have one.  Currently unused.

	var/list/ship_prefixes = list()	//Some might have more than one! Like NanoTrasen. Value is the mission they perform, e.g. ("ABC" = "mission desc")
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
		"Explorer",
		"Swift",
		"Dragonfly",
		"Ascendant",
		"Tenacious",
		"Pioneer",
		"Hawk",
		"Haste",
		"Radiant",
		"Luminous",
		"Princess of Sol",
		"King of the Mountain",
		"Words and Changes",
		"Katerina's Silhouette",
		"Castle of Water",
		"Jade Leviathan",
		"Sword of Destiny",
		"Ishtar's Grace"
		)

	var/list/destination_names = list()	//Names of static holdings that the organization's ships visit regularly.
	var/autogenerate_destination_names = TRUE

/datum/organization/proc/Initialize()
	if(autogenerate_destination_names) // Lets pad out the destination names.
		var/i = rand(6, 10)
		var/list/star_names = list(
			"Sol", "Alpha Centauri", "Tau Ceti", "Zhu Que", "Oasis", "Vir", "Gavel", "Ganesha",
			"Saint Columbia", "Altair", "Sidhe", "New Ohio", "Parvati", "Mahi-Mahi", "Nyx", "New Seoul",
			"Kess-Gendar", "Raphael", "Phact", "Altair", "El", "Eutopia", "Qerr'valis", "Qerrna-Lakirr", "Rarkajar", "Thoth", "Jahan's Post", "Kauq'xum", "Silk", "New Singapore", "Stove", "Viola", "Love", "Isavau's Gamble" )
		var/list/destination_types = list("dockyard", "station", "vessel", "waystation", "telecommunications satellite", "spaceport", "anomaly", "colony", "outpost")
		while(i)
			destination_names.Add("a [pick(destination_types)] in [pick(star_names)]")
			i--
