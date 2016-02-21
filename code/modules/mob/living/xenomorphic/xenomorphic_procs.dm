/*
Fun stuff for xenos
Leaving in xenomorphic so that it can be utilized for other creatures with ease, designed around slimes originally.
*/
//General mutation proc, currently called for spawning mutant slimes from
/mob/living/xenomorphic/proc/Mutate(atom/A)
	var/mob/living/xenomorphic/target = A
	prob((35+target.instability))
		if(target.colored)
			target.color = "#"
			for(i=0, i<5, i++)
				target.color += pick(hexNumbs)
		nameVar = "mutated"
		
	return 1
	
//Apparently metabolism is specific to carbon life forms, so let's write simplified reagents processing for the slimes.
/mob/living/xenomorphic/proc/handle_reagents()
	if(!internal_reagents)
		return
		
	if(internal_reagents.total_volume <= 0)
		return
		
	for(var/datum/reagent/R in src.internal_reagents.reagents_list)
	
		var/reagent_vol = src.internal_reagents.reagents.get_reagent_amount(R.id)
		
		if(!(stat == DEAD))
			if(toxic_internal[R.id])
				//Toxic damage here
				
			if(beneficial_internal[R.id])
				//healing/other here
				
			if(mut_internal[R.id])
				//mutating stuff here
	return
	
//Target related procs go here
/mob/living/xenomorphic/proc/Target_Finding()
	return
	
/mob/living/xenomorphic/proc/PickTarget()
	return