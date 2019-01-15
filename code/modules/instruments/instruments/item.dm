








// subclass for handheld instruments, like violin
/datum/song/handheld

/datum/song/handheld/updateDialog(mob/user)
	instrumentObj.interact(user)

/datum/song/handheld/shouldStopPlaying()
	if(instrumentObj)
		return !isliving(instrumentObj.loc)
	else
		return 1










