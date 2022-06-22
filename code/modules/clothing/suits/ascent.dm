/obj/item/clothing/suit/storage/mantid
	name = "mantid gear harness"
	desc = "A complex tangle of articulated cables and straps."
	species_restricted = list(SPECIES_MANTID)
	icon_state = "mantid_harness"
	body_parts_covered = 0
	slot_flags = SLOT_OCLOTHING | SLOT_ICLOTHING
	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/suit_cooling_unit,
		/obj/item/inflatable_dispenser,
		/obj/item/rcd
	)

/obj/item/clothing/suit/storage/mantid/Initialize()
	. = ..()
	for(var/tool in list(
/*
		/obj/item/gun/energy/particle/small,
*/
		/obj/item/clustertool,
		/obj/item/clustertool,
		/obj/item/multitool/mantid,
		/obj/item/weldingtool/electric/mantid
	))
		allowed |= tool
		new tool(pockets)
	pockets.make_exact_fit()
	allowed |= /obj/item/reagent_containers/drinks/cans/waterbottle/mantid
	pockets.can_hold |= /obj/item/reagent_containers/drinks/cans/waterbottle/mantid
