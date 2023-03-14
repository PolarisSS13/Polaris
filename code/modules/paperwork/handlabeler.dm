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

	if(has_extension(A, /datum/extension/labels))
		var/datum/extension/labels/L = get_extension(A, /datum/extension/labels)
		if(!L.CanAttachLabel(user, label))
			return
	A.attach_label(user, src, label)

/atom/proc/attach_label(var/user, var/atom/labeler, var/label_text)
	to_chat(user, "<span class='notice'>The label refuses to stick to [name].</span>")

/mob/observer/attach_label(var/user, var/atom/labeler, var/label_text)
	to_chat(user, "<span class='notice'>\The [labeler] passes through \the [src].</span>")

/obj/machinery/portable_atmospherics/hydroponics/attach_label(var/user, var/atom/labeler, var/label_text)
	if(!mechanical)
		to_chat(user, "<span class='notice'>How are you going to label that?</span>")
		return
	..()
	update_icon()

/obj/attach_label(var/user, var/atom/labeler, var/label_text)
	if(!simulated)
		return
	var/datum/extension/labels/L = get_or_create_extension(src, /datum/extension/labels)
	return L.AttachLabel(user, label_text)

/mob/living/silicon/robot/platform/attach_label(var/user, var/atom/labeler, var/label_text)
	if(!allowed(user))
		to_chat(usr, SPAN_WARNING("Access denied."))
	else if(client || key)
		to_chat(user, SPAN_NOTICE("You rename \the [src] to [label_text]."))
		to_chat(src, SPAN_NOTICE("\The [user] renames you to [label_text]."))
		SetName(label_text)
	else
		to_chat(user, SPAN_WARNING("\The [src] is inactive and cannot be renamed."))

/obj/item/reagent_containers/glass/attach_label(var/user, var/atom/labeler, var/label_text)
	to_chat(user, SPAN_WARNING("The label can't stick to the [name] (Try using a pen)."))
	return

/obj/machinery/portable_atmospherics/hydroponics/attach_label(var/user, var/atom/labeler, var/label_text)
	if(!mechanical)
		to_chat(user, SPAN_WARNING("How are you going to label that?"))
		return
	..()
	spawn(1)
		update_icon()

/obj/item/hand_labeler/attack_self(mob/user as mob)
	mode = !mode
	icon_state = "labeler[mode]"
	if(mode)
		to_chat(user, SPAN_NOTICE("You turn on \the [src]."))
		//Now let them chose the text.
		var/str = sanitizeSafe(input(user,"Label text?","Set label",""), MAX_NAME_LEN)
		if(!str || !length(str))
			to_chat(user, SPAN_WARNING("Invalid text."))
			return
		label = str
		to_chat(user, SPAN_NOTICE("You set the text to '[str]'."))
	else
		to_chat(user, SPAN_NOTICE("You turn off \the [src]."))
