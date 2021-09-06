/obj/item/weapon/deck/spaceball
	name = "\improper Spaceball deck box"
	desc = "A deck box for carrying your Spaceball cards."
	icon_state = "card_holder"
	decktype = "spaceball"
	decklimit = 20

/obj/item/weapon/pack/spaceball
	name = "spaceball booster pack"
	desc = "Officially licensed to take your money."
	icon_state = "card_pack_spaceball"
	parentdeck = "spaceball"

/obj/item/weapon/pack/spaceball/New()
	..()
	var/datum/playingcard/P
	var/i
	var/datum/spaceball_cards/randcard
	for(i=0;i<5;i++)
		randcard = new()
		P = new()
		P.name = randcard.name
		P.card_icon = randcard.card_icon
		P.back_icon = randcard.back_icon
		cards += P

/datum/spaceball_cards /// Separating in case someone wants to add more cardemon pack types like in saintsandsins_card.dm
	var/name
	var/card_icon
	var/back_icon

/datum/spaceball_cards/New() /// This is all very silly but I don't care enough about sports to refluff it.
	var/year = 554 + text2num(time2text(world.timeofday, "YYYY"))
	if(prob(1))
		name = "Spaceball Jones, [year] Brickburn Galaxy Trekers"
		card_icon = "spaceball_jones"
	else
		var/language_type = pick(/datum/language/human,/datum/language/skrell,/datum/language/tajaran,/datum/language/unathi,/datum/language/diona_local) /// Keeping diona because it's hilarious, though.
		var/datum/language/L = new language_type()
		var/team = pick("Brickburn Galaxy Trekers","Mars Rovers", "Qerrbalak Saints", "Moghes Rockets", "Meralar Lightning", "[using_map.starsys_name] Vixens", "Euphoric-Earth Alligators")
		name = "[L.get_random_name(pick(MALE,FEMALE))], [year - rand(0,50)] [team]"
		card_icon = "spaceball_standard"
	back_icon = "card_back_spaceball"