/obj/item/weapon/deck/saintsandsins
	name = "\improper Saints and Sins deck box"
	desc = "A deck box for the hit collectable card game, Saints and Sins."
	icon_state = "card_holder" /// Change later
	decktype = "saintsandsins"
    
	var/list/heretics = list()
	var/list/spells = list()

/obj/item/weapon/pack/saintsandsins
	name = "\improper Saints and Sins builder pack"
	desc = "A builder pack for hit collectable card game, Saints and Sins. This one will \
    help any aspiring deck builder get started."
	icon_state = "card_pack_cardemon"
	parentdeck = "saintsandsins"

	var/list/card_heretics = list( /// Like MTG commander
		new /datum/saintsandsins_cards("Lady of Holy Death", \
		"Health: 12. Ability goes here."),
		new /datum/saintsandsins_cards("Galeria the Haruspex", \
		"Health: 7. Ability goes here.")
	)
	var/list/card_spells = list(
		new /datum/saintsandsins_cards("Firebolt", \
		"Deals 3 damage to a Heretic on your turn for the next three rounds."),
		new /datum/saintsandsins_cards("Defense", \
		"Shields the next five points of damage.")
	)

/obj/item/weapon/pack/saintsandsins/New()
	..()
	var/datum/playingcard/P
	var/heretic_count = 0
	var/datum/saintsandsins_cards/randcard
	var/i
	for(i=0, i<11, i++)
		if(heretic_count == 0)
			randcard = pick(card_heretics)
			heretic_count = 1
		else
			randcard = pick(card_spells)
		P = new()
		P.name = randcard.name
		P.desc = randcard.desc
		cards += P


/obj/item/weapon/pack/saintsandsins/booster
	name = "\improper Saints and Sins booster pack"
	desc = "A booster pack for hit collectable card game, Saints and Sins. This one is labeled 'Basic Witch Kit'."


/datum/saintsandsins_cards
	var/name
	var/desc

/datum/saintsandsins_cards/New(var/_name, var/_desc)
	..()
	name = _name
	desc = _desc