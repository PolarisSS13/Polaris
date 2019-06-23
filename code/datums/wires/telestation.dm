/datum/wires/telestation
	wire_count = 6
	holder_type = /obj/machinery/teleport/station

#define WIRE_LOCK 	1 //pulse to lock/unlock, cut to keep it that way
#define WIRE_TESTFIRE 	2 //pulse to testfire, cut to stop testfires working
#define WIRE_ACTIVATE	4 //pulse to activate/deactivate, cut to disable the teleporter
#define WIRE_DUMMY_1	8 //does nothing
#define WIRE_DUMMY_2	16 //does nothing
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
				C.tele_broken = TRUE
			else
				C.tele_broken = FALSE

		if(WIRE_DUMMY_1)
			return

		if(WIRE_DUMMY_2)
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

		if(WIRE_DUMMY_2)
			return

		if(WIRE_RANDOMISE)
			if(C.com)
				C.com.failprob = rand(1,100)
				if(C.com.failprob > 75)
					C.visible_message("<span class='warning'>\icon[C] *Alert: bluespace matrix out of alignment.*</span>", "<span class='warning'>\icon[C] *Alert: bluespace matrix out of alignment.*</span>")
	return

/datum/wires/telestation/CanUse(var/mob/living/L)
	var/obj/machinery/teleport/station/C = holder
	return C.panel_open
