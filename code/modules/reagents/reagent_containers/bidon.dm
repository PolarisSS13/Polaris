
//this is big movable beaker
/obj/structure/reagent_dispensers/bidon
	name = "B.I.D.O.N. canister"
	desc = "Blue-Ink Dispenser Omnitech-Nanochem. A canister with acid-resistant linings intended for handling big volumes of chemicals."
	icon = 'icons/obj/machines/chemistry.dmi'
	icon_state = "bidon"
	amount_per_transfer_from_this = 30
	possible_transfer_amounts = list(10,30,60,120,200,300)
	var/filling_states = list(10,20,30,40,50,60,70,80,100)
	unacidable = 1
	anchored = 0
	var/obj/machinery/anchored_machine
	density = TRUE
	volume = 6000
	var/lid = TRUE
	var/starting_reagent
	var/starting_volume = 0
	has_hose=FALSE
	atom_flags = EMPTY_BITFIELD

/obj/structure/reagent_dispensers/bidon/Initialize()
	. = ..()
	if(starting_reagent && starting_volume)
		reagents.add_reagent(starting_reagent, starting_volume)

/obj/structure/reagent_dispensers/bidon/advanced
	name = "stasis B.I.D.O.N. canister"
	desc = "An advanced B.I.D.O.N. canister with stasis function."
	icon_state = "bidon_adv"
	atom_flags = ATOM_REAGENTS_SKIP_REACTIONS // It's a stasis BIDON, shouldn't allow chems to react inside it.
	filling_states = list(20,40,60,80,100)
	volume = 9000

/obj/structure/reagent_dispensers/bidon/trigger
	name = "trigger-stasis B.I.D.O.N. canister"
	desc = "An advanced B.I.D.O.N. canister with a stasis function that can be temporarily disabled with a multitool."
	icon_state = "bidon_adv"
	atom_flags = ATOM_REAGENTS_SKIP_REACTIONS //Tho its not a subtype its meant to be
	filling_states = list(20,40,60,80,100)
	volume = 9000
	var/timer_till_mixing = 120
	var/timing = FALSE

/obj/structure/reagent_dispensers/bidon/trigger/examine(mob/user)
	. = ..()
	if(timing)
		to_chat(user, SPAN_DANGER("[timer_till_mixing] seconds until stasis is disabled."))
	else
		to_chat(user, SPAN_NOTICE("[src]'s timer isn't activated."))

/obj/structure/reagent_dispensers/bidon/trigger/attackby(obj/item/I, mob/user)
	if(!timing)
		if(I.is_multitool())
			timing=TRUE
			to_chat(user, SPAN_NOTICE("You start the timer."))
			spawn(10 * timer_till_mixing)
			timer_end()
			timing=FALSE
			return
	else
		. = ..()
	update_icon()

/obj/structure/reagent_dispensers/bidon/trigger/proc/timer_end()
	atom_flags &= ~(ATOM_REAGENTS_SKIP_REACTIONS)
	spawn(10)
	atom_flags |= ATOM_REAGENTS_SKIP_REACTIONS
	reagents.handle_reactions()

/obj/structure/reagent_dispensers/bidon/Initialize(mapload, ...)
	. = ..()
	update_icon()

/obj/structure/reagent_dispensers/bidon/examine(mob/user)
	. = ..()
	if(get_dist(user, src) <= 2)
		if(lid)
			to_chat(user, SPAN_NOTICE("It has lid on it."))
		if(reagents.total_volume)
			to_chat(user, SPAN_NOTICE("It's filled with [reagents.total_volume]/[volume] units of reagents."))

/obj/structure/reagent_dispensers/bidon/attack_hand(mob/user as mob)
	//Prevent the bidon from being messed with while it is anchored.
	if(anchored)
		to_chat(user, SPAN_NOTICE("You can't remove the lid while the canister is anchored!"))
		return
	lid = !lid
	if(lid)
		to_chat(user, SPAN_NOTICE("You put the lid on."))
		atom_flags &= ~(ATOM_REAGENTS_IS_OPEN)
	else
		atom_flags |= ATOM_REAGENTS_IS_OPEN
		to_chat(user, SPAN_NOTICE("You removed the lid."))
	playsound(src,'sound/items/trayhit2.ogg',50,1)
	update_icon()

/obj/structure/reagent_dispensers/bidon/attackby(obj/item/I, mob/user)

	//Handle attaching the BIDON to a valid machine, should one exist
	if(I.is_wrench())
		if(anchored)
			anchored = FALSE
			anchored_machine = null
			playsound(src, I.usesound, 50, 1)
		else
			var/list/directions = list(WEST, NORTH, SOUTH, EAST)
			for(var/direction_from_obj in directions)
				for (var/obj/machinery/valid_machine in get_step(get_turf(src), direction_from_obj))
					if(ispath(valid_machine.anchor_type) && istype(src, valid_machine.anchor_type))
						if(valid_machine.anchor_direction)
							if(valid_machine.anchor_direction == reverse_direction(direction_from_obj))
								anchored_machine = valid_machine
								break
						else
							anchored_machine = valid_machine
							break
			if(anchored_machine)
				to_chat(user, SPAN_NOTICE("You [anchored ? "detach" : "attach"] the B.I.D.O.N canister to the [anchored_machine]."))
				anchored = TRUE
				playsound(src, I.usesound, 50, 1)
				//Remove the lid if it is currently sealed, so we don't have to deal with checking for it
				if(lid)
					to_chat(user, SPAN_NOTICE("The machine removes the lid automatically!"))
					lid = FALSE
					atom_flags |= ATOM_REAGENTS_IS_OPEN
					playsound(src,'sound/items/trayhit2.ogg',50,1)
				update_icon()
				return
	else if(lid)
		to_chat(user, SPAN_NOTICE("Remove the lid first."))
		return
	. = ..()
	update_icon()

/obj/structure/reagent_dispensers/bidon/update_icon()
	cut_overlays()
	if(lid)
		var/mutable_appearance/lid_icon = mutable_appearance(icon, "[icon_state]_lid")
		add_overlay(lid_icon)
	if(anchored)
		var/mutable_appearance/anchor_icon = mutable_appearance(icon, "bidon_anchored")
		add_overlay(anchor_icon)
	if(reagents.total_volume)
		var/mutable_appearance/filling = mutable_appearance('icons/obj/reagentfillings.dmi', "[icon_state][get_filling_state()]")
		if(!istype(src,/obj/structure/reagent_dispensers/bidon/advanced))
			filling.color = reagents.get_color()
		add_overlay(filling)

/obj/structure/reagent_dispensers/bidon/proc/get_filling_state()
	var/percent = round((reagents.total_volume / volume) * 100)
	for(var/increment in filling_states)
		if(increment >= percent)
			return increment

/obj/structure/reagent_dispensers/bidon/advanced/examine(mob/user)
	if(!..(user, 2))
		return
	if(reagents.reagent_list.len)
		for(var/I in reagents.reagent_list)
			var/datum/reagent/R = I
			to_chat(user, "<span class='notice'>[R.volume] units of [R.name]</span>")

//Preset Bidon of Animal Protein for testing
/obj/structure/reagent_dispensers/bidon/protein_can
	starting_reagent = "protein"


//Department starting protein to get the process off the ground
/obj/structure/reagent_dispensers/bidon/protein_can/si
	starting_reagent = "protein"
	starting_volume = 1000
