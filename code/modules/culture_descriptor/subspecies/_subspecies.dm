/decl/cultural_info/subspecies
	desc_type = "Subspecies"
	category = TAG_SUBSPECIES
	language = null
	economic_power = null
	secondary_langs = null
	additional_langs = null

/decl/cultural_info/subspecies/baseline
	name = SUBSPECIES_GENERIC
	description = "Sometimes people are just, baseline."

// Exists for characters who are 'vatborn', but either designer, or closer to their base species by template design.
/decl/cultural_info/subspecies/vatborn
	name = SUBSPECIES_VATBORN
	description = "A subspecies only by technicality, vatborn individuals are produced most \
	commonly by the use of a modified common template, or unique template made from donor genomes."

	economic_power = 0.8

	whitelist = CULTURE_ONLY_ORGANIC
