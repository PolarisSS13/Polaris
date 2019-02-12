
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

/obj/item/device/microphone/attack_self(mob/user as mob)
	src.on = !(src.on)
	user << "You switch [src] [src.on ? "on" : "off"]."
	if (src.on && prob(5))
		if (locate(/obj/loudspeaker) in range(2, user))
			for (var/obj/loudspeaker/S in range(7, user))
				S.visible_message("<span style=\"color:red\">[S] lets out a horrible [pick("shriek", "squeal", "noise", "squawk", "screech", "whine", "squeak")]!</span>")
				playsound(S.loc, 'sound/items/mic_feedback.ogg', 30, 1)

/obj/item/device/microphone/hear_talk(mob/M as mob, msg, real_name, lang_id)
	if (!src.on)
		return
	var/turf/T = get_turf(src)
	if (M in range(1, T))
		src.talk_into(M, msg, null, real_name, lang_id)

/obj/item/device/microphone/talk_into(mob/M as mob, messages, param, real_name, lang_id)
	if (!src.on)
		return
	var/speakers = 0
	var/turf/T = get_turf(src)
	for (var/obj/loudspeaker/S in range(7, T))
		speakers ++
	if (!speakers)
		return
	speakers += font_amp // 2 ain't huge so let's give ourselves a little boost
//	var/stuff = M.say_quote(messages[1])
//	var/stuff_b = M.say_quote(messages[2])
	var/list/mobs_messaged = list()
	for (var/obj/loudspeaker/S in range(7, T))
		for (var/mob/H in hearers(S, null))
			if (H in mobs_messaged)
				continue
//			var/U = H.say_understands(M, lang_id)
			H.visible_message("<span style=\"color:[font_color]\"><font size=[min(src.max_font, max(0, speakers - round(get_dist(H, S) / 2), 1))]><b>[M]</b> broadcasts, ''[messages]''</font></span>")
			mobs_messaged += H
	if (prob(10) && locate(/obj/loudspeaker) in range(2, T))
		for (var/obj/loudspeaker/S in range(7, T))
			S.visible_message("<span style=\"color:red\">[S] lets out a horrible [pick("shriek", "squeal", "noise", "squawk", "screech", "whine", "squeak")]!</span>")
			playsound(S.loc, 'sound/items/mic_feedback.ogg', 30, 1)

/obj/mic_stand
	name = "microphone stand"
	icon = 'icons/obj/radio.dmi'
	icon_state = "micstand"
	desc = "A stand that typically holds a mic in it."
//	mats = 10
	var/obj/item/device/microphone/myMic = null

/obj/mic_stand/New()
	spawn(1)
		if (!myMic)
			myMic = new(src)
	return ..()

/obj/mic_stand/attack_hand(mob/user as mob)
	if (!myMic)
		return ..()
	user.put_in_hands(myMic)
	myMic = null
	src.update_icon()
	return ..()

/obj/mic_stand/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/device/microphone))
		if (myMic)
			user << "/red There's already a microphone on [src]!"
			return
		user << "/blue You place the [W] on [src]."
		myMic = W
//		user.u_equip(W)
		W.forceMove(src)
		src.update_icon()
	else
		return ..()

/obj/mic_stand/hear_talk(mob/M as mob, msg, real_name)
	if (!myMic || !myMic.on)
		return
	var/turf/T = get_turf(src)
	if (M in range(1, T))
		myMic.talk_into(M, msg)

/obj/mic_stand/update_icon()
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

/obj/mic_stand/prosecutor/New()
	spawn(1)
		if (!myMic)
			myMic = /obj/item/device/microphone/prosecutor(src)
	return ..()

/obj/mic_stand/defense/New()
	spawn(1)
		if (!myMic)
			myMic = /obj/item/device/microphone/defense(src)
	return ..()

/obj/mic_stand/judge/New()
	spawn(1)
		if (!myMic)
			myMic = /obj/item/device/microphone/judge(src)
	return ..()