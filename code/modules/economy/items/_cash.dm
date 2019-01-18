/obj/item/stack/cash
	origin_tech = null
	icon = 'icons/obj/items.dmi'
	icon_state = "spacecash1"
	force = 0
	throwforce = 0
	throw_speed = 1
	throw_range = 2
	w_class = ITEMSIZE_SMALL
	max_amount = 10000
	singular_name = GALACTIC_CURRENCY_SINGULAR
	stacktype = /obj/item/stack/cash

/obj/item/stack/cash/update_icon()
	cut_overlays()
	name = "[amount] [amount > 1? GALACTIC_CURRENCY : GALACTIC_CURRENCY_SINGULAR]"
	if(worth in list(1000,500,200,100,50,20,10,1))
		icon_state = "spacecash[worth]"
		desc = "It's worth [CASH_AMOUNT_TEXT(amount)]."
		return
	desc = "They are worth [CASH_AMOUNT_TEXT(amount)]."

	var/sum = src.worth
	var/num = 0
	for(var/i in list(1000,500,200,100,50,20,10,1))
		while(sum >= i && num < 50)
			sum -= i
			num++
			var/image/banknote = image('icons/obj/items.dmi', "spacecash[i]")
			var/matrix/M = matrix()
			M.Translate(rand(-6, 6), rand(-4, 8))
			M.Turn(pick(-45, -27.5, 0, 0, 0, 0, 0, 0, 0, 27.5, 45))
			banknote.transform = M
			add_overlay(banknote)
	if(num == 0) // Less than one thaler, let's just make it look like 1 for ease
		var/image/banknote = image('icons/obj/items.dmi', "spacecash1")
		var/matrix/M = matrix()
		M.Translate(rand(-6, 6), rand(-4, 8))
		M.Turn(pick(-45, -27.5, 0, 0, 0, 0, 0, 0, 0, 27.5, 45))
		banknote.transform = M
		add_overlay(banknote)

/obj/item/stack/cash/c1
	name = "1 Thaler"
	icon_state = "spacecash1"
	desc = "It's worth 1 credit."
	worth = 1

/obj/item/stack/cash/c10
	name = "10 Thaler"
	icon_state = "spacecash10"
	desc = "It's worth 10 Thalers."
	worth = 10

/obj/item/stack/cash/c20
	name = "20 Thaler"
	icon_state = "spacecash20"
	desc = "It's worth 20 Thalers."
	worth = 20

/obj/item/stack/cash/c50
	name = "50 Thaler"
	icon_state = "spacecash50"
	desc = "It's worth 50 Thalers."
	worth = 50

/obj/item/stack/cash/c100
	name = "100 Thaler"
	icon_state = "spacecash100"
	desc = "It's worth 100 Thalers."
	worth = 100

/obj/item/stack/cash/c200
	name = "200 Thaler"
	icon_state = "spacecash200"
	desc = "It's worth 200 Thalers."
	worth = 200

/obj/item/stack/cash/c500
	name = "500 Thaler"
	icon_state = "spacecash500"
	desc = "It's worth 500 Thalers."
	worth = 500

/obj/item/stack/cash/c1000
	name = "1000 Thaler"
	icon_state = "spacecash1000"
	desc = "It's worth 1000 Thalers."
	worth = 1000

/proc/spawn_money(amount, atom/loc, mob/living/carbon/human/H)
	var/obj/item/stack/cash/C = new(loc, amount)
	if(istype(human_user) && !human_user.get_active_hand())
		human_user.put_in_hands(SC)

/obj/item/stack/cash/ewallet
	name = "charge card"
	icon_state = "efundcard"
	desc = "A card that holds an amount of money."
	stacktype = null
	var/owner_name = "" //So the ATM can set it so the EFTPOS can put a valid name on transactions.
	allow_user_split = FALSE
	no_variants = TRUE

/obj/item/stack/cash/ewallet/examine(mob/user)
	. = ..(user)
	if(get_dist(user, src) <= 2)
		to_chat(user, "Charge card's owner: [owner_name].")

/obj/item/stack/cash/ewallet/zero_check()
	return amount <= 0			//Do not auto qdel.
