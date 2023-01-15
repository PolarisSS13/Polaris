/obj/item/robot_module/flying/forensics
	name = "forensic drone module"
	display_name = "Forensics"
	channels = list("Security" = TRUE)
	networks = list(NETWORK_SECURITY)
	sprites = list(
		"Drone" = "drone-sec",
		"Eyebot" = "eyebot-security"
	)
	equipment = list(
		/obj/item/evidencebag,
		/obj/item/forensics/sample_kit,
		/obj/item/forensics/sample_kit/powder,
		/obj/item/gripper/security,
		/obj/item/flash,
		/obj/item/borg/sight/hud/sec,
		/obj/item/taperoll/police,
		/obj/item/surgical/scalpel/laser1,
		/obj/item/autopsy_scanner,
		/obj/item/reagent_scanner,
		/obj/item/reagent_containers/spray/luminol,
		/obj/item/uv_light,
		/obj/item/tool/crowbar
	)
	emag = /obj/item/gun/energy/laser/mounted

/obj/item/robot_module/flying/forensics/respawn_consumable(mob/living/silicon/robot/R, amount)
	var/obj/item/reagent_containers/spray/luminol/luminol = locate() in equipment
	if(!luminol)
		luminol = new(src)
		equipment += luminol
	if(luminol.reagents.total_volume < luminol.volume)
		var/adding = min(luminol.volume-luminol.reagents.total_volume, 2*amount)
		if(adding > 0)
			luminol.reagents.add_reagent(/datum/reagent/luminol, adding)
	..()
