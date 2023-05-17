/// Prints organs by consuming biomass from an inserted container.
/obj/machinery/bioprinter
	name = "bioprinter"
	desc = "This is a growth chamber capable of quickly producing fresh body parts to fuel your inner mad scientist (or to perform transplants with, if you're boring like that.) Blood samples and biomass go in, kidneys come out."
	description_info = "Consumes specialized biomass from an inserted container. More can be made through chemistry, but it requires a lot of phoron."
	description_fluff = "Bioprinting new body parts can take days or even weeks, depending on the thing in question. However, some printers - like this one - can be built to run on a specialized phoron-based feedstock, allowing surrogate organs and appendages to be assembled in a matter of seconds. Printing in this way is insanely expensive, though, which prevents it from enjoying the ubiquity that slower machines do."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bioprinter"

	anchored = TRUE
	density = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 40
	active_power_usage = 300
	circuit = /obj/item/circuitboard/bioprinter

	/// The reagent used by this bioprinter as fuel to produce things.
	var/biomass_id = "biomass"
	/// The container that biomass will be drawn from; without one, the machine cannot function.
	var/obj/item/reagent_containers/container = null

	/// How long in deciseconds it takes to print an organ. This is updated dynamically by parts.
	var/print_delay = 10 SECONDS
	/// The base time it takes for an organ to be printed. Should be type-specific, can be varedited for adminbus.
	var/base_print_delay = 10 SECONDS
	/// Printing an organ uses a stoppable timer; this variable references that timer's ID.
	/// Checking if this variable is null or not is used to determine whether or not the printer is actually printing.
	var/print_timer
	/// Data from a loaded blood sample, copied directly from the `data` list of `/datum/reagent/blood`.
	var/loaded_dna

	/// Organs printed by this machine might be from a different species, or cause rejection.
	/// Caused by using very high-rating parts (i.e. precursor tech.)
	var/malfunctioning = FALSE
	/// Allows the printer to create "complex" organs, like the brain and larynx.
	/// Granted by using high-quality parts.
	var/complex_organs = FALSE
	/// Allows the printer to create "anomalous" organs that it shouldn't usually be able to.
	/// Granted by using very high-rating parts, like `malfunctioning` is.
	var/anomalous_organs = FALSE

	/// A list of all the products that this bioprinter can produce by default.
	/// 1 unit of biomass (the default fuel) costs 1 unit of phoron,
	/// so each organ costs roughly 20u of phoron (1 sheet) and each limb costs 40u of phoron (2 sheets).
	var/list/products = list(
		"Heart"   = list(/obj/item/organ/internal/heart,  20),
		"Lungs"   = list(/obj/item/organ/internal/lungs,  20),
		"Kidneys" = list(/obj/item/organ/internal/kidneys,20),
		"Eyes"    = list(/obj/item/organ/internal/eyes,   20),
		"Liver"   = list(/obj/item/organ/internal/liver,  20),
		"Spleen"  = list(/obj/item/organ/internal/spleen, 20),
		"Arm, Left"   = list(/obj/item/organ/external/arm,  40),
		"Arm, Right"   = list(/obj/item/organ/external/arm/right,  40),
		"Leg, Left"   = list(/obj/item/organ/external/leg,  40),
		"Leg, Right"   = list(/obj/item/organ/external/leg/right,  40),
		"Foot, Left"   = list(/obj/item/organ/external/foot,  20),
		"Foot, Right"   = list(/obj/item/organ/external/foot/right,  20),
		"Hand, Left"   = list(/obj/item/organ/external/hand,  20),
		"Hand, Right"   = list(/obj/item/organ/external/hand/right,  20)
		)

	/// Dynamically included with `products` if `complex_organs` is true.
	var/list/complex_products = list(
		"Brain" = list(/obj/item/organ/internal/brain, 60),
		"Larynx" = list(/obj/item/organ/internal/voicebox, 20),
		"Head" = list(/obj/item/organ/external/head, 40)
		)

	/// Dynamically included with `products` if `anomalous_organs` is true.
	/// Anything in this list will appear with a purple name in the UI, instead of the default blue.
	var/list/anomalous_products = list(
		"Lymphatic Complex" = list(/obj/item/organ/internal/immunehub, 120),
		"Respiration Nexus" = list(/obj/item/organ/internal/lungs/replicant/mending, 80),
		"Adrenal Valve Cluster" = list(/obj/item/organ/internal/heart/replicant/rage, 80)
		)

/obj/machinery/bioprinter/Initialize()
	. = ..()
	default_apply_parts()

/obj/machinery/bioprinter/full/Initialize()
	. = ..()
	container = new /obj/item/reagent_containers/glass/bottle/biomass(src)

/obj/machinery/bioprinter/dismantle()
	var/turf/T = get_turf(src)
	if (T && container)
		container.forceMove(T)
		container = null
	return ..()

/obj/machinery/bioprinter/attackby(obj/item/I, mob/user)
	if (default_deconstruction_screwdriver(user, I))
		updateUsrDialog()
		return
	if (default_deconstruction_crowbar(user, I))
		return
	if (default_part_replacement(user, I))
		return
	if (default_unfasten_wrench(user, I, 20))
		return
	if (istype(I, /obj/item/reagent_containers/syringe))
		var/obj/item/reagent_containers/syringe/S = I
		var/datum/reagent/blood/sample = S.reagents.get_reagent("blood")
		if (!sample?.data)
			to_chat(user, SPAN_WARNING("\The [I] doesn't contain a valid blood sample."))
			return
		loaded_dna = sample.data
		S.reagents.clear_reagents()
		S.mode = SYRINGE_DRAW
		S.update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] fills \the [src] with a blood sample."),
			SPAN_NOTICE("You inject \the [src] with a blood sample from \the [I].")
		)
		SSnanoui.update_uis(src)
		return
	if (istype(I, /obj/item/reagent_containers/glass))
		if (container)
			to_chat(user, SPAN_WARNING("\The [src] already has a container loaded."))
			return
		var/obj/item/reagent_containers/glass/G = I
		if (!do_after(user, 1 SECOND))
			return
		user.visible_message(
			SPAN_NOTICE("\The [user] loads \the [G] into \the [src]."),
			SPAN_NOTICE("You load \the [G] into \the [src].")
		)
		user.drop_from_inventory(G)
		G.forceMove(src)
		container = G
		SSnanoui.update_uis(src)
		return
	return ..()

/obj/machinery/bioprinter/update_icon()
	cut_overlays()
	if (panel_open)
		add_overlay("bioprinter_panel_open")
	if (print_timer != null)
		add_overlay("bioprinter_working")

/obj/machinery/bioprinter/RefreshParts()
	print_delay = base_print_delay
	var/manip_rating = 0
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		manip_rating += M.rating
		print_delay -= (M.rating - 1) * 1 SECOND
	print_delay = max(0, print_delay)

	// Update the capabilities of the bioprinter based on its rating divided by half.
	// 3 = can print complex organs
	// 4 = can print anomalous organs
	// 5 = 30% chance to malfunction when printing
	manip_rating = round(manip_rating / 2)
	complex_organs = manip_rating >= 3
	anomalous_organs = manip_rating >= 4
	malfunctioning = manip_rating >= 5

	. = ..()

/obj/machinery/bioprinter/attack_hand(mob/user)
	if (stat & (BROKEN|NOPOWER))
		return
	else if (panel_open)
		to_chat(user, SPAN_WARNING("Close the panel first!"))
		return
	ui_interact(user)

/obj/machinery/bioprinter/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, master_ui, datum/topic_state/state)
	var/list/data = build_ui_data()
	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open = force_open)
	if (!ui)
		ui = new(user, src, ui_key, "bioprinter.tmpl", capitalize(name), 500, 650)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/bioprinter/proc/build_ui_data()
	var/data[0]

	data["biomassContainer"] = container
	data["biomassVolume"] = get_biomass_volume()
	data["biomassMax"] = container?.reagents.maximum_volume

	data["printTime"] = print_delay
	data["isPrinting"] = print_timer != null

	data["dna"] = loaded_dna
	data["dnaHash"] = loaded_dna?["blood_DNA"]
	// This is pretty hacky, but it seems like the blood sample doesn't otherwise keep its species data handy
	var/mob/living/carbon/human/donor = loaded_dna?["donor"]
	data["dnaSpecies"] = donor?.species ? donor.species.name : "N/A"

	var/list/valid_products = list()
	valid_products |= products
	if (complex_organs)
		valid_products |= complex_products
	if (anomalous_organs)
		valid_products |= anomalous_products

	var/products_data[0]
	for (var/O in valid_products)
		products_data[++products_data.len] = list(
			"name" = O,
			"cost" = valid_products[O][2],
			"canPrint" = (get_biomass_volume() >= valid_products[O][2]) && loaded_dna,
			"anomalous" = anomalous_products.Find(O)
		)
	data["products"] = products_data

	return data

/obj/machinery/bioprinter/Topic(href, href_list, datum/topic_state/state)
	if (..())
		return TRUE
	if (href_list["ejectBeaker"])
		if (container)
			container.forceMove(get_turf(src))
			if (usr.Adjacent(src))
				usr.put_in_active_hand(container)
			container = null
	if (href_list["flushDNA"])
		if (loaded_dna)
			loaded_dna = null
			visible_message(SPAN_NOTICE("\The [src] whirrs and discards its most recent DNA sample."))
	if (href_list["printOrgan"])
		var/organ_name = href_list["printOrgan"]
		var/list/all_products = products + complex_products + anomalous_products
		var/product_entry = all_products[organ_name]
		var/atom/product_path = product_entry?[1]
		if (product_entry && product_path && get_biomass_volume() >= product_entry[2])
			container.reagents.remove_reagent(biomass_id, product_entry[2])
			playsound(src, "switch", 30)
			visible_message(SPAN_NOTICE("\The [src] fills with fluid and begins to print \a [initial(product_path.name)]."))
			print_timer = addtimer(CALLBACK(src, .proc/print_organ, product_entry[1]), print_delay, TIMER_STOPPABLE)
			set_active(TRUE)
	if (href_list["cancelPrint"])
		if (print_timer)
			playsound(src, "switch", 30)
			playsound(src, 'sound/effects/squelch1.ogg', 40, TRUE)
			visible_message(SPAN_WARNING("\The [src] gurgles as it cancels its current task and discards the pulpy biomass."))
			deltimer(print_timer)
			print_timer = null
			set_active(FALSE)
	SSnanoui.update_uis(src)
	update_icon()

/// Updates power usage in accordance with `active` and forces an icon update.
/obj/machinery/bioprinter/proc/set_active(active)
	update_use_power(active ? USE_POWER_ACTIVE : USE_POWER_IDLE)
	update_icon()

/// Returns the amount of usable biomass that this printer has.
/// 0 will be returned if no container is loaded.
/obj/machinery/bioprinter/proc/get_biomass_volume()
	var/biomass_count = 0
	if (container?.reagents)
		biomass_count += container.reagents.get_reagent_amount(biomass_id)
	return biomass_count

/// Prints an organ of typepath `choice`, with DNA and species set to that of `loaded_dna["donor"]`.
/// If `malfunctioning` is true, has a 30% chance to mess it up as well.
/// Returns a reference to the new organ.
/obj/machinery/bioprinter/proc/print_organ(atom/choice)
	var/mob/living/carbon/human/C = loaded_dna["donor"]
	var/obj/item/organ/O = new choice(get_turf(src))
	O.status |= ORGAN_CUT_AWAY
	O.set_dna(C.dna)
	O.species = C.species

	var/malfunctioned = FALSE
	if (malfunctioning && prob(30)) // Alien Tech is a hell of a drug.
		malfunctioned = TRUE
		var/possible_species = list(SPECIES_HUMAN, SPECIES_VOX, SPECIES_SKRELL, SPECIES_ZADDAT, SPECIES_UNATHI, SPECIES_GOLEM, SPECIES_SHADOW)
		var/new_species = pick(possible_species)
		if (!GLOB.all_species[new_species])
			new_species = SPECIES_HUMAN
		O.species = GLOB.all_species[new_species]

	if (istype(O, /obj/item/organ/external) && !malfunctioned)
		var/obj/item/organ/external/E = O
		E.sync_colour_to_human(C)

	if (O.species)
		// This is a very hacky way of doing of what organ/Initialize() does if it has an owner
		O.w_class = max(O.w_class + mob_size_difference(O.species.mob_size, MOB_MEDIUM), 1)

	print_timer = null
	playsound(src, 'sound/machines/kitchen/microwave/microwave-end.ogg', 50, TRUE)
	visible_message(SPAN_NOTICE("\The [src] dings and spits out \a [O.name]."))
	set_active(FALSE)
	SSnanoui.update_uis(src)
	return O

/obj/item/circuitboard/bioprinter
	name = "bioprinter circuit"
	build_path = /obj/machinery/bioprinter
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	req_components = list(
							/obj/item/stack/cable_coil = 2,
							/obj/item/stock_parts/matter_bin = 2,
							/obj/item/stock_parts/manipulator = 2)
