/obj/machinery/vending/fuelstop
	name = "vehicle fuel stop"
	desc = "Time to top up the pimpin' rid-- electric car, I suppose."
	icon_state = "car"
	product_ads = "Top it up! Top it up!;Running out of car power is probably the worst thing during a car race.;Time to feed your bad boy."
	products = list(/obj/item/weapon/car_charger = 20,
	/obj/item/weapon/car_charger/advanced = 20,
	/obj/item/weapon/car_charger/hyper = 20,
	/obj/item/weapon/car_charger/full = 20) // Car chargers sold only.

	prices = list(/obj/item/weapon/car_charger = 200,
	/obj/item/weapon/car_charger/advanced = 300,
	/obj/item/weapon/car_charger/hyper = 450,
	/obj/item/weapon/car_charger/full = 600)


	vendor_department = "Emergency and Maintenance"

/obj/vehicle/car/attackby(obj/item/weapon/car_charger/W as obj, mob/user as mob)
	..()
	var/obj/item/weapon/cell/ch_cell = get_cell() //get the current cell
	if(ch_cell)
		if(istype(W, /obj/item/weapon/car_charger))
			if(ch_cell.charge == ch_cell.maxcharge)
				to_chat(user, "<b>You refrain from using [W] as the [src] is already fully charged.</b>")
				return

			if(W.full)
				ch_cell.give(ch_cell.maxcharge)
			else
				ch_cell.give(W.charge_amt)
			playsound(loc, 'sound/effects/turret/move2.wav', 5, 1, 5)
			to_chat(user, "You insert the [W] - [src]'s charge is now <b>[cell? round(cell.percent(), 0.01) : 0]%.</b>")
			update_icon()
			qdel(W)

// If there's no cell, that's too bad.
	else
		to_chat(user, "There doesn't seem to be a battery in this car.")

/obj/item/weapon/car_charger
	name = "cheap porta-charger"
	desc = "A disposable charger that refuels your car. So electric, it would speak in italics if it could."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "migniter-spark"

	var/charge_amt = 10000 // How much it charges your car by.
	var/full

/obj/item/weapon/car_charger/examine(mob/user)
	..()
	if(full)
		user << "It will charge your car's battery to the full amount."
	else
		user << "It adds <b>[charge_amt]mAh</b> to your car's battery."

/obj/item/weapon/car_charger/advanced
	name = "advanced porta-charger"
	charge_amt = 20000

/obj/item/weapon/car_charger/hyper
	name = "hyper porta-charger"
	charge_amt = 30000

/obj/item/weapon/car_charger/full
	name = "full porta-charger"
	full = 1