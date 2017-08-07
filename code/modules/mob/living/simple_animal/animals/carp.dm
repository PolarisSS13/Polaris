/mob/living/simple_animal/hostile/carp
	name = "space carp"
	desc = "A ferocious, fang-bearing creature that resembles a fish."
	icon_state = "carp"
	icon_living = "carp"
	icon_dead = "carp_dead"
	icon_gib = "carp_gib"

	faction = "carp"
	maxHealth = 25
	health = 25
	speed = 4
	turns_per_move = 5

	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"

	harm_intent_damage = 8
	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "bitten"
	attack_sound = 'sound/weapons/bite.ogg'

	//Space carp aren't affected by atmos.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/carpmeat

/mob/living/simple_animal/hostile/carp/spawn_organ()
	var/list/heart = list(/obj/item/organ/internal/heart, "[name]'s heart", "It's \the [name]'s heart. It pumps a phoron-rich blood throughout \the [name]'s body.")
	organs += heart
	var/list/gills = list(/obj/item/organ/internal, "[name]'s gills", "It's \the [name]'s gills. It provides phoron to \the [name]'s body.", "innards")
	organs += gills
	var/list/liver = list(/obj/item/organ/internal/liver, "[name]'s liver", "It's \the [name]'s liver. It helps filter out toxins from \the [name]'s body. Strangely, not phoron.")
	organs += liver
	var/list/swim_bladder = list(/obj/item/organ/internal, "[name]'s swim bladder", "It's \the [name]'s... swim bladder? It looks like a swim bladder, but it's highly active with bluespace radiation.", "vox_heart")
	organs += swim_bladder
	var/list/kidneys = list(/obj/item/organ/internal/kidneys, "[name]'s kidneys", "It's \the [name]'s kidneys. It removes toxins from \the [name]'s body. Strangely, not phoron.")
	organs += kidneys
	var/list/brain = list(/obj/item/organ/internal/brain, "[name]'s brain", "It's \the [name]'s brain. It controls \the [name]'s body. It is very small and smooth, which might explain the creature's aggressive nature.", "roro core")
	organs += brain
	var/list/eyes = list(/obj/item/organ/internal/eyes, "[name]'s eyes", "It's \the [name]'s eyes. They allow \the [name] to see, but they're not very complex, and can only see a few colors.")
	organs += eyes

/mob/living/simple_animal/hostile/carp/Process_Spacemove(var/check_drift = 0)
	return 1	//No drifting in space for space carp!	//original comments do not steal

/mob/living/simple_animal/hostile/carp/set_target()
	. = ..()
	if(.)
		custom_emote(1,"nashes at [.]")

/mob/living/simple_animal/hostile/carp/PunchTarget()
	. =..()
	var/mob/living/L = .
	if(istype(L))
		if(prob(15))
			L.Weaken(3)
			L.visible_message("<span class='danger'>\the [src] knocks down \the [L]!</span>")