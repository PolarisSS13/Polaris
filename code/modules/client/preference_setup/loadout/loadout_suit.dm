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
	description = "A selection of jackets styled on early aviation gear."
	path = /obj/item/clothing/suit/storage/toggle/bomber
	cost = 2

/datum/gear/suit/bomber/New()
	..()
	var/list/bombertype = list(
	"bomber jacket" = /obj/item/clothing/suit/storage/toggle/bomber,
	"bomber jacket, alternate" = /obj/item/clothing/suit/storage/bomber/alt,
	"bomber jacket, retro" = /obj/item/clothing/suit/storage/toggle/bomber/retro
	)
	gear_tweaks += new/datum/gear_tweak/path(bombertype)

/datum/gear/suit/leather_jacket
	display_name = "jacket, leather selection"
	description = "A selection of leather jackets in various styles."
	path = /obj/item/clothing/suit/storage/toggle/leather_jacket

/datum/gear/suit/leather_jacket/New()
	..()
	var/ljtype = list(
	"leather jacket, black" = /obj/item/clothing/suit/storage/toggle/leather_jacket,
	"leather jacket, alternate black" = /obj/item/clothing/suit/storage/leather_jacket_alt,
	"leather jacket, corporate black" = /obj/item/clothing/suit/storage/toggle/leather_jacket/nanotrasen,
	"leather jacket, brown" = /obj/item/clothing/suit/storage/toggle/brown_jacket,
	"leather jacket, corporate brown" = /obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen
	)
	gear_tweaks += new/datum/gear_tweak/path(ljtype)

/datum/gear/suit/leather_vest
	display_name = "jacket, leather vest selection"
	description = "A selection of sleeveless leather jackets in various styles."
	path = /obj/item/clothing/suit/storage/toggle/leather_jacket/sleeveless

/datum/gear/suit/leather_vest/New()
	..()
	var/list/lvtype = list(
	"leather vest, black" = /obj/item/clothing/suit/storage/toggle/leather_jacket/sleeveless,
	"leather vest, corporate black" = /obj/item/clothing/suit/storage/toggle/leather_jacket/nanotrasen/sleeveless,
	"leather vest, brown" = /obj/item/clothing/suit/storage/toggle/brown_jacket/sleeveless,
	"leather vest, corporate brown" = /obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen/sleeveless
	)
	gear_tweaks += new/datum/gear_tweak/path(lvtype)

/datum/gear/suit/mil
	display_name = "military jacket selection"
	description = "A selection of jackets resembling vintage military gear."
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
	description = "A selection of long raincoats."
	path = /obj/item/clothing/suit/storage/trench

/datum/gear/suit/trenchcoat/New()
	..()
	var/coattype = list(
	"trenchcoat, brown" = /obj/item/clothing/suit/storage/trench,
	"trenchcoat, grey" = /obj/item/clothing/suit/storage/trench/grey
	)
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
	display_name = "hoodie, baggy selection"
	description = "A selection of hooded sweatshirts, with non-functional hoods."
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
	description = "A selection of labcoats in standard, and non-standard colours."
	path = /obj/item/clothing/suit/storage/toggle/labcoat
	cost = 2

/datum/gear/suit/labcoat/New()
	..()
	var/list/labcoattype = list(
	"labcoat, white" = /obj/item/clothing/suit/storage/toggle/labcoat,
	"labcoat, blue" = /obj/item/clothing/suit/storage/toggle/labcoat/blue,
	"labcoat, blue-edged" = /obj/item/clothing/suit/storage/toggle/labcoat/blue_edge,
	"labcoat, green" = /obj/item/clothing/suit/storage/toggle/labcoat/green,
	"labcoat, orange" = /obj/item/clothing/suit/storage/toggle/labcoat/orange,
	"labcoat, pink" = /obj/item/clothing/suit/storage/toggle/labcoat/pink,
	"labcoat, purple" = /obj/item/clothing/suit/storage/toggle/labcoat/purple,
	"labcoat, red" = /obj/item/clothing/suit/storage/toggle/labcoat/red,
	"labcoat, yellow" = /obj/item/clothing/suit/storage/toggle/labcoat/yellow
	)
	gear_tweaks += new/datum/gear_tweak/path(labcoattype)

/datum/gear/suit/labcoat_rd
	display_name = "labcoat, research director (RD)"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/rd
	allowed_roles = list("Research Director")

/datum/gear/suit/labcoat_emt
	display_name = "labcoat, EMT (Medical)"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/emt
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist", "Psychiatrist")

/datum/gear/suit/plague_coat
	display_name = "plague doctor's coat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/plaguedoctor

/datum/gear/suit/surgical_apron
	display_name = "apron, surgical"
	path = /obj/item/clothing/suit/surgicalapron
	allowed_roles = list("Medical Doctor","Chief Medical Officer")
	cost = 1

/datum/gear/suit/overalls
	display_name = "overalls"
	path = /obj/item/clothing/suit/storage/apron/overalls

/datum/gear/suit/poncho
	display_name = "poncho selection"
	description = "A selection of ponchos in basic and departmental colours."
	path = /obj/item/clothing/accessory/storage/poncho

/datum/gear/suit/poncho/New()
	..()
	var/list/ponchos = list()
	for(var/poncho_style in (typesof(/obj/item/clothing/accessory/storage/poncho) - typesof(/obj/item/clothing/accessory/storage/poncho/roles/cloak)))
		var/obj/item/clothing/accessory/storage/poncho/poncho = poncho_style
		ponchos[initial(poncho.name)] = poncho
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(ponchos))

/datum/gear/suit/cloak_department
	display_name = "cloak, departmental selection"
	description = "A selection of cloaks and capelets in departmental colours."
	path = /obj/item/clothing/accessory/storage/poncho/roles/cloak/cargo

/datum/gear/suit/cloak_department/New()
	..()
	var/list/cloaks = list()
	for(var/cloak_style in (typesof(/obj/item/clothing/accessory/storage/poncho/roles/cloak)))
		var/obj/item/clothing/accessory/storage/poncho/roles/cloak/cloak = cloak_style
		cloaks[initial(cloak.name)] = cloak
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/cloak_custom //A colorable cloak
	display_name = "cloak (colorable)"
	path = /obj/item/clothing/accessory/storage/poncho/roles/cloak/custom

/datum/gear/suit/cloak_custom/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/cloak_chaplain
	display_name = "cloak, ceremonial selection"
	description = "A selection of cloaks typically worn in ceremonial contexts."
	path = /obj/item/clothing/accessory/storage/poncho/roles/cloak/ceremonial

/datum/gear/suit/cloak_chaplain/New()
	..()
	var/list/coattype = list(
	"cloak, Pleromanist" = /obj/item/clothing/accessory/storage/poncho/roles/cloak/chapel,
	"cloak, Unitarian" = /obj/item/clothing/accessory/storage/poncho/roles/cloak/chapel/alt,
	"cloak, ceremonial" = /obj/item/clothing/accessory/storage/poncho/roles/cloak/ceremonial
	)
	gear_tweaks += new/datum/gear_tweak/path(coattype)

//Shoulder cloak
/datum/gear/suit/cloak_shoulder
	display_name = "cloak, left shoulder (colorable)"
	path = /obj/item/clothing/accessory/storage/poncho/roles/cloak/shoulder

/datum/gear/suit/cloak_shoulder/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/cloak_shoulder_right
	display_name = "cloak, right shoulder (colorable)"
	path = /obj/item/clothing/accessory/storage/poncho/roles/cloak/shoulder/right

/datum/gear/suit/cloak_shoulder_right/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/capelet
	display_name = "cloak, capelet (colorable)"
	path = /obj/item/clothing/accessory/storage/poncho/roles/cloak/capelet

/datum/gear/suit/capelet/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/roughcloak
	display_name = "cloak, rough halfcloak (colorable)"
	path = /obj/item/clothing/accessory/storage/poncho/roles/cloak/half

/datum/gear/suit/roughcloak/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/unathi_robe
	display_name = "roughspun robe"
	path = /obj/item/clothing/suit/unathi/robe

/datum/gear/suit/suit_jackets
	display_name = "jacket, suit selection"
	description = "A selection of stylish suit jackets."
	path = /obj/item/clothing/suit/storage/toggle/internalaffairs

/datum/gear/suit/suit_jackets/New()
	..()
	var/list/jackettype = list(
	"suit jacket, black" = /obj/item/clothing/suit/storage/toggle/internalaffairs,
	"suit jacket, blue" = /obj/item/clothing/suit/storage/toggle/lawyer/bluejacket,
	"suit jacket, purple" = /obj/item/clothing/suit/storage/toggle/lawyer/purpjacket
	)
	gear_tweaks += new/datum/gear_tweak/path(jackettype)

/datum/gear/suit/suspenders
	display_name = "suspenders"
	path = /obj/item/clothing/suit/suspenders

/datum/gear/suit/forensics
	display_name = "jacket, forensics selection (Detective)"
	description = "A selection of windbreakers in security colours."
	path = /obj/item/clothing/suit/storage/forensics/red/long
	allowed_roles = list("Detective")

/datum/gear/suit/forensics/New()
	..()
	var/list/jackettype = list(
	"forensics jacket, red long" = /obj/item/clothing/suit/storage/forensics/red/long,
	"forensics jacket, red short" = /obj/item/clothing/suit/storage/forensics/red,
	"forensics jacket, blue long" = /obj/item/clothing/suit/storage/forensics/blue/long,
	"forensics jacket, blue short" = /obj/item/clothing/suit/storage/forensics/blue
	)
	gear_tweaks += new/datum/gear_tweak/path(jackettype)

/datum/gear/suit/wintercoat
	display_name = "winter coat selection"
	description = "A selection of heavy winter coats to keep you toasty in extreme weather."
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
	description = "A selection of two-tone cotton jackets."
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
	description = "A selection of lightweight sports jackets."
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
	description = "A selection of comfortable plaid shirts."
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
	description = "A selection of denim jackets in a variety of styles."
	path = /obj/item/clothing/suit/storage/toggle/denim_jacket

/datum/gear/suit/denim_jacket/New()
	..()
	var/list/denim_jackets = list()
	for(var/denim_jacket_style in typesof(/obj/item/clothing/suit/storage/toggle/denim_jacket))
		var/obj/item/clothing/suit/storage/toggle/denim_jacket/denim_jacket = denim_jacket_style
		denim_jackets[initial(denim_jacket.name)] = denim_jacket
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(denim_jackets))

/datum/gear/suit/kimono
	display_name = "kimono"
	path = /obj/item/clothing/suit/kimono

/datum/gear/suit/kimono/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/dep_jacket
	display_name = "jacket, departmental selection"
	description = "A selection of light jackets in departmental colours."
	path = /obj/item/clothing/suit/storage/toggle/sec_dep_jacket

/datum/gear/suit/dep_jacket/New()
	..()
	var/list/jackettype = list(
	"department jacket, engineering" = /obj/item/clothing/suit/storage/toggle/engi_dep_jacket,
	"department jacket, medical" = /obj/item/clothing/suit/storage/toggle/med_dep_jacket,
	"department jacket, security" = /obj/item/clothing/suit/storage/toggle/sec_dep_jacket,
	"department jacket, science" = /obj/item/clothing/suit/storage/toggle/sci_dep_jacket,
	"department jacket, supply" = /obj/item/clothing/suit/storage/toggle/supply_dep_jacket
	)
	gear_tweaks += new/datum/gear_tweak/path(jackettype)

/datum/gear/suit/light_jacket
	display_name = "jacket, light selection"
	description = "A selection of lightweight outdoor jackets."
	path = /obj/item/clothing/suit/storage/toggle/light_jacket

/datum/gear/suit/light_jacket/New()
	..()
	var/list/jacket = list(
	"grey light jacket" = /obj/item/clothing/suit/storage/toggle/light_jacket,
	"dark blue light jacket" = /obj/item/clothing/suit/storage/toggle/light_jacket/blue
	)
	gear_tweaks += new/datum/gear_tweak/path(jacket)

/datum/gear/suit/peacoat
	display_name = "peacoat (colorable)"
	path = /obj/item/clothing/suit/storage/toggle/peacoat

/datum/gear/suit/peacoat/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/kamishimo
	display_name = "kamishimo"
	path = /obj/item/clothing/suit/kamishimo

/datum/gear/suit/insulated
	display_name = "jacket, insulated selection"
	description = "A selection of jackets made to keep you nice and toasty on cold winter days. Or at least alive."
	path = /obj/item/clothing/suit/storage/insulated
	cost = 2

/datum/gear/suit/insulated/New()
	..()
	var/list/insulated_jackets = list()
	for(var/insulated_jacket_style in typesof(/obj/item/clothing/suit/storage/insulated))
		var/obj/item/clothing/suit/storage/insulated/insulated_jacket = insulated_jacket_style
		insulated_jackets[initial(insulated_jacket.name)] = insulated_jacket
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(insulated_jackets))

/datum/gear/suit/cardigan
	display_name = "cardigan (colorable)"
	path = /obj/item/clothing/suit/storage/toggle/cardigan

/datum/gear/suit/cardigan/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/costumes
	display_name = "costume overclothing selection"
	description = "A selection of fancy-dress costumes worn on the suit slot."
	path = /obj/item/clothing/suit/costume

/datum/gear/suit/costumes/New()
	..()
	var/list/costumes = list()
	for(var/costume in typesof(/obj/item/clothing/suit/costume))
		var/obj/item/clothing/suit/costume/costume_type = costume
		costumes[initial(costume_type.name)] = costume_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(costumes))

/datum/gear/suit/choodies
	display_name = "hoodie selection (colorable)"
	description = "A selection of hoodies with functional hoods."
	path = /obj/item/clothing/suit/storage/hooded/toggle/colorable

/datum/gear/suit/choodies/New()
	..()
	var/list/choodies = list(
	"normal hoodie" = /obj/item/clothing/suit/storage/hooded/toggle/colorable,
	"sleeveless hoodie" = /obj/item/clothing/suit/storage/hooded/toggle/colorable/sleeveless,
	"cropped hoodie" = /obj/item/clothing/suit/storage/hooded/toggle/colorable/cropped
	)
	gear_tweaks += gear_tweak_free_color_choice
	gear_tweaks += new/datum/gear_tweak/path(choodies)
