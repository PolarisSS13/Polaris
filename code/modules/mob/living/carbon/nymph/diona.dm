var/global/list/_nymph_default_emotes = list(
	/decl/emote/visible,
	/decl/emote/visible/scratch,
	/decl/emote/visible/drool,
	/decl/emote/visible/nod,
	/decl/emote/visible/sway,
	/decl/emote/visible/sulk,
	/decl/emote/visible/twitch,
	/decl/emote/visible/dance,
	/decl/emote/visible/roll,
	/decl/emote/visible/shake,
	/decl/emote/visible/jump,
	/decl/emote/visible/shiver,
	/decl/emote/visible/collapse,
	/decl/emote/visible/spin,
	/decl/emote/visible/sidestep,
	/decl/emote/audible/hiss,
	/decl/emote/audible,
	/decl/emote/audible/scretch,
	/decl/emote/audible/choke,
	/decl/emote/audible/gnarl,
	/decl/emote/audible/bug_hiss,
	/decl/emote/audible/bug_chitter,
	/decl/emote/audible/chirp
)

/datum/say_list/diona
	emote_hear = list("chirps")
	emote_see = list("jumps", "rolls", "scrathes")

/mob/living/carbon/diona
	name = "diona nymph"
	desc = "A skittery little creature."
	voice_name = "diona nymph"
	speak_emote = list("chirrups")
	icon = 'icons/mob/alien.dmi'
	icon_state = "nymph"
	item_state = "nymph"
	species_language = LANGUAGE_ROOTLOCAL
	only_species_language = TRUE
	gender = NEUTER

	can_pull_size = ITEMSIZE_SMALL
	can_pull_mobs = MOB_PULL_SMALLER

	holder_type = /obj/item/holder/diona
	var/obj/item/hat

	pass_flags = PASSTABLE
	health = 100
	maxHealth = 100
	mob_size = 4

	inventory_panel_type = null // Disable inventory by default
	has_huds = TRUE

	say_list_type = /datum/say_list/diona
	ai_holder_type = /datum/ai_holder/simple_mob/passive

	var/can_namepick_as_adult = TRUE
	var/adult_name = "diona gestalt"
	var/death_msg = "expires with a pitiful chirrup..."

	var/amount_grown = 0
	var/max_grown = 200
	var/time_of_birth
	var/instance_num


/mob/living/carbon/diona/get_available_emotes()
	return global._nymph_default_emotes


/mob/living/carbon/diona/Initialize()
	. = ..()
	time_of_birth = world.time

	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide
	verbs += /mob/living/carbon/diona/proc/merge

	instance_num = rand(1, 1000)
	name = "[initial(name)] ([instance_num])"
	real_name = name
	regenerate_icons()

	species = GLOB.all_species[SPECIES_DIONA]
	add_language(LANGUAGE_ROOTLOCAL)
	add_language(LANGUAGE_ROOTGLOBAL)
	add_language(LANGUAGE_GALCOM)


/mob/living/carbon/diona/put_in_hands(var/obj/item/W) // No hands.
	W.loc = get_turf(src)
	return TRUE


/mob/living/carbon/diona/proc/wear_hat(var/obj/item/new_hat)
	if(hat)
		return
	hat = new_hat
	new_hat.loc = src
	update_icons()


/mob/living/carbon/diona/u_equip(obj/item/W as obj)
	return


/mob/living/carbon/diona/Stat()
	..()
	stat(null, "Progress: [amount_grown]/[max_grown]")


/mob/living/carbon/diona/get_default_language()
	if(default_language)
		return default_language
	return GLOB.all_languages["Skathari"]


/mob/living/carbon/diona/say_quote(var/message, var/datum/language/speaking = null)
	var/verb = pick(speak_emote)
	var/ending = copytext(message, length(message))
	if(speaking && (speaking.name != "Galactic Common"))
		verb = speaking.get_spoken_verb(ending)
	else if(ending == "?")
		verb += " curiously"
	return verb


/mob/living/carbon/diona/death(gibbed)
	return ..(gibbed,death_msg)


/mob/living/carbon/diona/attack_ghost(mob/observer/dead/user)
	if(client || key || ckey)
		to_chat(user, SPAN_WARNING("\The [src] already has a player."))
		return
	if(alert(user, "Do you wish to take control of \the [src]?", "Chirp Time", "No", "Yes") == "No")
		return
	if(QDELETED(src) || QDELETED(user) || !user.client)
		return
	if(client || key || ckey)
		to_chat(user, SPAN_WARNING("\The [src] already has a player."))
		return
	var/datum/ghosttrap/plant/P = get_ghost_trap("living plant")
	if(P.assess_candidate(user))
		P.transfer_personality(user, src)

/mob/living/carbon/diona/make_hud_overlays()
	hud_list[HEALTH_HUD]      = gen_hud_image(ingame_hud_med, src, "100", plane = PLANE_CH_HEALTH)
	hud_list[STATUS_HUD]      = gen_hud_image(ingame_hud, src, "hudhealthy", plane = PLANE_CH_STATUS)
	hud_list[LIFE_HUD]        = gen_hud_image(ingame_hud, src, "hudhealthy", plane = PLANE_CH_LIFE)
	add_overlay(hud_list)

/mob/living/carbon/diona/Stat()
	..()
	if (statpanel("Status"))
		stat(null, text("Growth: [round(amount_grown/max_grown)]%"))
