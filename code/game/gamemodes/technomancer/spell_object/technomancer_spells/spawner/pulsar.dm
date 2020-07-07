/datum/technomancer_catalog/spell/pulsar
	name = "Pulsar"
	cost = 100
	category = OFFENSIVE_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/spawner/pulsar)


/datum/spell_metadata/spawner/pulsar
	name = "Pulsar"
	desc = "Emits electronic pulses to destroy, disable, or otherwise harm devices and machines. \
	The pulsar will hit everything within range, including allies. \
	Be sure to not hit yourself with this if you're a machine."
	icon_state = "tech_pulsar"
	aspect = ASPECT_SHOCK
	spell_path = /obj/item/weapon/spell/technomancer/spawner/pulsar
	cooldown = 20 SECONDS


/obj/item/weapon/spell/technomancer/spawner/pulsar
	name = "pulsar"
	desc = "Be sure to keep your distance if you're a machine."
	icon_state = "pulsar"
	spawn_sound = 'sound/effects/magic/technomancer/death.ogg'
	spawner_type = /obj/effect/temp_visual/pulse/pulsar
	energy_cost = 2000
	instability_cost = 8


/obj/effect/temp_visual/pulse/pulsar
	name = "pulsar"
	desc = "If this was a real pulsar, you would be very dead. Still emits a lot of EMPs."
	icon_state = "shield2"
	light_range = 4
	light_power = 5
	light_color = "#2ECCFA"
	pulses_remaining = 3
	pulse_delay = 2 SECONDS
	var/emp_first_range = 1
	var/emp_second_range = 2
	var/emp_third_range = 3
	var/emp_fourth_range = 4

/obj/effect/temp_visual/pulse/pulsar/Initialize()
	add_filter("pulsar_ray", 1, list(type = "rays", size = WORLD_ICON_SIZE * emp_fourth_range, color = "#2ECCFA"))
	animate(get_filter("pulsar_ray"), offset = 20, time = (pulses_remaining + 1) * pulse_delay)
	return ..()

/obj/effect/temp_visual/pulse/pulsar/Destroy()
	remove_filter("pulsar_ray")
	return ..()

/obj/effect/temp_visual/pulse/pulsar/on_pulse()
	empulse(src, emp_first_range, emp_second_range, emp_third_range, emp_fourth_range, log = 1)