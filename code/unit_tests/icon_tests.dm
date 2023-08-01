/datum/unit_test/robot_module_icons_shall_be_valid
	name = "ICONS: Robot module icons shall be valid"
	var/list/check_module_categories = list(
		ROBOT_MODULE_TYPE_GROUNDED,
		ROBOT_MODULE_TYPE_FLYING
	)
	var/list/panel_overlays = list(
		"ov-openpanel +w",
		"ov-openpanel +c",
		"ov-openpanel -c"
	)
	var/list/gear_to_check = list(
		/obj/item/borg/combat/shield   = "-shield",
		/obj/item/borg/combat/mobility = "-roll"
	)

/datum/unit_test/robot_module_icons_shall_be_valid/start_test()

	var/list/failures = list()
	// fetch our icon states to check against
	var/list/icon_state_cache = list(
		ROBOT_MODULE_TYPE_GROUNDED = icon_states('icons/mob/robots/robots_grounded.dmi'),
		ROBOT_MODULE_TYPE_FLYING   = icon_states('icons/mob/robots/robots_flying.dmi')
	)

	var/list/found_states = list() // Keep track of this for checking for unused states later.

	// Kick it off by doing a sprite check on all flying and grounded modules.
	for(var/module_type in typesof(/obj/item/robot_module))

		// Skip abstract modules and think-tanks as they do icon gen differently.
		var/obj/item/robot_module/module = module_type
		if(!initial(module.display_name) || !(initial(module.module_category) in check_module_categories))
			continue

		module = new module // this will automatically qdelete, but we just want the sprites.

		// Check that the expected states are actually in the icon file.
		var/check_states = icon_state_cache[module.module_category]
		for(var/sprite in module.sprites)

			// Basic sprite.
			var/check_state = module.sprites[sprite]
			if(check_state in check_states)
				LAZYDISTINCTADD(found_states[module.module_category], check_state)
			else
				failures += "missing base state '[check_state]' for [module.display_name] ([module.module_category])"

			// Eyes overlay.
			var/eye_check_state = "eyes-[check_state]"
			if(eye_check_state in check_states)
				LAZYDISTINCTADD(found_states[module.module_category], eye_check_state)
			else
				failures += "missing eyes state '[eye_check_state]' for [module.display_name] ([module.module_category])"

			// Equipment overlays.
			for(var/geartype in gear_to_check)
				var/suffix = gear_to_check[geartype]
				for(var/gear in module.modules)
					if(!ispath(gear, geartype))
						continue
					var/gear_check_state = "[check_state][suffix]"
					if(gear_check_state in check_states)
						LAZYDISTINCTADD(found_states[module.module_category], gear_check_state)
					else
						failures += "missing gear state '[gear_check_state]' for [module.display_name] ([module.module_category])"
					break

			// Check for drone AI eyes.
			if(istype(module, /obj/item/robot_module/drone))
				var/ai_eye_state = "[eye_check_state]-ai"
				if(ai_eye_state in check_states)
					LAZYDISTINCTADD(found_states[module.module_category], ai_eye_state)
				else
					failures += "missing drone AI control state '[ai_eye_state]' for [module.display_name] ([module.module_category])"

	// Check for missing panel states.
	for(var/module_category in check_module_categories)
		var/list/check_states = icon_state_cache[module_category]
		for(var/panel_state in panel_overlays)
			if(panel_state in check_states)
				LAZYDISTINCTADD(found_states[module_category], panel_state)
			else
				failures += "missing panel state '[panel_state]' for [module_category]"

	// Now we can do tachikoma sprites.
	var/list/tachikoma_icon_states = list()
	for(var/module_type in typesof(/obj/item/robot_module/robot/platform))
		// Skip abstract modules.
		var/obj/item/robot_module/robot/platform/module = module_type
		if(!initial(module.display_name) || !initial(module.module_category) || !initial(module.user_icon))
			continue

		// We need a module instance to check the decal list.
		module = new module_type
		if(!tachikoma_icon_states[module.user_icon])
			tachikoma_icon_states[module.user_icon] = icon_states(module.user_icon)
			LAZYDISTINCTADD(icon_state_cache[ROBOT_MODULE_TYPE_PLATFORM], tachikoma_icon_states[module.user_icon])

/*
unexpected state 'tachi_cross' for platform
unexpected state 'tachi-open-wires' for platform
unexpected state 'tachi-open-cell' for platform
*/
		var/list/states_to_check = list(
			"blank",
			module.user_icon_state,
			"[module.user_icon_state]-open",
			"[module.user_icon_state]-wires",
			"[module.user_icon_state]-cell",
			"[module.user_icon_state]-nowires"
		)
		if(module.armor_color)
			states_to_check += "[module.user_icon_state]_armour"
		for(var/decal in module.decals)
			states_to_check += "[module.user_icon_state]_[decal]"
		if(module.eye_color)
			states_to_check += "[module.user_icon_state]_eyes"
		if(module.pupil_color)
			states_to_check += "[module.user_icon_state]_pupils"

		for(var/check_state in states_to_check)
			if(check_state in tachikoma_icon_states[module.user_icon])
				LAZYDISTINCTADD(found_states[ROBOT_MODULE_TYPE_PLATFORM], check_state)
			else
				failures += "missing platform state '[check_state]' in icon file [module.user_icon]"

	// Check that there aren't any unexpected states.
	for(var/module_category in icon_state_cache)
		var/list/check_found_states = LAZYACCESS(found_states, module_category)
		for(var/check_state in icon_state_cache[module_category])
			if(!(check_state in check_found_states))
				failures += "unexpected state '[check_state]' for [module_category]"

	if(length(failures))
		fail("Some robot module sprites are invalid:\n" + failures.Join("\n"))
	else
		pass("All robot module sprites are valid.")
	return 1
