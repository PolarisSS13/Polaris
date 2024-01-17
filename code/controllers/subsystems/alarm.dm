SUBSYSTEM_DEF(alarm)
	name = "Alarm"
	wait = 2 SECONDS
	priority = FIRE_PRIORITY_ALARM
	init_order = INIT_ORDER_ALARM

	/// The list of alarm handlers this subsystem processes
	var/static/list/datum/alarm_handler/handlers

	/// The list of alarm handlers currently being processed
	var/static/list/current = list()

	/// The list of active alarms
	var/static/list/active = list()


/datum/controller/subsystem/alarm/Initialize(timeofday)
	handlers = list(
		GLOB.atmosphere_alarm,
		GLOB.camera_alarm,
		GLOB.fire_alarm,
		GLOB.motion_alarm,
		GLOB.power_alarm
	)


/datum/controller/subsystem/alarm/stat_entry(msg)
	..("[active.len] alarm\s")


/datum/controller/subsystem/alarm/fire(resumed, no_mc_tick)
	if (!resumed)
		current = handlers.Copy()
		active.Cut()
	var/datum/alarm_handler/A
	for (var/i = current.len to 1 step -1)
		A = current[i]
		A.process()
		active += A.alarms
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			current.Cut(i)
			return
	current.Cut()


GLOBAL_DATUM_INIT(atmosphere_alarm, /datum/alarm_handler/atmosphere, new)

GLOBAL_DATUM_INIT(camera_alarm, /datum/alarm_handler/camera, new)

GLOBAL_DATUM_INIT(fire_alarm, /datum/alarm_handler/fire, new)

GLOBAL_DATUM_INIT(motion_alarm, /datum/alarm_handler/motion, new)

GLOBAL_DATUM_INIT(power_alarm, /datum/alarm_handler/power, new)
