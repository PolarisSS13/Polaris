obj/item/weapon/material/twohanded/chainsaw
	base_name = "Chainsaw"
	desc = "Vroom vroom."
	base_icon = "chainsaw"
	var/on = 0
	var/max_fuel = 30
	w_class = ITEMSIZE_LARGE
	slot_flags = SLOT_BACK
	unwielded_force_divisor = 0.25
	force_divisor = 0.5
	dulled_divisor = 0.6
	sharp = 1
	edge = 1
	w_class = ITEMSIZE_LARGE
	slot_flags = SLOT_BACK
	force_wielded = 35

obj/item/weapon/material/twohanded/chainsaw/New()
	var/datum/reagents/R = new/datum/reagents(max_fuel)
	reagents = R
	R.my_atom = src
	R.add_reagent("fuel", max_fuel)
	..()

obj/item/weapon/material/twohanded/chainsaw/proc/turnOn()
	if(on) return

	visible_message("You start pulling the string on \the [src].", "[usr] starting pulling the string on the [src].")

	if(max_fuel <= 0)
		if(do_after(usr, 15))
			to_chat(usr, "\The [src] won't start!")
		else
			to_chat(usr, "You fumble with the string.")
	else if(!wielded)
		to_chat(usr, "You need both hands to start the chainsaw!")
	else
		if(do_after(usr, 15))
			visible_message("You start \the [src] up with a loud grinding!", "[usr] starts \the [src] up with a loud grinding!")
			attack_verb = list("shreds", "rips", "tears")
			on = 1
		else
			to_chat(usr, "You fumble with the string.")

obj/item/weapon/material/twohanded/chainsaw/proc/turnOff()
	if(!on) return
	to_chat(usr, "You switch the gas nozzle on the chainsaw, turning it off.")
	attack_verb = list("bluntly hit", "beat", "knocked")
	on = 0

obj/item/weapon/material/twohanded/chainsaw/attack_self(mob/user as mob)
	if(!on)
		turnOn()
	else
		turnOff()

obj/item/weapon/material/twohanded/chainsaw/afterattack(atom/A as mob|obj|turf|area, mob/user as mob, proximity)
	if(!proximity) return
	..()
	if(A && wielded && on)
		if(istype(A,/obj/structure/window))
			var/obj/structure/window/W = A
			W.shatter()
		else if(istype(A,/obj/structure/grille))
			new /obj/structure/grille/broken(A.loc)
			new /obj/item/stack/rods(A.loc)
			qdel(A)
		else if(istype(A,/obj/effect/plant))
			var/obj/effect/plant/P = A
			qdel(P) //Plant isn't surviving that. At all

obj/item/weapon/material/twohanded/chainsaw/process()
	update_icon()

	if(!on) return

	if(on)
		if(get_fuel() > 0)
			reagents.remove_reagent("fuel", 0.5)
		if(get_fuel() <= 0)
			to_chat(usr, "\The [src] sputters to a stop!")
			on = !on

obj/item/weapon/material/twohanded/chainsaw/proc/get_fuel()
	reagents.get_reagent_amount("fuel")

obj/item/weapon/material/twohanded/chainsaw/examine(mob/user)
	if(..(user,0))
		if(max_fuel)
			to_chat(usr, "<span class = 'notice'>The [src] feels like it contains roughtly [get_fuel()] units of fuel left.</span>")

obj/item/weapon/material/twohanded/chainsaw/suicide_act(mob/user)
	to_chat(viewers(user), "<span class='danger'>[user] is laying down and pulling the chainsaw into \him, it looks like \he's trying to commit suicide!</span>")
	return(BRUTELOSS)