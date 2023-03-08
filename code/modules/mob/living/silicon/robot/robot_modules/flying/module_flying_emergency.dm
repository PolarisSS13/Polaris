/obj/item/robot_module/flying/emergency
	name = "emergency response drone module"
	display_name = "Emergency Response"
	channels = list("Medical" = TRUE)
	networks = list(NETWORK_MEDICAL)
	//subsystems = list(/datum/nano_module/crew_monitor)
	sprites = list(
		"Drone" = "drone-medical",
		"Eyebot" = "eyebot-medical"
	)
	modules = list(
		/obj/item/flash,
		/obj/item/borg/sight/hud/med,
		/obj/item/healthanalyzer,
		/obj/item/reagent_scanner/adv,
		/obj/item/reagent_containers/borghypo/crisis,
		/obj/item/extinguisher/mini,
		/obj/item/taperoll/medical,
		/obj/item/inflatable_dispenser/robot,
		/obj/item/weldingtool/mini,
		/obj/item/tool/screwdriver,
		/obj/item/tool/wrench,
		/obj/item/tool/crowbar,
		/obj/item/tool/wirecutters,
		/obj/item/multitool,
		/obj/item/stack/medical/advanced/ointment,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/medical/splint,
		/obj/item/roller_holder,
		/obj/item/shockpaddles/robot,
		/obj/item/gripper/medical,
		/obj/item/reagent_containers/spray/cleaner/drone
	)
	synths = list(/datum/matter_synth/medicine = 15000)
	emag = /obj/item/reagent_containers/spray

/obj/item/robot_module/flying/emergency/finalize_emag()
	. = ..()
	emag.reagents.add_reagent("pacid", 250)
	emag.name = "polyacid spray"

/obj/item/robot_module/flying/emergency/finalize_equipment()
	. = ..()
	for(var/thing in list(/obj/item/stack/medical/advanced/ointment, /obj/item/stack/medical/advanced/bruise_pack, /obj/item/stack/medical/splint))
		var/obj/item/stack/medical/stack = locate(thing) in modules
		stack.uses_charge = 1
		stack.charge_costs = list(1000)

/obj/item/robot_module/flying/emergency/finalize_synths()
	. = ..()
	var/datum/matter_synth/medicine/medicine = locate() in synths
	for(var/thing in list(
		 /obj/item/stack/medical/advanced/ointment,
		 /obj/item/stack/medical/advanced/bruise_pack,
		 /obj/item/stack/medical/splint
		))
		var/obj/item/stack/medical/stack = locate(thing) in modules
		stack.synths = list(medicine)

/obj/item/robot_module/flying/emergency/respawn_consumable(mob/living/silicon/robot/R, amount)
	var/obj/item/reagent_containers/spray/PS = emag
	if(PS && PS.reagents.total_volume < PS.volume)
		var/adding = min(PS.volume-PS.reagents.total_volume, 2*amount)
		if(adding > 0)
			PS.reagents.add_reagent(/datum/reagent/acid/polyacid, adding)
	..()
