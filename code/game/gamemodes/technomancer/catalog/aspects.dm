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
	primary_color = "#FDB768"
	secondary_color = "#FEEEDC"

/datum/technomancer_aspect/frost
	name = ASPECT_FROST
	primary_color = "#DEE9FC"
	secondary_color = "#6395F2"

/datum/technomancer_aspect/shock
	name = ASPECT_SHOCK
	primary_color = "#FEEC86"
	secondary_color = "#FFF9DC"

/datum/technomancer_aspect/air
	name = ASPECT_AIR
	primary_color = "#67AFCB"
	secondary_color = "#E4F1F6"

/datum/technomancer_aspect/tele
	name = ASPECT_TELE
	primary_color = "#F033B4"
	secondary_color = "#FDDEF3"

/datum/technomancer_aspect/force
	name = ASPECT_FORCE
	primary_color = "#678FFE"
	secondary_color = "#DBE5FF"

/datum/technomancer_aspect/dark
	name = ASPECT_DARK

/datum/technomancer_aspect/light
	name = ASPECT_LIGHT
	primary_color = "#CCCCCC"
	secondary_color = "#EEEEEE"

/datum/technomancer_aspect/bio
	name = ASPECT_BIOMED
	primary_color = "#9BD770"
	secondary_color = "#EBF7E3"

/datum/technomancer_aspect/emp
	name = ASPECT_EMP

/datum/technomancer_aspect/unstable
	name = ASPECT_UNSTABLE
	primary_color = "#C91BFE"
	secondary_color = "#F7DBFF"

/datum/technomancer_aspect/chromatic
	name = ASPECT_CHROMATIC

/datum/technomancer_aspect/unholy // For cult stuff.
	name = ASPECT_UNHOLY