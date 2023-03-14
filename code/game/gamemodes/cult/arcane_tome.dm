/// Arcane tomes are the quintessential cultist "tool" and are used to draw runes, smack things with, and other such things.
/// The interface they open (ArcaneTome.js) also contains a lot of in-game documentation about how the antagonist works.
/obj/item/arcane_tome
	name = "arcane tome"
	desc = "An old, dusty tome with frayed edges and a sinister-looking cover."
	icon = 'icons/obj/weapons.dmi'
	item_icons = list(
		icon_l_hand = 'icons/mob/items/lefthand_books.dmi',
		icon_r_hand = 'icons/mob/items/righthand_books.dmi',
	)
	icon_state = "tome"
	item_state = "tome"
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_SMALL
	drop_sound = 'sound/items/drop/book.ogg'
	pickup_sound = 'sound/items/pickup/book.ogg'
	/// How long it takes to draw a rune using this tome. Non-positive values are instant.
	var/scribe_speed = 5 SECONDS

/obj/item/arcane_tome/get_examine_desc()
	if (iscultist(usr) || isobserver(usr))
		return "The scriptures of Nar-Sie, The One Who Sees, The Geometer of Blood. Contains the details of every ritual its followers could think of."
	else
		return desc

/obj/item/arcane_tome/attack_self(mob/user)
	if (!iscultist(user))
		to_chat(user, "The book is full of illegible scribbles and crudely-drawn shapes. Is this a joke...?")
	tgui_interact(user)

/obj/item/arcane_tome/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	if (!iscultist(user))
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "ArcaneTome", name)
		ui.open()
		playsound(user, 'sound/bureaucracy/bookopen.ogg', 25, TRUE)

/obj/item/arcane_tome/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = list()

	var/list/rune_data = list()
	for (var/V in subtypesof(/obj/effect/rune))
		var/obj/effect/rune/NR = V
		if (!initial(NR.can_write))
			continue
		var/obj/item/paper/talisman/T = initial(NR.talisman_path)
		rune_data += list(list(
			"name" = initial(NR.rune_name),
			"invokers" = initial(NR.required_invokers),
			"talisman" = T ? initial(T.tome_desc) : null,
			"shorthand" = initial(NR.rune_shorthand) ? initial(NR.rune_shorthand) : initial(NR.rune_desc),
			"typepath" = NR
		))
	data["runes"] = rune_data

	return data

/obj/item/arcane_tome/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if (..())
		return TRUE
	switch (action)
		if ("turnPage")
			playsound(src, "pageturn", 25, TRUE)
		if ("writeRune")
			var/obj/effect/rune/R = text2path(params["runePath"])
			if (!ispath(R, /obj/effect/rune))
				return
			scribe_rune(usr, R)
			return

/obj/item/arcane_tome/attack(mob/living/M, mob/living/user, target_zone, attack_modifier)
	// This is basically a reimplementation of weapon logic for cultists only
	// It is far from ideal, but it's what we got. Having it always do damage but only letting cultists attack with it
	// would mean that it could be used to smash lights and windows etc, and we only want it to work on living things
	if (iscultist(user) && !iscultist(M) && user.a_intent == I_HURT)
		user.break_cloak()
		user.setClickCooldown(user.get_attack_speed(src))
		user.do_attack_animation(M)
		var/hit_zone = M.resolve_item_attack(src, user, target_zone)
		if (hit_zone)
			M.interact_message(user,
				SPAN_DANGER("\The [user] bathes \the [M] in red light from \the [src]!"),
				SPAN_DANGER("\The [user] bathes you in burning red light from \the [src]!"),
				SPAN_DANGER("You burn \the [M] with \the [src]!")
			)
			playsound(src, 'sound/weapons/sear.ogg', 50, TRUE, -1)
			M.apply_damage(rand(5, 20), BURN, hit_zone, used_weapon = "internal burns")
		return
	. = ..()

/// Causes `user` to attempt to create a rune of type `rune_type`, using their blood (or equivalent) as the medium.
/// Inflicts a small amount of damage to the hands and creates blood decals in the process that remain if interrupted.
/obj/item/arcane_tome/proc/scribe_rune(mob/living/user, obj/effect/rune_type)
	if (locate(/obj/effect/rune) in get_turf(user))
		to_chat(user, SPAN_WARNING("You can only fit one rune on any given space."))
		return
	var/datum/gender/G = gender_datums[user.get_visible_gender()]
	var/blood_name = "blood"
	var/synth = user.isSynthetic()
	if (ishuman(user))
		var/mob/living/carbon/human/H = user
		blood_name = H.species?.get_blood_name()
	user.apply_damage(1, BRUTE, pick(BP_L_HAND, BP_R_HAND), sharp = TRUE, edge = TRUE, used_weapon = "long, precise cut")
	user.visible_message(
		SPAN_WARNING("\The [user] [!synth ? "slices open [G.his] skin" : "tears open [G.his] circulation"] and begins painting on symbols on the floor with [G.his] own [blood_name]!"),
		SPAN_NOTICE("You [!synth ? "slice open your skin" : "tear open your circulation"] and begin drawing a rune on the floor whilst invoking the ritual that binds your life essence with the dark arcane energies flowing through the surrounding world."),
		SPAN_WARNING("You hear droplets softly splattering on the ground."),
		range = 3
	)
	if (ishuman(user))
		var/mob/living/carbon/human/H = user
		for (var/i in 1 to 4)
			spawn (max(0, scribe_speed - 1 SECOND) / i)
				H.drip(1)
	if (!do_after(user, max(0, scribe_speed)))
		return
	if (locate(/obj/effect/rune) in get_turf(user))
		to_chat(user, SPAN_WARNING("You can only fit one rune on any given space."))
		return
	for (var/obj/effect/decal/cleanable/blood/B in get_turf(user))
		qdel(B)
	user.visible_message(
		SPAN_WARNING("\The [user] paints arcane markings with [G.his] own [blood_name]!"),
		SPAN_NOTICE("You finish drawing the arcane markings of the Geometer."),
		range = 3
	)
	var/obj/effect/rune/NR = new rune_type (get_turf(user))
	NR.after_scribe(user)

/obj/item/arcane_tome/admin
	scribe_speed = 0 // Instant
