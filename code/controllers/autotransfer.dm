var/datum/controller/transfer_controller/transfer_controller

datum/controller/transfer_controller
	var/timerbuffer = 0 //buffer for time check
	var/currenttick = 0
//	var/shift_hard_end = 0 // Polaris Edit
//	var/shift_last_vote = 0 // Polaris Edit

datum/controller/transfer_controller/New()
	timerbuffer = config.vote_autotransfer_initial
//	shift_hard_end = config.vote_autotransfer_initial + (config.vote_autotransfer_interval * 0) // Polaris edit - Legacy roundend voting
//	shift_last_vote = shift_hard_end - config.vote_autotransfer_interval // Polaris edit - legacy roundend voting
	START_PROCESSING(SSprocessing, src)

datum/controller/transfer_controller/Destroy()
	STOP_PROCESSING(SSprocessing, src)

datum/controller/transfer_controller/process()
	currenttick = currenttick + 1
	//Polaris Edit START
	if (round_duration_in_ds >= timerbuffer - 1 MINUTE)
		SSvote.autotransfer()
		timerbuffer = timerbuffer + config.vote_autotransfer_interval
	// Polaris Edit END