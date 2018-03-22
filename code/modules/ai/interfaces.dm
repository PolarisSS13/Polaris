// 'Interfaces' are procs that the ai_holder datum uses to communicate its will to the mob its attached.
// The reason for using this proc in the middle is to ensure the AI has some form of compatibility with most mob types,
// since some actions work very differently between mob types (e.g. executing an attack as a simple animal compared to a human).
// The AI can just call holder.IAttack(target) and the mob is responsible for determining how to actually attack the target.

/mob/living/proc/IAttack(atom/A)
	return FALSE

/mob/living/simple_animal/IAttack(atom/A)
	return attack_target(A)

/mob/living/proc/IRangedAttack(atom/A)
	return FALSE

/mob/living/simple_animal/IRangedAttack(atom/A)
	return shoot_target(A)

/mob/living/proc/ISpecialAttack(atom/A)
	return FALSE

/mob/living/simple_animal/ISpecialAttack(atom/A)
	return special_attack_target()

/mob/living/proc/ISay(message)

/mob/living/proc/IIsAlly(mob/living/L)
	return src.faction == L.faction

/mob/living/simple_animal/IIsAlly(mob/living/L)
	. = ..()
	if(!.) // Outside the faction, try to see if they're friends.
		return L in friends

/mob/living/proc/IGetID()

/mob/living/simple_animal/IGetID()
	if(myid)
		return myid.GetID()