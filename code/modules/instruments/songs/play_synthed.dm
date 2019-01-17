/datum/song/proc/do_play_lines_synth()
	compile_lines()
	var/terminate = FALSE
	while(repeats)
		for(var/_chord in compiled_chords)
			var/list/chord = _chord
			var/tempodiv = chord[chord.len]
			for(var/i in 1 to chord.len - 1)
				var/key = chord[i]
				playkey_synth(key)
			if(should_stop_playing())
				terminate = TRUE
				break
			sleep(sanitize_tempo_ds(tempo_ds / tempodiv))
		if(should_stop_playing())
			terminate = TRUE
		if(terminate)
			break
		updateUsrDialog()
	if(!debug_mode)
		compiled_chords = null

/datum/song/proc/compile_lines()
	compiled_chords = list()
	var/list/octaves = list()
	var/list/accents = list()
	for(var/i in 1 to 7)
		octaves += 3
		accents += "n"
	for(var/line in lines)
		var/list/beats = splittext(lowertext(line), ",")
		for(var/beat in beats)
			var/list/contents = splittext(beat, "/")
			var/tempo_divisor = 1
			var/contents_length = length(contents)
			var/list/newchord = list()
			if(contents_length)
				if(contents_length >= 2)
					var/newdiv = text2num(contents[2])
					if(isnum(newdiv))
						tempo_divisor = newdiv
				for(var/note in contents[1])
					var/key = note_to_key(note, octaves, accents, TRUE)
					if(key)
						newchord += key
			newchord += tempo_divisor
			compiled_chords += newchord
		CHECK_TICK

/datum/song/proc/note_to_key(notestring, list/octaves, list/accents, change_lists = FALSE)
	//For the sake of performance, we're not going to check for octaves/accents existing.
	var/notelen
	if((!(notelen = length(notestring))))
		return
	var/cur_note = text2ascii(note, 1) - 96
	//a = 1, b = 2, c = 3, d = 4, e = 5, f = 6, g = 7
	if(cur_note < 1 || cur_note > 7)
		return
	var/accent
	var/octave
	for(var/i in 2 to notelen)
		var/text = copytext(notestring, i)
		if((text == "s") || (text == "#"))
			if(change_lists)
				accents[cur_note] = "#"
			accent = "#"
		else if(text == "n")
			if(change_lists)
				accents[cur_note] = "n"
			accent = "n"
		else if(text == "b")
			if(change_lists)
				accents[cur_note] = "b"
			accent = "b"
		else
			var/n = text2num(text)
			if(n && (n >= max(INSTRUMENT_MIN_OCTAVE, octave_min)) && (n <= min(INSTRUMENT_MAX_OCTAVE, octave_max)))
				if(change_lists)
					octaves[cur_note] = n
				oactave = n
	accent = accent || accents[cur_note]
	octave = octave || octaves[cur_note]
	return ((octave * 12) + (accent_lookup[accent]) + (note_offset_lookup[cur_note]))

/datum/song/proc/playkey_synth(key, duration, atom/where = parent)
	var/datum/sample_pair/S = using_instrument.samples["[key]"]			//See how fucking easy it is to make a number text? You don't need a complicated 9 line proc!
	events += new /datum/musical
	//Should probably add channel limiters here at some point but I don't care right now.








/datum/synthesized_song/proc/play(what, duration, frequency, which, where, which_one)
	if(available_channels <= 0) //Ignore requests for new channels if we go over limit
		return
	available_channels -= 1
	src.sound_id = "[type]_[sequential_id(type)]"


	var/sound/sound_copy = sound(what)
	sound_copy.wait = 0
	sound_copy.repeat = 0
	sound_copy.frequency = frequency

	player.apply_modifications(sound_copy, which, where, which_one)
	//Environment, anything other than -1 means override
	var/use_env = 0

	if(isnum(sound_copy.environment) && sound_copy.environment <= -1)
		sound_copy.environment = 0 // set it to 0 and just not set use env
	else
		use_env = 1

	var/current_volume = Clamp(sound_copy.volume, 0, 100)
	sound_copy.volume = current_volume //Sanitize volume
	var/datum/sound_token/token = new /datum/sound_token/instrument(src.player.actual_instrument, src.sound_id, sound_copy, src.player.range, FALSE, use_env, player)
	#if DM_VERSION < 511
	sound_copy.frequency = 1
	#endif
	var/delta_volume = player.volume / src.sustain_timer

	var/tick = duration
	while ((current_volume > 0) && token)
		var/new_volume = current_volume
		tick += world.tick_lag
		if (delta_volume <= 0)
			CRASH("Delta Volume somehow was non-positive: [delta_volume]")
		if (src.soft_coeff <= 1)
			CRASH("Soft Coeff somehow was <=1: [src.soft_coeff]")
		if (src.linear_decay)
			new_volume = new_volume - delta_volume
		else
			new_volume = new_volume / src.soft_coeff

		var/sanitized_volume = max(round(new_volume), 0)
		if (sanitized_volume == current_volume)
			current_volume = new_volume
			continue
		current_volume = sanitized_volume
		src.player.event_manager.push_event(src.player, token, tick, current_volume)
		if (current_volume <= 0)
			break

