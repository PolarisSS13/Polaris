/obj/item/weapon/storage/box/swabs
	name = "box of swab kits"
	desc = "Sterilized equipment within. Do not contaminate."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "dnakit"
	can_hold = list(/obj/item/weapon/forensics/swab)
	storage_slots = 14

/obj/item/weapon/storage/box/swabs/New()
	..()
	for(var/i = 1 to storage_slots) // Fill 'er up.
		new /obj/item/weapon/forensics/swab(src)

/obj/item/weapon/storage/box/evidence
	name = "evidence bag box"
	desc = "A box claiming to contain evidence bags."
	storage_slots = 7
	can_hold = list(/obj/item/weapon/evidencebag)

/obj/item/weapon/storage/box/evidence/New()
	..()
	for(var/i = 1 to storage_slots)
		new /obj/item/weapon/evidencebag(src)

/obj/item/weapon/storage/box/fingerprints
	name = "box of fingerprint cards"
	desc = "Sterilized equipment within. Do not contaminate."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "dnakit"
	can_hold = list(/obj/item/weapon/sample/print)
	storage_slots = 14

/obj/item/weapon/storage/box/fingerprints/New()
	..()
	for(var/i = 1 to storage_slots)
		new /obj/item/weapon/sample/print(src)

/obj/item/weapon/storage/box/csi_markers
	name = "crime scene markers box"
	desc = "A cardboard box for crime scene marker cards."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "cards"
	w_class = ITEMSIZE_TINY
	starts_with = list(
		/obj/item/weapon/csi_marker/n1 = 1,
		/obj/item/weapon/csi_marker/n2 = 1,
		/obj/item/weapon/csi_marker/n3 = 1,
		/obj/item/weapon/csi_marker/n4 = 1,
		/obj/item/weapon/csi_marker/n5 = 1,
		/obj/item/weapon/csi_marker/n6 = 1,
		/obj/item/weapon/csi_marker/n7 = 1
	)