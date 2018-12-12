#define RAD_GEIGER_LOW 0.1							// Geiger counter sound thresholds
#define RAD_GEIGER_MEDIUM 10
#define RAD_GEIGER_HIGH 25

/datum/looping_sound/geiger
	mid_sounds = list(
		list('sound/items/geiger/new/low1.ogg'=1, 'sound/items/geiger/new/low2.ogg'=1, 'sound/items/geiger/new/low3.ogg'=1, 'sound/items/geiger/new/low4.ogg'=1),
		list('sound/items/geiger/new/med1.ogg'=1, 'sound/items/geiger/new/med2.ogg'=1, 'sound/items/geiger/new/med3.ogg'=1, 'sound/items/geiger/new/med4.ogg'=1),
		list('sound/items/geiger/new/high1.ogg'=1, 'sound/items/geiger/new/high2.ogg'=1, 'sound/items/geiger/new/high3.ogg'=1, 'sound/items/geiger/new/high4.ogg'=1),
		list('sound/items/geiger/new/ext1.ogg'=1, 'sound/items/geiger/new/ext2.ogg'=1, 'sound/items/geiger/new/ext3.ogg'=1, 'sound/items/geiger/new/ext4.ogg'=1)
		)
	mid_length = 1 SECOND
	volume = 25
	var/last_radiation

/datum/looping_sound/geiger/get_sound(starttime)
	var/danger
	switch(last_radiation)
		if(0 to RAD_GEIGER_LOW)
			danger = 1
		if(RAD_GEIGER_LOW to RAD_GEIGER_MEDIUM)
			danger = 2
		if(RAD_GEIGER_MEDIUM to RAD_GEIGER_HIGH)
			danger = 3
		if(RAD_GEIGER_HIGH to INFINITY)
			danger = 4
		else
			return null
	return ..(starttime, mid_sounds[danger])

/datum/looping_sound/geiger/stop()
	. = ..()
	last_radiation = 0

#undef RAD_GEIGER_LOW
#undef RAD_GEIGER_MEDIUM
#undef RAD_GEIGER_HIGH