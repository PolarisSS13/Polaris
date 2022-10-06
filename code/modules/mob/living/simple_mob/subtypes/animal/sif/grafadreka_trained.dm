/mob/living/simple_mob/animal/sif/grafadreka/trained
	desc = "A large, sleek snow drake with heavy claws, powerful jaws and many pale spines along its body. This one is wearing some kind of harness; maybe it belongs to someone."
	player_msg = "You are a large Sivian pack predator in symbiosis with the local bioluminescent bacteria. You can eat glowing \
	tree fruit to fuel your <b>ranged spitting attack</b> and <b>poisonous bite</b> (on <span class = 'danger'>harm intent</span>), as well as <b>healing saliva</b> \
	(on <b><font color = '#009900'>help intent</font></b>).<br>Using <font color='#e0a000'>grab intent</font> you can pick up and drop items on by clicking them or yourself, and can interact with some simple machines like buttons.<br>Unlike your wild kin, you are <b>trained</b> and work happily with your two-legged packmates."
	faction = "station"
	ai_holder_type = null // These guys should not exist without players.
	gender = PLURAL // Will take gender from prefs = set to non-NEUTER here to avoid randomizing in Initialize().
	movement_cooldown = 1.5 // ~Red~ trained ones go faster.

	/// If a valid harness path, the harness this drake will be wearing on Initialize.
	var/obj/item/storage/internal/animal_harness/harness = /obj/item/storage/internal/animal_harness

	/// On clicking with an item, stuff that should use behaviors instead of being placed in storage.
	var/list/allow_type_to_pass = list(
		/obj/item/healthanalyzer,
		/obj/item/stack/medical,
		/obj/item/reagent_containers/syringe
	)

	/// A type path -> proc path mapping for objects that drakes can use.
	var/list/interactable_objects = list(
		/obj/machinery/button = /mob/living/simple_mob/animal/sif/grafadreka/trained/proc/ButtonBasic,
		/obj/machinery/access_button = /mob/living/simple_mob/animal/sif/grafadreka/trained/proc/ButtonAccess
	)


/mob/living/simple_mob/animal/sif/grafadreka/trained/Destroy()
	if (istype(harness))
		QDEL_NULL(harness)
	return ..()


/mob/living/simple_mob/animal/sif/grafadreka/trained/Initialize()
	. = ..()
	if (ispath(harness, /obj/item/storage/internal/animal_harness))
		harness = new harness(src)
		harness.attached_radio = new /obj/item/radio(src)
		regenerate_harness_verbs()
	else
		if (harness)
			log_error("[type] initialized with an invalid harness [harness]")
		harness = null


/mob/living/simple_mob/animal/sif/grafadreka/trained/examine(mob/living/user)
	. = ..()
	if (harness)
		. += "\The [src] is wearing \a [harness]."
		for (var/obj/item/thing in list(harness.attached_gps, harness.attached_plate, harness.attached_radio))
			. += "There is \a [thing] attached."


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
	// bonk
	if (user.a_intent == I_HURT)
		return ..()
	if (user.a_intent == I_HELP)
		for (var/pass_type in allow_type_to_pass)
			if (istype(item, pass_type))
				return ..()
	// Open our storage, if we have it.
	if (harness?.attackby(item, user))
		regenerate_harness_verbs()
		return TRUE
	return ..()


/mob/living/simple_mob/animal/sif/grafadreka/trained/proc/regenerate_harness_verbs()
	if (!harness)
		verbs -= list(
			/mob/living/simple_mob/animal/sif/grafadreka/trained/proc/remove_attached_gps,
			/mob/living/simple_mob/animal/sif/grafadreka/trained/proc/remove_attached_plate,
			/mob/living/simple_mob/animal/sif/grafadreka/trained/proc/remove_attached_radio
		)
		return
	if (harness.attached_gps)
		verbs |= /mob/living/simple_mob/animal/sif/grafadreka/trained/proc/remove_attached_gps
	else
		verbs -= /mob/living/simple_mob/animal/sif/grafadreka/trained/proc/remove_attached_gps
	if (harness.attached_plate)
		verbs |= /mob/living/simple_mob/animal/sif/grafadreka/trained/proc/remove_attached_plate
	else
		verbs -= /mob/living/simple_mob/animal/sif/grafadreka/trained/proc/remove_attached_plate
	if (harness.attached_radio)
		verbs |= /mob/living/simple_mob/animal/sif/grafadreka/trained/proc/remove_attached_radio
	else
		verbs -= /mob/living/simple_mob/animal/sif/grafadreka/trained/proc/remove_attached_radio


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
	var/list/attached = list(harness.attached_gps, harness.attached_radio, harness.attached_plate)
	var/obj/item/response = input(src, "Select an item to drop:") as null | anything in attached + harness.contents
	if (!response)
		return ATTACK_FAILED
	var/datum/gender/gender = gender_datums[get_visible_gender()]
	var/is_special = (response in attached)
	if (is_special)
		visible_emote("begins tugging at \the [response] on [gender.his] harness.")
	else
		visible_emote("begins rooting around in the pouch on [gender.his] harness.")
	if (!do_after(src, 5 SECONDS, response, ignore_movement = TRUE))
		return ATTACK_FAILED
	if (is_special)
		if (!(response in src))
			to_chat(src, SPAN_WARNING("\The [response] is already gone!"))
			return ATTACK_FAILED
		if (response == harness.attached_gps)
			harness.attached_gps = null
		else if (response == harness.attached_radio)
			harness.attached_radio = null
		else if (response == harness.attached_plate)
			harness.attached_plate = null
		response.dropInto(loc)
		regenerate_harness_verbs()
	else
		harness.remove_from_storage(response, loc)
	visible_emote("removes \a [response] from [gender.his] harness and drops it.")
	return ATTACK_SUCCESSFUL


/mob/living/simple_mob/animal/sif/grafadreka/trained/proc/CollectItem(obj/item/item)
	if (!item.Adjacent(src))
		return ATTACK_FAILED
	if (!harness)
		to_chat(src, SPAN_WARNING("Your harness is missing; you cannot store \the [item]."))
		return ATTACK_FAILED
	face_atom(item)
	if (!do_after(src, 5 SECONDS, item))
		return ATTACK_FAILED
	var/datum/gender/gender = gender_datums[get_visible_gender()]
	if (harness?.attackby(item, src))
		visible_emote("grabs \a [item] in [gender.his] teeth and noses it into [gender.his] pack.")
		return ATTACK_SUCCESSFUL
	visible_emote("grabs \a [item] in [gender.his] teeth and tries to nose it into [gender.his] pack, but there's not enough space!")
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


/mob/living/simple_mob/animal/sif/grafadreka/trained/proc/ButtonBasic(obj/machinery/button/button)
	var/datum/gender/gender = gender_datums[get_visible_gender()]
	visible_emote("stands up awkwardly on [gender.his] hind legs and paws at \a [button].")
	if (!do_after(src, 5 SECONDS, button))
		return ATTACK_FAILED
	to_chat(src, SPAN_NOTICE("After some effort, you manage to push \the [button]."))
	button.attack_hand(src)
	return ATTACK_SUCCESSFUL


/mob/living/simple_mob/animal/sif/grafadreka/trained/proc/ButtonAccess(obj/machinery/access_button/button)
	var/datum/gender/gender = gender_datums[get_visible_gender()]
	visible_emote("stands up awkwardly on [gender.his] hind legs and paws at \a [button].")
	if (!do_after(src, 5 SECONDS, button))
		return ATTACK_FAILED
	to_chat(src, SPAN_NOTICE("After some effort, you manage to push \the [button]."))
	button.attack_hand(src)
	return ATTACK_SUCCESSFUL
