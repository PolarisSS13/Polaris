/mob/living/simple_mob/animal/sif/grafadreka/trained
	desc = "A large, sleek snow drake with heavy claws, powerful jaws and many pale spines along its body. This one is wearing some kind of harness; maybe it belongs to someone."
	player_msg = "You are a large Sivian pack predator in symbiosis with the local bioluminescent bacteria. You can eat glowing \
	tree fruit to fuel your <b>ranged spitting attack</b> and <b>poisonous bite</b> (on <span class = 'danger'>harm intent</span>), as well as <b>healing saliva</b> \
	(on <b><font color = '#009900'>help intent</font></b>).<br>Using <font color='#e0a000'>grab intent</font> you can pick up and drop items on by clicking them or yourself, \
	and can interact with some simple machines like buttons and levers.<br>Unlike your wild kin, you are <b>trained</b> and work happily with your two-legged packmates."
	faction = "station"
	ai_holder_type = null // These guys should not exist without players.
	gender = PLURAL // Will take gender from prefs = set to non-NEUTER here to avoid randomizing in Initialize().
	movement_cooldown = 1.5 // ~Red~ trained ones go faster.
	dexterity = MOB_DEXTERITY_SIMPLE_MACHINES
	harness = /obj/item/storage/internal/animal_harness/grafadreka

	/// On clicking with an item, stuff that should use behaviors instead of being placed in storage.
	var/static/list/allow_type_to_pass = list(
		/obj/item/healthanalyzer,
		/obj/item/stack/medical,
		/obj/item/reagent_containers/syringe
	)

	/// A type path -> proc path mapping for objects that drakes can use.
	var/static/list/interactable_objects = list(
		/obj/machinery/button = /mob/living/simple_mob/animal/sif/grafadreka/trained/proc/InteractButtonBasic,
		/obj/machinery/access_button = /mob/living/simple_mob/animal/sif/grafadreka/trained/proc/InteractButtonAccess,
		/obj/machinery/firealarm = /mob/living/simple_mob/animal/sif/grafadreka/trained/proc/InteractFireAlarm,
		/obj/machinery/conveyor_switch = /mob/living/simple_mob/animal/sif/grafadreka/trained/proc/InteractConveyorSwitch
	)


/mob/living/simple_mob/animal/sif/grafadreka/trained/Destroy()
	if (istype(harness))
		QDEL_NULL(harness)
	return ..()


/mob/living/simple_mob/animal/sif/grafadreka/trained/add_glow()
	. = ..()
	if (. && harness)
		var/image/I = .
		I.icon_state = "[I.icon_state]-pannier"


/mob/living/simple_mob/animal/sif/grafadreka/trained/Logout()
	..()
	if (stat != DEAD)
		lying = TRUE
		resting = TRUE
		sitting = FALSE
		Sleeping(2)
		update_icon()


/mob/living/simple_mob/animal/sif/grafadreka/trained/Login()
	..()
	SetSleeping(0)
	update_icon()


/mob/living/simple_mob/animal/sif/grafadreka/trained/attack_hand(mob/living/user)
	// Permit headpats/smacks
	if (!harness || user.a_intent == I_HURT || (user.a_intent == I_HELP && user.zone_sel?.selecting == BP_HEAD))
		return ..()
	return harness.handle_attack_hand(user)


// universal_understand is buggy and produces double lines, so we'll just do this hack instead.
/mob/living/simple_mob/animal/sif/grafadreka/trained/say_understands(mob/other, datum/language/speaking)
	if (!speaking || speaking.name == LANGUAGE_GALCOM)
		return TRUE
	return ..()


/mob/living/simple_mob/animal/sif/grafadreka/trained/update_icon()
	. = ..()
	if (harness)
		var/image/I = image(icon, "[current_icon_state]-pannier")
		I.color = harness.color
		I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE|KEEP_APART)
		if (offset_compiled_icon)
			I.pixel_x = offset_compiled_icon
		add_overlay(I)


/mob/living/simple_mob/animal/sif/grafadreka/trained/attackby(obj/item/item, mob/user)
	if (user.a_intent == I_HURT)
		return ..()
	if (user.a_intent == I_HELP)
		for (var/pass_type in allow_type_to_pass)
			if (istype(item, pass_type))
				return ..()
	if (harness?.attackby(item, user))
		return TRUE
	return ..()


/mob/living/simple_mob/animal/sif/grafadreka/trained/attack_target(atom/atom)
	if (a_intent == I_GRAB)
		if (atom == src)
			return DropItem()
		if (isobj(atom))
			var/interact_outcome = AttemptInteract(atom)
			if (!isnull(interact_outcome))
				return interact_outcome
			if (isitem(atom))
				return CollectItem(atom)
	return ..()


/mob/living/simple_mob/animal/sif/grafadreka/trained/proc/DropItem()
	if (!length(harness?.contents))
		to_chat(src, SPAN_WARNING("You have nothing to drop."))
		return ATTACK_FAILED
	var/obj/item/response = input(src, "Select an item to drop:") as null | anything in harness.contents
	if (!response)
		return ATTACK_FAILED
	var/datum/gender/gender = gender_datums[get_visible_gender()]
	visible_message(
		SPAN_ITALIC("\The [src] begins rooting around in the pouch on [gender.his] harness."),
		SPAN_ITALIC("You begin working \the [response] out of your harness pouch."),
		SPAN_ITALIC("You hear something rustling."),
		runemessage = CHAT_MESSAGE_DEFAULT_ACTION
	)
	if (!do_after(src, 5 SECONDS, ignore_movement = TRUE))
		return ATTACK_FAILED
	harness.remove_from_storage(response, loc)
	visible_message(
		SPAN_ITALIC("\The [src] pulls \a [response] from [gender.his] harness and drops it."),
		SPAN_NOTICE("You pull \the [response] from your harness and drop it."),
		SPAN_WARNING("Clank!"),
		runemessage = CHAT_MESSAGE_DEFAULT_ACTION
	)
	return ATTACK_SUCCESSFUL


/mob/living/simple_mob/animal/sif/grafadreka/trained/proc/CollectItem(obj/item/item)
	if (!item.simulated || item.abstract || !item.Adjacent(src))
		return ATTACK_FAILED
	if (!harness)
		to_chat(src, SPAN_WARNING("Your harness is missing; you cannot store \the [item]."))
		return ATTACK_FAILED
	if (item.anchored)
		to_chat(src, SPAN_WARNING("\The [item] is securely anchored; you can't take it."))
		return ATTACK_FAILED
	face_atom(item)
	if (!do_after(src, 5 SECONDS, item))
		return ATTACK_FAILED
	var/datum/gender/gender = gender_datums[get_visible_gender()]
	if (harness?.attackby(item, src, TRUE))
		visible_message(
			SPAN_ITALIC("\The [src] grabs \a [item] in [gender.his] teeth and noses it into [gender.his] harness pouch."),
			SPAN_NOTICE("You grab \the [item] in your teeth and push it into your harness pouch."),
			SPAN_ITALIC("You hear something rustling."),
			runemessage = CHAT_MESSAGE_DEFAULT_ACTION
		)
		return ATTACK_SUCCESSFUL
	to_chat(src, SPAN_WARNING("There's not enough space in your harness pouch for \the [item] to fit!"))
	return ATTACK_FAILED


/mob/living/simple_mob/animal/sif/grafadreka/trained/proc/AttemptInteract(obj/obj)
	if (!obj.Adjacent(src))
		return
	var/handler
	for (var/type in interactable_objects)
		if (ispath(obj.type, type))
			handler = interactable_objects[type]
			break
	if (!handler)
		return
	return call(src, handler)(obj)


/mob/living/simple_mob/animal/sif/grafadreka/trained/proc/InteractButtonBasic(obj/machinery/button/button)
	var/datum/gender/gender = gender_datums[get_visible_gender()]
	visible_message(
		SPAN_ITALIC("\The [src] stands up awkwardly on [gender.his] hind legs and paws at \a [button]."),
		SPAN_ITALIC("You rear up, attempting to push \the [button] with your foreclaws."),
		SPAN_WARNING("You hear something scratching and scrabbling."),
		runemessage = CHAT_MESSAGE_DEFAULT_ACTION
	)
	if (!do_after(src, 5 SECONDS, button))
		return ATTACK_FAILED
	to_chat(src, SPAN_NOTICE("After some effort, you manage to push \the [button]."))
	button.attack_hand(src)
	return ATTACK_SUCCESSFUL


/mob/living/simple_mob/animal/sif/grafadreka/trained/proc/InteractButtonAccess(obj/machinery/access_button/button)
	var/datum/gender/gender = gender_datums[get_visible_gender()]
	visible_message(
		SPAN_ITALIC("\The [src] stands up awkwardly on [gender.his] hind legs and paws at \a [button]."),
		SPAN_ITALIC("You rear up, attempting to push \the [button] with your foreclaws."),
		SPAN_WARNING("You hear something scratching and scrabbling."),
		runemessage = CHAT_MESSAGE_DEFAULT_ACTION
	)
	if (!do_after(src, 5 SECONDS, button))
		return ATTACK_FAILED
	to_chat(src, SPAN_NOTICE("After some effort, you manage to push \the [button]."))
	button.attack_hand(src)
	return ATTACK_SUCCESSFUL


/mob/living/simple_mob/animal/sif/grafadreka/trained/proc/InteractFireAlarm(obj/machinery/firealarm/alarm)
	var/datum/gender/gender = gender_datums[get_visible_gender()]
	visible_message(
		SPAN_ITALIC("\The [src] stands up awkwardly on [gender.his] hind legs and paws at \a [alarm]."),
		SPAN_ITALIC("You rear up, attempting to push \the [alarm] with your foreclaws."),
		SPAN_WARNING("You hear something scratching and scrabbling."),
		runemessage = CHAT_MESSAGE_DEFAULT_ACTION
	)
	if (!do_after(src, 5 SECONDS, alarm))
		return ATTACK_FAILED
	to_chat(src, SPAN_NOTICE("After some effort, you manage to push \the [alarm]."))
	alarm.attack_hand(src)
	return ATTACK_SUCCESSFUL


/mob/living/simple_mob/animal/sif/grafadreka/trained/proc/InteractConveyorSwitch(obj/machinery/conveyor_switch/lever)
	visible_message(
		SPAN_ITALIC("\The [src] pushes bodily against \a [lever]."),
		SPAN_ITALIC("You press your shoulder into \the [lever], trying to change its direction."),
		runemessage = CHAT_MESSAGE_DEFAULT_ACTION
	)
	if (!do_after(src, 2 SECONDS, lever))
		return ATTACK_FAILED
	to_chat(src, SPAN_NOTICE("After some effort, you manage to push \the [lever]."))
	lever.attack_hand(src)
	return ATTACK_SUCCESSFUL
