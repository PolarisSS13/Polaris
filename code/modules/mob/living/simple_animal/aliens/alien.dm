/mob/living/simple_animal/hostile/alien
	name = "alien hunter"
	desc = "Hiss!"
	icon = 'icons/mob/alien.dmi'
	icon_state = "alienh_running"
	icon_living = "alienh_running"
	icon_dead = "alien_l"
	icon_gib = "syndicate_gib"

	faction = "xeno"
	cooperative = 1
	run_at_them = 0

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"

	maxHealth = 100
	health = 100
	speed = -1

	harm_intent_damage = 5
	melee_damage_lower = 25
	melee_damage_upper = 25

	attacktext = "slashed"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	a_intent = I_HURT

	environment_smash = 2
	status_flags = CANPUSH

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	heat_damage_per_tick = 20
	unsuitable_atoms_damage = 15

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/xenomeat

	autopsy_tool = /obj/item/weapon/surgical/circular_saw

/mob/living/simple_animal/hostile/alien/spawn_organ()
	var/list/heart = list(/obj/item/organ/internal, "[name]'s heart", "It's \the [name]'s heart. It pumps a highly acidic blood throughout \the [name]'s body.", "unathi_heart-off")
	organs += heart
	var/list/lungs = list(/obj/item/organ/internal, "[name]'s lungs", "It's \the [name]'s lungs. Through evolution, the lungs have become weak and shriveled, and don't appear to be of any importance for /the [name]'s body.", "lungs_prosthetic") // I have no idea what xenos breathe.
	organs += lungs
	var/list/liver = list(/obj/item/organ/internal, "[name]'s liver", "It's \the [name]'s liver. It appears to produce a thick, durable resin of some sort.", "unathi_liver") // ToDo: Add construction tech levels.
	organs += liver
	var/list/acid_sack = list(/obj/item/organ/internal, "[name]'s acid sack", "It's \the [name]'s acid sack. It's surrounded by muscles, likely meant to contract around the sack to spit the acids at things.", "vox_lung")
	organs += acid_sack
	var/list/kidneys = list(/obj/item/organ/internal, "[name]'s kidneys", "It's \the [name]'s kidneys. It adds toxins to \the [name]'s body for some reason. Maybe this is why the blood is acidic.","vox_heart")
	organs += kidneys
	var/list/brain = list(/obj/item/organ/internal/brain/xeno, "[name]'s brain", "It's \the [name]'s brain. It controls \the [name]'s body. It looks kind of like an enormous wad of purple bubblegum.")
	organs += brain
	var/list/eyes = list(/obj/item/organ/internal/eyes, "[name]'s eyes", "It's \the [name]'s eyes. They allow \the [name] to see from behind the black carapace on its head. The evolutionary benefit could be similar to why a body guard wears sunglasses to avoid prey knowing they're being watched, or it could also be for protection.", "eyes_assisted")
	organs += eyes

/mob/living/simple_animal/hostile/alien/drone
	name = "alien drone"
	icon_state = "aliend_running"
	icon_living = "aliend_running"
	icon_dead = "aliend_l"
	health = 60
	melee_damage_lower = 15
	melee_damage_upper = 15

/mob/living/simple_animal/hostile/alien/sentinel
	name = "alien sentinel"
	icon_state = "aliens_running"
	icon_living = "aliens_running"
	icon_dead = "aliens_l"
	health = 120
	melee_damage_lower = 15
	melee_damage_upper = 15
	ranged = 1
	projectiletype = /obj/item/projectile/neurotox
	projectilesound = 'sound/weapons/pierce.ogg'


/mob/living/simple_animal/hostile/alien/queen
	name = "alien queen"
	icon_state = "alienq_running"
	icon_living = "alienq_running"
	icon_dead = "alienq_l"
	health = 250
	maxHealth = 250
	melee_damage_lower = 15
	melee_damage_upper = 15
	ranged = 1
	move_to_delay = 3
	projectiletype = /obj/item/projectile/neurotox
	projectilesound = 'sound/weapons/pierce.ogg'
	rapid = 1
	status_flags = 0

/mob/living/simple_animal/hostile/alien/queen/large
	name = "alien empress"
	icon = 'icons/mob/alienqueen.dmi'
	icon_state = "queen_s"
	icon_living = "queen_s"
	icon_dead = "queen_dead"
	move_to_delay = 4
	maxHealth = 400
	health = 400

/obj/item/projectile/neurotox
	damage = 30
	icon_state = "toxin"

/mob/living/simple_animal/hostile/alien/death()
	..()
	visible_message("[src] lets out a waning guttural screech, green blood bubbling from its maw...")
	playsound(src, 'sound/voice/hiss6.ogg', 100, 1)

// Xenoarch aliens.
/mob/living/simple_animal/hostile/samak
	name = "samak"
	desc = "A fast, armoured predator accustomed to hiding and ambushing in cold terrain."
	faction = "samak"
	icon_state = "samak"
	icon_living = "samak"
	icon_dead = "samak_dead"
	icon = 'icons/jungle.dmi'

	faction = "samak"

	maxHealth = 125
	health = 125
	speed = 2
	move_to_delay = 2

	melee_damage_lower = 5
	melee_damage_upper = 15

	attacktext = "mauled"
	cold_damage_per_tick = 0

	speak_chance = 5
	speak = list("Hruuugh!","Hrunnph")
	emote_see = list("paws the ground","shakes its mane","stomps")
	emote_hear = list("snuffles")

	autopsy_tool = /obj/item/weapon/surgical/circular_saw

	// ToDo: Add organs.

/mob/living/simple_animal/hostile/diyaab
	name = "diyaab"
	desc = "A small pack animal. Although omnivorous, it will hunt meat on occasion."
	faction = "diyaab"
	icon_state = "diyaab"
	icon_living = "diyaab"
	icon_dead = "diyaab_dead"
	icon = 'icons/jungle.dmi'

	faction = "diyaab"
	cooperative = 1

	maxHealth = 25
	health = 25
	speed = 1
	move_to_delay = 1

	melee_damage_lower = 1
	melee_damage_upper = 8

	attacktext = "gouged"
	cold_damage_per_tick = 0

	speak_chance = 5
	speak = list("Awrr?","Aowrl!","Worrl")
	emote_see = list("sniffs the air cautiously","looks around")
	emote_hear = list("snuffles")

/mob/living/simple_animal/hostile/shantak
	name = "shantak"
	desc = "A piglike creature with a bright iridiscent mane that sparkles as though lit by an inner light. Don't be fooled by its beauty though."
	faction = "shantak"
	icon_state = "shantak"
	icon_living = "shantak"
	icon_dead = "shantak_dead"
	icon = 'icons/jungle.dmi'

	faction = "shantak"

	maxHealth = 75
	health = 75
	speed = 1
	move_to_delay = 1

	melee_damage_lower = 3
	melee_damage_upper = 12

	attacktext = "gouged"
	cold_damage_per_tick = 0

	speak_chance = 5
	speak = list("Shuhn","Shrunnph?","Shunpf")
	emote_see = list("scratches the ground","shakes out it's mane","tinkles gently")

/mob/living/simple_animal/yithian
	name = "yithian"
	desc = "A friendly creature vaguely resembling an oversized snail without a shell."
	icon_state = "yithian"
	icon_living = "yithian"
	icon_dead = "yithian_dead"
	icon = 'icons/jungle.dmi'

	faction = "yithian"

	// ToDo: Add organs.

/mob/living/simple_animal/tindalos
	name = "tindalos"
	desc = "It looks like a large, flightless grasshopper."
	icon_state = "tindalos"
	icon_living = "tindalos"
	icon_dead = "tindalos_dead"
	icon = 'icons/jungle.dmi'

	faction = "tindalos"

	// ToDo: Add organs.