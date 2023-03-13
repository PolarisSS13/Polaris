var/global/datum/antagonist/cultist/cult

/proc/iscultist(var/mob/player)
	if(!cult || !player.mind)
		return 0
	if(player.mind in cult.current_antagonists)
		return 1

/datum/antagonist/cultist
	id = MODE_CULTIST
	role_text = "Cultist"
	role_text_plural = "Cultists"
	bantype = "cultist"
	restricted_jobs = list("Chaplain")
	avoid_silicons = TRUE
	protected_jobs = list("Security Officer", "Warden", "Detective", "Internal Affairs Agent", "Head of Security", "Site Manager")
	roundstart_restricted = list("Internal Affairs Agent", "Head of Security", "Site Manager")
	role_type = BE_CULTIST
	feedback_tag = "cult_objective"
	antag_indicator = "cult"
	welcome_text = "You have a talisman in your possession; one that will help you start the cult on this station. Use it well and remember - there are others."
	antag_sound = 'sound/effects/antag_notice/cult_alert.ogg'
	victory_text = "The cult wins! It has succeeded in serving its dark masters!"
	loss_text = "The staff managed to stop the cult!"
	victory_feedback_tag = "win - cult win"
	loss_feedback_tag = "loss - staff stopped the cult"
	flags = ANTAG_SUSPICIOUS | ANTAG_RANDSPAWN | ANTAG_VOTABLE
	hard_cap = 5
	hard_cap_round = 6
	initial_spawn_req = 4
	initial_spawn_target = 6
	antaghud_indicator = "hudcultist"

	/// Whether or not the Tear Reality rune can be used.
	var/allow_narsie = TRUE
	/// The mind datum of the mob that this cult must sacrifice to fulfill their objective.
	var/datum/mind/sacrifice_target
	/// A list of all mobs that this cult has sacrificed. Uses lazylist macros.
	var/list/sacrificed
	/// A list of all non-cultists that have been killed by Nar-Sie (in the rare event that an admin spawns it or something.) Uses lazylist macros.
	var/list/harvested
	/// A list of all runes in the game world. Uses lazylist macros.
	var/list/all_runes

	/**
	 * So here's how the cult vocabulary works:
	 * * There are two lists of words: one contains English words representing concepts ("blood", "other", "technology", etc) while the other are culty gibberish. Both of these lists have the same amount of total words in them.
	 * * At runtime, each cult word is correlated to a random English word representing its meaning. On one round the word "ego" might mean "technology", but on another it might mean "hell", and so on.
	 * * This list is populated as an associative list with each English word associated with its cult word counterpart.
	 *
	 * The word lists are found in `english_words` and `cult_words` on `/datum/antagonist/cultist`, and are populated from defines to avoid string copy-paste.
	 */
	var/list/vocabulary
	var/list/english_words = list(CULT_WORD_BLOOD, CULT_WORD_DESTROY, CULT_WORD_HELL, CULT_WORD_HIDE, CULT_WORD_JOIN, CULT_WORD_OTHER, CULT_WORD_SELF, CULT_WORD_SEE, CULT_WORD_TECHNOLOGY, CULT_WORD_TRAVEL)
	var/list/cult_words = list(CULT_WORD_BALAQ, CULT_WORD_CERTUM, CULT_WORD_EGO, CULT_WORD_GEERI, CULT_WORD_IRE, CULT_WORD_KARAZET, CULT_WORD_JATKAA, CULT_WORD_MGAR, CULT_WORD_NAHLIZET, CULT_WORD_VERI)

/datum/antagonist/cultist/New()
	..()
	cult = src
	if (!LAZYLEN(vocabulary))
		var/list/gibberish = cult_words
		for (var/eng in english_words)
			var/culty = pick(gibberish)
			LAZYSET(vocabulary, eng, culty)
			gibberish -= culty

/datum/antagonist/cultist/create_global_objectives()

	if(!..())
		return

	global_objectives = list()
	if(prob(50))
		global_objectives |= new /datum/objective/cult/survive
	else
		global_objectives |= new /datum/objective/cult/eldergod

	var/datum/objective/cult/sacrifice/sacrifice = new()
	sacrifice.find_target()
	sacrifice_target = sacrifice.target
	global_objectives |= sacrifice

/datum/antagonist/cultist/equip(var/mob/living/carbon/human/player)

	if(!..())
		return 0

	var/obj/item/paper/talisman/supply/T = new(get_turf(player))
	var/list/slots = list (
		"backpack" = slot_in_backpack,
		"left pocket" = slot_l_store,
		"right pocket" = slot_r_store,
		"left hand" = slot_l_hand,
		"right hand" = slot_r_hand,
	)
	for(var/slot in slots)
		player.equip_to_slot(T, slot)
		if(T.loc == player)
			break
	var/obj/item/storage/S = locate() in player.contents
	if(S && istype(S))
		T.loc = S

/datum/antagonist/cultist/remove_antagonist(var/datum/mind/player, var/show_message, var/implanted)
	if(!..())
		return 0
	to_chat(player.current, "<span class='danger'>An unfamiliar white light flashes through your mind, cleansing the taint of the dark-one and the memories of your time as his servant with it.</span>")
	player.memory = ""
	if(show_message)
		player.current.visible_message("<FONT size = 3>[player.current] looks like they just reverted to their old faith!</FONT>")

/datum/antagonist/cultist/add_antagonist(var/datum/mind/player)
	. = ..()
	if(.)
		to_chat(player, "You catch a glimpse of the Realm of Nar-Sie, the Geometer of Blood. You now see how flimsy the world is, you see that it should be open to the knowledge of That Which Waits. Assist your new compatriots in their dark dealings. Their goals are yours, and yours are theirs. You serve the Dark One above all else. Bring It back.")
		if(player.current && !istype(player.current, /mob/living/simple_mob/construct))
			player.current.add_language(LANGUAGE_CULT)

/datum/antagonist/cultist/remove_antagonist(var/datum/mind/player, var/show_message, var/implanted)
	. = ..()
	if(. && player.current && !istype(player.current, /mob/living/simple_mob/construct))
		player.current.remove_language(LANGUAGE_CULT)

/datum/antagonist/cultist/can_become_antag(var/datum/mind/player)
	if(!..())
		return 0
	for(var/obj/item/implant/loyalty/L in player.current)
		if(L && (L.imp_in == player.current))
			return 0
	return 1

/datum/antagonist/cultist/proc/cult_speak(mob/speaker, message)
	for (var/mob/M in player_list)
		if (iscultist(M) || isobserver(M))
			to_chat(M, SPAN_OCCULT("[speaker.GetVoice()][speaker.GetAltName()] intones, \"[message]\""))
