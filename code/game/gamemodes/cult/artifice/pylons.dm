
/obj/structure/cult/pylon/networked
	name = "Pylon"
	desc = "A floating crystal that hums with an otherworldly energy."
	isbroken = 0
	light_range = 5
	light_color = "#3e0000"

	shatter_message = "The pylon shatters!"
	impact_sound = 'sound/effects/Glasshit.ogg'
	shatter_sound = 'sound/effects/Glassbr3.ogg'

	activation_cooldown = 30 SECONDS
	last_activation = 0

	var/weakref/network_ref

	var/blood_per_tick = 0

	can_mutate = FALSE

	available_pylon_types = null

/obj/structure/cult/pylon/networked/Initialize()
	..()

	network_ref = weakref(GLOB.blood_networks[CULT_BLOODNETWORK_GLOBAL])

/obj/structure/cult/pylon/networked/Destroy()
	network_ref = null

	. = ..()

// Blood Network costs.
/obj/structure/cult/pylon/networked/proc/check_pay_tick()
	if(!blood_per_tick)
		return TRUE

	var/datum/bloodnet/GLOBnet = network_ref.resolve()

	return GLOBnet.check_adjustBlood(-1 * blood_per_tick)

/obj/structure/cult/pylon/networked/proc/pay_cost(var/amount = 0, var/ignore_failure = TRUE)
	if(!amount)
		return TRUE

	var/datum/bloodnet/GLOBnet = network_ref.resolve()

	return GLOBnet.adjustBlood(-1 * amount, ignore_failure)

// Parent cycling.
/obj/structure/cult/pylon/networked/pylon_unique()
	..()

	. = FALSE

	var/aura_check = FALSE
	if(check_pay_tick() || !blood_per_tick)
		pay_cost(blood_per_tick)
		aura_check = perform_aura()

	return aura_check

// Pylon abilities.
/obj/structure/cult/pylon/networked/proc/perform_aura() // Passive aura.
	return FALSE

/obj/structure/cult/pylon/networked/perform_attacked(mob/user, var/damage, var/obj/item/I)	// Return true if the damage continues on.
	if(istype(I, /obj/item/weapon/nullrod))
		if(iscultist(user))
			visible_message("<span class='cult'>\The [src] pulses, before dematerializing.</span>")

			new /obj/item/weapon/ectoplasm(get_turf(src))

			return FALSE

	if(istype(I, /obj/item/weapon/material/kitchen/utensil/fork/tuning))
		return FALSE

	if(istype(I, /obj/item/weapon/book/tome))

		var/mob/living/L = user

		anchored = !anchored

		L.whisper("Tethu [anchored ? "i'na" : "y'ia"] motuus [src].")

		return FALSE
	return TRUE

/obj/structure/cult/pylon/networked/perform_damaged(var/damage)	// Return true if the damage continues on.
	return TRUE

//Subtypes.

// Sacrifice Pylon
// Pulls life from valid nearby mobs.
/obj/structure/cult/pylon/networked/sacrifice
	name = "Thirsting Pylon"
	desc = "A floating crystal that hums with a gluttonous energy."

	activation_cooldown = 1 SECONDS

	var/increase_drain = FALSE
	var/drain_mult = 1
	var/increased_mult = 5

/obj/structure/cult/pylon/networked/sacrifice/perform_aura()
	var/datum/bloodnet/BN = network_ref.resolve()
	var/resolved = FALSE
	for(var/mob/living/L in oview(2, src))
		if((iscultist(L) || istype(L, /mob/living/simple_mob)) && !istype(L, /mob/living/simple_mob/construct))
			if(BN.valid_sacrifice(L))
				resolved = TRUE

				Beam(L,icon_state="drain",icon='icons/effects/beam.dmi',time=2 SECONDS, maxdistance=2,beam_type=/obj/effect/ebeam,beam_sleep_time=3)

				BN.sacrifice(L, drain_mult)
				if(prob(5))
					L.visible_message("<span class='warning'>\The [src] tears the life force from \the [L]!</span>")

	for(var/obj/effect/decal/cleanable/blood/B in view(5, src))
		if(prob(10 * drain_mult))
			resolved = TRUE
			Beam(B,icon_state="drain",icon='icons/effects/beam.dmi',time=0.5 SECONDS, maxdistance=2,beam_type=/obj/effect/ebeam,beam_sleep_time=3)
			BN.adjustBlood(10)
			qdel(B)

	for(var/obj/item/weapon/reagent_containers/blood/pack in view(2, src))
		if(prob(10))
			if(pack.reagents.has_reagent("blood"))
				resolved = TRUE
				Beam(pack,icon_state="drain",icon='icons/effects/beam.dmi',time=0.5 SECONDS, maxdistance=2,beam_type=/obj/effect/ebeam,beam_sleep_time=3)
				BN.adjustBlood(2 * drain_mult)
				pack.reagents.remove_reagent("blood", 2 * drain_mult)
				pack.update_icon()

	if(!resolved)	// If the pylon is doing nothing else, feed into a personal network.
		var/obj/item/device/crystalball/CB = locate() in view(5, src)

		if(CB)	// If there's a crystal ball in the area, and it's networked, and not OUR network.
			var/datum/bloodnet/CBBN = CB.getBloodnet()

			if(CBBN && CBBN != BN && CBBN.current_volume < CBBN.max_volume)
				if(BN.adjustBlood(-1 * drain_mult * 5) && CBBN.adjustBlood(drain_mult * 5))
					resolved = TRUE
					Beam(CB,icon_state="send",icon='icons/effects/beam.dmi',time=0.5 SECONDS, maxdistance=2,beam_type=/obj/effect/ebeam,beam_sleep_time=3)

	return resolved

/obj/structure/cult/pylon/networked/sacrifice/perform_attacked(mob/user, var/damage, var/obj/item/I)	// Return true if the damage continues on.
	if(istype(I, /obj/item/weapon/material/kitchen/utensil/fork/tuning))
		if(do_after(user, 2 SECONDS, src))
			playsound(get_turf(src),I.usesound, 50, 1)
			increase_drain = !increase_drain
			if(increase_drain)
				drain_mult = increased_mult
			else
				drain_mult = initial(drain_mult)

			to_chat(user, "<span class='notice'>\The [src] will [increase_drain ? "drain life rapidly" : "drain life slowly"] from creatures nearby.</span>")

		return FALSE
	return TRUE

// Will Pylon
// Indoctrinates nearby simple mobs to the cult faction.

/obj/structure/cult/pylon/networked/will
	name = "Oppressive Pylon"
	desc = "A floating crystal that hums with an overwhelming force."

	activation_cooldown = 30 SECONDS

	primary_color = "#ff0000aa"
	secondary_color = "#9932ccaa"
	base_color = "#1a1a1a"

	crystal_state = "crystal-split"
	base_state = "base-small"
	surge_state = "electricity_constant"

/obj/structure/cult/pylon/networked/will/perform_aura()
	var/resolved = FALSE
	for(var/mob/living/L in oview(2, src))
		if(L.stat == DEAD)
			continue

		if(!istype(L, /mob/living/simple_mob) && !iscultist(L))
			continue

		if(L.faction == "cult")
			continue

		if(prob(20))
			var/favor = pay_cost(10, FALSE)
			if(favor < 0)
				L.add_modifier(/datum/modifier/deep_wounds, 2 MINUTES)
			else
				L.add_modifier(/datum/modifier/mend_occult, 15 SECONDS)
				L.add_modifier(/datum/modifier/deep_wounds, 30 SECONDS)
			L.faction = "cult"
			resolved = TRUE

	return resolved

// Agonizing Pylon
// Fires darklight beams at non-cultists nearby.

/obj/structure/cult/pylon/networked/laser
	name = "Agonizing Pylon"
	desc = "A floating crystal that hums with an agonizing force."

	activation_cooldown = 30 SECONDS

	primary_color = "#ff0000aa"
	secondary_color = "#9932ccaa"
	base_color = "#1a1a1a"

	crystal_state = "crystal"
	base_state = "base-small"
	surge_state = "flare"

	var/defend = TRUE

	var/projectile_type = /obj/item/projectile/beam/inversion

/obj/structure/cult/pylon/networked/laser/perform_aura()
	var/resolved = FALSE
	if(defend)
		var/list/nearby_targets = list()

		for(var/mob/living/L in oview(7, src))
			if(L.stat >= UNCONSCIOUS)
				continue

			if(iscultist(L) || L.faction == "cult")
				continue

			nearby_targets |= L

		for(var/obj/mecha/M in oview(7, src))
			var/mob/living/L = M.occupant

			if(!L)
				continue

			if(L.stat >= UNCONSCIOUS)
				continue

			if(iscultist(L) || L.faction == "cult")
				continue

			nearby_targets |= M

		var/atom/movable/target

		if(LAZYLEN(nearby_targets))
			target = pick(nearby_targets)

		if(target && pay_cost(10))
			var/obj/item/projectile/P = new projectile_type(get_turf(src))

			visible_message("<span class='danger'>\The [src] fires \the [P] at \the [target]!</span>")

			P.launch_projectile_from_turf(target, BP_TORSO, src)

	return resolved

/obj/structure/cult/pylon/networked/laser/perform_attacked(mob/user, var/damage, var/obj/item/I)	// Return true if the damage continues on.
	if(istype(I, /obj/item/weapon/material/kitchen/utensil/fork/tuning))
		if(do_after(user, 2 SECONDS, src))
			playsound(get_turf(src),I.usesound, 50, 1)
			defend = !defend
			to_chat(user, "<span class='notice'>\The [src] will [defend ? "now" : "no longer"] defend the area around it.</span>")
		return FALSE
	return TRUE
