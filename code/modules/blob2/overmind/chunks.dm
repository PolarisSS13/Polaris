
// Blob Type Modification to allow for chunks. //

/datum/blob_type
	var/list/core_tech = list(TECH_BIO = 4, TECH_MATERIAL = 3)	// Tech for the item created when a core is destroyed.

	var/chunk_type = /obj/item/blob_chunk
	var/chunk_effect_cooldown = 10
	var/chunk_effect_range = 1	// Tile range of the effect.

	var/generation = 0	// How many times has this blob been chunked

/datum/blob_type/proc/make_chunk(var/turf/T)
	if(!T)
		return

	if(ispath(chunk_type, /obj/item/blob_chunk))
		return new chunk_type(T, listify_vars())

	return new chunk_type(T)

// Base chunk. //

/obj/item/blob_chunk
	name = "chunk"
	desc = "A piece of a blob's core."

	description_info = "Blob core chunks can be 'revived' with the help of Xenobio. \
	40 units of Blood, 40 units of Phoron, and 10 units of Slime Jelly will cause the chunk \
	to produce a new core on the turf it is on. The chunk remains, but unable to produce another. \
	You can change the faction of the blob created pre-emptively by using the chunk on a mob, imprinting \
	its faction upon the chunk."

	icon = 'icons/mob/blob.dmi'
	icon_state = "blobcore"

	unacidable = TRUE

	var/can_revive = TRUE

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

	name = "[blob_type_vars["name"]] [initial(name)]"

	AddComponent(blob_effect_master_type)

/obj/item/blob_chunk/is_open_container()
	return TRUE

/obj/item/blob_chunk/afterattack(var/atom/target, var/mob/user, var/proximity)
	if(proximity && Adjacent(target))
		user.visible_message(SPAN_WARNING("[user] holds \the [src] toward [target]."))
		if(isliving(target) && do_after(user, 3 SECONDS, target))
			var/mob/living/L = target

			user.visible_message(SPAN_WARNING("[bicon(src)] \the [src] inflates slighty, before it releases a puff of gas toward [L]."))
			to_chat(user, SPAN_NOTICE("[bicon(src)] [src] has registered \the [L.faction] pheromone as its own, forgetting \the [blob_type_vars["faction"]] pheromone."))

			blob_type_vars["faction"] = L.faction

	return

/obj/item/blob_chunk/proc/reviveBlob(var/ask_player = FALSE)
	var/turf/T = get_turf(src)

	var/obj/structure/blob/core/C = new(T, null, 2, 0)

	C.desired_blob_type = blob_type_vars["blob_type"]
	C.create_overmind()

	var/datum/blob_type/to_modify = C.overmind.blob_type
	to_modify.apply_vars(blob_type_vars)

	C.update_icon()

	if(!can_revive)
		name = "weakened [name]"
		desc += " It can no longer reproduce."

	if(C?.overmind)
		return TRUE

	return

// Artifact master solely for blobs. //

/datum/component/artifact_master/blob
	make_effects = list(
		/datum/artifact_effect/uncommon/fortify
	)

/datum/component/artifact_master/blob/do_setup()
	..()
	if(istype(holder, /obj/item/blob_chunk))
		var/obj/item/blob_chunk/type_source = holder

		for(var/datum/artifact_effect/AE in my_effects)
			AE.trigger = TRIGGER_TOUCH
			AE.effect = EFFECT_PULSE
			AE.effectrange = type_source.blob_type_vars["chunk_effect_range"]
			AE.chargelevelmax = type_source.blob_type_vars["chunk_effect_cooldown"]
