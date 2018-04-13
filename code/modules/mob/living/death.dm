/mob/living/death()
	clear_fullscreens()

	if(ai_holder)
		ai_holder.go_sleep()

	. = ..()