/obj/item/weapon/spell/construct/run_checks()
	if(!..())
		return FALSE

	if(owner)
		if((iscultist(owner) || istype(owner, /mob/living/simple_mob/construct)) && (world.time >= (last_castcheck + cooldown))) //Are they a cultist or a construct, and has the cooldown time passed?
			last_castcheck = world.time
			return TRUE
	return FALSE