// Cyborgs (non-drones), default loadout. This will be given to every module.
/obj/item/robot_module/robot/Initialize()

	. = ..()
	if(. != INITIALIZE_HINT_NORMAL)
		return

	src.modules += new /obj/item/flash/robot(src)
	src.modules += new /obj/item/tool/crowbar/cyborg(src)
	src.modules += new /obj/item/extinguisher(src)
	src.modules += new /obj/item/gps/robot(src)

/obj/item/robot_module/robot/standard
	name = "standard robot module"
	display_name = "Standard"
	sprites = list(
					"M-USE NanoTrasen" = "robot",
					"Cabeiri" = "eyebot-standard",
					"Haruka" = "marinaSD",
					"Usagi" = "tallflower",
					"Telemachus" = "toiletbot",
					"WTOperator" = "sleekstandard",
					"WTOmni" = "omoikane",
					"XI-GUS" = "spider",
					"XI-ALP" = "heavyStandard",
					"Basic" = "robot_old",
					"Android" = "droid",
					"Insekt" = "insekt-Default",
					"Usagi-II" = "tall2standard",
					"Pyralis" = "Glitterfly-Standard",
					"Decapod" = "decapod-Standard",
					"Pneuma" = "pneuma-Standard",
					"Tower" = "drider-Standard"
					)


/obj/item/robot_module/robot/standard/Initialize()

	. = ..()
	if(. != INITIALIZE_HINT_NORMAL)
		return

	src.modules += new /obj/item/melee/baton/loaded(src)
	src.modules += new /obj/item/tool/wrench/cyborg(src)
	src.modules += new /obj/item/healthanalyzer(src)
	src.emag = new /obj/item/melee/energy/sword(src)

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
					"Haruka" = "marinaMD",
					"Minako" = "arachne",
					"Usagi" = "tallwhite",
					"Telemachus" = "toiletbotsurgeon",
					"WTOperator" = "sleekcmo",
					"XI-ALP" = "heavyMed",
					"Basic" = "Medbot",
					"Advanced Droid" = "droid-medical",
					"Needles" = "medicalrobot",
					"Handy" = "handy-med",
					"Insekt" = "insekt-Med",
					"Usagi-II" = "tall2medical",
					"Pyralis" = "Glitterfly-Surgeon",
					"Decapod" = "decapod-Surgeon",
					"Pneuma" = "pneuma-Surgeon",
					"Tower" = "drider-Surgeon"
					)

/obj/item/robot_module/robot/medical/surgeon/Initialize()

	. = ..()
	if(. != INITIALIZE_HINT_NORMAL)
		return

	src.modules += new /obj/item/healthanalyzer(src)
	src.modules += new /obj/item/reagent_containers/borghypo/surgeon(src)
	src.modules += new /obj/item/autopsy_scanner(src)
	src.modules += new /obj/item/surgical/scalpel/cyborg(src)
	src.modules += new /obj/item/surgical/hemostat/cyborg(src)
	src.modules += new /obj/item/surgical/retractor/cyborg(src)
	src.modules += new /obj/item/surgical/cautery/cyborg(src)
	src.modules += new /obj/item/surgical/bonegel/cyborg(src)
	src.modules += new /obj/item/surgical/FixOVein/cyborg(src)
	src.modules += new /obj/item/surgical/bonesetter/cyborg(src)
	src.modules += new /obj/item/surgical/circular_saw/cyborg(src)
	src.modules += new /obj/item/surgical/surgicaldrill/cyborg(src)
	src.modules += new /obj/item/gripper/no_use/organ(src)
	src.modules += new /obj/item/gripper/medical(src)
	src.modules += new /obj/item/shockpaddles/robot(src)
	src.modules += new /obj/item/reagent_containers/dropper(src) // Allows surgeon borg to fix necrosis
	src.modules += new /obj/item/reagent_containers/syringe(src)
	src.emag = new /obj/item/reagent_containers/spray(src)
	src.emag.reagents.add_reagent("pacid", 250)
	src.emag.name = "Polyacid spray"

	var/datum/matter_synth/medicine = new /datum/matter_synth/medicine(10000)
	synths += medicine

	var/obj/item/stack/nanopaste/N = new /obj/item/stack/nanopaste(src)
	var/obj/item/stack/medical/advanced/bruise_pack/B = new /obj/item/stack/medical/advanced/bruise_pack(src)
	N.uses_charge = 1
	N.charge_costs = list(1000)
	N.synths = list(medicine)
	B.uses_charge = 1
	B.charge_costs = list(1000)
	B.synths = list(medicine)
	src.modules += N
	src.modules += B

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
					"Haruka" = "marinaMD",
					"Minako" = "arachne",
					"Usagi" = "tallwhite",
					"Telemachus" = "toiletbotmedical",
					"WTOperator" = "sleekmedic",
					"XI-ALP" = "heavyMed",
					"Basic" = "Medbot",
					"Advanced Droid" = "droid-medical",
					"Needles" = "medicalrobot",
					"Insekt" = "insekt-Med",
					"Usagi-II" = "tall2medical",
					"Pyralis" = "Glitterfly-Crisis",
					"Decapod" = "decapod-Crisis",
					"Pneuma" = "pneuma-Crisis",
					"Tower" = "drider-Crisis"
					)

/obj/item/robot_module/robot/medical/crisis/Initialize()

	. = ..()
	if(. != INITIALIZE_HINT_NORMAL)
		return

	src.modules += new /obj/item/healthanalyzer(src)
	src.modules += new /obj/item/reagent_scanner/adv(src)
	src.modules += new /obj/item/roller_holder(src)
	src.modules += new /obj/item/reagent_containers/borghypo/crisis(src)
	src.modules += new /obj/item/reagent_containers/glass/beaker/large(src)
	src.modules += new /obj/item/reagent_containers/dropper/industrial(src)
	src.modules += new /obj/item/reagent_containers/syringe(src)
	src.modules += new /obj/item/gripper/no_use/organ(src)
	src.modules += new /obj/item/gripper/medical(src)
	src.modules += new /obj/item/shockpaddles/robot(src)
	src.emag = new /obj/item/reagent_containers/spray(src)
	src.emag.reagents.add_reagent("pacid", 250)
	src.emag.name = "Polyacid spray"

	var/datum/matter_synth/medicine = new /datum/matter_synth/medicine(15000)
	synths += medicine

	var/obj/item/stack/medical/advanced/ointment/O = new /obj/item/stack/medical/advanced/ointment(src)
	var/obj/item/stack/medical/advanced/bruise_pack/B = new /obj/item/stack/medical/advanced/bruise_pack(src)
	var/obj/item/stack/medical/splint/S = new /obj/item/stack/medical/splint(src)
	O.uses_charge = 1
	O.charge_costs = list(1000)
	O.synths = list(medicine)
	B.uses_charge = 1
	B.charge_costs = list(1000)
	B.synths = list(medicine)
	S.uses_charge = 1
	S.charge_costs = list(1000)
	S.synths = list(medicine)
	src.modules += O
	src.modules += B
	src.modules += S

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
					"M-USE NanoTrasen" = "robotEngi",
					"Haruka" = "marinaENG",
					"Usagi" = "tallyellow",
					"Telemachus" = "toiletbotengineering",
					"WTOperator" = "sleekce",
					"XI-GUS" = "spidereng",
					"XI-ALP" = "heavyEng",
					"Basic" = "Engineering",
					"Antique" = "engineerrobot",
					"Landmate" = "landmate",
					"Landmate - Treaded" = "engiborg+tread",
					"Treadwell" = "treadwell",
					"Handy" = "handy-engineer",
					"Usagi-II" = "tall2engineer",
					"Pyralis" = "Glitterfly-Engineering",
					"Decapod" = "decapod-Engineering",
					"Pneuma" = "pneuma-Engineering",
					"Tower" = "drider-Engineering"
					)

/obj/item/robot_module/robot/engineering/general/Initialize()

	. = ..()
	if(. != INITIALIZE_HINT_NORMAL)
		return

	src.modules += new /obj/item/borg/sight/meson(src)
	src.modules += new /obj/item/weldingtool/electric/mounted/cyborg(src)
	src.modules += new /obj/item/tool/screwdriver/cyborg(src)
	src.modules += new /obj/item/tool/wrench/cyborg(src)
	src.modules += new /obj/item/tool/wirecutters/cyborg(src)
	src.modules += new /obj/item/multitool(src)
	src.modules += new /obj/item/t_scanner(src)
	src.modules += new /obj/item/analyzer(src)
	src.modules += new /obj/item/taperoll/engineering(src)
	src.modules += new /obj/item/gripper(src)
	src.modules += new /obj/item/gripper/circuit(src)
	src.modules += new /obj/item/lightreplacer(src)
	src.modules += new /obj/item/pipe_painter(src)
	src.modules += new /obj/item/floor_painter(src)
	src.modules += new /obj/item/inflatable_dispenser/robot(src)
	src.emag = new /obj/item/melee/baton/robot/arm(src)
	src.modules += new /obj/item/geiger(src)
	src.modules += new /obj/item/rcd/electric/mounted/borg(src)
	src.modules += new /obj/item/pipe_dispenser(src)
	src.modules += new /obj/item/pickaxe/plasmacutter(src)
	src.modules += new /obj/item/gripper/no_use/loader(src)

	var/datum/matter_synth/metal = new /datum/matter_synth/metal(40000)
	var/datum/matter_synth/glass = new /datum/matter_synth/glass(40000)
	var/datum/matter_synth/plasteel = new /datum/matter_synth/plasteel(20000)
	var/datum/matter_synth/wood = new /datum/matter_synth/wood(40000)
	var/datum/matter_synth/plastic = new /datum/matter_synth/plastic(40000)

	var/datum/matter_synth/wire = new /datum/matter_synth/wire()
	synths += metal
	synths += glass
	synths += plasteel
	synths += wood
	synths += plastic
	synths += wire

	var/obj/item/matter_decompiler/MD = new /obj/item/matter_decompiler(src)
	MD.metal = metal
	MD.glass = glass
	src.modules += MD

	var/obj/item/stack/material/cyborg/steel/M = new (src)
	M.synths = list(metal)
	src.modules += M

	var/obj/item/stack/material/cyborg/glass/G = new (src)
	G.synths = list(glass)
	src.modules += G

	var/obj/item/stack/rods/cyborg/R = new /obj/item/stack/rods/cyborg(src)
	R.synths = list(metal)
	src.modules += R

	var/obj/item/stack/cable_coil/cyborg/C = new /obj/item/stack/cable_coil/cyborg(src)
	C.synths = list(wire)
	src.modules += C

	var/obj/item/stack/material/cyborg/plasteel/PS = new (src)
	PS.synths = list(plasteel)
	src.modules += PS

	var/obj/item/stack/tile/floor/cyborg/S = new /obj/item/stack/tile/floor/cyborg(src)
	S.synths = list(metal)
	src.modules += S

	var/obj/item/stack/tile/roofing/cyborg/CT = new /obj/item/stack/tile/roofing/cyborg(src)
	CT.synths = list(metal)
	src.modules += CT

	var/obj/item/stack/material/cyborg/glass/reinforced/RG = new (src)
	RG.synths = list(metal, glass)
	src.modules += RG

	var/obj/item/stack/tile/wood/cyborg/WT = new /obj/item/stack/tile/wood/cyborg(src)
	WT.synths = list(wood)
	src.modules += WT

	var/obj/item/stack/material/cyborg/wood/W = new (src)
	W.synths = list(wood)
	src.modules += W

	var/obj/item/stack/material/cyborg/plastic/PL = new (src)
	PL.synths = list(plastic)
	src.modules += PL

/obj/item/robot_module/robot/security
	name = "security robot module"
	display_name = "Security"
	channels = list("Security" = 1)
	networks = list(NETWORK_SECURITY)
	subsystems = list(/mob/living/silicon/proc/subsystem_crew_monitor)
	can_be_pushed = 0
	supported_upgrades = list(/obj/item/borg/upgrade/tasercooler)

/obj/item/robot_module/robot/security/general
	sprites = list(
					"M-USE NanoTrasen" = "robotSecy",
					"Cerberus" = "bloodhound",
					"Cerberus - Treaded" = "treadhound",
					"Haruka" = "marinaSC",
					"Usagi" = "tallred",
					"Telemachus" = "toiletbotsecurity",
					"WTOperator" = "sleeksecurity",
					"XI-GUS" = "spidersec",
					"XI-ALP" = "heavySec",
					"Basic" = "secborg",
					"Black Knight" = "securityrobot",
					"Insekt" = "insekt-Sec",
					"Usagi-II" = "tall2security",
					"Pyralis" = "Glitterfly-Security",
					"Decapod" = "decapod-Security",
					"Pneuma" = "pneuma-Security",
					"Tower" = "drider-Security"
					)

/obj/item/robot_module/robot/security/general/Initialize()

	. = ..()
	if(. != INITIALIZE_HINT_NORMAL)
		return

	src.modules += new /obj/item/handcuffs/cyborg(src)
	src.modules += new /obj/item/melee/baton/robot(src)
	src.modules += new /obj/item/gun/energy/taser/mounted/cyborg(src)
	src.modules += new /obj/item/gun/energy/taser/xeno/sec/robot(src)
	src.modules += new /obj/item/taperoll/police(src)
	src.modules += new /obj/item/reagent_containers/spray/pepper(src)
	src.modules += new /obj/item/gripper/security(src)
	src.emag = new /obj/item/gun/energy/laser/mounted(src)

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
					"Arachne" = "crawler",
					"Cabeiri" = "eyebot-janitor",
					"Haruka" = "marinaJN",
					"Telemachus" = "toiletbotjanitor",
					"WTOperator" = "sleekjanitor",
					"XI-ALP" = "heavyRes",
					"Basic" = "JanBot2",
					"Mopbot"  = "janitorrobot",
					"Mop Gear Rex" = "mopgearrex",
					"Usagi-II" = "tall2janitor",
					"Pyralis" = "Glitterfly-Janitor",
					"Decapod" = "decapod-Janitor",
					"Pneuma" = "pneuma-Janitor",
					"Tower" = "drider-Janitor"
					)

/obj/item/robot_module/robot/janitor/Initialize()

	. = ..()
	if(. != INITIALIZE_HINT_NORMAL)
		return

	src.modules += new /obj/item/soap/nanotrasen(src)
	src.modules += new /obj/item/storage/bag/trash(src)
	src.modules += new /obj/item/mop(src)
	src.modules += new /obj/item/lightreplacer(src)
	src.emag = new /obj/item/reagent_containers/spray(src)
	src.emag.reagents.add_reagent("lube", 250)
	src.emag.name = "Lube spray"

/obj/item/robot_module/robot/janitor/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/lightreplacer/LR = locate() in src.modules
	LR.Charge(R, amount)
	if(src.emag)
		var/obj/item/reagent_containers/spray/S = src.emag
		S.reagents.add_reagent("lube", 2 * amount)

/obj/item/robot_module/robot/clerical
	name = "service robot module"
	display_name = "Service"
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

/obj/item/robot_module/robot/clerical/butler
	display_name = "Butler"
	sprites = list(
					"M-USE NanoTrasen" = "robotServ",
					"Cabeiri" = "eyebot-standard",
					"Haruka" = "marinaSV",
					"Michiru" = "maidbot",
					"Usagi" = "tallgreen",
					"Telemachus" = "toiletbot",
					"WTOperator" = "sleekservice",
					"WTOmni" = "omoikane",
					"XI-GUS" = "spider",
					"XI-ALP" = "heavyServ",
					"Standard" = "Service2",
					"Waitress" = "Service",
					"Bro" = "Brobot",
					"Rich" = "maximillion",
					"Usagi-II" = "tall2service",
					"Pyralis" = "Glitterfly-Service",
					"Decapod" = "decapod-Service",
					"Pneuma" = "pneuma-Service",
					"Tower" = "drider-Service"
				  	)

/obj/item/robot_module/robot/clerical/butler/Initialize()

	. = ..()
	if(. != INITIALIZE_HINT_NORMAL)
		return

	src.modules += new /obj/item/gripper/service(src)
	src.modules += new /obj/item/reagent_containers/glass/bucket(src)
	src.modules += new /obj/item/material/minihoe(src)
	src.modules += new /obj/item/material/knife/machete/hatchet(src)
	src.modules += new /obj/item/analyzer/plant_analyzer(src)
	src.modules += new /obj/item/storage/bag/plants(src)
	src.modules += new /obj/item/robot_harvester(src)
	src.modules += new /obj/item/material/knife(src)
	src.modules += new /obj/item/material/kitchen/rollingpin(src)
	src.modules += new /obj/item/multitool(src) //to freeze trays

	var/obj/item/rsf/M = new /obj/item/rsf(src)
	M.stored_matter = 30
	src.modules += M

	src.modules += new /obj/item/reagent_containers/dropper/industrial(src)

	var/obj/item/flame/lighter/zippo/L = new /obj/item/flame/lighter/zippo(src)
	L.lit = 1
	src.modules += L

	src.modules += new /obj/item/tray/robotray(src)
	src.modules += new /obj/item/reagent_containers/borghypo/service(src)
	src.emag = new /obj/item/reagent_containers/food/drinks/bottle/small/beer(src)

	var/datum/reagents/R = new/datum/reagents(50)
	src.emag.reagents = R
	R.my_atom = src.emag
	R.add_reagent("beer2", 50)
	src.emag.name = "Mickey Finn's Special Brew"

/obj/item/robot_module/robot/clerical/general
	name = "clerical robot module"
	display_name = "Clerical"
	sprites = list(
					"M-USE NanoTrasen" = "robotCler",
					"Cabeiri" = "eyebot-standard",
					"Haruka" = "marinaSV",
					"Usagi" = "tallgreen",
					"Telemachus" = "toiletbot",
					"WTOperator" = "sleekclerical",
					"WTOmni" = "omoikane",
					"XI-GUS" = "spidercom",
					"XI-ALP" = "heavyServ",
					"Waitress" = "Service",
					"Bro" = "Brobot",
					"Rich" = "maximillion",
					"Default" = "Service2",
					"Usagi-II" = "tall2service",
					"Pyralis" = "Glitterfly-Clerical",
					"Decapod" = "decapod-Clerical",
					"Pneuma" = "pneuma-Clerical",
					"Tower" = "drider-Clerical"
					)

/obj/item/robot_module/robot/clerical/general/Initialize()

	. = ..()
	if(. != INITIALIZE_HINT_NORMAL)
		return

	src.modules += new /obj/item/pen/robopen(src)
	src.modules += new /obj/item/form_printer(src)
	src.modules += new /obj/item/gripper/paperwork(src)
	src.modules += new /obj/item/hand_labeler(src)
	src.modules += new /obj/item/stamp(src)
	src.modules += new /obj/item/stamp/denied(src)
	src.emag = new /obj/item/stamp/chameleon(src)
	src.emag = new /obj/item/pen/chameleon(src)

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
					"Cabeiri" = "eyebot-miner",
					"Haruka" = "marinaMN",
					"Telemachus" = "toiletbotminer",
					"WTOperator" = "sleekminer",
					"XI-GUS" = "spidermining",
					"XI-ALP" = "heavyMiner",
					"Basic" = "Miner_old",
					"Advanced Droid" = "droid-miner",
					"Treadhead" = "Miner",
					"Usagi-II" = "tall2miner",
					"Pyralis" = "Glitterfly-Miner",
					"Decapod" = "decapod-Miner",
					"Pneuma" = "pneuma-Miner",
					"Tower" = "drider-Miner"
				)

/obj/item/robot_module/robot/miner/Initialize()

	. = ..()
	if(. != INITIALIZE_HINT_NORMAL)
		return

	src.modules += new /obj/item/borg/sight/material(src)
	src.modules += new /obj/item/tool/wrench/cyborg(src)
	src.modules += new /obj/item/tool/screwdriver/cyborg(src)
	src.modules += new /obj/item/storage/bag/ore(src)
	src.modules += new /obj/item/pickaxe/borgdrill(src)
	src.modules += new /obj/item/storage/bag/sheetsnatcher/borg(src)
	src.modules += new /obj/item/gripper/miner(src)
	src.modules += new /obj/item/mining_scanner(src)
	src.emag = new /obj/item/pickaxe/plasmacutter(src)
	src.emag = new /obj/item/pickaxe/diamonddrill(src)

/obj/item/robot_module/robot/research
	name = "research module"
	display_name = "Research"
	channels = list("Science" = 1)
	sprites = list(
					"L'Ouef" = "peaceborg",
					"Cabeiri" = "eyebot-science",
					"Haruka" = "marinaSCI",
					"WTDove" = "whitespider",
					"WTOperator" = "sleekscience",
					"Droid" = "droid-science",
					"Handy" = "handy-science",
					"Insekt" = "insekt-Sci",
					"Usagi-II" = "tall2peace",
					"Pyralis" = "Glitterfly-Research",
					"Decapod" = "decapod-Research",
					"Pneuma" = "pneuma-Research",
					"Tower" = "drider-Research"
					)

/obj/item/robot_module/robot/research/Initialize()

	. = ..()
	if(. != INITIALIZE_HINT_NORMAL)
		return

	src.modules += new /obj/item/portable_destructive_analyzer(src)
	src.modules += new /obj/item/gripper/research(src)
	src.modules += new /obj/item/gripper/circuit(src)
	src.modules += new /obj/item/gripper/no_use/organ/robotics(src)
	src.modules += new /obj/item/gripper/no_use/mech(src)
	src.modules += new /obj/item/gripper/no_use/loader(src)
	src.modules += new /obj/item/robotanalyzer(src)
	src.modules += new /obj/item/card/robot(src)
	src.modules += new /obj/item/weldingtool/electric/mounted/cyborg(src)
	src.modules += new /obj/item/tool/screwdriver/cyborg(src)
	src.modules += new /obj/item/tool/wrench/cyborg(src)
	src.modules += new /obj/item/tool/wirecutters/cyborg(src)
	src.modules += new /obj/item/multitool(src)
	src.modules += new /obj/item/surgical/scalpel/cyborg(src)
	src.modules += new /obj/item/surgical/circular_saw/cyborg(src)
	src.modules += new /obj/item/reagent_containers/syringe(src)
	src.modules += new /obj/item/reagent_containers/glass/beaker/large(src)
	src.modules += new /obj/item/storage/part_replacer(src)
	src.modules += new /obj/item/shockpaddles/robot/jumper(src)
	src.modules += new /obj/item/melee/baton/slime/robot(src)
	src.modules += new /obj/item/gun/energy/taser/xeno/robot(src)
	src.modules += new /obj/item/xenoarch_multi_tool(src)
	src.modules += new /obj/item/pickaxe/excavationdrill(src)
	src.modules += new /obj/item/cataloguer(src)

	src.emag = new /obj/item/hand_tele(src)

	var/datum/matter_synth/nanite = new /datum/matter_synth/nanite(10000)
	synths += nanite
	var/datum/matter_synth/wire = new /datum/matter_synth/wire()						//Added to allow repairs, would rather add cable now than be asked to add it later,
	synths += wire																		//Cable code, taken from engiborg,

	var/obj/item/stack/nanopaste/N = new /obj/item/stack/nanopaste(src)
	N.uses_charge = 1
	N.charge_costs = list(1000)
	N.synths = list(nanite)
	src.modules += N

	var/obj/item/stack/cable_coil/cyborg/C = new /obj/item/stack/cable_coil/cyborg(src)	//Cable code, taken from engiborg,
	C.synths = list(wire)
	src.modules += C

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
					"Haruka" = "marinaCB",
					"Combat Android" = "droid-combat",
					"Insekt" = "insekt-Combat",
					"Decapod" = "decapod-Combat"
					)

/obj/item/robot_module/robot/security/combat/Initialize()

	. = ..()
	if(. != INITIALIZE_HINT_NORMAL)
		return

	src.modules += new /obj/item/flash(src)
	src.modules += new /obj/item/borg/sight/thermal(src)
	src.modules += new /obj/item/gun/energy/laser/mounted(src)
	src.modules += new /obj/item/pickaxe/plasmacutter(src)
	src.modules += new /obj/item/borg/combat/shield(src)
	src.modules += new /obj/item/borg/combat/mobility(src)
	src.emag = new /obj/item/gun/energy/lasercannon/mounted(src)


/* Drones */

/obj/item/robot_module/drone
	name = "drone module"
	unavailable_by_default = TRUE
	hide_on_manifest = TRUE
	no_slip = TRUE
	networks = list(NETWORK_ENGINEERING)

/obj/item/robot_module/drone/Initialize(var/ml)

	. = ..()
	if(. != INITIALIZE_HINT_NORMAL)
		return

	src.modules += new /obj/item/borg/sight/meson(src)
	src.modules += new /obj/item/weldingtool/electric/mounted/cyborg(src)
	src.modules += new /obj/item/tool/screwdriver/cyborg(src)
	src.modules += new /obj/item/tool/wrench/cyborg(src)
	src.modules += new /obj/item/tool/crowbar/cyborg(src)
	src.modules += new /obj/item/tool/wirecutters/cyborg(src)
	src.modules += new /obj/item/t_scanner(src)
	src.modules += new /obj/item/multitool(src)
	src.modules += new /obj/item/lightreplacer(src)
	src.modules += new /obj/item/gripper(src)
	src.modules += new /obj/item/soap(src)
	src.modules += new /obj/item/gripper/no_use/loader(src)
	src.modules += new /obj/item/extinguisher(src)
	src.modules += new /obj/item/pipe_painter(src)
	src.modules += new /obj/item/floor_painter(src)

	var/mob/living/silicon/robot/robit = loc
	robit.internals = new/obj/item/tank/jetpack/carbondioxide(src)
	src.modules += robit.internals

	src.emag = new /obj/item/pickaxe/plasmacutter(src)
	src.emag.name = "Plasma Cutter"

	var/datum/matter_synth/metal = new /datum/matter_synth/metal(25000)
	var/datum/matter_synth/glass = new /datum/matter_synth/glass(25000)
	var/datum/matter_synth/wood = new /datum/matter_synth/wood(25000)
	var/datum/matter_synth/plastic = new /datum/matter_synth/plastic(25000)
	var/datum/matter_synth/wire = new /datum/matter_synth/wire(30)
	synths += metal
	synths += glass
	synths += wood
	synths += plastic
	synths += wire

	var/obj/item/matter_decompiler/MD = new /obj/item/matter_decompiler(src)
	MD.metal = metal
	MD.glass = glass
	MD.wood = wood
	MD.plastic = plastic
	src.modules += MD

	var/obj/item/stack/material/cyborg/steel/M = new (src)
	M.synths = list(metal)
	src.modules += M

	var/obj/item/stack/material/cyborg/glass/G = new (src)
	G.synths = list(glass)
	src.modules += G

	var/obj/item/stack/rods/cyborg/R = new /obj/item/stack/rods/cyborg(src)
	R.synths = list(metal)
	src.modules += R

	var/obj/item/stack/cable_coil/cyborg/C = new /obj/item/stack/cable_coil/cyborg(src)
	C.synths = list(wire)
	src.modules += C

	var/obj/item/stack/tile/floor/cyborg/S = new /obj/item/stack/tile/floor/cyborg(src)
	S.synths = list(metal)
	src.modules += S

	var/obj/item/stack/material/cyborg/glass/reinforced/RG = new (src)
	RG.synths = list(metal, glass)
	src.modules += RG

	var/obj/item/stack/tile/wood/cyborg/WT = new /obj/item/stack/tile/wood/cyborg(src)
	WT.synths = list(wood)
	src.modules += WT

	var/obj/item/stack/material/cyborg/wood/W = new (src)
	W.synths = list(wood)
	src.modules += W

	var/obj/item/stack/material/cyborg/plastic/P = new (src)
	P.synths = list(plastic)
	src.modules += P

	src.modules += new /obj/item/pipe_dispenser(src)	// At the end to go beside the construction's RCD.

/obj/item/robot_module/drone/construction
	name = "construction drone module"
	hide_on_manifest = TRUE
	channels = list("Engineering" = 1)
	languages = list()

/obj/item/robot_module/drone/construction/Initialize()

	. = ..()
	if(. != INITIALIZE_HINT_NORMAL)
		return

	src.modules += new /obj/item/rcd/electric/mounted/borg/lesser(src)

/obj/item/robot_module/drone/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/lightreplacer/LR = locate() in src.modules
	LR.Charge(R, amount)
	..()
	return

/obj/item/robot_module/drone/mining
	name = "miner drone module"
	channels = list("Supply" = 1)
	networks = list(NETWORK_MINE)

/obj/item/robot_module/drone/mining/Initialize()

	. = ..()
	if(. != INITIALIZE_HINT_NORMAL)
		return

	src.modules += new /obj/item/borg/sight/material(src)
	src.modules += new /obj/item/pickaxe/borgdrill(src)
	src.modules += new /obj/item/storage/bag/ore(src)
	src.modules += new /obj/item/storage/bag/sheetsnatcher/borg(src)
	src.emag = new /obj/item/pickaxe/diamonddrill(src)
