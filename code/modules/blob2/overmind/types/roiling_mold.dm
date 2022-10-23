// Blob that fires biological mortar shells from its factories.
/datum/blob_type/roiling_mold
	name = "roiling mold"
	desc = "A bubbling, creeping mold."
	ai_desc = "bombarding"
	effect_desc = "Bombards nearby organisms with toxic spores. Weak to all damage."
	difficulty = BLOB_DIFFICULTY_MEDIUM
	color = "#571509"
	complementary_color = "#ec4940"
	damage_type = BRUTE
	damage_lower = 5
	damage_upper = 20
	armor_check = "melee"
	brute_multiplier = 1.2
	burn_multiplier = 1.2
	spread_modifier = 0.8
	can_build_factories = TRUE
	ai_aggressiveness = 50
	attack_message = "The mold whips you"
	attack_message_living = ", and you feel a searing pain"
	attack_message_synth = ", and your shell buckles"
	attack_verb = "lashes"
	spore_projectile = /obj/item/projectile/arc/spore
	factory_type = /obj/structure/blob/factory/turret
