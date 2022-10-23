// Mostly a classic blob.  No nodes, no other blob types.
/datum/blob_type/classic
	name = "lethargic blob"
	desc = "A mass that seems bound to its core."
	ai_desc = "unambitious"
	effect_desc = "Will not create any nodes.  Has average strength and resistances."
	difficulty = BLOB_DIFFICULTY_EASY // Behaves almost like oldblob, and as such is about as easy as oldblob.
	color = "#AAFF00"
	complementary_color = "#57787B"
	can_build_nodes = FALSE
	spread_modifier = 1.0
	ai_aggressiveness = 0
