/datum/persistent/storage
	entries_expire_at = 1
	entries_decay_at = 0
	entry_decay_weight = 0
	tokens_per_line = PERSISTENCE_VARIABLE_TOKEN_LENGTH
	
	var/max_storage = 0
	var/store_per_type = FALSE // If true, will store up to max_storage for each type stored
	var/target_type = null // Path of the thing that this expects to put stuff into

/datum/persistent/storage/SetFilename()
	if(name)
		filename = "data/persistent/storage/[lowertext(using_map.name)]-[lowertext(name)].txt"

/datum/persistent/storage/LabelTokens(var/list/tokens)
	. = ..()
	.["items"] = list()
	for(var/T in tokens)
		var/list/subtok = splittext(T, " ")
		if(subtok.len != 2)
			continue
		
		var/path = text2path(subtok[1])
		var/num  = text2num( subtok[2])

		// Ensure we've found a token describing the quantity of a path
		if(subtok.len != 2 || \
				!ispath(path) || \
				!isnum(num))
			continue
		
		.["items"][path] = text2num(num)

/datum/persistent/storage/IsValidEntry(var/atom/entry)
	return ..() && istype(entry, target_type)

/datum/persistent/storage/CompileEntry(var/atom/entry)
	. = ..()
	var/stored = max_storage
	var/list/item_list = get_storage_list(entry)
	var/list/storage_list = list()
	for(var/item in item_list)
		storage_list[item] = min(stored, storage_list[item] + item_list[item]) // Can't store more than max_storage
		
		// stored gets reduced by qty stored, if greater than stored,
		// previous assignment will handle overage, and we set to 0
		if(!store_per_type)
			stored = max(stored - item_list[item], 0) 
	
	for(var/item in storage_list)
		. += "[item] [storage_list[item]]"

// Usage: returns list with structure:
//  list(
//      [type1] = [stored_quantity],
//      [type2] = [stored_quantity]
//  )
/datum/persistent/storage/proc/get_storage_list(var/atom/entry)
    return list() // Subtypes define list structure

/datum/persistent/storage/proc/find_specific_instance(var/turf/T)
	return locate(target_type) in T

/datum/persistent/storage/CheckTurfContents(var/turf/T, var/list/tokens)
	return istype(find_specific_instance(T), target_type)

/datum/persistent/storage/proc/generate_items(var/list/L)
	. = list()
	for(var/path in L)
		for(var/i in 1 to L[path])
			. += create_item(path)

/datum/persistent/storage/proc/create_item(var/path)
	return new path()



/datum/persistent/storage/smartfridge/get_storage_list(var/obj/machinery/smartfridge/entry)
	if(!istype(entry))
		return ..()

	. = list()
	for(var/datum/stored_item/I in entry.item_records)
		.[I.item_path] = I.get_amount()

/datum/persistent/storage/smartfridge/CreateEntryInstance(var/turf/creating, var/list/tokens)
	var/obj/machinery/smartfridge/S = find_specific_instance(creating)
	var/list/L = generate_items(tokens["items"])
	for(var/atom/A in L)
		if(S.accept_check(A))
			S.stock(A)
		else
			qdel(A) // Should clean this up here, it couldn't be stocked





/datum/persistent/storage/smartfridge/sheet_storage
	name = "sheet_storage"
	max_storage = 50
	store_per_type = TRUE
	target_type = /obj/machinery/smartfridge/sheets

/datum/persistent/storage/smartfridge/sheet_storage/generate_items(var/list/L)
	. = list()
	for(var/obj/item/stack/material/S as anything in L)
		if(!ispath(S, /obj/item/stack/material))
			log_debug("Warning: Sheet_storage persistent datum tried to create [S]")
			continue

		var/count = L[S]
		while(count > 0)
			S = new S
			S.amount = min(count, S.get_max_amount())
			count -= S.get_amount()
			. += S

/datum/persistent/storage/smartfridge/produce
	name = "fruit_storage"
	max_storage = 20
	store_per_type = FALSE
	target_type = /obj/machinery/smartfridge/produce

/datum/persistent/storage/smartfridge/produce/create_item(var/path)
