// HUDs

/datum/design/item/hud
	materials = list(MAT_STEEL = 50, "glass" = 50)

/datum/design/item/hud/AssembleDesignName()
	..()
	name = "HUD glasses prototype ([item_name])"

/datum/design/item/hud/AssembleDesignDesc()
	desc = "Allows for the construction of \a [item_name] HUD glasses."

/datum/design/item/hud/health
	name = "health scanner"
	id = "health_hud"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 3)
	build_path = /obj/item/clothing/glasses/hud/health
	sort_string = "EAAAA"

/datum/design/item/hud/security
	name = "security records"
	id = "security_hud"
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 2)
	build_path = /obj/item/clothing/glasses/hud/security
	sort_string = "EAAAB"

/datum/design/item/hud/mesons
	name = "optical meson scanner"
	id = "mesons"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/clothing/glasses/meson
	sort_string = "EAAAC"

/datum/design/item/hud/material
	name = "optical material scanner"
	id = "material"
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/clothing/glasses/material
	sort_string = "EAAAD"

/datum/design/item/hud/graviton_visor
	name = "graviton visor"
	id = "graviton_goggles"
	req_tech = list(TECH_MAGNET = 5, TECH_ENGINEERING = 3, TECH_BLUESPACE = 3, TECH_PHORON = 3)
	materials = list(MAT_PLASTEEL = 2000, MAT_GLASS = 3000, MAT_PHORON = 1500)
	build_path = /obj/item/clothing/glasses/graviton
	sort_string = "EAAAE"

/datum/design/item/hud/nightvision_visor
	name = "nightvision visor"
	id = "nightvision_goggles"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 4)
	materials = list(MAT_ALUMINIUM = 1000, MAT_GLASS = 3000)
	build_path = /obj/item/clothing/glasses/night
	sort_string = "EAAAF"

/datum/design/item/hud/thermal_visor
	name = "thermal visor"
	id = "thermal_goggles"
	req_tech = list(TECH_MAGNET = 6, TECH_ENGINEERING = 6, TECH_PHORON = 4, TECH_ILLEGAL = 7)
	materials = list(MAT_TITANIUM = 3000, MAT_GLASS = 2000, MAT_PHORON = 1000, MAT_DIAMOND = 1500)
	build_path = /obj/item/clothing/glasses/thermal/plain
	sort_string = "EAAAG"
