
/obj/structure/cult/forge
	name = "Daemon forge"
	desc = "A forge used in crafting the unholy weapons used by the armies of Nar-Sie."
	icon_state = "forge"
	// Are we usable for things?
	var/active = TRUE

	var/active_state = "forge"
	var/inactive_state = "forge-off"

	var/forge_sound = 'sound/machines/thruster.ogg'

	var/use_bloodnet = FALSE
	var/bloodcost = 50
	var/weakref/bnetref = null

/obj/structure/cult/forge/Initialize()
	..()

	bnetref = weakref(GLOB.blood_networks[CULT_BLOODNETWORK_GLOBAL])
	update_icon()

/obj/structure/cult/forge/attackby(obj/item/W as obj, mob/user as mob)
	if(active)
		var/I

		for(var/datum/cultist/artifice/AD in GLOB.cultforge_recipe_list)
			if(LAZYLEN(AD.material_cost))
				if(AD.material_cost.len == 1)
					var/path = AD.material_cost[1]
					if(istype(W, path))
						if(istype(W, /obj/item/stack))
							var/obj/item/stack/S = W
							if(S.can_use(AD.material_cost[path]))
								S.use(AD.material_cost[path])

								I = AD.obj_path
								bloodcost = AD.cost
								break
						else if(AD.material_cost[1] == 1)
							user.drop_from_inventory(W)
							qdel(W)
							bloodcost = AD.cost
							I = AD.obj_path
							break

		if(I)

			if(use_bloodnet)
				var/datum/bloodnet/BN = bnetref.resolve()

				if(!(BN.check_adjustBlood(-1 * bloodcost) && BN.adjustBlood(-1 * bloodcost)))
					return ..()

			new I(get_turf(src))

			flick("[icon_state]-flare", src)
			playsound(get_turf(src),forge_sound, 30, 1)
			return

	return ..()

/obj/structure/cult/forge/update_icon()
	..()

	if(!active)
		icon_state = "[inactive_state]"
	else
		icon_state = "[active_state]"

/obj/structure/cult/forge/networked
	name = "forge"
	desc = "A forge used in the creation of alchemical tools. Some call the users mad, or heretics. They're merely innovators."
	icon_state = "forge"

	active = FALSE

	use_bloodnet = TRUE

/obj/structure/cult/forge/networked/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/material/kitchen/utensil/fork/tuning) && anchored)
		if(do_after(user, 3 SECONDS, src))
			playsound(get_turf(src),W.usesound, 50, 1)
			active = !active
			update_icon()
			return
	if(istype(W, /obj/item/weapon/book/tome) && !active)
		if(do_after(user, 1 SECOND, src))
			playsound(get_turf(src),W.drop_sound, 50, 1)
			anchored = !anchored
			update_icon()
			return
	return ..()
