// Essentially just a wrapper for /decl/observ to preserve init order/make sure they aren't new'd at runtime.

var/global/repository/events/events_repository = new

/repository/events/proc/raise_event(var/event_type)
	var/decl/observ/event = GET_DECL(event_type)
	if(event)
		event.raise_event(arglist(args.Copy(2)))

/repository/events/proc/register(var/event_type, var/datum/event_source, var/datum/listener, var/proc_call)
	var/decl/observ/event = GET_DECL(event_type)
	if(event)
		event.register(event_source, listener, proc_call)

/repository/events/proc/unregister(var/event_type, var/datum/event_source, var/datum/listener, var/proc_call)
	var/decl/observ/event = GET_DECL(event_type)
	if(event)
		event.unregister(event_source, listener, proc_call)

/repository/events/proc/register_global(var/event_type, var/datum/listener, var/proc_call)
	var/decl/observ/event = GET_DECL(event_type)
	if(event)
		event.register_global(listener, proc_call)

/repository/events/proc/unregister_global(var/event_type, var/datum/listener, var/proc_call)
	var/decl/observ/event = GET_DECL(event_type)
	if(event)
		event.unregister_global(listener, proc_call)
