// Currently unticked pending full implementation of the required data structures
// and tracking/load logic. Needs to account for DMMS load, critters spawning in POIs,
// critters spawning on station, etc. Fair bit of design work to consider.
/datum/persistent/specimen
	name = "specimen"
	entries_expire_at = 10
	area_restricted = FALSE
	station_restricted = FALSE

/datum/persistent/specimen/CreateEntryInstance(var/turf/creating, var/list/token)
	new /obj/item/gps/specimen_tag(
		creating,
		token["age"]+1,
		token["implanted_by"],
		token["specimen_id"],
		token["specimen_gender"],
		token["physical_info"],
		token["behavior_info"],
		text2path(token["specimen_type"])
	)

/datum/persistent/specimen/GetEntryAge(var/atom/entry)
	var/obj/item/gps/specimen_tag/save_specimen = entry
	if(!istype(save_specimen))
		return 0
	return save_specimen.age

/datum/persistent/specimen/IsValidEntry(atom/entry)
	. = ..()
	var/obj/item/gps/specimen_tag/save_specimen = entry
	return istype(save_specimen) && save_specimen.has_been_implanted() && save_specimen.implanted_in.stat != DEAD

/datum/persistent/specimen/CompileEntry(var/atom/entry, var/write_file)
	. = ..()
	var/obj/item/gps/specimen_tag/save_specimen = entry
	if(!istype(save_specimen))
		return
	save_specimen.update_from_animal()
	LAZYADDASSOC(., "implanted_by",    save_specimen.implanted_by)
	LAZYADDASSOC(., "specimen_id",     save_specimen.gps_tag)
	LAZYADDASSOC(., "specimen_type",   save_specimen.implanted_in.type)
	LAZYADDASSOC(., "specimen_gender", save_specimen.gender)
	LAZYADDASSOC(., "physical_info",   save_specimen.physical_info)
	LAZYADDASSOC(., "behavior_info",   save_specimen.behavioral_info)
