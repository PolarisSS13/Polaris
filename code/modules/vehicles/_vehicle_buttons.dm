
/obj/vehicle/car/verb/honk()
	set name = "Honk horn"
	set category = "Vehicle"
	set src in view(0)

	if(!istype(usr, /mob/living/carbon/human))
		return

	if(usr.stat || usr.stunned || usr.lying )
		return

	honk_horn()
	usr << "<span class='notice'>You press the horn.</span>"


