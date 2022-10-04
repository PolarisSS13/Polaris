/datum/controller/subsystem
	// Metadata; you should define these.
	name = "fire coderbus" //name of the subsystem
	var/init_order = INIT_ORDER_DEFAULT	//order of initialization. Higher numbers are initialized first, lower numbers later. Can be decimal and negative values.
	var/wait = 20			//time to wait (in deciseconds) between each call to fire(). Must be a positive integer.
	var/priority = FIRE_PRIORITY_DEFAULT	//When mutiple subsystems need to run in the same tick, higher priority subsystems will run first and be given a higher share of the tick before MC_TICK_CHECK triggers a sleep

	var/flags = 0			//see MC.dm in __DEFINES Most flags must be set on world start to take full effect. (You can also restart the mc to force them to process again)
	var/subsystem_initialized = FALSE	//set to TRUE after it has been initialized, will obviously never be set if the subsystem doesn't initialize
	var/runlevels = RUNLEVELS_DEFAULT	//points of the game at which the SS can fire

	//set to 0 to prevent fire() calls, mostly for admin use or subsystems that may be resumed later
	//	use the SS_NO_FIRE flag instead for systems that never fire to keep it from even being added to the list
	var/can_fire = TRUE

	// Bookkeeping variables; probably shouldn't mess with these.
	var/last_fire = 0		//last world.time we called fire()
	var/next_fire = 0		//scheduled world.time for next fire()
	var/cost = 0			//average time to execute
	var/tick_usage = 0		//average tick usage
	var/tick_overrun = 0	//average tick overrun
	var/state = SS_IDLE		//tracks the current state of the ss, running, paused, etc.
	var/paused_ticks = 0	//ticks this ss is taking to run right now.
	var/paused_tick_usage	//total tick_usage of all of our runs while pausing this run
	var/ticks = 1			//how many ticks does this ss take to run on avg.
	var/times_fired = 0		//number of times we have called fire()
	var/queued_time = 0		//time we entered the queue, (for timing and priority reasons)
	var/queued_priority 	//we keep a running total to make the math easier, if priority changes mid-fire that would break our running total, so we store it here
	//linked list stuff for the queue
	var/datum/controller/subsystem/queue_next
	var/datum/controller/subsystem/queue_prev

	var/static/list/failure_strikes //How many times we suspect a subsystem type has crashed the MC, 3 strikes and you're out!


/datum/controller/subsystem/Destroy()
	dequeue()
	can_fire = 0
	flags |= SS_NO_FIRE
	Master.subsystems -= src
	return ..()


/// Wrapper for non-implementation initialization behaviors.
/datum/controller/subsystem/proc/DoInitialize(timeofday)
	Initialize(timeofday)
	subsystem_initialized = TRUE
	var/time = (REALTIMEOFDAY - timeofday) / 10
	var/msg = "Initialized [name] subsystem within [time] second[time == 1 ? "" : "s"]!"
	to_chat(world, "<span class='boldannounce'>[msg]</span>")
	log_world(msg)
	return time


// Do not implement any base behaviors here.
/// Initializes the subsystem exactly once, AFTER map load, run by the MC and passed REALTIMEOFDAY. The preferred initialization proc.
/datum/controller/subsystem/Initialize(timeofday)
	return


// Do not implement any base behaviors here.
/// Called in subsystem/New if there is an existing instance of the subsystem, on the existing instance, before it is deleted.
/datum/controller/subsystem/Recover()
	return


// Do not implement any base behaviors here.
/// Called in subsystem/New - happens BEFORE map load, and ALSO every time the subsystem is Recovered, AFTER being Recovered.
/datum/controller/subsystem/proc/OnNew()
	return


//hook for printing stats to the "MC" statuspanel for admins to see performance and related stats etc.
/datum/controller/subsystem/stat_entry(msg)
	if(!statclick)
		statclick = new/obj/effect/statclick/debug(null, "Initializing...", src)
	if(SS_NO_FIRE & flags)
		msg = "NO FIRE\t[msg]"
	else if(can_fire <= 0)
		msg = "OFFLINE\t[msg]"
	else
		msg = "[round(cost,1)]ms|[round(tick_usage,1)]%([round(tick_overrun,1)]%)|[round(ticks,0.1)]\t[msg]"
	var/title = name
	if (can_fire)
		title = "\[[state_letter()]][title]"
	stat(title, statclick.update(msg))


//This is used so the mc knows when the subsystem sleeps. do not override.
/datum/controller/subsystem/proc/ignite(resumed)
	set waitfor = 0
	. = SS_SLEEPING
	fire(resumed)
	. = state
	if (state == SS_SLEEPING)
		state = SS_IDLE
	if (state == SS_PAUSING)
		var/QT = queued_time
		enqueue()
		state = SS_PAUSED
		queued_time = QT


/**
* The periodic behavior of this subsystem, if it has any, every 'wait' deciseconds.
* Sleeping prevents future fires until returned.
* "resumed" is truthy when the previous fire did not complete and there is work left to do.
* "no_mc_tick" is truthy when fire should run to the end, and damn the torpedoes.
*/
/datum/controller/subsystem/proc/fire(resumed, no_mc_tick)
	flags |= SS_NO_FIRE
	throw EXCEPTION("Subsystem [src]([type]) does not fire() but did not set the SS_NO_FIRE flag. Please add the SS_NO_FIRE flag to any subsystem that doesn't fire so it doesn't get added to the processing list and waste cpu.")


//Queue it to run.
//	(we loop thru a linked list until we get to the end or find the right point)
//	(this lets us sort our run order correctly without having to re-sort the entire already sorted list)
/datum/controller/subsystem/proc/enqueue()
	var/SS_priority = priority
	var/SS_flags = flags
	var/datum/controller/subsystem/queue_node
	var/queue_node_priority
	var/queue_node_flags
	for (queue_node = Master.queue_head; queue_node; queue_node = queue_node.queue_next)
		queue_node_priority = queue_node.queued_priority
		queue_node_flags = queue_node.flags
		if (queue_node_flags & SS_TICKER)
			if (!(SS_flags & SS_TICKER))
				continue
			if (queue_node_priority < SS_priority)
				break
		else if (queue_node_flags & SS_BACKGROUND)
			if (!(SS_flags & SS_BACKGROUND))
				break
			if (queue_node_priority < SS_priority)
				break
		else
			if (SS_flags & SS_BACKGROUND)
				continue
			if (SS_flags & SS_TICKER)
				break
			if (queue_node_priority < SS_priority)
				break
	queued_time = world.time
	queued_priority = SS_priority
	state = SS_QUEUED
	if (SS_flags & SS_BACKGROUND) //update our running total
		Master.queue_priority_count_bg += SS_priority
	else
		Master.queue_priority_count += SS_priority
	queue_next = queue_node
	if (!queue_node)//we stopped at the end, add to tail
		queue_prev = Master.queue_tail
		if (Master.queue_tail)
			Master.queue_tail.queue_next = src
		else //empty queue, we also need to set the head
			Master.queue_head = src
		Master.queue_tail = src
	else if (queue_node == Master.queue_head)//insert at start of list
		Master.queue_head.queue_prev = src
		Master.queue_head = src
		queue_prev = null
	else
		queue_node.queue_prev.queue_next = src
		queue_prev = queue_node.queue_prev
		queue_node.queue_prev = src


/datum/controller/subsystem/proc/dequeue()
	if (queue_next)
		queue_next.queue_prev = queue_prev
	if (queue_prev)
		queue_prev.queue_next = queue_next
	if (src == Master.queue_tail)
		Master.queue_tail = queue_prev
	if (src == Master.queue_head)
		Master.queue_head = queue_next
	queued_time = 0
	if (state == SS_QUEUED)
		state = SS_IDLE


/datum/controller/subsystem/proc/pause()
	. = 1
	switch(state)
		if(SS_RUNNING)
			state = SS_PAUSED
		if(SS_SLEEPING)
			state = SS_PAUSING


//could be used to postpone a costly subsystem for (default one) var/cycles, cycles
//for instance, during cpu intensive operations like explosions
/datum/controller/subsystem/proc/postpone(cycles = 1)
	if(next_fire - world.time < wait)
		next_fire += (wait*cycles)


// Suspends this subsystem from being queued for running.  If already in the queue, sleeps until idle. Returns FALSE if the subsystem was already suspended.
/datum/controller/subsystem/proc/suspend()
	. = (can_fire > 0) // Return true if we were previously runnable, false if previously suspended.
	can_fire = FALSE
	// Safely sleep in a loop until the subsystem is idle, (or its been un-suspended somehow)
	while(can_fire <= 0 && state != SS_IDLE)
		stoplag() // Safely sleep in a loop until 


// Wakes a suspended subsystem.
/datum/controller/subsystem/proc/wake()
	can_fire = TRUE


/datum/controller/subsystem/proc/state_letter()
	switch (state)
		if (SS_RUNNING)
			. = "R"
		if (SS_QUEUED)
			. = "Q"
		if (SS_PAUSED, SS_PAUSING)
			. = "P"
		if (SS_SLEEPING)
			. = "S"
		if (SS_IDLE)
			. = "  "
