// Different types of fish! They are all subtypes of this tho
/mob/living/simple_animal/fish
	name = "fish"
	desc = "Its a fishy.  No touchy fishy."
	icon = 'icons/mob/fish.dmi'
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat

	// By defautl they can be in any water turf.  Subtypes might restrict to deep/shallow etc
	var/global/list/suitable_turf_types =  list(
		/turf/simulated/floor/beach/water,
		/turf/simulated/floor/beach/coastline,
		/turf/simulated/floor/holofloor/beach/water,
		/turf/simulated/floor/holofloor/beach/coastline,
		/turf/simulated/floor/water
	)

// Don't swim out of the water
/mob/living/simple_animal/fish/handle_wander_movement()
	if(isturf(src.loc) && !resting && !buckled && canmove) //Physically capable of moving?
		lifes_since_move++ //Increment turns since move (turns are life() cycles)
		if(lifes_since_move >= turns_per_move)
			if(!(stop_when_pulled && pulledby)) //Some animals don't move when pulled
				var/moving_to = 0 // otherwise it always picks 4, fuck if I know.   Did I mention fuck BYOND
				moving_to = pick(cardinal)
				dir = moving_to			//How about we turn them the direction they are moving, yay.
				var/turf/T = get_step(src,moving_to)
				if(T && is_type_in_list(T, suitable_turf_types))
					Move(T)
					lifes_since_move = 0

// Take damage if we are not in water
/mob/living/simple_animal/fish/handle_breathing()
	var/turf/T = get_turf(src)
	if(T && !is_type_in_list(T, suitable_turf_types))
		if(prob(50))
			say(pick("Blub", "Glub", "Burble"))
		adjustBruteLoss(unsuitable_atoms_damage)

/mob/living/simple_animal/fish/spawn_organ()
	var/list/heart = list(/obj/item/organ/internal/heart, "[name]'s heart", "It's \the [name]'s heart. It pumps blood throughout \the [name]'s body.")
	organs += heart
	var/list/gills = list(/obj/item/organ/internal, "[name]'s gills", "It's \the [name]'s gills. It provides oxygen to \the [name]'s body.", "innards")
	organs += gills
	var/list/liver = list(/obj/item/organ/internal/liver, "[name]'s liver", "It's \the [name]'s liver. It helps filter out toxins from \the [name]'s body.")
	organs += liver
	var/list/swim_bladder = list(/obj/item/organ/internal, "[name]'s swim bladder", "It's \the [name]'s swim bladder. It allows \the [name] to change its buoyancy.", "innards")
	organs += swim_bladder
	var/list/kidneys = list(/obj/item/organ/internal/kidneys, "[name]'s kidneys", "It's \the [name]'s kidneys. It removes toxins from \the [name]'s body.")
	organs += kidneys
	var/list/brain = list(/obj/item/organ/internal/brain, "[name]'s brain", "It's \the [name]'s brain. It controls \the [name]'s body.", "roro core")
	organs += brain
	var/list/eyes = list(/obj/item/organ/internal/eyes, "[name]'s eyes", "It's \the [name]'s eyes. They allow \the [name] to see.")
	organs += eyes

/mob/living/simple_animal/fish/bass
	name = "bass"
	icon_state = "bass-swim"
	icon_living = "bass-swim"
	icon_dead = "bass-dead"

/mob/living/simple_animal/fish/trout
	name = "trout"
	icon_state = "trout-swim"
	icon_living = "trout-swim"
	icon_dead = "trout-dead"

/mob/living/simple_animal/fish/salmon
	name = "salmon"
	icon_state = "salmon-swim"
	icon_living = "salmon-swim"
	icon_dead = "salmon-dead"

/mob/living/simple_animal/fish/perch
	name = "perch"
	icon_state = "perch-swim"
	icon_living = "perch-swim"
	icon_dead = "perch-dead"

/mob/living/simple_animal/fish/pike
	name = "pike"
	icon_state = "pike-swim"
	icon_living = "pike-swim"
	icon_dead = "pike-dead"

/mob/living/simple_animal/fish/koi
	name = "koi"
	icon_state = "koi-swim"
	icon_living = "koi-swim"
	icon_dead = "koi-dead"
