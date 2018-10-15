/obj/item/weapon/pickaxe/heavydutydrill //AEIOU project
	name = "heavy duty drill"
	desc = "Vroom vroom."
	icon = 'icons/obj/mining.dmi'
	icon_state = "thdd0"
	item_state = "chainsaw0"
	w_class = ITEMSIZE_LARGE
	slot_flags = SLOT_BACK
	digspeed = 120 //VERY SLOW. Digspeed is a delay. Lower is better.
	slowdown = 1
	matter = list(DEFAULT_WALL_MATERIAL = 3750)
	var/on = 0 //Is the engine running
	var/open = 0 //Is the maintenance panel open
	var/max_fuel = 100 //Amount of fuel. It is evident.
	var/active_force = 35 
	var/inactive_force = 10
	var/enginefailed = 0 //Is the engine currently stuck. If 1, it needs to be cleared.
	var/drill_bit = null //The actual drill in contact with the surface.
	var/engine = null //This is the engine that powers the drill. Better engines are faster.
	var/airfilter = null //This will determine the engine fuel efficiency.
	var/fuel_consumed = 0 //placeholder. This is used for fuel consumption calculations.
	var/fuel_efficiency = 30 //This is the var which determines how much you consume fuel.

/obj/item/weapon/pickaxe/heavydutydrill/New()
	var/datum/reagents/R = new/datum/reagents(max_fuel)
	reagents = R
	R.my_atom = src
	R.add_reagent("fuel", max_fuel)
	processing_objects |= src
	..()

/obj/item/weapon/pickaxe/heavydutydrill/Destroy()
	processing_objects -= src
	if(reagents)
		qdel(reagents)
	..()

/obj/item/weapon/pickaxe/heavydutydrill/proc/turnOn(mob/user as mob)
	if(on) return

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
			playsound(src, 'sound/weapons/chainsaw_startup.ogg',60,3)
			force = active_force
//			fuel_efficiency = (airfilter.aspiration)*1
			edge = 1
			sharp = 1
			on = 1
			digspeed = 15
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
	if(!proximity) return
	..()
	if(on)
		playsound(src, 'sound/weapons/chainsaw_attack.ogg',40,3)
	if(A && on)
		if(get_fuel() > 0)
			reagents.remove_reagent("fuel", 1)
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
	if (istype(A, /obj/structure/reagent_dispensers/fueltank) && get_dist(src,A) <= 1)
		to_chat(user, "<span class='notice'>You begin filling the tank on \the [src].</span>")
		visible_message(user,"<span class='notice'>You begin filling the tank on \the [src].</span>","[usr] begins filling the tank on \the [src].")
		visible_message("You start \the [src] up with a loud grinding!", "[usr] starts \the [src] up with a loud grinding!")
		if(do_after(usr, 15))
			A.reagents.trans_to_obj(src, max_fuel)
			playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
			to_chat(user, "<span class='notice'>[src] succesfully refueled.</span>")
		else
			to_chat(user, "<span class='notice'>Don't move while you're refilling \the [src].</span>")

/obj/item/weapon/pickaxe/heavydutydrill/process()
	if(!on) return

	if(on)
		if(get_fuel() > 0)
			fuel_consumed = (1*fuel_efficiency) //Lower numbers means better efficiency
			reagents.remove_reagent("fuel", fuel_consumed)
			
		if(get_fuel() < 1)
			to_chat(usr, "\The [src] sputters to a stop!")
			turnOff()
		if(prob(1))
			enginefail()

/obj/item/weapon/pickaxe/heavydutydrill/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/drillparts/drillairfilters))
		if(!airfilter)
			user.drop_item()
			W.loc = src
			airfilter = W
			user << "<span class='notice'>You install a filter in [src].</span>"
			update_icon()
		else
			user << "<span class='notice'>[src] already has a filter.</span>"	

	if(istype(W, /obj/item/drillparts/drillbit))
		if(!drill_bit)
			user.drop_item()
			W.loc = src
			drill_bit = W
			user << "<span class='notice'>You install a tip in [src].</span>"
			update_icon()
		else
			user << "<span class='notice'>[src] already has a tip.</span>"	

	if(istype(W, /obj/item/drillparts/drillengine))
		if(!engine )
			user.drop_item()
			W.loc = src
			engine  = W
			user << "<span class='notice'>You install an engine in [src].</span>"
			update_icon()
		else
			user << "<span class='notice'>[src] already has a engine.</span>"	


/obj/item/weapon/pickaxe/heavydutydrill/proc/enginefail() //This is the process for a jammed engine. You need to activate it in hand to solve the issue.
	force = inactive_force
	edge = 0
	sharp = 0
	on = 0
	digspeed = 120
	enginefailed = 1
	attack_verb = list("bluntly hit", "beat", "knocked")
	playsound(src, 'sound/weapons/chainsaw_turnoff.ogg',15,1)
	to_chat(usr, "\The [src] engine jams suddenly! It looks like you'll have to clear the jam yourself.")
	update_icon()

/obj/item/weapon/pickaxe/heavydutydrill/proc/get_fuel()
	return reagents.get_reagent_amount("fuel")

/obj/item/weapon/pickaxe/heavydutydrill/examine(mob/user)	
	if(..(user,0))
		if(max_fuel)
			to_chat(usr, "<span class = 'notice'>\The [src] feels like it contains roughtly [get_fuel()] units of fuel left.</span>")

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

//Drill air filter

/obj/item/drillparts/drillairfilters
	name = "basic air filter"
	desc = "An engine air filter meant for combustible engines. This one seems pretty basic."
	icon_state = "slag"
	var/aspiration = 1	

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
	var/dullness = 30

/obj/item/drillparts/drillbit/advanced
	name = "advanced drill bit"
	desc = "A drilling assembly meant for piercing solid rock. This one seems decently refined."
	dullness = 15

/obj/item/drillparts/drillbit/refined
	name = "refined drill bit"
	desc = "A drilling assembly meant for piercing solid rock. This looks like a high quality part."
	dullness = 1

//Drill engine

/obj/item/drillparts/drillengine
	name = "basic drill engine"
	desc = "A engine engine meant for combustible engines"
	icon_state = "slag"
	var/enginepower = 50

/obj/item/drillparts/drillengine/advanced
	name = "advanced drill engine"
	desc = "A engine meant for combustible engines"
	enginepower = 100

/obj/item/drillparts/drillengine/refined
	name = "refined drill engine"
	desc = "A engine meant for combustible engines"
	enginepower = 150