/obj/vehicle/car/verb/start_engine()
	set name = "Start engine"
	set category = "Vehicle"
	set src in view(0)

	if(!istype(usr, /mob/living/carbon/human))
		return

	if(!has_key())
		usr << "<span class='warning'>There's no keys in the ignition.</span>"
		return

	if(on)
		usr << "<span class='warning'>The engine is already running.</span>"
		return

	if(!spam_flag)
		spam_flag = 1
		cooldowntime = 30
		if(!on)
			playsound(src.loc, engine_start, 100, 0, 10)
			usr << "<span class='notice'>You start [src]'s engine.</span>"
			turn_on()
			spawn(cooldowntime)
				spam_flag = 0
		else
			if(cell.charge < charge_use)
				usr << "<span class='warning'>[src] is out of power.</span>"
			else
				spam_flag = 1
				cooldowntime = 20
				usr << "<span class='warning'>[src]'s engine won't start.</span>"
				playsound(src.loc, engine_fail, 80, 0, 10)
				spawn(cooldowntime)
					spam_flag = 0

/obj/vehicle/car/verb/stop_engine()
	set name = "Stop engine"
	set category = "Vehicle"
	set src in view(0)

	if(!istype(usr, /mob/living/carbon/human))
		return

	if(!on)
		usr << "<span class='warning'>The engine is already stopped.</span>"
		return

	turn_off()
	if (!on)
		usr << "<span class='notice'>You stop [src]'s engine.</span>"


/obj/vehicle/car/verb/honk()
	set name = "Honk horn"
	set category = "Vehicle"
	set src in view(0)

	if(!istype(usr, /mob/living/carbon/human))
		return

	if(usr.stat || usr.stunned || usr.lying )
		return

	if(on)
		honk_horn()
		usr << "<span class='notice'>You press the horn.</span>"
	else
		usr << "<span class='notice'>Nothing happens, the engine is off.</span>"

/obj/vehicle/car/verb/remove_key()
	set name = "Remove key"
	set category = "Vehicle"
	set src in view(0)

	if(!istype(usr, /mob/living/carbon/human))
		return

	if(!key)
		return

	if(on)
		turn_off()

	key.loc = usr.loc
	if(!usr.get_active_hand())
		usr.put_in_hands(key)
	key = null

	verbs -= /obj/vehicle/train/engine/verb/remove_key


