/datum/controller/process/playtime/setup()
	name = "playtime controller"
	schedule_interval = 600 // every 60 seconds

/datum/controller/process/playtime/doWork()
	if(!config.sqlite_enabled || !config.sqlite_stats)
		return
	for(var/mob/player in player_list)
		if(player.client) // Shouldn't be needed but paranoid.
			player.client.increment_playtime()