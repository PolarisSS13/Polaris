SUBSYSTEM_DEF(ai)
	name = "AI"
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	priority = FIRE_PRIORITY_AI
	wait = 2 SECONDS

	/// The list of AI datums to be processed.
	var/static/tmp/list/queue = list()

	/// The list of AI datums currently being processed.
	var/static/tmp/list/current = list()


/datum/controller/subsystem/ai/stat_entry(msg_prefix)
	var/list/msg = list(msg_prefix)
	msg += "P:[queue.len]"
	..(msg.Join())


/datum/controller/subsystem/ai/Recover()
	current.Cut()


/datum/controller/subsystem/ai/fire(resumed, no_mc_tick)
	if (!resumed)
		current = queue.Copy()
	var/datum/ai_holder/subject
	for (var/i = current.len to 1 step -1)
		subject = current[i]
		if (QDELETED(subject) || subject.busy)
			continue
		subject.handle_strategicals()
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			current.Cut(i)
			return
	current.Cut()


/// Convenience define for safely enqueueing an AI datum for slow processing.
#define START_AIPROCESSING(DATUM) \
if (!(DATUM.process_flags & AI_PROCESSING)) {\
	DATUM.process_flags |= AI_PROCESSING;\
	SSai.queue += DATUM;\
}


/// Convenience define for safely dequeueing an AI datum from slow processing.
#define STOP_AIPROCESSING(DATUM) \
DATUM.process_flags &= ~AI_PROCESSING; \
SSai.queue -= DATUM;


// Prevent AI running during CI to avoid some irrelevant runtimes
#ifdef UNIT_TEST
/datum/controller/subsystem/ai/flags = SS_NO_INIT | SS_NO_FIRE
#else
/datum/controller/subsystem/ai/flags = SS_NO_INIT
#endif
