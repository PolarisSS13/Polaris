// This stores information for SSMapping to load maps when the SS inits.
/obj/effect/landmark/poi_position
	name = "Point of Interest Loader"
	var/submap_path = null

INITIALIZE_IMMEDIATE(/obj/effect/landmark/poi_position)

/obj/effect/landmark/poi_position/Initialize(mapload)
	to_world_log("Initialize() called on [name] ([type]).")
	SSmapping.static_poi_landmarks += src
	return ..()

/obj/effect/landmark/poi_position/Destroy()
	SSmapping.static_poi_landmarks -= src
	return ..()

/obj/effect/landmark/poi_position/proc/get_submap_template()
	return new submap_path()


/obj/effect/landmark/poi_position/random_subtype/get_submap_template()
	var/list/subtypes = subtypesof(submap_path)
	var/type_picked = pick(subtypes)
	var/datum/map_template/template = new type_picked()
	return template


/obj/effect/landmark/poi_position/random
	var/list/possible_submap_paths = list()

/obj/effect/landmark/poi_position/random/get_submap_template()
	var/chosen_path = pick(possible_submap_paths)
	return new chosen_path()