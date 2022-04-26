/datum/robolimb
	var/includes_tail			//Cyberlimbs dmi includes a tail sprite to wear.
	var/includes_wing			//Cyberlimbs dmi includes a wing sprite to wear.
	var/list/whitelisted_to		//List of ckeys that are allowed to pick this in charsetup.

//////////////// For-specific-character fluff ones ///////////////// May be viable to place these into a custom_item subfolder, in order to allow CI Repo integration.

// verkister : Rahwoof Boop
/datum/robolimb/eggnerdltd
	company = "Uesseka Prototyping Ltd."
	desc = "This limb seems meticulously hand-crafted, and distinctly Unathi in design."
	icon = 'icons/mob/human_races/cyberlimbs/_fluff_vr/rahboop.dmi'
	species_cannot_use = list(SPECIES_TESHARI, SPECIES_PROMETHEAN, SPECIES_DIONA, SPECIES_HUMAN, SPECIES_VOX, SPECIES_HUMAN_VATBORN, SPECIES_TAJ, SPECIES_SKRELL, SPECIES_ZADDAT)
	species_alternates = list(SPECIES_HUMAN = "NanoTrasen")
	suggested_species = SPECIES_UNATHI
	blood_color = "#5e280d"
	includes_tail = 1
	unavailable_to_build = 1

/obj/item/disk/limb/uesseka
	company = "Uesseka Prototyping Ltd."

/datum/robolimb/nanotrasen_metro
	company = "NanoTrasen - Metro"
	desc = "This metallic limb is sleek and featuresless apart from some exposed motors around the joints."
	icon = 'icons/mob/human_races/cyberlimbs/talon/talon_main.dmi' //Sprited by: Viveret

/obj/item/disk/limb/nanotrasen_metro
	company = "NanoTrasen - Metro"
	catalogue_data = list(/datum/category_item/catalogue/information/organization/nanotrasen)


/datum/robolimb/zenghu_taj
	company = "Zeng-Hu - Tajaran"
	desc = "This limb has a rubbery covering with basic faux fur and visible seams."
	icon = 'icons/mob/human_races/cyberlimbs/zenghu/zenghu_taj.dmi'
	species_cannot_use = list(SPECIES_TESHARI, SPECIES_PROMETHEAN, SPECIES_DIONA, SPECIES_HUMAN, SPECIES_VOX, SPECIES_HUMAN_VATBORN, SPECIES_UNATHI, SPECIES_SKRELL, SPECIES_ZADDAT)
	suggested_species = SPECIES_TAJ
	unavailable_to_build = 1
	parts = list(BP_HEAD)

/datum/robolimb/uessekared
	company = "Uesseka Prototyping Ltd. - Red"
	desc = "This limb seems meticulously hand-crafted, and distinctly Unathi in design. This one's red!"
	icon = 'icons/mob/human_races/cyberlimbs/rahboopred/rahboopred.dmi'
	species_cannot_use = list(SPECIES_TESHARI, SPECIES_PROMETHEAN, SPECIES_DIONA, SPECIES_HUMAN, SPECIES_VOX, SPECIES_HUMAN_VATBORN, SPECIES_TAJ, SPECIES_SKRELL, SPECIES_ZADDAT)
	species_alternates = list(SPECIES_HUMAN = "NanoTrasen")
	suggested_species = SPECIES_UNATHI
	blood_color = "#5e280d"
	includes_tail = 1
	unavailable_to_build = 1

/obj/item/disk/limb/uessekared
	company = "Uesseka Prototyping Ltd. (Red)"

//Downstream realistic-fluffies for adminbus:

/datum/robolimb/dsi_tajaran
	company = "DSI - Tajaran"
	desc = "This limb feels soft and fluffy, realistic design and squish. By Darkside Incorperated."
	icon = 'icons/mob/human_races/cyberlimbs/DSITajaran/dsi_tajaran.dmi'
	blood_color = "#ffe2ff"
	lifelike = 1
	unavailable_to_build = 1
	includes_tail = 1
	skin_tone = 1
	suggested_species = "Tajara"

/datum/robolimb/dsi_tajaran/New()
	species_cannot_use = GLOB.all_species.Copy()
//	species_cannot_use -= SPECIES_TAJ

/obj/item/disk/limb/dsi_tajaran
	company = "DSI - Tajaran"

/datum/robolimb/dsi_lizard
	company = "DSI - Lizard"
	desc = "This limb feels smooth and scalie, realistic design and squish. By Darkside Incorperated."
	icon = 'icons/mob/human_races/cyberlimbs/DSILizard/dsi_lizard.dmi'
	blood_color = "#ffe2ff"
	lifelike = 1
	unavailable_to_build = 1
	includes_tail = 1
	skin_tone = 1
	suggested_species = "Unathi"

/datum/robolimb/dsi_lizard/New()
	species_cannot_use = GLOB.all_species.Copy()
//	species_cannot_use -= SPECIES_UNATHI

/obj/item/disk/limb/dsi_lizard
	company = "DSI - Lizard"
/*
/datum/robolimb/dsi_sergal
	company = "DSI - Sergal"
	desc = "This limb feels soft and fluffy, realistic design and toned muscle. By Darkside Incorperated."
	icon = 'icons/mob/human_races/cyberlimbs/DSISergal/dsi_sergal.dmi'
	blood_color = "#ffe2ff"
	lifelike = 1
	unavailable_to_build = 1
	includes_tail = 1
	skin_tone = 1
	suggested_species = "Sergal"

/obj/item/disk/limb/dsi_sergal
	company = "DSI - Sergal"

/datum/robolimb/dsi_nevrean
	company = "DSI - Nevrean"
	desc = "This limb feels soft and feathery, lightweight, realistic design and squish. By Darkside Incorperated."
	icon = 'icons/mob/human_races/cyberlimbs/DSINevrean/dsi_nevrean.dmi'
	blood_color = "#ffe2ff"
	lifelike = 1
	unavailable_to_build = 1
	includes_tail = 1
	skin_tone = 1
	suggested_species = "Nevrean"

/obj/item/disk/limb/dsi_nevrean
	company = "DSI - Nevrean"

/datum/robolimb/dsi_vulpkanin
	company = "DSI - Vulpkanin"
	desc = "This limb feels soft and fluffy, realistic design and squish. Seems a little mischievous. By Darkside Incorperated."
	icon = 'icons/mob/human_races/cyberlimbs/DSIVulpkanin/dsi_vulpkanin.dmi'
	blood_color = "#ffe2ff"
	lifelike = 1
	unavailable_to_build = 1
	includes_tail = 1
	skin_tone = 1
	suggested_species = "Vulpkanin"

/obj/item/disk/limb/dsi_vulpkanin
	company = "DSI - Vulpkanin"

/datum/robolimb/dsi_akula
	company = "DSI - Akula"
	desc = "This limb feels soft and fleshy, realistic design and squish. Seems a little mischievous. By Darkside Incorperated."
	icon = 'icons/mob/human_races/cyberlimbs/DSIAkula/dsi_akula.dmi'
	blood_color = "#ffe2ff"
	lifelike = 1
	unavailable_to_build = 1
	includes_tail = 1
	skin_tone = 1
	suggested_species = "Akula"

/obj/item/disk/limb/dsi_akula
	company = "DSI - Akula"

/datum/robolimb/dsi_spider
	company = "DSI - Vasilissan"
	desc = "This limb feels hard and chitinous, realistic design. Seems a little mischievous. By Darkside Incorperated."
	icon = 'icons/mob/human_races/cyberlimbs/DSISpider/dsi_spider.dmi'
	blood_color = "#ffe2ff"
	lifelike = 1
	unavailable_to_build = 1
	includes_tail = 1
	skin_tone = 1
	suggested_species = "Vasilissan"

/obj/item/disk/limb/dsi_spider
	company = "DSI - Vasilissan"
*/
/datum/robolimb/dsi_teshari
	company = "DSI - Teshari"
	desc = "This limb has a thin synthflesh casing with a few connection ports."
	icon = 'icons/mob/human_races/cyberlimbs/DSITeshari/dsi_teshari.dmi'
	lifelike = 1
	skin_tone = 1
	suggested_species = SPECIES_TESHARI

/datum/robolimb/dsi_teshari/New()
	species_cannot_use = GLOB.all_species.Copy()
//	species_cannot_use -= SPECIES_TESHARI
//	species_cannot_use -= SPECIES_CUSTOM
	..()

/obj/item/disk/limb/dsi_teshari
	company = "DSI - Teshari"
