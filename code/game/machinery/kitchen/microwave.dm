/obj/machinery/microwave
	name = "microwave"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "mw"
	layer = 2.9 // ARBITRARY NUMBERS
	density = TRUE
	anchored = TRUE
	use_power = TRUE
	idle_power_usage = 5
	active_power_usage = 100
	flags = OPENCONTAINER | NOREACT
	circuit = /obj/item/weapon/circuitboard/microwave
	var/operating = 0 // Is it on? gee thanks i needed that clarified
	var/dirty = 0 // = {0..100} Does it need cleaning?
	var/broken = 0 // ={0,1,2} How broken is it???
	// typecache and global these
	var/global/list/datum/recipe/available_recipes // List of the recipes you can use 
	var/global/list/acceptable_items // List of the items you can put in
	var/global/list/acceptable_reagents // List of the reagents you can put in
	var/global/max_n_of_items = 0 // why the fuck is this a global
	var/list/held_items = list()


// see code/modules/food/recipes_microwave.dm for recipes
// see code/modules/hell/occupants.dm for coder

/*******************
*   Initialising
********************/

/obj/machinery/microwave/New()
	..()
	reagents = new/datum/reagents(100)
	reagents.my_atom = src // turn this into a helper and remove copypaste

	component_parts = list()
	component_parts += new /obj/item/weapon/stock_parts/console_screen(src)
	component_parts += new /obj/item/weapon/stock_parts/motor(src)
	component_parts += new /obj/item/weapon/stock_parts/capacitor(src)

	if (!available_recipes)
		available_recipes = new
		for (var/type in (typesof(/datum/recipe)-/datum/recipe)) // subtypesof
			available_recipes+= new type // oh dear god no, use initial() trick here
		acceptable_items = new // lazyinit all these
		acceptable_reagents = new
		for (var/datum/recipe/recipe in available_recipes) // what the fuck
			for (var/item in recipe.items)
				acceptable_items |= item
			for (var/reagent in recipe.reagents)
				acceptable_reagents |= reagent
			if (recipe.items)
				max_n_of_items = max(max_n_of_items,recipe.items.len)
		// This will do until I can think of a fun recipe to use dionaea in -
		// will also allow anything using the holder item to be microwaved into
		// impure carbon. ~Z
		acceptable_items |= /obj/item/weapon/holder // I Can't Believe It's Hacky(tm)
		acceptable_items |= /obj/item/weapon/reagent_containers/food/snacks/grown

	RefreshParts()

/*******************
*   Item Adding
********************/

/obj/machinery/microwave/attackby(var/obj/item/O as obj, var/mob/user as mob) // as mob/as obj is shit
	if(src.broken > 0) // magic fucking numbers
		if(src.broken == 2 && istype(O, /obj/item/weapon/screwdriver)) // If it's broken and they're using a screwdriver
			user.visible_message( \
				"<span class='notice'>\The [user] starts to fix part of the microwave.</span>", \
				"<span class='notice'>You start to fix part of the microwave.</span>" \
			)
			playsound(src, O.usesound, 50, 1)
			if (do_after(user,20 * O.toolspeed))
				user.visible_message( \
					"<span class='notice'>\The [user] fixes part of the microwave.</span>", \
					"<span class='notice'>You have fixed part of the microwave.</span>" \
				)
				src.broken = 1 // Fix it a bit
		else if(src.broken == 1 && istype(O, /obj/item/weapon/wrench)) // If it's broken and they're doing the wrench
			user.visible_message( \
				"<span class='notice'>\The [user] starts to fix part of the microwave.</span>", \
				"<span class='notice'>You start to fix part of the microwave.</span>" \
			)
			if (do_after(user,20 * O.toolspeed))
				user.visible_message( \
					"<span class='notice'>\The [user] fixes the microwave.</span>", \
					"<span class='notice'>You have fixed the microwave.</span>" \
				)
				src.icon_state = "mw"
				src.broken = 0 // Fix it!
				src.dirty = 0 // just to be sure // MAGIC NUMBERS
				src.flags = OPENCONTAINER
		else
			user << "<span class='warning'>It's broken!</span>"
			return TRUE
	else if(default_deconstruction_screwdriver(user, O))
		return
	else if(default_deconstruction_crowbar(user, O))
		return

	else if(src.dirty==100) // The microwave is all dirty so can't be used! // what the absolute fuck
		// lmao i can clean this with space lube if i put it in the cleaner bottle
		if(istype(O, /obj/item/weapon/reagent_containers/spray/cleaner) || istype(O, /obj/item/weapon/soap)) // this shit needs to not be hardcoded/spray should use the actual reagent
			user.visible_message( \
				"<span class='notice'>\The [user] starts to clean the microwave.</span>", \
				"<span class='notice'>You start to clean the microwave.</span>" \
			)
			if (do_after(user,20))
				user.visible_message( \
					"<span class='notice'>\The [user] has cleaned the microwave.</span>", \
					"<span class='notice'>You have cleaned the microwave.</span>" \
				)
				src.dirty = 0 // It's clean!
				src.broken = 0 // just to be sure
				src.icon_state = "mw" // shit icon state name, rename
				src.flags = OPENCONTAINER
		else //Otherwise bad luck!!
			user << "<span class='warning'>It's dirty!</span>"
			return 1
	else if(is_type_in_list(O,acceptable_items)) // typecache this
		if (contents.len>=(max_n_of_items + component_parts.len + 1))	//Adds component_parts to the maximum number of items.	The 1 is from the circuit
			user << "<span class='warning'>This [src] is full of ingredients, you cannot put more.</span>"
			return 1
		if(istype(O, /obj/item/stack)) // >literally acknowledges using a colon here is bad >DOESNT WANT TO TAKE THE 5 SECONDS IT TAKES TO TYPECASTE THIS SHIT
			var/obj/item/stack/S = O
			if(S.get_amount() > 1)
				new O.type (src)
				S.use(1)
				user.visible_message( \
					"<span class='notice'>\The [user] has added one of [O] to \the [src].</span>", \
					"<span class='notice'>You add one of [O] to \the [src].</span>")
				return
			else
				user << "There's not enough in [S]."
				return FALSE
		else
			user.drop_item()
			O.loc = src // forcemove equiv
			held_items += O
			user.visible_message( \
				"<span class='notice'>\The [user] has added \the [O] to \the [src].</span>", \
				"<span class='notice'>You add \the [O] to \the [src].</span>")
			return
	else if(istype(O,/obj/item/weapon/reagent_containers/glass) || \
	        istype(O,/obj/item/weapon/reagent_containers/food/drinks) || \
	        istype(O,/obj/item/weapon/reagent_containers/food/condiment) \
		) // jesus christ why just check if it has reagents and opencontainer
		if (!O.reagents)
			return 1
		for (var/R in O.reagents.reagent_list) // saves us a istype()
			var/datum/reagent/RE = R
			if (!(RE.id in acceptable_reagents))
				user << "<span class='warning'>Your [O] contains components unsuitable for cookery.</span>"
				return 1
		return
	else if(istype(O,/obj/item/weapon/grab)) // todo: allow slamming microwave door into face of grabee
		var/obj/item/weapon/grab/G = O
		user << "<span class='warning'>This is ridiculous. You can not fit \the [G.affecting] in this [src].</span>"
		return 1
	else
		user << "<span class='warning'>You have no idea what you can cook with this [O].</span>"
	..()
	src.updateUsrDialog()

/obj/machinery/microwave/attack_hand(mob/user as mob)
	user.set_machine(src)
	interact(user)

/*******************
*   Microwave Menu
********************/

/obj/machinery/microwave/interact(mob/user as mob) // hell on earth, as mob is useless
	var/dat = ""
	if(broken > 0) // MAGIC FUCKING NUMBERS also you DONT NEED TO USE SRC
		dat = {"<TT>Bzzzzttttt</TT>"}
	else if(operating)
		dat = {"<TT>Microwaving in progress!<BR>Please wait...!</TT>"}
	else if(dirty == 100)
		dat = {"<TT>This microwave is dirty!<BR>Please clean it before use!</TT>"}
	else
		var/list/items_counts = new
		var/list/items_measures = new
		var/list/items_measures_p = new
		for (var/obj/O in ((contents - component_parts) - circuit))
			var/display_name = O.name
			if (istype(O,/obj/item/weapon/reagent_containers/food/snacks/egg))
				items_measures[display_name] = "egg"
				items_measures_p[display_name] = "eggs"
			if (istype(O,/obj/item/weapon/reagent_containers/food/snacks/tofu))
				items_measures[display_name] = "tofu chunk"
				items_measures_p[display_name] = "tofu chunks"
			if (istype(O,/obj/item/weapon/reagent_containers/food/snacks/meat)) //any meat
				items_measures[display_name] = "slab of meat"
				items_measures_p[display_name] = "slabs of meat"
			if (istype(O,/obj/item/weapon/reagent_containers/food/snacks/donkpocket))
				display_name = "Turnovers"
				items_measures[display_name] = "turnover"
				items_measures_p[display_name] = "turnovers"
			if (istype(O,/obj/item/weapon/reagent_containers/food/snacks/carpmeat))
				items_measures[display_name] = "fillet of meat"
				items_measures_p[display_name] = "fillets of meat" // TODO: decide whether to axe this shit entirely or no
			items_counts[display_name]++
		for (var/O in items_counts)
			var/N = items_counts[O]
			if (!(O in items_measures))
				dat += {"<B>[capitalize(O)]:</B> [N] [lowertext(O)]\s<BR>"}
			else
				if (N==1)
					dat += {"<B>[capitalize(O)]:</B> [N] [items_measures[O]]<BR>"}
				else
					dat += {"<B>[capitalize(O)]:</B> [N] [items_measures_p[O]]<BR>"}

		for (var/R in reagents.reagent_list)
			var/datum/reagent/RE = R
			var/display_name = RE.name
			dat += {"<B>[display_name]:</B> [RE.volume] unit\s<BR>"}

		if (!items_counts.len && !reagents.reagent_list.len)
			dat = {"<B>The microwave is empty.</B><BR>"}
		else
			dat = {"<b>Ingredients:</b><br>[dat]"}
		dat += {"<HR><BR>\
			<A href='?src=\ref[src];action=cook'>Turn on!<BR>\
			<A href='?src=\ref[src];action=dispose'>Eject ingredients!<BR>\
			"}

	user << browse("<HEAD><TITLE>Microwave Controls</TITLE></HEAD><TT>[dat]</TT>", "window=microwave")
	onclose(user, "microwave")
	return



/***********************************
*   Microwave Menu Handling/Cooking
************************************/

/obj/machinery/microwave/proc/cook()
	if(stat & (NOPOWER|BROKEN))
		return
	start()
	if (!reagents.total_volume && !(locate(/obj) in ((contents - component_parts) - circuit))) //dry run // >>>USING LOCATE
		if (!wzhzhzh(10))
			abort()
			return
		stop()
		return

	var/datum/recipe/recipe = select_recipe(available_recipes,src)
	var/obj/cooked
	if (!recipe)
		dirty += 1
		if (prob(max(10,dirty*5)))
			if (!wzhzhzh(4))
				abort()
				return
			muck_start()
			wzhzhzh(4)
			muck_finish()
			cooked = fail()
			cooked.loc = src.loc
			return
		else if (has_extra_item())
			if (!wzhzhzh(4))
				abort()
				return
			broke()
			cooked = fail()
			cooked.loc = src.loc
			return
		else
			if (!wzhzhzh(10))
				abort()
				return
			stop()
			cooked = fail()
			cooked.loc = src.loc
			return
	else
		var/halftime = round(recipe.time/10/2)
		if (!wzhzhzh(halftime))
			abort()
			return
		if (!wzhzhzh(halftime))
			abort()
			cooked = fail()
			cooked.loc = src.loc
			return
		cooked = recipe.make_food(src)
		stop()
		if(cooked)
			cooked.loc = src.loc
		return

/obj/machinery/microwave/proc/wzhzhzh(var/seconds as num) // Whoever named this proc is fucking literally Satan. ~ Z
	for (var/i=1 to seconds)
		if (stat & (NOPOWER|BROKEN))
			return 0
		use_power(500)
		sleep(10)
	return 1

/obj/machinery/microwave/proc/has_extra_item()
	for (var/obj/O in held_items)
		if ( \
				!istype(O,/obj/item/weapon/reagent_containers/food) && \
				!istype(O, /obj/item/weapon/grown) \
			)
			return 1
	return 0

/obj/machinery/microwave/proc/start()
	src.visible_message("<span class='notice'>The microwave turns on.</span>", "<span class='notice'>You hear a microwave.</span>")
	src.operating = 1
	src.icon_state = "mw1"
	src.updateUsrDialog()

/obj/machinery/microwave/proc/abort()
	src.operating = 0 // Turn it off again aferwards
	src.icon_state = "mw"
	src.updateUsrDialog()

/obj/machinery/microwave/proc/stop()
	playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
	src.operating = 0 // Turn it off again aferwards
	src.icon_state = "mw"
	src.updateUsrDialog()

/obj/machinery/microwave/proc/dispose()
	for (var/obj/O in held_items)
		O.loc = src.loc
		held_items -= O
	if (src.reagents.total_volume)
		src.dirty++
	src.reagents.clear_reagents()
	usr << "<span class='notice'>You dispose of the microwave contents.</span>"
	src.updateUsrDialog()

/obj/machinery/microwave/proc/muck_start()
	playsound(src.loc, 'sound/effects/splat.ogg', 50, 1) // Play a splat sound
	src.icon_state = "mwbloody1" // Make it look dirty!!

/obj/machinery/microwave/proc/muck_finish()
	playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
	src.visible_message("<span class='warning'>The microwave gets covered in muck!</span>")
	src.dirty = 100 // Make it dirty so it can't be used util cleaned
	src.flags = null //So you can't add condiments
	src.icon_state = "mwbloody" // Make it look dirty too
	src.operating = 0 // Turn it off again aferwards
	src.updateUsrDialog()

/obj/machinery/microwave/proc/broke()
	var/datum/effect/effect/system/spark_spread/s = new
	s.set_up(2, 1, src)
	s.start()
	src.icon_state = "mwb" // Make it look all busted up and shit
	src.visible_message("<span class='warning'>The microwave breaks!</span>") //Let them know they're stupid
	src.broken = 2 // Make it broken so it can't be used util fixed
	src.flags = null //So you can't add condiments
	src.operating = 0 // Turn it off again aferwards
	src.updateUsrDialog()

/obj/machinery/microwave/proc/fail()
	var/obj/item/weapon/reagent_containers/food/snacks/badrecipe/burned_food = new(src)
	var/amount = 0
	for (var/obj/O in held_items) // this used to be for (var/obj/O in (((contents - ffuu) - component_parts) - circuit)), painful
		amount++
		if (O.reagents)
			var/id = O.reagents.get_master_reagent_id()
			if (id)
				amount+=O.reagents.get_reagent_amount(id)
		qdel(O)
	src.reagents.clear_reagents()
	ffuu.reagents.add_reagent("carbon", amount)
	ffuu.reagents.add_reagent("toxin", amount/10)
	return ffuu

/obj/machinery/microwave/Topic(href, href_list)
	if(..())
		return

	usr.set_machine(src)
	if(src.operating)
		src.updateUsrDialog()
		return

	switch(href_list["action"])
		if ("cook")
			cook()

		if ("dispose")
			dispose()
	return
