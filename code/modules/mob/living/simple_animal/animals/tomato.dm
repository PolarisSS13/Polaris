/mob/living/simple_animal/hostile/tomato
	name = "tomato"
	desc = "It's a horrifyingly enormous beef tomato, and it's packing extra beef!"
	icon_state = "tomato"
	icon_living = "tomato"
	icon_dead = "tomato_dead"

	faction = "plants"
	maxHealth = 15
	health = 15
	turns_per_move = 5

	response_help  = "prods"
	response_disarm = "pushes aside"
	response_harm   = "smacks"

	harm_intent_damage = 5
	melee_damage_upper = 15
	melee_damage_lower = 10
	attacktext = "mauled"

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/tomatomeat

/mob/living/simple_animal/fish/spawn_organ()
	var/list/seeds = list(/obj/item/seeds/killertomatoseed, "packet of killer tomato seeds", "These were extracted directly from a killer tomato's body.")
	organs += seeds
	var/list/eyes = list(/obj/item/organ/internal/eyes, "[name]'s eyes", "It's \the [name]'s eyes. They allow \the [name] to see.")
	organs += eyes
	var/list/heart = list(/obj/item/organ/internal/heart, "[name]'s heart", "It's \the [name]'s heart. It pumps a substance with the consistency of tomato juice throughout \the [name]'s body.")
	organs += heart