
/datum/design/circuit/disk
	build_type = IMPRINTER
	req_tech = list(TECH_DATA = 3)
	materials = list(MAT_PLASTIC = 2000, MAT_GLASS = 1000)
	chemicals = list("pacid" = 10)
	time = 5

/datum/design/circuit/disk/AssembleDesignName()
	..()
	if(build_path)
		var/obj/item/weapon/disk/D = build_path
		if(istype(D, /obj/item/weapon/disk/species))
			name = "Species Prosthetic design ([item_name])"
		else if(istype(D, /obj/item/weapon/disk/limb))
			name = "Transtellar Prosthetic design ([item_name])"
		else
			name = "Disk design ([item_name])"

/datum/design/circuit/disk/skrellprint
	name = SPECIES_SKRELL
	id = "prosthetic_skrell"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/weapon/disk/species/skrell
	sort_string = "DBAAA"

/datum/design/circuit/disk/tajprint
	name = SPECIES_TAJ
	id = "prosthetic_tajaran"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/weapon/disk/species/tajaran
	sort_string = "DBAAB"

/datum/design/circuit/disk/unathiprint
	name = SPECIES_UNATHI
	id = "prosthetic_unathi"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 4)
	build_path = /obj/item/weapon/disk/species/unathi
	sort_string = "DBAAC"

/datum/design/circuit/disk/ print
	name = SPECIES_
	id = "prosthetic_ "
	req_tech = list(TECH_DATA = 3, TECH_BIO = 4)
	build_path = /obj/item/weapon/disk/species/
	sort_string = "DBAAD"
