/obj/vehicle/bicycle
	name = "bicycle"
	desc = "Keep away from electricity."
	icon_state = "bicycle"
	headlights = 0

	var/static/list/bike_music = list('sound/misc/bike1.mid',
								'sound/misc/bike2.mid',
								'sound/misc/bike3.mid')

/obj/vehicle/bicycle/unbuckle_mob(mob/living/buckled_mob,force = 0)
	if(buckled_mob)
		buckled_mob << sound(null, repeat = 0, wait = 0, volume = 80, channel = 42)
	. =..()

/obj/vehicle/bicycle/broken // :::^^^)))
	name = "fried bicycle"
	desc = "Well spent."
