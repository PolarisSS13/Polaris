
// We manually initialize the alarm handlers instead of looping over all existing types
// to make it possible to write: camera.triggerAlarm() rather than alarm_manager.managers[datum/alarm_handler/camera].triggerAlarm() or a variant thereof.
GLOBAL_DATUM_INIT(atmosphere_alarm, datum/alarm_handler/atmosphere, new ))
GLOBAL_DATUM_INIT(camera_alarm, datum/alarm_handler/camera, new ))
GLOBAL_DATUM_INIT(fire_alarm, datum/alarm_handler/fire, new ))
GLOBAL_DATUM_INIT(motion_alarm, datum/alarm_handler/motion, new ))
GLOBAL_DATUM_INIT(power_alarm, datum/alarm_handler/power, new ))

// Alarm Manager, the manager for alarms.
GLOBAL_DATUM(alarm_manager, /datum/controller/process/alarm)

/datum/controller/process/alarm
	var/list/datum/alarm/all_handlers

/datum/controller/process/alarm/setup()
	name = "alarm"
	schedule_interval = 20 // every 2 seconds
	all_handlers = list(atmosphere_alarm, camera_alarm, fire_alarm, motion_alarm, power_alarm)
	alarm_manager = src

/datum/controller/process/alarm/doWork()
	for(last_object in all_handlers)
		var/datum/alarm_handler/AH = last_object
		AH.process()
		SCHECK

/datum/controller/process/alarm/proc/active_alarms()
	var/list/all_alarms = new
	for(var/datum/alarm_handler/AH in all_handlers)
		var/list/alarms = AH.alarms
		all_alarms += alarms

	return all_alarms

/datum/controller/process/alarm/proc/number_of_active_alarms()
	var/list/alarms = active_alarms()
	return alarms.len

/datum/controller/process/alarm/statProcess()
	..()
	stat(null, "[number_of_active_alarms()] alarm\s")
