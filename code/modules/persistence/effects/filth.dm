/datum/persistent/filth
	name = "filth"
	entries_expire_at = 4 // 4 rounds, 24 hours.
	has_admin_data = TRUE

/datum/persistent/filth/GetAdminDataStringFor(var/thing, var/can_modify, var/mob/user)
	if(istype(thing, /obj/effect/decal/cleanable/crayon))
		var/obj/effect/decal/cleanable/crayon/CRAY = thing
		if(can_modify)
			return "<td colspan = 3>[thing]</td><td>Loc:([CRAY.x],[CRAY.y],[CRAY.z]) P_X: [CRAY.pixel_x] P_Y: [CRAY.pixel_y] Color: [CRAY.art_color] Shading: [CRAY.art_shade] Type: [CRAY.art_type]</td><td><a href='byond://?src=\ref[src];caller=\ref[user];remove_entry=\ref[thing]'>Destroy</a></td>"
		return "<td colspan = 4>[thing]</td>"
	return null

/datum/persistent/filth/IsValidEntry(var/atom/entry)
	. = ..() && entry.invisibility == 0

/datum/persistent/filth/CheckTokenSanity(var/list/token)
	// byond's json implementation is "questionable", and uses types as keys and values without quotes sometimes even though they aren't valid json
	token["path"] = istext(token["path"]) ? text2path(token["path"]) : token["path"]
	token["pixel_x"] = istext(token["pixel_x"]) ? text2num(token["pixel_x"]) : token["pixel_x"]
	token["pixel_y"] = istext(token["pixel_y"]) ? text2num(token["pixel_y"]) : token["pixel_y"]
	return ..() && ispath(token["path"]) && isnum(token["pixel_x"]) && isnum(token["pixel_y"])

/datum/persistent/filth/CheckTurfContents(var/turf/T, var/list/token)
	var/_path = token["path"]
	if(!ispath(_path, /obj/effect/decal/cleanable/crayon))
		return (locate(_path) in T) ? FALSE : TRUE

// Crayon drawings aren't handled in graffiti, so we need to check if someone made "art" seperately from blood, dirt, etc.
	var/too_much_crayon = 0
	for(var/obj/effect/decal/cleanable/crayon/C in T)
		too_much_crayon++
		if(too_much_crayon >= 5)
			return FALSE
	return TRUE

/datum/persistent/filth/CreateEntryInstance(var/turf/creating, var/list/token)
	var/_path = token["path"]
	var/atom/inst = new _path(creating, token["age"]+1)
	if(token["pixel_x"])
		inst.pixel_x = token["pixel_x"]
	if(token["pixel_y"])
		inst.pixel_y = token["pixel_y"]

	if(istype(inst, /obj/effect/decal/cleanable/crayon))
		var/obj/effect/decal/cleanable/crayon/Crayart = inst
		if(token["art_type"])
			Crayart.art_type = token["art_type"]
		if(token["art_color"])
			Crayart.art_color = token["art_color"]
		if(token["art_shade"])
			Crayart.art_shade = token["art_shade"]

		Crayart.update_icon()

/datum/persistent/filth/GetEntryAge(var/atom/entry)
	var/obj/effect/decal/cleanable/filth = entry
	return filth.age

/datum/persistent/filth/proc/GetEntryPath(var/atom/entry)
	var/obj/effect/decal/cleanable/filth = entry
	return filth.generic_filth ? /obj/effect/decal/cleanable/filth : filth.type

/datum/persistent/filth/CompileEntry(var/atom/entry)
	. = ..()
	LAZYADDASSOC(., "path", "[GetEntryPath(entry)]")
	LAZYADDASSOC(., "pixel_x", "[entry.pixel_x]")
	LAZYADDASSOC(., "pixel_y", "[entry.pixel_y]")

	if(istype(entry, /obj/effect/decal/cleanable/crayon))
		var/obj/effect/decal/cleanable/crayon/Inst = entry
		LAZYADDASSOC(., "art_type", "[Inst.art_type]")
		LAZYADDASSOC(., "art_color", "[Inst.art_color]")
		LAZYADDASSOC(., "art_shade", "[Inst.art_shade]")
