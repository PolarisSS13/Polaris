// Here are where all the other colors of slime live.
// They will generally fight each other if not Unified, meaning the xenobiologist has to seperate them.

// Tier 1.

/mob/living/simple_mob/slime/xenobio/purple
	desc = "This slime is rather toxic to handle, as it is poisonous."
	color = "#CC23FF"
	slime_color = "purple"
	coretype = /obj/item/slime_extract/purple
	reagent_injected = "toxin"

	description_info = "This slime spreads a toxin when it attacks.  A biosuit or other thick armor can protect from the toxic attack."
	player_msg = "You <b>inject a harmful toxin</b> when attacking."

	slime_mutation = list(
//			/mob/living/simple_animal/slime/dark_purple,
//			/mob/living/simple_animal/slime/dark_blue,
//			/mob/living/simple_animal/slime/green,
//			/mob/living/simple_animal/slime
		)

/mob/living/simple_mob/slime/xenobio/orange
	desc = "This slime is known to be flammable and can ignite enemies."
	color = "#FFA723"
	slime_color = "orange"
	coretype = /obj/item/slime_extract/orange
	melee_damage_lower = 5
	melee_damage_upper = 5

	description_info = "Attacks from this slime will burn you, and can ignite you.  A firesuit can protect from the burning attacks of this slime."
	player_msg = "You <b>inflict burning attacks</b>, which causes additional damage, makes the target more flammable, and has a chance to ignite them."

	slime_mutation = list(
//			/mob/living/simple_animal/slime/dark_purple,
//			/mob/living/simple_animal/slime/yellow,
//			/mob/living/simple_animal/slime/red,
//			/mob/living/simple_animal/slime
		)

/mob/living/simple_mob/slime/xenobio/orange/apply_melee_effects(atom/A)
	..()
	if(isliving(A))
		var/mob/living/L = A
		L.inflict_heat_damage(is_adult ? 20 : 10)
		to_chat(src, span("span", "You burn \the [L]."))
		to_chat(L, span("danger", "You've been burned by \the [src]!"))
		L.adjust_fire_stacks(1)
		if(prob(12))
			L.IgniteMob()


/mob/living/simple_mob/slime/xenobio/metal
	desc = "This slime is a lot more resilient than the others, due to having a metamorphic metallic and sloped surface."
	color = "#5F5F5F"
	slime_color = "metal"
	shiny = TRUE
	coretype = /obj/item/slime_extract/metal

	description_info = "This slime is a lot more durable and tough to damage than the others. It also seems to provoke others to attack it over others."
	player_msg = "You are <b>more resilient and armored</b> than more slimes. Your attacks will also encourage less intelligent enemies to focus on you."

	maxHealth = 250
	maxHealth_adult = 350

	// The sloped armor.
	// It's resistant to most weapons (but a spraybottle still kills it rather fast).
	armor = list(
				"melee" = 25,
				"bullet" = 25,
				"laser" = 25,
				"energy" = 50,
				"bomb" = 80,
				"bio" = 100,
				"rad" = 100
				)

	armor_soak = list(
				"melee" = 5,
				"bullet" = 5,
				"laser" = 5,
				"energy" = 0,
				"bomb" = 0,
				"bio" = 0,
				"rad" = 0
				)

	slime_mutation = list(
//			/mob/living/simple_animal/slime/silver,
//			/mob/living/simple_animal/slime/yellow,
//			/mob/living/simple_animal/slime/gold,
//			/mob/living/simple_animal/slime
		)

/mob/living/simple_mob/slime/xenobio/metal/apply_melee_effects(atom/A)
	..()
	if(isliving(A))
		var/mob/living/L = A
		L.taunt(src, TRUE) // We're the party tank now.

// Tier 2

/mob/living/simple_mob/slime/xenobio/yellow
	desc = "This slime is very conductive, and is known to use electricity as a means of defense moreso than usual for slimes."
	color = "#FFF423"
	slime_color = "yellow"
	coretype = /obj/item/slime_extract/yellow
	melee_damage_lower = 5
	melee_damage_upper = 5

	projectiletype = /obj/item/projectile/beam/lightning/slime
	projectilesound = 'sound/weapons/gauss_shoot.ogg' // Closest thing to a 'thunderstrike' sound we have.
	glow_toggle = TRUE

	description_info = "This slime will fire ranged lightning attacks at enemies if they are at range, inflict shocks upon entities they attack, \
	and generate electricity for their stun attack faster than usual.  Insulative or reflective armor can protect from these attacks."
	player_msg = "You have a <b>ranged electric attack</b>. You also <b>shock enemies you attack</b>, and your electric stun attack charges passively."

	slime_mutation = list(
//			/mob/living/simple_animal/slime/bluespace,
//			/mob/living/simple_animal/slime/bluespace,
//			/mob/living/simple_animal/slime/metal,
//			/mob/living/simple_animal/slime/orange
		)

/mob/living/simple_mob/slime/xenobio/yellow/apply_melee_effects(atom/A)
	..()
	if(isliving(A))
		var/mob/living/L = A
		L.inflict_shock_damage(is_adult ? 20 : 10)
		to_chat(src, span("span", "You shock \the [L]."))
		to_chat(L, span("danger", "You've been shocked by \the [src]!"))

/mob/living/simple_mob/slime/xenobio/yellow/handle_special()
	if(stat == CONSCIOUS)
		if(prob(25))
			power_charge = between(0, power_charge + 1, 10)
	..()

/obj/item/projectile/beam/lightning/slime
	power = 10


/mob/living/simple_mob/slime/xenobio/dark_purple
	desc = "This slime produces ever-coveted phoron.  Risky to handle but very much worth it."
	color = "#660088"
	slime_color = "dark purple"
	coretype = /obj/item/slime_extract/dark_purple
	reagent_injected = "phoron"

	description_info = "This slime applies phoron to enemies it attacks.  A biosuit or other thick armor can protect from the toxic attack.  \
	If hit with a burning attack, it will erupt in flames."
	player_msg = "You <b>inject phoron</b> into enemies you attack.<br>\
	<b>You will erupt into flames if harmed by fire!</b>"

	slime_mutation = list(
//			/mob/living/simple_animal/slime/purple,
//			/mob/living/simple_animal/slime/orange,
//			/mob/living/simple_animal/slime/ruby,
//			/mob/living/simple_animal/slime/ruby
		)

/mob/living/simple_mob/slime/xenobio/dark_purple/proc/ignite()
	visible_message(span("critical", "\The [src] erupts in an inferno!"))
	for(var/turf/simulated/target_turf in view(2, src))
		target_turf.assume_gas("phoron", 30, 1500+T0C)
		spawn(0)
			target_turf.hotspot_expose(1500+T0C, 400)
	qdel(src)

/mob/living/simple_mob/slime/xenobio/dark_purple/ex_act(severity)
	log_and_message_admins("[src] ignited due to a chain reaction with an explosion.")
	ignite()

/mob/living/simple_mob/slime/xenobio/dark_purple/fire_act(datum/gas_mixture/air, temperature, volume)
	log_and_message_admins("[src] ignited due to exposure to fire.")
	ignite()

/mob/living/simple_mob/slime/xenobio/dark_purple/bullet_act(var/obj/item/projectile/P, var/def_zone)
	if(P.damage_type && P.damage_type == BURN && P.damage) // Most bullets won't trigger the explosion, as a mercy towards Security.
		log_and_message_admins("[src] ignited due to bring hit by a burning projectile[P.firer ? " by [key_name(P.firer)]" : ""].")
		ignite()
	else
		..()

/mob/living/simple_mob/slime/xenobio/dark_purple/attackby(var/obj/item/weapon/W, var/mob/user)
	if(istype(W) && W.force && W.damtype == BURN)
		log_and_message_admins("[src] ignited due to being hit with a burning weapon ([W]) by [key_name(user)].")
		ignite()
	else
		..()



/mob/living/simple_mob/slime/xenobio/dark_blue
	desc = "This slime makes other entities near it feel much colder, and is more resilient to the cold.  It tends to kill other slimes rather quickly."
	color = "#2398FF"
	glows = TRUE
	slime_color = "dark blue"
	coretype = /obj/item/slime_extract/dark_blue
	melee_damage_lower = 5
	melee_damage_upper = 5


	description_info = "This slime is immune to the cold, however water will still kill it. Its attacks will \
	also chill you, causing additional harm. A winter coat or other cold-resistant clothing can protect from the chill."
	player_msg = "You are <b>immune to the cold</b>, inflict additional cold damage on attack, and cause nearby entities to become colder."

	slime_mutation = list(
//			/mob/living/simple_animal/slime/purple,
//			/mob/living/simple_animal/slime/blue,
//			/mob/living/simple_animal/slime/cerulean,
//			/mob/living/simple_animal/slime/cerulean
		)

	minbodytemp = 0
	cold_damage_per_tick = 0
	cold_resist = 1

/mob/living/simple_mob/slime/xenobio/dark_blue/handle_special()
	if(stat != DEAD)
		cold_aura()
	..()

/mob/living/simple_mob/slime/xenobio/dark_blue/proc/cold_aura()
	for(var/mob/living/L in view(2, src))
		if(L == src)
			continue
		chill(L)

	var/turf/T = get_turf(src)
	var/datum/gas_mixture/env = T.return_air()
	if(env)
		env.add_thermal_energy(-10 * 1000)

/mob/living/simple_mob/slime/xenobio/dark_blue/apply_melee_effects(atom/A)
	..()
	if(isliving(A))
		var/mob/living/L = A
		chill(L)
		to_chat(src, span("span", "You chill \the [L]."))
		to_chat(L, span("danger", "You've been chilled by \the [src]!"))


/mob/living/simple_mob/slime/xenobio/dark_blue/proc/chill(mob/living/L)
	L.inflict_cold_damage(is_adult ? 20 : 10)
	if(!L.get_cold_protection() * 100) // Having complete protection always saves you, otherwise there's a chance to get this modifier.
		add_modifier(/datum/modifier/chilled, 10 SECONDS)

/*

*/