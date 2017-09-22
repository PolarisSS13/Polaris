/datum/gear/accessory
	display_name = "armband, red"
	path = /obj/item/clothing/accessory/armband
	slot = slot_tie
	sort_category = "Accessories"

/datum/gear/accessory/cargo
	display_name = "armband, cargo"
	path = /obj/item/clothing/accessory/armband/cargo

/datum/gear/accessory/emt
	display_name = "armband, EMT"
	path = /obj/item/clothing/accessory/armband/medblue

/datum/gear/accessory/engineering
	display_name = "armband, engineering"
	path = /obj/item/clothing/accessory/armband/engine

/datum/gear/accessory/hydroponics
	display_name = "armband, hydroponics"
	path = /obj/item/clothing/accessory/armband/hydro

/datum/gear/accessory/medical
	display_name = "armband, medical"
	path = /obj/item/clothing/accessory/armband/med

/datum/gear/accessory/medical/cross
	display_name = "armband, medic"
	path = /obj/item/clothing/accessory/armband/med/cross

/datum/gear/accessory/science
	display_name = "armband, science"
	path = /obj/item/clothing/accessory/armband/science

/datum/gear/accessory/colored
	display_name = "armband"
	path = /obj/item/clothing/accessory/armband/med/color

/datum/gear/accessory/colored/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/accessory/wallet
	display_name = "wallet, orange"
	path = /obj/item/weapon/storage/wallet/random

/datum/gear/accessory/wallet_poly
	display_name = "wallet, polychromic"
	path = /obj/item/weapon/storage/wallet/poly

/datum/gear/accessory/wallet/womens
	display_name = "wallet, womens"
	path = /obj/item/weapon/storage/wallet/womens

/datum/gear/accessory/wallet/womens/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/accessory/clutch
	display_name = "clutch bag"
	path = /obj/item/weapon/storage/briefcase/clutch
	cost = 2

/datum/gear/accessory/clutch/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/accessory/purse
	display_name = "purse"
	path = /obj/item/weapon/storage/backpack/purse
	cost = 3

/datum/gear/accessory/purse/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)


/datum/gear/accessory/wcoat
	display_name = "waistcoat"
	path = /obj/item/clothing/accessory/wcoat
	cost = 1

/datum/gear/accessory/wcoat/red
	display_name = "waistcoat, red"
	path = /obj/item/clothing/accessory/wcoat/red

/datum/gear/accessory/wcoat/grey
	display_name = "waistcoat, grey"
	path = /obj/item/clothing/accessory/wcoat/grey

/datum/gear/accessory/wcoat/brown
	display_name = "waistcoat, brown"
	path = /obj/item/clothing/accessory/wcoat/brown

/datum/gear/accessory/swvest
	display_name = "sweatervest, black"
	path = /obj/item/clothing/accessory/wcoat/swvest
	cost = 1

/datum/gear/accessory/swvest/blue
	display_name = "sweatervest, blue"
	path = /obj/item/clothing/accessory/wcoat/swvest/blue

/datum/gear/accessory/swvest/red
	display_name = "sweatervest, red"
	path = /obj/item/clothing/accessory/wcoat/swvest/red

/datum/gear/accessory/holster
	display_name = "holster selection"
	path = /obj/item/clothing/accessory/holster
	allowed_roles = list("Colony Director", "Head of Personnel", "Security Officer", "Warden", "Head of Security","Detective")

/datum/gear/accessory/holster/New()
	..()
	var/list/holsters = list()
	for(var/holster in typesof(/obj/item/clothing/accessory/holster))
		var/obj/item/clothing/accessory/holster/holster_type = holster
		holsters[initial(holster_type.name)] = holster_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(holsters))

/datum/gear/accessory/tie
	display_name = "tie, black"
	path = /obj/item/clothing/accessory/black

/datum/gear/accessory/tie/blue
	display_name = "tie, blue"
	path = /obj/item/clothing/accessory/blue

/datum/gear/accessory/tie/blue_clip
	display_name = "tie, blue with clip"
	path = /obj/item/clothing/accessory/blue_clip

/datum/gear/accessory/tie/blue_long
	display_name = "tie, blue long"
	path = /obj/item/clothing/accessory/blue_long

/datum/gear/accessory/tie/red
	display_name = "tie, red"
	path = /obj/item/clothing/accessory/red

/datum/gear/accessory/tie/red_clip
	display_name = "tie, red with clip"
	path = /obj/item/clothing/accessory/red_clip

/datum/gear/accessory/tie/red_long
	display_name = "tie, red long"
	path = /obj/item/clothing/accessory/red_long

/datum/gear/accessory/tie/yellow
	display_name = "tie, yellow"
	path = /obj/item/clothing/accessory/yellow

/datum/gear/accessory/tie/navy
	display_name = "tie, navy blue"
	path = /obj/item/clothing/accessory/navy

/datum/gear/accessory/tie/white
	display_name = "tie, white"
	path = /obj/item/clothing/accessory/white

/datum/gear/accessory/tie/horrible
	display_name = "tie, socially disgraceful"
	path = /obj/item/clothing/accessory/horrible


/datum/gear/accessory/scarf
	display_name = "scarf selection"
	path = /obj/item/clothing/accessory/scarf

/datum/gear/accessory/scarf/New()
	..()
	var/list/scarves = list()
	for(var/scarf in typesof(/obj/item/clothing/accessory/scarf/))
		var/obj/item/clothing/accessory/scarf/scarf_type = scarf
		scarves[initial(scarf_type.name)] = scarf_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(scarves))

/datum/gear/accessory/suitjacket
	display_name = "suit jacket, tan"
	path = /obj/item/clothing/accessory/tan_jacket

/datum/gear/accessory/suitjacket/charcoal
	display_name = "suit jacket, charcoal"
	path = /obj/item/clothing/accessory/charcoal_jacket

/datum/gear/accessory/suitjacket/navy
	display_name = "suit jacket, navy blue"
	path = /obj/item/clothing/accessory/navy_jacket

/datum/gear/accessory/suitjacket/burgundy
	display_name = "suit jacket, burgundy"
	path = /obj/item/clothing/accessory/burgundy_jacket

/datum/gear/accessory/suitjacket/checkered
	display_name = "suit jacket, checkered"
	path = /obj/item/clothing/accessory/checkered_jacket

/datum/gear/accessory/suitvest
	display_name = "suit vest"
	path = /obj/item/clothing/accessory/vest

/datum/gear/accessory/brown_vest
	display_name = "webbing, engineering"
	path = /obj/item/clothing/accessory/storage/brown_vest
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer","Security Officer","Detective","Head of Security","Warden","Paramedic","Chief Medical Officer","Medical Doctor")

/datum/gear/accessory/black_vest
	display_name = "webbing, security"
	path = /obj/item/clothing/accessory/storage/black_vest
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer","Security Officer","Detective","Head of Security","Warden","Paramedic","Chief Medical Officer","Medical Doctor")

/datum/gear/accessory/white_vest
	display_name = "webbing, medical"
	path = /obj/item/clothing/accessory/storage/white_vest
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer","Security Officer","Detective","Head of Security","Warden","Paramedic","Chief Medical Officer","Medical Doctor")

/datum/gear/accessory/brown_drop_pouches
	display_name = "drop pouches, engineering"
	path = /obj/item/clothing/accessory/storage/brown_drop_pouches
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer","Security Officer","Detective","Head of Security","Warden","Paramedic","Chief Medical Officer","Medical Doctor")

/datum/gear/accessory/black_drop_pouches
	display_name = "drop pouches, security"
	path = /obj/item/clothing/accessory/storage/black_drop_pouches
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer","Security Officer","Detective","Head of Security","Warden","Paramedic","Chief Medical Officer","Medical Doctor")

/datum/gear/accessory/white_drop_pouches
	display_name = "drop pouches, medical"
	path = /obj/item/clothing/accessory/storage/white_drop_pouches
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer","Security Officer","Detective","Head of Security","Warden","Paramedic","Chief Medical Officer","Medical Doctor")

/datum/gear/accessory/fannypack
	display_name = "fannypack"
	path = /obj/item/weapon/storage/belt/fannypack
	cost = 2

/datum/gear/accessory/fannypack/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/accessory/freewebbing
	display_name = "webbing, simple"
	path = /obj/item/clothing/accessory/storage
	cost = 2

/datum/gear/accessory/webbing
	display_name = "webbing & pouch selection"
	path = /obj/item/clothing/accessory/storage
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer","Security Officer","Detective","Head of Security","Warden","Paramedic","Chief Medical Officer","Medical Doctor")

/datum/gear/accessory/webbing/New()
	..()
	var/list/webbings = list()
	for(var/webbing in typesof(/obj/item/clothing/accessory/storage))
		var/obj/item/clothing/accessory/storage/webbing_type = webbing
		webbings[initial(webbing_type.name)] = webbing_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(webbings))

/datum/gear/accessory/chaps
	display_name = "chaps"
	path = /obj/item/clothing/accessory/chaps

/datum/gear/accessory/webbing/New()
	..()
	var/list/chaps = list()
	for(var/chap in typesof(/obj/item/clothing/accessory/chaps))
		var/obj/item/clothing/accessory/chaps/chap_type = chap
		chaps[initial(chap_type.name)] = chap_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(chaps))

/datum/gear/accessory/hawaii
	display_name = "hawaii shirt"
	path = /obj/item/clothing/accessory/hawaii

/datum/gear/accessory/hawaii/New()
	..()
	var/list/shirts = list()
	shirts["blue hawaii shirt"] = /obj/item/clothing/accessory/hawaii
	shirts["red hawaii shirt"] = /obj/item/clothing/accessory/hawaii/red
	shirts["random colored hawaii shirt"] = /obj/item/clothing/accessory/hawaii/random
	gear_tweaks += new/datum/gear_tweak/path(shirts)


/datum/gear/accessory/sweater
	display_name = "Sweater Selection"
	path = /obj/item/clothing/accessory/sweater

/datum/gear/accessory/sweater/New()
	..()
	var/list/sweaters = list()
	for(var/sweater in typesof(/obj/item/clothing/accessory/sweater))
		var/obj/item/clothing/suit/sweater_type = sweater
		sweaters[initial(sweater_type.name)] = sweater_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(sweaters))
