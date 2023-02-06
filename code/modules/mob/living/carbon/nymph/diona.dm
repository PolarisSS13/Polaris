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

/mob/living/carbon/nymph
	name = "diona nymph"
	voice_name = "diona nymph"
	speak_emote = list("chirrups")
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

	var/can_namepick_as_adult = TRUE
	var/adult_name = "diona gestalt"
	var/death_msg = "expires with a pitiful chirrup..."

	var/amount_grown = 0
	var/max_grown = 200
	var/time_of_birth
	var/instance_num


/mob/living/carbon/nymph/get_available_emotes()
	return global._nymph_default_emotes


/mob/living/carbon/nymph/Initialize()
	. = ..()
	time_of_birth = world.time

	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide
	verbs += /mob/living/carbon/nymph/proc/merge

	instance_num = rand(1, 1000)
	name = "[initial(name)] ([instance_num])"
	real_name = name
	regenerate_icons()

	species = GLOB.all_species[SPECIES_DIONA]
	add_language(LANGUAGE_ROOTGLOBAL)
	add_language(LANGUAGE_GALCOM)


/mob/living/carbon/nymph/put_in_hands(var/obj/item/W) // No hands.
	W.loc = get_turf(src)
	return TRUE


/mob/living/carbon/nymph/proc/wear_hat(var/obj/item/new_hat)
	if(hat)
		return
	hat = new_hat
	new_hat.loc = src
	update_icons()


/mob/living/carbon/nymph/proc/handle_npc(var/mob/living/carbon/nymph/D)
	if(D.stat != CONSCIOUS)
		return
	if(prob(33) && D.canmove && isturf(D.loc) && !D.pulledby) //won't move if being pulled
		step(D, pick(cardinal))
	if(prob(1))
		D.emote(pick("scratch","jump","chirp","roll"))


/mob/living/carbon/nymph/u_equip(obj/item/W as obj)
	return


/mob/living/carbon/nymph/Stat()
	..()
	stat(null, "Progress: [amount_grown]/[max_grown]")


/mob/living/carbon/nymph/get_default_language()
	if(default_language)
		return default_language
	return GLOB.all_languages["Skathari"]


/mob/living/carbon/nymph/say_quote(var/message, var/datum/language/speaking = null)
	var/verb = pick(speak_emote)
	var/ending = copytext(message, length(message))
	if(speaking && (speaking.name != "Galactic Common"))
		verb = speaking.get_spoken_verb(ending)
	else if(ending == "?")
		verb += " curiously"
	return verb


/mob/living/carbon/nymph/death(gibbed)
	return ..(gibbed,death_msg)
