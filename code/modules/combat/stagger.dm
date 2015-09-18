/mob/living/simple_animal
	var/stagger = 0

/mob/living/simple_animal/construct/armoured
	stagger = 4

/obj/item/weapon
	var/stagger = 0 //If this is 1 or higher, it has a chance of staggering anyone hit.

/obj/item/weapon/attack(mob/living/M as mob, mob/living/user as mob, def_zone)
	. = ..()
	if(.)
		if(stagger)
			M.stagger(user,strength = stagger)

/mob/living/proc/stagger(var/mob/living/user = null, var/turf/T = null, var/strength = 1)
	if(!src)
		return

	src.hide_balance_hud = 0

	if(balance <= 0)
		return //This is to prevent stunlocking.

	//First, check to see if we can resist the stagger.
	var/poise = src.get_poise()
	if(Debug2)
		world.log << "## DEBUG: poise of [src] is [src.get_poise()]."

	if(poise != 0 || !(poise < strength) ) //If we have no poise, or if the force is overwheling, skip the resist chance.
		if(Debug2)	world.log << "## DEBUG: Passed check to attempt resisting stagger."
		if(poise > strength + 2) //We have so much poise that we can never be staggered from this attack.
			if(Debug2)
				world.log << "## DEBUG: poise was so high that [src] auto-resisted."
			visible_message("<span class='warning'>[src] withstands the impact!</span>",
			"<span class='attack'>Your armor protects you from being displaced.</span>")
			return
		if(Debug2)
			world.log << "## DEBUG: Resist starting now."
		var/resist_difficulty = (poise - strength)	//If we have equal poise to the stagger's strength, we have a 50% chance of resisting.
		var/resist_roll = rand(1,resist_difficulty + 2)	//If we have one point higher, it's 66%, and for two points it's 75%.
		if(Debug2)
			world.log << "## DEBUG: resist_difficulty = [resist_difficulty]."
		if(Debug2)
			world.log << "## DEBUG: resist_roll: we rolled [resist_roll] out of [resist_difficulty+2]."
		if( !(resist_roll == 1) ) //Did we succeed?
			if(Debug2)
				world.log << "## DEBUG: Resist successful."
			visible_message("<span class='attack'>[src] resists the impact!</span>",
			"<span class='danger'>Your armor protects you from being staggered.</span>")
			return
		if(Debug2)
			world.log << "## DEBUG: Resist failed."
		//If we didn't succeed, then downwards we go.

	var/remaining_balance = max(src.balance - Ceiling(strength / 2),0) //High weapon stagger will deplete balance faster.
	remaining_balance = max(remaining_balance + Ceiling(poise / 2), 0)  //But high poise will make it slower.

	if(remaining_balance == src.balance)
		remaining_balance = remaining_balance - 1

	src.balance = remaining_balance

	update_balance_hud()

	if(src.balance <= 0)
		var/a = rand(1,3)
		switch(a)
			if(1)
				visible_message("<span class='attack'>[src] is knocked down to the ground!</span>",
				"<span class='danger'>You are knocked down to the ground!</span>")
			if(2)
				visible_message("<span class='attack'>[src] is smashed into the ground from [user ? "\the [user]'s" : "an"] overwhelming force!</span>",
				"<span class='danger'>You're smashed into the ground!</span>")
			if(3)
				visible_message("<span class='attack'>[src] is floored from the impact!</span>",
				"<span class='danger'>You've been floored from the impact!</span>")
		if(istype(src,/mob/living/simple_animal/hostile)) //Because fuck spiders.
			src.Weaken(10)
		else
			src.Weaken(5)
	else
		var/a = rand(1,3)
		switch(a)
			if(1)
				visible_message("<span class='attack'>[src] staggers under the impact!</span>",
				"<span class='danger'>You stagger under the impact!</span>")
			if(2)
				visible_message("<span class='attack'>[src] was sent flying backwards!</span>",
				"<span class='danger'>You were sent flying backwards!</span>")
			if(3)
				visible_message("<span class='attack'>[src] reels backwards from the impact!</span>",
				"<span class='danger'>You reel backwards from the impact!</span>")
		if(user)
			throw_at(get_edge_target_turf(src,user.dir),1,1)
		else if(T)
			throw_at(T,1,1)