/datum/playingcard
	var/name = "playing card"
	var/desc
	var/card_icon = "card_back"
	var/back_icon = "card_back"

/obj/item/weapon/deck
	w_class = ITEMSIZE_SMALL
	icon = 'icons/obj/playing_cards.dmi'
	var/list/cards = list()
	var/cooldown = 0 // to prevent spam shuffle
	var/decktype = "playingcards" /// Should match parentdeck for any related card packs.
	var/decklimit = null /// If we want a maximum to how many cards the deck can hold. 

/* Not sure if this was ever functional?
/obj/item/weapon/deck/holder
	name = "card box"
	desc = "A small leather case to show how classy you are compared to everyone else."
	icon_state = "card_holder"
*/
/obj/item/weapon/deck/cards
	name = "deck of cards"
	desc = "A simple deck of playing cards."
	icon_state = "deck"
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'

/obj/item/weapon/deck/cards/New()
	..()
	var/datum/playingcard/P
	for(var/suit in list("spades","clubs","diamonds","hearts"))

		var/colour
		if(suit == "spades" || suit == "clubs")
			colour = "black_"
		else
			colour = "red_"

		for(var/number in list("ace","two","three","four","five","six","seven","eight","nine","ten"))
			P = new()
			P.name = "[number] of [suit]"
			P.card_icon = "[colour]num"
			P.back_icon = "card_back"
			cards += P

		for(var/number in list("jack","queen","king"))
			P = new()
			P.name = "[number] of [suit]"
			P.card_icon = "[colour]col"
			P.back_icon = "card_back"
			cards += P

	for(var/i = 0, i<2, i++)
		P = new()
		P.name = "joker"
		P.card_icon = "joker"
		cards += P

/obj/item/weapon/deck/attackby(obj/O as obj, mob/user as mob)
	if(istype(O,/obj/item/weapon/hand))
		var/obj/item/weapon/hand/H = O
		if(decklimit && (decklimit <= cards.len))
			to_chat(user,"<span class='warning'>This deck is full!</span>")
			return
		if(H.parentdeck == src.decktype)
			for(var/datum/playingcard/P in H.cards)
				if(decklimit && (decklimit <= cards.len)) /// Stop placing the cards
					to_chat(user,"<span class='notice'>You place some cards on the bottom of \the [src]</span>.")
					H.update_icon()
					return
				H.cards -= P	
				cards += P
			qdel(H)
			to_chat(user,"<span class='notice'>You place your cards on the bottom of \the [src]</span>.")
			return
		else
			to_chat(user,"<span class='warning'>You can't mix cards from other decks!</span>")
			return
	..()

/obj/item/weapon/deck/attack_hand(mob/user as mob)
	var/mob/living/carbon/human/H = user
	if(istype(src.loc, /obj/item/weapon/storage) || src == H.r_store || src == H.l_store || src.loc == user) // so objects can be removed from storage containers or pockets. also added a catch-all, so if it's in the mob you'll pick it up.
		..()
	else // but if they're not, or are in your hands, you can still draw cards.
		draw_card()

/obj/item/weapon/deck/verb/draw_card()

	set category = "Object"
	set name = "Draw"
	set desc = "Draw a card from a deck."
	set src in view(1)

	var/mob/living/carbon/user = usr

	if(usr.stat || !Adjacent(usr)) return

	if(user.hands_are_full()) // Safety check lest the card disappear into oblivion
		to_chat(user,"<span class='notice'>Your hands are full!</span>")
		return

	if(!istype(usr,/mob/living/carbon))
		return

	if(!cards.len)
		to_chat(user,"<span class='notice'>There are no cards in the deck.</span>")
		return

	var/obj/item/weapon/hand/H = user.get_active_hand(/obj/item/weapon/hand)
	if(H && !(H.parentdeck == src.decktype))
		to_chat(user,"<span class='warning'>You can't mix cards from different decks!</span>")
		return

	if(!H)
		H = new(get_turf(src))
		user.put_in_hands(H)

	if(!H || !user) return

	var/datum/playingcard/P = cards[1]
	H.cards += P
	cards -= P
	H.parentdeck = src.decktype
	H.update_icon()
	user.visible_message("<span class='notice'>\The [user] draws a card.</span>")
	to_chat(user,"<span class='notice'>It's the [P].</span>")

/obj/item/weapon/deck/verb/find_card() /// A bit of copypasta code but I'm not sure how to avoid that.
	set category = "Object"
	set name = "Find Card"
	set desc = "Find a specific card from a deck."
	set src in view(1)

	var/mob/living/carbon/user = usr

	if(usr.stat || !Adjacent(usr)) return

	if(user.hands_are_full())
		to_chat(user,"<span class='notice'>Your hands are full!</span>")
		return

	if(!istype(usr,/mob/living/carbon))
		return

	if(!cards.len)
		to_chat(user,"<span class='notice'>There are no cards in the deck.</span>")
		return

	var/obj/item/weapon/hand/H = user.get_active_hand(/obj/item/weapon/hand)
	if(H && !(H.parentdeck == src.decktype))
		to_chat(user,"<span class='warning'>You can't mix cards from different decks!</span>")
		return

	var/list/pickablecards = list()
	for(var/datum/playingcard/P in cards)
		if(!islist(pickablecards[P.name]))
			pickablecards[P.name] += list()
		
		pickablecards[P.name] += P

	var/pickedcard = input("Which card do you want to remove from the deck?")	as null|anything in pickablecards

	if(!pickedcard || !LAZYLEN(pickablecards[pickedcard]) || !usr || !src) return

	var/datum/playingcard/card = pick(pickablecards[pickedcard])

	user.visible_message("<span class = 'notice'>\The [user] searches the [src] for a card.</span>") /// To help catch any cheaters. 
	H = new(get_turf(src))
	user.put_in_hands(H)
	H.cards += card
	cards -= card
	H.parentdeck = src.decktype
	H.update_icon()


/obj/item/weapon/deck/verb/deal_card()

	set category = "Object"
	set name = "Deal"
	set desc = "Deal a card from a deck."
	set src in view(1)

	if(usr.stat || !Adjacent(usr)) return

	if(!cards.len)
		to_chat(usr,"<span class='notice'>There are no cards in the deck.</span>")
		return

	var/list/players = list()
	for(var/mob/living/player in viewers(3))
		if(!player.stat)
			players += player
	//players -= usr

	var/mob/living/M = input("Who do you wish to deal a card?") as null|anything in players
	if(!usr || !src || !M) return

	deal_at(usr, M, 1)

/obj/item/weapon/deck/verb/cheater_deal() /// By request. 
	set category = "Object"
	set name = "Deal From Bottom"
	set desc = "Deal a card from the bottom of a deck, like a cheater."
	set src in view(1)

	if(!cards.len)
		to_chat(usr,"<span class='notice'>There are no cards in the deck.</span>")
		return
	
	var/list/players = list()
	for(var/mob/living/player in viewers(3))
		if(!player.stat)
			players += player
	var/mob/living/M = input("Who do you wish to deal a card?") as null|anything in players
	if(!usr || !src || !M) return

	if(prob(30))
		usr.visible_message("<span class = 'warning'>\The [usr] dealt from the bottom of the deck!</span>")

	moveElement(cards, cards.len, 1) /// Moves the last card to the front before dealing it.
	deal_at(usr, M, 1)

/obj/item/weapon/deck/verb/deal_card_multi()

	set category = "Object"
	set name = "Deal Multiple Cards"
	set desc = "Deal multiple cards from a deck."
	set src in view(1)

	if(usr.stat || !Adjacent(usr)) return

	if(!cards.len)
		to_chat(usr,"<span class='notice'>There are no cards in the deck.</span>")
		return

	var/list/players = list()
	for(var/mob/living/player in viewers(3))
		if(!player.stat)
			players += player
	//players -= usr
	var/maxcards = max(min(cards.len,10),1)
	var/dcard = input("How many card(s) do you wish to deal? You may deal up to [maxcards] cards.") as num
	if(dcard > maxcards)
		return
	var/mob/living/M = input("Who do you wish to deal [dcard] card(s)?") as null|anything in players
	if(!usr || !src || !M) return

	deal_at(usr, M, dcard)

/obj/item/weapon/deck/proc/deal_at(mob/user, mob/target, dcard) // Take in the no. of card to be dealt
	var/obj/item/weapon/hand/H = new(get_step(user, user.dir))
	var/i
	for(i = 0, i < dcard, i++)
		H.cards += cards[1]
		cards -= cards[1]
		H.parentdeck = src.decktype
		H.concealed = 1
		H.update_icon()
	if(user==target)
		var/datum/gender/TU = gender_datums[user.get_visible_gender()]
		user.visible_message("<span class = 'notice'>\The [user] deals [dcard] card(s) to [TU.himself].</span>")
	else
		user.visible_message("<span class = 'notice'>\The [user] deals [dcard] card(s) to \the [target].</span>")
	H.throw_at(get_step(target,target.dir),10,1,H)


/obj/item/weapon/hand/attackby(obj/O as obj, mob/user as mob)
	if(cards.len == 1 && istype(O, /obj/item/weapon/pen))
		var/datum/playingcard/P = cards[1]
		if(P.name != "Blank Card")
			to_chat(user,"<span class = 'notice'>You cannot write on that card.</span>")
			return
		var/cardtext = sanitize(input(user, "What do you wish to write on the card?", "Card Editing") as text|null, MAX_PAPER_MESSAGE_LEN)
		if(!cardtext)
			return
		P.name = cardtext
		// SNOWFLAKE FOR CAG, REMOVE IF OTHER CARDS ARE ADDED THAT USE THIS.
		P.card_icon = "cag_white_card"
		update_icon()
	else if(istype(O,/obj/item/weapon/hand))
		var/obj/item/weapon/hand/H = O
		if(H.parentdeck == src.parentdeck) // Prevent cardmixing
			for(var/datum/playingcard/P in cards)
				H.cards += P
			H.concealed = src.concealed
			user.drop_from_inventory(src)
			qdel(src)
			H.update_icon()
			return
		else
			to_chat(user,"<span class = 'notice'>You cannot mix cards from other decks!</span>")
			return

	..()

/obj/item/weapon/deck/attack_self()
	shuffle()


/obj/item/weapon/deck/verb/verb_shuffle()
	set category = "Object"
	set name = "Shuffle"
	set desc = "Shuffle the cards in the deck."
	set src in view(1)
	shuffle()

/obj/item/weapon/deck/proc/shuffle()
	var/mob/living/user = usr
	if (cooldown < world.time - 10) // 15 ticks cooldown
		var/list/newcards = list()
		while(cards.len)
			var/datum/playingcard/P = pick(cards)
			newcards += P
			cards -= P
		cards = newcards
		user.visible_message("<span class = 'notice'>\The [user] shuffles [src].</span>")
		playsound(src, 'sound/items/cardshuffle.ogg', 50, 1)
		cooldown = world.time
	else
		return


/obj/item/weapon/deck/MouseDrop(mob/user as mob) // Code from Paper bin, so you can still pick up the deck
	if((user == usr && (!( usr.restrained() ) && (!( usr.stat ) && (usr.contents.Find(src) || in_range(src, usr))))))
		if(!istype(usr, /mob/living/simple_mob))
			if( !usr.get_active_hand() )		//if active hand is empty
				var/mob/living/carbon/human/H = user
				var/obj/item/organ/external/temp = H.organs_by_name["r_hand"]

				if (H.hand)
					temp = H.organs_by_name["l_hand"]
				if(temp && !temp.is_usable())
					to_chat(user,"<span class='notice'>You try to move your [temp.name], but cannot!</span>")
					return

				to_chat(user,"<span class='notice'>You pick up [src].</span>")
				user.put_in_hands(src)

	return

/obj/item/weapon/deck/verb_pickup() // Snowflaked so pick up verb work as intended
	var/mob/user = usr
	if((istype(user) && (!( usr.restrained() ) && (!( usr.stat ) && (usr.contents.Find(src) || in_range(src, usr))))))
		if(!istype(usr, /mob/living/simple_mob))
			if( !usr.get_active_hand() )		//if active hand is empty
				var/mob/living/carbon/human/H = user
				var/obj/item/organ/external/temp = H.organs_by_name["r_hand"]

				if (H.hand)
					temp = H.organs_by_name["l_hand"]
				if(temp && !temp.is_usable())
					to_chat(user,"<span class='notice'>You try to move your [temp.name], but cannot!</span>")
					return

				to_chat(user,"<span class='notice'>You pick up [src].</span>")
				user.put_in_hands(src)
	return

/obj/item/weapon/pack/  /// Put new packs in random spawner in code/game/objects/random/misc.dm
	name = "Card Pack"
	desc = "For those with disposible income."

	icon_state = "card_pack"
	icon = 'icons/obj/playing_cards.dmi'
	w_class = ITEMSIZE_TINY
	var/list/cards = list()
	var/parentdeck = null // This variable is added here so that card pack dependent card can be mixed together by defining a "parentdeck" for them
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'


/obj/item/weapon/pack/attack_self(var/mob/user as mob)
	user.visible_message("<span class ='danger'>[user] rips open \the [src]!</span>")
	var/obj/item/weapon/hand/H = new()

	H.cards += cards
	H.parentdeck = src.parentdeck
	cards.Cut();
	user.drop_item()
	qdel(src)

	H.update_icon()
	user.put_in_active_hand(H)

/obj/item/weapon/hand
	name = "hand of cards"
	desc = "Some playing cards."
	icon = 'icons/obj/playing_cards.dmi'
	icon_state = "empty"
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'
	w_class = ITEMSIZE_TINY

	var/concealed = 0
	var/list/cards = list()
	var/parentdeck = null

/obj/item/weapon/hand/verb/discard()

	set category = "Object"
	set name = "Discard"
	set desc = "Place (a) card(s) from your hand in front of you."

	var/i
	var/maxcards = min(cards.len,5) // Maximum of 5 cards at once
	var/discards = input("How many cards do you want to discard? You may discard up to [maxcards] card(s)") as num
	if(discards > maxcards)
		return
	for	(i = 0;i < discards;i++)
		var/list/to_discard = list()
		for(var/datum/playingcard/P in cards)
			to_discard[P.name] = P
		var/discarding = input("Which card do you wish to put down?") as null|anything in to_discard

		if(!discarding || !to_discard[discarding] || !usr || !src) return

		var/datum/playingcard/card = to_discard[discarding]
		to_discard.Cut()

		var/obj/item/weapon/hand/H = new(src.loc)
		H.cards += card
		cards -= card
		H.concealed = 0
		H.parentdeck = src.parentdeck
		H.update_icon()
		src.update_icon() /// Calls for qdel if no cards
		usr.visible_message("<span class = 'notice'>\The [usr] plays \the [discarding].</span>")
		H.loc = get_turf(usr)
		H.Move(get_step(usr,usr.dir))

/obj/item/weapon/hand/attack_self(var/mob/user as mob)
	concealed = !concealed
	update_icon()
	user.visible_message("<span class = 'notice'>\The [user] [concealed ? "conceals" : "reveals"] their hand.</span>")

/obj/item/weapon/hand/examine(mob/user)
	. = ..()
	if((!concealed) && cards.len)
		. += "It contains: "
		for(var/datum/playingcard/P in cards)
			if(!P.desc)
				. += "\The [P.name]."
			else
				. += "[P.name]: [P.desc]"

/obj/item/weapon/hand/verb/Removecard()

	set category = "Object"
	set name = "Remove card"
	set desc = "Remove a card from the hand."
	set src in view(1)

	var/mob/living/carbon/user = usr

	if(user.stat || !Adjacent(user)) return

	if(user.hands_are_full()) // Safety check lest the card disappear into oblivion
		to_chat(usr,"<span class='danger'>Your hands are full!</span>")
		return

	var/list/pickablecards = list() /// Make it so duplicates don't cause runtimes
	for(var/datum/playingcard/P in cards)
		if(!islist(pickablecards[P.name]))
			pickablecards[P.name] += list()
		
		pickablecards[P.name] += P

	var/pickedcard = input("Which card do you want to remove from the hand?")	as null|anything in pickablecards

	if(!pickedcard || !LAZYLEN(pickablecards[pickedcard]) || !usr || !src) return

	var/datum/playingcard/card = pick(pickablecards[pickedcard])

	var/obj/item/weapon/hand/H = new(get_turf(src))
	user.put_in_hands(H)
	H.cards += card
	cards -= card
	H.parentdeck = src.parentdeck
	H.concealed = src.concealed
	H.update_icon()
	src.update_icon()

	if(!cards.len)
		qdel(src)
	return

/obj/item/weapon/hand/update_icon(var/direction = 0)

	if(!cards.len)
		qdel(src)
		return
	else if(cards.len > 1)
		name = "hand of cards"
		desc = "Some playing cards."
	else
		name = "playing card"
		desc = "A playing card."

	overlays.Cut()


	if(cards.len == 1)
		var/datum/playingcard/P = cards[1]
		var/image/I = new(src.icon, (concealed ? "[P.back_icon]" : "[P.card_icon]") )
		I.pixel_x += (-5+rand(10))
		I.pixel_y += (-5+rand(10))
		overlays += I
		return

	var/offset = max(FLOOR(20/cards.len, 1), 1) /// Keeps +20 cards from shifting back into one.

	var/matrix/M = matrix()
	if(direction)
		switch(direction)
			if(NORTH)
				M.Translate( 0,  0)
			if(SOUTH)
				M.Translate( 0,  4)
			if(WEST)
				M.Turn(90)
				M.Translate( 3,  0)
			if(EAST)
				M.Turn(90)
				M.Translate(-2,  0)
	var/i = 0
	for(var/datum/playingcard/P in cards)
		var/image/I = new(src.icon, (concealed ? "[P.back_icon]" : "[P.card_icon]") )
		//I.pixel_x = origin+(offset*i)
		if(i>20)
			return
		switch(direction)
			if(SOUTH)
				I.pixel_x = 8-(offset*i)
			if(WEST)
				I.pixel_y = -6+(offset*i)
			if(EAST)
				I.pixel_y = 8-(offset*i)
			else
				I.pixel_x = -7+(offset*i)
		I.transform = M
		overlays += I
		i++

/obj/item/weapon/hand/dropped(mob/user as mob)
	if(locate(/obj/structure/table, loc))
		src.update_icon(user.dir)

/obj/item/weapon/hand/pickup(mob/user as mob)
	..()
	src.update_icon()
