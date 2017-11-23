/obj/item/device/camerabug
	name = "mobile camera pod"
	desc = "A camera pod used by tactical operators. Must be linked to a camera scanner unit."
	icon = 'icons/obj/grenade.dmi'
	icon_state = "camgrenade"
	item_state = "empgrenade"

	flags = CONDUCT
	force = 5.0
	w_class = ITEMSIZE_SMALL
	throwforce = 5.0
	throw_range = 15
	throw_speed = 3
	origin_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)

	var/obj/item/device/radio/bug/radio
	var/obj/machinery/camera/bug/camera

/obj/item/device/camerabug/spy
	name = "bug"
	desc = ""	//Nothing to see here
	icon = 'icons/obj/weapons.dmi'
	icon_state = "eshield0"
	item_state = "nothing"
	layer = TURF_LAYER+0.2
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	origin_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1, TECH_ILLEGAL = 3)

/obj/item/device/camerabug/New()
	..()
	radio = new(src)
	camera = new(src)

/obj/item/device/camerabug/examine(mob/user)
	. = ..(user, 0)
	if(.)
		user << "It's a tiny camera, microphone, and transmission device in a happy union."
		user << "Needs to be both configured and brought in contact with monitor device to be fully functional."

/obj/item/device/camerabug/attack_self(mob/user)
	radio.attack_self(user)

/obj/item/device/camerabug/attackby(obj/W as obj, mob/living/user as mob)
	if(istype(W, /obj/item/device/bug_monitor))
		var/obj/item/device/bug_monitor/SM = W
		SM.pair(src, user)
	else
		..()

/obj/item/device/camerabug/hear_talk(mob/M, var/msg, verb, datum/language/speaking)
	radio.hear_talk(M, msg, speaking)

/obj/item/device/bug_monitor
	name = "mobile camera pod monitor"
	desc = "A portable camera console designed to work with mobile camera pods."
	icon = 'icons/obj/device.dmi'
	icon_state = "forensic0"
	item_state = "electronic"
	w_class  = ITEMSIZE_SMALL
	origin_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)

	var/operating = 0
	var/obj/item/device/radio/bug/radio
	var/obj/machinery/camera/bug/selected_camera
	var/list/obj/machinery/camera/bug/cameras = new()

/obj/item/device/bug_monitor/New()
	radio = new(src)

/obj/item/device/bug_monitor/attack_self(mob/user)
	if(operating)
		return

	radio.attack_self(user)
	view_cameras(user)

/obj/item/device/bug_monitor/attackby(obj/W as obj, mob/living/user as mob)
	if(istype(W, /obj/item/device/camerabug))
		pair(W, user)
	else
		return ..()

/obj/item/device/bug_monitor/proc/pair(var/obj/item/device/camerabug/SB, var/mob/living/user)
	if(SB.camera in cameras)
		user << "<span class='notice'>\The [SB] has been unpaired from \the [src].</span>"
		cameras -= SB.camera
	else
		user << "<span class='notice'>\The [SB] has been paired with \the [src].</span>"
		cameras += SB.camera

/obj/item/device/bug_monitor/proc/view_cameras(mob/user)
	if(!can_use_cam(user))
		return

	selected_camera = cameras[1]
	view_camera(user)

	operating = 1
	while(selected_camera && Adjacent(user))
		selected_camera = input("Select camera to view.") as null|anything in cameras
	selected_camera = null
	operating = 0

/obj/item/device/bug_monitor/proc/view_camera(mob/user)
	spawn(0)
		while(selected_camera && Adjacent(user))
			var/turf/T = get_turf(selected_camera)
			if(!T || !is_on_same_plane_or_station(T.z, user.z) || !selected_camera.can_use())
				user.unset_machine()
				user.reset_view(null)
				user << "<span class='notice'>[selected_camera] unavailable.</span>"
				sleep(90)
			else
				user.set_machine(selected_camera)
				user.reset_view(selected_camera)
			sleep(10)
		user.unset_machine()
		user.reset_view(null)

/obj/item/device/bug_monitor/proc/can_use_cam(mob/user)
	if(operating)
		return

	if(!cameras.len)
		to_chat(user, "<span class='warning'>No paired cameras detected!</span>")
		to_chat(user, "<span class='warning'>Bring a camera in contact with this device to pair the camera.</span>")
		return

	return 1

/obj/item/device/bug_monitor/hear_talk(mob/M, var/msg, verb, datum/language/speaking)
	return radio.hear_talk(M, msg, speaking)

/obj/item/device/bug_monitor/spy
	name = "\improper PDA"
	desc = "A portable microcomputer by Thinktronic Systems, LTD. Functionality determined by a preprogrammed ROM cartridge."
	icon = 'icons/obj/pda.dmi'
	icon_state = "pda"
	item_state = "electronic"
	origin_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1, TECH_ILLEGAL = 3)

/obj/item/device/bug_monitor/spy/examine(mob/user)
	. = ..(user, 1)
	if(.)
		user << "The time '12:00' is blinking in the corner of the screen and \the [src] looks very cheaply made."

/obj/machinery/camera/bug/check_eye(var/mob/user as mob)
	return 0

/obj/machinery/camera/bug
	network = list(NETWORK_SECURITY)

/obj/machinery/camera/bug/New()
	..()
	name = "MCP #[rand(1000,9999)]"
	c_tag = name

/obj/machinery/camera/bug/spy
	// These cheap toys are accessible from the mercenary camera console as well - only the antag ones though!
	network = list(NETWORK_MERCENARY)

/obj/machinery/camera/bug/spy/New()
	..()
	name = "DV-136ZB #[rand(1000,9999)]"
	c_tag = name

/obj/item/device/radio/bug
	listening = 0 //turn it on first
	frequency = 1359 //sec comms
	broadcasting = 0
	canhear_range = 1
	name = "camera bug device"
	icon_state = "syn_cypherkey"

/obj/item/device/radio/bug/spy
	listening = 0
	frequency = 1473
	broadcasting = 0
	canhear_range = 1
	name = "spy device"
	icon_state = "syn_cypherkey"
