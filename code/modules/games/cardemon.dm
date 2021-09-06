/obj/item/weapon/deck/cardemon
	name = "\improper Cardemon deck box"
	desc = "A deck box for carrying your Cardemon cards. Fun for all ages!"
	icon_state = "card_holder_cardemon"
	decktype = "cardemon"
	decklimit = 20

/obj/item/weapon/pack/cardemon
	name = "cardemon booster pack"
	desc = "Finally! A children's card game in space!"
	icon_state = "card_pack_cardemon"
	parentdeck = "cardemon"

	var/list/nam = list("Death","Life","Plant","Leaf","Air","Earth","Fire","Water","Killer","Holy", "God", "Ordinary","Demon","Angel", "Plasteel", "Phoron", "Mad", "Insane", "Metal", "Steel", "Secret", "Science")
	var/list/nam2 = list("Carp", "Corgi", "Cat", "Mouse", "Octopus", "Lizard", "Monkey", "Plant", "Duck", "Demon", "Spider", "Bird", "Slime", "Sheep", "Fish", "Siffet", "Goose") /// Ultimate card: Science Goose. Honk!
	

/obj/item/weapon/pack/cardemon/New()
	..()
	var/datum/playingcard/P
	var/datum/cardemon_cards/randcard
	var/i
	for(i=0; i<5; i++)
		randcard = new(pick(nam), pick(nam2))
		P = new()
		P.name = randcard.name
		P.card_icon = randcard.card_icon
		P.back_icon = randcard.back_icon
		cards += P

/datum/cardemon_cards /// Separating in case someone wants to add more cardemon pack types like in saintsandsins_card.dm
	var/name
	var/card_icon
	var/back_icon

/datum/cardemon_cards/New(var/_nam, var/_nam2)
	var/rarity
	if(prob(10))
		if(prob(5))
			if(prob(5))
				rarity = "Plasteel"
			else
				rarity = "Platinum"
		else
			rarity = "Silver"
	
	name = "[_nam] [_nam2]"
	card_icon = "card_cardemon"
	if(rarity)
		name = "[rarity] [name]"
		card_icon += "_[rarity]"
	back_icon = "card_back_cardemon"