SUBSYSTEM_DEF(SSinstruments)
	name = "Instruments"
	wait = 0.5
	priority = FIRE_PRIORITY_INSTRUMENTS
	flags = SS_NO_TICK_CHECK
	var/list/datum/instrument/instrument_data = list()		//id = datum
	var/list/datum/song/songs = list()

/datum/controller/subsystem/instruments/Initialize()
	initialize_instrument_data()

/datum/controller/subsystem/instruments/proc/on_song_new(datum/song/S)
	songs += S

/datum/controller/subsystem/instruments/proc/on_song_del(datum/song/S)
	songs -= S

/datum/controller/subsystem/instruments/proc/initialize_instrument_data()
	for(var/path in subtypesof(/datum/instrument))
		var/datum/instrument/I = path
		if(initial(I.abstract_type) == path)
			continue
		if(istext(initial(I.id)))
			continue
		I = new
		instrument_data[I.id] = I
	for(var/id in instrument_data)
		var/datum/instrument/I = instrument_data[id]
		I.Initialize()
		CHECK_TICK
