// Returns a short string that describes what type the mob is, without a massive '/mob/living/carbon/human',
// Useful for admin UIs and logging.
/mob/proc/type_shorthand()
	return "Base Mob"

/mob/observer/dead/type_shorthand()
	return "Ghost"

/mob/observer/eye/type_shorthand()
	return "Eye"

/mob/new_player/type_shorthand()
	return "Lobby Mob"

/mob/living/type_shorthand()
	return "Living Mob"

/mob/living/carbon/type_shorthand()
	return "Carbon Mob"

/mob/living/carbon/human/type_shorthand()
	return "Humanoid" // Because aliens.

/mob/living/bot/type_shorthand()
	return "Bot"

/mob/living/simple_animal/type_shorthand()
	return "Simple Animal"

/mob/living/silicon/type_shorthand()
	return "Silicon"

/mob/living/silicon/ai/type_shorthand()
	return "AI"

/mob/living/silicon/pai/type_shorthand()
	return "pAI"

/mob/living/silicon/robot/type_shorthand()
	return "Robot"

/mob/living/silicon/robot/drone/type_shorthand()
	return "Drone"

/mob/living/voice/type_shorthand()
	return "Communicator Voice"