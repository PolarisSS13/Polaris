
/mob/living/simple_mob/construct/proteon
	name = "Proteon"
	real_name = "Proteon"
	construct_type = "proteon"
	desc = "A small construct dedicated to the tending of the living believers of the alchemical arts."
	icon_state = "tg_proteon"
	icon_living = "tg_proteon"
	maxHealth = 200
	health = 200
	response_harm = "beaten"
	harm_intent_damage = 5
	melee_damage_lower = 15
	melee_damage_upper = 20
	attacktext = list("clawed")
	attack_sound = 'sound/weapons/rapidslice.ogg'
	construct_spells = list(
		/spell/targeted/construct_advanced/mend_acolyte
		)
