#define TAB_ARCHIVES 1
#define TAB_RUNES 2

/// Arcane tomes are the quintessential cultist "tool" and are used to draw runes, smack things with, and other such things.
/// The interface they open (arcane_tome.tmpl) also contains a lot of in-game documentation about how the antagonist works.
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

	/// Whether or not a rune is already being written with this tome.
	var/scribing = FALSE
	/// How long it takes to draw a rune using this tome. Non-positive values are instant.
	var/scribe_speed = 5 SECONDS
	/// This tome's selected UI tab.
	var/tab = TAB_ARCHIVES
	/// The selected archive entry in the UI.
	var/archive = 0
	/// If TRUE, the rune list in the tome's UI will be displayed in a more concise way.
	var/compact_mode = FALSE

/obj/item/arcane_tome/get_examine_desc()
	if (iscultist(usr) || isobserver(usr))
		return "The scriptures of Nar-Sie, The One Who Sees, The Geometer of Blood. Contains the details of every ritual its followers could think of."
	else
		return desc

/obj/item/arcane_tome/attack_self(mob/user)
	if (!iscultist(user))
		to_chat(user, "The book is full of illegible scribbles and crudely-drawn shapes. Is this a joke...?")
		return
	ui_interact(user)

/obj/item/arcane_tome/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, master_ui, datum/topic_state/state)
	if (!iscultist(user))
		return
	var/list/data = build_ui_data()
	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open = force_open)
	if (!ui)
		archive = 0
		data["archive"] = archive
		ui = new(user, src, ui_key, "arcane_tome.tmpl", "Arcane Tome", 500, 600)
		ui.set_initial_data(data)
		ui.open()
		playsound(user, 'sound/bureaucracy/bookopen.ogg', 25, TRUE)

/obj/item/arcane_tome/proc/build_ui_data()
	var/dat[0]
	var/runes[0]
	for (var/V in subtypesof(/obj/effect/rune))
		var/obj/effect/rune/NR = V
		if (!initial(NR.can_write))
			continue
		var/obj/item/paper/talisman/T = initial(NR.talisman_path)
		var/req_invokers = initial(NR.required_invokers)
		var/invokers_text = initial(NR.invokers_text)
		runes[++runes.len] = list(
			"name" = initial(NR.rune_name),
			"invoker_data" = invokers_text != null ? invokers_text : (req_invokers > 1 ? req_invokers : null),
			"talisman" = T ? initial(T.tome_desc) : null,
			"shorthand" = initial(NR.rune_shorthand) ? initial(NR.rune_shorthand) : initial(NR.rune_desc),
			"typepath" = NR
		)
	dat["runes"] = runes
	dat["tab"] = tab
	dat["archive"] = archive
	dat["compact_mode"] = compact_mode
	return dat

/obj/item/arcane_tome/Topic(href, href_list, datum/topic_state/state)
	if (..() || !iscultist(usr))
		return TRUE
	if (href_list["switch_tab"])
		tab = text2num(href_list["switch_tab"])
		playsound(src, "pageturn", 25, TRUE)
	if (href_list["switch_archive"])
		archive = text2num(href_list["switch_archive"])
		playsound(src, "pageturn", 25, TRUE)
	if (href_list["compact_mode"])
		compact_mode = !compact_mode
	if (href_list["write_rune"])
		var/obj/effect/rune/R = text2path(href_list["write_rune"])
		if (ispath(R, /obj/effect/rune))
			scribe_rune(usr, R)
	SSnanoui.update_uis(src)

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
	if (scribing)
		to_chat(user, SPAN_WARNING("You can only scribe one rune at a time."))
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
		SPAN_WARNING("You hear droplets softly spattering onto the ground."),
		range = 3
	)
	scribing = TRUE
	if (ishuman(user) && !max(0, scribe_speed)) // Only drip blood if it actually takes time to write the rune
		var/mob/living/carbon/human/H = user
		for (var/i in 1 to 4)
			spawn (max(0, scribe_speed - 1 SECOND) / i)
				H.drip(1)
	if (!do_after(user, max(0, scribe_speed)))
		to_chat(user, SPAN_WARNING("The ritual is interrupted. Your [blood_name] splatters onto the ground."))
		scribing = FALSE
		return
	scribing = FALSE
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

/// Debug tome that automatically converts on pickup. Should never appear regularly.
/obj/item/arcane_tome/debug
	name = "debug tome"
	scribe_speed = 1 SECOND // Not quite instant, but close to it

/obj/item/arcane_tome/debug/get_examine_desc()
	return SPAN_DANGER("This should never appear in normal play - report this on the issue tracker if you see it in a normal round!")

/obj/item/arcane_tome/debug/pickup(mob/living/user)
	. = ..()
	if (user.mind)
		cult.add_antagonist(user.mind)

#undef TAB_ARCHIVES
#undef TAB_RUNES
