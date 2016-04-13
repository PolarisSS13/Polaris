//////////////SIREN//////////////
/obj/machinery/siren
	name = "siren"
	desc = "A small wall-mounted siren"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "siren0"
	light_color = "#a91515"
	light_range = 2
	light_power = 0
	layer = 5
	idle_power_usage = 2
	active_power_usage = 20

	var/alarm = 0
	var/alarm_change = 0


/obj/machinery/siren/process()
	if(alarm_change)
		if(alarm && !(stat & (NOPOWER|BROKEN)))
			icon_state = "siren1"
			set_light(light_range, light_power, light_color)
		else
			icon_state = "siren0"
			set_light(0)
		alarm_change = 0
	if(alarm)
		alarm--
		if(!alarm)
			alarm_change = 1


/obj/machinery/siren/proc/setAlarm(var/duration = 1)
	if(!alarm)
		alarm_change = 1
	alarm = duration


/obj/machinery/siren/power_change()
	alarm_change = 1
	process()