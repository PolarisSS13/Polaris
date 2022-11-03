/datum/var/whitelist_decl = null

/decl/whitelist
	abstract_type = /decl/whitelist
	var/display_name

/decl/whitelist/language
	abstract_type = /decl/whitelist/language

/decl/whitelist/species
	abstract_type = /decl/whitelist/species

/decl/whitelist/genemod // This whitelists a collection of sprite_accessories
	display_name = "Genemods"
	uid = "genemod"

/decl/whitelist/language/skrell
	display_name = "Common Skrellian"
	uid = "lang_skrell_common"

/decl/whitelist/language/skrell/high
	display_name = "High Skrellian"
	uid = "lang_skrell_high"

/decl/whitelist/language/unathi
	display_name = "Sinta'Unathi"
	uid = "lang_unathi"

/decl/whitelist/language/taj
	display_name = "Siik"
	uid = "lang_taj"

/decl/whitelist/language/taj/akhani
	display_name = "Akhani"
	uid = "lang_taj2"

/decl/whitelist/language/taj/sign
	display_name = "Alai"
	uid = "lang_taj_sign"

/decl/whitelist/language/teshari
	display_name = "Schechi"
	uid = "lang_tesh"

/decl/whitelist/language/human
	display_name = "Sol Common"
	uid = "lang_human"

/decl/whitelist/species/skrell
	display_name = "Skrell"
	uid = "species_skrell"

/decl/whitelist/species/diona
	display_name = "Diona"
	uid = "species_diona"

/decl/whitelist/species/unathi
	display_name = "Unathi"
	uid = "species_unathi"

/decl/whitelist/species/tajara
	display_name = "Tajara"
	uid = "species_taj"

/decl/whitelist/species/teshari
	display_name = "Teshari"
	uid = "species_tesh"

/decl/whitelist/species/promethean
	display_name = "Promethean"
	uid = "species_promethean"

/decl/whitelist/species/zaddat
	display_name = "Zaddat"
	uid = "species_zaddat"

/decl/whitelist/species/vox
	display_name = "Vox"
	uid = "species_vox"
