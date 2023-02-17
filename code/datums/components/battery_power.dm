/// Generalized framework allowing something to draw power from an inserted power cell.
/// Contains attack_hand() and attackby() signals allowing cells to be added and removed by hand.
/// This base type supports only standard cells; device cells won't fit.
/datum/component/battery_power
	var/obj/item/cell/cell

/datum/component/battery_power/Initialize()
	if (istype(parent, /obj/machinery))
		RegisterSignal(parent, COMSIG_ATOM_ATTACK_HAND, .proc/on_attack_hand)
		RegisterSignal(parent, COMSIG_PARENT_ATTACKBY, .proc/on_attack_by)
	else
		return COMPONENT_INCOMPATIBLE

/// Checks if a provided item can be used as a power cell for this component.
/// By default, the component checks for standard-sized cells.
/datum/component/battery_power/proc/is_valid_cell(obj/item/I)
	return istype(I, /obj/item/cell) && !istype(I, /obj/item/cell/device)

/datum/component/battery_power/proc/on_attack_hand(obj/parent_atom, mob/living/user)
	var/obj/machinery/M = parent_atom
	if (!M.panel_open)
		return
	if (!cell)
		to_chat(user, SPAN_WARNING("\The [M] has no cell to remove."))
		return
	cell.dropInto(M.loc)
	user.put_in_active_hand(cell)
	cell.add_fingerprint(user)
	user.visible_message(SPAN_NOTICE("\The [user] removes \the [cell] from \the [M]."), SPAN_NOTICE("You remove \the [cell] from \the [M]."))
	M.update_icon()
	cell.update_icon()
	cell = null

/datum/component/battery_power/proc/on_attack_by(obj/parent_atom, obj/item/I, mob/living/user)
	var/obj/machinery/M = parent_atom
	if (!M.panel_open || !is_valid_cell(I))
		return
	if (cell)
		to_chat(user, SPAN_WARNING("\The [src] already has \a [cell] installed."))
		return
	user.drop_item(I)
	I.forceMove(M)
	cell = I
	user.visible_message(SPAN_NOTICE("\The [user] inserts \the [I] into \the [M]."), SPAN_NOTICE("You slot \the [I] into \the [M]."))
	M.update_icon()

/// Attempts to use power from a connected cell if one exists.
/// You generally want to multiply the required amount by CELLRATE beforehand,
/// in order to keep things at their intended levels - otherwise cells will drain very quickly.
/datum/component/battery_power/proc/draw_power(power)
	return cell?.use(power)
