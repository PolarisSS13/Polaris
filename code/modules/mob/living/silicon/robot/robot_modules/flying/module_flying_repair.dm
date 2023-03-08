/obj/item/robot_module/flying/repair
	name = "repair drone module"
	display_name = "Repair"
	channels = list ("Engineering" = TRUE)
	networks = list(NETWORK_ENGINEERING)
	sprites = list(
		"Drone" = "drone-engineer",
		"Eyebot" = "eyebot-engineering"
	)
	modules = list(
		/obj/item/borg/sight/meson,
		/obj/item/extinguisher,
		/obj/item/weldingtool/largetank,
		/obj/item/tool/screwdriver,
		/obj/item/tool/wrench,
		/obj/item/tool/crowbar,
		/obj/item/tool/wirecutters,
		/obj/item/multitool,
		/obj/item/t_scanner,
		/obj/item/analyzer,
		/obj/item/geiger,
		/obj/item/taperoll/engineering,
		/obj/item/taperoll/atmos,
		/obj/item/gripper,
		/obj/item/gripper/no_use/loader,
		/obj/item/lightreplacer,
		/obj/item/floor_painter,
		/obj/item/inflatable_dispenser/robot,
		/obj/item/reagent_containers/spray/cleaner/drone,
		/obj/item/matter_decompiler,
		/obj/item/stack/material/cyborg/steel,
		/obj/item/stack/rods/cyborg,
		/obj/item/stack/tile/floor/cyborg,
		/obj/item/stack/material/cyborg/glass,
		/obj/item/stack/material/cyborg/glass/reinforced,
		/obj/item/stack/cable_coil/cyborg,
		/obj/item/stack/material/cyborg/plasteel
	)
	synths = list(
		/datum/matter_synth/metal = 	30000,
		/datum/matter_synth/glass = 	20000,
		/datum/matter_synth/plasteel = 	10000,
		/datum/matter_synth/wire = 		40
	)
	emag = /obj/item/melee/baton/robot/arm

/obj/item/robot_module/flying/repair/finalize_synths()
	. = ..()
	var/datum/matter_synth/metal/metal =       locate() in synths
	var/datum/matter_synth/glass/glass =       locate() in synths
	var/datum/matter_synth/plasteel/plasteel = locate() in synths
	var/datum/matter_synth/wire/wire =         locate() in synths

	var/obj/item/matter_decompiler/MD = locate() in modules
	MD.metal = metal
	MD.glass = glass

	for(var/thing in list(
		 /obj/item/stack/material/cyborg/steel,
		 /obj/item/stack/rods/cyborg,
		 /obj/item/stack/tile/floor/cyborg,
		 /obj/item/stack/material/cyborg/glass/reinforced
		))
		var/obj/item/stack/stack = locate(thing) in modules
		LAZYDISTINCTADD(stack.synths, metal)

	for(var/thing in list(
		 /obj/item/stack/material/cyborg/glass/reinforced,
		 /obj/item/stack/material/cyborg/glass
		))
		var/obj/item/stack/stack = locate(thing) in modules
		LAZYDISTINCTADD(stack.synths, glass)

	var/obj/item/stack/cable_coil/cyborg/C = locate() in modules
	C.synths = list(wire)

	var/obj/item/stack/material/cyborg/plasteel/PL = locate() in modules
	PL.synths = list(plasteel)
	. = ..()

/obj/item/robot_module/flying/repair/respawn_consumable(mob/living/silicon/robot/R, amount)
	var/obj/item/lightreplacer/LR = locate() in modules
	if(LR)
		LR.Charge(R, amount)
	..()
