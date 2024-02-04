
/obj/structure/ore_box
	name = "ore box"
	desc = "A heavy box used for storing ore."
	icon = 'icons/obj/mining.dmi'
	icon_state = "orebox0"
	density = TRUE

	/// Rebuild stored_ore if true. Becomes true when contents changes.
	var/stored_ore_dirty

	/// The current ore contents of the bag formatted by english_list.
	var/stored_ore


/obj/structure/ore_box/examine(mob/user, distance, infix, suffix)
	. = ..()
	if (distance > 2 && !isobserver(user))
		return
	if (isliving(user))
		add_fingerprint(user)
	if (stored_ore_dirty)
		stored_ore_dirty = FALSE
		stored_ore = null
		var/list/ores = list()
		for (var/obj/item/ore/ore in contents)
			++ores[ore.name]
		var/list/chunks = list()
		for (var/name in ores)
			chunks += "[ores[name]] [name]"
		if (length(chunks))
			stored_ore = "It contains [english_list(chunks)]"
	. += SPAN_ITALIC(stored_ore || "It is empty.")


/obj/structure/ore_box/attackby(obj/item/item, mob/living/user)
	if (istype(item, /obj/item/ore))
		user.remove_from_mob(item, src)
		stored_ore_dirty = TRUE
		return TRUE
	var/obj/item/storage/storage = item
	if (istype(storage))
		. = TRUE
		var/length = length(storage.contents)
		if (!length)
			to_chat(user, SPAN_WARNING("\The [storage] is empty."))
			return
		var/gathered
		var/obj/item/storage/bag/ore/bag = item
		if (istype(bag))
			bag.stored_ore_dirty = TRUE
			contents += bag.contents
			gathered = TRUE
		else
			for (var/obj/item/ore/ore in storage)
				storage.remove_from_storage(ore, src)
				++gathered
		if (gathered)
			to_chat(user, SPAN_ITALIC("You empty \the [storage] into \the [src]."))
			stored_ore_dirty = TRUE
		else
			to_chat(user, SPAN_WARNING("\The [storage] contained no ore."))


/obj/structure/ore_box/ex_act(severity)
	var/turf/turf = get_turf(src)
	switch (severity)
		if (1)
			if (turf == loc)
				turf.contents += contents
			qdel(src)
		if (2)
			if (prob(50))
				return
			if (turf == loc)
				turf.contents += contents
			qdel(src)


/obj/structure/ore_box/verb/empty_box()
	set name = "Empty Ore Box"
	set category = "Object"
	set src in view(1)
	var/mob/living/user = usr
	if (!(ishuman(user) || isrobot(user)))
		to_chat(user, SPAN_WARNING("You're not dextrous enough to do that."))
		return
	if (!Adjacent(user))
		return
	if (user.stat || user.restrained())
		to_chat(user, SPAN_WARNING("You're in no condition to do that."))
		return
	add_fingerprint(user)
	if (!length(contents))
		to_chat(user, SPAN_WARNING("\The [src] is empty."))
		return
	user.visible_message(
		SPAN_ITALIC("\The [user] empties \a [src]."),
		SPAN_ITALIC("You empty \the [src]."),
		range = 5
	)
	loc.contents += contents
