// Reorganized and somewhat cleaned up.
// AI code has been made into a datum, inside the AI module folder.

/mob/living/simple_mob
	name = "animal"
	desc = ""
	icon = 'icons/mob/animal.dmi'
	health = 20
	maxHealth = 20

	mob_bump_flag = SIMPLE_ANIMAL
	mob_swap_flags = MONKEY|SLIME|HUMAN
	mob_push_flags = MONKEY|SLIME|HUMAN

	var/tt_desc = "Uncataloged Life Form" //Tooltip description

	//Settings for played mobs
	var/show_stat_health = 1		// Does the percentage health show in the stat panel for the mob
	var/has_hands = 0				// Set to 1 to enable the use of hands and the hands hud
	var/list/hud_gears				// Slots to show on the hud (typically none)
	var/ui_icons					// Icon file path to use for the HUD, otherwise generic icons are used
	var/r_hand_sprite				// If they have hands,
	var/l_hand_sprite				// they could use some icons.
	var/player_msg					// Message to print to players about 'how' to play this mob on login.

	//Mob icon/appearance settings
	var/icon_living = ""			// The iconstate if we're alive, required
	var/icon_dead = ""				// The iconstate if we're dead, required
	var/icon_gib = "generic_gib"	// The iconstate for being gibbed, optional. Defaults to a generic gib animation.
	var/icon_rest = null			// The iconstate for resting, optional
	var/image/modifier_overlay = null // Holds overlays from modifiers.
	var/image/eye_layer = null		// Holds the eye overlay.
	var/has_eye_glow = FALSE		// If true, adds an overlay over the lighting plane for [icon_state]-eyes.
	attack_icon = 'icons/effects/effects.dmi' //Just the default, played like the weapon attack anim
	attack_icon_state = "slash" //Just the default

	//Mob talking settings
	universal_speak = 0				// Can all mobs in the entire universe understand this one?
	var/has_langs = list(LANGUAGE_GALCOM)// Text name of their language if they speak something other than galcom. They speak the first one.

	//Movement things.
	var/movement_cooldown = 5			// Lower is faster.
	var/movement_sound = null			// If set, will play this sound when it moves on its own will.

	//Mob interaction
	var/response_help   = "tries to help"	// If clicked on help intent
	var/response_disarm = "tries to disarm" // If clicked on disarm intent
	var/response_harm   = "tries to hurt"	// If clicked on harm intent
	var/list/friends = list()		// Mobs on this list wont get attacked regardless of faction status.
	var/harm_intent_damage = 3		// How much an unarmed harm click does to this mob.
	var/meat_amount = 0				// How much meat to drop from this mob when butchered
	var/obj/meat_type				// The meat object to drop
	var/list/loot_list = list()		// The list of lootable objects to drop, with "/path = prob%" structure
	var/obj/item/weapon/card/id/myid// An ID card if they have one to give them access to stuff.

	//Mob environment settings
	var/minbodytemp = 250			// Minimum "okay" temperature in kelvin
	var/maxbodytemp = 350			// Maximum of above
	var/heat_damage_per_tick = 3	// Amount of damage applied if animal's body temperature is higher than maxbodytemp
	var/cold_damage_per_tick = 2	// Same as heat_damage_per_tick, only if the bodytemperature it's lower than minbodytemp
	var/fire_alert = 0				// 0 = fine, 1 = hot, 2 = cold

	var/min_oxy = 5					// Oxygen in moles, minimum, 0 is 'no minimum'
	var/max_oxy = 0					// Oxygen in moles, maximum, 0 is 'no maximum'
	var/min_tox = 0					// Phoron min
	var/max_tox = 1					// Phoron max
	var/min_co2 = 0					// CO2 min
	var/max_co2 = 5					// CO2 max
	var/min_n2 = 0					// N2 min
	var/max_n2 = 0					// N2 max
	var/unsuitable_atoms_damage = 2	// This damage is taken when atmos doesn't fit all the requirements above

	//Hostility settings
	var/taser_kill = 1				// Is the mob weak to tasers

	//Attack ranged settings
	var/projectiletype				// The projectiles I shoot
	var/projectilesound				// The sound I make when I do it
	var/casingtype					// What to make the hugely laggy casings pile out of

	//Mob melee settings
	var/melee_damage_lower = 2		// Lower bound of randomized melee damage
	var/melee_damage_upper = 6		// Upper bound of randomized melee damage
	var/list/attacktext = list("attacked") // "You are [attacktext] by the mob!"
	var/list/friendly = list("nuzzles") // "The mob [friendly] the person."
	var/attack_sound = null			// Sound to play when I attack
	var/melee_miss_chance = 15		// percent chance to miss a melee attack.
	var/attack_armor_type = "melee"		// What armor does this check?
	var/attack_armor_pen = 0			// How much armor pen this attack has.
	var/attack_sharp = 0				// Is the attack sharp?
	var/attack_edge = 0					// Does the attack have an edge?

	//Special attacks
	var/special_attack_prob = 0			// Chance of the mob doing a special attack (0 for never)
	var/special_attack_min_range = 0	// Min range to perform the special attacks from
	var/special_attack_max_range = 0	// Max range to perform special attacks from

	//Damage resistances
	var/grab_resist = 0				// Chance for a grab attempt to fail. Note that this is not a true resist and is just a prob() of failure.
	var/resistance = 0				// Damage reduction for all types
	var/list/armor = list(			// Values for normal getarmor() checks
				"melee" = 0,
				"bullet" = 0,
				"laser" = 0,
				"energy" = 0,
				"bomb" = 0,
				"bio" = 100,
				"rad" = 100
				)
	var/list/armor_soak = list(		// Values for getsoak() checks.
				"melee" = 0,
				"bullet" = 0,
				"laser" = 0,
				"energy" = 0,
				"bomb" = 0,
				"bio" = 0,
				"rad" = 0
				)
	var/purge = 0					// Cult stuff.
	var/supernatural = FALSE		// Ditto.


/mob/living/simple_mob/initialize()
	verbs -= /mob/verb/observe
	maxHealth = health

	for(var/L in has_langs)
		languages |= all_languages[L]
	if(languages.len)
		default_language = languages[1]

	if(has_eye_glow)
		add_eyes()
	return ..()


/mob/living/simple_mob/Destroy()
	default_language = null
	if(myid)
		qdel(myid)
		myid = null

	friends.Cut()
	languages.Cut()

	if(has_eye_glow)
		remove_eyes()
	return ..()


//Client attached
/mob/living/simple_mob/Login()
	. = ..()
	to_chat(src,"<b>You are \the [src]. [player_msg]</b>")


/mob/living/simple_mob/emote(var/act, var/type, var/desc)
	if(act)
		..(act, type, desc)


/mob/living/simple_mob/SelfMove()
	. = ..()
	if(movement_sound)
		playsound(src, movement_sound, 50, 1)

/mob/living/simple_mob/movement_delay()
	var/tally = 0 //Incase I need to add stuff other than "speed" later

	tally = movement_cooldown

	if(force_max_speed)
		return -3

	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.haste) && M.haste == TRUE)
			return -3
		if(!isnull(M.slowdown))
			tally += M.slowdown

	if(purge)//Purged creatures will move more slowly. The more time before their purge stops, the slower they'll move.
		if(tally <= 0)
			tally = 1
		tally *= purge

	if(m_intent == "walk")
		tally *= 1.5

	return tally+config.animal_delay


/mob/living/simple_mob/Stat()
	..()
	if(statpanel("Status") && show_stat_health)
		stat(null, "Health: [round((health / getMaxHealth()) * 100)]%")

/mob/living/simple_mob/lay_down()
	..()
	if(resting && icon_rest)
		icon_state = icon_rest
	else
		icon_state = icon_living
	update_icon()


/mob/living/simple_mob/say(var/message,var/datum/language/language)
	var/verb = "says"
	if(speak_emote.len)
		verb = pick(speak_emote)

	message = sanitize(message)

	..(message, null, verb)

/mob/living/simple_mob/get_speech_ending(verb, var/ending)
	return verb


/mob/living/simple_mob/put_in_hands(var/obj/item/W) // No hands.
	W.forceMove(get_turf(src))
	return 1

// Harvest an animal's delicious byproducts
/mob/living/simple_mob/proc/harvest(var/mob/user)
	var/actual_meat_amount = max(1,(meat_amount/2))
	if(meat_type && actual_meat_amount>0 && (stat == DEAD))
		for(var/i=0;i<actual_meat_amount;i++)
			var/obj/item/meat = new meat_type(get_turf(src))
			meat.name = "[src.name] [meat.name]"
		if(issmall(src))
			user.visible_message("<span class='danger'>[user] chops up \the [src]!</span>")
			new/obj/effect/decal/cleanable/blood/splatter(get_turf(src))
			qdel(src)
		else
			user.visible_message("<span class='danger'>[user] butchers \the [src] messily!</span>")
			gib()


/mob/living/simple_mob/is_sentient()
	return mob_class & MOB_CLASS_HUMANOID|MOB_CLASS_ANIMAL // Update this if needed.
//	return intelligence_level != SA_PLANT && intelligence_level != SA_ROBOTIC

//Just some subpaths for easy searching
/mob/living/simple_mob/hostile
	faction = "not yours"
//	ai_holder_type = /datum/ai_holder/regular/hostile

/mob/living/simple_mob/retaliate
//	ai_holder_type = /datum/ai_holder/regular/retaliate

/mob/living/simple_mob/get_nametag_desc(mob/user)
	return "<i>[tt_desc]</i>"