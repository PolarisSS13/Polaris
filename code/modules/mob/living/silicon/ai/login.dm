/mob/living/silicon/ai/Login()	//ThisIsDumb(TM) TODO: tidy this up �_� ~Carn
	..()
	for(var/obj/effect/rune/rune in rune_list)
		client.images += rune.blood_image
	regenerate_icons()
	flash = new /obj/screen()
	flash.icon_state = "blank"
	flash.name = "flash"
	flash.screen_loc = ui_entire_screen
	flash.layer = 17
	blind = new /obj/screen()
	blind.icon_state = "black"
	blind.name = " "
	blind.screen_loc = ui_entire_screen
	blind.invisibility = INVISIBILITY_MAXIMUM
	client.screen.Add( blind, flash )

	if(stat != DEAD)
		for(var/obj/machinery/ai_status_display/O in machines) //change status
			O.mode = 1
			O.emotion = "Neutral"
	src.view_core()
	return