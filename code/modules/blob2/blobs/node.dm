GLOBAL_LIST_EMPTY(blob_nodes)

/obj/structure/blob/node
	name = "blob node"
	base_name = "node"
	icon_state = "blank_blob"
	desc = "A large, pulsating yellow mass."
	max_integrity = 50
	health_regen = 3
	point_return = 50

/obj/structure/blob/node/New(var/newloc)
	..()
	blob_nodes += src
	processing_objects += src
	update_icon()

/obj/structure/blob/node/Destroy()
	blob_nodes -= src
	processing_objects -= src
	return ..()

/obj/structure/blob/node/update_icon()
	overlays.Cut()
	color = null
	var/mutable_appearance/blob_overlay = mutable_appearance('icons/mob/blob.dmi', "blob")
	if(overmind)
		name = "[overmind.blob_type.name] [base_name]"
		blob_overlay.color = overmind.blob_type.color
	overlays += blob_overlay
	overlays += mutable_appearance('icons/mob/blob.dmi', "blob_node_overlay")

/obj/structure/blob/node/process()
	set waitfor = FALSE
	if(overmind) // This check is so that if the core is killed, the nodes stop.
		pulse_area(overmind, 10, BLOB_NODE_PULSE_RANGE, BLOB_NODE_EXPAND_RANGE)