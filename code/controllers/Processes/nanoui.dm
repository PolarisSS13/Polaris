/datum/controller/process/nanoui/setup()
	name = "nanoui"
	schedule_interval = 20 // every 2 seconds

/datum/controller/process/nanoui/statProcess()
	..()
	stat(null, "[SSnanoui.processing_uis.len] UIs")

/datum/controller/process/nanoui/doWork()
	for(last_object in SSnanoui.processing_uis)
		var/datum/nanoui/NUI = last_object
		if(istype(NUI) && !QDELETED(NUI))
			try
				NUI.process()
			catch(var/exception/e)
				catchException(e, NUI)
		else
			catchBadType(NUI)
			SSnanoui.processing_uis -= NUI