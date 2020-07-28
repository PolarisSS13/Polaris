
/obj/item/hose_connector
	name = "hose connector"
	desc = "A socket for a hose. It.. doesn't do anything on its own."

	var/obj/carrier = null

	var/flow_direction = HOSE_NEUTRAL

	var/datum/hose/my_hose = null

/obj/item/hose_connector/Destroy()
	if(my_hose)
		my_hose.disconnect()
		my_hose = null
	if(carrier)
		carrier = null
	..()

/obj/item/hose_connector/Initialize()
	..()

	create_reagents(100)

	if(!istype(loc, /turf))
		name = "[flow_direction] hose connector ([loc])"

/obj/item/hose_connector/proc/valid_connection(var/obj/item/hose_connector/C)
	if(istype(C))
		if(C.my_hose)
			return FALSE

		if(C.flow_direction in list(HOSE_INPUT, HOSE_OUTPUT) - flow_direction)
			return TRUE

	return FALSE

/obj/item/hose_connector/proc/disconnect()
	my_hose = null

/obj/item/hose_connector/proc/connect(var/datum/hose/H = null)
	if(istype(H))
		my_hose = H

/obj/item/hose_connector/proc/setup_hoses(var/obj/item/hose_connector/target)
	if(target)
		var/datum/hose/H = new()

		H.set_hose(src, target)

/obj/item/hose_connector/proc/get_pairing()
	if(my_hose)
		return my_hose.get_pairing(src)

	return

/*
 * Subtypes
 */

/obj/item/hose_connector/input
	name = "hose input"
	flow_direction = HOSE_INPUT

/obj/item/hose_connector/input/active
	name = "active hose"

/obj/item/hose_connector/input/active/Destroy()
	STOP_PROCESSING(SSobj, src)
	..()

/obj/item/hose_connector/input/active/Initialize()
	..()
	START_PROCESSING(SSobj, src)

/obj/item/hose_connector/input/active/process()
	if(carrier)
		reagents.trans_to_obj(carrier, reagents.maximum_volume)

/obj/item/hose_connector/output
	name = "hose output"
	flow_direction = HOSE_OUTPUT

/obj/item/hose_connector/output/active
	name = "active hose"

/obj/item/hose_connector/output/active/Destroy()
	STOP_PROCESSING(SSobj, src)
	..()

/obj/item/hose_connector/output/active/Initialize()
	..()
	START_PROCESSING(SSobj, src)

/obj/item/hose_connector/output/active/process()
	if(carrier)
		carrier.reagents.trans_to_holder(reagents, reagents.maximum_volume)
