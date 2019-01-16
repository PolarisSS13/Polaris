/datum/song
	var/name = "Untitled"

	var/debug_mode = FALSE

	var/list/lines = list()
	var/list/compiled_chords 	//non assoc list of lists : index = list(key1, key2, key3... , tempo_divisor). tempo divisor always exists, key1 doesn't have to if it's a rest.

	var/tempo_ds = 5			//delay between notes in deciseconds
	var/repeat_current = 0		//current repeats left
	var/max_repeats = 10		//max repeats
	var/playing = FALSE			//whether we should be playing. Setting this to FALSE will halt the playing proc ASAP.
	var/now_playing = FALSE		//Whether we actually are playing.

	var/list/allowed_instrument_ids = list("r3grand")		//Ones the built in switcher is allowed to use.
	var/datum/instrument/using_instrument
	var/legacy_mode = FALSE

	var/obj/parent			//The object in the world we're attached to. Can theoretically support datums in the future, but this should probably stay as an atom at the least.
	var/last_hearcheck = 0		//last world.time we checked for hearing mobs.
	var/list/hearing_mobs		//list of mobs that can hear us

	//Cache for hyper speed!
	var/cached_legacy_ext
	var/cached_legacy_dir
	var/list/cached_samples
	////////////////////////

	var/interface_help = FALSE		//help is open
	var/interface_edit = TRUE		//editing mode

/datum/song/New(datum/instrument/instrument_or_id)
	SSinstruments.on_song_new(src)
	set_instrument(instrument_or_id || ((islist(allowed_instrument_ids) && length(allowed_instrument_ids))? allowed_instrument_ids[1] : allowed_instrument_ids))

/datum/song/Destroy()
	stop_playing()
	var/time = world.time
	UNTIL(!now_playing || ((world.time - time) > 20))
	if((world.time - time) > 20)
		crash_with("WARNING: datum/song [src] failed to stop playing more than 20 deciseconds after being instructed to stop by Destroy()!")
	SSinstruments.on_song_del(src)
	parent = null
	lines = null
	using_instrument = null
	allowed_instrument_ids = null
	hearing_mobs = null
	cached_samples = null
	compiled_chords = null
	return ..()

/datum/song/proc/set_bpm(bpm)
	tempo_ds = round(600 / bpm, world.tick_lag)

/datum/song/proc/get_bpm()
	return (600 / tempo_ds)

/datum/song/proc/set_instrument(datum/instrument/I)
	if(istext(I))
		I = SSinstruments.instrument_data[I]
	if(istype(I))
		if(istype(using_instrument))
			LAZYOR(using_instruments.songs_using, src)
		using_instrument = I
		LAZYOR(I.songs_using, src)
		return TRUE
	if(isnull(I))
		if(istype(using_instrument))
			LAZYREMOVE(using_instruments.songs_using, src)
		using_instrument = null
		cached_samples = null
		cached_legacy_ext = null
		cached_legacy_dir = null
		return TRUE
	return FALSE

/datum/song/proc/sanitize_tempo(new_tempo)
	return max(round(abs(new_tempo), world.tick_lag), world.tick_lag)

/datum/song/proc/stop_playing()
	hearing_mobs.Cut()
	playing = FALSE

/datum/song/proc/start_playing()
	set waitfor = FALSE
	if(!instrument || !instrument.ready())
		return FALSE
	playing = TRUE
	legacy = CHECK_BITFIELD(instrument.instrument_flags, INSTRUMENT_LEGACY)
	do_hearcheck(TRUE)
	play_lines()
	return TRUE

/datum/song/proc/do_hearcheck(force = FALSE)
	if(((world.time - GLOB.musician_hearcheck_mindelay) > last_hearcheck) || force)
		LAZYCLEARLIST(hearing_mobs)
		for(var/mob/M in hearers(15, source))
			if(!M.client || !(M.is_preference_enabled(/datum/client_preference/instrument_toggle)))
				continue
			LAZYSET(hearing_mobs, M, TRUE)
		last_hearcheck = world.time

/datum/song/proc/play_lines()
	if(now_playing)
		CRASH("WARNING: datum/song attempted to play_lines while it was already now_playing!")
		return FALSE
	now_playing = TRUE
	legacy? do_play_lines_legacy() : do_play_lines_synth()
	now_playing = FALSE
	updateDialog()
	return TRUE

/datum/song/proc/should_stop_playing()
	return !playing || !using_instrument || QDELETED(parent)

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
	if(!length(notestring))
		return
	var/cur_note = text2ascii(note, 1) - 96
	if(cur_note < 1 || cur_note > 7)
		return
	if(




for(var/beat in splittext(lowertext(line), ","))
	var/list/notes = splittext(beat, "/")
	for(var/note in splittext(notes[1], "-"))
		if(shouldStopPlaying())//If the instrument is playing, or special case
			playing = 0
			return
		if(lentext(note) == 0)
			continue
		var/cur_note = text2ascii(note) - 96
		if(cur_note < 1 || cur_note > 7)
			continue
		for(var/i=2 to lentext(note))
			var/ni = copytext(note,i,i+1)
			if(!text2num(ni))
				if(ni == "#" || ni == "b" || ni == "n")
					cur_acc[cur_note] = ni
				else if(ni == "s")
					cur_acc[cur_note] = "#" // so shift is never required
			else
				cur_oct[cur_note] = text2num(ni)
		playnote(cur_note, cur_acc[cur_note], cur_oct[cur_note])
	if(notes.len >= 2 && text2num(notes[2]))
		sleep(sanitize_tempo(tempo / text2num(notes[2])))
	else
		sleep(tempo)
repeat--
playing = 0
repeat = 0
updateDialog(user)





//Playing legacy instruments

/datum/song/proc/do_play_lines_legacy()
	var/terminate = FALSE
	while(repeat >= 0)
		var/cur_oct[7]
		var/cur_acc[7]
		for(var/i = 1 to 7)
			cur_oct[i] = 3
			cur_acc[i] = "n"

		for(var/line in lines)
			for(var/beat in splittext(lowertext(line), ","))
				var/list/notes = splittext(beat, "/")
				for(var/note in splittext(notes[1], "-"))
					if(should_stop_playing())
						terminate = TRUE
						break
					if(lentext(note) == 0)
						continue
					var/cur_note = text2ascii(note) - 96
					if(cur_note < 1 || cur_note > 7)
						continue
					for(var/i=2 to lentext(note))
						var/ni = copytext(note,i,i+1)
						if(!text2num(ni))
							if(ni == "#" || ni == "b" || ni == "n")
								cur_acc[cur_note] = ni
							else if(ni == "s")
								cur_acc[cur_note] = "#" // so shift is never required
						else
							cur_oct[cur_note] = text2num(ni)
					playnote_legacy(cur_note, cur_acc[cur_note], cur_oct[cur_note])
				if(notes.len >= 2 && text2num(notes[2]))
					sleep(sanitize_tempo_ds(tempo_ds / text2num(notes[2])))
				else
					sleep(tempo)
		repeat--
		if(should_stop_playing())
			terminate = TRUE
		if(terminate)
			break
		updateUsrDialog()

// note is a number from 1-7 for A-G
// acc is either "b", "n", or "#"
// oct is 1-8 (or 9 for C)
/datum/song/proc/playnote_legacy(note, acc as text, oct)
	// handle accidental -> B<>C of E<>F
	if(acc == "b" && (note == 3 || note == 6)) // C or F
		if(note == 3)
			oct--
		note--
		acc = "n"
	else if(acc == "#" && (note == 2 || note == 5)) // B or E
		if(note == 2)
			oct++
		note++
		acc = "n"
	else if(acc == "#" && (note == 7)) //G#
		note = 1
		acc = "b"
	else if(acc == "#") // mass convert all sharps to flats, octave jump already handled
		acc = "b"
		note++

	// check octave, C is allowed to go to 9
	if(oct < 1 || (note == 3 ? oct > 9 : oct > 8))
		return

	// now generate name
	var/soundfile = "sound/instruments/[cached_legacy_dir]/[ascii2text(note+64)][acc][oct].[cached_legacy_ext]"
	soundfile = file(soundfile)
	// make sure the note exists
	if(!fexists(soundfile))
		return
	// and play
	var/turf/source = get_turf(parentj)
	do_hearcheck()
	var/sound/music_played = sound(soundfile)
	for(var/i in hearing_mobs)
		var/mob/M = i
		M.playsound_local(source, null, 100, falloff = 5, S = music_played)

///////////////////






/datum/song/proc/updateDialog(mob/user)
	parent?.updateDialog()		// assumes it's an object in world, override if otherwise



/datum/song/proc/interact(mob/user)
	var/dat = ""
	if(lines.len > 0)
		dat += "<H3>Playback</H3>"
		if(!playing)
			dat += {"<A href='?src=\ref[src];play=1'>Play</A> <SPAN CLASS='linkOn'>Stop</SPAN><BR><BR>
				Repeat Song:
				[repeat > 0 ? "<A href='?src=\ref[src];repeat=-10'>-</A><A href='?src=\ref[src];repeat=-1'>-</A>" : "<SPAN CLASS='linkOff'>-</SPAN><SPAN CLASS='linkOff'>-</SPAN>"]
				 [repeat] times
				[repeat < max_repeats ? "<A href='?src=\ref[src];repeat=1'>+</A><A href='?src=\ref[src];repeat=10'>+</A>" : "<SPAN CLASS='linkOff'>+</SPAN><SPAN CLASS='linkOff'>+</SPAN>"]
				<BR>"}
		else
			dat += {"<SPAN CLASS='linkOn'>Play</SPAN> <A href='?src=\ref[src];stop=1'>Stop</A><BR>
				Repeats left: <B>[repeat]</B><BR>"}
	if(!edit)
		dat += "<BR><B><A href='?src=\ref[src];edit=2'>Show Editor</A></B><BR>"
	else
		var/bpm = round(600 / tempo)
		dat += {"<H3>Editing</H3>
			<B><A href='?src=\ref[src];edit=1'>Hide Editor</A></B>
			 <A href='?src=\ref[src];newsong=1'>Start a New Song</A>
			 <A href='?src=\ref[src];import=1'>Import a Song</A><BR><BR>
			Tempo: <A href='?src=\ref[src];tempo=[world.tick_lag]'>-</A> [bpm] BPM <A href='?src=\ref[src];tempo=-[world.tick_lag]'>+</A><BR><BR>"}
		var/linecount = 0
		for(var/line in lines)
			linecount += 1
			dat += "Line [linecount]: <A href='?src=\ref[src];modifyline=[linecount]'>Edit</A> <A href='?src=\ref[src];deleteline=[linecount]'>X</A> [line]<BR>"
		dat += "<A href='?src=\ref[src];newline=1'>Add Line</A><BR><BR>"
		if(help)
			dat += {"<B><A href='?src=\ref[src];help=1'>Hide Help</A></B><BR>
					Lines are a series of chords, separated by commas (,), each with notes seperated by hyphens (-).<br>
					Every note in a chord will play together, with chord timed by the tempo.<br>
					<br>
					Notes are played by the names of the note, and optionally, the accidental, and/or the octave number.<br>
					By default, every note is natural and in octave 3. Defining otherwise is remembered for each note.<br>
					Example: <i>C,D,E,F,G,A,B</i> will play a C major scale.<br>
					After a note has an accidental placed, it will be remembered: <i>C,C4,C,C3</i> is <i>C3,C4,C4,C3</i><br>
					Chords can be played simply by seperating each note with a hyphon: <i>A-C#,Cn-E,E-G#,Gn-B</i><br>
					A pause may be denoted by an empty chord: <i>C,E,,C,G</i><br>
					To make a chord be a different time, end it with /x, where the chord length will be length<br>
					defined by tempo / x: <i>C,G/2,E/4</i><br>
					Combined, an example is: <i>E-E4/4,F#/2,G#/8,B/8,E3-E4/4</i>
					<br>
					Lines may be up to 50 characters.<br>
					A song may only contain up to 50 lines.<br>
					"}
		else
			dat += "<B><A href='?src=\ref[src];help=2'>Show Help</A></B><BR>"
	var/datum/browser/popup = new(user, "instrument", parent? parent.name : "Song Display" , 700, 500)
	popup.set_content(dat)
	popup.set_title_image(user.browse_rsc_icon(instrumentObj.icon, instrumentObj.icon_state))
	popup.open()

/datum/song/Topic(href, href_list)
	if(!instrumentObj.Adjacent(usr) || usr.stat)
		usr << browse(null, "window=instrument")
		usr.unset_machine()
		return
	instrumentObj.add_fingerprint(usr)
	if(href_list["newsong"])
		lines = new()
		tempo = sanitize_tempo(5) // default 120 BPM
		name = ""
	else if(href_list["import"])
		var/t = ""
		do
			t = html_encode(input(usr, "Please paste the entire song, formatted:", text("[]", name), t)  as message)
			if(!in_range(instrumentObj, usr))
				return
			if(lentext(t) >= INSTRUMENT_MAX_LINE_LENGTH*INSTRUMENT_MAX_LINE_NUMBER)
				var/cont = input(usr, "Your message is too long! Would you like to continue editing it?", "", "yes") in list("yes", "no")
				if(cont == "no")
					break
		while(lentext(t) > INSTRUMENT_MAX_LINE_LENGTH*INSTRUMENT_MAX_LINE_NUMBER)
		//split into lines
		spawn()
			lines = splittext(t, "\n")
			if(copytext(lines[1],1,6) == "BPM: ")
				tempo = sanitize_tempo(600 / text2num(copytext(lines[1],6)))
				lines.Cut(1,2)
			else
				tempo = sanitize_tempo(5) // default 120 BPM
			if(lines.len > INSTRUMENT_MAX_LINE_NUMBER)
				to_chat(usr, "Too many lines!")
				lines.Cut(INSTRUMENT_MAX_LINE_NUMBER+1)
			var/linenum = 1
			for(var/l in lines)
				if(lentext(l) > INSTRUMENT_MAX_LINE_LENGTH)
					to_chat(usr, "Line [linenum] too long!")
					lines.Remove(l)
				else
					linenum++
			updateDialog(usr)		// make sure updates when complete
	else if(href_list["help"])
		help = text2num(href_list["help"]) - 1
	else if(href_list["edit"])
		edit = text2num(href_list["edit"]) - 1
	if(href_list["repeat"]) //Changing this from a toggle to a number of repeats to avoid infinite loops.
		if(playing)
			return //So that people cant keep adding to repeat. If the do it intentionally, it could result in the server crashing.
		repeat += round(text2num(href_list["repeat"]))
		if(repeat < 0)
			repeat = 0
		if(repeat > max_repeats)
			repeat = max_repeats
	else if(href_list["tempo"])
		tempo = sanitize_tempo(tempo + text2num(href_list["tempo"]))
	else if(href_list["play"])
		playing = 1
		spawn()
			playsong(usr)
	else if(href_list["newline"])
		var/newline = html_encode(input("Enter your line: ", instrumentObj.name) as text|null)
		if(!newline || !in_range(instrumentObj, usr))
			return
		if(lines.len > INSTRUMENT_MAX_LINE_NUMBER)
			return
		if(lentext(newline) > INSTRUMENT_MAX_LINE_LENGTH)
			newline = copytext(newline, 1, INSTRUMENT_MAX_LINE_LENGTH)
		lines.Add(newline)
	else if(href_list["deleteline"])
		var/num = round(text2num(href_list["deleteline"]))
		if(num > lines.len || num < 1)
			return
		lines.Cut(num, num+1)
	else if(href_list["modifyline"])
		var/num = round(text2num(href_list["modifyline"]),1)
		var/content = html_encode(input("Enter your line: ", instrumentObj.name, lines[num]) as text|null)
		if(!content || !in_range(instrumentObj, usr))
			return
		if(lentext(content) > INSTRUMENT_MAX_LINE_LENGTH)
			content = copytext(content, 1, INSTRUMENT_MAX_LINE_LENGTH)
		if(num > lines.len || num < 1)
			return
		lines[num] = content
	else if(href_list["stop"])
		playing = 0
	updateDialog(usr)
	return







/datum/synthesized_song
	var/playing = 0
	var/autorepeat = 0
	var/current_line = 0

	var/datum/sound_player/player // Not a physical thing
	var/datum/instrument/instrument_data

	var/linear_decay = 1
	var/sustain_timer = 1
	var/soft_coeff = 2.0
	var/transposition = 0

	var/octave_range_min
	var/octave_range_max

	var/sound_id

	var/available_channels //Alright, this basically starts as the max config value and we will decrease and increase at runtime


/datum/synthesized_song/New(datum/sound_player/playing_object, datum/instrument/instrument)
	src.player = playing_object
	src.instrument_data = instrument
	src.octave_range_min = GLOB.musical_config.lowest_octave
	src.octave_range_max = GLOB.musical_config.highest_octave

	instrument.create_full_sample_deviation_map()



	available_channels = GLOB.musical_config.channels_per_instrument

/datum/synthesized_song/Destroy()
	player.event_manager.deactivate()

/datum/synthesized_song/proc/sanitize_tempo(new_tempo) // Identical to datum/song
	new_tempo = abs(new_tempo)
	return max(round(new_tempo, world.tick_lag), world.tick_lag)


/datum/synthesized_song/proc/play_synthesized_note(note, acc, oct, duration, where, which_one)
	if (oct < GLOB.musical_config.lowest_octave || oct > GLOB.musical_config.highest_octave)	return
	if (oct < src.octave_range_min || oct > src.octave_range_max)	return

	var/delta1 = acc == "b" ? -1 : acc == "#" ? 1 : acc == "s" ? 1 : acc == "n" ? 0 : 0
	var/delta2 = 12 * oct

	var/note_num = delta1+delta2+GLOB.musical_config.nn2no[note]
	if (note_num < 0 || note_num > 127)
		CRASH("play_synthesized note failed because of 0..127 condition, [note], [acc], [oct]")
		return

	var/datum/sample_pair/pair = src.instrument_data.sample_map[GLOB.musical_config.n2t(note_num)]
	#define Q 0.083 // 1/12
	var/freq = 2**(Q*pair.deviation)
	#undef Q

	src.play(pair.sample, duration, freq, note_num, where, which_one)


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


#define CP(L, S) copytext(L, S, S+1)
#define IS_DIGIT(L) (L >= "0" && L <= "9" ? 1 : 0)

#define STOP_PLAY_LINES \
	autorepeat = 0 ;\
	playing = 0 ;\
	current_line = 0 ;\
	player.event_manager.deactivate() ;\
	return

/datum/synthesized_song/proc/play_lines(mob/user, list/allowed_suff, list/note_off_delta, list/lines)
	if (!lines.len)
		STOP_PLAY_LINES
	var/list/cur_accidentals = list("n", "n", "n", "n", "n", "n", "n")
	var/list/cur_octaves = list(3, 3, 3, 3, 3, 3, 3)
	src.current_line = 1
	for (var/line in lines)
		var/cur_note = 1
		if (src.player && src.player.actual_instrument)
			var/obj/structure/synthesized_instrument/S = src.player.actual_instrument
			var/datum/real_instrument/R = S.real_instrument
			if (R.song_editor)
				SSnano.update_uis(R.song_editor)
		for (var/notes in splittext(lowertext(line), ","))
			var/list/components = splittext(notes, "/")
			var/duration = sanitize_tempo(src.tempo)
			if (components.len)
				var/delta = components.len==2 && text2num(components[2]) ? text2num(components[2]) : 1
				var/note_str = splittext(components[1], "-")

				duration = sanitize_tempo(src.tempo / delta)
				src.player.event_manager.suspended = 1
				for (var/note in note_str)
					if (!note)	continue // wtf, empty note
					var/note_sym = CP(note, 1)
					var/note_off = 0
					if (note_sym in note_off_delta)
						note_off = text2ascii(note_sym) - note_off_delta[note_sym]
					else
						continue // Shitty note, move along and avoid runtimes

					var/octave = cur_octaves[note_off]
					var/accidental = cur_accidentals[note_off]

					switch (length(note))
						if (3)
							accidental = CP(note, 2)
							octave = CP(note, 3)
							if (!(accidental in allowed_suff) || !IS_DIGIT(octave))
								continue
							else
								octave = text2num(octave)
						if (2)
							if (IS_DIGIT(CP(note, 2)))
								octave = text2num(CP(note, 2))
							else
								accidental = CP(note, 2)
								if (!(accidental in allowed_suff))
									continue
					cur_octaves[note_off] = octave
					cur_accidentals[note_off] = accidental
					play_synthesized_note(note_off, accidental, octave+transposition, duration, src.current_line, cur_note)
					if (src.player.event_manager.is_overloaded())
						STOP_PLAY_LINES
			cur_note++
			src.player.event_manager.suspended = 0
			if (!src.playing || src.player.shouldStopPlaying(user))
				STOP_PLAY_LINES
			sleep(duration)
		src.current_line++
	if (src.autorepeat)
		.()

#undef STOP_PLAY_LINES

/datum/synthesized_song/proc/play_song(mob/user)
	// This code is really fucking horrible.
	src.player.event_manager.activate()
	var/list/allowed_suff = list("b", "n", "#", "s")
	var/list/note_off_delta = list("a"=91, "b"=91, "c"=98, "d"=98, "e"=98, "f"=98, "g"=98)
	var/list/lines_copy = src.lines.Copy()
	addtimer(CALLBACK(src, .proc/play_lines, user, allowed_suff, note_off_delta, lines_copy), 0)

#undef CP
#undef IS_DIGIT
