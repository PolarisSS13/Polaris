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
