#define GIB_DATA_TYPE "type"
#define GIB_DATA_AMOUNT "amount"
#define GIB_DATA_DIRECTIONS "directions"

/proc/gibs(atom/location, var/datum/dna/MobDNA, gibber_type = /obj/effect/spawner/gibs/generic, var/fleshcolor, var/bloodcolor)
	new gibber_type(location, MobDNA, fleshcolor, bloodcolor)

/obj/effect/spawner/gibs
	/// If non-null, sparks will be spawned alongside the gibs.
	var/sparks
	/// This is a list of associative lists, each of which is structured as such:
	/// list("type" = typepath, "amount" = amount, "direction" = a list of possible directions)
	/// At spawn, gib decals will be created and moved around according to their list data.
	var/list/gib_types
	/// Determines the color of the "chunky" bits.
	var/flesh_color
	/// Determines the color of the blood.
	/// `blood_color` is a base-level atom var (used for bloody item overlays...!) so we gotta be a bit creative with the name here.
	var/base_color

/obj/effect/spawner/gibs/do_spawn(mapload, datum/dna/dna, flesh_override, blood_override)
	var/turf/T = get_turf(src)
	if (sparks)
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread()
		s.set_up(2, 1, T)
		s.start()
	flesh_color = flesh_override ? flesh_override : flesh_color
	base_color = blood_override ? blood_override : base_color
	for (var/list/L in gib_types)
		var/gib_type = L[GIB_DATA_TYPE]
		var/gib_amount = L[GIB_DATA_AMOUNT] ? gib_type && L[GIB_DATA_AMOUNT] : 0
		var/list/gib_directions = L[GIB_DATA_DIRECTIONS]
		for (var/i in 1 to gib_amount)
			var/obj/effect/decal/cleanable/blood/gibs/G = new gib_type (T)
			if (istype(G))
				if (flesh_color)
					G.fleshcolor = flesh_color
				if (blood_color)
					G.basecolor = blood_color
				G.blood_DNA = list()
				if (dna)
					G.blood_DNA[dna.unique_enzymes] = dna.b_type
				else
					G.blood_DNA["Non-human DNA"] = "A+"
			if (LAZYLEN(gib_directions))
				G.streak(gib_directions)

/obj/effect/spawner/gibs/generic
	gib_types = list(
		list(GIB_DATA_TYPE = /obj/effect/decal/cleanable/blood/gibs, GIB_DATA_AMOUNT = 2, GIB_DATA_DIRECTIONS = list(WEST, NORTHWEST, SOUTHEAST, NORTH)),
		list(GIB_DATA_TYPE = /obj/effect/decal/cleanable/blood/gibs, GIB_DATA_AMOUNT = 2, GIB_DATA_DIRECTIONS = list(EAST, NORTHEAST, SOUTHEAST, SOUTH)),
		list(GIB_DATA_TYPE = /obj/effect/decal/cleanable/blood/gibs/core, GIB_DATA_AMOUNT = 1, GIB_DATA_DIRECTIONS = list()),
	)

/obj/effect/spawner/gibs/human
	gib_types = list(
		list(GIB_DATA_TYPE = /obj/effect/decal/cleanable/blood/gibs, GIB_DATA_AMOUNT = 1, GIB_DATA_DIRECTIONS = list(NORTH, NORTHEAST, NORTHWEST)),
		list(GIB_DATA_TYPE = /obj/effect/decal/cleanable/blood/gibs/down, GIB_DATA_AMOUNT = 1, GIB_DATA_DIRECTIONS = list(SOUTH, SOUTHEAST, SOUTHWEST)),
		list(GIB_DATA_TYPE = /obj/effect/decal/cleanable/blood/gibs, GIB_DATA_AMOUNT = 1, GIB_DATA_DIRECTIONS = list(WEST, NORTHWEST, SOUTHWEST)),
		list(GIB_DATA_TYPE = /obj/effect/decal/cleanable/blood/gibs, GIB_DATA_AMOUNT = 1, GIB_DATA_DIRECTIONS = list(EAST, NORTHEAST, SOUTHEAST)),
		list(GIB_DATA_TYPE = /obj/effect/decal/cleanable/blood/gibs, GIB_DATA_AMOUNT = 1, GIB_DATA_DIRECTIONS = list()),
		list(GIB_DATA_TYPE = /obj/effect/decal/cleanable/blood/gibs/core, GIB_DATA_AMOUNT = 1, GIB_DATA_DIRECTIONS = list()),
	)

/obj/effect/spawner/gibs/human/do_spawn()
	// Introduce an element of randomness; spread some of the decals willy-nilly, have a small range of possible extra bits
	// `alldirs` is not a constant, so we need to manually assign them here before we spawn in the chunks
	if (LAZYLEN(gib_types) >= 6)
		gib_types[4][GIB_DATA_DIRECTIONS] = alldirs
		gib_types[5][GIB_DATA_DIRECTIONS] = alldirs
		gib_types[6][GIB_DATA_AMOUNT] = rand(0, 2)
	return ..()

/obj/effect/spawner/gibs/robot
	sparks = TRUE
	gib_types = list(
		list(GIB_DATA_TYPE = /obj/effect/decal/cleanable/blood/gibs/robot/up, GIB_DATA_AMOUNT = 1, GIB_DATA_DIRECTIONS = list(NORTH, NORTHEAST, NORTHWEST)),
		list(GIB_DATA_TYPE = /obj/effect/decal/cleanable/blood/gibs/robot/down, GIB_DATA_AMOUNT = 1, GIB_DATA_DIRECTIONS = list(SOUTH, SOUTHEAST, SOUTHWEST)),
		list(GIB_DATA_TYPE = /obj/effect/decal/cleanable/blood/gibs/robot, GIB_DATA_AMOUNT = 1, GIB_DATA_DIRECTIONS = list(WEST, NORTHWEST, SOUTHWEST)),
		list(GIB_DATA_TYPE = /obj/effect/decal/cleanable/blood/gibs/robot, GIB_DATA_AMOUNT = 1, GIB_DATA_DIRECTIONS = list(EAST, NORTHEAST, SOUTHEAST)),
		list(GIB_DATA_TYPE = /obj/effect/decal/cleanable/blood/gibs/robot, GIB_DATA_AMOUNT = 1, GIB_DATA_DIRECTIONS = list()),
		list(GIB_DATA_TYPE = /obj/effect/decal/cleanable/blood/gibs/robot/limb, GIB_DATA_AMOUNT = 1, GIB_DATA_DIRECTIONS = list()),
	)

/obj/effect/spawner/gibs/robot/do_spawn()
	if (LAZYLEN(gib_types) >= 6)
		gib_types[4][GIB_DATA_DIRECTIONS] = alldirs
		gib_types[5][GIB_DATA_DIRECTIONS] = alldirs
		gib_types[6][GIB_DATA_AMOUNT] = rand(0, 2)
	return ..()

#undef GIB_DATA_TYPE
#undef GIB_DATA_AMOUNT
#undef GIB_DATA_DIRECTIONS
