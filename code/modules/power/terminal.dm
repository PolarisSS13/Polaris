// the underfloor wiring terminal for the APC
// autogenerated when an APC is placed
// all conduit connects go to this object instead of the APC
// using this solves the problem of having the APC in a wall yet also inside an area

/obj/machinery/power/terminal
	name = "terminal"
	icon_state = "term"
	desc = "It's an underfloor wiring terminal for power equipment."
	level = 1
	var/obj/machinery/power/master = null
	anchored = 1
	plane = PLATING_PLANE
	layer = WIRES_LAYER+0.01


/obj/machinery/power/terminal/Initialize()
	. = ..()
	var/turf/T = src.loc
	if(level==1) hide(!T.is_plating())
	return

/obj/machinery/power/terminal/Destroy()
	if(master)
		master.disconnect_terminal(src)
		master = null
	return ..()

/obj/machinery/power/terminal/hide(var/i)
	invisibility = i ? 101 : 0
	icon_state = i ? "term-f" : "term"

/obj/machinery/power/terminal/hides_under_flooring()
	return 1

// Needed so terminals are not removed from machines list.
// Powernet rebuilds need this to work properly.
/obj/machinery/power/terminal/process()
	return 1

/obj/machinery/power/terminal/overload(var/obj/machinery/power/source)
	if(master)
		master.overload(source)
