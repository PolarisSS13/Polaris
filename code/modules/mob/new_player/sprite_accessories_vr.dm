////////////////////////
// For sergals and stuff
////////////////////////
// Note: Creating a sub-datum to group all vore stuff together
// would require us to exclude that datum from the global list.

/datum/sprite_accessory/hair

	//var/icon_add = 'icons/mob/human_face.dmi' //Already defined in sprite_accessories.dm line 49.
	var/color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/hair/astolfo
	name = "Astolfo"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "hair_astolfo"

/datum/sprite_accessory/hair/awoohair
	name = "Shoulder-length Messy"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "momijihair"

/datum/sprite_accessory/hair/citheronia
	name = "Citheronia Hair (Kira72)"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_state = "citheronia_hair"
	ckeys_allowed = list("Kira72")
	do_colouration = 0

/datum/sprite_accessory/hair/taramaw
	name = "Hairmaw (Liquidfirefly)"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_state = "maw_hair"
	ckeys_allowed = list("liquidfirefly")
	do_colouration = 0

/datum/sprite_accessory/hair/citheronia_colorable
	name = "Citheronia Hair"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "citheronia_hair_c"
	do_colouration = 1

/datum/sprite_accessory/hair/sergal_plain
	name = "Sergal Plain"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "serg_plain"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/sergal_medicore
	name = "Sergal Medicore"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "serg_medicore"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/sergal_tapered
	name = "Sergal Tapered"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "serg_tapered"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/sergal_fairytail
	name = "Sergal Fairytail"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "serg_fairytail"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/braid
	name = "Floorlength Braid"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "hair_braid"

/datum/sprite_accessory/hair/twindrills
	name = "Twin Drills"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "hair_twincurl"


/*
bald
	name = "Bald"
	icon_state = "bald"
	gender = MALE
	species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN)
*/
/datum/sprite_accessory/hair/ponytail6_fixed //Eggnerd's done with waiting for upstream fixes lmao.
	name = "Ponytail 6 but fixed"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "hair_ponytail6"
//		species_allowed = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_NEVREAN, SPECIES_AKULA,SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_XENOHYBRID, SPECIES_VASILISSAN, SPECIES_RAPALA, SPECIES_PROTEAN, SPECIES_ALRAUNE, SPECIES_WEREBEAST)

/datum/sprite_accessory/hair/una_hood
	name = "Cobra Hood"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "soghun_hood"
	species_allowed = list(SPECIES_UNATHI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/una_spines_long
	name = "Long Unathi Spines"
	icon_state = "soghun_longspines"
	species_allowed = list(SPECIES_UNATHI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/una_spines_short
	name = "Short Unathi Spines"
	icon_state = "soghun_shortspines"
	species_allowed = list(SPECIES_UNATHI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/una_frills_long
	name = "Long Unathi Frills"
	icon_state = "soghun_longfrills"
	species_allowed = list(SPECIES_UNATHI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/una_frills_short
	name = "Short Unathi Frills"
	icon_state = "soghun_shortfrills"
	species_allowed = list(SPECIES_UNATHI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/una_horns
	name = "Unathi Horns"
	icon_state = "soghun_horns"
	species_allowed = list(SPECIES_UNATHI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/una_bighorns
	name = "Unathi Big Horns"
	icon_state = "unathi_bighorn"
	species_allowed = list(SPECIES_UNATHI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/una_smallhorns
	name = "Unathi Small Horns"
	icon_state = "unathi_smallhorn"
	species_allowed = list(SPECIES_UNATHI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/una_ramhorns
	name = "Unathi Ram Horns"
	icon_state = "unathi_ramhorn"
	species_allowed = list(SPECIES_UNATHI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/una_sidefrills
	name = "Unathi Side Frills"
	icon_state = "unathi_sidefrills"
	species_allowed = list(SPECIES_UNATHI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/una_doublehorns
	name = "Double Unathi Horns"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "soghun_dubhorns"
	species_allowed = list(SPECIES_UNATHI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/taj_ears
	name = "Tajaran Ears"
	icon_state = "ears_plain"
	species_allowed = list(SPECIES_TAJ, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/taj_ears_clean
	name = "Tajara Clean"
	icon_state = "hair_clean"
	species_allowed = list(SPECIES_TAJ, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/taj_ears_bangs
	name = "Tajara Bangs"
	icon_state = "hair_bangs"
	species_allowed = list(SPECIES_TAJ, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/taj_ears_braid
	name = "Tajara Braid"
	icon_state = "hair_tbraid"
	species_allowed = list(SPECIES_TAJ, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/taj_ears_shaggy
	name = "Tajara Shaggy"
	icon_state = "hair_shaggy"
	species_allowed = list(SPECIES_TAJ, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/taj_ears_mohawk
	name = "Tajaran Mohawk"
	icon_state = "hair_mohawk"
	species_allowed = list(SPECIES_TAJ, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/taj_ears_plait
	name = "Tajara Plait"
	icon_state = "hair_plait"
	species_allowed = list(SPECIES_TAJ, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/taj_ears_straight
	name = "Tajara Straight"
	icon_state = "hair_straight"
	species_allowed = list(SPECIES_TAJ, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/taj_ears_long
	name = "Tajara Long"
	icon_state = "hair_long"
	species_allowed = list(SPECIES_TAJ, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/taj_ears_rattail
	name = "Tajara Rat Tail"
	icon_state = "hair_rattail"
	species_allowed = list(SPECIES_TAJ, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/taj_ears_spiky
	name = "Tajara Spiky"
	icon_state = "hair_tajspiky"
	species_allowed = list(SPECIES_TAJ, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/taj_ears_messy
	name = "Tajara Messy"
	icon_state = "hair_messy"
	species_allowed = list(SPECIES_TAJ, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/taj_ears_curls
	name = "Tajaran Curly"
	icon_state = "hair_curly"
	species_allowed = list(SPECIES_TAJ, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/taj_ears_wife
	name = "Tajaran Housewife"
	icon_state = "hair_wife"
	species_allowed = list(SPECIES_TAJ, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/taj_ears_victory
	name = "Tajaran Victory Curls"
	icon_state = "hair_victory"
	species_allowed = list(SPECIES_TAJ, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/taj_ears_bob
	name = "Tajaran Bob"
	icon_state = "hair_tbob"
	species_allowed = list(SPECIES_TAJ, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/taj_ears_fingercurl
	name = "Tajaran Finger Curls"
	icon_state = "hair_fingerwave"
	species_allowed = list(SPECIES_TAJ, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/teshari_fluffymohawk
	name = "Teshari Fluffy Mohawk"
	icon =  'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "teshari_fluffymohawk"
	species_allowed = list(SPECIES_TESHARI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
/*
//Teshari things
teshari
	icon_add = 'icons/mob/human_face_vr_add.dmi'

teshari_altdefault
	icon_add = 'icons/mob/human_face_vr_add.dmi'

teshari_tight
	icon_add = 'icons/mob/human_face_vr_add.dmi'

teshari_excited
	icon_add = 'icons/mob/human_face_vr_add.dmi'

teshari_spike
	icon_add = 'icons/mob/human_face_vr_add.dmi'

teshari_long
	icon_add = 'icons/mob/human_face_vr_add.dmi'

teshari_burst
	icon_add = 'icons/mob/human_face_vr_add.dmi'

teshari_shortburst
	icon_add = 'icons/mob/human_face_vr_add.dmi'

teshari_mohawk
	icon_add = 'icons/mob/human_face_vr_add.dmi'

teshari_pointy
	icon_add = 'icons/mob/human_face_vr_add.dmi'

teshari_upright
	icon_add = 'icons/mob/human_face_vr_add.dmi'

teshari_mane
	icon_add = 'icons/mob/human_face_vr_add.dmi'

teshari_droopy
	icon_add = 'icons/mob/human_face_vr_add.dmi'

teshari_mushroom
	icon_add = 'icons/mob/human_face_vr_add.dmi'
*/
//Skrell 'hairstyles' - these were requested for a chimera and screw it, if one wants to eat seafood, go nuts
/datum/sprite_accessory/hair/skr_tentacle_veryshort
	name = "Skrell Very Short Tentacles"
	icon_state = "skrell_hair_veryshort"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/skr_tentacle_short
	name = "Skrell Short Tentacles"
	icon_state = "skrell_hair_short"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/skr_tentacle_average
	name = "Skrell Average Tentacles"
	icon_state = "skrell_hair_average"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/hair/skr_tentacle_verylong
	name = "Skrell Long Tentacles"
	icon_state = "skrell_hair_verylong"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

// Vulpa stuffs

/datum/sprite_accessory/hair/vulp_hair_none
	name = "None"
	icon_state = "bald"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_kajam
	name = "Kajam"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "kajam"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_keid
	name = "Keid"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "keid"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_adhara
	name = "Adhara"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "adhara"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_kleeia
	name = "Kleeia"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "kleeia"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_mizar
	name = "Mizar"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "mizar"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_apollo
	name = "Apollo"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "apollo"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_belle
	name = "Belle"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "belle"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_bun
	name = "Vulp Bun"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "bun"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_jagged
	name = "Jagged"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "jagged"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_curl
	name = "Curl"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "curl"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_hawk
	name = "Hawk"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "hawk"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_anita
	name = "Anita"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "anita"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_short
	name = "Short"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "short"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp_hair_spike
	name = "Spike"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "spike"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

//xeno stuffs
/datum/sprite_accessory/hair/xeno_head_drone_color
	name = "Drone dome"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "cxeno_drone"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER
// figure this one out for better coloring
/datum/sprite_accessory/hair/xeno_head_sentinel_color
	name = "Sentinal dome"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "cxeno_sentinel"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/xeno_head_queen_color
	name = "Queen dome"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "cxeno_queen"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/xeno_head_hunter_color
	name = "Hunter dome"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "cxeno_hunter"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/xeno_head_praetorian_color
	name = "Praetorian dome"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "cxeno_praetorian"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

// Shadekin stuffs

/datum/sprite_accessory/hair/shadekin_hair_short
	name = "Shadekin Short Hair"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "shadekin_short"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/shadekin_hair_poofy
	name = "Shadekin Poofy Hair"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "shadekin_poofy"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/shadekin_hair_long
	name = "Shadekin Long Hair"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "shadekin_long"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/hair/shadekin_hair_rivyr
	name = "Rivyr Hair"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "shadekin_rivyr"
	ckeys_allowed = list("verysoft")
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/facial_hair
	icon = 'icons/mob/human_face_or_vr.dmi'
	var/color_blend_mode = ICON_MULTIPLY
	species_allowed = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_TESHARI)
/*
shaved
	name = "Shaved"
	icon_state = "bald"
	gender = NEUTER
	species_allowed = list(SPECIES_HUMAN, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_TESHARI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
*/
/datum/sprite_accessory/facial_hair/neck_fluff
	name = "Neck Fluff"
	icon = 'icons/mob/human_face_or_vr.dmi'
	icon_state = "facial_neckfluff"
	gender = NEUTER
	species_allowed = list(SPECIES_TAJ, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/facial_hair/vulp_none
	name = "None"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_state = "none"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/facial_hair/vulp_blaze
	name = "Blaze"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_state = "vulp_facial_blaze"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/facial_hair/vulp_vulpine
	name = "Vulpine"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_state = "vulp_facial_vulpine"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/facial_hair/vulp_earfluff
	name = "Earfluff"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_state = "vulp_facial_earfluff"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/facial_hair/vulp_mask
	name = "Mask"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_state = "vulp_facial_mask"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/facial_hair/vulp_patch
	name = "Patch"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_state = "vulp_facial_patch"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/facial_hair/vulp_ruff
	name = "Ruff"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_state = "vulp_facial_ruff"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/facial_hair/vulp_kita
	name = "Kita"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_state = "vulp_facial_kita"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

/datum/sprite_accessory/facial_hair/vulp_swift
	name = "Swift"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_state = "vulp_facial_swift"
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	gender = NEUTER

//VOREStation Body Markings and Overrides
//Reminder: BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN,BP_HEAD

/datum/sprite_accessory/marking //Override for base markings
	var/color_blend_mode = ICON_ADD

/datum/sprite_accessory/marking/vr
	icon = 'icons/mob/human_races/markings_vr.dmi'

	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/marking/vr/vulp_belly
	name = "belly fur (Vulp)"
	icon_state = "vulp_belly"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/vr/vulp_fullbelly
	name = "full belly fur (Vulp)"
	icon_state = "vulp_fullbelly"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/vr/vulp_crest
	name = "belly crest (Vulp)"
	icon_state = "vulp_crest"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/vr/vulp_nose
	name = "nose (Vulp)"
	icon_state = "vulp_nose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/vulp_short_nose
	name = "nose, short (Vulp)"
	icon_state = "vulp_short_nose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/snoutstripe
	name = "snout stripe (Vulp)"
	icon_state = "snoutstripe"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/vulp_face
	name = "face (Vulp)"
	icon_state = "vulp_face"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/vulp_facealt
	name = "face, alt. (Vulp)"
	icon_state = "vulp_facealt"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/vulp_earsface
	name = "ears and face (Vulp)"
	icon_state = "vulp_earsface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/vulp_all
	name = "all head highlights (Vulp)"
	icon_state = "vulp_all"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/sergal_full
	name = "Sergal Markings"
	icon_state = "sergal_full"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)
	species_allowed = list("Sergal")

/datum/sprite_accessory/marking/vr/sergal_full_female
	name = "Sergal Markings (Female)"
	icon_state = "sergal_full_female"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)
	species_allowed = list("Sergal")

/datum/sprite_accessory/marking/vr/monoeye
	name = "Monoeye"
	icon_state = "monoeye"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/spidereyes
	name = "Spider Eyes"
	icon_state = "spidereyes"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/sergaleyes
	name = "Sergal Eyes"
	icon_state = "eyes_sergal"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/brows
	name = "Eyebrows"
	icon_state = "brows"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/nevrean_female
	name = "Female Nevrean beak"
	icon_state = "nevrean_f"
	body_parts = list(BP_HEAD)
	color_blend_mode = ICON_MULTIPLY
	gender = FEMALE

/datum/sprite_accessory/marking/vr/nevrean_male
	name = "Male Nevrean beak"
	icon_state = "nevrean_m"
	body_parts = list(BP_HEAD)
	color_blend_mode = ICON_MULTIPLY
	gender = MALE

/datum/sprite_accessory/marking/vr/spots
	name = "Spots"
	icon_state = "spots"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/vr/shaggy_mane
	name = "Shaggy mane/feathers"
	icon_state = "shaggy"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/vr/jagged_teeth
	name = "Jagged teeth"
	icon_state = "jagged"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/blank_face
	name = "Blank round face (use with monster mouth)"
	icon_state = "blankface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/monster_mouth
	name = "Monster mouth"
	icon_state = "monster"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/saber_teeth
	name = "Saber teeth"
	icon_state = "saber"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/fangs
	name = "Fangs"
	icon_state = "fangs"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/tusks
	name = "Tusks"
	icon_state = "tusks"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/otie_face
	name = "Otie face"
	icon_state = "otieface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/otie_nose
	name = "Otie nose"
	icon_state = "otie_nose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/otienose_lite
	name = "Short otie nose"
	icon_state = "otienose_lite"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/backstripes
	name = "Back stripes"
	icon_state = "otiestripes"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/vr/belly_butt
	name = "Belly and butt"
	icon_state = "bellyandbutt"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/vr/fingers_toes
	name = "Fingers and toes"
	icon_state = "fingerstoes"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/vr/otie_socks
	name = "Fingerless socks"
	icon_state = "otiesocks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/vr/corvid_beak
	name = "Corvid beak"
	icon_state = "corvidbeak"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/corvid_belly
	name = "Corvid belly"
	icon_state = "corvidbelly"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/vr/cow_body
	name = "Cow markings"
	icon_state = "cowbody"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/vr/cow_nose
	name = "Cow nose"
	icon_state = "cownose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/zmask
	name = "Eye mask"
	icon_state = "zmask"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/zbody
	name = "Thick jagged stripes"
	icon_state = "zbody"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/vr/znose
	name = "Jagged snout"
	icon_state = "znose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/otter_nose
	name = "Otter nose"
	icon_state = "otternose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/otter_face
	name = "Otter face"
	icon_state = "otterface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/deer_face
	name = "Deer face"
	icon_state = "deerface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/sharkface
	name = "Akula snout"
	icon_state = "sharkface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/sheppy_face
	name = "Shepherd snout"
	icon_state = "shepface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/sheppy_back
	name = "Shepherd back"
	icon_state = "shepback"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/vr/zorren_belly_male
	name = "Zorren Male Torso"
	icon_state = "zorren_belly"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/vr/zorren_belly_female
	name = "Zorren Female Torso"
	icon_state = "zorren_belly_female"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/vr/zorren_back_patch
	name = "Zorren Back Patch"
	icon_state = "zorren_backpatch"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/vr/zorren_face_male
	name = "Zorren Male Face"
	icon_state = "zorren_face"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	gender = MALE

/datum/sprite_accessory/marking/vr/zorren_face_female
	name = "Zorren Female Face"
	icon_state = "zorren_face_female"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	gender = FEMALE

/datum/sprite_accessory/marking/vr/zorren_muzzle_male
	name = "Zorren Male Muzzle"
	icon_state = "zorren_muzzle"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	gender = MALE

/datum/sprite_accessory/marking/vr/zorren_muzzle_female
	name = "Zorren Female Muzzle"
	icon_state = "zorren_muzzle_female"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	gender = FEMALE

/datum/sprite_accessory/marking/vr/zorren_socks
	name = "Zorren Socks"
	icon_state = "zorren_socks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/vr/zorren_longsocks
	name = "Zorren Longsocks"
	icon_state = "zorren_longsocks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/vr/tesh_feathers
	name = "Teshari Feathers"
	icon_state = "tesh-feathers"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/vr/harpy_feathers
	name = "Rapala leg Feather"
	icon_state = "harpy-feathers"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG)

/datum/sprite_accessory/marking/vr/harpy_legs
	name = "Rapala leg coloring"
	icon_state = "harpy-leg"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG)

/datum/sprite_accessory/marking/vr/chooves
	name = "Cloven hooves"
	icon_state = "chooves"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT)

/datum/sprite_accessory/marking/vr/alurane
	name = "Alurane Body"
	icon_state = "alurane"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)
	ckeys_allowed = list("natje")

/datum/sprite_accessory/marking/vr/body_tone
	name = "Body toning (for emergency contrast loss)"
	icon_state = "btone"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/vr/gloss
	name = "Full body gloss"
	icon_state = "gloss"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/vr/eboop_panels
	name = "Eggnerd FBP panels"
	icon_state = "eboop"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/vr/osocks_rarm
	name = "Modular Longsock (right arm)"
	icon_state = "osocks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_R_ARM,BP_R_HAND)

/datum/sprite_accessory/marking/vr/osocks_larm
	name = "Modular Longsock (left arm)"
	icon_state = "osocks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_ARM,BP_L_HAND)

/datum/sprite_accessory/marking/vr/osocks_rleg
	name = "Modular Longsock (right leg)"
	icon_state = "osocks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_R_FOOT,BP_R_LEG)

/datum/sprite_accessory/marking/vr/osocks_lleg
	name = "Modular Longsock (left leg)"
	icon_state = "osocks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_L_LEG)

/datum/sprite_accessory/marking/vr/animeeyesinner
	name = "Anime Eyes Inner"
	icon_state = "animeeyesinner"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/animeeyesouter
	name = "Anime Eyes Outer"
	icon_state = "animeeyesouter"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/panda_eye_marks
	name = "Panda Eye Markings"
	icon_state = "eyes_panda"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/marking/vr/catwomantorso
	name = "Catwoman chest stripes"
	icon_state = "catwomanchest"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/vr/catwomangroin
	name = "Catwoman groin stripes"
	icon_state = "catwomangroin"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_GROIN)

/datum/sprite_accessory/marking/vr/catwoman_rleg
	name = "Catwoman right leg stripes"
	icon_state = "catwomanright"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_R_LEG)

/datum/sprite_accessory/marking/vr/catwoman_lleg
	name = "Catwoman left leg stripes"
	icon_state = "catwomanleft"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG)

/datum/sprite_accessory/marking/vr/teshi_small_feathers
	name = "Teshari small wingfeathers"
	icon_state = "teshi_sf"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_HAND,BP_R_HAND,BP_TORSO)

/datum/sprite_accessory/marking/vr/spirit_lights
	name = "Ward - Spirit FBP Lights"
	icon_state = "lights"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/vr/spirit_lights_body
	name = "Ward - Spirit FBP Lights (body)"
	icon_state = "lights"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO)

/datum/sprite_accessory/marking/vr/spirit_lights_head
	name = "Ward - Spirit FBP Lights (head)"
	icon_state = "lights"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/spirit_panels
	name = "Ward - Spirit FBP Panels"
	icon_state = "panels"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/vr/spirit_panels_body
	name = "Ward - Spirit FBP Panels (body)"
	icon_state = "panels"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/vr/spirit_panels_head
	name = "Ward - Spirit FBP Panels (head)"
	icon_state = "panels"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/tentacle_head
	name = "Squid Head"
	icon_state = "tentaclehead"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/tentacle_mouth
	name = "Tentacle Mouth"
	icon_state = "tentaclemouth"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/rosette
	name = "Rosettes"
	icon_state = "rosette"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)
/*
werewolf_nose
	name = "Werewolf nose"
	icon = 'icons/mob/species/werebeast/werebeast_markings.dmi'
	icon_state = "werewolf_nose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_WEREBEAST)

werewolf_face
	name = "Werewolf face"
	icon = 'icons/mob/species/werebeast/werebeast_markings.dmi'
	icon_state = "werewolf"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_WEREBEAST)

werewolf_belly
	name = "Werewolf belly"
	icon = 'icons/mob/species/werebeast/werebeast_markings.dmi'
	icon_state = "werewolf"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_GROIN,BP_TORSO)
	species_allowed = list(SPECIES_WEREBEAST)

werewolf_socks
	name = "Werewolf socks"
	icon = 'icons/mob/species/werebeast/werebeast_markings.dmi'
	icon_state = "werewolf"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
	species_allowed = list(SPECIES_WEREBEAST)

shadekin_snoot
	name = "Shadekin Snoot"
	icon_state = "shadekin-snoot"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW)
*/
/datum/sprite_accessory/marking/vr/taj_nose_alt
	name = "Nose Color, alt. (Taj)"
	icon_state = "taj_nosealt"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/talons
	name = "Talons"
	icon_state = "talons"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG)

/datum/sprite_accessory/marking/vr/claws
	name = "Claws"
	icon_state = "claws"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/vr/equine_snout //Why the long face? Works best with sergal bodytype.
	name = "Equine Snout"
	icon_state = "donkey"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/equine_nose
	name = "Equine Nose"
	icon_state = "dnose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
