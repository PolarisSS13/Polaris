/mob/living/exosuit/premade/sleek
	name = "sleek exosuit"
	desc = "A sleek and agile exosuit."

/obj/item/mech_component/manipulators/sleek/painted
	color = COLOR_OFF_WHITE

/obj/item/mech_component/propulsion/sleek/painted
	color = COLOR_OFF_WHITE

/obj/item/mech_component/sensors/sleek/painted
	color = COLOR_OFF_WHITE

/obj/item/mech_component/chassis/sleek/painted
	color = COLOR_OFF_WHITE

/mob/living/exosuit/premade/sleek/Initialize()
	if(!arms)
		arms = new /obj/item/mech_component/manipulators/sleek/painted(src)
	if(!legs)
		legs = new /obj/item/mech_component/propulsion/sleek/painted(src)
	if(!head)
		head = new /obj/item/mech_component/sensors/sleek/painted(src)
	if(!body)
		body = new /obj/item/mech_component/chassis/sleek/painted(src)

	return ..()

/mob/living/exosuit/premade/sleek/spawn_mech_equipment()
	..()
	install_system_initialize(new /obj/item/mech_equipment/catapult(src), HARDPOINT_LEFT_HAND)
	install_system_initialize(new /obj/item/mech_equipment/sleeper(src), HARDPOINT_BACK)
	install_system_initialize(new /obj/item/mech_equipment/light(src), HARDPOINT_HEAD)

/obj/item/mech_component/manipulators/sleek
	name = "sleek arms"
	exosuit_desc_string = "sleekweight, segmented manipulators"
	icon_state = "sleek_arms"
	melee_damage = 5
	action_delay = 15
	max_damage = 40
	power_use = 10
	desc = "As flexible as they are fragile, these Vey-Med manipulators can follow a pilot's movements in close to real time."

/obj/item/mech_component/propulsion/sleek
	name = "sleek legs"
	exosuit_desc_string = "aerodynamic electromechanic legs"
	icon_state = "sleek_legs"
	move_delay = 2
	turn_delay = 3
	max_damage = 40
	power_use = 5
	desc = "The electrical systems driving these legs are almost totally silent. Unfortunately slamming a plate of metal against the ground is not."

/obj/item/mech_component/sensors/sleek
	name = "sleek sensors"
	gender = PLURAL
	exosuit_desc_string = "advanced sensor array"
	icon_state = "sleek_head"
	max_damage = 30
	vision_flags = SEE_TURFS
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	power_use = 50
	desc = "A series of high resolution optical sensors. They can overlay several images to give the pilot a sense of location even in total darkness. "

/obj/item/mech_component/sensors/sleek/prebuild()
	..()
	software = new(src)
	software.installed_software = list(MECH_SOFTWARE_UTILITY, MECH_SOFTWARE_MEDICAL)

/obj/item/mech_component/chassis/sleek
	name = "sleek exosuit chassis"
	hatch_descriptor = "canopy"
	pilot_coverage = 100
	transparent_cabin =  TRUE
	exosuit_desc_string = "an open and sleek chassis"
	icon_state = "sleek_body"
	max_damage = 50
	mech_health = 200
	power_use = 5
	has_hardpoints = list(HARDPOINT_BACK)
	desc = "The Veymed Odysseus series cockpits combine ultrasleek materials and clear aluminium laminates to provide an optimized cockpit experience."

/obj/item/mech_component/chassis/sleek/prebuild()
	. = ..()
	armour = new /obj/item/robot_parts/robot_component/armour/exosuit/radproof(src)

/obj/item/mech_component/chassis/sleek/Initialize()
	pilot_positions = list(
		list(
			"[NORTH]" = list("x" = 8,  "y" = 0),
			"[SOUTH]" = list("x" = 8,  "y" = 0),
			"[EAST]"  = list("x" = 3,  "y" = 0),
			"[WEST]"  = list("x" = 13, "y" = 0)
		)
	)
	return ..()
