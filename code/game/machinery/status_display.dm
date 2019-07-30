#define FONT_SIZE "5pt"
#define FONT_COLOR "#09f"
#define FONT_STYLE "Arial Black"
#define SCROLL_SPEED 2

// Status display
// (formerly Countdown timer display)

// Use to show shuttle ETA/ETD times
// Alert status
// And arbitrary messages set by comms computer
/obj/machinery/status_display
	icon = 'icons/obj/status_display.dmi'
	icon_state = "frame"
	name = "status display"
	anchored = 1
	density = 0
	use_power = 1
	idle_power_usage = 10
	circuit =  /obj/item/weapon/circuitboard/status_display
	var/mode = 1	// 0 = Blank
					// 1 = Shuttle timer
					// 2 = Arbitrary message(s)
					// 3 = alert picture
					// 4 = Supply shuttle timer

	var/picture_state	// icon_state of alert picture
	var/message1 = ""	// message line 1
	var/message2 = ""	// message line 2
	var/index1			// display index for scrolling messages or 0 if non-scrolling
	var/index2
	var/picture = null

	var/frequency = 1435		// radio frequency

	var/friendc = 0      // track if Friend Computer mode
	var/ignore_friendc = 0

	maptext_height = 26
	maptext_width = 32

	var/const/CHARS_PER_LINE = 5
	var/const/STATUS_DISPLAY_BLANK = 0
	var/const/STATUS_DISPLAY_TRANSFER_SHUTTLE_TIME = 1
	var/const/STATUS_DISPLAY_MESSAGE = 2
	var/const/STATUS_DISPLAY_ALERT = 3
	var/const/STATUS_DISPLAY_TIME = 4
	var/const/STATUS_DISPLAY_CUSTOM = 99

	//If any of these are set, they'll override the default.
	var/font_size = "5pt"
	var/font_color = "#09f"
	var/font_style = "Arial Black"

/obj/machinery/status_display/Destroy()
	if(radio_controller)
		radio_controller.remove_object(src,frequency)
	return ..()

/obj/machinery/status_display/attackby(I as obj, user as mob)
	if(computer_deconstruction_screwdriver(user, I))
		return
	else
		attack_hand(user)
	return

// register for radio system
/obj/machinery/status_display/initialize()
	. = ..()
	if(radio_controller)
		radio_controller.add_object(src, frequency)

// timed process
/obj/machinery/status_display/process()
	if(stat & NOPOWER)
		remove_display()
		return
	update()

/obj/machinery/status_display/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return
	set_picture("ai_bsod")
	..(severity)

// set what is displayed
/obj/machinery/status_display/proc/update()
	remove_display()
	if(friendc && !ignore_friendc)
		set_picture("ai_friend")
		return 1

	switch(mode)
		if(STATUS_DISPLAY_BLANK)	//blank
			return 1
		if(STATUS_DISPLAY_TRANSFER_SHUTTLE_TIME)				//emergency shuttle timer
			if(!emergency_shuttle)
				message1 = "-ETA-"
				message2 = "Never" // You're here forever.
				return 1
			if(emergency_shuttle.waiting_to_leave())
				message1 = "-ETD-"
				if(emergency_shuttle.shuttle.is_launching())
					message2 = "Launch"
				else
					message2 = get_shuttle_timer_departure()
					if(length(message2) > CHARS_PER_LINE)
						message2 = "Error"
				update_display(message1, message2)
			else if(emergency_shuttle.has_eta())
				message1 = "-ETA-"
				message2 = get_shuttle_timer_arrival()
				if(length(message2) > CHARS_PER_LINE)
					message2 = "Error"
				update_display(message1, message2)
			return 1
		if(STATUS_DISPLAY_MESSAGE)	//custom messages
			var/line1
			var/line2

			if(!index1)
				line1 = message1
			else
				line1 = copytext(message1+"|"+message1, index1, index1+CHARS_PER_LINE)
				var/message1_len = length(message1)
				index1 += SCROLL_SPEED
				if(index1 > message1_len)
					index1 -= message1_len

			if(!index2)
				line2 = message2
			else
				line2 = copytext(message2+"|"+message2, index2, index2+CHARS_PER_LINE)
				var/message2_len = length(message2)
				index2 += SCROLL_SPEED
				if(index2 > message2_len)
					index2 -= message2_len
			update_display(line1, line2)
			return 1
		if(STATUS_DISPLAY_ALERT)
			set_picture(picture_state)
			return 1
		if(STATUS_DISPLAY_TIME)
			message1 = "TIME"
			message2 = stationtime2text()
			update_display(message1, message2)
			return 1
	return 0

/obj/machinery/status_display/examine(mob/user)
	. = ..(user)
	if(mode != STATUS_DISPLAY_BLANK && mode != STATUS_DISPLAY_ALERT)
		user << "The display says:<br>\t[sanitize(message1)]<br>\t[sanitize(message2)]"

/obj/machinery/status_display/proc/set_message(m1, m2)
	if(m1)
		index1 = (length(m1) > CHARS_PER_LINE)
		message1 = m1
	else
		message1 = ""
		index1 = 0

	if(m2)
		index2 = (length(m2) > CHARS_PER_LINE)
		message2 = m2
	else
		message2 = ""
		index2 = 0

/obj/machinery/status_display/proc/set_picture(state)
	remove_display()
	if(!picture || picture_state != state)
		picture_state = state
		picture = image(icon, icon_state=picture_state)
	overlays |= picture

/obj/machinery/status_display/proc/update_display(line1, line2)
	var/fnt_sz
	var/fnt_cl
	var/fnt_stl

	if(font_size)
		fnt_sz = font_size
	else
		fnt_sz = FONT_SIZE

	if(font_color)
		fnt_cl = font_color
	else
		fnt_cl = FONT_COLOR

	if(font_style)
		fnt_stl = font_style
	else
		fnt_stl = FONT_STYLE

	var/new_text = {"<div style="font-size:[fnt_sz];color:[fnt_cl];font:'[fnt_stl]';text-align:center;" valign="top">[line1]<br>[line2]</div>"}
	if(maptext != new_text)
		maptext = new_text

/obj/machinery/status_display/proc/get_shuttle_timer_arrival()
	if(!emergency_shuttle)
		return "Error"
	var/timeleft = emergency_shuttle.estimate_arrival_time()
	if(timeleft < 0)
		return ""
	return "[add_zero(num2text((timeleft / 60) % 60),2)]:[add_zero(num2text(timeleft % 60), 2)]"

/obj/machinery/status_display/proc/get_shuttle_timer_departure()
	if(!emergency_shuttle)
		return "Error"
	var/timeleft = emergency_shuttle.estimate_launch_time()
	if(timeleft < 0)
		return ""
	return "[add_zero(num2text((timeleft / 60) % 60),2)]:[add_zero(num2text(timeleft % 60), 2)]"

/obj/machinery/status_display/proc/get_supply_shuttle_timer()
	var/datum/shuttle/ferry/supply/shuttle = supply_controller.shuttle
	if(!shuttle)
		return "Error"

	if(shuttle.has_arrive_time())
		var/timeleft = round((shuttle.arrive_time - world.time) / 10,1)
		if(timeleft < 0)
			return "Late"
		return "[add_zero(num2text((timeleft / 60) % 60),2)]:[add_zero(num2text(timeleft % 60), 2)]"
	return ""

/obj/machinery/status_display/proc/remove_display()
	if(overlays.len)
		overlays.Cut()
	if(maptext)
		maptext = ""

/obj/machinery/status_display/receive_signal(datum/signal/signal)
	switch(signal.data["command"])
		if("blank")
			mode = STATUS_DISPLAY_BLANK

		if("shuttle")
			mode = STATUS_DISPLAY_TRANSFER_SHUTTLE_TIME

		if("message")
			mode = STATUS_DISPLAY_MESSAGE
			set_message(signal.data["msg1"], signal.data["msg2"])

		if("alert")
			mode = STATUS_DISPLAY_ALERT
			set_picture(signal.data["picture_state"])

		if("time")
			mode = STATUS_DISPLAY_TIME
	update()

#undef CHARS_PER_LINE
#undef FOND_SIZE
#undef FONT_COLOR
#undef FONT_STYLE
#undef SCROLL_SPEED

/obj/machinery/status_display/time_display
	ignore_friendc = 1
	name = "time display"

/obj/machinery/status_display/time_display/update()
	message1 = "TIME"
	message2 = stationtime2text()
	update_display(message1, message2)

/obj/machinery/status_display/money_display
	ignore_friendc = 1
	desc = "This displays the current funding of a particular institution or company."
	name = "funding display"
	var/department = "Civilian"
	var/dept_name = "PUBLIC FUNDS"
	icon = 'icons/obj/status_display_wide.dmi'
	maptext_height = 26
	maptext_width = 62
	font_color = "#84ff00"

/obj/machinery/status_display/money_display/update()
	update_display(message1, message2)
	message1 = "[dept_name]:"
	message2 = "[department_accounts[department].money]CR"


/obj/machinery/status_display/money_display/city/initialize()
	department = "[station_name()] Funds"
	dept_name = "City Funds"
	..()

/obj/machinery/status_display/money_display/civilian
	department = "Civilian"
	dept_name = "Public Funds"

/obj/machinery/status_display/money_display/police
	department = "Police"
	dept_name = "Police Funds"

/obj/machinery/status_display/money_display/cargo
	department = "Cargo"
	dept_name = "Cargo Funds"

/obj/machinery/status_display/money_display/council
	department = "City Council"
	dept_name = "Council Funds"


/obj/machinery/status_display/money_display/hospital
	department = "Public Healthcare"
	dept_name = "Health Funds"

/obj/machinery/status_display/money_display/emt
	department = "Emergency and Maintenance"
	dept_name = "EMT Funds"


/obj/machinery/status_display/money_display/rnd
	department = "Research and Science"
	dept_name = "R&D Funds"


/obj/machinery/status_display/money_display/bar
	department = "Bar"
	dept_name = "Bar Funds"


/obj/machinery/status_display/money_display/botany
	department = "Botany"
	dept_name = "Botany Funds"
