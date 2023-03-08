/obj/item/robot_module/flying/filing
	name = "filing drone module"
	display_name = "Filing"
	channels = list(
		"Service" = TRUE,
		"Supply" = TRUE
		)
	sprites = list("Drone" = "drone-service")
	modules = list(
		/obj/item/flash,
		/obj/item/pen/robopen,
		/obj/item/form_printer,
		/obj/item/gripper/paperwork,
		/obj/item/packageWrap,
		/obj/item/hand_labeler,
		/obj/item/stamp,
		/obj/item/stamp/denied,
		/obj/item/destTagger,
		/obj/item/tool/crowbar,
		/obj/item/megaphone
	)
	emag = /obj/item/stamp/chameleon
