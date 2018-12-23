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


/obj/structure/roulette/verb/spin(mob/user as mob)
	set name = "Spin Roulette Table"
	set category = "Object"
	set src in oview(1)

	if(spinning)
		to_chat(user,"The [src] is already spinning!")
		return
	else
		playsound(src, 'sound/effects/fingersnap.ogg', 50, 1)
		spinning = 1
		update_icon()
		sleep(20)
		//Win or lose?
		do_outcome()
		reset_wheel()
		update_icon()