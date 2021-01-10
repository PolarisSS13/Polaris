/obj/structure/prop/nest
	name = "diyaab den"
	desc = "A den of some creature."
	icon = 'icons/obj/structures.dmi'
	icon_state = "bonfire"
	density = TRUE
	anchored = TRUE
	interaction_message = "<span class='warning'>You feel like you shouldn't be sticking your nose into a wild animal's den.</span>"

	var/disturbance_spawn_chance = 20
	var/last_spawn
	var/spawn_delay = 150
	var/randomize_spawning = FALSE
	var/creature_types = list(/mob/living/simple_mob/animal/sif/diyaab)
	var/list/den_mobs
	var/den_faction			//The faction of any spawned creatures.
	var/max_creatures = 3	//Maximum number of living creatures this nest can have at one time.

	var/tally = 0				//The counter referenced against total_creature_max, or just to see how many mobs it has spawned.
	var/total_creature_max	//If set, it can spawn this many creatures, total, ever.

	var/destroy_message = "<span class='notice'>The den collapses in on itself!</span>"

/obj/structure/prop/nest/Initialize()
	..()
	den_mobs = list()
	START_PROCESSING(SSobj, src)
	last_spawn = world.time
	if(randomize_spawning) //Not the biggest shift in spawntime, but it's here.
		var/delayshift_clamp = spawn_delay / 10
		var/delayshift = rand(delayshift_clamp, -1 * delayshift_clamp)
		spawn_delay += delayshift

/obj/structure/prop/nest/Destroy()
	visible_message(destroy_message)

	den_mobs = null
	STOP_PROCESSING(SSobj, src)
	..()

/obj/structure/prop/nest/attack_hand(mob/living/user) // Used to tell the player that this isn't useful for anything.
	..()
	if(user && prob(disturbance_spawn_chance))
		spawn_creature(get_turf(src))

/obj/structure/prop/nest/process()
	update_creatures()
	if(world.time > last_spawn + spawn_delay)
		spawn_creature(get_turf(src))

/obj/structure/prop/nest/ex_act()
	. = ..()

	if(!QDELETED(src))
		qdel(src)

/obj/structure/prop/nest/proc/spawn_creature(var/turf/spawnpoint)
	update_creatures() //Paranoia.
	if(total_creature_max && tally >= total_creature_max)
		return
	if(istype(spawnpoint) && den_mobs.len < max_creatures)
		last_spawn = world.time
		var/spawn_choice = pick(creature_types)
		var/mob/living/L = new spawn_choice(spawnpoint)
		if(den_faction)
			L.faction = den_faction
		visible_message("<span class='warning'>\The [L] crawls out of \the [src].</span>")
		den_mobs += L
		tally++

/obj/structure/prop/nest/proc/remove_creature(var/mob/target)
	den_mobs -= target

/obj/structure/prop/nest/proc/update_creatures()
	for(var/mob/living/L in den_mobs)
		if(L.stat == 2)
			remove_creature(L)

/*
 * Subtypes.
 */

 /obj/structure/prop/nest/cult
 	name = "occult opening"
	desc = "An ancient portal to another realm."
	icon = 'icons/obj/cult.dmi'
	icon_state = "portal"
	density = FALSE
	interaction_message = "<span class='warning'>You feel like you shouldn't be sticking your nose into another realm.</span>"

	disturbance_spawn_chance = 5
	spawn_delay = 2 MINUTES
	creature_types = list(/mob/living/simple_mob/animal/space/bats/cult,
		/mob/living/simple_mob/creature/cult)

	den_faction = "cult"
	max_creatures = 3

	destroy_message = "<span class='notice'>The tunnel collapses in on itself!</span>"

/obj/structure/prop/nest/cult/attack_hand(mob/living/user)
	var/destroy_self = FALSE
	if(iscultist(user) || istype(user, /mob/living/simple_mob/construct))
		destroy_self = TRUE
	else
		if(user.is_holding_item_of_type(/obj/item/weapon/nullrod))
			to_chat(user, "<span class='notice'>You channel the null rod's condensed ethereal energies into \the [src].</span>")
			destroy_self = TRUE
		. = ..()

	if(destroy_self)
		qdel(src)

/obj/structure/prop/nest/cult/portal
	name = "noxious portal"

	icon_state = "portal"

	max_creatures = 1

	creature_types = list(/mob/living/simple_mob/animal/space/bats/cult/strong,
		/mob/living/simple_mob/creature/cult/strong,
		/mob/living/simple_mob/faithless/cult
		)
