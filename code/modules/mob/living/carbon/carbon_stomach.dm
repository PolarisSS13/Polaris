/mob/living/carbon/proc/can_devour(atom/movable/victim, var/silent = FALSE)
	return (FAT in mutations) && ismini(victim) ? DEVOUR_SLOW : FALSE

/mob/living/carbon/proc/get_stomach_contents()
	return contents

/mob/living/carbon/proc/remove_from_stomach(var/atom/movable/A)
	if(!istype(A))
		return
	A.dropInto(get_turf(src))

/mob/living/carbon/proc/move_to_stomach(atom/movable/victim)
	victim.forceMove(src)

/mob/living/carbon/proc/devour(atom/movable/victim)
	var/can_eat = can_devour(victim)
	if(!can_eat)
		return FALSE
	var/eat_speed = 100
	if(can_eat == DEVOUR_FAST)
		eat_speed = 30
	visible_message(SPAN_DANGER("\The [src] is attempting to devour \the [victim] whole!"))
	var/mob/target = victim
	if(isobj(victim))
		target = src
	if(!do_mob(src,target,eat_speed))
		return FALSE
	visible_message(SPAN_DANGER("\The [src] devours \the [victim] whole!"))
	if(ismob(victim))
		add_attack_logs(src, victim, "Devoured")
	else
		drop_from_inventory(victim)
	move_to_stomach(victim)
	return TRUE

/mob/living/carbon/proc/get_gluttony_flags()
	return 0

/mob/living/carbon/empty_stomach()
	var/gluttony_flags = get_gluttony_flags()
	for(var/atom/movable/AM as anything in get_stomach_contents())
		remove_from_stomach(AM)
		if(gluttony_flags & GLUT_PROJECTILE_VOMIT)
			AM.throw_at(get_edge_target_turf(src, dir), 7, 7, src)
