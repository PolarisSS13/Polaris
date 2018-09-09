/obj/structure/flora/rock
	name = "rock"
	icon = 'icons/obj/flora/rocks.dmi'
	icon_state = "basalt1"
	desc = "Almost makes you want to take it home as a pet."
	anchored = 1
	burn_state = 1 //can't really burn a rock... for now.

/obj/structure/flora/rock/New()
	..()
	icon_state = pick("basalt1",
							"basalt2",
							"basalt3")