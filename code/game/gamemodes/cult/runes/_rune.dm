/obj/effect/rune
	name = "rune"
	desc = "A strange collection of symbols drawn in what looks to be blood."
	icon = 'icons/obj/rune.dmi'
	icon_state = "1"
	anchored = TRUE
	unacidable = TRUE
	layer = TURF_LAYER

	/// The actual invocation spoken by each cultist activating this rune.
	var/invocation
	/// If true, cultists invoking this rune will whisper, instead of speaking normally.
	var/whispered
	/// A list of "words" used to form this rune.
	var/list/circle_words
	/// AIs see runes as blood splatters. This variable tracks the image shown in the rune's place.
	var/image/blood_image
	/// The talisman that this rune will create when used by the Imbue Talisman rune.
	var/obj/item/paper/talisman/talisman_path
	/// How many cultists need to be adjacent to this rune and able to speak in order to activate it.
	var/required_invokers = 1
	/// The actual name of this rune (like "Sacrifice", "Convert", or so on), shown to cultists or ghosts that examine it.
	var/rune_name
	/// Very short description of the rune's functionality, to be shown as a tooltip in the tome.
	var/rune_shorthand
	/// As `rune_name`, but for a description of what the rune actually does.
	var/rune_desc
	/// If FALSE, this rune won't appear on the tome's rune list.
	var/can_write = TRUE

/obj/effect/rune/Initialize()
	. = ..()
	blood_image = image(loc = src)
	blood_image.override = TRUE
	for (var/mob/living/silicon/ai/AI in player_list)
		AI.client?.images += blood_image
	LAZYDISTINCTADD(cult.all_runes, src)
	update_icon()

/obj/effect/rune/Destroy()
	for (var/mob/living/silicon/ai/AI in player_list)
		AI.client?.images -= blood_image
	QDEL_NULL(blood_image)
	LAZYREMOVE(cult.all_runes, src)
	return ..()

/obj/effect/rune/get_examine_desc()
	if ((isobserver(usr) || iscultist(usr)) && rune_name && rune_desc)
		return SPAN_OCCULT("This is a <b>[rune_name]</b> rune.<br>[rune_desc]")
	else
		return desc

/obj/effect/rune/attackby(obj/item/I, mob/user)
	if (istype(I, /obj/item/arcane_tome) && iscultist(user))
		to_chat(user, SPAN_NOTICE("You retrace your steps, carefully undoing the lines of \the [src]."))
		qdel(src)
		return
	else if (istype(I, /obj/item/nullrod))
		to_chat(user, SPAN_NOTICE("The scratchings lose coherence and dissolve into puddles of blood that quickly sizzle and disappear."))
		qdel(src)
		return
	else if (istype(I, /obj/item/soap) || istype(I, /obj/item/mop))
		to_chat(user, SPAN_WARNING("No matter how hard you try, the scratchings just won't seem to come out."))
	return

/obj/effect/rune/attack_hand(mob/living/user)
	if (can_contribute(user, FALSE))
		do_invocation(user)

/// Type-specific check for if this rune can be invoked or not. Always returns `TRUE` unless overridden.
/obj/effect/rune/proc/can_invoke(mob/living/invoker)
	return TRUE

/// Type-specific check to get required invokers. This lets runes require different invokers under certain conditions.
/// If it's a rune with dynamic requirements, you might benefit from giving that invoker a message explaining why they need more people.
/obj/effect/rune/proc/get_required_invokers(mob/living/invoker)
	return required_invokers

/**
 * Checks if a given mob can participate as an invoker for this rune.
 *
 * By default, a mob must be a human, a cultist, and able to speak.
 * Arguments:
 * * `invoker` - The mob being checked as a possible contributor
 * * `silent` - If non-true, shows an error message to the mob being checked. Defaults to `TRUE`
 */
/obj/effect/rune/proc/can_contribute(mob/living/invoker, silent = TRUE)
	var/fail_message
	if (!ishuman(invoker))
		return
	var/mob/living/carbon/human/H = invoker
	if (!iscultist(H))
		fail_message = "You can't mouth the arcane scratchings without fumbling over them."
	else if (H.is_muzzled() || H.silent || (H.sdisabilities & MUTE))
		fail_message = "You can't speak the words of \the [src]."
	if (fail_message)
		if (!silent)
			to_chat(H, SPAN_WARNING(fail_message))
		return
	return TRUE

/// This proc holds the logic through which invocation is attempted and handled, and shouldn't be overridden.
/// If `can_invoke()` is `TRUE` and the rune has enough possible contributors, the rune's `invoke()` is called.
/obj/effect/rune/proc/do_invocation(mob/living/user)
	if (!can_invoke(user))
		fizzle()
		return
	var/list/invokers = list()
	invokers += user
	var/req_invokers = get_required_invokers(user)
	for (var/mob/living/L in range(1, src) - user)
		if (invokers.len >= req_invokers)
			break
		else if (can_contribute(L))
			invokers.Add(L)
	if (invokers.len < req_invokers)
		for (var/mob/living/invoker in invokers)
			to_chat(invoker, SPAN_WARNING("You need more invokers to use this rune. (Have [invokers.len], need [req_invokers])"))
		return
	if (invocation)
		for (var/mob/living/L in invokers)
			!whispered ? L.say(invocation) : L.whisper(invocation)
	invoke(invokers)

/// Short message shown to all observers representing a failed attempt to use the rune.
/// Clarifying messages describing *why* an attempt failed should go in `can_invoke()` or `invoke()` if possible, and not here.
/obj/effect/rune/proc/fizzle()
	visible_message(SPAN_WARNING("The markings pulse with a small burst of light, then fall dark."))

/// This is what you want to override for each type. The actual effects of a rune (converting someone, teleporting the invoker, etc) should be handled here.
/// To reference the person who triggered the activation of the rune, use `invokers[1]`.
/obj/effect/rune/proc/invoke(list/invokers)
	fizzle()

/// Does something after creating this rune. By default, nothing extra happens.
/obj/effect/rune/proc/after_scribe(mob/living/writer)
	return

/// Applies unique effects to a talisman created by this rune before the rune is destroyed.
/obj/effect/rune/proc/apply_to_talisman(obj/item/paper/talisman/T)
	return

/// "Random" rune with no function, used for generating spooky runes in mapgen.
/obj/effect/rune/mapgen
	rune_name = "malformed"
	rune_desc = "These meaningless scratchings serve no purpose, save to show one's devotion."
	can_write = FALSE
	circle_words = list() // Needs to be an empty list to prevent runtimes in Initialize()

/obj/effect/rune/mapgen/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/rune/mapgen/LateInitialize()
	var/list/words = cult.english_words
	for (var/i in 1 to 3)
		var/word = pick(words)
		circle_words.Add(word)
		words.Remove(word)
	update_icon()
