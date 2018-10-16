/datum/wires/jukebox
	random = 1
	holder_type = /obj/machinery/media/jukebox
	wire_count = 11

#define WIRE_POWER		1
#define WIRE_HACK		2
#define WIRE_SPEEDUP		4
#define WIRE_SPEEDDOWN		8
#define WIRE_REVERSE		16
#define WIRE_NOTHING1		32
#define WIRE_NOTHING2		64
#define WIRE_START		128
#define WIRE_STOP		256
#define WIRE_PREV		512
#define WIRE_NEXT		1024

/datum/wires/jukebox/CanUse(var/mob/living/L)
	var/obj/machinery/media/jukebox/A = holder
	if(A.panel_open)
		return 1
	return 0

// Show the status of lights as a hint to the current state
/datum/wires/jukebox/GetInteractWindow()
	var/obj/machinery/media/jukebox/A = holder
	. += ..()
	. += "<BR>The power light is [(A.stat & (BROKEN|NOPOWER)) ? "off" : "on"].<BR>"
	. += "The parental guidance light is [A.hacked ? "off" : "on"].<BR>"
	. += "The data light is [IsIndexCut(WIRE_REVERSE) ? "hauntingly dark" : "glowing sloftly"].<BR>"

// Give a hint as to what each wire does
/datum/wires/jukebox/UpdatePulsed(var/index)
	var/obj/machinery/media/jukebox/A = holder
	switch(index)
		if(WIRE_POWER)
			holder.visible_message("<span class='notice'>\icon[holder] The power light flickers.</span>")
			A.shock(usr, 90)
		if(WIRE_HACK)
			holder.visible_message("<span class='notice'>\icon[holder] The parental guidance light flickers.</span>")
		if(WIRE_REVERSE)
			holder.visible_message("<span class='notice'>\icon[holder] The data light blinks ominously.</span>")
		if(WIRE_SPEEDUP)
			holder.visible_message("<span class='notice'>\icon[holder] The speakers squeaks.</span>")
		if(WIRE_SPEEDDOWN)
			holder.visible_message("<span class='notice'>\icon[holder] The speakers rumble.</span>")
		if(WIRE_START)
			A.StartPlaying()
		if(WIRE_STOP)
			A.StopPlaying()
		if(WIRE_PREV)
			A.PrevTrack()
		if(WIRE_NEXT)
			A.NextTrack()
		else
			A.shock(usr, 10) // The nothing wires give a chance to shock just for fun

/datum/wires/jukebox/UpdateCut(var/index, var/mended)
	var/obj/machinery/media/jukebox/A = holder

	switch(index)
		if(WIRE_POWER)
			// TODO - Actually make machine electrified or something.
			A.shock(usr, 90)

		if(WIRE_HACK)
			if(mended)
				A.set_hacked(0)
			else
				A.set_hacked(1)

		if(WIRE_SPEEDUP, WIRE_SPEEDDOWN, WIRE_REVERSE)
			var/newfreq = IsIndexCut(WIRE_REVERSE) ? -1 : 1;
			if (IsIndexCut(WIRE_SPEEDUP))
				newfreq *= 2
			if (IsIndexCut(WIRE_SPEEDDOWN))
				newfreq *= 0.5
			A.freq = newfreq
