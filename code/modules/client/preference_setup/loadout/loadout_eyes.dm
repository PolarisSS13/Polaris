// Eyes
/datum/gear/eyes
	display_name = "eyepatch"
	path = /obj/item/clothing/glasses/eyepatch
	slot = slot_glasses
	sort_category = "Glasses and Eyewear"

/datum/gear/eyes/glasses
	display_name = "Glasses, prescription"
	path = /obj/item/clothing/glasses/regular

/datum/gear/eyes/glasses/green
	display_name = "Glasses, green"
	path = /obj/item/clothing/glasses/gglasses

/datum/gear/eyes/glasses/prescriptionhipster
	display_name = "Glasses, hipster"
	path = /obj/item/clothing/glasses/regular/hipster

/datum/gear/eyes/glasses/monocle
	display_name = "Monocle"
	path = /obj/item/clothing/glasses/monocle

/datum/gear/eyes/scanning_goggles
	display_name = "scanning goggles"
	path = /obj/item/clothing/glasses/regular/scanners

/datum/gear/eyes/sciencegoggles
	display_name = "Science Goggles"
	path = /obj/item/clothing/glasses/science

/datum/gear/eyes/security
	display_name = "Security HUD (Security)"
	path = /obj/item/clothing/glasses/hud/security
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/eyes/security/prescriptionsec
	display_name = "Security HUD, prescription (Security)"
	path = /obj/item/clothing/glasses/hud/security/prescription

/datum/gear/eyes/security/sunglasshud
	display_name = "Security HUD, sunglasses (Security)"
	path = /obj/item/clothing/glasses/sunglasses/sechud

/datum/gear/eyes/secaviators
	display_name = "Security HUD Aviators"
	path = /obj/item/clothing/glasses/sunglasses/sechud/aviator
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/eyes/secaviators/prescription
	display_name = "Security HUD Aviators, prescription"
	path = /obj/item/clothing/glasses/sunglasses/sechud/aviator/prescription

/datum/gear/eyes/medical
	display_name = "Medical HUD (Medical)"
	path = /obj/item/clothing/glasses/hud/health
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist")

/datum/gear/eyes/medical/prescriptionmed
	display_name = "Medical HUD, prescription (Medical)"
	path = /obj/item/clothing/glasses/hud/health/prescription

/datum/gear/eyes/shades
	display_name = "Sunglasses, fat"
	path = /obj/item/clothing/glasses/sunglasses/big

/datum/gear/eyes/glasses/sunglasses
	display_name = "Sunglasses"
	path = /obj/item/clothing/glasses/sunglasses

/datum/gear/eyes/glasses/aviator
	display_name = "Aviators"
	path = /obj/item/clothing/glasses/sunglasses/aviator

/datum/gear/eyes/shades/prescriptionsun
	display_name = "Sunglasses, presciption"
	path = /obj/item/clothing/glasses/sunglasses/prescription
