
/obj/machinery/pump
	name = "fluid pump"
	desc = "A fluid pumping machine."

	description_info = "A machine that can pump fluid from certain turfs.<br>\
	Water can be pumped from any body of water. Certain locations or environmental\
	conditions  can cause different byproducts to be produced.<br>\
	Magma or Lava can be pumped to produce mineralized fluid."

	anchored = 0
	density = 1

	icon = 'icons/obj/machines/reagent.dmi'
	icon_state = "pump"

	circuit = /obj/item/weapon/circuitboard/fluidpump
	active_power_usage = 200 * CELLRATE

	var/obj/item/weapon/cell/cell = null
	var/obj/item/hose_connector/output/Output = null
	var/reagents_per_cycle = 40
	var/on = 0
	var/unlocked = 0
	var/open = 0

/obj/machinery/pump/Initialize()
	create_reagents(200)
	. = ..()
	default_apply_parts()

	if(ispath(cell))
		cell = new cell(src)

	else
		cell = default_use_hicell()

	Output = new(src)

	RefreshParts()
	update_icon()

/obj/machinery/pump/update_icon()
	..()
	cut_overlays()
	add_overlay("[icon_state]-tank")
	if(!(cell?.check_charge(active_power_usage)))
		add_overlay("[icon_state]-lowpower")

	if(reagents.total_volume >= 1)
		var/image/I = image(icon, "[icon_state]-volume")
		I.color = reagents.get_color()
		add_overlay(I)
	add_overlay("[icon_state]-glass")

	if(open)
		add_overlay("[icon_state]-open")
		if(istype(cell))
			add_overlay("[icon_state]-cell")

		if(panel_open)
			add_overlay("[icon_state]-panel")

	icon_state = "[initial(icon_state)][on ? "-running" : ""]"

/obj/machinery/pump/process()
	if(!on)
		return

	if(!anchored || !(cell?.checked_use(active_power_usage)))
		toggle(FALSE)
		return

	pump_reagents()
	update_icon()

	if(Output.get_pairing())
		reagents.trans_to_holder(Output.reagents, Output.reagents.maximum_volume)
		if(prob(5))
			visible_message(SPAN_NOTICE("\The [src] gurgles as it exports fluid."))

/obj/machinery/pump/RefreshParts()
	var/obj/item/weapon/stock_parts/manipulator/SM = locate() in component_parts
	active_power_usage = initial(active_power_usage) / SM.rating

	var/motor_power = 0
	for(var/obj/item/weapon/stock_parts/motor/M in component_parts)
		motor_power += M.rating
	reagents_per_cycle = initial(reagents_per_cycle) * motor_power / 2

	var/bin_size = 0
	for(var/obj/item/weapon/stock_parts/matter_bin/SB in component_parts)
		bin_size += SB.rating

	// New holder might have different volume. Transfer everything to a new holder to account for this.
	var/datum/reagents/R = new(round(initial(reagents.maximum_volume) + 100 * bin_size), src)
	src.reagents.trans_to_holder(R, src.reagents.total_volume)
	qdel(src.reagents)
	src.reagents = R

// Toggles the power state, if possible.
// Returns TRUE/FALSE on power state changing
// var/target = target power state
// var/message = TRUE/FALSE whether to make a message about state change
/obj/machinery/pump/proc/toggle(var/target, var/message = TRUE)
	if(target == on)
		return FALSE

	if(!on && (!(cell?.check_charge(active_power_usage)) || !anchored))
		return FALSE

	on = !on
	update_icon()
	if(message)
		if(on)
			message = SPAN_NOTICE("\The [src] turns on.")
		else
			message = SPAN_NOTICE("\The [src] shuts down.")
		visible_message(message)
	return TRUE

/obj/machinery/pump/attack_robot(mob/user)
	return attack_hand(user)

/obj/machinery/pump/attack_ai(mob/user)
	if(!toggle(!on))
		to_chat(user, SPAN_NOTICE("You try to toggle \the [src] but it does not respond."))

/obj/machinery/pump/attack_hand(mob/user)
	if(open && istype(cell))
		user.put_in_hands(cell)
		cell.add_fingerprint(user)
		cell.update_icon()
		cell = null
		toggle(FALSE)
		to_chat(user, SPAN_NOTICE("You remove the power cell."))
		return

	if(!toggle(!on))
		to_chat(user, SPAN_NOTICE("You try to toggle \the [src] but it does not respond."))

/obj/machinery/pump/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(W.is_screwdriver())
		if(!open)
			to_chat(user, SPAN_NOTICE("You [unlocked ? "screw" : "unscrew"] the battery panel."))
			unlocked = !unlocked
		else if(!cell)
			default_deconstruction_screwdriver(user, W)
			update_icon()
			return

	else if(W.is_crowbar())
		if(unlocked)
			if(open)
				if(panel_open && (alert(usr,"Confirm deconstruction.", "Deconstruction","No","Yes") == "Yes") && default_deconstruction_crowbar(user, W))
					return

				open = FALSE
				to_chat(user, SPAN_NOTICE("You pry the battery panel into place."))
			else
				open = TRUE
				to_chat(user, SPAN_NOTICE("You remove the battery panel."))

	else if(W.is_wrench())
		if(on)
			to_chat(user, SPAN_NOTICE("\The [src] is active. Turn it off before trying to move it!"))
			return
		default_unfasten_wrench(user, W, 2 SECONDS)

	else if(istype(W, /obj/item/weapon/cell))
		if(open)
			if(panel_open)
				to_chat(user, SPAN_NOTICE("The cell can't be connected directly to the machine's wires. Replace the maintenance panel."))
			if(cell)
				to_chat(user, SPAN_NOTICE("There is a power cell already installed."))
			else
				user.drop_from_inventory(W)
				W.loc = src
				cell = W
				to_chat(user, SPAN_NOTICE("You insert the power cell."))
	else
		. = ..()
	RefreshParts()
	update_icon()

/obj/machinery/pump/proc/pump_reagents()
	var/turf/T = get_turf(src)

	var/obj/structure/geyser/Geyser = locate() in T
	if(Geyser?.reagents.total_volume)
		Geyser.reagents.trans_to_holder(reagents, reagents_per_cycle)

	else if(istype(T, /turf/simulated/floor/water))
		reagents.add_reagent("water", reagents_per_cycle)

		if(T.temperature <= T0C)
			reagents.add_reagent("ice", round(reagents_per_cycle / 2, 0.1))

		if(istype(T,/turf/simulated/floor/water/pool))
			reagents.add_reagent("chlorine", round(reagents_per_cycle / 10, 0.1))

		else if(istype(T,/turf/simulated/floor/water/contaminated))
			reagents.add_reagent("vatstabilizer", round(reagents_per_cycle / 2))

		if(T.loc.name == "Sea")	// Saltwater.
			reagents.add_reagent("sodiumchloride", round(reagents_per_cycle / 10, 0.1))

		for(var/turf/simulated/mineral/MT in range(5))
			if(MT.mineral)
				var/obj/effect/mineral/OR = MT.mineral
				reagents.add_reagent(OR.ore_reagent, round(reagents_per_cycle, 0.1))

	else if(istype(T, /turf/simulated/floor/lava))
		reagents.add_reagent("mineralizedfluid", round(reagents_per_cycle / 2, 0.1))
