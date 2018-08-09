/datum/controller/process/burning/setup()
	name = "burning"
	schedule_interval = 20 // every 2 seconds

/datum/controller/process/burning/doWork()
	for(var/obj/O in burning_objects)
		if(O && (O.burn_state == 1))
			if(O.burn_world_time < world.time)
				O.burn()
		else
			burning_objects.Remove(O)




