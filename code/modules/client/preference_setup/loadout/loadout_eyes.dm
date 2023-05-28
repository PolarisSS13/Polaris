// Eyes
/datum/gear/eyes
	display_name = "eyepatch"
	path = /obj/item/clothing/glasses/eyepatch
	slot = slot_glasses
	sort_category = "Glasses and Eyewear"

/datum/gear/eyes/eyepatchwhite
	display_name = "eyepatch (recolorable)"
	path = /obj/item/clothing/glasses/eyepatchwhite
	slot = slot_glasses
	sort_category = "Glasses and Eyewear"

/datum/gear/eyes/eyepatchwhite/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/eyes/blindfold
	display_name = "blindfold"
	path = /obj/item/clothing/glasses/sunglasses/blindfold

/datum/gear/eyes/whiteblindfold //I may have lost my sight, but at least these folks can see my RAINBOW BLINDFOLD
	display_name = "blindfold, white (recolorable)"
	path = /obj/item/clothing/glasses/sunglasses/blindfold/whiteblindfold

/datum/gear/eyes/whiteblindfold/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/eyes/thinblindfold
	display_name = "blindfold, thin white (recolorable)"
	path = /obj/item/clothing/glasses/sunglasses/thinblindfold

/datum/gear/eyes/thinblindfold/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/eyes/glasses
	display_name = "glasses, prescription selection"
	path = /obj/item/clothing/glasses/regular
	cost = 1

/datum/gear/eyes/glasses/New()
	..()
	var/list/glassestype = list(
	"prescription glasses, standard" = /obj/item/clothing/glasses/regular,
	"prescription glasses, hipster" = /obj/item/clothing/glasses/regular/hipster,
	"prescription glasses, rimless" = /obj/item/clothing/glasses/regular/rimless,
	"prescription glasses, thin frame" = /obj/item/clothing/glasses/regular/thin
	)
	gear_tweaks += new/datum/gear_tweak/path(glassestype)

/datum/gear/eyes/glassesfake
	display_name = "glasses, non-prescription selection"
	path = /obj/item/clothing/glasses/gglasses
	cost = 1

/datum/gear/eyes/glassesfake/New()
	..()
	var/list/glassestype = list(
	"glasses, green" = /obj/item/clothing/glasses/gglasses,
	"glasses, rimless" = /obj/item/clothing/glasses/rimless,
	"glasses, thin frame" = /obj/item/clothing/glasses/thin
	)
	gear_tweaks += new/datum/gear_tweak/path(glassestype)

/datum/gear/eyes/monocle
	display_name = "monocle"
	path = /obj/item/clothing/glasses/monocle

/datum/gear/eyes/goggles
	display_name = "goggles, plain"
	path = /obj/item/clothing/glasses/goggles

/datum/gear/eyes/goggles/scanning
	display_name = "goggles, scanning"
	path = /obj/item/clothing/glasses/regular/scanners

/datum/gear/eyes/goggles/science
	display_name = "goggles, science"
	path = /obj/item/clothing/glasses/science

/datum/gear/eyes/security
	display_name = "security HUD selection (Security)"
	path = /obj/item/clothing/glasses/hud/security
	allowed_roles = list("Security Officer","Head of Security","Warden", "Detective")

/datum/gear/eyes/security/New()
	..()
	var/list/hudtype = list(
	"security hud, standard" = /obj/item/clothing/glasses/hud/security,
	"security hud, standard prescription" = /obj/item/clothing/glasses/hud/security/prescription,
	"security hud, sunglasses" = /obj/item/clothing/glasses/sunglasses/sechud,
	"security hud, sunglasses prescription" = /obj/item/clothing/glasses/sunglasses/sechud/prescription,
	"security hud, aviators" = /obj/item/clothing/glasses/sunglasses/sechud/aviator,
	"security hud, aviators prescription" = /obj/item/clothing/glasses/sunglasses/sechud/aviator/prescription
	)
	gear_tweaks += new/datum/gear_tweak/path(hudtype)

/datum/gear/eyes/medical
	display_name = "medical HUD selection (Medical)"
	path = /obj/item/clothing/glasses/hud/health
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist", "Psychiatrist", "Search and Rescue")

/datum/gear/eyes/medical/New()
	..()
	var/list/huds = list()
	for(var/hud in typesof(/obj/item/clothing/glasses/hud/health))
		var/obj/item/clothing/glasses/hud/hud_type = hud
		huds[initial(hud_type.name)] = hud_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(huds))

/datum/gear/eyes/meson
	display_name = "optical meson scanners selection (Engineering, Science, Mining)"
	path = /obj/item/clothing/glasses/meson
	allowed_roles = list("Station Engineer","Chief Engineer","Atmospheric Technician", "Scientist", "Research Director", "Shaft Miner")

/datum/gear/eyes/meson/New()
	..()
	var/list/mesons = list()
	for(var/meson in typesof(/obj/item/clothing/glasses/meson))
		var/obj/item/clothing/glasses/meson_type = meson
		mesons[initial(meson_type.name)] = meson_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(mesons))

/datum/gear/eyes/material
	display_name = "optical material scanners (Mining)"
	path = /obj/item/clothing/glasses/material
	allowed_roles = list("Shaft Miner","Quartermaster")

/datum/gear/eyes/material/prescription
	display_name = "optical material scanners, prescription (Mining)"
	path = /obj/item/clothing/glasses/material/prescription

/datum/gear/eyes/fakesun
	display_name = "sunglasses, stylish"
	path = /obj/item/clothing/glasses/fakesunglasses

/datum/gear/eyes/fakeaviator
	display_name = "sunglasses, stylish aviators"
	path = /obj/item/clothing/glasses/fakesunglasses/aviator

/datum/gear/eyes/sun
	display_name = "sunglasses, protective selection (Security/Command)"
	path = /obj/item/clothing/glasses/sunglasses
	allowed_roles = list("Security Officer","Head of Security","Warden","Site Manager","Head of Personnel","Quartermaster","Internal Affairs Agent","Detective")

/datum/gear/eyes/sun/New()
	..()
	var/list/hudtype = list(
	"sunglasses, standard" = /obj/item/clothing/glasses/sunglasses,
	"sunglasses, big" = /obj/item/clothing/glasses/sunglasses/big,
	"sunglasses, aviators" = /obj/item/clothing/glasses/sunglasses/aviator,
	"sunglasses, prescription" = /obj/item/clothing/glasses/sunglasses/prescription
	)
	gear_tweaks += new/datum/gear_tweak/path(hudtype)

/datum/gear/eyes/circuitry
	display_name = "goggles, circuitry (empty)"
	path = /obj/item/clothing/glasses/circuitry
