/turf/simulated/floor/attackby(var/obj/item/C, var/mob/user)

	if(!C || !user)
		return 0

	if(isliving(user) && istype(C))
		var/mob/living/L = user
		if(L.a_intent != I_HELP)
			attack_tile(C, L) // Be on help intent if you want to decon something.
			return

	if (has_snow()) // Snowy turfs have to be cleared out before anything else can be done with them
		if (istype(C, /obj/item/shovel))
			user.visible_message(
				SPAN_NOTICE("\The [user] starts clearing \the [src] with \the [C.name]..."),
				SPAN_NOTICE("You start clearing \the [src] with your [C.name]..."))
			if(do_after(user, 4 SECONDS * C.toolspeed))
				user.visible_message(
					SPAN_NOTICE("\The [user] finishes clearing \the [src]."),
					SPAN_NOTICE("You clear out \the [src] and leave it in a pile nearby."))
				var/obj/item/stack/material/snow/S = new(src)
				S.amount = 5 * snow_layers
				set_snow(0)
		else
			to_chat(user, SPAN_WARNING("Remove the snow with a shovel first!"))
		return TRUE

	if(!(C.has_tool_quality(TOOL_SCREWDRIVER) && flooring && (flooring.flags & TURF_REMOVE_SCREWDRIVER)))
		if(isliving(user))
			var/mob/living/L = user
			if(L.a_intent == I_HELP && L.is_preference_enabled(/datum/client_preference/engrave_graffiti))
				try_graffiti(L, C)

	if(istype(C, /obj/item/stack/tile/roofing))
		var/expended_tile = FALSE // To track the case. If a ceiling is built in a multiz zlevel, it also necessarily roofs it against weather
		var/turf/T = GetAbove(src)
		var/obj/item/stack/tile/roofing/R = C

		// Patch holes in the ceiling
		if(T)
			if(istype(T, /turf/simulated/open) || istype(T, /turf/space))
			 	// Must be build adjacent to an existing floor/wall, no floating floors
				var/list/cardinalTurfs = list() // Up a Z level
				for(var/dir in cardinal)
					var/turf/B = get_step(T, dir)
					if(B)
						cardinalTurfs += B

				var/turf/simulated/A = locate(/turf/simulated/floor) in cardinalTurfs
				if(!A)
					A = locate(/turf/simulated/wall) in cardinalTurfs
				if(!A)
					to_chat(user, "<span class='warning'>There's nothing to attach the ceiling to!</span>")
					return

				if(R.use(1)) // Cost of roofing tiles is 1:1 with cost to place lattice and plating
					T.ReplaceWithLattice()
					T.ChangeTurf(/turf/simulated/floor, preserve_outdoors = TRUE)
					playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
					user.visible_message("<span class='notice'>[user] patches a hole in the ceiling.</span>", "<span class='notice'>You patch a hole in the ceiling.</span>")
					expended_tile = TRUE
			else
				to_chat(user, "<span class='warning'>There aren't any holes in the ceiling to patch here.</span>")
				return

		// Create a ceiling to shield from the weather
		if(src.is_outdoors())
			for(var/dir in cardinal)
				var/turf/A = get_step(src, dir)
				if(A && !A.is_outdoors())
					if(expended_tile || R.use(1))
						make_indoors()
						playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
						user.visible_message("<span class='notice'>[user] roofs a tile, shielding it from the elements.</span>", "<span class='notice'>You roof this tile, shielding it from the elements.</span>")
					break
		return

	if(!is_plating())
		if(istype(C))
			try_deconstruct_tile(C, user)
			return
		else if(istype(C, /obj/item/stack/cable_coil))
			to_chat(user, "<span class='warning'>You must remove the [flooring.descriptor] first.</span>")
			return
		else if(istype(C, /obj/item/stack/tile))
			try_replace_tile(C, user)
			return
	else
		if(istype(C, /obj/item/stack/cable_coil))
			if(broken || burnt)
				to_chat(user, "<span class='warning'>This section is too damaged to support anything. Use a welder to fix the damage.</span>")
				return
			var/obj/item/stack/cable_coil/coil = C
			coil.turf_place(src, user)
			return
		else if(istype(C, /obj/item/stack))
			if(broken || burnt)
				to_chat(user, "<span class='warning'>This section is too damaged to support anything. Use a welder to fix the damage.</span>")
				return
			var/obj/item/stack/S = C
			var/decl/flooring/use_flooring
			var/list/flooring_types = decls_repository.get_decls_of_type(/decl/flooring)
			for(var/flooring_type in flooring_types)
				var/decl/flooring/F = flooring_types[flooring_type]
				if(!F.build_type)
					continue
				if((S.type == F.build_type) || (S.build_type == F.build_type))
					use_flooring = F
					break
			if(!use_flooring)
				return
			// Do we have enough?
			if(use_flooring.build_cost && S.amount < use_flooring.build_cost)
				to_chat(user, "<span class='warning'>You require at least [use_flooring.build_cost] [S.name] to complete the [use_flooring.descriptor].</span>")
				return
			// Stay still and focus...
			if(use_flooring.build_time && !do_after(user, use_flooring.build_time))
				return
			if(!is_plating() || !S || !user || !use_flooring)
				return
			if(S.use(use_flooring.build_cost))
				set_flooring(use_flooring)
				playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
				return
		// Repairs.
		else if(istype(C, /obj/item/weldingtool))
			var/obj/item/weldingtool/welder = C
			if(welder.isOn() && (is_plating()))
				if(broken || burnt)
					if(welder.remove_fuel(0,user))
						to_chat(user, "<span class='notice'>You fix some dents on the broken plating.</span>")
						playsound(src, welder.usesound, 80, 1)
						icon_state = "plating"
						burnt = null
						broken = null
					else
						to_chat(user, "<span class='warning'>You need more welding fuel to complete this task.</span>")

/turf/simulated/floor/attack_hand(mob/user)
	if (!user.pulling && has_snow())
		visible_message(SPAN_NOTICE("[user] starts scooping up some snow..."), SPAN_NOTICE("You start scooping up some snow..."))
		if(do_after(user, 1 SECOND))
			var/obj/S = new /obj/item/stack/material/snow(user.loc)
			user.put_in_hands(S)
			visible_message(SPAN_NOTICE("[user] scoops up a pile of snow."), SPAN_NOTICE("You scoop up a pile of snow."))
		return
	return ..()

/turf/simulated/floor/proc/try_deconstruct_tile(obj/item/W as obj, mob/user as mob)
	if(W.is_crowbar())
		if(broken || burnt)
			to_chat(user, "<span class='notice'>You remove the broken [flooring.descriptor].</span>")
			make_plating()
		else if(flooring.flags & TURF_IS_FRAGILE)
			to_chat(user, "<span class='danger'>You forcefully pry off the [flooring.descriptor], destroying them in the process.</span>")
			make_plating()
		else if(flooring.flags & TURF_REMOVE_CROWBAR)
			to_chat(user, "<span class='notice'>You lever off the [flooring.descriptor].</span>")
			make_plating(1)
		else
			return 0
		playsound(src, W.usesound, 80, 1)
		return 1
	else if(W.is_screwdriver() && (flooring.flags & TURF_REMOVE_SCREWDRIVER))
		if(broken || burnt)
			return 0
		to_chat(user, "<span class='notice'>You unscrew and remove the [flooring.descriptor].</span>")
		make_plating(1)
		playsound(src, W.usesound, 80, 1)
		return 1
	else if(W.is_wrench() && (flooring.flags & TURF_REMOVE_WRENCH))
		to_chat(user, "<span class='notice'>You unwrench and remove the [flooring.descriptor].</span>")
		make_plating(1)
		playsound(src, W.usesound, 80, 1)
		return 1
	else if(istype(W, /obj/item/shovel) && (flooring.flags & TURF_REMOVE_SHOVEL))
		to_chat(user, "<span class='notice'>You shovel off the [flooring.descriptor].</span>")
		make_plating(1)
		playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
		return 1
	return 0

/turf/simulated/floor/proc/try_replace_tile(obj/item/stack/tile/T as obj, mob/user as mob)
	if(T.type == flooring.build_type)
		return
	var/obj/item/W = user.is_holding_item_of_type(/obj/item)
	if(!istype(W))
		return
	if(!try_deconstruct_tile(W, user))
		return
	if(flooring)
		return
	attackby(T, user)
