// This causes PoI maps to get 'checked' and compiled, when undergoing a unit test.
// This is so Travis can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.
// When adding a new PoI, please add it to this list.
#if MAP_TEST
// #define "your_map_here.dmm"
#include banish_void.dmm
#endif

/datum/map_template/special
	name = "Special Submap Template"
	desc = "A map template base that should not be spawned randomly."


/datum/map_template/special/banish_void
	name = "Banish Void"
	desc = "Where people who get banished by technomancers go for a brief period of time."
	mappath = 'maps/submaps/special_submaps/banish_void.dmm'