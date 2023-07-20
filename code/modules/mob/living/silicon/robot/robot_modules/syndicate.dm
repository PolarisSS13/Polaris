/* Syndicate modules */

/obj/item/robot_module/robot/syndicate
	name = "illegal robot module"
	display_name = "Subverted"
	hide_on_manifest = TRUE
	unavailable_by_default = TRUE
	languages = list(
					LANGUAGE_SOL_COMMON = 1,
					LANGUAGE_SIVIAN = 0,
					LANGUAGE_TRADEBAND = 1,
					LANGUAGE_UNATHI = 0,
					LANGUAGE_SIIK	= 0,
					LANGUAGE_AKHANI = 0,
					LANGUAGE_SKRELLIAN = 0,
					LANGUAGE_SKRELLIANFAR = 0,
					LANGUAGE_ROOTLOCAL = 0,
					LANGUAGE_GUTTER = 1,
					LANGUAGE_SCHECHI = 0,
					LANGUAGE_EAL	 = 1,
					LANGUAGE_SIGN	 = 0,
					LANGUAGE_TERMINUS = 1,
					LANGUAGE_ZADDAT = 0
					)
	sprites = list(
		"Cerberus"           = "syndie_bloodhound",
		"Cerberus - Treaded" = "syndie_treadhound",
		"Ares"               = "squats",
		"Telemachus"         = "toiletbotantag",
		"XI-GUS"             = "spidersyndi",
		"XI-ALP"             = "syndi-heavy"
	)
	universal_equipment = list(
		/obj/item/flash/robot,
		/obj/item/tool/crowbar/cyborg,
		/obj/item/extinguisher,
		/obj/item/gps/robot,
		/obj/item/pinpointer/shuttle/merc,
		/obj/item/melee/energy/sword,
	)
	jetpack = /obj/item/tank/jetpack/carbondioxide
	synths = list(
		/datum/matter_synth/cloth = 40000
	)
	var/id

// All syndie modules get these, and the base borg items (flash, crowbar, etc).
/obj/item/robot_module/robot/syndicate/finalize_synths()
	. = ..()
	var/datum/matter_synth/cloth/cloth = locate() in synths
	var/obj/item/stack/sandbags/cyborg/SB = locate() in modules
	SB.synths += list(cloth)

/obj/item/robot_module/robot/syndicate/finalize_equipment()
	. = ..()
	var/mob/living/silicon/robot/R = loc
	if(istype(R))
		id = R.idcard
		modules += id

/obj/item/robot_module/robot/syndicate/Destroy()
	id = null
	return ..()

// Gets a big shield and a gun that shoots really fast to scare the opposing force.
/obj/item/robot_module/robot/syndicate/protector
	name = "protector robot module"
	sprites = list(
		"Cerberus - Treaded" = "syndie_treadhound",
		"Cerberus" = "syndie_bloodhound",
		"Ares" = "squats",
		"XI-ALP" = "syndi-heavy"
		)
	modules = list(
		/obj/item/shield_projector/rectangle/weak,
		/obj/item/gun/energy/dakkalaser,
		/obj/item/handcuffs/cyborg,
		/obj/item/melee/baton/robot
	)

// 95% engi-borg and 15% roboticist.
/obj/item/robot_module/robot/syndicate/mechanist
	name = "mechanist robot module"
	sprites = list(
		"XI-GUS" = "spidersyndi",
		"WTOperator" = "sleekhos"
	)
	modules = list(
		/obj/item/borg/sight/meson,
		/obj/item/weldingtool/electric/mounted/cyborg,
		/obj/item/tool/screwdriver/cyborg,
		/obj/item/tool/wrench/cyborg,
		/obj/item/tool/wirecutters/cyborg,
		/obj/item/multitool/ai_detector,
		/obj/item/pickaxe/plasmacutter,
		/obj/item/rcd/electric/mounted/borg/lesser,
		/obj/item/melee/energy/sword/ionic_rapier,
		/obj/item/robotanalyzer,
		/obj/item/shockpaddles/robot/jumper,
		/obj/item/gripper/no_use/organ/robotics,
		/obj/item/card/robot/syndi,
		/obj/item/card/emag,
		/obj/item/stack/nanopaste,
		/obj/item/stack/material/cyborg/steel,
		/obj/item/stack/material/cyborg/glass,
		/obj/item/stack/rods/cyborg,
		/obj/item/stack/cable_coil/cyborg,
		/obj/item/stack/material/cyborg/glass/reinforced
	)
	synths = list(
		/datum/matter_synth/nanite = 10000,
		/datum/matter_synth/metal = 40000,
		/datum/matter_synth/glass = 40000,
		/datum/matter_synth/wire
	)

/obj/item/robot_module/robot/syndicate/mechanist/finalize_synths()
	. = ..()

	var/datum/matter_synth/nanite/nanite = locate() in synths
	var/obj/item/stack/nanopaste/N =       locate() in modules
	N.uses_charge = 1
	N.charge_costs = list(1000)
	N.synths = list(nanite)

	var/datum/matter_synth/metal/metal =         locate() in synths
	var/obj/item/stack/material/cyborg/steel/M = locate() in modules
	var/obj/item/stack/rods/cyborg/rods =        locate() in modules
	M.synths = list(metal)
	rods.synths = list(metal)

	var/datum/matter_synth/glass/glass =         locate() in synths
	var/obj/item/stack/material/cyborg/glass/G = locate() in modules
	G.synths = list(glass)

	var/datum/matter_synth/wire/wire =       locate() in synths
	var/obj/item/stack/cable_coil/cyborg/C = locate() in modules
	C.synths = list(wire)

	var/obj/item/stack/material/cyborg/glass/reinforced/RG = locate() in modules
	RG.synths = list(metal, glass)

// Mediborg optimized for on-the-field healing, but can also do surgery if needed.
/obj/item/robot_module/robot/syndicate/combat_medic
	name = "combat medic robot module"
	sprites = list(
		"Telemachus" = "toiletbotantag"
	)
	modules = list(
		/obj/item/borg/sight/hud/med,
		/obj/item/healthanalyzer/advanced,
		/obj/item/reagent_containers/borghypo/merc,
		/obj/item/autopsy_scanner,
		/obj/item/surgical/scalpel/cyborg,
		/obj/item/surgical/hemostat/cyborg,
		/obj/item/surgical/retractor/cyborg,
		/obj/item/surgical/cautery/cyborg,
		/obj/item/surgical/bonegel/cyborg,
		/obj/item/surgical/FixOVein/cyborg,
		/obj/item/surgical/bonesetter/cyborg,
		/obj/item/surgical/circular_saw/cyborg,
		/obj/item/surgical/surgicaldrill/cyborg,
		/obj/item/gripper/no_use/organ,
		/obj/item/gripper/medical,
		/obj/item/shockpaddles/robot/combat,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/syringe,
		/obj/item/roller_holder,
		/obj/item/stack/medical/advanced/ointment,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/medical/splint
	)
	synths = list(
		/datum/matter_synth/medicine = 15000
	)

/obj/item/robot_module/robot/syndicate/combat_medic/finalize_synths()
	. = ..()
	var/datum/matter_synth/medicine/medicine = locate() in synths
	var/obj/item/stack/medical/advanced/ointment/O = locate() in modules
	O.uses_charge = 1
	O.charge_costs = list(1000)
	O.synths = list(medicine)
	var/obj/item/stack/medical/advanced/bruise_pack/B = locate() in modules
	B.uses_charge = 1
	B.charge_costs = list(1000)
	B.synths = list(medicine)
	var/obj/item/stack/medical/splint/S = locate() in modules
	S.uses_charge = 1
	S.charge_costs = list(1000)
	S.synths = list(medicine)

/obj/item/robot_module/robot/syndicate/combat_medic/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/reagent_containers/syringe/S = locate() in modules
	if(S.mode == 2)
		S.reagents.clear_reagents()
		S.mode = initial(S.mode)
		S.desc = initial(S.desc)
		S.update_icon()
	..()
