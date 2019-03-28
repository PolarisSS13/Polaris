
/datum/species/zombie/shambler
	name= "Shambling Zombie"
	blurb = "Looks like this night shift worker had their coffee. Trying to make us envious, I see."
	evolution = STANDARD_EVOLUTION
	death_message = "emits a long series of erratic chitters before it finally slows down, but is that for good?"
	slowdown = 0.1 //this zombie type is actually supposed to be sanic after a bad chilli dog.
	total_health = 120 //Less health than over evolved zombies in exchange for high speed.


/datum/species/zombie/tanker
	name= "Tanker Zombie"
	blurb = "Office life and cafe food makes it difficult to shift those stubborn pounds. We empathize."
	evolution = TANKER_EVOLUTION
	mob_size = MOB_LARGE
	death_message = "Makes a loud whistling sound as it emits a foul odourous gas into the air..."
	slowdown = 2.2 //A bit slower than a regular zombie...
	total_health = 300 //thicc
	brute_mod = 0.30 //Have you ever hit a huge bag of pudding and watched it jiggle? Yeah that.
	icobase = 'icons/mob/human_races/r_zombie_tanker.dmi'
	deform = 'icons/mob/human_races/r_zombie_tanker.dmi'