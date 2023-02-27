// For the cardpack decls
#define CARDPACK_BUILDER "builder"
#define CARDPACK_BASICWITCH "basicwitch"

#define KEY_TYPE "KEY"
#define REACTION_TYPE "REACTION"

/**
 *  ////////////////////////////////////////////
 *  ///              Rules                  ///
 *  ///////////////////////////////////////////
 *
 *  Players start with 5 spell cards, Heretic card starts in play. Game is over when Heretic card dies.
 *  Decks have 30 cards + a Heretic card, with up to 3 duplicate spells. If all cards have been drawn,
 *  reshuffle discarded spells.
 *
 *  Active Heretic actions can only be activated once per round, which are marked by the start of the caster's turn.
 *  Passive Heretic effects are always active when their conditions are met. Heretics cannot exceed max health.
 *
 *  Key spells may only be used on your turn. Reaction spells may be used in reaction to another player's spell,
 *  even if it is not targeting you. You may cast up to 2 spells on your turn, and draw 1 card after ending
 *  your turn. You may only use one reaction spell per round.
 *
 *  Damage types:
 *  Fire | Water | Earth | Wind | Decay | Holy
 *
 *  Suitable for 2-4 players.
 *
 *  The above and any changes to it should be listed in game on the deck box description_info.
 */

/obj/item/deck/saintsandsins
	name = "\improper Saints and Sins deck box"
	desc = "A deck box for the hit collectable card game, Saints and Sins. The instructions appear to be listed on the side."
	icon_state = "deck_box_saintsandsins"
	description_info = "Players start with 5 spell cards, Heretic card starts in play. Game is over when Heretic card dies. Decks have 30 cards + a Heretic card, with up to 3 duplicate spells. If all cards have been drawn, reshuffle discarded spells. <BR><BR>\
	Active Heretic actions can only be activated once per round, which are marked by the start of the caster's turn. Passive Heretic effects are always active when their conditions are met. Heretics cannot exceed max health. <BR><BR>\
	Key spells may only be used on your turn. Reaction spells may be used in reaction to another player's spell, even if it is not targeting you. You may cast up to 2 spells on your turn, and draw 1 card after ending your turn. You may only use one reaction spell per round. <BR><BR>\
	Damage types: <BR><BR>\
	Fire | Water | Earth | Wind | Decay | Holy <BR><BR>\
	Suitable for 2-4 players."
	decktype = /datum/playingcard/saintsandsins
	decklimit = 31

	var/list/heretics = list()
	var/list/spells = list()

/obj/item/pack/saintsandsins
	name = "\improper Saints and Sins builder pack"
	desc = "A builder pack for hit collectable card game, Saints and Sins. This one will \
    help any aspiring deck builder get started."
	icon_state = "card_pack_saintsandsins"
	decktype = /datum/playingcard/saintsandsins
	var/pack_type = CARDPACK_BUILDER
	var/how_many_cards = 21 /// Boosters give less cards than the builder packs.


/obj/item/pack/saintsandsins/Initialize()
	..()
	var/list/heretic_weights = build_card_weights_list(pack_type, /decl/sas_card/heretic)
	var/list/spell_weights = build_card_weights_list(pack_type, /decl/sas_card/spell)
	var/datum/playingcard/saintsandsins/P
	var/i
	var/decl/sas_card/cardpicker
	var/card_front
	for(i=0, i<how_many_cards, i++)
		if(i == 0) // Just pick one.
			cardpicker = pickweight(heretic_weights)
			card_front = "saintsandsins_heretic"
		else
			cardpicker = pickweight(spell_weights)
			card_front = "saintsandsins_spell"
		cardpicker = decls_repository.get_decl(cardpicker)
		P = new()
		P.name = cardpicker
		P.desc = cardpicker
		P.card_icon = card_front
		P.back_icon = "card_back_saintsandsins"
		cards += P

/datum/playingcard/saintsandsins

/**
 * Booster packs
 * Can have special cards not found in builder pack.
 */

/obj/item/pack/saintsandsins/booster
	name = "\improper Saints and Sins booster pack"
	desc = "A booster pack for hit collectable card game, Saints and Sins. This one is labeled 'Basic Witch Kit'."
	pack_type = CARDPACK_BASICWITCH
	how_many_cards = 11

/obj/item/pack/saintsandsins/proc/build_card_weights_list(pack_type, root_type)
	. = list()
	for (var/decl/sas_card/C in decls_repository.get_decls_of_subtype(root_type))
		if (pack_type in C.pack_probability)
			.[C.type] = C.pack_probability[pack_type] || 1

/*
// Builder pack cards can appear in other packs to fluff them up. Pack-specific are less likely to do so.
*/
/decl/sas_card
	var/name
	var/desc
	var/ability
	var/pack_probability

/*
// Heretics, only one per pack opened.
*/
/decl/sas_card/heretic
	var/health

/decl/sas_card/heretic/New()
	..()
	desc = "Health: [health]. [ability]"

/decl/sas_card/heretic/lady_of_holy_death
	name = "Lady of Holy Death"
	health = 18
	ability = "Restore 1 health every time you deal Decay damage, up to max health."
	pack_probability = list(
		CARDPACK_BUILDER = 10,
		CARDPACK_BASICWITCH = 10
	)

/decl/sas_card/heretic/galeria_the_haruspex
	name = "Galeria the Haruspex"
	health = 15
	ability = "ACTIVE: Block up to 2 damage of any kind for one round."
	pack_probability = list(
		CARDPACK_BUILDER = 10,
		CARDPACK_BASICWITCH = 10
	)

/decl/sas_card/heretic/dutiful_mephistopheles
	name = "Dutiful Mephistopheles"
	health = 15
	ability = "PASSIVE: Reduces Decay damage received by 2 while increasing Holy by 3."
	pack_probability = list(
		CARDPACK_BASICWITCH = 6
	)

/decl/sas_card/heretic/woebringer_colette
	name = "Woebringer Colette"
	health = 21
	desc = "ACTIVE: Deal 2 damage of any damage type while taking 2 damage of the same type."
	pack_probability = list(
		CARDPACK_BASICWITCH = 8
	)

/decl/sas_card/heretic/orpheus_the_blind
	name = "Orpheus the Blind"
	health = 18
	desc = "PASSIVE: When below half health, take half damage per spell, rounded up."
	pack_probability = list(
		CARDPACK_BASICWITCH = 4
	)

/*
// Spells.
*/
/decl/sas_card/spell
	var/spell_type

/decl/sas_card/spell/New()
	..()
	desc = "[ability] [spell_type]."

/decl/sas_card/spell/summon_psychopomp
	name = "Summon Psychopomp"
	ability = "Deals 3 Decay damage to target for 3 rounds."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BUILDER = 5,
		CARDPACK_BASICWITCH = 8
	)

/decl/sas_card/spell/meteor_shower
	name = "Meteor Shower"
	ability = "Deals 5 Fire damage to ALL Heretics."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BUILDER = 7
	)

/decl/sas_card/spell/chastise
	name = "Chastise"
	ability = "Deals 2 Holy damage to target."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BUILDER = 10,
		CARDPACK_BASICWITCH = 10
	)

/decl/sas_card/spell/rebuke
	name = "Rebuke"
	ability = "Nullifies one spell."
	spell_type = REACTION_TYPE
	pack_probability = list(
		CARDPACK_BUILDER = 3,
		CARDPACK_BASICWITCH = 6
	)

/decl/sas_card/spell/blessed_invocation
	name = "Blessed Invocation"
	ability = "Restores 5 health to caster."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BUILDER = 3,
		CARDPACK_BASICWITCH = 4
	)

/decl/sas_card/spell/vampyric_bite
	name = "Vampyric Bite"
	ability = "Deals 2 Decay damage to target and restores 2 health to caster."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BUILDER = 7,
		CARDPACK_BASICWITCH = 8
	)

/decl/sas_card/spell/wicked_fountain
	name = "Wicked Fountain"
	ability = "Deals 3 Water damage to target."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BUILDER = 8,
		CARDPACK_BASICWITCH = 10
	)

/decl/sas_card/spell/sick_air
	name = "Sick Air"
	ability = "Deals 1 Wind damage to target for 5 rounds."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BUILDER = 8
	)

/decl/sas_card/spell/flux_of_humors
	name = "Flux of Humors"
	ability = "Restores 2 health to caster for 3 rounds."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BUILDER = 8,
		CARDPACK_BASICWITCH = 10
	)

/decl/sas_card/spell/earthquake
	name = "Earthquake"
	ability = "Deals 3 Earth damage to ALL Heretics for 3 rounds."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BUILDER = 8,
		CARDPACK_BASICWITCH = 10
	)

/decl/sas_card/spell/shifting_soil
	name = "Shifting Soil"
	ability = "Redirect spell to another Heretic."
	spell_type = REACTION_TYPE
	pack_probability = list(
		CARDPACK_BUILDER = 8,
		CARDPACK_BASICWITCH = 10
	)

/decl/sas_card/spell/wind_tunnel
	name = "Wind Tunnel"
	ability = "Redirects spell to its caster."
	spell_type = REACTION_TYPE
	pack_probability = list(
		CARDPACK_BUILDER = 8,
		CARDPACK_BASICWITCH = 10
	)

/decl/sas_card/spell/awakening
	name = "Awakening"
	ability = "Deals 2 Holy damage to ALL Heretics."
	spell_type = REACTION_TYPE
	pack_probability = list(
		CARDPACK_BUILDER = 8
	)

/decl/sas_card/spell/penance
	name = "Penance"
	ability = "Deals 3 Holy damage to target."
	spell_type = REACTION_TYPE
	pack_probability = list(
		CARDPACK_BASICWITCH = 7
	)

/decl/sas_card/spell/soothing_breeze
	name = "Soothing Breeze"
	ability = "Blocks up to 4 damage of any kind for one round."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BASICWITCH = 6
	)

/decl/sas_card/spell/protection_ward
	name = "Protection Ward"
	ability = "Nullifies the next damage from a spell used on its caster."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BASICWITCH = 8
	)

/decl/sas_card/spell/blood_drain
	name = "Blood Drain"
	ability = "Deals 1 Water damage to target for 6 rounds."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BASICWITCH = 8
	)

/decl/sas_card/spell/dance_of_death
	name = "Dance of Death"
	ability = "Discard 2 cards and draw 2 more."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BASICWITCH = 9
	)

/decl/sas_card/spell/hex
	name = "Hex"
	ability = "Target must discard their whole hand and draw a new one."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BASICWITCH = 6
	)

/decl/sas_card/spell/crippling_despair
	name = "Crippling Despair"
	ability = "Target may only cast one Key spell on their next turn."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BASICWITCH = 8
	)

/decl/sas_card/spell/spark_of_pain
	name = "Spark of Pain"
	ability = "Deals 1 Fire damage to target."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BASICWITCH = 10
	)

/decl/sas_card/spell/devils_tears
	name = "Devil's Tears"
	ability = "Deals 1 Water damage to target."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BASICWITCH = 10
	)

/decl/sas_card/spell/fist_of_stone
	name = "Fist of Stone"
	ability = "Deals 1 Earth damage to target."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BASICWITCH = 10
	)

/decl/sas_card/spell/cutting_blow
	name = "Cutting Blow"
	ability = "Deals 1 Wind damage to target."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BASICWITCH = 10
	)

/decl/sas_card/spell/touch_of_death
	name = "Touch of Death"
	ability = "Deals 1 Decay damage to target."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BASICWITCH = 10
	)

/decl/sas_card/spell/righteous_accusation
	name = "Righteous Accusation"
	ability = "Deals 1 Holy damage to target."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BASICWITCH = 10
	)

/decl/sas_card/spell/cold_stare
	name = "Cold Stare"
	ability = "Nullifies any Fire damage from a spell."
	spell_type = REACTION_TYPE
	pack_probability = list(
		CARDPACK_BASICWITCH = 8
	)

#undef CARDPACK_BUILDER
#undef CARDPACK_BASICWITCH

#undef KEY_TYPE
#undef REACTION_TYPE
