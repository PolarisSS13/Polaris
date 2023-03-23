/obj/item/deck/cardemon
	name = "\improper Cardemon deck box"
	desc = "A deck box for carrying your Cardemon cards. Fun for all ages!"
	icon_state = "card_holder_cardemon"
	decktype = /datum/playingcard/cardemon
	decklimit = 20

/obj/item/pack/cardemon
	name = "cardemon booster pack"
	desc = "Finally! A children's card game in space!"
	icon_state = "card_pack_cardemon"
	decktype = /datum/playingcard/cardemon

/obj/item/pack/cardemon/Initialize()
	. = ..()
	var/datum/playingcard/cardemon/P
	var/i
	for(i=0; i<5; i++)
		P = new()
		cards += P

/datum/playingcard/cardemon

/datum/playingcard/cardemon/New()

	var/list/static/nam = list("Death","Life","Plant","Leaf","Air","Earth","Fire","Water","Killer","Holy", "God", "Ordinary","Demon","Angel", "Plasteel", "Phoron", "Mad", "Insane", "Metal", "Steel", "Secret", "Science")
	var/list/static/nam2 = list("Carp", "Corgi", "Cat", "Mouse", "Octopus", "Lizard", "Monkey", "Plant", "Duck", "Demon", "Spider", "Bird", "Slime", "Sheep", "Fish", "Siffet", "Goose")

	var/rarity = pick("",
			prob(10); "Silver",
			prob(0.5); "Platinum",
			prob(0.025); "Plasteel"
		)

	name = "[pick(nam)] [pick(nam2)]"
	card_icon = "card_cardemon"
	if(rarity)
		name = "[rarity] [name]"
		card_icon += "_[rarity]"
	back_icon = "card_back_cardemon"
