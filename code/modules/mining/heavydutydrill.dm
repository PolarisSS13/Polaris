/obj/item/weapon/pickaxe/heavydutydrill //AEIOU project
	name = "heavy duty drill"
	desc = "Vroom vroom."
	icon = 'icons/obj/mining.dmi'
	icon_state = "thdd0"
	item_state = "chainsaw0"
	w_class = ITEMSIZE_LARGE
	slot_flags = SLOT_BACK
	digspeed = 120			//VERY SLOW. Digspeed is a delay. Lower is better.
	slowdown = 1			//Teshari nerf and hardy trait buff
	matter = list(DEFAULT_WALL_MATERIAL = 3750)
	var/on = 0				//Is the engine running
	var/open = 0			//Is the maintenance panel open
	var/max_fuel = 500		//Amount of fuel. It is evident.
	var/active_force = 35	//How much damage it does when active.
	var/inactive_force = 10

	var/enginefailed = 0	//Is the engine currently stuck. If 1, it needs to be cleared.
	var/fuel_consumed = 0	//placeholder. This is used for fuel consumption calculations.
	var/missing_part = 0	//Ugly placeholder. 

	var/drill_bit = null	//The actual drill in contact with the surface.
	var/engine = null		//This is the engine that powers the drill. Better engines are faster.
	var/airfilter = null 	//This will determine the engine fuel efficiency.

	var/fuel_efficiency = 1	//This is the var which determines how much you consume fuel.
	var/jam_chance = 2		//This is determined by the engine level.
	var/active_digspeed = 1 //Determined by the drill bit

/obj/item/weapon/pickaxe/heavydutydrill/New()
	var/datum/reagents/R = new/datum/reagents(max_fuel)
	reagents = R
	R.my_atom = src
	R.add_reagent("fuel", max_fuel)
	processing_objects |= src

	drill_bit = new/obj/item/drillparts/drillbit(src)
	engine = new/obj/item/drillparts/drillengine(src)
	airfilter = new/obj/item/drillparts/drillairfilters(src)

	update_stats()	//Get the parts values and shit.
	update_icon()
	..()

/obj/item/weapon/pickaxe/heavydutydrill/Destroy()
	processing_objects -= src
	if(reagents)
		qdel(reagents)
	..()

/obj/item/weapon/pickaxe/heavydutydrill/proc/turnOn(mob/user as mob)
	if(on)
		return

	if(!drill_bit)
		to_chat(user, "There is no drill tip.")
		missing_part = 1
	if(!engine)
		to_chat(user, "There is no engine to run the drill.")
		missing_part = 1
	if(!airfilter)
		to_chat(user, "There is no filters to run the drill.")
		missing_part = 1

	if(missing_part)
		to_chat(user, "The drill can't function in it's current state.")
		missing_part = 0
		return

	if(enginefailed)
		unjam(user)
		return

	visible_message("You start pulling the string on \the [src].", "[usr] starts pulling the string on \the [src].")

	if(max_fuel <= 0)
		if(do_after(user, 15))
			to_chat(user, "\The [src] won't start!")
		else
			to_chat(user, "You fumble with the string.")
	else
		if(do_after(user, 15))
			visible_message("You start \the [src] up with a loud grinding!", "[usr] starts \the [src] up with a loud grinding!")
			attack_verb = list("shredded", "ripped", "torn")
			playsound(src, 'sound/weapons/chainsaw_startup.ogg',50,3)
			force = active_force
			edge = 1
			sharp = 1
			on = 1
			digspeed = active_digspeed
			update_icon()
		else
			to_chat(user, "You fumble with the string.")

/obj/item/weapon/pickaxe/heavydutydrill/proc/turnOff(mob/user as mob)
	if(!on) return
	to_chat(user, "You switch the gas nozzle on \the [src], turning it off.")
	attack_verb = list("bluntly hit", "beat", "knocked")
	playsound(user, 'sound/weapons/chainsaw_turnoff.ogg',40,3)
	force = inactive_force
	edge = 0
	sharp = 0
	on = 0
	digspeed = 120
	update_icon()

/obj/item/weapon/pickaxe/heavydutydrill/attack_self(mob/user as mob)
	if(!on)
		turnOn(user)
	else
		turnOff(user)

/obj/item/weapon/pickaxe/heavydutydrill/proc/unjam(mob/user as mob)
	if(!enginefailed) return
	visible_message("You begin clearing the jam of \the [src] with a loud grinding!", "[usr] begin clearing the jam on \the [src] with a loud grinding!")
	playsound(user, 'sound/weapons/chainsaw_turnoff.ogg',40,3)
	sleep(30)
	visible_message("You clear \the [src] jam!", "[usr] clears \the [src] jam.")
	enginefailed = 0




/obj/item/weapon/pickaxe/heavydutydrill/afterattack(atom/A as mob|obj|turf|area, mob/user as mob, proximity)
	if(!proximity)
		return
	..()
	if(on)
		playsound(src, 'sound/weapons/chainsaw_attack.ogg',40,3)
	if(A && on)
		if(get_fuel() > 0)
			reagents.remove_reagent("fuel", 1)

		if(istype(A,/obj/structure/window))
			var/obj/structure/window/W = A
			W.shatter()

		if(prob(jam_chance))
			enginefail()

	if(istype(A, /obj/structure/reagent_dispensers/fueltank) && get_dist(src,A) <= 1)
		visible_message(user,"<span class='notice'>You begin filling the tank on \the [src].</span>","[usr] begins filling the tank on \the [src].")
		if(do_after(usr, 15))
			A.reagents.trans_to_obj(src, max_fuel)
			playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
			to_chat(user, "<span class='notice'>[src] succesfully refueled.</span>")
		else
			to_chat(user, "<span class='notice'>Don't move while you're refilling \the [src].</span>")

/obj/item/weapon/pickaxe/heavydutydrill/process()
	if(!on)
		return

	if(on)
		if(get_fuel() > 0)
			fuel_consumed = (1*fuel_efficiency) //Lower numbers means better efficiency
			reagents.remove_reagent("fuel", fuel_consumed)

		if(get_fuel() < 1)
			to_chat(usr, "\The [src] sputters to a stop!")
			turnOff()


/obj/item/weapon/pickaxe/heavydutydrill/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/weapon/tool/screwdriver))
		open = !open
		playsound(src, 'sound/items/Screwdriver.ogg',40,1)
		user << "<span class='notice'>The maintenance panel of the [src] is now [open ? "closed" : "open"].</span>"
		return

	if(open)
		if(istype(W, /obj/item/drillparts/drillairfilters))
			if(!airfilter)
				user.drop_item()
				W.loc = src
				airfilter = W
				user << "<span class='notice'>You install \the [W] in [src].</span>"
				update_icon()
				update_stats()
			else
				user << "<span class='notice'>[src] already has a filter.</span>"
			return

		if(istype(W, /obj/item/drillparts/drillbit))
			if(!drill_bit)
				user.drop_item()
				W.loc = src
				drill_bit = W
				user << "<span class='notice'>You install \the [W] in [src].</span>"
				update_icon()
				update_stats()
			else
				user << "<span class='notice'>[src] already has a tip.</span>"
			return

		if(istype(W, /obj/item/drillparts/drillengine))
			if(!engine)
				user.drop_item()
				W.loc = src
				engine = W
				user << "<span class='notice'>You install \the [W] in [src].</span>"
				update_icon()
				update_stats()
			else
				user << "<span class='notice'>[src] already has a engine.</span>"
			return

		if(open && istype(W, /obj/item/weapon/tool/crowbar))
			if(drill_bit || airfilter || engine)
				var/choice = input("What component would you like to remove?") as null|anything in list(drill_bit,airfilter,engine)
				if(!choice) 
					return
				if(choice == drill_bit)
					to_chat(usr, "You pop \the [drill_bit] out of \the [src]'s storage compartment.")
					usr.put_in_hands(drill_bit)
					src.drill_bit = null
					update_stats()
				else if(choice == airfilter)
					to_chat(usr, "You pop \the [airfilter] out of \the [src]'s storage compartment.")
					usr.put_in_hands(airfilter)
					src.airfilter = null
					update_stats()
				else if(choice == engine)
					to_chat(usr, "You detatch \the [engine] from \the [src]'s engine mount.")
					usr.put_in_hands(engine)
					src.engine = null
					update_stats()
				return
			else
				to_chat(usr, "\The [src] does not have anything installed.")
			return
	else
		to_chat(usr, "\The [src] maintenance panel is not open. Dummy.")
		return

	if(istype(W, /obj/item/weapon/reagent_containers)
		visible_message(usr,"<span class='notice'>You fill the tank on \the [src].</span>","[usr] fills the tank on \the [src].")
		W.reagents.trans_to_obj(src, max_fuel)

/obj/item/weapon/pickaxe/heavydutydrill/proc/update_stats() //This is supposed to update the values after you put things in and out.
	..()
	for(var/obj/item/drillparts/X in drill_bit)
		active_digspeed = X.dullness
	for(var/obj/item/drillparts/X in engine)
		jam_chance = X.reliability
	for(var/obj/item/drillparts/X in airfilter)
		fuel_efficiency = X.aspiration

/obj/item/weapon/pickaxe/heavydutydrill/proc/enginefail()//This is the process for a jammed engine. You need to activate it in hand to solve the issue.
	force = inactive_force
	edge = 0
	sharp = 0
	on = 0
	digspeed = 120
	enginefailed = 1
	attack_verb = list("bluntly hit", "beat", "knocked")
	playsound(src, 'sound/weapons/chainsaw_turnoff.ogg',40,1)
	visible_message(usr,"<span class='notice'>\The [src] engine jams suddenly! It looks like you'll have to clear the jam yourself.</span>","[usr] [src] jams suddenly!")

	update_icon()

/obj/item/weapon/pickaxe/heavydutydrill/proc/get_fuel()
	return reagents.get_reagent_amount("fuel")

/obj/item/weapon/pickaxe/heavydutydrill/examine(mob/user)
	if(..(user,0))
		if(max_fuel)
			to_chat(usr, "<span class = 'notice'>\The [src] feels like it contains roughtly [get_fuel()] units of fuel left.</span>")
		if(open)
			to_chat(usr, "<span class = 'notice'>\The [src] maintenance panel is open.</span>")

/obj/item/weapon/pickaxe/heavydutydrill/suicide_act(mob/user)
	var/datum/gender/TU = gender_datums[user.get_visible_gender()]
	to_chat(viewers(user), "<span class='danger'>[user] is lying down and pulling \the [src] into [TU.him], it looks like [TU.he] [TU.is] trying to commit suicide!</span>")
	return(BRUTELOSS)

/obj/item/weapon/pickaxe/heavydutydrill/update_icon()
	if(on)
		icon_state = "thdd1"
		item_state = "chainsaw1"
	else
		icon_state = "thdd0"
		item_state = "chainsaw0"

//////////////////////////////////////////////////////////////////////
//																	//
//																	//
//HEAVY DUTY DRILL  PARTS BE HERE									//
//																	//
//																	//
//////////////////////////////////////////////////////////////////////

/obj/item/drillparts
	name = "Drill part"
	desc = "This is not supposed to be spawned in ever."
	icon = 'icons/obj/mining.dmi'
	w_class = ITEMSIZE_SMALL
	force = 5
	var/aspiration = 0
	var/dullness = 0
	var/reliability = 0 //Jam chance

//Drill air filter

/obj/item/drillparts/drillairfilters
	name = "basic air filter"
	desc = "An engine air filter meant for combustible engines. This one seems pretty basic."
	icon_state = "slag"
	aspiration = 1

/obj/item/drillparts/drillairfilters/advanced
	name = "advanced air filter"
	desc = "An engine air filter meant for combustible engines. This one seems decently refined."
	aspiration = 0.5

/obj/item/drillparts/drillairfilters/refined
	name = "refined drill air filter"
	desc = "An engine air filter meant for combustible engines. This looks like a high quality part."
	aspiration = 0.25


//Drill bits

/obj/item/drillparts/drillbit
	name = "basic drill bit"
	desc = "A drilling assembly meant for piercing solid rock. It seems pretty basic."
	icon_state = "slag"
	dullness = 30

/obj/item/drillparts/drillbit/advanced
	name = "advanced drill bit"
	desc = "A drilling assembly meant for piercing solid rock. This one seems decently refined."
	dullness = 15

/obj/item/drillparts/drillbit/refined
	name = "refined drill bit"
	desc = "A drilling assembly meant for piercing solid rock. This looks like a high quality part."
	dullness = 10

//Drill engine

/obj/item/drillparts/drillengine
	name = "basic drill engine"
	desc = "A engine meant for medium tools."
	icon_state = "slag"
	reliability = 2

/obj/item/drillparts/drillengine/advanced
	name = "advanced drill engine"
	desc = "A engine meant for medium tools. This one seems decently refined."
	reliability = 0.5

/obj/item/drillparts/drillengine/refined
	name = "refined drill engine"
	desc = "A engine meant for medium tools. This looks like a high quality part."
	reliability = 0.1