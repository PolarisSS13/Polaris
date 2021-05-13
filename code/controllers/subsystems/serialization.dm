SUBSYSTEM_DEF(serialization)
	name = "Serialization"
	init_order = INIT_ORDER_PERSISTENCE // TODO
	flags = SS_NO_FIRE
	var/most_recent_deserialized_data = null
	var/list/weakref/deserialized_objects = list()
	var/persistent_address_ticker = 0

/datum
	var/persistent_address = null // Used to look up deserialized objects, so object references have a chance to be preserved.
	var/forbid_serialization = FALSE // If TRUE, tells the serializer to ignore this object.
	var/serialization_unsupported = FALSE // Will complain if something tries to serialize this and it's TRUE.

/datum/proc/calculate_persistent_address()
	return sha1(list2params(vars) + num2text(world.time) + num2text(SSserialization.persistent_address_ticker++)) // This might need a better way.



/datum/Destroy()
	if(persistent_address)
		SSserialization.deserialized_objects -= persistent_address
	return ..()

// TODO: Potential optimization option by avoiding serializing vars that have not changed from compiletime setting by using initial()
// Would be a disk space optimization at the cost of CPU time.


// Copies information required to recreate a datum object into an associated list.
// The list can be passed to functions that will serialize it into a .json or .sav file.
// You can use getters instead of direct variable reading, if needed.
// When overriding, make sure to call `. = ..()` somewhere inside, so you don't exclude the fundemental variables.
/datum/proc/save_serialized_data(list/_options)
//	SHOULD_CALL_PARENT(TRUE)
	. = list()
	SERIALIZE_VAR_ALWAYS(type)
	SERIALIZE_GETTER_VAR(persistent_address, calculate_persistent_address())

// Applies information from an associative list to this object.
// Generally used when something's getting deserialized.
// You can use setters instead of direct variable assignment, if needed.
// An unfortunate quirk of going with macros is that the input list MUST be named `_data`, which shouldn't conflict with any existing var names.
/datum/proc/load_deserialized_data(list/_data, list/_options)
//	SHOULD_CALL_PARENT(TRUE)
	DESERIALIZE_VAR(persistent_address)

/datum/proc/iterate_deserialized_variables(list/_data, list/_options)
	for(var/variable in _data)
		if(variable == NAMEOF(src, type))
			continue
		to_world("Currently at [variable]. Going to write [_data[variable]].")
		vars[variable] = _data[variable]
	finalize_deserialized_data(_data, _options)

// Might rename to post_deserialize() or something.
/datum/proc/finalize_deserialized_data(list/_options)


/*
/atom/save_serialized_data(list/_options)
    . = ..()
    SERIALIZE_VAR(alpha)
    SERIALIZE_VAR(desc)
    SERIALIZE_VAR(color)

/atom/load_deserialized_data(list/_data, list/_options)
    ..()
    for(var/varname in _data)
      vars[varname] = _data[varname]
    finalize_deserialized_data(_options)

/obj/item/stack/material/finalize_deserialized_data(list/_options)
    if(ispath(material)) // validate
      set_material(material)

*/

// Serializes a specific object to a string.
// Use `write_json(json_string, file_path)` to save the string produced by this to disk.
/datum/controller/subsystem/serialization/proc/object_to_json(datum/object, make_pretty = TRUE, list/options)
	if(isnull(object))
		return
	var/list/data = object.save_serialized_data(options)
	var/json_string = json_encode(data)
	if(make_pretty)
		json_string = pretty_json(json_string)
	return json_string

// Deserializes a string and attempts to recreate the object that had made it.
// Returns the resulting object if successful.
// Use `read_json(file_path)` to get the string that this proc needs.
/datum/controller/subsystem/serialization/proc/json_to_object(json_string, list/options)
	var/list/data = json_decode(json_string)
	if(!istype(data))
		log_debug("DESERIALIZATION: Supplied json string resulted in no data.")
		return
	return deserialize_list(data, options)



/datum/controller/subsystem/serialization/proc/deserialize_list(list/data, list/options)
	var/object_type = data[NAMEOF(src, type)]
	if(!ispath(text2path(object_type)))
		log_debug("DESERIALIZATION: Object type '[object_type]' does not appear to exist.")
		// Consider adding a method to migrate old paths to new ones in some kind of list?
		return
	
	var/datum/object = new object_type()
	var/address = data[NAMEOF(src, persistent_address)]
//	object.load_deserialized_data(data, options)
	object.iterate_deserialized_variables(data, options)
	deserialized_objects[address] = weakref(object)
	most_recent_deserialized_data = data.Copy()
//	process_reference_lookup_queue()
	return object

// File I/O

// Writes a json string to disk, storing it permanently.
// This proc will happily overwrite whatever is in the path, so be aware of that.
/datum/controller/subsystem/serialization/proc/write_json(json_string, file_path)
	var/json_file = file(file_path)
	if(fexists(json_file))
		fdel(json_file) // This stops the file from getting appended, and breaking the json parser.
	//to_file(json_file, json_string)
	text2file(json_string, json_file)

// Reads a json file from disk, retriving the json string contained inside.
/datum/controller/subsystem/serialization/proc/read_json(file_path)
	if(!fexists(file_path))
		CRASH("Tried to open file '[file_path]', but it does not exist or cannot be accessed.")
	
	var/json_file = file(file_path)
	return file2text(json_file)

// Adds some whitespace to make the json formatting easier for humans to read.
// `json_decode()` ignores it so it's purely for the benefit of humans.
// However it will add a small amount of overhead when something is being saved.
// The file size will also be slightly bigger due to the added whitespace.
/datum/controller/subsystem/serialization/proc/pretty_json(json_string)
	// Remove existing whitespace, to avoid double pretty-ifying the string if it contains a json string
	// that was already processed by this proc.
	json_string = replacetext(json_string, "\n", "")
	json_string = replacetext(json_string, "\\n", "")
//	json_string = replacetext(json_string, " ", "")

	var/depth = 0 // How much to indent.
	var/inside_string = FALSE // If it sees an unescaped `"`, don't do anything.
	// This is being done as a list in order to reduce repeatitive concatination, which helps preserve BYOND's super secret string tree.
	var/list/new_json_string_list = list() 
	for(var/i = 1 to length(json_string))
		var/char = copytext(json_string, i, i+1)
		var/string_to_add = char
		switch(char)
			if("\"")
				// If encountering an open or closing apostrophe, check if it's an escaped one. 
				if(!(copytext(json_string, i-1, i) == "\\"))
					inside_string = !inside_string
			if("{", "\[")
				if(!inside_string)
					depth++
					string_to_add = "[char]\n[indent(depth)]"
			if("}", "\]")
				if(!inside_string)
					depth--
					string_to_add = "\n[indent(depth)][char]"
			if(",")
				if(!inside_string)
					string_to_add = "[char]\n[indent(depth)]"
		new_json_string_list += string_to_add
	return new_json_string_list.Join()

// Used for above proc.
/datum/controller/subsystem/serialization/proc/indent(amount)
	if(amount <= 0)
		return null
	for(var/i = 1 to amount)
		. += "    " // Four spaces.

// Returns a duplicate of a serializable object, without writing to disk.
/*
/datum/controller/subsystem/serialization/proc/clone_object(datum/object)
	return json_to_object(object_to_json(object, FALSE))
*/

// Compares two serializable objects, and returns whether or not they are equivalent.
// Equivalence is determined if both objects produced the same data when serialized.
// An exception is `persistent_address`, as two seperate objects will have different values for that (hopefully).
/datum/serialization/proc/compare_objects(datum/A, datum/B)
	var/A_data = A.save_serialized_data()
	var/B_data = B.save_serialized_data()
	for(var/key in A_data)
		if(key == NAMEOF(src, persistent_address))
			continue
		if(A_data[key] != B_data[key])
			return FALSE
	return TRUE


// Demo Code

/atom/save_serialized_data(list/_options)
	. = ..()
	SERIALIZE_VAR(alpha)
	SERIALIZE_VAR(desc)
	SERIALIZE_VAR(color)
	SERIALIZE_VAR(dir)
	SERIALIZE_VAR(fingerprints)
	SERIALIZE_VAR(fingerprintshidden)
	SERIALIZE_VAR(fingerprintslast)
	SERIALIZE_VAR(gender)
//	SERIALIZE_FILE_PATH(icon)
	SERIALIZE_VAR(icon_state)
	SERIALIZE_VAR(invisibility)
	SERIALIZE_VAR(maptext)
	SERIALIZE_VAR(maptext_height)
	SERIALIZE_VAR(maptext_width)
	SERIALIZE_VAR(maptext_x)
	SERIALIZE_VAR(maptext_y)
	SERIALIZE_VAR(mouse_opacity)
	SERIALIZE_VAR(name)
	SERIALIZE_VAR(opacity)
//	SERIALIZE_OBJECT(reagents)
	SERIALIZE_VAR(pixel_w)
	SERIALIZE_VAR(pixel_x)
	SERIALIZE_VAR(pixel_y)
	SERIALIZE_VAR(pixel_z)
	if(_options["recursive"])
		SERIALIZE_OBJECT_LIST(contents, _options)


/atom/load_deserialized_data(list/_data, list/_options)
	..()
	DESERIALIZE_VAR(alpha)
	DESERIALIZE_VAR(desc)
	DESERIALIZE_VAR(color)
	DESERIALIZE_VAR(dir)
	DESERIALIZE_VAR(fingerprints)
	DESERIALIZE_VAR(fingerprintshidden)
	DESERIALIZE_VAR(fingerprintslast)
	DESERIALIZE_VAR(gender)
//	DESERIALIZE_FILE_PATH(icon)
	DESERIALIZE_VAR(icon_state)
	DESERIALIZE_VAR(invisibility)
	DESERIALIZE_VAR(maptext)
	DESERIALIZE_VAR(maptext_height)
	DESERIALIZE_VAR(maptext_width)
	DESERIALIZE_VAR(maptext_x)
	DESERIALIZE_VAR(maptext_y)
	DESERIALIZE_VAR(mouse_opacity)
	DESERIALIZE_VAR(name)
	DESERIALIZE_VAR(opacity)
//	DESERIALIZE_OBJECT(reagents, _options)
	DESERIALIZE_VAR(pixel_w)
	DESERIALIZE_VAR(pixel_x)
	DESERIALIZE_VAR(pixel_y)
	DESERIALIZE_VAR(pixel_z)
	if(_options["recursive"])
		DESERIALIZE_OBJECT_LIST(contents, _options)


/atom/finalize_deserialized_data(list/_data, list/_options)
	if(_options["recursive"])
		DESERIALIZE_OBJECT_LIST(contents, _options)

/atom/movable/save_serialized_data(list/_options)
	. = ..()
	SERIALIZE_VAR(anchored)

/atom/movable/load_deserialized_data(list/_data, list/_options)
	..()
	DESERIALIZE_VAR(anchored)


/obj/item/stack/save_serialized_data(list/_options)
	. = ..()
	SERIALIZE_VAR(amount)
	SERIALIZE_VAR(max_amount)

/obj/item/stack/load_deserialized_data(list/_data, list/_options)
	..()
	DESERIALIZE_VAR(amount)
	DESERIALIZE_VAR(max_amount)


/obj/item/stack/material/save_serialized_data(list/_options)
	. = ..()
	SERIALIZE_VAR(apply_colour)
	SERIALIZE_VAR(default_type)
	SERIALIZE_GETTER_VAR(material, material.name)

/obj/item/stack/material/load_deserialized_data(list/_data, list/_options)
	..()
	DESERIALIZE_VAR(apply_colour)
	DESERIALIZE_VAR(default_type)
	set_material(DESERIALIZE_VALUE(material))

/obj/item/stack/material/finalize_deserialized_data(list/_data, list/_options)
	set_material(material)
	..()


// Directory defines should have a trailing slash.
#define SERIALIZATION_TEST_DIRECTORY "data/persistent/"

/atom/verb/test_serialization()
	set src in oview(1)
	var/json = SSserialization.object_to_json(src, TRUE, list("recursive" = 1))
	SSserialization.write_json(json, SERIALIZATION_TEST_DIRECTORY+"test.json")

/client/verb/test_deserialization()
	var/json = SSserialization.read_json(SERIALIZATION_TEST_DIRECTORY+"test.json")
	var/atom/A = SSserialization.json_to_object(json, list("recursive" = 1))
	if(istype(A, /atom/movable))
		var/atom/movable/AM = A
		AM.forceMove(get_turf(usr))
	debug_variables(A)