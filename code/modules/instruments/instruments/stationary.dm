




/datum/song/stationary/shouldStopPlaying(mob/user)
	if(instrumentObj)
		if(!instrumentObj.Adjacent(user) || user.stat)
			return 1
		return !instrumentObj.anchored		// add special cases to stop in subclasses
	else
		return 1


