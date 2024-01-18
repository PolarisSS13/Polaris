/obj/structure/wood_fire // abstract type, do not use

	icon = 'icons/obj/wood_fire.dmi'
	density = FALSE
	anchored = TRUE
	buckle_lying = FALSE
	layer = TURF_LAYER + 0.5 // We want it to layer underneath food and things on top of it.

	var/base_icon_state = "bonfire"
	var/can_dismantle = TRUE
	var/burning = FALSE
	var/next_fuel_consumption = 0 // world.time of when next item in fuel list gets eatten to sustain the fire.
	var/grill = FALSE
	var/set_temperature = T0C + 30	//K
	var/heating_power = 80000
	var/datum/looping_sound/fire_crackles/fire_loop
	var/datum/looping_sound/grill/grill_loop // Used when food is cooking on the fire.

/obj/structure/wood_fire/Initialize()
	. = ..()
	fire_loop  = new(list(src), FALSE)
	grill_loop = new(list(src), FALSE)

/obj/structure/wood_fire/Destroy()
	QDEL_NULL(fire_loop)
	QDEL_NULL(grill_loop)
	return ..()

/obj/structure/wood_fire/proc/get_upgrade_options()
	if(grill || can_buckle)
		return null
	if(!grill)
		LAZYADD(., "Grill")
	if(!can_buckle)
		LAZYADD(., "Stake")

/obj/structure/wood_fire/proc/try_build_feature(var/mob/user, var/obj/item/stack/rods/rods)
	if(!istype(rods))
		return FALSE

	var/list/upgrade_options = get_upgrade_options()
	var/choice
	if(!length(upgrade_options))
		return FALSE

	if(length(upgrade_options) == 1)
		choice = upgrade_options[1]
	else
		choice = input(user, "What would you like to construct?", "Constructing Grill") as null|anything in upgrade_options
		if(QDELETED(rods) || rods.get_amount() < 1 || user.incapacitated() || !Adjacent(user))
			return TRUE

	switch(choice)
		if("Stake")
			rods.use(1)
			can_buckle = TRUE
			buckle_require_restraints = TRUE
			to_chat(user, SPAN_NOTICE("You add a rod to \the [src]."))
		if("Grill")
			rods.use(1)
			grill = TRUE
			to_chat(user, SPAN_NOTICE("You add a grill to \the [src]."))
		else
			return TRUE
	update_icon()
	return TRUE

/obj/structure/wood_fire/attackby(obj/item/W, mob/user)

	// Place food on the grill.
	if(istype(W, /obj/item/reagent_containers/food/snacks) && grill)
		if(user.unEquip(W))
			W.dropInto(loc)
			// Place it on top of the grill.
			W.pixel_x = 0
			W.pixel_y = 12
		return TRUE

	if(try_build_feature(user, W))
		return TRUE

	if(istype(W, /obj/item/stack/material/fuel))
		add_fuel(W, user)
		return TRUE

	if(W.is_hot())
		ignite()
		return TRUE

	return ..()

/obj/structure/wood_fire/attack_hand(mob/user)
	if(!has_buckled_mobs())
		if(get_fuel_amount())
			remove_fuel(user)
			return TRUE
		if(can_dismantle)
			dismantle(user)
			return TRUE
	return ..()

/obj/structure/wood_fire/proc/dismantle(mob/user)
	if(!burning)
		user.visible_message("[user] starts dismantling \the [src].", "You start dismantling \the [src].")
		if(do_after(user, 5 SECONDS))
			for(var/obj/item/thing in contents)
				thing.dropInto(loc)
			user.visible_message("[user] dismantles down \the [src].", "You dismantle \the [src].")
			qdel(src)
	else
		to_chat(user, SPAN_WARNING("\The [src] is still burning. Extinguish it first if you want to dismantle it."))

/obj/structure/wood_fire/proc/get_fuel_amount()
	. = 0
	for(var/obj/item/stack/material/fuel/fuel in contents)
		. += (fuel.amount * fuel.bonfire_fuel_time) / (2 MINUTES)

/obj/structure/wood_fire/proc/remove_fuel(mob/user)
	if(!get_fuel_amount())
		return
	var/atom/movable/AM = pop(contents)
	if(!istype(AM))
		return
	AM.forceMove(get_turf(src))
	to_chat(user, SPAN_NOTICE("You take \the [AM] out of \the [src] before it has a chance to burn away."))
	update_icon()

/obj/structure/wood_fire/proc/add_fuel(atom/movable/new_fuel, mob/user)
	if(get_fuel_amount() >= 10)
		to_chat(user, SPAN_WARNING("\The [src] already has enough fuel!"))
		return FALSE
	if(istype(new_fuel, /obj/item/stack/material/fuel/wood) || istype(new_fuel, /obj/item/stack/material/fuel/log) )
		var/obj/item/stack/F = new_fuel
		var/obj/item/stack/S = F.split(1)
		if(S)
			S.forceMove(src)
			to_chat(user, SPAN_WARNING("You add \the [new_fuel] to \the [src]."))
			update_icon()
			return TRUE
		return FALSE
	else
		to_chat(user, SPAN_WARNING("\The [src] needs raw wood to burn, \a [new_fuel] won't work."))
	return FALSE

/obj/structure/wood_fire/proc/consume_fuel()
	var/obj/item/stack/consumed_fuel
	for(var/atom/movable/thing in contents)
		if(!thing.simulated)
			continue
		consumed_fuel = thing
		break
	if(!istype(consumed_fuel, /obj/item/stack/material/fuel))
		if(consumed_fuel)
			qdel(consumed_fuel) // Don't know, don't care.
		return FALSE
	var/obj/item/stack/material/fuel/fuel_stack = consumed_fuel
	next_fuel_consumption = world.time + max(1 MINUTE, fuel_stack.bonfire_fuel_time)
	fuel_stack.use(1)
	update_icon()
	return TRUE

/obj/structure/wood_fire/proc/extinguish()
	if(!burning)
		return
	burning = FALSE
	update_icon()
	STOP_PROCESSING(SSobj, src)
	visible_message(SPAN_NOTICE("\The [src] stops burning."))
	if(fire_loop?.started)
		fire_loop.stop(src)

/obj/structure/wood_fire/proc/ignite()
	if(burning || !get_fuel_amount())
		return
	burning = TRUE
	update_icon()
	START_PROCESSING(SSobj, src)
	visible_message(SPAN_NOTICE("\The [src] starts burning!"))
	if(fire_loop && !fire_loop.started)
		fire_loop.start(src)

/obj/structure/wood_fire/proc/get_fuel_overlay(var/fuel_amount)
	if(fuel_amount)
		var/image/I = image(icon, "[base_icon_state]_fuelled")
		I.appearance_flags = RESET_COLOR | KEEP_APART
		var/obj/item/stack/material/fuel/fuel = locate() in contents
		I.color = fuel?.material?.icon_colour
		return I

/obj/structure/wood_fire/update_icon()

	cut_overlays()

	// Draw our fuel overlay and colour it based on fuel material.
	var/fuel_amount = get_fuel_amount()
	var/fuel_overlay = get_fuel_overlay(fuel_amount)
	if(fuel_overlay)
		if(islist(fuel_overlay))
			for(var/overlay in fuel_overlay)
				add_overlay(overlay)
		else
			add_overlay(fuel_overlay)

	if(burning)

		// Draw our actual fire icon.
		var/image/I = image(icon, ((fuel_amount >= 5) ? "[base_icon_state]_hot" : "[base_icon_state]_warm"))
		I.appearance_flags = RESET_COLOR | KEEP_APART
		add_overlay(I)

		// If we're capable of burning buckled mobs (usually via a stake),
		// draw an intense fire overlay and offset it to cover the mob.
		if(fire_is_burning_mobs())
			I = image(icon, "[base_icon_state]_intense")
			I.pixel_y = 13
			I.layer = MOB_LAYER + 0.1
			I.appearance_flags = RESET_COLOR | KEEP_APART
			add_overlay(I)

		// Update our lights.
		var/light_strength = max(fuel_amount / 2, 2)
		set_light(light_strength, light_strength, COLOR_FIRE_ORANGE)
	else
		set_light(0)

	if(grill)
		var/image/grille_image = image(icon, "[base_icon_state]_grill")
		grille_image.appearance_flags = RESET_COLOR | KEEP_APART
		add_overlay(grille_image)

	underlays.Cut()
	if(can_buckle)
		var/mutable_appearance/rod_underlay = mutable_appearance('icons/obj/structures.dmi', "[base_icon_state]_rod")
		rod_underlay.pixel_y = 16
		rod_underlay.appearance_flags = RESET_COLOR | PIXEL_SCALE | TILE_BOUND | KEEP_APART
		underlays += rod_underlay


/obj/structure/wood_fire/proc/fire_is_burning_mobs()
	return has_buckled_mobs() && get_fuel_amount() >= 5

/obj/structure/wood_fire/process()

	// Are we even alight?
	if(!burning)
		return

	// Should we even be alight?
	var/datum/gas_mixture/env = loc?.return_air()
	if(env?.gas["oxygen"] < 1 || (world.time >= next_fuel_consumption && !consume_fuel()))
		extinguish()
		return

	// Ignite anything sitting on the same turf as us.
	if(isturf(loc))
		var/turf/current_turf = loc
		current_turf.hotspot_expose(1000, 500)

	// See if we can dry out anything around us, or cook any food.
	var/grilling = FALSE
	for(var/obj/item/thing in view(1, src))
		var/on_top_of_fire = thing.loc == loc
		if(on_top_of_fire)
			if(!grilling && istype(thing, /obj/item/reagent_containers/food/snacks))
				grilling = TRUE
			if(!grill)
				thing.fire_act(null, 1000, 500)
				continue
		thing.dry_out(src, max(1, 3 - get_dist(thing, src)), on_top_of_fire)

	// If we're cooking food, play a food cooking souond.
	if(grill_loop)
		if(grilling)
			if(!grill_loop.started)
				grill_loop.start(src)
		else
			if(grill_loop.started)
				grill_loop.stop(src)

	// If we're low enough, don't burn anything or put out
	// any significant heat, they need to refuel the fire.
	var/fuel_amount = get_fuel_amount()
	if(fuel_amount < 5)
		return

	// Burn anything standing on our turf.
	var/adj_fuel_amount = fuel_amount / 4
	for(var/mob/living/victim in loc)
		victim.adjust_fire_stacks(adj_fuel_amount / 4)
		victim.IgniteMob()

	// Heat up our environment.
	if(!env || abs(env.temperature - set_temperature) <= 0.1)
		return
	var/transfer_moles = 0.25 * env.total_moles
	var/datum/gas_mixture/removed = env.remove(transfer_moles)
	var/heat_transfer = removed?.get_thermal_energy_change(set_temperature)
	if(heat_transfer > 0)
		heat_transfer = min(heat_transfer, heating_power)
		removed.add_thermal_energy(heat_transfer)
	for(var/mob/living/L in view(3, src))
		L.add_modifier(/datum/modifier/endothermic, 10 SECONDS, null, TRUE)
	env.merge(removed)

/obj/structure/wood_fire/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	ignite()

/obj/structure/wood_fire/water_act(amount)
	if(prob(amount * 10))
		extinguish()

/obj/structure/wood_fire/post_buckle_mob(mob/living/M)
	if(M.buckled == src) // Just buckled someone
		M.pixel_y += 13
	else // Just unbuckled someone
		M.pixel_y -= 13
	update_icon()

// A freestanding fire for cooking food on.
/obj/structure/wood_fire/bonfire
	name = "bonfire"
	desc = "For grilling, broiling, charring, smoking, heating, roasting, toasting, simmering, searing, melting, and occasionally burning things."
	icon_state = "bonfire"

// Pre-fuelled for recipes/maps.
/obj/structure/wood_fire/bonfire/fuelled/Initialize()
	. = ..()
	for(var/i = 1 to 5)
		new /obj/item/stack/material/fuel/log(src)
	update_icon()

// Blue wood.
/obj/structure/wood_fire/bonfire/sifwood/Initialize()
	. = ..()
	for(var/i = 1 to 5)
		new /obj/item/stack/material/fuel/log/sif(src)
	update_icon()

// A smaller bonfire.
/obj/structure/wood_fire/campfire
	name = "campfire"
	desc = "A small firepit for camping. Did anyone bring the marshmallows?"
	icon_state = "campfire"
	base_icon_state = "campfire"
	can_dismantle = FALSE
	can_buckle = FALSE
	set_temperature = T0C + 20	//K
	heating_power = 40000

/obj/structure/wood_fire/campfire/get_upgrade_options()
	if(!grill)
		return list("Grill")

// more like a space heater than a bonfire. A cozier alternative to both.
/obj/structure/wood_fire/fireplace
	name = "fireplace"
	desc = "The sound of the crackling hearth reminds you of home."
	icon_state = "fireplace"
	base_icon_state = "fireplace"
	density = TRUE
	set_temperature = T0C + 20	//K
	heating_power = 40000
	can_dismantle = FALSE
	can_buckle = FALSE
	grill = TRUE

/obj/structure/wood_fire/fireplace/get_upgrade_options()
	if(!grill)
		return list("Grill")

/obj/structure/wood_fire/fireplace/stove
	name = "stove"
	desc = "A rustic, soot-stained wood-fired stove. Better check your CO detector."
	grill = FALSE
	icon_state = "stove"
	base_icon_state = "stove"

/obj/structure/wood_fire/fireplace/stove/get_upgrade_options()
	return

/obj/structure/wood_fire/fireplace/stove/get_fuel_overlay(var/fuel_amount)
	. = ..()
	if(!.)
		. = "[base_icon_state]_cover"
	else if(islist(.))
		. += "[base_icon_state]_cover"
	else
		. = list(., "[base_icon_state]_cover")
