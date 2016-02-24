/datum/controller/process/Shuttle/setup()
	name = "shuttle controller"
	schedule_interval = 20 // every 2 seconds

	if(!shuttle_controller)
		shuttle_controller = new

	if(!shuttle_controller2)
		shuttle_controller2 = new

/datum/controller/process/Shuttle/doWork()
	shuttle_controller.process()
