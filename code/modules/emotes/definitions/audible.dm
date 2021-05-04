/datum/emote/audible
	key = "burp"
	emote_message_3p = "burps."
	message_type = AUDIBLE_MESSAGE

/datum/emote/audible/New()
	. = ..()
	// Snips the 'USER' from 3p emote messages for radio.
	if(!emote_message_radio && emote_message_3p)
		emote_message_radio = emote_message_3p
	if(!emote_message_radio_synthetic && emote_message_synthetic_3p)
		emote_message_radio_synthetic = emote_message_synthetic_3p

/datum/emote/audible/deathgasp_alien
	key = "deathgasp"
	emote_message_3p = "lets out a waning guttural screech, green blood bubbling from its maw."

/datum/emote/audible/whimper
	key = "whimper"
	emote_message_3p = "whimpers."

/datum/emote/audible/gasp
	key = "gasp"
	emote_message_3p = "gasps."
	conscious = FALSE

/datum/emote/audible/scretch
	key = "scretch"
	emote_message_3p = "scretches."

/datum/emote/audible/choke
	key ="choke"
	emote_message_3p = "chokes."
	conscious = FALSE

/datum/emote/audible/gnarl
	key = "gnarl"
	emote_message_3p = "gnarls and shows USER_THEIR teeth."

/datum/emote/audible/multichirp
	key = "mchirp"
	emote_message_3p = "chirps a chorus of notes!"
	emote_sound = 'sound/voice/multichirp.ogg'

/datum/emote/audible/alarm
	key = "alarm"
	emote_message_1p = "You sound an alarm."
	emote_message_3p = "sounds an alarm."

/datum/emote/audible/alert
	key = "alert"
	emote_message_1p = "You let out a distressed noise."
	emote_message_3p = "lets out a distressed noise."

/datum/emote/audible/notice
	key = "notice"
	emote_message_1p = "You play a loud tone."
	emote_message_3p = "plays a loud tone."

/datum/emote/audible/boop
	key = "boop"
	emote_message_1p = "You boop."
	emote_message_3p = "boops."

/datum/emote/audible/beep
	key = "beep"
	emote_message_3p = "You beep."
	emote_message_3p = "beeps."
	emote_sound = 'sound/machines/twobeep.ogg'

/datum/emote/audible/sniff
	key = "sniff"
	emote_message_3p = "sniffs."

/datum/emote/audible/snore
	key = "snore"
	emote_message_3p = "snores."
	conscious = FALSE

/datum/emote/audible/whimper
	key = "whimper"
	emote_message_3p = "whimpers."

/datum/emote/audible/yawn
	key = "yawn"
	emote_message_3p = "yawns."

/datum/emote/audible/clap
	key = "clap"
	emote_message_3p = "claps."

/datum/emote/audible/chuckle
	key = "chuckle"
	emote_message_3p = "chuckles."

/datum/emote/audible/cry
	key = "cry"
	emote_message_3p = "cries."

/datum/emote/audible/sigh
	key = "sigh"
	emote_message_3p = "sighs."

/datum/emote/audible/laugh
	key = "laugh"
	emote_message_3p_target = "laughs at TARGET."
	emote_message_3p = "laughs."

/datum/emote/audible/mumble
	key = "mumble"
	emote_message_3p = "mumbles!"

/datum/emote/audible/grumble
	key = "grumble"
	emote_message_3p = "grumbles!"

/datum/emote/audible/groan
	key = "groan"
	emote_message_3p = "groans!"
	conscious = FALSE

/datum/emote/audible/moan
	key = "moan"
	emote_message_3p = "moans!"
	conscious = FALSE

/datum/emote/audible/giggle
	key = "giggle"
	emote_message_3p = "giggles."

/datum/emote/audible/grunt
	key = "grunt"
	emote_message_3p = "grunts."

/datum/emote/audible/bug_hiss
	key ="hiss"
	emote_message_3p_target = "hisses at TARGET."
	emote_message_3p = "hisses."
	emote_sound = 'sound/voice/BugHiss.ogg'

/datum/emote/audible/bug_buzz
	key ="buzz"
	emote_message_3p = "buzzes its wings."
	emote_sound = 'sound/voice/BugBuzz.ogg'

/datum/emote/audible/bug_chitter
	key ="chitter"
	emote_message_3p = "chitters."
	emote_sound = 'sound/voice/Bug.ogg'

/datum/emote/audible/roar
	key = "roar"
	emote_message_3p = "roars!"

/datum/emote/audible/bellow
	key = "bellow"
	emote_message_3p = "bellows!"

/datum/emote/audible/howl
	key = "howl"
	emote_message_3p = "howls!"

/datum/emote/audible/wheeze
	key = "wheeze"
	emote_message_3p = "wheezes."

/datum/emote/audible/hiss
	key = "hiss"
	emote_message_3p_target = "hisses softly at TARGET."
	emote_message_3p = "hisses softly."

/datum/emote/audible/chirp
	key = "chirp"
	emote_message_3p = "chirps!"
	emote_sound = 'sound/misc/nymphchirp.ogg'

/datum/emote/audible/crack
	key = "crack"
	emote_message_3p = "cracks USER_THEIR knuckles."
	emote_sound = 'sound/voice/knuckles.ogg'

/datum/emote/audible/squish
	key = "squish"
	emote_sound = 'sound/effects/slime_squish.ogg' //Credit to DrMinky (freesound.org) for the sound.
	emote_message_3p = "squishes."

/datum/emote/audible/warble
	key = "warble"
	emote_sound = 'sound/effects/warble.ogg' // Copyright CC BY 3.0 alienistcog (freesound.org) for the sound.
	emote_message_3p = "warbles."

/datum/emote/audible/vox_shriek
	key = "shriek"
	emote_message_3p = "SHRIEKS!"
	emote_sound = 'sound/voice/shriek1.ogg'

/datum/emote/audible/purr
	key = "purr"
	emote_message_3p = "purrs."
	emote_sound = 'sound/voice/cat_purr.ogg'

/datum/emote/audible/purrlong
	key = "purrl"
	emote_message_3p = "purrs."
	emote_sound = 'sound/voice/cat_purr_long.ogg'

/datum/emote/audible/teshsqueak
	key = "surprised"
	emote_message_1p = "You chirp in surprise!"
	emote_message_3p = "chirps in surprise!"
	emote_message_1p_target = "You chirp in surprise at TARGET!"
	emote_message_3p_target = "chirps in surprise at TARGET!"
	emote_sound = 'sound/voice/teshsqueak.ogg' // Copyright CC BY 3.0 InspectorJ (freesound.org) for the source audio.

/datum/emote/audible/teshchirp
	key = "chirp"
	emote_message_1p = "You chirp!"
	emote_message_3p = "chirps!"
	emote_message_1p_target = "You chirp at TARGET!"
	emote_message_3p_target = "chirps at TARGET!"
	emote_sound = 'sound/voice/teshchirp.ogg' // Copyright Sampling+ 1.0 Incarnidine (freesound.org) for the source audio.

/datum/emote/audible/teshtrill
	key = "trill"
	emote_message_1p = "You trill."
	emote_message_3p = "trills."
	emote_message_1p_target = "You trill at TARGET."
	emote_message_3p_target = "trills at TARGET."
	emote_sound = 'sound/voice/teshtrill.ogg' // Copyright CC BY-NC 3.0 Arnaud Coutancier (freesound.org) for the source audio.
