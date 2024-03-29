//
// Mobs Subsystem - Process mob.Life()
//

SUBSYSTEM_DEF(mobs)
	name = "Mobs"
	priority = 100
	wait = 2 SECONDS
	flags = SS_KEEP_TIMING|SS_NO_INIT
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/list/currentrun = list()
	var/log_extensively = FALSE
	var/list/timelog = list()
	var/list/busy_z_levels = list()
	var/list/slept = list()
	var/skipped_mobs = 0

/datum/controller/subsystem/mobs/stat_entry()
	..("P: [global.mob_list.len] | S: [skipped_mobs]")

/datum/controller/subsystem/mobs/fire(resumed, no_mc_tick)
	var/list/busy_z_levels = src.busy_z_levels

	if (!resumed)
		skipped_mobs = 0
		src.currentrun = mob_list.Copy()
		busy_z_levels.Cut()
		for(var/played_mob in player_list)
			if(!played_mob || isobserver(played_mob))
				continue
			var/mob/pm = played_mob
			busy_z_levels |= pm.z

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun
	var/times_fired = src.times_fired
	while(currentrun.len)
		var/mob/M = currentrun[currentrun.len]
		currentrun.len--

		if(QDELETED(M))
			mob_list -= M
		else
			// Right now mob.Life() is unstable enough I think we need to use a try catch.
			// Obviously we should try and get rid of this for performance reasons when we can.
			try
				if(M.low_priority && !(M.z in busy_z_levels))
					skipped_mobs++
					if (MC_TICK_CHECK)
						return
					continue

				var/time = world.time
				M.Life(times_fired)
				if(time != world.time && !slept[M.type])
					slept[M.type] = TRUE
					log_debug("SSmobs: Type '[M.type]' slept for [world.time - time]ds in Life(). Suppressing further warnings.")

			catch(var/exception/e)
				log_runtime(e, M, "Caught by [name] subsystem")

		if (MC_TICK_CHECK)
			return
