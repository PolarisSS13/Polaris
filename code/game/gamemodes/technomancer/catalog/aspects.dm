// A simple datum used to hold a few values regarding technomancer aspects.

GLOBAL_LIST_INIT(technomancer_aspects, build_technomancer_aspect_list())

/proc/build_technomancer_aspect_list()
	. = list()
	for(var/t in subtypesof(/datum/technomancer_aspect))
		var/datum/technomancer_aspect/aspect = new t()
		.[aspect.name] = aspect

/datum/technomancer_aspect
	var/name = null
	var/icon_state = null // An icon_state to use from a icon of aspects.
	var/primary_color = null // A 'bright' color used in UIs.
	var/secondary_color = null // A less bright color similar to above.

/datum/technomancer_aspect/fire
	name = ASPECT_FIRE
	primary_color = "#FF6262" // Darkish red.
	secondary_color = "#C40000" // Lighter red.

/datum/technomancer_aspect/frost
	name = ASPECT_FROST

/datum/technomancer_aspect/shock
	name = ASPECT_SHOCK
	primary_color = "#FFDD66" // Yellow but not eye-bleeding.
	secondary_color = "#FFEE88" // Lighter version of above.

/datum/technomancer_aspect/air
	name = ASPECT_AIR

/datum/technomancer_aspect/tele
	name = ASPECT_TELE
	primary_color = "#FF99FF"
	secondary_color = "#FF33FF"

/datum/technomancer_aspect/force
	name = ASPECT_FORCE
	primary_color = "#66EEEE"
	secondary_color = "#00CCFF"

/datum/technomancer_aspect/dark
	name = ASPECT_DARK

/datum/technomancer_aspect/light
	name = ASPECT_LIGHT

/datum/technomancer_aspect/bio
	name = ASPECT_BIOMED

/datum/technomancer_aspect/emp
	name = ASPECT_EMP

/datum/technomancer_aspect/unstable
	name = ASPECT_UNSTABLE

/datum/technomancer_aspect/chromatic
	name = ASPECT_CHROMATIC

/datum/technomancer_aspect/unholy // For cult stuff.
	name = ASPECT_UNHOLY