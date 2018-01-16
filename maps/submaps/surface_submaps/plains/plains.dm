// This causes PoI maps to get 'checked' and compiled, when undergoing a unit test.
// This is so Travis can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.
// When adding a new PoI, please add it to this list.
#if MAP_TEST
#include "farm1.dmm"
#include "construction1.dmm"
#include "camp1.dmm"
#include "house1.dmm"
#endif

/datum/map_template/surface/plains
	name = "Surface Content - Plains"
	desc = "Used to make the surface outside the outpost be 16% less boring."

// To be added: Templates for surface exploration when they are made.

/datum/map_template/surface/plains/farm1
	name = "Farm 1"
	desc = "A small farm tended by a farmbot."
	mappath = 'maps/submaps/surface_submaps/plains/farm1.dmm'
	cost = 10

/datum/map_template/surface/plains/construction1
	name = "Construction Site 1"
	desc = "A structure being built. It seems laziness is not limited to engineers."
	mappath = 'maps/submaps/surface_submaps/plains/construction1.dmm'
	cost = 10

/datum/map_template/surface/plains/camp1
	name = "Camp Site 1"
	desc = "A small campsite, complete with housing and bonfire."
	mappath = 'maps/submaps/surface_submaps/plains/camp1.dmm'
	cost = 10

/datum/map_template/surface/plains/house1
	name = "House 1"
	desc = "A fair sized house out in the frontier, that belonged to a well-traveled explorer."
	mappath = 'maps/submaps/surface_submaps/plains/house1.dmm'
	cost = 10