/*
/// For Skathari
/// In its own file to easily expand upon. Mob found in alien.dm 
*/

/datum/ai_holder/simple_mob/xeno_alien /// Basic
	hostile = TRUE
	retaliate = TRUE
	cooperative = TRUE
	returns_home = FALSE
	can_flee = FALSE
	speak_chance = 0
	wander = TRUE
	base_wander_delay = 4

/datum/ai_holder/simple_mob/xeno_alien/post_melee_attack(atom/A)
	if(holder.Adjacent(A))
		holder.IMove(get_step(holder, pick(alldirs)))
		holder.face_atom(A)

/datum/ai_holder/simple_mob/xeno_alien/ranged /// Drones
	pointblank = TRUE
	ignore_incapacitated = TRUE /// We're squishier and our tox hits hard. Focus on who's up. 
	var/run_if_this_close = 4
	var/max_distance = 6

/datum/ai_holder/simple_mob/xeno_alien/ranged/on_engagement(atom/A)
	if(get_dist(holder, A) < run_if_this_close)
		holder.IMove(get_step_away(holder, A, run_if_this_close))
		holder.face_atom(A)
	else if(get_dist(holder, A) > max_distance)
		holder.IMove(get_step_towards(holder, A))
		holder.face_atom(A)

/datum/ai_holder/simple_mob/xeno_alien/empress /// Big mama
	ignore_incapacitated = TRUE /// Focus on better threats. 
	intelligence_level = AI_SMART /// She's got the brains