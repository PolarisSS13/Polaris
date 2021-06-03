// If defined as `1`, the serializer will try to optimize for disk space by not storing values 
// that don't differ from compile-time values. This introduces a small amount of CPU overhead.
#define COMPRESS_SERIALIZATION 1

// -Simple-

// Saves a 'simple' variable, such as a string, number, list, or assocative list.
// Intended to be used inside of an overrided 'save_serialized_data()` proc.
// `NAMEOF()` makes it so compilation fails if the variable name stops existing instead of silently breaking persistence.
// This macro exists to protect from copypasta errors as a result of typing .[NAMEOF(src, the_var_name)] = the_var_name repeatively.
// If compression is disabled, this works identically to `SERIALIZE_VAR_ALWAYS()`.
#if COMPRESS_SERIALIZATION == 1

#define SERIALIZE_VAR(X)\
if(##X != initial(##X))\
{\
	.[NAMEOF(src, ##X)] = ##X;\
}

#else

#define SERIALIZE_VAR(X) .[NAMEOF(src, ##X)] = ##X

#endif

// Loads a 'simple' variable, such as a string, number, list, or assocative list.
// Intended to be used inside of an overrided `load_deserialized_data()` proc.
// Made for the same purpose of the above macro, but for loading instead of saving.
//#define DESERIALIZE_VAR(X) X = _data[NAMEOF(src, ##X)]

// If the value deserialized is null, by default, it will instead load the compile-time value
// of that variable. This is done to accomodate 
// If you actually want null to be retrieved, use `DESERIALIZE_VAR_NULLABLE()`.

/*
#define DESERIALIZE_VAR(X)\
var/_test = _data[NAMEOF(src, ##X)];\
if(isnull(_test))\
{\
	X = initial(##X);\
}\
else\
{\
	X = _data[NAMEOF(src, ##X);\
}

// Similar to above, but will allow for overwriting a current var with null.
#define DESERIALIZE_VAR_NULLABLE(X) X = _data[NAMEOF(src, ##X)]
*/

#define DESERIALIZE_VAR(X) X = _data[NAMEOF(src, ##X)]

// -Always-

// Bypasses the compression check, making this always get serialized, even if it hasn't changed.
// This is used for things that must always be serialized, such as the typepath.
// This also gets around an error that occurs when using `initial()` on certain vars, like the typepath, again.
#define SERIALIZE_VAR_ALWAYS(X) .[NAMEOF(src, ##X)] = ##X

// -File Path-

// Variables containing file paths (e.g. icons, sound files, etc) don't serialize as easily as other variables.
// This protects from saving file paths for files that don't actually exist on the server, e.g. an admin uploading a custom icon or sound file.
#define SERIALIZE_FILE_PATH(FILE_PATH)\
if(fexists(##FILE_PATH))\
{\
	.[NAMEOF(src, ##FILE_PATH)] = "[##FILE_PATH]";\
}

#define DESERIALIZE_FILE_PATH(X) X = file(_data[NAMEOF(src, ##X)])

// -Setters/Getters-

// Similar to above, but allows for arbitrary data to be inputted instead of what the var actually is.
// This is generally used when you're using a getter or otherwise serialize the output of a proc.
#define SERIALIZE_GETTER_VAR(VAR_NAME, GETTER_PROC) .[NAMEOF(src, ##VAR_NAME)] = ##GETTER_PROC

// Like above, but allows the var to be sourced from elsewhere beside what got written to disk.
// Generally this is for things that need to use a setter to modify properly.
#define DESERIALIZE_SETTER_VAR(VAR_NAME, SETTER_PROC) ##SETTER_PROC(.[NAMEOF(src, ##VAR_NAME)])

// Loads a value, but does not set any variables.
// Useful for feeding into setter procs, or to reference singleton objects.
#define DESERIALIZE_VALUE(VAR_NAME) _data[NAMEOF(src, ##VAR_NAME)]

// -Unmanaged-

// Allows using strings for the key, and thus has no protections against typos or var name changes.
// Use if you're storing something that is not a real variable on the object being saved.
#define SERIALIZE_FIAT_VAR(VAR_NAME, VAR_VALUE) .[VAR_NAME] = ##VAR_VALUE

// -Object-

// Saves an object variable, instead of saving it as an assoc. list.
// In most cases you probably want `SERIALIZE_OBJECT_LIST()` for stuff like object contents, 
// which generally covers most nested objects already without one object shared among others becoming many objects belonging to each object.
// Also helps avoid infinite loops by having two objects linked to each other and having the serializer try to follow both objects back and forth.
// Using contents should be enough.
#define SERIALIZE_OBJECT(X)\
var/datum/D = ##X;\
.[NAMEOF(src, ##X)] = D.save_serialized_data();

// -Object Lists-

// Saves a regular list of items as a serialized object, instead of merely an assoc list.
// Intended to be used inside of an overrided `save_serialized_data()` proc.
#define SERIALIZE_OBJECT_LIST(LIST, OPTIONS)\
var/list/things = list();\
things.len = LIST.len;\
var/i = 0;\
for(var/thing in LIST)\
{\
	var/datum/D = thing;\
	things[++i] = D.save_serialized_data(OPTIONS);\
}\
.[NAMEOF(src, ##LIST)] = things

// Deserializes an object instance.
#define DESERIALIZE_OBJECT(VAR_NAME, OPTIONS)\
var/datum/D = SSserialization.deserialize_list(VAR_NAME, OPTIONS);\
##VAR_NAME = D

// Deserializes a saved list that had contained object instances.
#define DESERIALIZE_OBJECT_LIST(LIST, OPTIONS)\
LIST.Cut();\
for(var/list/L in _data[NAMEOF(src, ##LIST)])\
{\
	var/datum/D = SSserialization.deserialize_list(L, OPTIONS);\
	LIST += D;\
}


#define SERIALIZE(PATH)\
##PATH/save_serialized_data()\
{\
	. = ..();\
}

#define DESERIALIZE(PATH)\
##PATH/load_deserialized_data(list/_data);\
	..();
