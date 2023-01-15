/obj/item/robot_module/flying/cultivator
	name = "cultivator drone module"
	display_name = "Cultivator"
	channels = list(
		"Science" = TRUE,
		"Service" = TRUE
	)
	sprites = list("Drone" = "drone-hydro")

	equipment = list(
		/obj/item/storage/bag/plants,
		/obj/item/tool/wirecutters/clippers,
		/obj/item/material/minihoe,
		/obj/item/material/knife/machete/hatchet,
		/obj/item/reagent_containers/glass/bucket,
		/obj/item/surgical/scalpel/laser1,
		/obj/item/surgical/circular_saw,
		/obj/item/extinguisher,
		/obj/item/gripper/cultivator,
		/obj/item/analyzer/plant_analyzer,
		/obj/item/robot_harvester
	)
	emag = /obj/item/melee/energy/sword
