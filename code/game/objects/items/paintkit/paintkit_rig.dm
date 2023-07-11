
/obj/item/kit/rig
	name = "rig modification kit"
	desc = "A kit for modifying a rigsuit."
	uses = 1
	accepted_refit_types = list(/obj/item/rig)

/obj/item/kit/rig/debug/Initialize()
	. = ..()
	set_info("debug suit", "This is a test", "debug", CUSTOM_ITEM_OBJ, CUSTOM_ITEM_MOB)
