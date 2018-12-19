/obj/item/weapon/roulette/chip
	name = "black roulette chip"
	icon = 'icons/obj/items.dmi'
	icon_state = "coin"
	var/chip_color = "black"
	var/chip_worth = 100
	color = "black"

/obj/item/weapon/roulette/chip/red
	name = "red roulette chip"
	chip_color = "red"
	color = "red"
	chip_worth = 5


/obj/structure/roulette
	name = "roulette table"
	desc = "A large green table that has a spinner on it. If you pick a number and it lands on that, you will win chips. Or something."
	icon = 'icons/obj/gambling/roulette.dmi'
	icon_state = "roulette"
	density = 1
	anchored = 1
	bounds = "64,32"
	var/highest_number = 36
	var/win_number
	var/win_color
	var/list/possible_win_colors = list("black", "red")
	var/spinning = 0
	var/list/current_bets = list()
	var/list/current_betters = list()
	var/can_bet = 1
	var/win



/obj/structure/roulette/initialize()
	reset_wheel()
	..()

/obj/structure/roulette/proc/reset_wheel()
	spinning = 0
	//reset it for next round.
	win_color = pick(possible_win_colors)
	win_number = rand(1, highest_number)

/obj/structure/roulette/proc/do_outcome()
	src.visible_message("\The [src]'s ball clatters to a halt on the <font color=[win_color]><span>[win_color] [win_number]</span></font>.","You hear a rattling that slowly comes to a stop.")

/obj/structure/roulette/update_icon()
	if(spinning)
		icon_state = "[initial(icon_state)]_spin"
	else
		icon_state = initial(icon_state)

/obj/structure/roulette/attackby(mob/user as mob, obj/item/weapon/roulette/chip/I as obj)
	if(spinning)
		to_chat(user, "The [src] is still spinning!")
		return

	if(istype(I,/obj/item/weapon/roulette/chip))
		if(!can_bet)
			to_chat(user, "<span class='notice'>[src] can't be betted on right now.</span>")
			return
		else
			var/BET = input("What number would you place to place bets with on the [I]? Your [I] is worth [I.chip_worth] and will earn you twice the amount if it win by matching the same color and number.", "Place Bets", 1) as num|null
			if(BET)
				if(spinning)
					to_chat(user, "The [src] is spinning too fast for you to place bets on it!")
					return
				else
					user.visible_message("[user] places bets the <b>number [BET]</b> on the [src] with the <b>[I]</b>.", "You place a bets on <b>[BET]</b> on the \the <b>[src]</b> with the [I].")
					current_bets += BET
					qdel(I)


	else
		to_chat(user, "You need a roulette chip to play.")
		return


/obj/structure/roulette/verb/spin(mob/user as mob)
	set name = "Spin Roulette Table"
	set category = "Object"
	set src in oview(1)

	if(spinning)
		to_chat(user, "The [src] is already spinning!")
	else
		playsound(src, 'sound/effects/fingersnap.ogg', 50, 1)
		spinning = 1
		update_icon()
		sleep(20)
		//Win or lose?
		do_outcome()
		reset_wheel()
		update_icon()