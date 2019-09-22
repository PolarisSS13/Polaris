/mob/living/simple_animal/penguin
	name = "penguin"
	desc = "An ungainly, waddling, cute, and VERY well-dressed bird."
	tt_desc = "Aptenodytes forsteri"
	icon_state = "penguin"
	icon_living = "penguin"
	icon_dead = "penguin_dead"
	intelligence_level = SA_ANIMAL

	maxHealth = 20
	health = 20

	turns_per_move = 5

	response_help  = "pets"
	response_disarm = "pushes aside"
	response_harm   = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 10
	melee_damage_upper = 15
	attacktext = list("pecked")

	has_langs = list("Bird")
	speak_chance = 0

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat

/mob/living/simple_animal/penguin/Move(a, b, flag)
	..()
	animate(src, pixel_z = 4, time = 0)
	animate(pixel_z = 0, transform = turn(matrix(), pick(-12, 0, 12)), time=2)
	animate(pixel_z = 0, transform = matrix(), time = 0)

/mob/living/simple_animal/pet/penguin/emperor
	name = "Emperor penguin"
	real_name = "penguin"
	desc = "Emperor of all he surveys."
	icon_state = "penguin"
	icon_living = "penguin"
	icon_dead = "penguin_dead"

/mob/living/simple_animal/pet/penguin/emperor/shamebrero
	name = "Shamebrero penguin"
	desc = "Shameful of all he surveys."
	icon_state = "penguin_shamebrero"
	icon_living = "penguin_shamebrero"

/mob/living/simple_animal/pet/penguin/baby
	speak = list("gah", "noot noot", "noot!", "noot", "squeee!", "noo!")
	name = "Penguin chick"
	real_name = "penguin"
	desc = "Can't fly and barely waddles, yet the prince of all chicks."
	icon_state = "penguin_baby"
	icon_living = "penguin_baby"
	icon_dead = "penguin_baby_dead"
	density = FALSE
	pass_flags = PASSMOB
	mob_size = MOB_SMALL