/obj/item/rig/mantid
	name = "mantid support exosuit"
	desc = "A powerful support exosuit with integrated power supply, weapons and atmosphere. It's closer to a mech than a rig."
	icon_state = "mantid_rig"
	suit_type = "mantid exosuit"
	species_restricted = list(SPECIES_MANTID)
	slowdown = 0
	offline_slowdown = 1
	equipment_overlay_icon = null
	req_access = list(access_ascent)
	update_visible_name = TRUE
	cell_type = /obj/item/cell/mantid
	air_type = /obj/item/tank/mantid
	armor = list(melee = 70, bullet = 15, laser = 15, energy = 15, bomb = 60, bio = 100, rad = 10)

	initial_modules = list(
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/chem_dispenser/mantid,
		/obj/item/rig_module/device/multitool,
		/obj/item/rig_module/device/cable_coil,
		/obj/item/rig_module/device/welder,
		/obj/item/rig_module/device/clustertool,
		/obj/item/rig_module/device/plasmacutter,
		/obj/item/rig_module/maneuvering_jets
	)

// Renamed blade.
/obj/item/rig_module/mounted/energy_blade/mantid
	name = "nanoblade projector"
	desc = "A fusion-powered blade nanofabricator of mantid design."
	interface_name = "nanoblade projector"
	interface_desc = "A fusion-powered blade nanofabricator of mantid design."
	icon = 'icons/obj/mantid.dmi'
	icon_state = "multitool"
	interface_name = "nanoblade"
	usable = FALSE
	gun = null

// Chem dispenser.
/obj/item/rig_module/chem_dispenser/mantid
	name = "mantid chemical injector"
	desc = "A compact chemical dispenser of mantid design."
	interface_name = "mantid chemical injector"
	interface_desc = "A compact chemical dispenser of mantid design."
	icon = 'icons/obj/mantid.dmi'
	icon_state = "multitool"

/obj/item/rig_module/device/multitool
	name = "mantid integrated multitool"
	desc = "A limited-sentience integrated multitool capable of interfacing with any number of systems."
	interface_name = "multitool"
	interface_desc = "A limited-sentience integrated multitool capable of interfacing with any number of systems."
	device = /obj/item/multitool
	icon = 'icons/obj/mantid.dmi'
	icon_state = "multitool"
	usable = FALSE
	selectable = TRUE

/obj/item/rig_module/device/cable_coil
	name = "mantid cable extruder"
	desc = "A cable nanofabricator of mantid design."
	interface_name = "cable fabricator"
	interface_desc = "A cable nanofabricator of mantid design."
	device = /obj/item/stack/cable_coil/fabricator
	icon = 'icons/obj/mantid.dmi'
	icon_state = "multitool"
	usable = FALSE
	selectable = TRUE

/obj/item/rig_module/device/welder
	name = "mantid welding arm"
	desc = "An electrical cutting torch of mantid design."
	interface_name = "welding arm"
	interface_desc = "An electrical cutting torch of mantid design."
	icon = 'icons/obj/mantid.dmi'
	icon_state = "welder1"
	engage_string = "Toggle Welder"
	device = /obj/item/weldingtool/electric/mantid
	usable = TRUE
	selectable = TRUE

/obj/item/rig_module/device/clustertool
	name = "mantid clustertool"
	desc = "A complex assembly of self-guiding, modular heads capable of performing most manual tasks."
	interface_name = "modular clustertool"
	interface_desc = "A complex assembly of self-guiding, modular heads capable of performing most manual tasks."
	icon = 'icons/obj/mantid.dmi'
	icon_state = "clustertool"
	engage_string = "Select Mode"
	device = /obj/item/clustertool
	usable = TRUE
	selectable = TRUE

/*
/obj/item/rig_module/mounted/flechette_rifle
	name = "flechette rifle"
	desc = "A flechette nanofabricator and launch system of mantid design."
	interface_name = "flechette rifle"
	interface_desc = "A flechette nanofabricator and launch system of mantid design."
	icon = 'icons/obj/mantid.dmi'
	icon_state = "rifle"
	gun = /obj/item/gun/magnetic/railgun/flechette/mantid

/obj/item/rig_module/mounted/particle_rifle
	name = "particle rifle"
	desc = "A mounted particle rifle of mantid design."
	interface_name = "particle rifle"
	interface_desc = "A mounted particle rifle of mantid design."
	icon = 'icons/obj/mantid.dmi'
	icon_state = "rifle"
	gun = /obj/item/gun/energy/particle

*/
