// Electric blob that stuns.
/datum/blob_type/energized_jelly
	name = "energized jelly"
	desc = "A substance that seems to generate electricity."
	ai_desc = "suppressive"
	effect_desc = "When attacking an entity, it will shock them with a strong electric shock.  Repeated attacks can stun the target."
	difficulty = BLOB_DIFFICULTY_MEDIUM
	color = "#EFD65A"
	complementary_color = "#00E5B1"
	damage_type = BURN
	damage_lower = 5
	damage_upper = 10
	brute_multiplier = 0.5
	burn_multiplier = 0.5
	spread_modifier = 0.35
	ai_aggressiveness = 80
	attack_message = "The jelly prods you"
	attack_message_living = ", and your flesh burns as electricity arcs into you"
	attack_message_synth = ", and your internal circuity is overloaded as electricity arcs into you"
	attack_verb = "prods"
	spore_projectile = /obj/item/projectile/beam/shock

/datum/blob_type/energized_jelly/on_attack(obj/structure/blob/B, mob/living/victim, def_zone)
	victim.electrocute_act(10, src, 1, def_zone)
	victim.stun_effect_act(0, 40, BP_TORSO, src)
