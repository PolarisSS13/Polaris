/datum/gear/accessory
	display_name = "locket"
	slot = slot_tie
	sort_category = "Accessories"
	type_category = /datum/gear/accessory
	path = /obj/item/clothing/accessory/locket
	cost = 1

/datum/gear/accessory/armband
	display_name = "armband selection"
	path = /obj/item/clothing/accessory/armband

/datum/gear/accessory/armband/New()
	..()
	var/list/armbands = list()
	for(var/armband in (typesof(/obj/item/clothing/accessory/armband) - typesof(/obj/item/clothing/accessory/armband/med/color)))
		var/obj/item/clothing/accessory/armband_type = armband
		armbands[initial(armband_type.name)] = armband_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(armbands))

/datum/gear/accessory/armband/colored
	display_name = "armband (colorable)"
	path = /obj/item/clothing/accessory/armband/med/color

/datum/gear/accessory/armband/colored/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/wallet
	display_name = "wallet, orange"
	path = /obj/item/storage/wallet/random

/datum/gear/accessory/wallet_poly
	display_name = "wallet, polychromic"
	path = /obj/item/storage/wallet/poly

/datum/gear/accessory/wallet/womens
	display_name = "wallet, womens (colorable)"
	path = /obj/item/storage/wallet/womens

/datum/gear/accessory/wallet/womens/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/clutch
	display_name = "clutch bag"
	path = /obj/item/storage/briefcase/clutch
	cost = 2

/datum/gear/accessory/clutch/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/purse
	display_name = "purse"
	path = /obj/item/storage/backpack/purse
	cost = 3

/datum/gear/accessory/purse/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/wcoat
	display_name = "waistcoat selection"
	path = /obj/item/clothing/accessory/wcoat
	cost = 1

/datum/gear/accessory/wcoat/New()
	..()
	var/list/wcoats = list()
	for(var/wcoat in typesof(/obj/item/clothing/accessory/wcoat))
		var/obj/item/clothing/accessory/wcoat_type = wcoat
		wcoats[initial(wcoat_type.name)] = wcoat_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(wcoats))

/datum/gear/accessory/holster
	display_name = "holster selection (Security, CD, HoP)"
	path = /obj/item/clothing/accessory/holster
	allowed_roles = list("Site Manager", "Head of Personnel", "Security Officer", "Warden", "Head of Security","Detective")

/datum/gear/accessory/holster/New()
	..()
	var/list/holsters = list()
	for(var/holster in typesof(/obj/item/clothing/accessory/holster))
		var/obj/item/clothing/accessory/holster_type = holster
		holsters[initial(holster_type.name)] = holster_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(holsters))

/datum/gear/accessory/tie
	display_name = "tie selection"
	path = /obj/item/clothing/accessory/tie
	cost = 1

/datum/gear/accessory/tie/New()
	..()
	var/list/ties = list()
	for(var/tie in typesof(/obj/item/clothing/accessory/tie))
		var/obj/item/clothing/accessory/tie_type = tie
		ties[initial(tie_type.name)] = tie_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(ties))

/datum/gear/accessory/scarf
	display_name = "scarf selection"
	path = /obj/item/clothing/accessory/scarf
	cost = 1

/datum/gear/accessory/scarf/New()
	..()
	var/list/scarfs = list()
	for(var/scarf in typesof(/obj/item/clothing/accessory/scarf))
		var/obj/item/clothing/accessory/scarf_type = scarf
		scarfs[initial(scarf_type.name)] = scarf_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(scarfs))

/datum/gear/accessory/scarfcolor
	display_name = "scarf (recolorable)"
	path = /obj/item/clothing/accessory/scarf/white
	cost = 1

/datum/gear/accessory/scarfcolor/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/bowtie
	display_name = "bowtie selection"
	path = /obj/item/clothing/accessory/bowtie
	cost = 1

/datum/gear/accessory/bowtie/New()
	..()
	var/list/bowties = list()
	for(var/obj/item/clothing/accessory/bowtie_type as anything in typesof(/obj/item/clothing/accessory/bowtie))
		bowties[initial(bowtie_type.name)] = bowtie_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(bowties))

/datum/gear/accessory/jacket
	display_name = "suit jacket selection"
	path = /obj/item/clothing/accessory/jacket
	cost = 1

/datum/gear/accessory/jacket/New()
	..()
	var/list/jackets = list()
	for(var/jacket in typesof(/obj/item/clothing/accessory/jacket))
		var/obj/item/clothing/accessory/jacket_type = jacket
		jackets[initial(jacket_type.name)] = jacket_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(jackets))

/datum/gear/accessory/suitvest
	display_name = "suit vest, black"
	path = /obj/item/clothing/accessory/vest

/datum/gear/accessory/webbing_vest
	display_name = "webbing vest selection (Engineering, Security, Medical)"
	path = /obj/item/clothing/accessory/storage/brown_vest
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer","Security Officer","Detective","Head of Security","Warden","Paramedic","Chief Medical Officer","Medical Doctor", "Search and Rescue")

/datum/gear/accessory/webbing_vest/New()
	..()
	var/list/webbingtype = list(
	"webbing, brown" = /obj/item/clothing/accessory/storage/brown_vest,
	"webbing, black" = /obj/item/clothing/accessory/storage/black_vest,
	"webbing, white" = /obj/item/clothing/accessory/storage/white_vest
	)
	gear_tweaks += new/datum/gear_tweak/path(webbingtype)

/datum/gear/accessory/webbing_simple
	display_name = "webbing, simple"
	path = /obj/item/clothing/accessory/storage/webbing
	cost = 2

/datum/gear/accessory/drop_pouches
	display_name = "drop pouches selection (Engineering, Security, Medical)"
	path = /obj/item/clothing/accessory/storage/brown_drop_pouches
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer","Security Officer","Detective","Head of Security","Warden","Paramedic","Chief Medical Officer","Medical Doctor", "Search and Rescue")

/datum/gear/accessory/drop_pouches/New()
	..()
	var/list/pouchtype = list(
	"drop pouches, brown" = /obj/item/clothing/accessory/storage/brown_drop_pouches,
	"drop pouches, black" = /obj/item/clothing/accessory/storage/black_drop_pouches,
	"drop pouches, white" = /obj/item/clothing/accessory/storage/white_drop_pouches
	)
	gear_tweaks += new/datum/gear_tweak/path(pouchtype)

/datum/gear/accessory/overalls
	display_name = "utility overalls selection (Engineering, Cargo)"
	path = /obj/item/clothing/accessory/storage/overalls
	allowed_roles = list("Station Engineer", "Atmospheric Technician", "Chief Engineer", "Cargo Technician", "Quartermaster", "Shaft Miner")

/datum/gear/accessory/overalls/New()
	..()
	var/overalltype = list(
	"overalls, high-vis stripe" = /obj/item/clothing/accessory/storage/overalls,
	"overalls, brown" = /obj/item/clothing/accessory/storage/overalls/engineer
	)
	gear_tweaks += new/datum/gear_tweak/path(overalltype)

/datum/gear/accessory/fannypack
	display_name = "fannypack selection"
	cost = 2
	path = /obj/item/storage/belt/fannypack

/datum/gear/accessory/fannypack/New()
	..()
	var/list/fannys = list()
	for(var/fanny in typesof(/obj/item/storage/belt/fannypack))
		var/obj/item/storage/belt/fannypack/fanny_type = fanny
		fannys[initial(fanny_type.name)] = fanny_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(fannys))

/datum/gear/accessory/chaps
	display_name = "chaps, brown"
	path = /obj/item/clothing/accessory/chaps

/datum/gear/accessory/chaps/black
	display_name = "chaps, black"
	path = /obj/item/clothing/accessory/chaps/black

/datum/gear/accessory/hawaii
	display_name = "hawaii shirt"
	path = /obj/item/clothing/accessory/hawaii

/datum/gear/accessory/hawaii/New()
	..()
	var/list/shirts = list(
	"blue hawaii shirt" = /obj/item/clothing/accessory/hawaii,
	"red hawaii shirt" = /obj/item/clothing/accessory/hawaii/red,
	"random colored hawaii shirt" = /obj/item/clothing/accessory/hawaii/random
	)
	gear_tweaks += new/datum/gear_tweak/path(shirts)

/datum/gear/accessory/sweater
	display_name = "sweater selection"
	path = /obj/item/clothing/accessory/sweater

/datum/gear/accessory/sweater/New()
	..()
	var/list/sweaters = list()
	for(var/sweater in typesof(/obj/item/clothing/accessory/sweater))
		var/obj/item/clothing/suit/sweater_type = sweater
		sweaters[initial(sweater_type.name)] = sweater_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(sweaters))

/datum/gear/accessory/bracelet/material
	display_name = "bracelet, selection"
	description = "Choose from a number of bracelets."
	path = /obj/item/clothing/accessory/bracelet
	cost = 1

/datum/gear/accessory/bracelet/material/New()
	..()
	var/list/bracelettype = list(
	"bracelet, steel" = /obj/item/clothing/accessory/bracelet/material/steel,
	"bracelet, iron" = /obj/item/clothing/accessory/bracelet/material/iron,
	"bracelet, silver" = /obj/item/clothing/accessory/bracelet/material/silver,
	"bracelet, gold" = /obj/item/clothing/accessory/bracelet/material/gold,
	"bracelet, platinum" = /obj/item/clothing/accessory/bracelet/material/platinum,
	"bracelet, glass" = /obj/item/clothing/accessory/bracelet/material/glass,
	"bracelet, wood" = /obj/item/clothing/accessory/bracelet/material/wood,
	"bracelet, sivian wood" = /obj/item/clothing/accessory/bracelet/material/sifwood,
	"bracelet, plastic" = /obj/item/clothing/accessory/bracelet/material/plastic,
	"bracelet, copper" = /obj/item/clothing/accessory/bracelet/material/copper,
	"bracelet, bronze" = /obj/item/clothing/accessory/bracelet/material/bronze,
	"bracelet, friendship" = /obj/item/clothing/accessory/bracelet/friendship
	)
	gear_tweaks += new/datum/gear_tweak/path(bracelettype)

/datum/gear/accessory/bracelet/slap
	display_name = "bracelet, slap (colorable)"
	path = /obj/item/clothing/accessory/bracelet/slap

/datum/gear/accessory/bracelet/slap/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/bracelet/beaded
	display_name = "bracelet, beaded (colorable)"
	path = /obj/item/clothing/accessory/bracelet/beaded

/datum/gear/accessory/bracelet/beaded/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/stethoscope
	display_name = "stethoscope"
	path = /obj/item/clothing/accessory/stethoscope
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Psychiatrist","Paramedic", "Search and Rescue")

/datum/gear/accessory/halfcape
	display_name = "cape, half"
	path = /obj/item/clothing/accessory/halfcape

/datum/gear/accessory/fullcape
	display_name = "cape, full"
	path = /obj/item/clothing/accessory/fullcape



/datum/gear/accessory/sash
	display_name = "sash (colorable)"
	path = /obj/item/clothing/accessory/sash

/datum/gear/accessory/sash/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/asym
	display_name = "asymmetric jacket selection"
	path = /obj/item/clothing/accessory/asymmetric
	cost = 1

/datum/gear/accessory/asym/New()
	..()
	var/list/asyms = list()
	for(var/asym in typesof(/obj/item/clothing/accessory/asymmetric))
		var/obj/item/clothing/accessory/asymmetric_type = asym
		asyms[initial(asymmetric_type.name)] = asymmetric_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(asyms))

/datum/gear/accessory/cowledvest
	display_name = "cowled vest"
	path = /obj/item/clothing/accessory/cowledvest

/datum/gear/accessory/asymovercoat
	display_name = "orange asymmetrical overcoat"
	path = /obj/item/clothing/accessory/asymovercoat

/datum/gear/accessory/virginkiller
	display_name = "virgin killer sweater (colorable)"
	path = /obj/item/clothing/accessory/sweater/virgin

/datum/gear/accessory/virginkiller/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/pride
	display_name = "pride pin selection"
	path = /obj/item/clothing/accessory/medal/pride

/datum/gear/accessory/pride/New()
	..()
	var/list/pridepins = list()
	for(var/pridepin in typesof(/obj/item/clothing/accessory/medal/pride))
		var/obj/item/clothing/accessory/medal/pridepin_type = pridepin
		pridepins[initial(pridepin_type.name)] = pridepin_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(pridepins))

/datum/gear/accessory/corpbadge
	display_name = "investigator holobadge (IAA)"
	path = /obj/item/clothing/accessory/medal/badge/holo/investigator
	allowed_roles = list("Internal Affairs Agent")

/datum/gear/accessory/pressbadge
	display_name = "press pass, corporate"
	path = /obj/item/clothing/accessory/medal/badge/press

/datum/gear/accessory/pressbadgefreelance
	display_name = "press pass, freelance"
	path = /obj/item/clothing/accessory/medal/badge/press/independent

/datum/gear/accessory/legbrace
	display_name = "leg braces"
	path = /obj/item/clothing/accessory/legbrace

/datum/gear/accessory/neckerchief
	display_name = "neckerchief, color select"
	path = /obj/item/clothing/accessory/neckerchief

/datum/gear/accessory/necklace
	display_name = "necklace selection"
	description = "Choose from a number of neclkaces."
	path = /obj/item/clothing/accessory/necklace
	cost = 1

/datum/gear/accessory/necklace/New()
	..()
	var/list/necklacetype = list(
	"necklace, steel" = /obj/item/clothing/accessory/necklace/steel,
	"necklace, iron" = /obj/item/clothing/accessory/necklace/iron,
	"necklace, silver" = /obj/item/clothing/accessory/necklace/silver,
	"necklace, gold" = /obj/item/clothing/accessory/necklace/gold,
	"necklace, platinum" = /obj/item/clothing/accessory/necklace/platinum,
	"necklace, glass" = /obj/item/clothing/accessory/necklace/glass,
	"necklace, wood" = /obj/item/clothing/accessory/necklace/wood,
	"necklace, sivian wood" = /obj/item/clothing/accessory/necklace/sifwood,
	"necklace, plastic" = /obj/item/clothing/accessory/necklace/plastic,
	"necklace, copper" = /obj/item/clothing/accessory/necklace/copper,
	"necklace, bronze" = /obj/item/clothing/accessory/necklace/bronze
	)
	gear_tweaks += new/datum/gear_tweak/path(necklacetype)

/datum/gear/accessory/neckerchief/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/watch
	display_name = "watch selection"
	description = "Choose from a number of wristwatches."
	path = /obj/item/clothing/accessory/watch
	cost = 1

/datum/gear/accessory/watch/New()
	..()
	var/list/watchtype = list(
	"watch" = /obj/item/clothing/accessory/watch,
	"watch, silver" = /obj/item/clothing/accessory/watch/silver,
	"watch, gold" = /obj/item/clothing/accessory/watch/gold,
	"watch, holographic" = /obj/item/clothing/accessory/watch/holo,
	"watch, leather" = /obj/item/clothing/accessory/watch/leather
	)
	gear_tweaks += new/datum/gear_tweak/path(watchtype)

/datum/gear/accessory/ceremonial_bracers
	display_name = "ceremonial bracers"
	path = /obj/item/clothing/accessory/ceremonial_bracers

/datum/gear/accessory/ceremonial_loins
	display_name = "ceremonial loincloth"
	path = /obj/item/clothing/accessory/ceremonial_loins
