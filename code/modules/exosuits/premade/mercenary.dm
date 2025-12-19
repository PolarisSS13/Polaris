/mob/living/exosuit/premade/mercenary
	name = "mercenary exosuit"
	desc = "A heavily armored combat exosuit."

/obj/item/mech_component/manipulators/mercenary/painted
	color = COLOR_TITANIUM

/obj/item/mech_component/propulsion/mercenary/painted
	color = COLOR_TITANIUM

/obj/item/mech_component/sensors/mercenary/painted
	color = COLOR_TITANIUM

/obj/item/mech_component/chassis/mercenary/painted
	color = COLOR_TITANIUM

/mob/living/exosuit/premade/mercenary/Initialize()
	if(!arms)
		arms = new /obj/item/mech_component/manipulators/mercenary/painted(src)
	if(!legs)
		legs = new /obj/item/mech_component/propulsion/mercenary/painted(src)
	if(!head)
		head = new /obj/item/mech_component/sensors/mercenary/painted(src)
	if(!body)
		body = new /obj/item/mech_component/chassis/mercenary/painted(src)
	. = ..()

/mob/living/exosuit/premade/mercenary/spawn_mech_equipment()
	..()
	install_system_initialize(new /obj/item/mech_equipment/mounted_system/taser/laser(src), HARDPOINT_LEFT_HAND)
	install_system_initialize(new /obj/item/mech_equipment/mounted_system/taser/ion(src), HARDPOINT_RIGHT_HAND)

/mob/living/exosuit/premade/mercenary/merc/Initialize()
	. = ..()
	if(arms)
		arms.color = COLOR_RED
	if(legs)
		legs.color = COLOR_RED
	if(head)
		head.color = COLOR_RED
	if(body)
		body.color = COLOR_DARK_GUNMETAL

/mob/living/exosuit/premade/mercenary/merc/spawn_mech_equipment()
	install_system_initialize(new /obj/item/mech_equipment/mounted_system/taser(src), HARDPOINT_LEFT_HAND)
	install_system_initialize(new /obj/item/mech_equipment/mounted_system/taser/laser(src), HARDPOINT_RIGHT_HAND)
