//
// Mobs Subsystem - Process mob.Life()
//

//Polaris Edits - Missing  temporary debugging code to diagnose extreme tick consumption.

SUBSYSTEM_DEF(mobs)
	name = "Mobs"
	priority = 100
	wait = 2 SECONDS
	flags = SS_KEEP_TIMING|SS_NO_INIT
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/list/currentrun = list()
	var/log_extensively = FALSE
	var/list/timelog = list()
	
	var/slept_mobs = 0
	var/list/process_z = list()

/datum/controller/subsystem/mobs/stat_entry()
	..("P: [global.mob_list.len] | S: [slept_mobs]")

/datum/controller/subsystem/mobs/fire(resumed = 0)
	var/list/process_z = src.process_z
	if (!resumed)
		src.currentrun = mob_list.Copy()
		process_z.Cut()
		
		for(var/played_mob in player_list)
			if(!played_mob || isobserver(played_mob))
				continue
			var/mob/pm = played_mob
			process_z |= pm.z

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun
	var/times_fired = src.times_fired
	while(currentrun.len)
		var/mob/M = currentrun[currentrun.len]
		currentrun.len--

		if(QDELETED(M))
			mob_list -= M
			continue
		else if(M.low_priority && !(M.loc && process_z[get_z(M)]))
			slept_mobs++
			continue
		
		M.Life(times_fired)

		if (MC_TICK_CHECK)
			return
