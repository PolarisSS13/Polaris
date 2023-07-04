
// Blob Type Modification//

/datum/blob_type
	var/list/core_tech = list(TECH_BIO = 4, TECH_MATERIAL = 3)	// Tech for the item created when a core is destroyed.

	var/chunk_master = /datum/component/artifact_master/blob
	var/chunk_effect_cooldown = 20 SECONDS				// Cooldown (if applicable) for the blob's artifact effect.
	var/chunk_effect_range = 1	// Tile range of the effect.

	var/generation = 0	// How many times has this blob been chunked

/datum/blob_type/proc/make_chunk(var/turf/T)
	if(!T)
		return

	return new /obj/item/blob_chunk(T, create_descendant())

// Base artifact master for chunks. //

/obj/item/blob_chunk
	name = "chunk"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blobcore"

	var/datum/blob_type/blob_type

/obj/item/blob_chunk/Initialize(var/newloc, var/datum/blob_type/new_type)
	. = ..()

	create_reagents(120)

	if(ispath(blob_type))
		blob_type = new()

	if(new_type)
		if(!ispath(new_type))
			blob_type = new_type
		else
			blob_type = new new_type()

	if(istype(blob_type))
		if(ispath(blob_type.chunk_master, /datum/component/artifact_master))
			AddComponent(blob_type.chunk_master)

		name = "[blob_type.name] [initial(name)]"
		color = blob_type.color
		origin_tech = blob_type.core_tech.Copy()

// Artifact master solely for blobs. //

/datum/component/artifact_master/blob
	make_effects = list(
		/datum/artifact_effect/uncommon/fortify
	)

/datum/component/artifact_master/blob/do_setup()
	..()
	if(holder && istype(holder, /obj/item/blob_chunk))
		var/obj/item/blob_chunk/type_source = holder
		var/datum/blob_type/effect_source = type_source.blob_type

		for(var/datum/artifact_effect/AE in my_effects)
			AE.trigger = TRIGGER_TOUCH
			AE.effect = EFFECT_PULSE
			AE.effectrange = effect_source.chunk_effect_range
			AE.chargelevelmax = (effect_source.chunk_effect_cooldown / 1 SECOND)
