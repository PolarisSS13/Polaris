/obj/item/storage/internal/animal_harness/grafadreka
	var/const/ATTACHED_GPS = "gps"
	var/const/ATTACHED_RADIO = "radio"
	var/const/ATTACHED_ARMOR = "armor plate"

	/// An attachable_types list shared between drake harness instances.
	var/static/list/grafadreka_attachable_types = list(
		/obj/item/gps = ATTACHED_GPS,
		/obj/item/radio = ATTACHED_RADIO,
		/obj/item/clothing/accessory/armor = list(
			ATTACHED_ARMOR,
			/obj/item/storage/internal/animal_harness/grafadreka/proc/UpdateArmor
		),
		/obj/item/clothing/accessory/material/makeshift = list(
			ATTACHED_ARMOR,
			/obj/item/storage/internal/animal_harness/grafadreka/proc/UpdateArmor
		)
	)

	/// The drake that owns this harness.
	var/mob/living/simple_mob/animal/sif/grafadreka/trained/owner


/obj/item/storage/internal/animal_harness/grafadreka/Destroy()
	attachable_types = null
	owner = null
	return ..()


/obj/item/storage/internal/animal_harness/grafadreka/Initialize(mapload)
	attachable_types = grafadreka_attachable_types
	. = ..()
	owner = loc
	if (!istype(owner))
		log_debug("Drake harness created without a drake!")
		return INITIALIZE_HINT_QDEL
	var/obj/item/gps/explorer/on/gps = new (owner)
	gps.gps_tag = owner.name
	attached_items[ATTACHED_GPS] = gps
	attached_items[ATTACHED_RADIO] = new /obj/item/radio (owner)
	new /obj/item/stack/medical/bruise_pack (src)
	new /obj/item/stack/medical/ointment (src)
	new /obj/item/storage/mre/menu13 (src)


/obj/item/storage/internal/animal_harness/grafadreka/proc/UpdateArmor()
	if (!owner)
		return
	var/obj/item/clothing/accessory/armor = attached_items[ATTACHED_ARMOR]
	if (!armor)
		owner.armor = owner.original_armor
		return
	for (var/key in armor.armor)
		armor[key] = max(owner.original_armor[key], armor.armor[key])
