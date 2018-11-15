/datum/interaction/bow
	command = "bow"
	description = "Bow to them."
	max_distance = 25
	simple_message = "USER bows to TARGET."

/datum/interaction/smile
	command = "smile"
	description = "Smile at them."
	simple_message = "USER smiles at TARGET."
	require_user_mouth = 1
	max_distance = 25

/datum/interaction/wave
	command = "wave"
	description = "Wave to them."
	simple_message = "USER waves to TARGET."
	require_user_hands = 1
	max_distance = 25

/datum/interaction/handshake
	command = "handshake"
	description = "Shake their hand."
	simple_message = "USER shakes the hand of TARGET."
	require_user_hands = 1
	needs_physical_contact = 1

/datum/interaction/pat
	command = "pat"
	description = "Pat their shoulder."
	simple_message = "USER pats TARGET's shoulder."
	require_user_hands = 1
	needs_physical_contact = 1

/datum/interaction/kiss
	command = "kiss"
	description = "Kiss them, you fool."
	require_user_mouth = 1
	simple_message = "USER kisses TARGET."
	write_log_user = "kissed"
	write_log_target = "was kissed by"
	needs_physical_contact = 1

/datum/interaction/kiss/evaluate_user(var/mob/user, var/silent=1)
	if(..())
		if(!user.has_lips())
			if(!silent) user << "<span class='warning'>You don't have any lips.</span>"
			return 0
		return 1
	return 0

/datum/interaction/hug
	command = "hug"
	description = "Hug them."
	require_user_mouth = 1
	simple_message = "USER hugs TARGET."
	interaction_sound = 'honk/sound/interactions/hug.ogg'
	needs_physical_contact = 1

/datum/interaction/cheer
	command = "cheer"
	description = "Cheer them on."
	require_user_mouth = 1
	simple_message = "USER cheers TARGET on!"

/datum/interaction/highfive
	command = "highfive"
	description = "Give them a high-five."
	require_user_mouth = 1
	simple_message = "USER high fives TARGET!"
	interaction_sound = 'honk/sound/interactions/slap.ogg'
	needs_physical_contact = 1

/datum/interaction/headpat
	command = "headpat"
	description = "Pat their head. Aww..."
	require_user_hands = 1
	simple_message = "USER headpats TARGET!"
	needs_physical_contact = 1

/datum/interaction/salute
	command = "salute"
	description = "Give them a firm salute!"
	require_user_hands = 1
	simple_message = "USER salutes TARGET sharply!"
	max_distance = 25

/datum/interaction/fistbump
	command = "fistbump"
	description = "Bump it!"
	require_user_hands = 1
	simple_message = "USER fistbumps TARGET! Yeah!"
	needs_physical_contact = 1

/datum/interaction/pinkypromise
	command = "pinkypromise"
	description = "Make a pinky promise with them!"
	require_user_hands = 1
	simple_message = "USER hooks their pinky with TARGET's! Pinky Promise!"
	needs_physical_contact = 1

/datum/interaction/bird
	command = "bird"
	description = "Flip them the bird!"
	require_user_hands = 1
	simple_message = "USER gives TARGET the bird!"
	max_distance = 25

/datum/interaction/holdhand
	command = "holdhand"
	description = "Hold their hand."
	require_user_hands = 1
	simple_message = "USER holds TARGET's hand. Degenerate."
	max_distance = 25
	needs_physical_contact = 1
	max_distance = 25