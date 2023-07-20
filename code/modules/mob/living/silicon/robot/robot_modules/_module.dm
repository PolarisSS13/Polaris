/obj/item/robot_module
	name = "robot module"
	icon = 'icons/obj/module.dmi'
	icon_state = "std_module"
	w_class = ITEMSIZE_NO_CONTAINER
	item_state = "std_mod"

	var/unavailable_by_default
	var/display_name
	var/hide_on_manifest = FALSE
	var/channels = list()
	var/networks = list()
	var/languages = list(
		LANGUAGE_SOL_COMMON = 1,
		LANGUAGE_SIVIAN= 0,
		LANGUAGE_TRADEBAND = 1,
		LANGUAGE_UNATHI = 0,
		LANGUAGE_SIIK = 0,
		LANGUAGE_AKHANI = 0,
		LANGUAGE_SKRELLIAN = 0,
		LANGUAGE_GUTTER = 0,
		LANGUAGE_SCHECHI = 0,
		LANGUAGE_SIGN = 0,
		LANGUAGE_TERMINUS = 1,
		LANGUAGE_ZADDAT = 0
	)
	var/sprites = list()
	var/can_be_pushed = 1
	var/no_slip = 0
	var/list/modules = list()
	var/list/datum/matter_synth/synths = list()
	var/obj/item/emag = null
	var/obj/item/borg/upgrade/advhealth = null
	var/list/subsystems = list()
	var/list/obj/item/borg/upgrade/supported_upgrades = list()

	var/obj/item/tank/jetpack/jetpack

	var/list/universal_equipment = list(
		/obj/item/flash/robot,
		/obj/item/tool/crowbar/cyborg,
		/obj/item/extinguisher,
		/obj/item/gps/robot
	)
	// Module categorization values.
	var/module_category = ROBOT_MODULE_TYPE_GROUNDED
	var/upgrade_locked = FALSE
	var/crisis_locked = FALSE

	// Bookkeeping
	var/list/original_languages = list()
	var/list/added_networks = list()

/obj/item/robot_module/proc/hide_on_manifest()
	. = hide_on_manifest

/obj/item/robot_module/Initialize(var/ml)
	. = ..()
	var/mob/living/silicon/robot/R = loc
	if(!istype(R))
		return INITIALIZE_HINT_QDEL

	R.module = src

	build_equipment(R)
	build_emag(R)
	build_synths(R)

	finalize_equipment(R)
	finalize_emag(R)
	finalize_synths(R)

	add_camera_networks(R)
	add_languages(R)
	add_subsystems(R)
	apply_status_flags(R)
	handle_shell(R)

	if(R.radio)
		addtimer(CALLBACK(R.radio, /obj/item/radio/proc/recalculateChannels), 0)

	R.set_module_sprites(sprites)
	addtimer(CALLBACK(R, /mob/living/silicon/robot/proc/choose_icon, R.module_sprites.len + 1, R.module_sprites), 0)

/obj/item/robot_module/proc/build_equipment()
	SHOULD_CALL_PARENT(TRUE)
	for(var/thing in (modules|universal_equipment))
		modules -= thing
		if(ispath(thing, /obj/item))
			modules += new thing(src)
		else if(isitem(thing))
			var/obj/item/I = thing
			I.forceMove(src)
			modules += I
		else
			log_debug("Invalid var type in [type] equipment creation - [thing]")
	if(ispath(jetpack))
		jetpack = new jetpack(src)

/obj/item/robot_module/proc/finalize_equipment()
	SHOULD_CALL_PARENT(TRUE)
	for(var/obj/item/I in modules)
		I.canremove = FALSE
	if(jetpack)
		if(istype(jetpack))
			jetpack.canremove = FALSE
			var/mob/living/silicon/robot/robit = loc
			if(istype(robit))
				jetpack.forceMove(robit)
				robit.internals = jetpack
		else
			log_debug("Invalid var type in [type] jetpack creation - [jetpack]")
			jetpack = null

/obj/item/robot_module/proc/build_emag()
	SHOULD_CALL_PARENT(TRUE)
	if(ispath(emag))
		emag = new emag(src)

/obj/item/robot_module/proc/finalize_emag()
	SHOULD_CALL_PARENT(TRUE)
	if(emag)
		if(istype(emag))
			emag.canremove = FALSE
		else
			log_debug("Invalid var type in [type] emag creation - [emag]")
			emag = null

/obj/item/robot_module/proc/build_synths()
	SHOULD_CALL_PARENT(TRUE)
	for(var/thing in synths)
		if(istype(thing, /datum/matter_synth))
			continue
		if(!ispath(thing, /datum/matter_synth))
			log_debug("Invalid var type in [type] synth creation - [thing]")
			continue
		if(isnull(synths[thing]))
			synths += new thing
		else
			synths += new thing(synths[thing])
		synths -= thing

/obj/item/robot_module/proc/finalize_synths()
	SHOULD_CALL_PARENT(TRUE)
	return

/obj/item/robot_module/proc/Reset(var/mob/living/silicon/robot/R)
	remove_camera_networks(R)
	remove_languages(R)
	remove_subsystems(R)
	remove_status_flags(R)

	if(R.radio)
		R.radio.recalculateChannels()
	R.choose_icon(0, R.set_module_sprites(list("Default" = "robot")))

// This can qdel before init if spawned outside a mob, so
// Destroy() needs to be a bit nuanced to avoid runtimes.
/obj/item/robot_module/Destroy()
	for(var/datum/thing in modules)
		qdel(thing)
// Robot icons unit test needs the module types list.
#ifndef UNIT_TEST
	modules = null
#endif
	for(var/datum/thing in synths)
		qdel(thing)
	synths = null
	if(istype(emag))
		QDEL_NULL(emag)
	if(istype(jetpack))
		QDEL_NULL(jetpack)
	return ..()

/obj/item/robot_module/emp_act(severity)
	if(modules)
		for(var/obj/O in modules)
			O.emp_act(severity)
	if(emag)
		emag.emp_act(severity)
	if(synths)
		for(var/datum/matter_synth/S in synths)
			S.emp_act(severity)
	..()
	return

/obj/item/robot_module/proc/respawn_consumable(var/mob/living/silicon/robot/R, var/rate)
	if(!synths || !synths.len)
		return

	for(var/datum/matter_synth/T in synths)
		T.add_charge(T.recharge_rate * rate)

/obj/item/robot_module/proc/rebuild()//Rebuilds the list so it's possible to add/remove items from the module
	var/list/temp_list = modules
	modules = list()
	for(var/obj/O in temp_list)
		if(O)
			modules += O

/obj/item/robot_module/proc/add_languages(var/mob/living/silicon/robot/R)
	// Stores the languages as they were before receiving the module, and whether they could be synthezized.
	for(var/datum/language/language_datum in R.languages)
		original_languages[language_datum] = (language_datum in R.speech_synthesizer_langs)

	for(var/language in languages)
		R.add_language(language, languages[language])

/obj/item/robot_module/proc/remove_languages(var/mob/living/silicon/robot/R)
	// Clear all added languages, whether or not we originally had them.
	for(var/language in languages)
		R.remove_language(language)

	// Then add back all the original languages, and the relevant synthezising ability
	for(var/original_language in original_languages)
		R.add_language(original_language, original_languages[original_language])
	original_languages.Cut()

/obj/item/robot_module/proc/add_camera_networks(var/mob/living/silicon/robot/R)
	if(R.camera && (NETWORK_ROBOTS in R.camera.network))
		for(var/network in networks)
			if(!(network in R.camera.network))
				R.camera.add_network(network)
				added_networks |= network

/obj/item/robot_module/proc/remove_camera_networks(var/mob/living/silicon/robot/R)
	if(R.camera)
		R.camera.remove_networks(added_networks)
	added_networks.Cut()

/obj/item/robot_module/proc/add_subsystems(var/mob/living/silicon/robot/R)
	R.verbs |= subsystems

/obj/item/robot_module/proc/remove_subsystems(var/mob/living/silicon/robot/R)
	R.verbs -= subsystems

/obj/item/robot_module/proc/apply_status_flags(var/mob/living/silicon/robot/R)
	if(!can_be_pushed)
		R.status_flags &= ~CANPUSH

/obj/item/robot_module/proc/remove_status_flags(var/mob/living/silicon/robot/R)
	if(!can_be_pushed)
		R.status_flags |= CANPUSH

/obj/item/robot_module/proc/handle_shell(var/mob/living/silicon/robot/R)
	if(R.braintype == BORG_BRAINTYPE_AI_SHELL)
		channels = list(
			"Medical" = 1,
			"Engineering" = 1,
			"Security" = 1,
			"Service" = 1,
			"Supply" = 1,
			"Science" = 1,
			"Command" = 1,
			"Explorer" = 1
			)
