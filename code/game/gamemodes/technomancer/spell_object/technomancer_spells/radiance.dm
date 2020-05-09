/datum/technomancer_catalog/spell/radiance
	name = "Radiance"
	cost = 100
	category = OFFENSIVE_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/radiance)

/datum/spell_metadata/radiance
	name = "Radiance"
	desc = "Causes you to be very radiant, glowing brightly in visible light, thermal energy, and deadly ionizing radiation. \
	Every few seconds, you will have an energy flare up, briefly flashing anyone who is looking at you, afflicting them with \
	an intense glow that prevents stealth for a short period of time, and if they are close enough, it will also light them on fire. \
	Note that you are NOT protected from the radiation and heat."
	aspect = ASPECT_LIGHT
	icon_state = "tech_radiance"
	spell_path = /obj/item/weapon/spell/technomancer/radiance

/datum/spell_metadata/radiance/get_spell_info()
	var/obj/item/weapon/spell/technomancer/radiance/spell = spell_path
	var/tick_rate = SSobj.wait
	. = list()
	.["Energy Cost"] = "[initial(spell.energy_per_tick)] every [DisplayTimeText(tick_rate)]"
	.["Instability Cost"] = "[initial(spell.instability_per_tick)] every [DisplayTimeText(tick_rate)]"
	.["Radiation Strength"] = "[initial(spell.radiation_strength)]Bq"
	.["Flare Interval"] = DisplayTimeText(initial(spell.flare_interval) * tick_rate)
	.["Scepter Flare Interval"] = DisplayTimeText(initial(spell.scepter_flare_interval) * tick_rate)
	.["Corona Radius"] = initial(spell.effect_radius)
	.["Ignition Radius"] = initial(spell.ignition_radius)


/obj/item/weapon/spell/technomancer/radiance
	name = "radiance"
	desc = "You will glow with a radiance similar to that of Supermatter."
	icon_state = "radiance"
	toggled = 1
	var/energy_per_tick = 500
	var/instability_per_tick = 2
	var/radiation_strength = 25
	var/thermal_power = 100000
	var/temperature_cap = 10000

	var/ticks_until_flare = 3
	var/flare_interval = 3
	var/scepter_flare_interval = 2

	var/datum/looping_sound/supermatter/soundloop
	var/ray_filter_name = "radiance"
	var/ray_offset = 0
	var/offset_per_tick = 3
	var/ray_size = 4 // In tiles.

	var/effect_radius = 4
	var/ignition_radius = 2

/obj/item/weapon/spell/technomancer/radiance/Initialize()
	set_light(7, 4, l_color = "#D9D900")

	playsound(owner, 'sound/effects/magic/technomancer/generic_cast.ogg', 75, 1)

	soundloop = new(list(src), FALSE)
	soundloop.volume = 20
	soundloop.start()

	START_PROCESSING(SSobj, src)
	log_and_message_admins("has begun channeling [src].")
	return ..()

/obj/item/weapon/spell/technomancer/radiance/on_spell_given(mob/user)
	ray_filter_name = "[ray_filter_name]-[REF(src)]" // So someone with two radiances will have seperate filters hopefully.

	if(!owner.get_filter(ray_filter_name))
		owner.add_filter(ray_filter_name, 1, list(type = "rays", size = WORLD_ICON_SIZE * ray_size, color = "#D9D900"))
		handle_animation()

/obj/item/weapon/spell/technomancer/radiance/Destroy()
	owner.remove_filter(ray_filter_name)

	soundloop.stop()
	QDEL_NULL(soundloop)

	STOP_PROCESSING(SSobj, src)
	log_and_message_admins("has stopped channeling [src].")
	return ..()

/obj/item/weapon/spell/technomancer/radiance/process()
	handle_heat()

	handle_radiation()

	handle_animation()

	ticks_until_flare--
	if(ticks_until_flare <= 0)
		flare()

		if(check_for_scepter())
			ticks_until_flare = scepter_flare_interval
		else
			ticks_until_flare = flare_interval

	adjust_instability(instability_per_tick)

/obj/item/weapon/spell/technomancer/radiance/proc/handle_heat()
	var/turf/T = get_turf(src)

	var/datum/gas_mixture/env = T.return_air()
	if(env)
		env.add_thermal_energy(thermal_power)

/obj/item/weapon/spell/technomancer/radiance/proc/handle_radiation()
	SSradiation.radiate(src, radiation_strength)

/obj/item/weapon/spell/technomancer/radiance/proc/handle_animation()
	ray_offset += offset_per_tick

	animate(owner.get_filter(ray_filter_name), offset = ray_offset, time = SSobj.wait)

/obj/item/weapon/spell/technomancer/radiance/proc/flare()
	playsound(owner, 'sound/effects/magic/technomancer/charge.ogg', 75, 1)
	new /obj/effect/explosion(get_turf(owner))

	// Burn people or make them glow.
	var/list/nearby_things = range(get_turf(src), effect_radius)
	for(var/mob/living/L in nearby_things)
		if(is_technomancer_ally(L))
			continue

		if(get_dist(L, owner) <= ignition_radius)
			L.add_modifier(/datum/modifier/fire, 10 SECONDS) // Approximately 25 burn per stack.

		L.add_modifier(/datum/modifier/technomancer/corona, 6 SECONDS)

	// Flash people.
	for(var/mob/living/L in viewers(src))
		var/dir_towards_us = get_dir(L, src)
		if(L.dir && L.dir & dir_towards_us)
			to_chat(L, span("danger", "The flash of light from \the [src] blinds you briefly!"))
			L.flash_eyes(intensity = FLASH_PROTECTION_MODERATE, override_blindness_check = FALSE, affect_silicon = TRUE)


/datum/modifier/technomancer/corona
	name = "corona"
	desc = "You appear to be glowing really bright.  It doesn't seem to hurt, however hiding will be impossible."
	mob_overlay_state = "corona"

	on_created_text = "<span class='warning'>You start to glow very brightly!</span>"
	on_expired_text = "<span class='notice'>Your glow has ended.</span>"
	evasion = -30
	stacks = MODIFIER_STACK_EXTEND

/datum/modifier/technomancer/corona/tick()
	holder.break_cloak()
