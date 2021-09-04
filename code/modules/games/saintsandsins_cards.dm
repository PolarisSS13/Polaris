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

/obj/item/weapon/deck/saintsandsins
	name = "\improper Saints and Sins deck box"
	desc = "A deck box for the hit collectable card game, Saints and Sins. The instructions appear to be listed on the side."
	icon_state = "deck_box_saintsandsins"
	description_info = "Players start with 5 spell cards, Heretic card starts in play. Game is over when Heretic card dies. Decks have 30 cards + a Heretic card, with up to 3 duplicate spells. If all cards have been drawn, reshuffle discarded spells. <BR><BR>\
	Active Heretic actions can only be activated once per round, which are marked by the start of the caster's turn. Passive Heretic effects are always active when their conditions are met. Heretics cannot exceed max health. <BR><BR>\
	Key spells may only be used on your turn. Reaction spells may be used in reaction to another player's spell, even if it is not targeting you. You may cast up to 2 spells on your turn, and draw 1 card after ending your turn. You may only use one reaction spell per round. <BR><BR>\
	Damage types: <BR><BR>\
	Fire | Water | Earth | Wind | Decay | Holy <BR><BR>\
	Suitable for 2-4 players."
	decktype = "saintsandsins"
	decklimit = 31

	var/list/heretics = list()
	var/list/spells = list()

/obj/item/weapon/pack/saintsandsins
	name = "\improper Saints and Sins builder pack"
	desc = "A builder pack for hit collectable card game, Saints and Sins. This one will \
    help any aspiring deck builder get started."
	icon_state = "card_pack_saintsandsins"
	parentdeck = "saintsandsins"
	var/how_many_cards = 21 /// Boosters give less cards than the builder packs.

	var/list/card_heretics = list( /// Like MTG commander.
		new /datum/saintsandsins_cards("Lady of Holy Death", \
		"Health: 18. PASSIVE: Restore 1 health every time you deal Decay damage, up to max health."),
		new /datum/saintsandsins_cards("Galeria the Haruspex", \
		"Health: 15. ACTIVE: Block up to 2 damage of any kind for one round.")
	)
	var/list/card_spells = list( /// Keep these short and simple.
		new /datum/saintsandsins_cards("Summon Psychopomp", \
		"Deals 3 Decay damage to target for 3 rounds. KEY."),
		new /datum/saintsandsins_cards("Meteor Shower", \
		"Deals 5 Fire damage to ALL Heretics. KEY."),
		new /datum/saintsandsins_cards("Chastise", \
		"Deals 2 Holy damage to target. KEY."),
		new /datum/saintsandsins_cards("Rebuke", \
		"Nullifies one spell. REACTION."),
		new /datum/saintsandsins_cards("Blessed Invocation", \
		"Restores 5 health to caster. KEY."),
		new /datum/saintsandsins_cards("Vampyric Bite", \
		"Deals 2 Decay damage to target and restores 2 health to caster. KEY."),
		new /datum/saintsandsins_cards("Wicked Fountain", \
		"Deals 3 Water damage to target. KEY."),
		new /datum/saintsandsins_cards("Sick Air", \
		"Deals 1 Wind damage to target for 5 rounds. KEY."),
		new /datum/saintsandsins_cards("Flux of Humors", \
		"Restores 2 health to caster for 3 rounds. KEY."),
		new /datum/saintsandsins_cards("Earthquake", \
		"Deals 3 Earth damage to ALL Heretics for 3 rounds. KEY."),
		new /datum/saintsandsins_cards("Shifting Soil", \
		"Redirect spell to another Heretic. REACTION."),
		new /datum/saintsandsins_cards("Wind Tunnel", \
		"Redirects spell to its caster. REACTION."),
		new /datum/saintsandsins_cards("Awakening", \
		"Deals 2 Holy damage to ALL Heretics. REACTION.")
	)

/obj/item/weapon/pack/saintsandsins/New()
	..()
	var/datum/playingcard/P
	var/heretic_count = 0
	var/datum/saintsandsins_cards/randcard
	var/i
	var/card_front
	for(i=0, i<how_many_cards, i++)
		if(heretic_count == 0)
			randcard = pick(card_heretics)
			heretic_count = 1
			card_front = "saintsandsins_heretic"
		else
			randcard = pick(card_spells)
			card_front = "saintsandsins_spell"
		P = new()
		P.name = randcard.name
		P.desc = randcard.desc
		P.card_icon = card_front
		P.back_icon = "card_back_saintsandsins"
		cards += P

/**
 * Booster packs
 * Can have special cards not found in builder pack.
 */

/obj/item/weapon/pack/saintsandsins/booster
	name = "\improper Saints and Sins booster pack"
	desc = "A booster pack for hit collectable card game, Saints and Sins. This one is labeled 'Basic Witch Kit'."
	how_many_cards = 11
	card_heretics = list(
		new /datum/saintsandsins_cards("Lady of Holy Death", \
		"Health: 18. PASSIVE: Restore 1 health every time you deal Decay damage, up to max health."),
		new /datum/saintsandsins_cards("Dutiful Mephistopheles", \
		"Health: 20. PASSIVE: Reduces Decay damage received by 2 while increasing Holy by 3.")
	)

	card_spells = list( /// TO DO: Add more unique ones
		new /datum/saintsandsins_cards("Summon Psychopomp", \
		"Deals 3 Decay damage to target for 3 rounds. KEY."),
		new /datum/saintsandsins_cards("Chastise", \
		"Deals 2 Holy damage to target. KEY."),
		new /datum/saintsandsins_cards("Rebuke", \
		"Nullifies one spell. REACTION."),
		new /datum/saintsandsins_cards("Blessed Invocation", \
		"Restores 5 health to caster. KEY."),
		new /datum/saintsandsins_cards("Vampyric Bite", \
		"Deals 2 Decay damage to target and restores 2 health to caster. KEY."),
		new /datum/saintsandsins_cards("Wicked Fountain", \
		"Deals 3 Water damage to target. KEY."),
		new /datum/saintsandsins_cards("Flux of Humors", \
		"Restores 2 health to caster for 3 rounds. KEY."),
		new /datum/saintsandsins_cards("Earthquake", \
		"Deals 3 Earth damage to ALL Heretics for 3 rounds. KEY."),
		new /datum/saintsandsins_cards("Shifting Soil", \
		"Redirect spell to another Heretic. REACTION."),
		new /datum/saintsandsins_cards("Wind Tunnel", \
		"Redirects spell to its caster. REACTION.")
	)


/datum/saintsandsins_cards
	var/name
	var/desc

/datum/saintsandsins_cards/New(var/_name, var/_desc)
	..()
	name = _name
	desc = _desc