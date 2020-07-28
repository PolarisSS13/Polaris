
/obj/item/stack/hose
	name = "plastic tubing"
	singular_name = "plastic tube"
	desc = "A tube of paste containing swarms of repair nanites. Very effective in repairing robotic machinery."
	icon = 'icons/obj/machines/reagent.dmi'
	icon_state = "hose"
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 1)
	amount = 1
	w_class = ITEMSIZE_SMALL
	no_variants = TRUE

	var/obj/item/hose_connector/remembered = null

/obj/item/stack/hose/Destroy()
	remembered = null
	..()

/obj/item/stack/hose/CtrlClick(mob/user)
	if(remembered)
		to_chat(user, "<span class='notice'>You wind \the [src] back up.</span>")
		remembered = null
	return

/obj/item/stack/hose/afterattack(var/atom/target, var/mob/living/user, proximity, params)
	if(!proximity)
		return

	var/list/available_sockets = list()

	for(var/obj/item/hose_connector/HC in target.contents)
		if(!HC.my_hose)
			if(remembered)
				if(HC.flow_direction == HOSE_NEUTRAL || HC.flow_direction != remembered.flow_direction)
					available_sockets |= HC

			else
				available_sockets |= HC

	if(LAZYLEN(available_sockets))
		if(available_sockets.len == 1)
			var/obj/item/hose_connector/AC = available_sockets[1]
			if(remembered && remembered.valid_connection(AC))
				var/distancetonode = get_dist(remembered,AC)
				if(distancetonode > world.view)
					to_chat(user, "<span class='notice'>\The [src] would probably burst if it were this long.</span>")
				else if(distancetonode <= amount)
					remembered.setup_hoses(AC)
					use(distancetonode)
					remembered = null
				else
					to_chat(user, "<span class='notice'>You do not have enough tubing to connect the sockets.</span>")

			else
				remembered = AC
				to_chat(user, "<span class='notice'>You connect one end of tubing to \the [AC].</span>")

		else
			var/choice = input("Select a target hose connector.", "Socket Selection", null) as null|anything in available_sockets

			if(choice)
				var/obj/item/hose_connector/CC = choice
				if(remembered)
					if(remembered.valid_connection(CC))
						var/distancetonode = get_dist(remembered, CC)
						if(distancetonode > world.view)
							to_chat(user, "<span class='notice'>\The [src] would probably burst if it were this long.</span>")
						else if(distancetonode <= amount)
							remembered.setup_hoses(CC)
							use(distancetonode)
							remembered = null

						else
							to_chat(user, "<span class='notice'>You do not have enough tubing to connect the sockets.</span>")

				else
					remembered = CC
					to_chat(user, "<span class='notice'>You connect one end of tubing to \the [CC].</span>")

		return

	else
		..()
