// Bags of holding

/datum/design/item/boh/AssembleDesignName()
	..()
	name = "Infinite capacity storage prototype ([item_name])"

/datum/design/item/boh/bag_holding
	name = "bluespace backpack"
	desc = "Using localized bluespace portals this bag prototype offers incredible storage capacity with the contents weighting nothing. It's a shame the bag itself is pretty heavy."
	id = "bag_holding"
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6)
	materials = list("gold" = 3000, "diamond" = 1500, "uranium" = 250)
	build_path = /obj/item/storage/backpack/holding
	sort_string = "QAAAA"

/datum/design/item/boh/dufflebag_holding
	name = "bluespace dufflebag"
	desc = "A minaturized prototype of the popular bluespace backpack, the bluespace is, functionally, identical to the backpack version, but in a more stylish and compact form."
	id = "dufflebag_holding"
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6)
	materials = list("gold" = 3000, "diamond" = 1500, "uranium" = 250)
	build_path = /obj/item/storage/backpack/holding/duffle
	sort_string = "QAAAB"
