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
