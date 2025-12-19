/obj/item/mech_component/manipulators
	name = "arms"
	pixel_y = -12
	icon_state = "loader_arms"
	has_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)

	var/melee_damage = 15
	var/action_delay = 15
	var/obj/item/robot_parts/robot_component/actuator/motivator
	power_use = 10

/obj/item/mech_component/manipulators/Destroy()
	QDEL_NULL(motivator)
	. = ..()

/obj/item/mech_component/manipulators/show_missing_parts(var/mob/user)
	if(!motivator)
		. += SPAN_WARNING("It is missing an actuator.")

/obj/item/mech_component/manipulators/ready_to_install()
	return motivator

/obj/item/mech_component/manipulators/prebuild()
	motivator = new(src)

/obj/item/mech_component/manipulators/attackby(var/obj/item/thing, var/mob/user)
	if(istype(thing,/obj/item/robot_parts/robot_component/actuator))
		if(motivator)
			to_chat(user, SPAN_WARNING("\The [src] already has an actuator installed."))
		else if(install_component(thing, user))
			motivator = thing
		return
	return ..()

/obj/item/mech_component/manipulators/update_components()
	motivator = locate() in src

/*
 * Variants
 */

/obj/item/mech_component/manipulators/combat
	name = "combat arms"
	exosuit_desc_string = "flexible, advanced manipulators"
	icon_state = "combat_arms"
	melee_damage = 5
	action_delay = 10
	power_use = 50

/obj/item/mech_component/manipulators/industrial
	name = "exosuit arms"
	exosuit_desc_string = "heavy-duty industrial lifters"
	icon_state = "industrial_arms"
	max_damage = 70
	power_use = 30
	desc = "The Industrial Digital Interaction Manifolds allow you poke untold dangers from the relative safety of your cockpit."

/obj/item/mech_component/manipulators/heavy
	name = "heavy arms"
	exosuit_desc_string = "super-heavy reinforced manipulators"
	icon_state = "heavy_arms"
	desc = "Designed to function where any other piece of equipment would have long fallen apart, the Hephaestus Superheavy Lifter series can take a beating and excel at delivering it."
	melee_damage = 25
	action_delay = 15
	max_damage = 90
	power_use = 60

/obj/item/mech_component/manipulators/light
	name = "light arms"
	exosuit_desc_string = "lightweight, segmented manipulators"
	icon_state = "light_arms"
	melee_damage = 5
	action_delay = 15
	max_damage = 40
	power_use = 10
	desc = "As flexible as they are fragile, these Vey-Med manipulators can follow a pilot's movements in close to real time."

/obj/item/mech_component/manipulators/mercenary
	name = "mercenary arms"
	exosuit_desc_string = "super-mercenary reinforced manipulators"
	icon_state = "mercenary_arms"
	desc = "Designed to function where any other piece of equipment would have long fallen apart, the Supermercenary Lifter series can take a beating and excel at delivering it."
	melee_damage = 25
	action_delay = 15
	max_damage = 90
	power_use = 60

/obj/item/mech_component/manipulators/modern
	name = "modern arms"
	exosuit_desc_string = "flexible, advanced manipulators"
	icon_state = "modern_arms"
	melee_damage = 5
	action_delay = 10
	power_use = 50

/obj/item/mech_component/manipulators/powerloader
	name = "exosuit arms"
	exosuit_desc_string = "heavy-duty industrial lifters"
	max_damage = 70
	power_use = 30
	desc = "The Xion Industrial Digital Interaction Manifolds allow you poke untold dangers from the relative safety of your cockpit."

/obj/item/mech_component/manipulators/sleek
	name = "sleek arms"
	exosuit_desc_string = "sleekweight, segmented manipulators"
	icon_state = "sleek_arms"
	melee_damage = 5
	action_delay = 15
	max_damage = 40
	power_use = 10
	desc = "As flexible as they are fragile, these Vey-Med manipulators can follow a pilot's movements in close to real time."
