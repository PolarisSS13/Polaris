#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

//Circuitboards for frames.  Most of these don't fit into other categories.

/obj/item/weapon/circuitboard/status_display
	name = T_BOARD("status display")
	build_path = /obj/machinery/status_display
	board_type = "display"
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)

/obj/item/weapon/circuitboard/ai_status_display
	name = T_BOARD("ai status display")
	build_path = /obj/machinery/ai_status_display
	board_type = "display"
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)

/obj/item/weapon/circuitboard/newscaster
	name = T_BOARD("newscaster")
	build_path = /obj/machinery/newscaster
	board_type = "display"
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)

/obj/item/weapon/circuitboard/firealarm
	name = T_BOARD("fire alarm")
	build_path = /obj/machinery/firealarm
	board_type = "alarm"
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)

/obj/item/weapon/circuitboard/airalarm
	name = T_BOARD("air alarm")
	build_path = /obj/machinery/alarm
	board_type = "alarm"
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)