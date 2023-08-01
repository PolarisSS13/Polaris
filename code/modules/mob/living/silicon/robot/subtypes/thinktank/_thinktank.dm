/mob/living/silicon/robot/platform
	name = "support platform"
	desc = "A large quadrupedal AI platform, colloquially known as a 'think-tank' due to the flexible onboard intelligence."
	icon = 'icons/mob/robots/robots_platform.dmi'
	icon_state = "tachi"
	color = "#68a2f2"

	cell =        /obj/item/cell/mech
	idcard_type = /obj/item/card/id/platform

	lawupdate = FALSE
	modtype = "Standard"
	speak_statement = "chirps"

	mob_bump_flag =   HEAVY
	mob_swap_flags = ~HEAVY
	mob_push_flags =  HEAVY
	mob_size =        MOB_LARGE

	dismantle_type = /obj/item/robot_parts/frame/platform
	module_category = ROBOT_MODULE_TYPE_PLATFORM

	var/mapped = FALSE
	var/has_had_player = FALSE
	var/const/platform_respawn_time = 3 MINUTES

	var/tmp/last_recharge_state =     FALSE
	var/tmp/recharge_complete =       FALSE
	var/tmp/recharger_charge_amount = 10 KILOWATTS
	var/tmp/recharger_tick_cost =     80 KILOWATTS
	var/weakref/recharging

/mob/living/silicon/robot/platform/Login()
	. = ..()
	has_had_player = TRUE

/mob/living/silicon/robot/platform/SetName(pickedName)
	. = ..()
	if(mind)
		mind.name = real_name

/mob/living/silicon/robot/platform/Initialize(var/mapload)
	. = ..()
	if(mapped)
		if(!mmi)
			mmi = new /obj/item/mmi/digital/robot(src)
		SetName("inactive [initial(name)]")
	updateicon()

// Copypasting from root proc to avoid calling ..() and accidentally creating duplicate armour etc.
/mob/living/silicon/robot/platform/initialize_components()
	components["actuator"] =       new /datum/robot_component/actuator(src)
	components["radio"] =          new /datum/robot_component/radio(src)
	components["power cell"] =     new /datum/robot_component/cell(src)
	components["diagnosis unit"] = new /datum/robot_component/diagnosis_unit(src)
	components["camera"] =         new /datum/robot_component/camera(src)
	components["comms"] =          new /datum/robot_component/binary_communication(src)
	components["armour"] =         new /datum/robot_component/armour/platform(src)

/mob/living/silicon/robot/platform/Destroy()
	var/obj/item/robot_module/robot/platform/thinktank_module = module
	if(istype(thinktank_module))
		for(var/weakref/drop_ref in thinktank_module.stored_atoms)
			var/atom/movable/drop_atom = drop_ref.resolve()
			if(istype(drop_atom) && !QDELETED(drop_atom) && drop_atom.loc == src)
				drop_atom.dropInto(loc)
		thinktank_module.stored_atoms = null
	if(recharging)
		var/obj/item/recharging_atom = recharging.resolve()
		if(istype(recharging_atom) && recharging_atom.loc == src)
			recharging_atom.dropInto(loc)
		recharging = null
	. = ..()

/mob/living/silicon/robot/platform/examine(mob/user, distance)
	. = ..()
	if(distance <= 3)

		if(recharging)
			var/obj/item/cell/recharging_atom = recharging.resolve()
			if(istype(recharging_atom) && !QDELETED(recharging_atom))
				. += "It has \a [recharging_atom] slotted into its recharging port."
				. += "The cell readout shows [round(recharging_atom.percent(),1)]% charge."
			else
				. += "Its recharging port is empty."
		else
			. += "Its recharging port is empty."

		var/obj/item/robot_module/robot/platform/thinktank_module = module
		if(istype(thinktank_module) && length(thinktank_module.stored_atoms))
			var/list/atom_names = list()
			for(var/weakref/stored_ref in thinktank_module.stored_atoms)
				var/atom/movable/AM = stored_ref.resolve()
				if(istype(AM))
					atom_names += "\a [AM]"
			if(length(atom_names))
				. += "It has [english_list(atom_names)] loaded into its transport bay."
		else
			. += "Its cargo bay is empty."

/mob/living/silicon/robot/platform/update_braintype()
	braintype = BORG_BRAINTYPE_PLATFORM

/mob/living/silicon/robot/platform/init()
	. = ..()
	if(ispath(module, /obj/item/robot_module))
		module = new module(src)

/mob/living/silicon/robot/platform/use_power()
	. = ..()

	if(stat != DEAD && cell)

		// TODO generalize solar occlusion to charge from the actual sun.
		var/new_recharge_state = istype(loc, /turf/simulated/floor/outdoors) || /*, /turf/exterior) */ istype(loc, /turf/space)
		if(new_recharge_state != last_recharge_state)
			last_recharge_state = new_recharge_state
			if(last_recharge_state)
				to_chat(src, SPAN_NOTICE("<b>Your integrated solar panels begin recharging your battery.</b>"))
			else
				to_chat(src, SPAN_DANGER("Your integrated solar panels cease recharging your battery."))

		if(last_recharge_state)
			var/charge_amt = recharger_charge_amount * CELLRATE
			cell.give(charge_amt)
			used_power_this_tick -= (charge_amt)
			module.respawn_consumable(src, (charge_amt / 250)) // magic number copied from borg charger.

		if(recharging)

			var/obj/item/cell/recharging_atom = recharging.resolve()
			if(!istype(recharging_atom) || QDELETED(recharging_atom) || recharging_atom.loc != src)
				recharging = null
				return

			if(recharging_atom.percent() < 100)
				var/charge_amount = recharger_tick_cost * CELLRATE
				if(cell.check_charge(charge_amount * 1.5) && cell.checked_use(charge_amount)) // Don't kill ourselves recharging the battery.
					recharging_atom.give(charge_amount)
					used_power_this_tick += charge_amount

			if(!recharge_complete && recharging_atom.percent() >= 100)
				recharge_complete = TRUE
				visible_message(SPAN_NOTICE("\The [src] beeps and flashes a green light above \his recharging port."))
