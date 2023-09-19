/mob/living/exosuit/premade/modern
	name = "modern exosuit"
	desc = "A sleek, modern modern exosuit."

/mob/living/exosuit/premade/modern/Initialize()
	if(!arms)
		arms = new /obj/item/mech_component/manipulators/modern(src)
		arms.color = COLOR_DARK_GUNMETAL
	if(!legs)
		legs = new /obj/item/mech_component/propulsion/modern(src)
		legs.color = COLOR_DARK_GUNMETAL
	if(!head)
		head = new /obj/item/mech_component/sensors/modern(src)
		head.color = COLOR_DARK_GUNMETAL
	if(!body)
		body = new /obj/item/mech_component/chassis/modern(src)
		body.color = COLOR_DARK_GUNMETAL

	return ..()

/mob/living/exosuit/premade/modern/spawn_mech_equipment()
	..()
	install_system_initialize(new /obj/item/mech_equipment/mounted_system/taser(src), HARDPOINT_LEFT_HAND)
	install_system_initialize(new /obj/item/mech_equipment/mounted_system/taser/ion(src), HARDPOINT_RIGHT_HAND)

/obj/item/mech_component/manipulators/modern
	name = "modern arms"
	exosuit_desc_string = "flexible, advanced manipulators"
	icon_state = "modern_arms"
	melee_damage = 5
	action_delay = 10
	power_use = 50

/obj/item/mech_component/propulsion/modern
	name = "modern legs"
	exosuit_desc_string = "sleek hydraulic legs"
	icon_state = "modern_legs"
	move_delay = 3
	turn_delay = 3
	power_use = 20

/obj/item/mech_component/sensors/modern
	name = "modern sensors"
	gender = PLURAL
	exosuit_desc_string = "high-resolution thermal sensors"
	icon_state = "modern_head"
	vision_flags = SEE_MOBS
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	power_use = 200

/obj/item/mech_component/sensors/modern/prebuild()
	..()
	software = new(src)
	software.installed_software = list(MECH_SOFTWARE_WEAPONS, MECH_SOFTWARE_ADVWEAPONS)

/obj/item/mech_component/chassis/modern
	name = "sealed exosuit chassis"
	hatch_descriptor = "canopy"
	pilot_coverage = 100
	hide_pilot = TRUE
	exosuit_desc_string = "an armoured chassis"
	icon_state = "modern_body"
	power_use = 40
	mech_health = 350

/obj/item/mech_component/chassis/modern/prebuild()
	. = ..()
	armor = new /obj/item/robot_parts/robot_component/armour/exosuit/combat(src)

/obj/item/mech_component/chassis/modern/Initialize()
	pilot_positions = list(
		list(
			"[NORTH]" = list("x" = 8,  "y" = 8),
			"[SOUTH]" = list("x" = 8,  "y" = 8),
			"[EAST]"  = list("x" = 4,  "y" = 8),
			"[WEST]"  = list("x" = 12, "y" = 8)
		)
	)

	return ..()
