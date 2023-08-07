/obj/item/robot_module/robot/standard
	name = "standard robot module"
	display_name = "Standard"
	sprites = list(
		"M-USE NanoTrasen" = "robot",
		"Haruka"           = "marinaSD",
		"Usagi"            = "tallflower",
		"Telemachus"       = "toiletbot",
		"WTOperator"       = "sleekstandard",
		"WTOmni"           = "omoikane",
		"XI-GUS"           = "spider",
		"XI-ALP"           = "heavyStandard",
		"Basic"            = "robot_old",
		"Android"          = "droid",
		"Insekt"           = "insekt-Default",
		"Usagi-II"         = "tall2standard",
		"Decapod"          = "decapod-Standard",
		"Pneuma"           = "pneuma-Standard",
		"Tower"            = "drider-Standard"
	)
	modules = list(
		/obj/item/melee/baton/loaded,
		/obj/item/tool/wrench/cyborg,
		/obj/item/healthanalyzer
	)
	emag = /obj/item/melee/energy/sword

/obj/item/robot_module/robot/standard/flying
	module_category = ROBOT_MODULE_TYPE_FLYING
	can_be_pushed = TRUE
	sprites = list(
		"Drone"    = "robot",
		"Pyralis"  = "Glitterfly-Standard",
		"Cabeiri"  = "eyebot-standard"
	)

/obj/item/robot_module/robot/medical
	name = "medical robot module"
	display_name = "Medical"
	channels = list("Medical" = 1)
	networks = list(NETWORK_MEDICAL)
	subsystems = list(/mob/living/silicon/proc/subsystem_crew_monitor)
	can_be_pushed = 0

/obj/item/robot_module/robot/medical/surgeon
	name = "surgeon robot module"
	display_name = "Surgeon"
	sprites = list(
		"M-USE NanoTrasen" = "robotMedi",
		"Haruka"           = "marinaMD",
		"Minako"           = "arachne",
		"Usagi"            = "tallwhite",
		"Telemachus"       = "toiletbotsurgeon",
		"WTOperator"       = "sleekcmo",
		"XI-ALP"           = "heavyMed",
		"Basic"            = "Medbot",
		"Advanced Droid"   = "droid-medical",
		"Needles"          = "medicalrobot",
		"Insekt"           = "insekt-Med",
		"Usagi-II"         = "tall2medical",
		"Decapod"          = "decapod-Surgeon",
		"Pneuma"           = "pneuma-Surgeon",
		"Tower"            = "drider-Surgeon"
	)
	modules = list(
		/obj/item/healthanalyzer,
		/obj/item/reagent_containers/borghypo/surgeon,
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
		/obj/item/shockpaddles/robot,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/syringe,
		/obj/item/stack/nanopaste,
		/obj/item/stack/medical/advanced/bruise_pack
	)
	emag = /obj/item/reagent_containers/spray
	synths = list(
		/datum/matter_synth/medicine = 10000
	)

/obj/item/robot_module/robot/medical/surgeon/flying
	module_category = ROBOT_MODULE_TYPE_FLYING
	can_be_pushed = TRUE
	sprites = list(
		"Handy"   = "handy-med",
		"Drone"   = "drone-surgery",
		"Eyebot"  = "eyebot-medical",
		"Pyralis" = "Glitterfly-Surgeon"
	)

/obj/item/robot_module/robot/medical/surgeon/finalize_emag()
	. = ..()
	emag.reagents.add_reagent("pacid", 250)
	emag.name = "polyacid spray"

/obj/item/robot_module/robot/medical/surgeon/finalize_synths()
	. = ..()
	var/datum/matter_synth/medicine/medicine = locate() in synths
	var/obj/item/stack/nanopaste/N = locate() in modules
	N.uses_charge = 1
	N.charge_costs = list(1000)
	N.synths = list(medicine)
	var/obj/item/stack/medical/advanced/bruise_pack/B = locate() in modules
	B.uses_charge = 1
	B.charge_costs = list(1000)
	B.synths = list(medicine)

/obj/item/robot_module/robot/medical/surgeon/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)

	var/obj/item/reagent_containers/syringe/S = locate() in src.modules
	if(S.mode == 2)
		S.reagents.clear_reagents()
		S.mode = initial(S.mode)
		S.desc = initial(S.desc)
		S.update_icon()

	if(src.emag)
		var/obj/item/reagent_containers/spray/PS = src.emag
		PS.reagents.add_reagent("pacid", 2 * amount)

	..()

/obj/item/robot_module/robot/medical/crisis
	name = "crisis robot module"
	display_name = "Crisis"
	sprites = list(
		"M-USE NanoTrasen" = "robotMedi",
		"Haruka"           = "marinaMD",
		"Minako"           = "arachne",
		"Usagi"            = "tallwhite",
		"Telemachus"       = "toiletbotmedical",
		"WTOperator"       = "sleekmedic",
		"XI-ALP"           = "heavyMed",
		"Basic"            = "Medbot",
		"Advanced Droid"   = "droid-medical",
		"Needles"          = "medicalrobot",
		"Insekt"           = "insekt-Med",
		"Usagi-II"         = "tall2medical",
		"Decapod"          = "decapod-Crisis",
		"Pneuma"           = "pneuma-Crisis",
		"Tower"            = "drider-Crisis"
	)
	modules = list(
		/obj/item/healthanalyzer,
		/obj/item/reagent_scanner/adv,
		/obj/item/roller_holder,
		/obj/item/reagent_containers/borghypo/crisis,
		/obj/item/reagent_containers/glass/beaker/large,
		/obj/item/reagent_containers/dropper/industrial,
		/obj/item/reagent_containers/syringe,
		/obj/item/gripper/no_use/organ,
		/obj/item/gripper/medical,
		/obj/item/shockpaddles/robot,
		/obj/item/stack/medical/advanced/ointment,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/medical/splint
	)
	emag = /obj/item/reagent_containers/spray
	synths = list(
		/datum/matter_synth/medicine = 15000
	)

/obj/item/robot_module/robot/medical/crisis/flying
	module_category = ROBOT_MODULE_TYPE_FLYING
	can_be_pushed = TRUE
	sprites = list(
		"Drone"           = "drone-medical",
		"Chemistry Drone" = "drone-chemistry",
		"Eyebot"          = "eyebot-medical",
		"Pyralis"         = "Glitterfly-Crisis"
	)

/obj/item/robot_module/robot/medical/crisis/finalize_emag()
	. = ..()
	emag.reagents.add_reagent("pacid", 250)
	emag.name = "polyacid spray"

/obj/item/robot_module/robot/medical/crisis/finalize_synths()
	. = ..()
	var/datum/matter_synth/medicine/medicine =          locate() in synths
	var/obj/item/stack/medical/advanced/ointment/O =    locate() in modules
	O.uses_charge = 1
	O.charge_costs = list(1000)
	O.synths = list(medicine)
	var/obj/item/stack/medical/advanced/bruise_pack/B = locate() in modules
	B.uses_charge = 1
	B.charge_costs = list(1000)
	B.synths = list(medicine)
	var/obj/item/stack/medical/splint/S =               locate() in modules
	S.uses_charge = 1
	S.charge_costs = list(1000)
	S.synths = list(medicine)

/obj/item/robot_module/robot/medical/crisis/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)

	var/obj/item/reagent_containers/syringe/S = locate() in src.modules
	if(S.mode == 2)
		S.reagents.clear_reagents()
		S.mode = initial(S.mode)
		S.desc = initial(S.desc)
		S.update_icon()

	if(src.emag)
		var/obj/item/reagent_containers/spray/PS = src.emag
		PS.reagents.add_reagent("pacid", 2 * amount)

	..()

/obj/item/robot_module/robot/engineering
	name = "engineering robot module"
	display_name = "Engineering"
	channels = list("Engineering" = 1)
	networks = list(NETWORK_ENGINEERING)
	subsystems = list(/mob/living/silicon/proc/subsystem_power_monitor)
	sprites = list(
		"M-USE NanoTrasen"   = "robotEngi",
		"Haruka"             = "marinaENG",
		"Usagi"              = "tallyellow",
		"Telemachus"         = "toiletbotengineering",
		"WTOperator"         = "sleekce",
		"XI-GUS"             = "spidereng",
		"XI-ALP"             = "heavyEng",
		"Basic"              = "Engineering",
		"Antique"            = "engineerrobot",
		"Landmate"           = "landmate",
		"Landmate - Treaded" = "engiborg+tread",
		"Treadwell"          = "treadwell",
		"Usagi-II"           = "tall2engineer",
		"Decapod"            = "decapod-Engineering",
		"Pneuma"             = "pneuma-Engineering",
		"Tower"              = "drider-Engineering"
	)
	modules = list(
		/obj/item/borg/sight/meson,
		/obj/item/weldingtool/electric/mounted/cyborg,
		/obj/item/tool/screwdriver/cyborg,
		/obj/item/tool/wrench/cyborg,
		/obj/item/tool/wirecutters/cyborg,
		/obj/item/multitool,
		/obj/item/t_scanner,
		/obj/item/analyzer,
		/obj/item/taperoll/engineering,
		/obj/item/gripper,
		/obj/item/gripper/circuit,
		/obj/item/lightreplacer,
		/obj/item/pipe_painter,
		/obj/item/floor_painter,
		/obj/item/inflatable_dispenser/robot,
		/obj/item/geiger,
		/obj/item/rcd/electric/mounted/borg,
		/obj/item/pipe_dispenser,
		/obj/item/pickaxe/plasmacutter,
		/obj/item/gripper/no_use/loader,
		/obj/item/matter_decompiler,
		/obj/item/stack/material/cyborg/steel,
		/obj/item/stack/material/cyborg/glass,
		/obj/item/stack/rods/cyborg,
		/obj/item/stack/cable_coil/cyborg,
		/obj/item/stack/material/cyborg/plasteel,
		/obj/item/stack/tile/floor/cyborg,
		/obj/item/stack/tile/roofing/cyborg,
		/obj/item/stack/material/cyborg/glass/reinforced,
		/obj/item/stack/tile/wood/cyborg,
		/obj/item/stack/material/cyborg/wood,
		/obj/item/stack/material/cyborg/plastic
	)
	emag = /obj/item/melee/baton/robot/arm
	synths = list(
		/datum/matter_synth/metal =    40000,
		/datum/matter_synth/glass =    40000,
		/datum/matter_synth/plasteel = 20000,
		/datum/matter_synth/wood =     40000,
		/datum/matter_synth/plastic =  40000,
		/datum/matter_synth/wire
	)

/obj/item/robot_module/robot/engineering/finalize_synths()
	. = ..()
	var/datum/matter_synth/metal/metal =       locate() in synths
	var/datum/matter_synth/glass/glass =       locate() in synths
	var/datum/matter_synth/plasteel/plasteel = locate() in synths
	var/datum/matter_synth/wood/wood =         locate() in synths
	var/datum/matter_synth/plastic/plastic =   locate() in synths
	var/datum/matter_synth/wire/wire =         locate() in synths
	var/obj/item/matter_decompiler/MD =        locate() in modules
	MD.metal = metal
	MD.glass = glass
	var/obj/item/stack/material/cyborg/steel/M = locate() in modules
	M.synths = list(metal)
	var/obj/item/stack/material/cyborg/glass/G = locate() in modules
	G.synths = list(glass)
	var/obj/item/stack/rods/cyborg/R = locate() in modules
	R.synths = list(metal)
	var/obj/item/stack/cable_coil/cyborg/C =locate() in modules
	C.synths = list(wire)
	var/obj/item/stack/material/cyborg/plasteel/PS = locate() in modules
	PS.synths = list(plasteel)
	var/obj/item/stack/tile/floor/cyborg/S = locate() in modules
	S.synths = list(metal)
	var/obj/item/stack/tile/roofing/cyborg/CT = locate() in modules
	CT.synths = list(metal)
	var/obj/item/stack/material/cyborg/glass/reinforced/RG = locate() in modules
	RG.synths = list(metal, glass)
	var/obj/item/stack/tile/wood/cyborg/WT = locate() in modules
	WT.synths = list(wood)
	var/obj/item/stack/material/cyborg/wood/W = locate() in modules
	W.synths = list(wood)
	var/obj/item/stack/material/cyborg/plastic/PL = locate() in modules
	PL.synths = list(plastic)

/obj/item/robot_module/robot/engineering/flying
	module_category = ROBOT_MODULE_TYPE_FLYING
	can_be_pushed = TRUE
	sprites = list(
		"Handy"   = "handy-engineer",
		"Drone"   = "drone-engineer",
		"Eyebot"  = "eyebot-engineering",
		"Pyralis" = "Glitterfly-Engineering",
	)

/obj/item/robot_module/robot/security
	name = "security robot module"
	display_name = "Security"
	channels = list("Security" = 1)
	networks = list(NETWORK_SECURITY)
	subsystems = list(/mob/living/silicon/proc/subsystem_crew_monitor)
	can_be_pushed = 0
	supported_upgrades = list(/obj/item/borg/upgrade/tasercooler)
	modules = list(
		/obj/item/handcuffs/cyborg,
		/obj/item/melee/baton/robot,
		/obj/item/gun/energy/taser/mounted/cyborg,
		/obj/item/gun/energy/taser/xeno/sec/robot,
		/obj/item/taperoll/police,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/gripper/security
	)
	emag = /obj/item/gun/energy/laser/mounted
	sprites = list(
		"M-USE NanoTrasen"   = "robotSecy",
		"Cerberus"           = "bloodhound",
		"Cerberus - Treaded" = "treadhound",
		"Haruka"             = "marinaSC",
		"Usagi"              = "tallred",
		"Telemachus"         = "toiletbotsecurity",
		"WTOperator"         = "sleeksecurity",
		"XI-GUS"             = "spidersec",
		"XI-ALP"             = "heavySec",
		"Basic"              = "secborg",
		"Hedge Knight"       = "Security",
		"Black Knight"       = "securityrobot",
		"Insekt"             = "insekt-Sec",
		"Usagi-II"           = "tall2security",
		"Decapod"            = "decapod-Security",
		"Pneuma"             = "pneuma-Security",
		"Tower"              = "drider-Security"
	)

/obj/item/robot_module/robot/security/flying
	module_category = ROBOT_MODULE_TYPE_FLYING
	can_be_pushed = TRUE
	sprites = list(
		"Pyralis" = "Glitterfly-Security",
		"Drone"   = "drone-sec",
		"Eyebot"  = "eyebot-security"
	)

/obj/item/robot_module/robot/security/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/flash/F = locate() in src.modules
	if(F.broken)
		F.broken = 0
		F.times_used = 0
		F.icon_state = "flash"
	else if(F.times_used)
		F.times_used--
	var/obj/item/gun/energy/taser/mounted/cyborg/T = locate() in src.modules
	if(T.power_supply.charge < T.power_supply.maxcharge)
		T.power_supply.give(T.charge_cost * amount)
		T.update_icon()
	else
		T.charge_tick = 0

/obj/item/robot_module/robot/janitor
	name = "janitorial robot module"
	display_name = "Janitor"
	channels = list("Service" = 1)
	sprites = list(
		"M-USE NanoTrasen" = "robotJani",
		"Arachne"          = "crawler",
		"Haruka"           = "marinaJN",
		"Telemachus"       = "toiletbotjanitor",
		"WTOperator"       = "sleekjanitor",
		"XI-ALP"           = "heavyRes",
		"Basic"            = "JanBot2",
		"Mopbot"           = "janitorrobot",
		"Mop Gear Rex"     = "mopgearrex",
		"Usagi"            = "tallblue",
		"Usagi-II"         = "tall2janitor",
		"Decapod"          = "decapod-Janitor",
		"Pneuma"           = "pneuma-Janitor",
		"Tower"            = "drider-Janitor"
	)
	modules = list(
		/obj/item/soap/nanotrasen,
		/obj/item/storage/bag/trash,
		/obj/item/mop,
		/obj/item/lightreplacer
	)
	emag = /obj/item/reagent_containers/spray

/obj/item/robot_module/robot/janitor/flying
	module_category = ROBOT_MODULE_TYPE_FLYING
	can_be_pushed = TRUE
	sprites = list(
		"Drone"   = "drone-janitor",
		"Pyralis" = "Glitterfly-Janitor",
		"Cabeiri" = "eyebot-janitor"
	)

/obj/item/robot_module/robot/janitor/finalize_emag()
	. = ..()
	emag.reagents.add_reagent("lube", 250)
	emag.name = "lube spray"

/obj/item/robot_module/robot/janitor/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/lightreplacer/LR = locate() in src.modules
	LR.Charge(R, amount)
	if(src.emag)
		var/obj/item/reagent_containers/spray/S = src.emag
		S.reagents.add_reagent("lube", 2 * amount)

/obj/item/robot_module/robot/clerical
	name = "service robot module"
	channels = list(
		"Service" = 1,
		"Command" = 1
	)
	languages = list(
		LANGUAGE_SOL_COMMON	= 1,
		LANGUAGE_SIVIAN 	= 1,
		LANGUAGE_UNATHI		= 1,
		LANGUAGE_SIIK		= 1,
		LANGUAGE_AKHANI		= 1,
		LANGUAGE_SKRELLIAN	= 1,
		LANGUAGE_SKRELLIANFAR = 0,
		LANGUAGE_ROOTLOCAL	= 0,
		LANGUAGE_TRADEBAND	= 1,
		LANGUAGE_GUTTER		= 1,
		LANGUAGE_SCHECHI	= 1,
		LANGUAGE_EAL		= 1,
		LANGUAGE_TERMINUS	= 1,
		LANGUAGE_SIGN		= 0,
		LANGUAGE_ZADDAT		= 1,
	)

/obj/item/robot_module/robot/clerical/service
	display_name = "Service"
	sprites = list(
		"M-USE NanoTrasen" = "robotServ",
		"Haruka"           = "marinaSV",
		"Michiru"          = "maidbot",
		"Usagi"            = "tallgreen",
		"Telemachus"       = "toiletbot",
		"WTOperator"       = "sleekservice",
		"WTOmni"           = "omoikane",
		"XI-GUS"           = "spider",
		"XI-ALP"           = "heavyServ",
		"Standard"         = "Service2",
		"Waitress"         = "Service",
		"Bro"              = "Brobot",
		"Usagi"            = "tall2clown",
		"Rich"             = "maximillion",
		"Usagi-II"         = "tall2service",
		"Decapod"          = "decapod-Service",
		"Pneuma"           = "pneuma-Service",
		"Tower"            = "drider-Service"
	)
	modules = list(
		/obj/item/gripper/service,
		/obj/item/reagent_containers/glass/bucket,
		/obj/item/material/minihoe,
		/obj/item/material/knife/machete/hatchet,
		/obj/item/analyzer/plant_analyzer,
		/obj/item/storage/bag/plants,
		/obj/item/robot_harvester,
		/obj/item/material/knife,
		/obj/item/material/kitchen/rollingpin,
		/obj/item/multitool,
		/obj/item/reagent_containers/dropper/industrial,
		/obj/item/tray/robotray,
		/obj/item/reagent_containers/borghypo/service,
		/obj/item/flame/lighter/zippo,
		/obj/item/rsf
	)
	emag = /obj/item/reagent_containers/food/drinks/bottle/small/beer

/obj/item/robot_module/robot/clerical/service/flying
	module_category = ROBOT_MODULE_TYPE_FLYING
	can_be_pushed = TRUE
	sprites = list(
		"Pyralis"           = "Glitterfly-Service",
		"Eyebot"            = "eyebot-standard",
		"Service Drone"     = "drone-service",
		"Hydroponics Drone" = "drone-hydro"
	)

/obj/item/robot_module/robot/clerical/service/finalize_emag()
	. = ..()
	if(!emag.reagents)
		emag.create_reagents(50)
	else
		emag.reagents.clear_reagents()
	emag.reagents.add_reagent("beer2", 50)
	emag.name = "Mickey Finn's Special Brew"

/obj/item/robot_module/robot/clerical/service/finalize_equipment()
	. = ..()
	var/obj/item/rsf/M = locate() in modules
	M.stored_matter = 30
	var/obj/item/flame/lighter/zippo/L = locate() in modules
	L.lit = TRUE

/obj/item/robot_module/robot/clerical/general
	name = "clerical robot module"
	display_name = "Clerical"
	sprites = list(
		"M-USE NanoTrasen" = "robotCler",
		"Haruka"           = "marinaSV",
		"Usagi"            = "tallgreen",
		"Telemachus"       = "toiletbot",
		"WTOperator"       = "sleekclerical",
		"WTOmni"           = "omoikane",
		"XI-GUS"           = "spidercom",
		"XI-ALP"           = "heavyServ",
		"Waitress"         = "Service",
		"Bro"              = "Brobot",
		"Rich"             = "maximillion",
		"Default"          = "Service2",
		"Usagi-II"         = "tall2service",
		"Decapod"          = "decapod-Clerical",
		"Pneuma"           = "pneuma-Clerical",
		"Tower"            = "drider-Clerical",
		"Hedge"            = "Hydrobot"
	)
	modules = list(
		/obj/item/pen/robopen,
		/obj/item/form_printer,
		/obj/item/gripper/paperwork,
		/obj/item/hand_labeler,
		/obj/item/stamp,
		/obj/item/stamp/denied
	)
	emag = /obj/item/pen/chameleon

/obj/item/robot_module/robot/clerical/general/flying
	module_category = ROBOT_MODULE_TYPE_FLYING
	can_be_pushed = TRUE
	sprites = list(
		"Eyebot"            = "eyebot-standard",
		"Drone"             = "drone-blu",
		"Service Drone"     = "drone-service",
		"Gravekeeper"       = "drone-gravekeeper",
		"Hydroponics Drone" = "drone-hydro",
		"Pyralis"           = "Glitterfly-Clerical"
	)

/obj/item/robot_module/general/butler/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/reagent_containers/food/condiment/enzyme/E = locate() in src.modules
	E.reagents.add_reagent("enzyme", 2 * amount)
	if(src.emag)
		var/obj/item/reagent_containers/food/drinks/bottle/small/beer/B = src.emag
		B.reagents.add_reagent("beer2", 2 * amount)

/obj/item/robot_module/robot/miner
	name = "miner robot module"
	display_name = "Miner"
	channels = list("Supply" = 1)
	networks = list(NETWORK_MINE)
	sprites = list(
		"NM-USE NanoTrasen" = "robotMine",
		"Haruka"            = "marinaMN",
		"Telemachus"        = "toiletbotminer",
		"WTOperator"        = "sleekminer",
		"XI-GUS"            = "spidermining",
		"XI-ALP"            = "heavyMiner",
		"Basic"             = "Miner_old",
		"Advanced Droid"    = "droid-miner",
		"Treadhead"         = "Miner",
		"Usagi-II"          = "tall2miner",
		"Decapod"           = "decapod-Miner",
		"Pneuma"            = "pneuma-Miner",
		"Tower"             = "drider-Miner"
	)
	modules = list(
		/obj/item/borg/sight/material,
		/obj/item/tool/wrench/cyborg,
		/obj/item/tool/screwdriver/cyborg,
		/obj/item/storage/bag/ore,
		/obj/item/pickaxe/borgdrill,
		/obj/item/storage/bag/sheetsnatcher/borg,
		/obj/item/gripper/miner,
		/obj/item/mining_scanner
	)
	emag = /obj/item/pickaxe/diamonddrill

/obj/item/robot_module/robot/miner/flying
	module_category = ROBOT_MODULE_TYPE_FLYING
	can_be_pushed = TRUE
	sprites = list(
		"Drone"   = "drone-miner",
		"Cabeiri" = "eyebot-miner",
		"Pyralis" = "Glitterfly-Miner"
	)

/obj/item/robot_module/robot/research
	name = "research module"
	display_name = "Research"
	channels = list("Science" = 1)
	sprites = list(
		"L'Ouef"     = "peaceborg",
		"Haruka"     = "marinaSCI",
		"WTDove"     = "whitespider",
		"WTOperator" = "sleekscience",
		"Droid"      = "droid-science",
		"Insekt"     = "insekt-Sci",
		"Usagi-II"   = "tall2peace",
		"Decapod"    = "decapod-Research",
		"Pneuma"     = "pneuma-Research",
		"Tower"      = "drider-Research"
	)
	modules = list(
		/obj/item/portable_destructive_analyzer,
		/obj/item/gripper/research,
		/obj/item/gripper/circuit,
		/obj/item/gripper/no_use/organ/robotics,
		/obj/item/gripper/no_use/mech,
		/obj/item/gripper/no_use/loader,
		/obj/item/robotanalyzer,
		/obj/item/card/robot,
		/obj/item/weldingtool/electric/mounted/cyborg,
		/obj/item/tool/screwdriver/cyborg,
		/obj/item/tool/wrench/cyborg,
		/obj/item/tool/wirecutters/cyborg,
		/obj/item/multitool,
		/obj/item/surgical/scalpel/cyborg,
		/obj/item/surgical/circular_saw/cyborg,
		/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/glass/beaker/large,
		/obj/item/storage/part_replacer,
		/obj/item/shockpaddles/robot/jumper,
		/obj/item/melee/baton/slime/robot,
		/obj/item/gun/energy/taser/xeno/robot,
		/obj/item/xenoarch_multi_tool,
		/obj/item/pickaxe/excavationdrill,
		/obj/item/cataloguer,
		/obj/item/stack/cable_coil/cyborg,
		/obj/item/stack/nanopaste
	)
	emag = /obj/item/hand_tele
	synths = list(
		/datum/matter_synth/nanite = 10000,
		/datum/matter_synth/wire
	)

/obj/item/robot_module/robot/research/flying
	module_category = ROBOT_MODULE_TYPE_FLYING
	can_be_pushed = TRUE
	sprites = list(
		"Handy"   = "handy-science",
		"Drone"   = "drone-science",
		"Pyralis" = "Glitterfly-Research",
		"Cabeiri" = "eyebot-science"
	)

/obj/item/robot_module/robot/research/finalize_synths()
	. = ..()
	var/datum/matter_synth/nanite =  locate() in synths
	var/obj/item/stack/nanopaste/N = locate() in modules
	N.uses_charge = 1
	N.charge_costs = list(1000)
	N.synths = list(nanite)
	var/datum/matter_synth/wire =    locate() in synths
	var/obj/item/stack/cable_coil/cyborg/C = locate() in modules
	C.synths = list(wire)

/obj/item/robot_module/robot/research/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/reagent_containers/syringe/S = locate() in src.modules
	if(S.mode == 2)
		S.reagents.clear_reagents()
		S.mode = initial(S.mode)
		S.desc = initial(S.desc)
		S.update_icon()
	..()

/obj/item/robot_module/robot/security/combat
	name = "combat robot module"
	display_name = "Combat"
	crisis_locked = TRUE
	hide_on_manifest = TRUE
	sprites = list(
		"Haruka"         = "marinaCB",
		"Combat Android" = "droid-combat",
		"Insekt"         = "insekt-Combat",
		"Decapod"        = "decapod-Combat"
	)
	modules = list(
		/obj/item/flash,
		/obj/item/borg/sight/thermal,
		/obj/item/gun/energy/laser/mounted,
		/obj/item/pickaxe/plasmacutter,
		/obj/item/borg/combat/shield,
		/obj/item/borg/combat/mobility
	)
	emag = /obj/item/gun/energy/lasercannon/mounted

/* Drones */
/obj/item/robot_module/drone
	name = "drone module"
	display_name = "Drone"
	sprites = list("Drone" = "repairbot")
	unavailable_by_default = TRUE
	hide_on_manifest = TRUE
	no_slip = TRUE
	networks = list(NETWORK_ENGINEERING)
	modules = list(
		/obj/item/borg/sight/meson,
		/obj/item/weldingtool/electric/mounted/cyborg,
		/obj/item/tool/screwdriver/cyborg,
		/obj/item/tool/wrench/cyborg,
		/obj/item/tool/crowbar/cyborg,
		/obj/item/tool/wirecutters/cyborg,
		/obj/item/t_scanner,
		/obj/item/multitool,
		/obj/item/lightreplacer,
		/obj/item/gripper,
		/obj/item/soap,
		/obj/item/gripper/no_use/loader,
		/obj/item/extinguisher,
		/obj/item/pipe_painter,
		/obj/item/floor_painter,
		/obj/item/matter_decompiler,
		/obj/item/stack/material/cyborg/steel,
		/obj/item/stack/material/cyborg/glass,
		/obj/item/stack/rods/cyborg,
		/obj/item/stack/cable_coil/cyborg,
		/obj/item/stack/tile/floor/cyborg,
		/obj/item/stack/material/cyborg/glass/reinforced,
		/obj/item/stack/tile/wood/cyborg,
		/obj/item/stack/material/cyborg/wood,
		/obj/item/stack/material/cyborg/plastic
	)
	jetpack = /obj/item/tank/jetpack/carbondioxide
	emag = /obj/item/pickaxe/plasmacutter
	synths = list(
		/datum/matter_synth/metal = 25000,
		/datum/matter_synth/glass = 25000,
		/datum/matter_synth/wood = 25000,
		/datum/matter_synth/plastic = 25000,
		/datum/matter_synth/wire = 30
	)

/obj/item/robot_module/drone/finalize_synths()
	. = ..()
	var/datum/matter_synth/metal/metal =     locate() in synths
	var/datum/matter_synth/glass/glass =     locate() in synths
	var/datum/matter_synth/wood/wood =       locate() in synths
	var/datum/matter_synth/plastic/plastic = locate() in synths
	var/datum/matter_synth/wire/wire =       locate() in synths

	var/obj/item/matter_decompiler/MD = locate() in modules
	MD.metal = metal
	MD.glass = glass
	MD.wood = wood
	MD.plastic = plastic

	var/obj/item/stack/material/cyborg/steel/M = locate() in modules
	M.synths = list(metal)
	var/obj/item/stack/material/cyborg/glass/G = locate() in modules
	G.synths = list(glass)
	var/obj/item/stack/rods/cyborg/R = locate() in modules
	R.synths = list(metal)
	var/obj/item/stack/cable_coil/cyborg/C = locate() in modules
	C.synths = list(wire)
	var/obj/item/stack/tile/floor/cyborg/S = locate() in modules
	S.synths = list(metal)
	var/obj/item/stack/material/cyborg/glass/reinforced/RG = locate() in modules
	RG.synths = list(metal, glass)
	var/obj/item/stack/tile/wood/cyborg/WT = locate() in modules
	WT.synths = list(wood)
	var/obj/item/stack/material/cyborg/wood/W = locate() in modules
	W.synths = list(wood)
	var/obj/item/stack/material/cyborg/plastic/P = locate() in modules
	P.synths = list(plastic)

	src.modules += new /obj/item/pipe_dispenser(src)	// At the end to go beside the construction's RCD.

/obj/item/robot_module/drone/construction
	name = "construction drone module"
	display_name = "Construction Drone"
	hide_on_manifest = TRUE
	sprites = list("Drone" = "constructiondrone")
	channels = list("Engineering" = 1)
	languages = list()

/obj/item/robot_module/drone/construction/build_equipment()
	modules += /obj/item/rcd/electric/mounted/borg/lesser
	. = ..()

/obj/item/robot_module/drone/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/lightreplacer/LR = locate() in src.modules
	LR.Charge(R, amount)
	..()

/obj/item/robot_module/drone/mining
	name = "miner drone module"
	display_name = "Mining Drone"
	channels = list("Supply" = 1)
	networks = list(NETWORK_MINE)
	sprites = list("Drone" = "miningdrone")
	modules = list(
		/obj/item/borg/sight/material,
		/obj/item/pickaxe/borgdrill,
		/obj/item/storage/bag/ore,
		/obj/item/storage/bag/sheetsnatcher/borg
	)
	emag = /obj/item/pickaxe/diamonddrill
