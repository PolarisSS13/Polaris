// Defines for the ai_intelligence var.
// Controls if the mob will do 'advanced tactics' like running from grenades.
#define AI_DUMB			1 // Be dumber than usual.
#define AI_NORMAL		2 // Default level.
#define AI_SMART		3 // Will do more processing to perceive threats such as active grenades. Use sparingly.

#define ai_log(M,V)	if(debug_ai) ai_log_output(M,V)

// Logging level defines.
#define AI_LOG_OFF		0 // Don't show anything.
#define AI_LOG_ERROR	1 // Show logs of things likely causing the mob to not be functioning correctly.
#define AI_LOG_WARNING	2 // Show less serious but still helpful to know issues that might be causing things to work incorrectly.
#define AI_LOG_INFO		3 // Important regular events, like selecting a target or switching stances.
#define AI_LOG_DEBUG	4 // More detailed information about the flow of execution.
#define AI_LOG_TRACE	5 // Even more detailed than the last.

// Reasons for targets to not be valid. Based on why, the AI responds differently.
#define AI_TARGET_VALID			0 // We can fight them.
#define AI_TARGET_INVIS			1 // They were in field of view but became invisible. Switch to STANCE_BLINDFIGHT if no other viable targets exist.
#define AI_TARGET_NOSIGHT		2 // No longer in field of view. Go STANCE_REPOSITION to their last known location if no other targets are seen.
#define AI_TARGET_ALLY			3 // They are an ally. Find a new target.
#define AI_TARGET_DEAD			4 // They're dead. Find a new target.
#define AI_TARGET_INVINCIBLE	5 // Target is currently unable to receive damage for whatever reason. Find a new target or wait.

//TRACE DEBUG INFO WARN ERROR OFF