/*
 * Augments. This file contains the base, and organic-targeting augments.
 */

/obj/item/organ/internal/augment
	name = "augment"

	icon_state = "cell_bay"

	parent_organ = BP_TORSO

	organ_verbs = list(/mob/living/carbon/human/proc/augment_menu)	// Verbs added by the organ when present in the body.
	target_parent_classes = list()	// Is the parent supposed to be organic, robotic, assisted?
	forgiving_class = FALSE	// Will the organ give its verbs when it isn't a perfect match? I.E., assisted in organic, synthetic in organic.

	var/obj/item/integrated_object	// Objects held by the organ, used for re-usable, deployable things.
	var/integrated_object_type	// Object type the organ will spawn.
	var/target_slot = null

	var/silent_deploy = FALSE

	var/image/my_radial_icon = null
	var/radial_icon = null	// DMI for the augment's radial icon.
	var/radial_name = null	// The augment's name in the Radial Menu.
	var/radial_state = null	// Icon state for the augment's radial icon.

/obj/item/organ/internal/augment/Initialize()
	..()

	setup_radial_icon()

	if(integrated_object_type)
		integrated_object = new integrated_object_type(src)
		integrated_object.canremove = FALSE

/obj/item/organ/internal/augment/proc/setup_radial_icon()
	if(!radial_icon)
		radial_icon = icon
	if(!radial_name)
		radial_name = name
	if(!radial_state)
		radial_state = icon_state
	my_radial_icon = image(icon = radial_icon, icon_state = radial_state)

/obj/item/organ/internal/augment/handle_organ_mod_special(var/removed = FALSE)
	if(removed && integrated_object && integrated_object.loc != src)
		if(isliving(integrated_object.loc))
			var/mob/living/L = integrated_object.loc
			L.drop_from_inventory(integrated_object)
		integrated_object.forceMove(src)
	..(removed)

/obj/item/organ/internal/augment/proc/augment_action()
	if(!owner)
		return

	var/item_to_equip = integrated_object
	if(!item_to_equip && integrated_object_type)
		item_to_equip = integrated_object_type

	if(ispath(item_to_equip))
		owner.equip_augment_item(target_slot, item_to_equip, silent_deploy, FALSE)
	else
		owner.equip_augment_item(target_slot, item_to_equip, silent_deploy, FALSE, src)

/*
 * The delicate handling of augment-controlled items.
 */

// Attaches to the end of dropped items' code.

/obj/item
	var/destroy_on_drop = FALSE	// Used by augments to determine if the item should destroy itself when dropped, or return to its master.
	var/obj/item/organ/my_augment = null	// Used to reference the object's host organ.

/obj/item/dropped(mob/user)
	. = ..()
	if(src)
		if(destroy_on_drop && !QDELETED(src))
			qdel(src)
			return
		if(my_augment)
			forceMove(my_augment)

/*
 * SUBTYPES
 */

// The base organic-targeting augment.

/obj/item/organ/internal/augment/bioaugment
	name = "bioaugmenting implant"

	robotic = ORGAN_ROBOT
	target_parent_classes = list(ORGAN_FLESH)

/* Jensen Shades. Your vision can be augmented.
 * This, technically, no longer needs its unique organ verb, however I have chosen to leave it for posterity
 * in the event it needs to be referenced, while still remaining perfectly functional with either system.
 */

/obj/item/organ/internal/augment/bioaugment/thermalshades
	name = "integrated thermolensing implant"
	desc = "A miniscule implant that houses a pair of thermolensed sunglasses. Don't ask how they deploy, you don't want to know."
	icon_state = "augment_shades"
	dead_icon = "augment_shades_dead"

	w_class = ITEMSIZE_TINY

	organ_tag = O_AUG_TSHADE

	parent_organ = BP_HEAD

	organ_verbs = list(
		/mob/living/carbon/human/proc/augment_menu,
		/mob/living/carbon/human/proc/toggle_shades)

	integrated_object_type = /obj/item/clothing/glasses/hud/security/jensenshades

/obj/item/organ/internal/augment/bioaugment/thermalshades/augment_action()
	if(!owner)
		return

	owner.toggle_shades()

/obj/item/organ/internal/augment/armmounted
	name = "laser rifle implant"
	desc = "A large implant that fits into a subject's arm. It deploys a laser-emitting array by some painful means."

	icon_state = "augment_laser"

	w_class = ITEMSIZE_LARGE

	organ_tag = O_AUG_L_FOREARM

	parent_organ = BP_L_ARM

	target_slot = slot_l_hand

	target_parent_classes = list(ORGAN_FLESH, ORGAN_ASSISTED)

	integrated_object_type = /obj/item/weapon/gun/energy/laser/mounted/augment

/obj/item/organ/internal/augment/armmounted/attackby(obj/item/I as obj, mob/user as mob)
	if(I.is_screwdriver())
		switch(organ_tag)
			if(O_AUG_L_FOREARM)
				organ_tag = O_AUG_R_FOREARM
				parent_organ = BP_R_ARM
				target_slot = slot_r_hand
			if(O_AUG_R_FOREARM)
				organ_tag = O_AUG_L_FOREARM
				parent_organ = BP_L_ARM
				target_slot = slot_l_hand
		to_chat(user, "<span class='notice'>You swap \the [src]'s servos to install neatly into \the lower [parent_organ] mount.</span>")
		return

	. = ..()

/obj/item/organ/internal/augment/armmounted/taser
	name = "taser implant"
	desc = "A large implant that fits into a subject's arm. It deploys a taser-emitting array by some painful means."

	icon_state = "augment_taser"

	integrated_object_type = /obj/item/weapon/gun/energy/taser/mounted/augment

/obj/item/organ/internal/augment/armmounted/dartbow
	name = "crossbow implant"
	desc = "A small implant that fits into a subject's arm. It deploys a dart launching mechanism through the flesh through unknown means."

	icon_state = "augment_dart"

	w_class = ITEMSIZE_SMALL

	integrated_object_type = /obj/item/weapon/gun/energy/crossbow

// The toolkit / multi-tool implant.

/obj/item/organ/internal/augment/armmounted/multiple
	name = "rotary toolkit"
	desc = "A large implant that fits into a subject's arm. It deploys an array of tools by some painful means."

	icon_state = "augment_toolkit"

	organ_tag = O_AUG_R_UPPERARM

	w_class = ITEMSIZE_HUGE

	integrated_object_type = /obj/item/weapon/tool/screwdriver

	toolspeed = 0.8

	var/list/integrated_tools = list(
		/obj/item/weapon/tool/screwdriver = null,
		/obj/item/weapon/tool/wrench = null,
		/obj/item/weapon/tool/crowbar = null,
		/obj/item/weapon/tool/wirecutters = null,
		/obj/item/device/multitool = null,
		/obj/item/stack/cable_coil/gray = null,
		/obj/item/weapon/tape_roll = null
		)

	var/list/integrated_tools_by_name

	var/list/integrated_tool_images

	var/list/synths

	var/list/synth_types = list(
		/datum/matter_synth/wire
		)

/obj/item/organ/internal/augment/armmounted/multiple/Initialize()
	..()

	integrated_tools[integrated_object_type] = integrated_object

	integrated_tools_by_name = list()

	integrated_tool_images = list()

	if(synth_types)
		synths = list()
		for(var/datumpath in synth_types)
			var/datum/matter_synth/MS = new datumpath
			synths += MS

	for(var/path in integrated_tools)
		if(!integrated_tools[path])
			integrated_tools[path] = new path(src)
		var/obj/item/I = integrated_tools[path]
		I.canremove = FALSE
		I.toolspeed = toolspeed
		I.my_augment = src
		I.name = "integrated [I.name]"

	for(var/tool in integrated_tools)
		var/obj/item/Tool = integrated_tools[tool]
		if(istype(Tool, /obj/item/stack))
			var/obj/item/stack/S = Tool
			S.synths = synths
			S.uses_charge = synths.len
		integrated_tools_by_name[Tool.name] = Tool
		integrated_tool_images[Tool.name] = image(icon = Tool.icon, icon_state = Tool.icon_state)

/obj/item/organ/internal/augment/armmounted/multiple/handle_organ_proc_special()
	..()

	if(!owner || is_bruised() || !synths)
		return

	if(prob(20))
		for(var/datum/matter_synth/MS in synths)
			MS.add_charge(MS.recharge_rate)

/obj/item/organ/internal/augment/armmounted/multiple/attackby(obj/item/I as obj, mob/user as mob)
	if(I.is_screwdriver())
		switch(organ_tag)
			if(O_AUG_L_UPPERARM)
				organ_tag = O_AUG_R_UPPERARM
				parent_organ = BP_R_ARM
				target_slot = slot_r_hand
			if(O_AUG_R_UPPERARM)
				organ_tag = O_AUG_L_UPPERARM
				parent_organ = BP_L_ARM
				target_slot = slot_l_hand
		to_chat(user, "<span class='notice'>You swap \the [src]'s servos to install neatly into \the upper [parent_organ] mount.</span>")
		return

	. = ..()

/obj/item/organ/internal/augment/armmounted/multiple/augment_action()
	if(!owner)
		return

	var/list/options = list()

	for(var/Iname in integrated_tools_by_name)
		options[Iname] = integrated_tool_images[Iname]

	var/list/choice = list()
	if(length(options) == 1)
		for(var/key in options)
			choice = key
	else
		choice = show_radial_menu(owner, owner, options)

	integrated_object = integrated_tools_by_name[choice]

	..()

/obj/item/organ/internal/augment/armmounted/multiple/medical
	name = "rotary medical kit"
	icon_state = "augment_medkit"
	integrated_object_type = /obj/item/weapon/surgical/hemostat

	integrated_tools = list(
		/obj/item/weapon/surgical/hemostat = null,
		/obj/item/weapon/surgical/retractor = null,
		/obj/item/weapon/surgical/cautery = null,
		/obj/item/weapon/surgical/surgicaldrill = null,
		/obj/item/weapon/surgical/scalpel = null,
		/obj/item/weapon/surgical/circular_saw = null,
		/obj/item/weapon/surgical/bonegel = null,
		/obj/item/weapon/surgical/FixOVein = null,
		/obj/item/weapon/surgical/bonesetter = null,
		/obj/item/stack/medical/crude_pack = null
		)

	synth_types = list(
		/datum/matter_synth/bandage
		)

/*
 * Human-specific mob procs.
 */

/mob/living/carbon/human/proc/toggle_shades()
	set name = "Toggle Integrated Thermoshades"
	set desc = "Toggle your flash-proof, thermal-integrated sunglasses."
	set category = "Augments"

	var/obj/item/organ/internal/augment/aug = internal_organs_by_name[O_AUG_TSHADE]

	if(glasses)
		if(aug && aug.integrated_object == glasses)
			drop_from_inventory(glasses)
			aug.integrated_object.forceMove(aug)
			if(!glasses)
				to_chat(src, "<span class='alien'>Your [aug.integrated_object] retract into your skull.</span>")
		else if(!istype(glasses, /obj/item/clothing/glasses/hud/security/jensenshades))
			to_chat(src, "<span class='notice'>\The [glasses] block your shades from deploying.</span>")
		else if(istype(glasses, /obj/item/clothing/glasses/hud/security/jensenshades))
			var/obj/item/G = glasses
			if(G.canremove)
				to_chat(src, "<span class='notice'>\The [G] are not your integrated shades.</span>")
			else
				drop_from_inventory(G)
				to_chat(src, "<span class='notice'>\The [G] retract into your skull.</span>")
				qdel(G)

	else
		if(aug && aug.integrated_object)
			to_chat(src, "<span class='alien'>Your [aug.integrated_object] deploy.</span>")
			equip_to_slot(aug.integrated_object, slot_glasses, 0, 1)
			if(!glasses || glasses != aug.integrated_object)
				aug.integrated_object.forceMove(aug)
		else
			var/obj/item/clothing/glasses/hud/security/jensenshades/J = new(get_turf(src))
			equip_to_slot(J, slot_glasses, 1, 1)
			to_chat(src, "<span class='notice'>Your [aug.integrated_object] deploy.</span>")

// The next two procs simply handle the radial menu for augment activation.

/mob/living/carbon/human/proc/augment_menu()
	set name = "Open Augment Menu"
	set desc = "Toggle your augment menu."
	set category = "Augments"

	enable_augments(usr)

/mob/living/carbon/human/proc/enable_augments(var/mob/living/user)
	var/list/options = list()

	var/list/present_augs = list()

	for(var/obj/item/organ/internal/augment/Aug in internal_organs)
		if(Aug.my_radial_icon && !Aug.is_broken() && Aug.check_verb_compatability())
			present_augs[Aug.radial_name] = Aug

	for(var/augname in present_augs)
		var/obj/item/organ/internal/augment/iconsource = present_augs[augname]
		options[augname] = iconsource.my_radial_icon

	var/list/choice = list()
	if(length(options) == 1)
		for(var/key in options)
			choice = key
	else
		choice = show_radial_menu(user, src, options)

	if(!isnull(choice) && options[choice])
		var/obj/item/organ/internal/augment/A = present_augs[choice]
		A.augment_action(user)

/* equip_augment_item
 * Used to equip an organ's augment items when possible.
 * slot is the target equip slot, if it's not a generic either-hand deployable,
 * equipping is either the target object, or a path for the target object,
 * destroy_on_drop is the default value for the object to be deleted if it is removed from their person, if equipping is a path, however, this will be set to TRUE,
 * cling_to_organ is a reference to the organ object itself, so they can easily return to their organ when removed by any means.
 */

/mob/living/carbon/human/proc/equip_augment_item(var/slot, var/obj/item/equipping = null, var/make_sound = TRUE, var/destroy_on_drop = FALSE, var/obj/item/organ/cling_to_organ = null)
	if(!ishuman(src))
		return 0

	var/mob/living/carbon/human/M = src

	if((slot == slot_l_hand && l_hand) || (slot == slot_r_hand && r_hand))
		to_chat(M,"<span class='warning'>Your hand is full.  Drop something first.</span>")
		return 0

	var/del_if_failure = destroy_on_drop

	if(ispath(equipping))
		del_if_failure = TRUE
		equipping = new equipping(src)

	if(!slot)
		put_in_any_hand_if_possible(equipping, del_if_failure)

	else
		if(slot_is_accessible(slot, equipping, src))
			equip_to_slot(equipping, slot, 1, 1)
		else if(destroy_on_drop || del_if_failure)
			qdel(equipping)
			return 0

	if(cling_to_organ) // Does the object automatically return to the organ?
		equipping.my_augment = cling_to_organ

	if(make_sound)
		playsound(src, 'sound/items/change_jaws.ogg', 30, 1)

	if(equipping.loc != src)
		equipping.dropped()

	return 1
