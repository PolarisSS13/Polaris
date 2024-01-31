/datum/design/item/biotech
	materials = list(MAT_STEEL = 30, "glass" = 20)

/datum/design/item/biotech/AssembleDesignName()
	..()
	name = "Biotech device prototype ([item_name])"

// Biotech of various types

/datum/design/item/biotech/mass_spectrometer
	desc = "A device for analyzing chemicals in blood."
	id = "mass_spectrometer"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 2)
	build_path = /obj/item/mass_spectrometer
	sort_string = "JAAAA"

/datum/design/item/biotech/adv_mass_spectrometer
	desc = "A device for analyzing chemicals in blood and their quantities."
	id = "adv_mass_spectrometer"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 4)
	build_path = /obj/item/mass_spectrometer/adv
	sort_string = "JAAAB"

/datum/design/item/biotech/reagent_scanner
	desc = "A device for identifying chemicals."
	id = "reagent_scanner"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 2)
	build_path = /obj/item/reagent_scanner
	sort_string = "JAABA"

/datum/design/item/biotech/adv_reagent_scanner
	desc = "A device for identifying chemicals and their proportions."
	id = "adv_reagent_scanner"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 4)
	build_path = /obj/item/reagent_scanner/adv
	sort_string = "JAABB"

/datum/design/item/biotech/robot_scanner
	desc = "A hand-held scanner able to diagnose robotic injuries."
	id = "robot_scanner"
	req_tech = list(TECH_MAGNET = 3, TECH_BIO = 2, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 500, "glass" = 200)
	build_path = /obj/item/robotanalyzer
	sort_string = "JAACA"

/datum/design/item/biotech/nanopaste
	desc = "A tube of paste containing swarms of repair nanites. Very effective in repairing robotic machinery."
	id = "nanopaste"
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 7000, "glass" = 7000)
	build_path = /obj/item/stack/nanopaste
	sort_string = "JAACB"

/datum/design/item/biotech/plant_analyzer
	desc = "A device capable of quickly scanning all relevant data about a plant."
	id = "plant_analyzer"
	req_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	materials = list(MAT_STEEL = 500, "glass" = 500)
	build_path = /obj/item/analyzer/plant_analyzer
	sort_string = "JAADA"

/datum/design/item/biotech/bidon
	desc = "A canister for handling large volumes of chemicals."
	id = "bidon"
	req_tech = list(TECH_MATERIAL = 4, TECH_BIO = 4)
	materials = list(MAT_STEEL = 2000, "glass" = 1000)
	build_path = /obj/structure/reagent_dispensers/bidon
	sort_string = "JAADB"

/datum/design/item/biotech/bidon_stasis
	desc = "A stasis canister for handling large volumes of chemicals."
	id = "bidon_stasis"
	req_tech = list(TECH_MATERIAL = 6, TECH_BIO = 4, TECH_DATA = 5)
	materials = list(MAT_STEEL = 2000, "glass" = 1000, MAT_SILVER = 100)
	build_path = /obj/structure/reagent_dispensers/bidon/stasis
	sort_string = "JAADC"
