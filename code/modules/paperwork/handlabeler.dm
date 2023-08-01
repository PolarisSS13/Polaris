/obj/item/hand_labeler
	name = "hand labeler"
	desc = "Label everything like you've always wanted to! Stuck to the side is a label reading \'Labeler\'. Seems you're too late for that one."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "labeler0"
	var/label = null
	var/labels_left = 30
	var/mode = 0	//off or on.
	drop_sound = 'sound/items/drop/device.ogg'
	pickup_sound = 'sound/items/pickup/device.ogg'

/obj/item/hand_labeler/attack()
	return

/obj/item/hand_labeler/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity)
		return
	if(!mode)	//if it's off, give up.
		return
	if(A == loc)	// if placing the labeller into something (e.g. backpack)
		return		// don't set a label

	if(!labels_left)
		to_chat(user, SPAN_WARNING("\The [src] has no labels left."))
		return
	if(!label || !length(label))
		to_chat(user, SPAN_WARNING("\The [src] has no label text set."))
		return
	if(length(A.name) + length(label) > 64)
		to_chat(user, SPAN_WARNING("\The [src]'s label too big."))
		return
	if(ishuman(A))
		to_chat(user, SPAN_WARNING("The label refuses to stick to [A.name]."))
		return
	if(issilicon(A))
		to_chat(user, SPAN_WARNING("The label refuses to stick to [A.name]."))
		return
	if(isobserver(A))
		to_chat(user, SPAN_WARNING("[src] passes through [A.name]."))
		return
	if(istype(A, /obj/item/reagent_containers/glass))
		to_chat(user, SPAN_WARNING("The label can't stick to the [A.name] (Try using a pen)."))
		return
	if(istype(A, /obj/machinery/portable_atmospherics/hydroponics))
		var/obj/machinery/portable_atmospherics/hydroponics/tray = A
		if(!tray.mechanical)
			to_chat(user, SPAN_WARNING("How are you going to label that?"))
			return
		tray.labelled = label
		spawn(1)
			tray.update_icon()

	user.visible_message( \
		SPAN_NOTICE("\The [user] labels [A] as [label]."), \
		SPAN_NOTICE("You label [A] as [label]."))
	A.name = "[A.name] ([label])"

/obj/item/hand_labeler/attack_self(mob/user as mob)
	mode = !mode
	icon_state = "labeler[mode]"
	if(mode)
		to_chat(user, SPAN_NOTICE("You turn on \the [src]."))
		//Now let them choose the text.
		var/str = html_decode(sanitizeSafe(input(user,"Label text?","Set label",""), MAX_NAME_LEN))
		if(!str || !length(str))
			to_chat(user, SPAN_WARNING("Invalid text."))
			return
		label = str
		to_chat(user, SPAN_NOTICE("You set the text to '[str]'."))
	else
		to_chat(user, SPAN_NOTICE("You turn off \the [src]."))
