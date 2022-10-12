/mob/living/carbon/human/get_gluttony_flags()
	return species.gluttonous

/mob/living/carbon/human/get_stomach_contents()
	var/obj/item/stomach = internal_organs_by_name[O_STOMACH]
	return stomach?.contents

/mob/living/carbon/human/can_devour(atom/movable/victim, var/silent = FALSE)

	var/obj/item/organ/internal/stomach/stomach = internal_organs_by_name[O_STOMACH]
	if(!istype(stomach) || stomach.is_broken())
		if(!silent)
			to_chat(src, SPAN_WARNING("Your stomach is not functional!"))
		return FALSE

	if(!stomach.can_eat_atom(victim))
		if(!silent)
			to_chat(src, SPAN_WARNING("You are not capable of devouring \the [victim] whole!"))
		return FALSE

	if(stomach.is_full(victim))
		if(!silent)
			to_chat(src, SPAN_WARNING("Your [stomach.name] is full!"))
		return FALSE

	. = stomach.get_devour_time(victim) || ..()

/mob/living/carbon/human/move_to_stomach(atom/movable/victim)
	var/obj/item/organ/internal/stomach = internal_organs_by_name[O_STOMACH]
	if(istype(stomach))
		victim.forceMove(stomach)

/mob/living/carbon/human/attackby(obj/item/I, mob/user)
	if(user == src && user.zone_sel.selecting == O_MOUTH && can_devour(I, silent = TRUE))
		var/obj/item/blocked = src.check_mouth_coverage()
		if(blocked)
			to_chat(user, SPAN_WARNING("\The [blocked] is in the way!"))
			return TRUE
		if(devour(I))
			return TRUE

/mob/living/carbon/human/take_internal_stomach_damage(var/d)
	var/obj/item/organ/external/organ = get_organ(BP_TORSO)
	if(istype(organ) && organ.take_damage(d, 0))
		UpdateDamageIcon()
		updatehealth()
