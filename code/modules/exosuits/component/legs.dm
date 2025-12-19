/obj/item/mech_component/propulsion
	name = "legs"
	pixel_y = 12
	icon_state = "loader_legs"
	var/move_delay = 5
	var/turn_delay = 5
	var/obj/item/robot_parts/robot_component/actuator/motivator
	power_use = 50

/obj/item/mech_component/propulsion/Destroy()
	QDEL_NULL(motivator)
	. = ..()

/obj/item/mech_component/propulsion/show_missing_parts(var/mob/user)
	if(!motivator)
		. += SPAN_WARNING("It is missing an actuator.")

/obj/item/mech_component/propulsion/ready_to_install()
	return motivator

/obj/item/mech_component/propulsion/update_components()
	motivator = locate() in src

/obj/item/mech_component/propulsion/attackby(var/obj/item/thing, var/mob/user)
	if(istype(thing,/obj/item/robot_parts/robot_component/actuator))
		if(motivator)
			to_chat(user, SPAN_WARNING("\The [src] already has an actuator installed."))
			return
		if(install_component(thing, user)) motivator = thing
	else
		return ..()

/obj/item/mech_component/propulsion/prebuild()
	motivator = new(src)

/obj/item/mech_component/propulsion/proc/can_move_on(var/turf/location, var/turf/target_loc)
	return isatom(location) && istype(target_loc)

/*
 * Variants
 */

/obj/item/mech_component/propulsion/combat
	name = "combat legs"
	exosuit_desc_string = "sleek hydraulic legs"
	icon_state = "combat_legs"
	move_delay = 3
	turn_delay = 3
	power_use = 20

/obj/item/mech_component/propulsion/industrial
	name = "exosuit legs"
	exosuit_desc_string = "reinforced hydraulic legs"
	desc = "Wide and stable but not particularly fast."
	icon_state = "industrial_legs"
	max_damage = 70
	move_delay = 4
	turn_delay = 4
	power_use = 10

/obj/item/mech_component/propulsion/heavy
	name = "heavy legs"
	exosuit_desc_string = "heavy hydraulic legs"
	desc = "Oversized actuators struggle to move these armoured legs. "
	icon_state = "heavy_legs"
	move_delay = 5
	turn_delay = 5
	max_damage = 160
	power_use = 100

/obj/item/mech_component/propulsion/spider
	name = "quadlegs"
	exosuit_desc_string = "hydraulic quadlegs"
	desc = "Xion Industrial's arachnid series boasts more leg per leg than the leading competitor."
	icon_state = "spiderlegs"
	max_damage = 80
	move_delay = 4
	turn_delay = 1
	power_use = 25

/obj/item/mech_component/propulsion/tracks
	name = "tracks"
	exosuit_desc_string = "armored tracks"
	desc = "A classic brought back. The Hephaestus' Landmaster class tracks are impervious to most damage and can maintain top speed regardless of load. Watch out for corners."
	icon_state = "tracks"
	max_damage = 150
	move_delay = 2 //It´s fast
	turn_delay = 7
	power_use = 150
	color = COLOR_WHITE

/obj/item/mech_component/propulsion/light
	name = "light legs"
	exosuit_desc_string = "aerodynamic electromechanic legs"
	icon_state = "light_legs"
	move_delay = 2
	turn_delay = 3
	max_damage = 40
	power_use = 5
	desc = "The electrical systems driving these legs are almost totally silent. Unfortunately slamming a plate of metal against the ground is not."

/obj/item/mech_component/propulsion/mercenary
	name = "mercenary legs"
	exosuit_desc_string = "mercenary hydraulic legs"
	desc = "Oversized actuators struggle to move these armoured legs. "
	icon_state = "mercenary_legs"
	move_delay = 5
	turn_delay = 5
	max_damage = 160
	power_use = 100

/obj/item/mech_component/propulsion/modern
	name = "modern legs"
	exosuit_desc_string = "sleek hydraulic legs"
	icon_state = "modern_legs"
	move_delay = 3
	turn_delay = 3
	power_use = 20

/obj/item/mech_component/propulsion/powerloader
	name = "exosuit legs"
	exosuit_desc_string = "reinforced hydraulic legs"
	desc = "Wide and stable but not particularly fast."
	max_damage = 70
	move_delay = 4
	turn_delay = 4
	power_use = 10

/obj/item/mech_component/propulsion/sleek
	name = "sleek legs"
	exosuit_desc_string = "aerodynamic electromechanic legs"
	icon_state = "sleek_legs"
	move_delay = 2
	turn_delay = 3
	max_damage = 40
	power_use = 5
	desc = "The electrical systems driving these legs are almost totally silent. Unfortunately slamming a plate of metal against the ground is not."
