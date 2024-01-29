/obj/item/mech_component/chassis
	name = "body"
	icon_state = "loader_body"
	gender = NEUTER

	var/mech_health = 300
	var/obj/item/cell/cell
	var/obj/item/robot_parts/robot_component/diagnosis_unit/diagnostics
	var/obj/item/robot_parts/robot_component/armour/exosuit/armour
	var/obj/machinery/portable_atmospherics/canister/air_supply
	var/datum/gas_mixture/cockpit
	var/transparent_cabin = FALSE
	var/hide_pilot =        FALSE
	var/hatch_descriptor = "cockpit"
	var/list/pilot_positions
	var/pilot_coverage = 100
	var/min_pilot_size = MOB_SMALL
	var/max_pilot_size = MOB_LARGE
	has_hardpoints = list(HARDPOINT_BACK, HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)

/obj/item/mech_component/chassis/Destroy()
	QDEL_NULL(cell)
	QDEL_NULL(diagnostics)
	QDEL_NULL(armour)
	QDEL_NULL(air_supply)
	. = ..()

/obj/item/mech_component/chassis/update_components()
	diagnostics = locate() in src
	cell =        locate() in src
	armour =      locate() in src
	air_supply =  locate() in src

/obj/item/mech_component/chassis/show_missing_parts(var/mob/user)
	if(!cell)
		. += SPAN_WARNING("It is missing a power cell.")
	if(!diagnostics)
		. += SPAN_WARNING("It is missing a diagnostics unit.")
	if(!armour)
		. += SPAN_WARNING("It is missing exosuit armour plating.")

/obj/item/mech_component/chassis/Initialize()
	. = ..()
	cockpit = new(20)
	if(loc)
		var/datum/gas_mixture/air = loc.return_air()
		if(air)
			cockpit.equalize(air)
	air_supply = new /obj/machinery/portable_atmospherics/canister/air(src)

	if(isnull(pilot_positions))
		pilot_positions = list(
			list(
				"[NORTH]" = list("x" = 8, "y" = 0),
				"[SOUTH]" = list("x" = 8, "y" = 0),
				"[EAST]"  = list("x" = 8, "y" = 0),
				"[WEST]"  = list("x" = 8, "y" = 0)
			)
		)

/obj/item/mech_component/chassis/proc/update_air(var/take_from_supply)

	var/changed
	if(!take_from_supply || pilot_coverage < 100)
		var/turf/T = get_turf(src)
		if(!T)
			return
		cockpit.equalize(T.return_air())
		changed = TRUE
	else if(air_supply)
		var/env_pressure = cockpit.return_pressure()
		var/pressure_delta = air_supply.release_pressure - env_pressure
		if((air_supply.air_contents.temperature > 0) && (pressure_delta > 0))
			var/transfer_moles = calculate_transfer_moles(air_supply.air_contents, cockpit, pressure_delta)
			transfer_moles = min(transfer_moles, (air_supply.release_flow_rate/air_supply.air_contents.volume)*air_supply.air_contents.total_moles)
			pump_gas_passive(air_supply, air_supply.air_contents, cockpit, transfer_moles)
			changed = TRUE
	if(changed)
		cockpit.react()

/obj/item/mech_component/chassis/ready_to_install()
	return (cell && diagnostics && armour)

/obj/item/mech_component/chassis/prebuild()
	diagnostics = new(src)
	cell = new /obj/item/cell/high(src)
	cell.charge = cell.maxcharge

/obj/item/mech_component/chassis/attackby(var/obj/item/thing, var/mob/user)
	if(istype(thing,/obj/item/robot_parts/robot_component/diagnosis_unit))
		if(diagnostics)
			to_chat(user, SPAN_WARNING("\The [src] already has a diagnostic system installed."))
			return
		if(install_component(thing, user)) diagnostics = thing
	else if(istype(thing, /obj/item/cell))
		if(cell)
			to_chat(user, SPAN_WARNING("\The [src] already has a cell installed."))
			return
		if(install_component(thing,user)) cell = thing
	else if(istype(thing, /obj/item/robot_parts/robot_component/armour/exosuit))
		if(armour)
			to_chat(user, SPAN_WARNING("\The [src] already has armour installed."))
			return
		if(install_component(thing, user))
			armour = thing
	else
		return ..()

/obj/item/mech_component/chassis/MouseDrop_T(atom/dropping, mob/user)
	var/obj/machinery/portable_atmospherics/canister/C = dropping
	if(istype(C) && do_after(user, 5, src))
		to_chat(user, SPAN_NOTICE("You install the canister in the [src]."))
		if(air_supply)
			air_supply.forceMove(get_turf(src))
			air_supply = null
		C.forceMove(src)
		update_components()
	else . = ..()

/obj/item/mech_component/chassis/proc/get_armor_values()
	if(armour)
		return armour.armor

	return list(
		melee =5,
		bullet = 5,
		laser = 5,
		energy = 5,
		bomb = 0,
		bio = 5,
		rad = 5
		)

/obj/item/mech_component/chassis/proc/get_armor(var/type)
	var/list/checking = get_armor_values()
	return checking[type]

/*
 * Variants
 */

/obj/item/mech_component/chassis/combat
	name = "sealed exosuit chassis"
	hatch_descriptor = "canopy"
	pilot_coverage = 100
	transparent_cabin =  TRUE
	exosuit_desc_string = "an armoured chassis"
	icon_state = "combat_body"
	power_use = 40
	mech_health = 350

/obj/item/mech_component/chassis/combat/prebuild()
	. = ..()
	armor = new /obj/item/robot_parts/robot_component/armour/exosuit/combat(src)

/obj/item/mech_component/chassis/combat/Initialize()
	pilot_positions = list(
		list(
			"[NORTH]" = list("x" = 8,  "y" = 8),
			"[SOUTH]" = list("x" = 8,  "y" = 8),
			"[EAST]"  = list("x" = 4,  "y" = 8),
			"[WEST]"  = list("x" = 12, "y" = 8)
		)
	)

	. = ..()

/obj/item/mech_component/chassis/industrial
	name = "open exosuit chassis"
	hatch_descriptor = "roll cage"
	pilot_coverage = 40
	exosuit_desc_string = "an industrial rollcage"
	desc = "An industrial roll cage. Technically OSHA compliant. Technically."
	icon_state = "industrial_body"
	max_damage = 100
	power_use = 0

/obj/item/mech_component/chassis/industrial/prebuild()
	. = ..()
	armour = new /obj/item/robot_parts/robot_component/armour/exosuit(src)

/obj/item/mech_component/chassis/industrial/Initialize()
	pilot_positions = list(
		list(
			"[NORTH]" = list("x" = 8,  "y" = 8),
			"[SOUTH]" = list("x" = 8,  "y" = 8),
			"[EAST]"  = list("x" = 8,  "y" = 8),
			"[WEST]"  = list("x" = 8,  "y" = 8)
		),
		list(
			"[NORTH]" = list("x" = 8,  "y" = 16),
			"[SOUTH]" = list("x" = 8,  "y" = 16),
			"[EAST]"  = list("x" = 0,  "y" = 16),
			"[WEST]"  = list("x" = 16, "y" = 16)
		)
	)
	. = ..()

/obj/item/mech_component/chassis/heavy
	name = "reinforced exosuit chassis"
	hatch_descriptor = "hatch"
	desc = "The HI-Koloss chassis is a veritable juggernaut, capable of protecting a pilot even in the most hostile of environments. It handles like a battlecruiser, however."
	pilot_coverage = 100
	exosuit_desc_string = "a heavily armoured chassis"
	icon_state = "heavy_body"
	max_damage = 150
	mech_health = 500
	power_use = 50
	has_hardpoints = list(HARDPOINT_BACK)

/obj/item/mech_component/chassis/heavy/prebuild()
	. = ..()
	armor = new /obj/item/robot_parts/robot_component/armour/exosuit/combat(src)

/obj/item/mech_component/chassis/light
	name = "light exosuit chassis"
	hatch_descriptor = "canopy"
	pilot_coverage = 100
	transparent_cabin =  TRUE
	hide_pilot = TRUE //Sprite too small, legs clip through, so for now hide pilot
	exosuit_desc_string = "an open and light chassis"
	icon_state = "light_body"
	max_damage = 50
	power_use = 5
	mech_health = 200
	has_hardpoints = list(HARDPOINT_BACK)
	desc = "The Veymed Odysseus series cockpits combine ultralight materials and clear aluminum laminates to provide an optimized cockpit experience."

/obj/item/mech_component/chassis/light/prebuild()
	. = ..()
	armour = new /obj/item/robot_parts/robot_component/armour/exosuit/radproof(src)

/obj/item/mech_component/chassis/light/Initialize()
	pilot_positions = list(
		list(
			"[NORTH]" = list("x" = 8,  "y" = -2),
			"[SOUTH]" = list("x" = 8,  "y" = -2),
			"[EAST]"  = list("x" = 1,  "y" = -2),
			"[WEST]"  = list("x" = 9,  "y" = -2)
		)
	)
	. = ..()

/obj/item/mech_component/chassis/mercenary
	name = "reinforced exosuit chassis"
	hatch_descriptor = "hatch"
	desc = "The HI-Koloss chassis is a veritable juggernaut, capable of protecting a pilot even in the most hostile of environments. It handles like a battlecruiser, however."
	pilot_coverage = 100
	exosuit_desc_string = "a heavily armoured chassis"
	icon_state = "mercenary_body"
	max_damage = 150
	mech_health = 500
	power_use = 50
	has_hardpoints = list(HARDPOINT_BACK)

/obj/item/mech_component/chassis/mercenary/Initialize()
	pilot_positions = list(
		list(
			"[NORTH]" = list("x" = 8,  "y" = 8),
			"[SOUTH]" = list("x" = 9,  "y" = 2),
			"[EAST]"  = list("x" = 4,  "y" = 8),
			"[WEST]"  = list("x" = 12, "y" = 8)
		)
	)
	. = ..()

/obj/item/mech_component/chassis/mercenary/prebuild()
	. = ..()
	armour = new /obj/item/robot_parts/robot_component/armour/exosuit/combat(src)

/obj/item/mech_component/chassis/pod
	name = "spherical exosuit chassis"
	hatch_descriptor = "hatch"
	pilot_coverage = 100
	transparent_cabin = TRUE
	exosuit_desc_string = "a spherical chassis"
	icon_state = "pod_body"
	max_damage = 70
	power_use = 5
	has_hardpoints = list(HARDPOINT_BACK)
	desc = "The Katamari series cockpits won a massive government tender a few years back. No one is sure why, but these terrible things keep popping up on every government-run facility."

/obj/item/mech_component/chassis/pod/prebuild()
	. = ..()
	armour = new /obj/item/robot_parts/robot_component/armour/exosuit/radproof(src)

/obj/item/mech_component/chassis/pod/Initialize()
	pilot_positions = list(
		list(
			"[NORTH]" = list("x" = 8,  "y" = 4),
			"[SOUTH]" = list("x" = 8,  "y" = 4),
			"[EAST]"  = list("x" = 12,  "y" = 4),
			"[WEST]"  = list("x" = 4,  "y" = 4)
		),
		list(
			"[NORTH]" = list("x" = 8,  "y" = 8),
			"[SOUTH]" = list("x" = 8,  "y" = 8),
			"[EAST]"  = list("x" = 10,  "y" = 8),
			"[WEST]"  = list("x" = 6, "y" = 8)
		)
	)
	. = ..()

/obj/item/mech_component/chassis/pod/prebuild()
	. = ..()
	armour = new /obj/item/robot_parts/robot_component/armour/exosuit/radproof(src)

/obj/item/mech_component/chassis/modern
	name = "sealed exosuit chassis"
	hatch_descriptor = "canopy"
	pilot_coverage = 100
	hide_pilot = TRUE
	exosuit_desc_string = "an armoured chassis"
	icon_state = "modern_body"
	power_use = 40
	mech_health = 350

/obj/item/mech_component/chassis/modern/prebuild()
	. = ..()
	armor = new /obj/item/robot_parts/robot_component/armour/exosuit/combat(src)

/obj/item/mech_component/chassis/modern/Initialize()
	pilot_positions = list(
		list(
			"[NORTH]" = list("x" = 8,  "y" = 8),
			"[SOUTH]" = list("x" = 8,  "y" = 8),
			"[EAST]"  = list("x" = 4,  "y" = 8),
			"[WEST]"  = list("x" = 12, "y" = 8)
		)
	)
	. = ..()

/obj/item/mech_component/chassis/powerloader
	name = "open exosuit chassis"
	hatch_descriptor = "roll cage"
	pilot_coverage = 40
	exosuit_desc_string = "an industrial rollcage"
	desc = "A Xion industrial brand roll cage. Technically OSHA compliant. Technically."
	max_damage = 100
	power_use = 0

/obj/item/mech_component/chassis/powerloader/prebuild()
	. = ..()
	armour = new /obj/item/robot_parts/robot_component/armour/exosuit(src)

/obj/item/mech_component/chassis/powerloader/Initialize()
	pilot_positions = list(
		list(
			"[NORTH]" = list("x" = 8,  "y" = 8),
			"[SOUTH]" = list("x" = 8,  "y" = 8),
			"[EAST]"  = list("x" = 8,  "y" = 8),
			"[WEST]"  = list("x" = 8,  "y" = 8)
		),
		list(
			"[NORTH]" = list("x" = 8,  "y" = 16),
			"[SOUTH]" = list("x" = 8,  "y" = 16),
			"[EAST]"  = list("x" = 0,  "y" = 16),
			"[WEST]"  = list("x" = 16, "y" = 16)
		)
	)
	. = ..()

/obj/item/mech_component/chassis/sleek
	name = "sleek exosuit chassis"
	hatch_descriptor = "canopy"
	pilot_coverage = 100
	transparent_cabin =  TRUE
	exosuit_desc_string = "an open and sleek chassis"
	icon_state = "sleek_body"
	max_damage = 50
	mech_health = 200
	power_use = 5
	has_hardpoints = list(HARDPOINT_BACK)
	desc = "The Veymed Odysseus series cockpits combine ultrasleek materials and clear aluminium laminates to provide an optimized cockpit experience."

/obj/item/mech_component/chassis/sleek/prebuild()
	. = ..()
	armour = new /obj/item/robot_parts/robot_component/armour/exosuit/radproof(src)

/obj/item/mech_component/chassis/sleek/Initialize()
	pilot_positions = list(
		list(
			"[NORTH]" = list("x" = 8,  "y" = 0),
			"[SOUTH]" = list("x" = 8,  "y" = 0),
			"[EAST]"  = list("x" = 3,  "y" = 0),
			"[WEST]"  = list("x" = 13, "y" = 0)
		)
	)
	. = ..()
