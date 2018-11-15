
//-------------------------------------------
// Vehicle Action Buttons
//-------------------------------------------
/obj/screen/vehicle_action
	var/obj/vehicle/car/owner

	enginetoggle
		name = "Turn On Engine"
		icon_state = "engine0"

	horntoggle
		name = "Honk Horn"
		icon_state = "horn"


/obj/screen/vehicle_action/Destroy()
	..()
	owner = null

/obj/screen/vehicle_action/Click()
	if(!usr || !owner)
		return 1
	if(usr.next_move >= world.time)
		return
	usr.next_move = world.time + 6

	if(usr.stat || usr.restrained() || usr.stunned || usr.lying)
		return 1

	if(owner != usr.buckled || usr.buckled) //Don't display the action bar to mobs in the trunk.
		return 1

	switch(name)
		if("Turn On Engine")
			owner.start_engine()
		if("Turn Off Engine")
			owner.stop_engine()
		if("Honk Horn")
			owner.honk_horn()
	return 1

