
// Blob Type Modification to allow for chunks. //

/datum/blob_type
	var/list/core_tech = list(TECH_BIO = 4, TECH_MATERIAL = 3)	// Tech for the item created when a core is destroyed.

	var/chunk_type = /obj/item/blob_chunk
	var/chunk_effect_cooldown = 20 SECONDS				// Cooldown (if applicable) for the blob's artifact effect.
	var/chunk_effect_range = 1	// Tile range of the effect.

	var/generation = 0	// How many times has this blob been chunked

/datum/blob_type/proc/make_chunk(var/turf/T)
	if(!T)
		return

	return new /obj/item/blob_chunk(T, listify_vars())

// Base chunk. //

/obj/item/blob_chunk
	name = "chunk"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blobcore"

	var/list/blob_type_vars

	var/datum/blob_type/default_blob = /datum/blob_type/classic

	var/blob_effect_master_type = /datum/component/artifact_master/blob

/obj/item/blob_chunk/Initialize(var/newloc, var/list/transfer_vars)
	. = ..()

	create_reagents(120)

	if(!transfer_vars)
		default_blob = new default_blob()
		transfer_vars = default_blob.listify_vars()

	blob_type_vars = transfer_vars
	color = transfer_vars["color"]

	AddComponent(blob_effect_master_type)

/obj/item/blob_chunk/proc/reviveBlob(var/ask_player = FALSE)
	var/turf/T = get_turf(src)

	var/obj/structure/blob/core/C = new(T, null, 2, 0)

	C.desired_blob_type = blob_type_vars["blob_type"]

	C.create_overmind()

	var/datum/blob_type/to_modify = C.overmind.blob_type

	to_modify.apply_vars(blob_type_vars)

// Artifact master solely for blobs. //

/datum/component/artifact_master/blob
	make_effects = list(
		/datum/artifact_effect/uncommon/fortify
	)

/datum/component/artifact_master/blob/do_setup()
	..()
	if(holder && istype(holder, /obj/item/blob_chunk))
		var/obj/item/blob_chunk/type_source = holder

		for(var/datum/artifact_effect/AE in my_effects)
			AE.trigger = TRIGGER_TOUCH
			AE.effect = EFFECT_PULSE
			AE.effectrange = type_source.blob_type_vars["chunk_effect_range"]
			AE.chargelevelmax = (type_source.blob_type_vars["chunk_effect_cooldown"] / 1 SECOND)
