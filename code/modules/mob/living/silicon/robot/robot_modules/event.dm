/* Other, unaffiliated modules */

// The module that borgs on the surface have.  Generally has a lot of useful tools in exchange for questionable loyalty to the crew.
/obj/item/robot_module/robot/lost
	name = "lost robot module"
	display_name = "Unregistered"
	module_category = ROBOT_MODULE_TYPE_FLYING
	unavailable_by_default = TRUE
	hide_on_manifest = TRUE
	sprites = list(
		"Drone" = "drone-lost"
	)
	modules = list(
		/obj/item/melee/baton/shocker/robot,
		/obj/item/handcuffs/cyborg,
		/obj/item/borg/combat/shield,
		/obj/item/healthanalyzer,
		/obj/item/reagent_containers/borghypo/lost,
		/obj/item/weldingtool/electric/mounted,
		/obj/item/tool/screwdriver/cyborg,
		/obj/item/tool/wrench/cyborg,
		/obj/item/tool/wirecutters/cyborg,
		/obj/item/multitool,
		/obj/item/robotanalyzer,
		/obj/item/stack/cable_coil/cyborg
	)
	emag = /obj/item/gun/energy/retro/mounted
	synths = list(
		/datum/matter_synth/wire
	)

/obj/item/robot_module/robot/lost/finalize_synths()
	. = ..()
	var/datum/matter_synth/wire/wire = locate() in synths
	var/obj/item/stack/cable_coil/cyborg/C = locate() in modules
	C.synths = list(wire)

/obj/item/robot_module/robot/gravekeeper
	name = "gravekeeper robot module"
	display_name = "Gravekeeper"
	unavailable_by_default = TRUE
	hide_on_manifest = TRUE
	sprites = list(
		"Gravekeeper" = "sleek-gravekeeper"
	)
	modules = list(
		/obj/item/melee/baton/shocker/robot,
		/obj/item/borg/combat/shield,
		/obj/item/weldingtool/electric/mounted,
		/obj/item/tool/screwdriver/cyborg,
		/obj/item/tool/wrench/cyborg,
		/obj/item/material/minihoe,
		/obj/item/material/knife/machete/hatchet,
		/obj/item/analyzer/plant_analyzer,
		/obj/item/storage/bag/plants,
		/obj/item/robot_harvester,
		/obj/item/shovel,
		/obj/item/gripper/gravekeeper
	)
	emag = /obj/item/gun/energy/retro/mounted
	synths = list(
		/datum/matter_synth/wood = 25000
	)

/obj/item/robot_module/robot/gravekeeper/finalize_synths()
	. = ..()
	var/datum/matter_synth/wood/wood = locate() in synths
	var/obj/item/stack/material/cyborg/wood/W = locate() in modules
	W.synths = list(wood)
	src.modules += W
