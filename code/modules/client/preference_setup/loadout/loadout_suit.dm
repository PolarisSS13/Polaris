// Suit slot
/datum/gear/suit
	display_name = "apron, blue"
	path = /obj/item/clothing/suit/storage/apron
	slot = slot_wear_suit
	sort_category = "Suits and Overwear"
	cost = 1

/datum/gear/suit/apron_white
	display_name = "apron, colorable"
	path = /obj/item/clothing/suit/storage/apron/white

/datum/gear/suit/apron_white/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/greatcoat
	display_name = "greatcoat"
	path = /obj/item/clothing/suit/greatcoat

/datum/gear/suit/leather_coat
	display_name = "leather coat"
	path = /obj/item/clothing/suit/leathercoat

/datum/gear/suit/puffer_coat
	display_name = "puffer coat"
	path = /obj/item/clothing/suit/jacket/puffer
	cost = 2

/datum/gear/suit/puffer_vest
	display_name = "puffer vest"
	path = /obj/item/clothing/suit/jacket/puffer/vest
	cost = 2

/datum/gear/suit/bomber
	display_name = "jacket, bomber selection"
	path = /obj/item/clothing/suit/storage/toggle/bomber
	cost = 2

/datum/gear/suit/bomber/New()
	..()
	var/bombertype = list()
	bombertype["bomber jacket"] = /obj/item/clothing/suit/storage/toggle/bomber
	bombertype["bomber jacket, alternate"] = /obj/item/clothing/suit/storage/bomber/alt
	bombertype["bomber jacket, retro"] = /obj/item/clothing/suit/storage/toggle/bomber/retro
	gear_tweaks += new/datum/gear_tweak/path(bombertype)

/datum/gear/suit/leather_jacket
	display_name = "jacket, leather selection"
	path = /obj/item/clothing/suit/storage/toggle/leather_jacket

/datum/gear/suit/leather_jacket/New()
	..()
	var/ljtype = list()
	ljtype["leather jacket, black"] = /obj/item/clothing/suit/storage/toggle/leather_jacket
	ljtype["leather jacket, alternate black"] = /obj/item/clothing/suit/storage/leather_jacket_alt
	ljtype["leather jacket, corporate black"] = /obj/item/clothing/suit/storage/toggle/leather_jacket/nanotrasen
	ljtype["leather jacket, brown"] = /obj/item/clothing/suit/storage/toggle/brown_jacket
	ljtype["leather jacket, corporate brown"] = /obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen
	gear_tweaks += new/datum/gear_tweak/path(ljtype)

/datum/gear/suit/leather_vest
	display_name = "jacket, leather vest selection"
	path = /obj/item/clothing/suit/storage/toggle/leather_jacket/sleeveless

/datum/gear/suit/leather_vest/New()
	..()
	var/lvtype = list()
	lvtype["leather vest, black"] = /obj/item/clothing/suit/storage/toggle/leather_jacket/sleeveless
	lvtype["leather vest, corporate black"] = /obj/item/clothing/suit/storage/toggle/leather_jacket/nanotrasen/sleeveless
	lvtype["leather vest, brown"] = /obj/item/clothing/suit/storage/toggle/brown_jacket/sleeveless
	lvtype["leather vest, corporate brown"] = /obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen/sleeveless
	gear_tweaks += new/datum/gear_tweak/path(lvtype)

/datum/gear/suit/mil
	display_name = "military jacket selection"
	path = /obj/item/clothing/suit/storage/miljacket

/datum/gear/suit/mil/New()
	..()
	var/list/mil_jackets = list()
	for(var/military_style in typesof(/obj/item/clothing/suit/storage/miljacket))
		var/obj/item/clothing/suit/storage/miljacket/miljacket = military_style
		mil_jackets[initial(miljacket.name)] = miljacket
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(mil_jackets))

/datum/gear/suit/greyjacket
	display_name = "jacket, grey"
	path = /obj/item/clothing/suit/storage/greyjacket

/datum/gear/suit/trenchcoat
	display_name = "trenchcoat selection"
	path = /obj/item/clothing/suit/storage/trench

/datum/gear/suit/trenchcoat/New()
	..()
	var/coattype = list()
	coattype["trenchcoat, brown"] = /obj/item/clothing/suit/storage/trench
	coattype["trenchcoat, grey"] = /obj/item/clothing/suit/storage/trench/grey
	gear_tweaks += new/datum/gear_tweak/path(coattype)

/datum/gear/suit/duster
	display_name = "cowboy duster (colorable)"
	path = /obj/item/clothing/suit/storage/duster

/datum/gear/suit/duster/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/hazard_vest
	display_name = "hazard vest selection"
	path = /obj/item/clothing/suit/storage/hazardvest

/datum/gear/suit/hazard_vest/New()
	..()
	var/list/hazards = list()
	for(var/hazard_style in typesof(/obj/item/clothing/suit/storage/hazardvest))
		var/obj/item/clothing/suit/storage/hazardvest/hazardvest = hazard_style
		hazards[initial(hazardvest.name)] = hazardvest
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(hazards))

/datum/gear/suit/hoodie
	display_name = "hoodie selection"
	path = /obj/item/clothing/suit/storage/toggle/hoodie
	cost = 2

/datum/gear/suit/hoodie/New()
	..()
	var/list/hoodies = list()
	for(var/hoodie_style in typesof(/obj/item/clothing/suit/storage/toggle/hoodie))
		var/obj/item/clothing/suit/storage/toggle/hoodie/hoodie = hoodie_style
		hoodies[initial(hoodie.name)] = hoodie
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(hoodies))

/datum/gear/suit/labcoat
	display_name = "labcoat, colored selection"
	path = /obj/item/clothing/suit/storage/toggle/labcoat
	cost = 2

/datum/gear/suit/labcoat/New()
	..()
	var/labcoattype = list()
	labcoattype["labcoat, white"] = /obj/item/clothing/suit/storage/toggle/labcoat
	labcoattype["labcoat, blue"] = /obj/item/clothing/suit/storage/toggle/labcoat/blue
	labcoattype["labcoat, blue-edged"] = /obj/item/clothing/suit/storage/toggle/labcoat/blue_edge
	labcoattype["labcoat, green"] = /obj/item/clothing/suit/storage/toggle/labcoat/green
	labcoattype["labcoat, orange"] = /obj/item/clothing/suit/storage/toggle/labcoat/orange
	labcoattype["labcoat, pink"] = /obj/item/clothing/suit/storage/toggle/labcoat/pink
	labcoattype["labcoat, purple"] = /obj/item/clothing/suit/storage/toggle/labcoat/purple
	labcoattype["labcoat, red"] = /obj/item/clothing/suit/storage/toggle/labcoat/red
	labcoattype["labcoat, yellow"] = /obj/item/clothing/suit/storage/toggle/labcoat/yellow
	gear_tweaks += new/datum/gear_tweak/path(labcoattype)

/datum/gear/suit/labcoat/rd
	display_name = "labcoat, research director (RD)"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/rd
	allowed_roles = list("Research Director")

/datum/gear/suit/labcoat/emt
	display_name = "labcoat, EMT (Medical)"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/emt
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist", "Psychiatrist")

/datum/gear/suit/miscellaneous/labcoat
	display_name = "plague doctor's coat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/plaguedoctor

/datum/gear/suit/roles/surgical_apron
	display_name = "apron, surgical"
	path = /obj/item/clothing/suit/surgicalapron
	allowed_roles = list("Medical Doctor","Chief Medical Officer")
	cost = 1

/datum/gear/suit/overalls
	display_name = "overalls"
	path = /obj/item/clothing/suit/storage/apron/overalls

/datum/gear/suit/poncho
	display_name = "poncho selection"
	path = /obj/item/clothing/accessory/poncho

/datum/gear/suit/poncho/New()
	..()
	var/list/ponchos = list()
	for(var/poncho_style in (typesof(/obj/item/clothing/accessory/poncho) - typesof(/obj/item/clothing/accessory/poncho/roles/cloak)))
		var/obj/item/clothing/accessory/poncho/poncho = poncho_style
		ponchos[initial(poncho.name)] = poncho
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(ponchos))

/datum/gear/suit/roles/poncho/cloak
	display_name = "cloak, departmental selection"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/cargo

/datum/gear/suit/roles/poncho/cloak/New()
	..()
	var/list/cloaks = list()
	for(var/cloak_style in (typesof(/obj/item/clothing/accessory/poncho/roles/cloak)))
		var/obj/item/clothing/accessory/poncho/roles/cloak/cloak = cloak_style
		cloaks[initial(cloak.name)] = cloak
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/roles/poncho/cloak/custom //A colorable cloak
	display_name = "cloak (colorable)"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/custom

/datum/gear/suit/roles/poncho/cloak/custom/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/unathi_robe
	display_name = "roughspun robe"
	path = /obj/item/clothing/suit/unathi/robe

/datum/gear/suit/suit_jackets
	display_name = "suit jacket selection"
	path = /obj/item/clothing/suit/storage/toggle/internalaffairs

/datum/gear/suit/suit_jackets/New()
	..()
	var/jackettype = list()
	jackettype["suit jacket, black"] = /obj/item/clothing/suit/storage/toggle/internalaffairs
	jackettype["suit jacket, blue"] = /obj/item/clothing/suit/storage/toggle/lawyer/bluejacket
	jackettype["suit jacket, purple"] = /obj/item/clothing/suit/storage/toggle/lawyer/purpjacket
	gear_tweaks += new/datum/gear_tweak/path(jackettype)

/datum/gear/suit/suspenders
	display_name = "suspenders"
	path = /obj/item/clothing/suit/suspenders

/datum/gear/suit/forensics
	display_name = "jacket, forensics selection (Detective)"
	path = /obj/item/clothing/suit/storage/forensics/red/long
	allowed_roles = list("Detective")

/datum/gear/suit/forensics/New()
	..()
	var/jackettype = list()
	jackettype["forensics jacket, red long"] = /obj/item/clothing/suit/storage/forensics/red/long
	jackettype["forensics jacket, red short"] = /obj/item/clothing/suit/storage/forensics/red
	jackettype["forensics jacket, blue long"] = /obj/item/clothing/suit/storage/forensics/blue/long
	jackettype["forensics jacket, blue short"] = /obj/item/clothing/suit/storage/forensics/blue
	gear_tweaks += new/datum/gear_tweak/path(jackettype)

/datum/gear/suit/wintercoat
	display_name = "winter coat selection"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat
	cost = 2

/datum/gear/suit/wintercoat/New()
	..()
	var/list/wintercoats = list()
	for(var/wintercoat_style in (typesof(/obj/item/clothing/suit/storage/hooded/wintercoat)))
		var/obj/item/clothing/suit/storage/hooded/wintercoat/wintercoat = wintercoat_style
		wintercoats[initial(wintercoat.name)] = wintercoat
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(wintercoats))

/datum/gear/suit/varsity
	display_name = "jacket, varsity selection"
	path = /obj/item/clothing/suit/varsity

/datum/gear/suit/varsity/New()
	..()
	var/list/varsities = list()
	for(var/varsity_style in typesof(/obj/item/clothing/suit/varsity))
		var/obj/item/clothing/suit/varsity/varsity = varsity_style
		varsities[initial(varsity.name)] = varsity
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(varsities))

/datum/gear/suit/track
	display_name = "jacket, track selection"
	path = /obj/item/clothing/suit/storage/toggle/track

/datum/gear/suit/track/New()
	..()
	var/list/tracks = list()
	for(var/track_style in typesof(/obj/item/clothing/suit/storage/toggle/track))
		var/obj/item/clothing/suit/storage/toggle/track/track = track_style
		tracks[initial(track.name)] = track
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(tracks))

/datum/gear/suit/flannel
	display_name = "flannel selection"
	path = /obj/item/clothing/suit/storage/flannel

/datum/gear/suit/flannel/New()
	..()
	var/list/flannels = list()
	for(var/flannel_style in typesof(/obj/item/clothing/suit/storage/flannel))
		var/obj/item/clothing/suit/storage/flannel/flannel = flannel_style
		flannels[initial(flannel.name)] = flannel
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(flannels))

/datum/gear/suit/denim_jacket
	display_name = "jacket, denim selection"
	path = /obj/item/clothing/suit/storage/toggle/denim_jacket

/datum/gear/suit/denim_jacket/New()
	..()
	var/list/denim_jackets = list()
	for(var/denim_jacket_style in typesof(/obj/item/clothing/suit/storage/toggle/denim_jacket))
		var/obj/item/clothing/suit/storage/toggle/denim_jacket/denim_jacket = denim_jacket_style
		denim_jackets[initial(denim_jacket.name)] = denim_jacket
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(denim_jackets))

/datum/gear/suit/miscellaneous/kimono
	display_name = "kimono"
	path = /obj/item/clothing/suit/kimono

/datum/gear/suit/miscellaneous/kimono/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/miscellaneous/dep_jacket
	display_name = "jacket, departmental selection"
	path = /obj/item/clothing/suit/storage/toggle/sec_dep_jacket

/datum/gear/suit/miscellaneous/dep_jacket/New()
	..()
	var/jackettype = list()
	jackettype["department jacket, engineering"] = /obj/item/clothing/suit/storage/toggle/engi_dep_jacket
	jackettype["department jacket, medical"] = /obj/item/clothing/suit/storage/toggle/med_dep_jacket
	jackettype["department jacket, security"] = /obj/item/clothing/suit/storage/toggle/sec_dep_jacket
	jackettype["department jacket, science"] = /obj/item/clothing/suit/storage/toggle/sci_dep_jacket
	jackettype["department jacket, supply"] = /obj/item/clothing/suit/storage/toggle/supply_dep_jacket
	gear_tweaks += new/datum/gear_tweak/path(jackettype)

/datum/gear/suit/miscellaneous/light_jacket
	display_name = "jacket, light selection"
	path = /obj/item/clothing/suit/storage/toggle/light_jacket

/datum/gear/suit/miscellaneous/light_jacket/New()
	..()
	var/list/jacket = list(
		"grey light jacket" = /obj/item/clothing/suit/storage/toggle/light_jacket,
		"dark blue light jacket" = /obj/item/clothing/suit/storage/toggle/light_jacket/blue
	)
	gear_tweaks += new/datum/gear_tweak/path(jacket)

/datum/gear/suit/miscellaneous/peacoat
	display_name = "peacoat"
	path = /obj/item/clothing/suit/storage/toggle/peacoat

/datum/gear/suit/miscellaneous/peacoat/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/miscellaneous/kamishimo
	display_name = "kamishimo"
	path = /obj/item/clothing/suit/kamishimo

/datum/gear/suit/insulted
	display_name = "insulted jacket selection"
	path = /obj/item/clothing/suit/storage/insulated
	cost = 2

/datum/gear/suit/insulated/New()
	..()
	var/list/insulated_jackets = list()
	for(var/insulated_jacket_style in typesof(/obj/item/clothing/suit/storage/insulated))
		var/obj/item/clothing/suit/storage/insulated/insulated_jacket = insulated_jacket_style
		insulated_jackets[initial(insulated_jacket.name)] = insulated_jacket
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(insulated_jackets))

/datum/gear/suit/miscellaneous/cardigan
	display_name = "cardigan"
	path = /obj/item/clothing/suit/storage/toggle/cardigan

/datum/gear/suit/miscellaneous/cardigan/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice
