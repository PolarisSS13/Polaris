/obj/item/robot_module/robot/platform

	module_category = ROBOT_MODULE_TYPE_PLATFORM
	unavailable_by_default = TRUE

	var/pupil_color =     COLOR_CYAN
	var/base_color =      COLOR_WHITE
	var/eye_color =       COLOR_BEIGE
	var/armor_color =    "#68a2f2"
	var/user_icon =       'icons/mob/robots/robots_platform.dmi'
	var/user_icon_state = "tachi"

	var/list/decals
	var/list/available_decals = list(
		"Stripe" = "stripe",
		"Vertical Stripe" = "stripe_vertical"
	)

	var/list/stored_atoms
	var/max_stored_atoms = 1
	var/static/list/can_store_types = list(
		/mob/living,
		/obj/item,
		/obj/structure,
		/obj/machinery
	)
	// Currently set to prevent tonks hauling a deliaminating SM into the middle of the station.
	var/static/list/cannot_store_types = list(
		/obj/machinery/power/supermatter
	)

/obj/item/robot_module/robot/platform/Destroy()
	QDEL_NULL_LIST(stored_atoms)
	return ..()

/obj/item/robot_module/robot/platform/verb/set_eye_colour()
	set name = "Set Eye Colour"
	set desc = "Select an eye colour to use."
	set category = "Robot Commands"
	set src in usr

	var/new_pupil_color = input(usr, "Select a pupil colour.", "Pupil Colour Selection") as color|null
	if(usr.incapacitated() || QDELETED(usr) || QDELETED(src) || loc != usr)
		return

	pupil_color = new_pupil_color || initial(pupil_color)
	usr.update_icon()

/obj/item/robot_module/robot/platform/explorer
	name = "recon platform module"
	display_name = "Recon"
	unavailable_by_default = FALSE
	armor_color = "#528052"
	eye_color =   "#7b7b46"
	decals = list(
		"stripe_vertical" = "#52b8b8",
		"stripe" =          "#52b8b8"
	)
	channels = list(
		"Science" = 1,
		"Explorer" = 1
	)
	modules = list(
		/obj/item/tool/wrench/cyborg,
		/obj/item/weldingtool/electric/mounted/cyborg,
		/obj/item/tool/wirecutters/cyborg,
		/obj/item/tool/screwdriver/cyborg,
		/obj/item/pickaxe/plasmacutter,
		/obj/item/material/knife/machete/cyborg,
		/obj/item/gun/energy/phasegun/mounted/cyborg,
		/obj/item/stack/medical/bruise_pack
	)
	emag = /obj/item/chainsaw
	synths = list(
		/datum/matter_synth/medicine = 7500
	)

/obj/item/robot_module/robot/platform/explorer/finalize_synths()
	..()
	var/datum/matter_synth/medicine/medicine = locate() in synths
	var/obj/item/stack/medical/bruise_pack/bandaid = locate() in modules
	bandaid.uses_charge = 1
	bandaid.charge_costs = list(1000)
	bandaid.synths = list(medicine)

/obj/item/robot_module/robot/platform/explorer/respawn_consumable(var/mob/living/silicon/robot/R, rate)
	. = ..()
	for(var/obj/item/gun/energy/pew in modules)
		if(pew.power_supply && pew.power_supply.charge < pew.power_supply.maxcharge)
			pew.power_supply.give(pew.charge_cost * rate)
			pew.update_icon()
		else
			pew.charge_tick = 0

/obj/item/robot_module/robot/platform/cargo
	name = "logistics platform module"
	display_name = "Logistics"
	unavailable_by_default = FALSE
	armor_color = "#d5b222"
	eye_color =   "#686846"
	decals = list(
		"stripe_vertical" = "#bfbfa1",
		"stripe" =          "#bfbfa1"
	)
	channels = list("Supply" = 1)
	networks = list(NETWORK_MINE)
	max_stored_atoms = 3
	modules = list(
		/obj/item/packageWrap,
		/obj/item/pen/multi,
		/obj/item/destTagger,
	)
	emag = /obj/item/stamp/denied

/obj/item/robot_module/robot/platform/cargo/respawn_consumable(mob/living/silicon/robot/R, rate)
	. = ..()
	var/obj/item/packageWrap/wrapper = locate() in modules
	if(wrapper.amount < initial(wrapper.amount))
		wrapper.amount++
