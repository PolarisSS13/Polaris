/****************
* Debug Support *
****************/
GLOBAL_DATUM_INIT(all_observable_events, datum/all_observable_events, new ))

/datum/all_observable_events
	var/list/events

/datum/all_observable_events/New()
	events = list()
	..()
