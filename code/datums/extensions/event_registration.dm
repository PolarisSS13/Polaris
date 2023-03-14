// For registering for events to be called when certain conditions are met.

/datum/extension/event_registration
	base_type = /datum/extension/event_registration
	expected_type = /datum
	flags = EXTENSION_FLAG_IMMEDIATE
	var/decl/observ/event
	var/datum/target
	var/callproc

/datum/extension/event_registration/New(datum/holder, decl/observ/event, datum/target, callproc)
	..()
	event.register(target, src, .proc/trigger)
	GLOB.destroyed_event.register(target, src, .proc/qdel_self)

	src.event = event
	src.target = target
	src.callproc = callproc

/datum/extension/event_registration/Destroy()
	GLOB.destroyed_event.unregister(target, src, .proc/qdel_self)
	event.unregister(target, src)
	. = ..()

/datum/extension/event_registration/proc/trigger()
	call(holder, callproc)(arglist(args))
