// Alien clothing.

/datum/gear/suit/zhan_furs
	display_name = "Zhan-Khazan furs (Tajaran)"
	path = /obj/item/clothing/suit/tajaran/furs
	sort_category = "Xenowear"

/datum/gear/head/zhan_scarf
	display_name = "Zhan headscarf (colorable)"
	path = /obj/item/clothing/head/tajaran/scarf
	whitelisted = SPECIES_TAJ

/datum/gear/head/zhan_scarf/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/unathi_mantle
	display_name = "hide mantle (Unathi)"
	path = /obj/item/clothing/suit/unathi/mantle
	cost = 1
	sort_category = "Xenowear"

/datum/gear/ears/skrell/chains	//Chains
	display_name = "headtail chain selection (Skrell)"
	path = /obj/item/clothing/ears/skrell/chain
	sort_category = "Xenowear"
	whitelisted = SPECIES_SKRELL

/datum/gear/ears/skrell/chains/New()
	..()
	var/list/chaintypes = list()
	for(var/chain_style in typesof(/obj/item/clothing/ears/skrell/chain))
		var/obj/item/clothing/ears/skrell/chain/chain = chain_style
		chaintypes[initial(chain.name)] = chain
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(chaintypes))

/datum/gear/ears/skrell/bands
	display_name = "headtail band selection (Skrell)"
	path = /obj/item/clothing/ears/skrell/band
	sort_category = "Xenowear"
	whitelisted = SPECIES_SKRELL

/datum/gear/ears/skrell/bands/New()
	..()
	var/list/bandtypes = list()
	for(var/band_style in typesof(/obj/item/clothing/ears/skrell/band))
		var/obj/item/clothing/ears/skrell/band/band = band_style
		bandtypes[initial(band.name)] = band
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(bandtypes))

/datum/gear/ears/skrell/cloth/short
	display_name = "short headtail cloth (Skrell)"
	path = /obj/item/clothing/ears/skrell/cloth_male/black
	sort_category = "Xenowear"
	whitelisted = SPECIES_SKRELL

/datum/gear/ears/skrell/cloth/short/New()
	..()
	var/list/shorttypes = list()
	for(var/short_style in typesof(/obj/item/clothing/ears/skrell/cloth_male))
		var/obj/item/clothing/ears/skrell/cloth_male/short = short_style
		shorttypes[initial(short.name)] = short
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(shorttypes))

/datum/gear/ears/skrell/cloth/long
	display_name = "long headtail cloth (Skrell)"
	path = /obj/item/clothing/ears/skrell/cloth_female/black
	sort_category = "Xenowear"
	whitelisted = SPECIES_SKRELL

/datum/gear/ears/skrell/cloth/long/New()
	..()
	var/list/longtypes = list()
	for(var/long_style in typesof(/obj/item/clothing/ears/skrell/cloth_female))
		var/obj/item/clothing/ears/skrell/cloth_female/long = long_style
		longtypes[initial(long.name)] = long
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(longtypes))

/datum/gear/ears/skrell/colored/band
	display_name = "colored bands (Skrell)"
	path = /obj/item/clothing/ears/skrell/colored/band
	sort_category = "Xenowear"
	whitelisted = SPECIES_SKRELL

/datum/gear/ears/skrell/colored/band/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/ears/skrell/colored/chain
	display_name = "colored chain (Skrell)"
	path = /obj/item/clothing/ears/skrell/colored/chain
	sort_category = "Xenowear"
	whitelisted = SPECIES_SKRELL

/datum/gear/ears/skrell/colored/chain/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/uniform/smock
	display_name = "Teshari smock selection"
	path = /obj/item/clothing/under/teshari/smock
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/uniform/smock/New()
	..()
	var/list/smocks = list()
	for(var/smock in typesof(/obj/item/clothing/under/teshari/smock))
		var/obj/item/clothing/under/teshari/smock/smock_type = smock
		smocks[initial(smock_type.name)] = smock_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(smocks))

/datum/gear/uniform/undercoat
	display_name = "Teshari undercoat selection"
	path = /obj/item/clothing/under/teshari/undercoat/standard
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/uniform/undercoat/New()
	..()
	var/list/undercoats = list()
	for(var/undercoat in typesof(/obj/item/clothing/under/teshari/undercoat/standard))
		var/obj/item/clothing/under/teshari/undercoat/standard/undercoat_type = undercoat
		undercoats[initial(undercoat_type.name)] = undercoat_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(undercoats))

/datum/gear/suit/cloak
	display_name = "Teshari cloak selection"
	path = /obj/item/clothing/suit/storage/teshari/cloak/standard
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/suit/cloak/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/teshari/cloak/standard))
		var/obj/item/clothing/suit/storage/teshari/cloak/standard/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/uniform/harness
	display_name = "gear harness (Full Body Prosthetic, Diona)"
	path = /obj/item/clothing/under/harness
	sort_category = "Xenowear"

/datum/gear/shoes/footwraps
	display_name = "cloth footwraps"
	path = /obj/item/clothing/shoes/footwraps
	sort_category = "Xenowear"
	cost = 1

/datum/gear/shoes/footwraps/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/uniform/cohesionsuits
	display_name = "cohesion suit selection (Promethean)"
	path = /obj/item/clothing/under/cohesion
	sort_category = "Xenowear"

/datum/gear/uniform/cohesionsuits/New()
	..()
	var/list/cohesionsuits = list()
	for(var/cohesionsuit in (typesof(/obj/item/clothing/under/cohesion)))
		var/obj/item/clothing/under/cohesion/cohesion_type = cohesionsuit
		cohesionsuits[initial(cohesion_type.name)] = cohesion_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cohesionsuits))

/datum/gear/uniform/teshundercoat
	display_name = "Teshari undercoat selection"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/hop
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/uniform/teshundercoat/New()
	..()
	var/list/teshundercoats = list()
	for(var/teshundercoat_style in typesof(/obj/item/clothing/under/teshari/undercoat/jobs))
		var/obj/item/clothing/under/teshari/undercoat/jobs/teshundercoat = teshundercoat_style
		teshundercoats[initial(teshundercoat.name)] = teshundercoat
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(teshundercoats))

/datum/gear/suit/teshcloak
	display_name = "Teshari cloak selection, jobs"
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/suit/teshcloak/New()
	..()
	var/list/teshcloaks = list()
	for(var/teshcloak_style in typesof(/obj/item/clothing/suit/storage/teshari/cloak/jobs, /obj/item/clothing/suit/storage/teshari/beltcloak/jobs))
		var/obj/item/clothing/suit/storage/teshari/cloak/jobs/teshcloak = teshcloak_style
		teshcloaks[initial(teshcloak.name)] = teshcloak
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(teshcloaks))

/datum/gear/uniform/smockcolor
	display_name = "Teshari smock (colorable)"
	path = /obj/item/clothing/under/teshari/smock/white
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/uniform/smockcolor/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/beltcloak
	display_name = "Teshari cloak selection, belted"
	path = /obj/item/clothing/suit/storage/teshari/beltcloak/standard
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/suit/beltcloak/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/teshari/beltcloak/standard))
		var/obj/item/clothing/suit/storage/teshari/beltcloak/standard/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/beltcloak_color
	display_name = "Teshari cloak, belted (colorable)"
	path = /obj/item/clothing/suit/storage/teshari/beltcloak/standard/white_grey
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/suit/beltcloak_color/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/cloak_hood
	display_name = "Teshari cloak selection, hooded"
	path = /obj/item/clothing/suit/storage/hooded/teshari/standard
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/suit/cloak_hood/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/hooded/teshari/standard))
		var/obj/item/clothing/suit/storage/teshari/cloak/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/uniform/worksuit
	display_name = "Teshari worksuit selection"
	path = /obj/item/clothing/under/teshari/undercoat/standard/worksuit
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/uniform/worksuit/New()
	..()
	var/list/worksuits = list()
	for(var/worksuit in typesof(/obj/item/clothing/under/teshari/undercoat/standard/worksuit))
		var/obj/item/clothing/under/teshari/undercoat/standard/worksuit/worksuit_type = worksuit
		worksuits[initial(worksuit_type.name)] = worksuit_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(worksuits))

/datum/gear/uniform/undercoatcolor
	display_name = "Teshari undercoat (colorable)"
	path = /obj/item/clothing/under/teshari/undercoat/standard/white_grey
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/uniform/undercoatcolor/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/cloakcolor
	display_name = "Teshari cloak (colorable)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/standard/white_grey
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/suit/cloakcolor/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/labcoat_tesh
	display_name = "Teshari labcoat (colorable)"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/teshari
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/suit/labcoat_tesh/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/teshcoat
	display_name = "Teshari smallcoat, (colorable stripes)"
	path = /obj/item/clothing/suit/storage/toggle/tesharicoat
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/suit/teshcoat/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/teshcoatwhite
	display_name = "Teshari smallcoat (colorable)"
	path = /obj/item/clothing/suit/storage/toggle/tesharicoatwhite
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/suit/teshcoatwhite/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/teshneckscarf
	display_name = "Teshari neckscarf, (colorable)"
	path = /obj/item/clothing/accessory/scarf/teshari/neckscarf
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/accessory/teshneckscarf/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/eyes/aerogelgoggles
	display_name = "Teshari airtight orange goggles"
	path = /obj/item/clothing/glasses/aerogelgoggles
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/utility/teshchair
	display_name = "small electric wheelchair (Teshari)"
	path = /obj/item/wheelchair/motor/small
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"
	cost = 4

/datum/gear/shoes/teshwrap
	display_name = "Teshari legwraps"
	path = /obj/item/clothing/shoes/footwraps/teshari
	sort_category = "Xenowear"
	whitelisted = SPECIES_TESHARI
	cost = 1

/datum/gear/shoes/teshwrap/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/teshbag
	display_name = "Teshari tailbags"
	path = /obj/item/storage/backpack/teshbag
	sort_category = "Xenowear"
	whitelisted = SPECIES_TESHARI
	cost = 3

/datum/gear/accessory/teshtailwrap
	display_name = "Teshari tail wrap"
	path = /obj/item/clothing/accessory/teshtail/wrap
	sort_category = "Xenowear"
	whitelisted = SPECIES_TESHARI

/datum/gear/accessory/teshtailwrap/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/teshtailwrapalt
	display_name = "Teshari tail wrap, alt"
	path = /obj/item/clothing/accessory/teshtail/wrap/alt
	sort_category = "Xenowear"
	whitelisted = SPECIES_TESHARI

/datum/gear/accessory/teshtailwrapalt/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/teshtailwraplong
	display_name = "Teshari tail wrap, long"
	path = /obj/item/clothing/accessory/teshtail/wrap/long
	sort_category = "Xenowear"
	whitelisted = SPECIES_TESHARI

/datum/gear/accessory/teshtailwraplong/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/teshtailbells
	display_name = "Teshari tail bells"
	path = /obj/item/clothing/accessory/teshtail/bells
	sort_category = "Xenowear"
	whitelisted = SPECIES_TESHARI

/datum/gear/accessory/teshbangle
	display_name = "Teshari tail bangle, base"
	path = /obj/item/clothing/accessory/teshtail/bangle
	sort_category = "Xenowear"
	whitelisted = SPECIES_TESHARI
	cost = 0 //for these, so you can select all three or mix and match without taking three points.

/datum/gear/accessory/teshbangle/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/teshbangle2
	display_name = "Teshari tail bangle, middle"
	path = /obj/item/clothing/accessory/teshtail/bangle/middle
	sort_category = "Xenowear"
	whitelisted = SPECIES_TESHARI
	cost = 0

/datum/gear/accessory/teshbangle2/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/teshbangle3
	display_name = "Teshari tail bangle, end"
	path = /obj/item/clothing/accessory/teshtail/bangle/end
	sort_category = "Xenowear"
	whitelisted = SPECIES_TESHARI
	cost = 0

/datum/gear/accessory/teshbangle3/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/teshplume
	display_name = "Teshari artifical tailplume"
	path = /obj/item/clothing/accessory/teshtail/plumage
	sort_category = "Xenowear"
	whitelisted = SPECIES_TESHARI

/datum/gear/accessory/teshplume/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/teshchains
	display_name = "Teshari tail chains"
	path = /obj/item/clothing/accessory/teshtail/chains
	sort_category = "Xenowear"
	whitelisted = SPECIES_TESHARI

/datum/gear/accessory/teshchains/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/teshchainslong
	display_name = "Teshari tail chains, long"
	path = /obj/item/clothing/accessory/teshtail/chains/long
	sort_category = "Xenowear"
	whitelisted = SPECIES_TESHARI

/datum/gear/accessory/teshchainslong/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/teshchainsdangle
	display_name = "Teshari tail chains, dangling"
	path = /obj/item/clothing/accessory/teshtail/chains/dangle
	sort_category = "Xenowear"
	whitelisted = SPECIES_TESHARI

/datum/gear/accessory/teshchainsdangle/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/teshchainslongdangle
	display_name = "Teshari tail chains, long and dangling"
	path = /obj/item/clothing/accessory/teshtail/chains/longdangle
	sort_category = "Xenowear"
	whitelisted = SPECIES_TESHARI

/datum/gear/accessory/teshchainslongdangle/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice