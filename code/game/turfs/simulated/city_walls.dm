// Walls
/material/chrome
	name = "chrome"
	display_name = "Chrome"
	icon_base = "hospital"
	..()

/material/blackchrome
	name = "blackchrome"
	display_name = "Black Chrome"
	icon_base = "tech"
	..()

/turf/simulated/wall/chrome
	icon_state = "hospital"

/turf/simulated/wall/chrome/New(var/newloc)
	..(newloc,"chrome")


/turf/simulated/wall/tech
	icon_state = "tech"

/turf/simulated/wall/tech/New(var/newloc)
	..(newloc,"blackchrome")

/material/greysteel
	name = "greysteel"
	display_name = "Grey Steel"
	icon_base = "steel"
	..()

/turf/simulated/wall/greysteel
	icon_state = "steel"

/turf/simulated/wall/greysteel/New(var/newloc)
	..(newloc,"greysteel")