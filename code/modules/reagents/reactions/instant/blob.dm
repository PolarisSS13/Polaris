
// Reactions for Blob Chunks. //

/decl/chemical_reaction/instant/blob_chunk_revival
	name = "Blob Chunk Revival"
	id = "blob_revival"
	result = null
	required_reagents = list("blood" = 40, "phoron" = 40, "slimejelly" = 10)
	result_amount = 1

/decl/chemical_reaction/instant/blob_chunk_revival/can_happen(var/datum/reagents/holder)
	if(holder.my_atom && istype(holder.my_atom, /obj/item/blob_chunk))
		return ..()
	return FALSE

/decl/chemical_reaction/instant/blob_chunk_revival/on_reaction(var/datum/reagents/holder)
	var/obj/item/blob_chunk/chunk = holder.my_atom
	if(chunk.can_revive)
		chunk.can_revive = FALSE
		chunk.reviveBlob()
