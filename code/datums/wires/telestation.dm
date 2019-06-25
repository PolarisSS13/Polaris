/datum/wires/telestation
	wire_count = 6
	holder_type = /obj/machinery/teleport/station

#define WIRE_LOCK 	1 //pulse to lock/unlock, cut to keep it that way
#define WIRE_TESTFIRE 	2 //pulse to testfire, cut to stop testfires working
#define WIRE_ACTIVATE	4 //pulse to activate/deactivate, cut to disable the teleporter
#define WIRE_DUMMY_1	8 //does nothing
#define WIRE_ELECTRIC	16 //creates electrosmoke when pulsed, zaps you when cut
#define WIRE_RANDOMISE	32 //pulse to randomise the "get spaced" chance, cut to reset it to 5%

/datum/wires/telestation/GetInteractWindow()
	. = ..()
	. += "<br>\n["Warning: tampering with teleporter station wiring may result in bluespace dislocation."]"
	return .

/datum/wires/telestation/UpdateCut(var/index, var/mended)
	var/obj/machinery/teleport/station/C = holder

	switch(index)
		if(WIRE_LOCK)
			C.visible_message("\icon[C] *beep-beep*", "\icon[C] *beep-beep*")
			if(!mended)
				C.fixlock = TRUE
			else
				C.fixlock = FALSE

		if(WIRE_TESTFIRE)
			if(C.com)
				if(!mended)
					C.com.testfire_broken = TRUE
				else
					C.com.testfire_broken = FALSE

		if(WIRE_ACTIVATE)
			if(!mended)
				if(C.engaged)
					C.disengage()
				C.tele_broken = TRUE
			else
				C.tele_broken = FALSE

		if(WIRE_DUMMY_1)
			return

		if(WIRE_ELECTRIC)
			if(!mended)
				C.electrified = TRUE
			else
				C.electrified = FALSE
			return

		if(WIRE_RANDOMISE)
			if(C.com)
				C.com.failprob = 5 //resets the failprob to base %
	return

/datum/wires/telestation/UpdatePulsed(var/index)
	var/obj/machinery/teleport/station/C = holder
	if(IsIndexCut(index))
		return
	switch(index)
		if(WIRE_LOCK)
			C.visible_message("\icon[C] *beep-beep*", "\icon[C] *beep-beep*")
			C.com.failprob = min(90, C.com.failprob + 15 + rand(-15, 30)) //add 15, then add between -15 and +30, to a maximum of 90. scrambles, but (un)locks.
			C.lock()

		if(WIRE_TESTFIRE)
			C.testfire()

		if(WIRE_ACTIVATE)
			if(C.engaged)
				C.disengage()
			else
				C.engage()

		if(WIRE_DUMMY_1)
			return

		if(WIRE_ELECTRIC)
			new /obj/effect/effect/smoke/elemental/shock(get_turf(C))
			return

		if(WIRE_RANDOMISE)
			if(C.com)
				C.com.failprob = min(90, C.com.failprob + 10 + rand(-15, 30)) //add 10, then add between -15 and +30, to a maximum of 90. scrambles and doesn't unlock, but will tell you if it's really bad.
				if(C.com.failprob > 75)
					C.visible_message("<span class='warning'>\icon[C] *Alert: bluespace matrix out of alignment.*</span>", "<span class='warning'>\icon[C] *Alert: bluespace matrix out of alignment.*</span>")
	return

/datum/wires/telestation/CanUse(var/mob/living/L)
	var/obj/machinery/teleport/station/C = holder
	return C.panel_open
