/obj/structure/reagent_dispensers/bidon
	name = "bidon canister"
	desc = "A canister for handling large volumes of chemicals."
	icon = 'icons/obj/structures/bidon.dmi'
	icon_state = "bidon"
	possible_transfer_amounts = list(10, 30, 60, 120, 200, 300)
	unacidable = TRUE
	has_hose = FALSE
	var/use_reagent_color = TRUE
	var/fill_step = 10


/obj/structure/reagent_dispensers/bidon/Initialize()
	. = ..()
	update_icon()


/obj/structure/reagent_dispensers/bidon/update_icon()
	cut_overlays()
	if (!is_open_container())
		add_overlay("[icon_state]_lid")
	var/fill_state = ceil(round(reagents.total_volume / volume * 100, fill_step), 0, 100)
	if (!fill_state)
		return
	if (use_reagent_color)
		var/image/image = image(icon, icon_state = "[icon_state][fill_state]")
		image.color = reagents.get_color()
		add_overlay(image)
	else
		add_overlay("[icon_state][fill_state]")


/obj/structure/reagent_dispensers/bidon/examine(mob/user, distance, infix, suffix)
	. = ..()
	if (distance > 5)
		return
	. += "The lid is [is_open_container() ? "off" : "on"]."
	if (distance < 3)
		. += "It holds [round(reagents.total_volume, 0.1)]/[volume] units of reagents."


/obj/structure/reagent_dispensers/bidon/attack_hand(mob/living/user)
	playsound(src, 'sound/items/trayhit2.ogg', 50, TRUE)
	atom_flags ^= ATOM_REAGENTS_IS_OPEN
	if (is_open_container())
		to_chat(user, SPAN_ITALIC("You open the lid of \the [src]."))
	else
		to_chat(user, SPAN_ITALIC("You close the lid of \the [src]."))
	update_icon()


/obj/structure/reagent_dispensers/bidon/attackby(obj/item/item, mob/living/user)
	if (!is_open_container() && istype(item, /obj/item/reagent_containers))
		to_chat(user, SPAN_WARNING("Remove the lid first."))
		return TRUE
	return ..()


/obj/structure/reagent_dispensers/bidon/stasis
	name = "stasis bidon canister"
	desc = "A canister for handling large volumes of chemicals. This one has a stasis field."
	icon_state = "bidon_stasis"
	atom_flags = ATOM_REAGENTS_SKIP_REACTIONS
	use_reagent_color = FALSE
	fill_step = 20
	var/timer_seconds
	var/timer_handle


/obj/structure/reagent_dispensers/bidon/stasis/update_icon()
	..()
	if (timer_handle)
		add_overlay("timer_active")
	else if (timer_seconds)
		add_overlay("timer_idle")


/obj/structure/reagent_dispensers/bidon/stasis/examine(mob/user, distance, infix, suffix)
	. = ..()
	if (distance > 5 || !timer_seconds)
		return
	var/timer_display = "a timer"
	if (timer_handle)
		timer_display = "an active timer"
	if (distance > 3)
		. += "It has [timer_display] attached."
	else
		. += "It has [timer_display] attached set for [timer_seconds] seconds."


/obj/structure/reagent_dispensers/bidon/stasis/attackby(obj/item/item, mob/living/user)
	if (istype(item, /obj/item/assembly/timer))
		if (timer_seconds)
			to_chat(user, SPAN_WARNING("\The [src] already has a timer attached."))
		else if (user.unEquip(item))
			var/obj/item/assembly/timer/timer = item
			timer_seconds = timer.time
			qdel(item)
			playsound(src, 'sound/items/Screwdriver.ogg', 50, TRUE)
			user.visible_message(
				SPAN_ITALIC("\The [user] attaches \a [item] to \a [src]."),
				SPAN_ITALIC("You attach \the [item] to \the [src]."),
				SPAN_ITALIC("You hear metal clicking together."),
				range = 5
			)
		return TRUE
	if (item.is_screwdriver())
		if (!timer_seconds)
			to_chat(user, SPAN_WARNING("\The [src] doesn't have a timer attached."))
		else if (timer_handle)
			to_chat(user, SPAN_WARNING("\The [src]'s timer is active."))
		else
			user.visible_message(
				SPAN_ITALIC("\The [user] removes the timer from \the [src]."),
				SPAN_ITALIC("You remove the timer from \the [src]."),
				SPAN_ITALIC("You hear metal clicking together."),
				range = 5
			)
			playsound(src, item.usesound, 50, TRUE)
			var/obj/item/assembly/timer/timer = new (loc)
			user.put_in_hands(timer)
			timer.time = timer_seconds
			timer_seconds = 0
		return TRUE
	if (item.is_multitool())
		if (!timer_seconds)
			to_chat(user, SPAN_WARNING("\The [src] doesn't have a timer attached."))
			return TRUE
		else if (timer_handle)
			deltimer(timer_handle)
			timer_handle = null
			user.visible_message(
				SPAN_ITALIC("\The [user] disables the timer on \the [src]."),
				SPAN_ITALIC("You disable the timer on \the [src]."),
				SPAN_ITALIC("You hear soft beeping."),
				range = 5
			)
			update_icon()
		else
			timer_handle = addtimer(CALLBACK(src, .proc/timer_end), timer_seconds SECONDS, TIMER_STOPPABLE)
			user.visible_message(
				SPAN_ITALIC("\The [user] activates the timer on \the [src]."),
				SPAN_ITALIC("You activate the timer on \the [src]."),
				SPAN_ITALIC("You hear soft beeping."),
				range = 5
			)
		playsound(src, item.usesound, 50, TRUE)
		update_icon()
		return TRUE
	return ..()


/obj/structure/reagent_dispensers/bidon/stasis/proc/timer_end()
	atom_flags &= ~(ATOM_REAGENTS_SKIP_REACTIONS)
	reagents.handle_reactions()
	atom_flags |= ATOM_REAGENTS_SKIP_REACTIONS
	timer_handle = null
	update_icon()
