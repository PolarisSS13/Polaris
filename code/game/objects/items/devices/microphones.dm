
/obj/item/device/microphone
	name = "microphone"
	icon = 'icons/obj/radio.dmi'
	icon_state = "mic"
	desc = "A microphone, for speaking in."
	var/max_font = 8
	var/font_amp = 4
	var/on = 1
	var/font_color = "black"

/obj/item/device/microphone/examine()
	..()
	. += "It's currently [src.on ? "on" : "off"]."

/obj/item/device/microphone/verb/toggle_microphone()
	set name = "Toggle Microphone"
	set category = "Object"

	src.on = !(src.on)
	usr << "You switch [src] [src.on ? "on" : "off"]."
	if (src.on && prob(50))
		if (locate(/obj/loudspeaker) in range(2, usr))
			for (var/obj/loudspeaker/S in range(7, usr))
				S.visible_message("<span style=\"color:red\">[S] lets out a horrible [pick("shriek", "squeal", "noise", "squawk", "screech", "whine", "squeak")]!</span>")
				playsound(S.loc, 'sound/items/mic_feedback.ogg', 30, 1)

/obj/item/device/microphone/attack_self(mob/M as mob, msg)
	if (!src.on)
		return
	if (usr.client)
		if(usr.client.prefs.muted & MUTE_IC)
			src << "<span class='warning'>You cannot speak in IC (muted).</span>"
			return
	if(!ishuman(usr))
		usr << "<span class='warning'>You don't know how to use this!</span>"
		return
	var/turf/T = get_turf(src)
	if (M in range(1, T))
		msg = sanitize(input(usr, "What is your message?", "Microphone", null)  as message)
		if(!msg)
			return
		msg = capitalize(msg)

	var/speakers = 0
	for (var/obj/loudspeaker/S in range(7, T))
		speakers ++
	if (!speakers)
		usr << "<span class='warning'>You realise that there's no loudspeaker nearby for this to project to.</span>"
		return

	M.visible_message("<font size=3><b>[M]</b> says, <span style=\"color:[font_color]\">''[msg]''</font></span>")
	log_say("(MICROPHONE SAY) [msg]", M)

	if (prob(10) && locate(/obj/loudspeaker) in range(2, T))
		for (var/obj/loudspeaker/S in range(7, T))
			S.visible_message("<span style=\"color:red\">[S] lets out a horrible [pick("shriek", "squeal", "noise", "squawk", "screech", "whine", "squeak")]!</span>")
			playsound(S.loc, 'sound/items/mic_feedback.ogg', 30, 1)


/obj/item/device/mic_stand
	name = "microphone stand"
	icon = 'icons/obj/radio.dmi'
	icon_state = "micstand"
	desc = "A stand that typically holds a mic in it."
//	mats = 10
	var/obj/item/device/microphone/myMic = null
	var/mic_type = /obj/item/device/microphone

/obj/item/device/mic_stand/New()
	spawn(1)
		if (!myMic)
			myMic = new mic_type(src)
	return ..()

/obj/item/device/mic_stand/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/device/microphone))
		if (myMic)
			user << "<span class='warning'>There's already a microphone on [src]!</span>"
			return
		user << "You place the [W] on [src]."
		myMic = W
		user.drop_from_inventory(W, src)
		W.forceMove(src)
//		user.update_inv_l_hand(0)
//		user.update_inv_r_hand()
		src.update_icon()
	else
		return ..()

/obj/item/device/mic_stand/attack_hand(mob/living/user)
	if (!myMic)
		user << "<span class='warning'>There's no microphone on [src]!</span>"
		return ..()
	playsound(loc, 'sound/items/mic_feedback.ogg', 30, 1)

	user.put_in_hands(myMic)
	myMic = null
	update_icon()

	return ..()

/obj/item/device/mic_stand/update_icon()
	if (myMic)
		src.icon_state = "micstand"
	else
		src.icon_state = "micstand-empty"

/obj/loudspeaker
	name = "loudspeaker"
	icon = 'icons/obj/radio.dmi'
	icon_state = "loudspeaker"
	anchored = 1
	density = 1
//	mats = 15


/obj/item/device/microphone/prosecutor
	name = "prosecutor's mic"
	font_color = "red"

/obj/item/device/microphone/defense
	name = "defense attorney's mic"
	font_color = "blue"

/obj/item/device/microphone/judge
	name = "judge's mic"
	font_color = "purple"

/obj/item/device/mic_stand/prosecutor
	mic_type = /obj/item/device/microphone/prosecutor


/obj/item/device/mic_stand/defense
	mic_type = /obj/item/device/microphone/defense


/obj/item/device/mic_stand/judge
	mic_type = /obj/item/device/microphone/judge