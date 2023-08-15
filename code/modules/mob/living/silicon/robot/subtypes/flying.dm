/mob/living/silicon/robot/flying
	desc = "A utility robot with an anti-gravity hover unit and a lightweight frame."
	icon = 'icons/mob/robots/robots_flying.dmi'
	module_category = ROBOT_MODULE_TYPE_FLYING
	dismantle_type = /obj/item/robot_parts/frame/flyer
	power_efficiency = 0.75

	// They are not very heavy or strong.
	mob_size =       MOB_SMALL
	mob_bump_flag =  SIMPLE_ANIMAL
	mob_swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	mob_push_flags = MONKEY|SLIME|SIMPLE_ANIMAL

/mob/living/silicon/robot/flying/update_floating()
	if(hovering)
		make_floating(TRUE)
		return
	..()

/mob/living/silicon/robot/flying/initialize_components()
	components["actuator"] =       new/datum/robot_component/actuator(src)
	components["radio"] =          new/datum/robot_component/radio(src)
	components["power cell"] =     new/datum/robot_component/cell(src)
	components["diagnosis unit"] = new/datum/robot_component/diagnosis_unit(src)
	components["camera"] =         new /datum/robot_component/camera(src)
	components["comms"] =          new/datum/robot_component/binary_communication(src)
	components["armour"] =         new/datum/robot_component/armour/light(src)

/mob/living/silicon/robot/flying/Life()
	. = ..()
	if(incapacitated() || !is_component_functioning("actuator"))
		stop_hovering()
	else
		start_hovering()

/mob/living/silicon/robot/flying/proc/start_hovering()
	if(!hovering)
		hovering = TRUE
		pass_flags |= PASSTABLE
		default_pixel_y = 0
	update_floating()

/mob/living/silicon/robot/flying/proc/stop_hovering()
	if(hovering)
		hovering = FALSE
		pass_flags &= ~PASSTABLE
		default_pixel_y = -8
	update_floating()

/mob/living/silicon/robot/flying/death()
	. = ..()
	if(!QDELETED(src) && stat == DEAD)
		stop_hovering()

/mob/living/silicon/robot/flying/Allow_Spacemove(var/dense_object)
	return hovering || ..()

/mob/living/silicon/robot/flying/Process_Spaceslipping(var/prob_slip = 5)
	return ..(hovering ? 0 : prob_slip)

/mob/living/silicon/robot/flying/can_fall(anchor_bypass = FALSE, turf/location_override = loc)
	return !hovering && ..()

/mob/living/silicon/robot/flying/can_overcome_gravity()
	return hovering
