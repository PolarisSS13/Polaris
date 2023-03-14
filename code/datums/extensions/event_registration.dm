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
	events_repository.register(/decl/observ/destroyed, target, src, .proc/qdel_self)
	src.event = event
	src.target = target
	src.callproc = callproc

/datum/extension/event_registration/Destroy()
	events_repository.unregister(/decl/observ/destroyed, target, src)
	event.unregister(target, src)
	. = ..()

/datum/extension/event_registration/proc/trigger()
	call(holder, callproc)(arglist(args))
