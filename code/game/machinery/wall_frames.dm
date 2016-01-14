/obj/item/frame
	name = "frame parts"
	desc = "Used for building frames."
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "frame_bitem"
	flags = CONDUCT
	var/build_machine_type = /obj/structure/frame
	var/refund_amt = 2
	var/refund_type = /obj/item/stack/material/steel
	var/reverse = 0 //if resulting object faces opposite its dir (like light fixtures)
	var/frame_type = null
	var/frame_base = 0

/obj/item/frame/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/wrench))
		new refund_type( get_turf(src.loc), refund_amt)
		qdel(src)
		return
	..()

/obj/item/frame/attack_self(mob/user as mob)
	..()
	if(!build_machine_type)
		return

	var/ndir

	var/response = alert(user, "What kind of frame would you like to make?", "Frame type request", "Computer", "Machine")
	switch(response)
		if("Computer") frame_type = "computer"
		if("Machine") frame_type = "machine"

	var/obj/machinery/M = new build_machine_type(get_turf(src.loc), ndir, 1, frame_type)
	M.fingerprints = src.fingerprints
	M.fingerprintshidden = src.fingerprintshidden
	M.fingerprintslast = src.fingerprintslast
	qdel(src)

/obj/item/frame/proc/try_build(turf/on_wall, mob/user as mob)
	if(frame_base == 0)
		var/response = input(usr, "What kind of frame would you like to make?", "Frame type request", null) in list("Fire Alarm", "Air Alarm", "Display", "Newscaster")
		switch(response)
			if("Fire Alarm") frame_type = "alarm"
			if("Air Alarm")
				frame_type = "alarm"
				icon = 'icons/obj/monitors.dmi'
			if("Display") frame_type = "display"
			if("Newscaster")
				frame_type = "display"
				icon = 'icons/obj/terminals.dmi'

	if(!build_machine_type)
		return

	if (get_dist(on_wall,usr)>1)
		return

	var/ndir
	if(reverse)
		ndir = get_dir(usr,on_wall)
	else
		ndir = get_dir(on_wall,usr)

	if (!(ndir in cardinal))
		return

	var/turf/loc = get_turf(usr)
	var/area/A = loc.loc
	if (!istype(loc, /turf/simulated/floor))
		usr << "<span class='danger'>\The frame cannot be placed on this spot.</span>"
		return
	if (A.requires_power == 0 || A.name == "Space")
		usr << "<span class='danger'>\The [src] Alarm cannot be placed in this area.</span>"
		return

	if(gotwallitem(loc, ndir))
		usr << "<span class='danger'>There's already an item on this wall!</span>"
		return
	var/obj/machinery/M = new build_machine_type(loc, ndir, 1, frame_type, icon)
	M.fingerprints = src.fingerprints
	M.fingerprintshidden = src.fingerprintshidden
	M.fingerprintslast = src.fingerprintslast
	qdel(src)

/obj/item/frame/light
	name = "light fixture frame"
	desc = "Used for building lights."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "tube-construct-item"
	build_machine_type = /obj/machinery/light_construct
	reverse = 1
	frame_base = 1

/obj/item/frame/light/small
	name = "small light fixture frame"
	icon_state = "bulb-construct-item"
	refund_amt = 1
	build_machine_type = /obj/machinery/light_construct/small
	frame_base = 1

/obj/item/frame/extinguisher_cabinet
	name = "extinguisher cabinet frame"
	desc = "Used for building fire extinguisher cabinets."
	icon = 'icons/obj/closet.dmi'
	icon_state = "extinguisher_empty"
	build_machine_type = /obj/structure/extinguisher_cabinet
	frame_base = 1

/obj/item/frame/noticeboard
	name = "noticeboard frame"
	desc = "Used for building noticeboards."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "nboard00"
	build_machine_type = /obj/structure/noticeboard
	frame_base = 1