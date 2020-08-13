#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/weapon/circuitboard/pipelayer
	name = T_BOARD("pipe layer")
	build_path = /obj/machinery/pipelayer
	board_type = new /datum/frame/frame_types/machine
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)
	req_components = list(
							/obj/item/weapon/stock_parts/motor = 1,
							/obj/item/weapon/stock_parts/gear = 1,
							/obj/item/weapon/stock_parts/matter_bin = 1)

/obj/item/weapon/circuitboard/metal_detector
	name = T_BOARD("Metal Detector")
	build_path = /obj/machinery/metal_detector
	board_type = "machine"
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 3)
	req_components = list(
							/obj/item/weapon/stock_parts/scanning_module = 3,
							/obj/item/weapon/stock_parts/console_screen = 1)