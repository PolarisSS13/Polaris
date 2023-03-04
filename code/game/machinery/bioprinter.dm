// GENERIC PRINTER - DO NOT USE THIS OBJECT.
// Flesh and robot printers are defined below this object.

/obj/machinery/organ_printer
	name = "organ printer"
	desc = "It's a machine that prints organs."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bioprinter"

	anchored = TRUE
	density = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 40
	active_power_usage = 300

	var/obj/item/reagent_containers/container = null		// This is the beaker that holds all of the biomass

	var/print_delay = 10 SECONDS
	var/base_print_delay = 10 SECONDS // For Adminbus reasons
	var/printing
	var/print_timer
	var/loaded_dna //Blood sample for DNA hashing.

	var/malfunctioning = FALSE	// May cause rejection, or the printing of some alien limb instead!
	var/complex_organs = FALSE	// Can it print more 'complex' organs?
	var/anomalous_organs = FALSE	// Can it print anomalous organs?

	// These should be subtypes of /obj/item/organ
	// Costs roughly 20u Phoron (1 sheet) per internal organ, limbs are 60u for limb and extremity
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

	var/list/complex_products = list(
		"Brain" = list(/obj/item/organ/internal/brain, 60),
		"Larynx" = list(/obj/item/organ/internal/voicebox, 20),
		"Head" = list(/obj/item/organ/external/head, 40)
		)

	var/list/anomalous_products = list(
		"Lymphatic Complex" = list(/obj/item/organ/internal/immunehub, 120),
		"Respiration Nexus" = list(/obj/item/organ/internal/lungs/replicant/mending, 80),
		"Adrenal Valve Cluster" = list(/obj/item/organ/internal/heart/replicant/rage, 80)
		)

/obj/machinery/organ_printer/attackby(var/obj/item/O, var/mob/user)
	if(default_deconstruction_screwdriver(user, O))
		updateUsrDialog()
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return
	if(default_unfasten_wrench(user, O, 20))
		return
	return ..()

/obj/machinery/organ_printer/update_icon()
	cut_overlays()
	if(panel_open)
		add_overlay("bioprinter_panel_open")
	if(printing)
		add_overlay("bioprinter_working")

/obj/machinery/organ_printer/Initialize()
	. = ..()
	default_apply_parts()

/obj/machinery/organ_printer/RefreshParts()
	// Print Delay updating
	print_delay = base_print_delay
	var/manip_rating = 0
	for(var/obj/item/stock_parts/manipulator/manip in component_parts)
		manip_rating += manip.rating
		print_delay -= (manip.rating-1)*10
	print_delay = max(0,print_delay)

	manip_rating = round(manip_rating / 2)

	if(manip_rating >= 5)
		malfunctioning = TRUE
	else
		malfunctioning = initial(malfunctioning)

	if(manip_rating >= 3)
		complex_organs = TRUE
		if(manip_rating >= 4)
			anomalous_organs = TRUE
			if(manip_rating >= 5)
				malfunctioning = TRUE
	else
		complex_organs = initial(complex_organs)
		anomalous_organs = initial(anomalous_organs)
		malfunctioning = initial(malfunctioning)

	. = ..()

/obj/machinery/organ_printer/attack_hand(mob/user)
	if (stat & (BROKEN|NOPOWER))
		return
	else if (panel_open)
		to_chat(user, SPAN_WARNING("Close the panel first!"))
		return
	tgui_interact(user)

/obj/machinery/organ_printer/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Bioprinter", name)
		ui.open()

/obj/machinery/organ_printer/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data[0]

	data["biomassContainer"] = container
	data["biomassVolume"] = get_biomass_volume()
	data["biomassMax"] = container?.reagents.maximum_volume

	data["printTime"] = print_delay
	data["isPrinting"] = printing

	data["dna"] = loaded_dna
	data["dnaHash"] = loaded_dna?["blood_DNA"]
	// This is pretty hacky, but it seems like the blood sample doesn't otherwise keep its species data handy
	var/mob/living/carbon/human/donor = loaded_dna?["donor"]
	data["dnaSpecies"] = donor?.species ? donor.species.name : "N/A"

	var/list/products_data = list()
	for (var/O in products)
		products_data +=  list(list(
			"name" = O,
			"cost" = products[O][2],
			"canPrint" = get_biomass_volume() >= products[O][2] && loaded_dna,
			"anomalous" = anomalous_products.Find(O)
		))
	data["products"] = products_data

	return data

/obj/machinery/organ_printer/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if (..())
		return TRUE
	switch (action)
		if ("ejectBeaker")
			if (container)
				container.forceMove(get_turf(src))
				if (usr.Adjacent(src))
					usr.put_in_active_hand(container)
				container = null
		if ("flushDNA")
			if (loaded_dna)
				loaded_dna = null
				visible_message(SPAN_NOTICE("\The [src] whirrs as it flushes its most recent DNA sample."))
		if ("printOrgan")
			var/organ_name = params["organName"]
			var/product_entry = products[organ_name]
			var/atom/product_path = product_entry?[1]
			if (!product_entry || !product_path || get_biomass_volume() < product_entry[2])
				return
			container.reagents.remove_reagent("biomass", product_entry[2])
			playsound(src, "switch", 30)
			visible_message(SPAN_NOTICE("\The [src] fills with fluid and begins to print a new [initial(product_path.name)]."))
			set_active(TRUE)
			print_timer = addtimer(CALLBACK(src, .proc/print_organ, product_entry[1]), print_delay, TIMER_STOPPABLE)
		if ("cancelPrint")
			if (!print_timer)
				return
			playsound(src, "switch", 30)
			playsound(src, 'sound/effects/squelch1.ogg', 40, TRUE)
			visible_message(SPAN_DANGER("\The [src] gurgles as it cancels its current task and discards the pulpy biomass."))
			deltimer(print_timer)
			set_active(FALSE)

/obj/machinery/organ_printer/proc/set_active(active, silent)
	update_use_power(active ? USE_POWER_ACTIVE : USE_POWER_IDLE)
	printing = active
	update_icon()

// Checks for reagents, then reports how much biomass it has in it
/obj/machinery/organ_printer/proc/get_biomass_volume()
	var/biomass_count = 0
	if(container && container.reagents)
		for(var/datum/reagent/R in container.reagents.reagent_list)
			if(R.id == "biomass")
				biomass_count += R.volume

	return biomass_count

/obj/machinery/organ_printer/proc/print_organ(var/choice)
	update_use_power(USE_POWER_IDLE)
	printing = 0
	update_icon()
	var/new_organ = choice
	var/obj/item/organ/O = new new_organ(get_turf(src))
	O.status |= ORGAN_CUT_AWAY
	var/mob/living/carbon/human/C = loaded_dna["donor"]
	O.set_dna(C.dna)
	O.species = C.species

	var/malfunctioned = FALSE

	if(malfunctioning && prob(30)) // Alien Tech is a hell of a drug.
		malfunctioned = TRUE
		var/possible_species = list(SPECIES_HUMAN, SPECIES_VOX, SPECIES_SKRELL, SPECIES_ZADDAT, SPECIES_UNATHI, SPECIES_GOLEM, SPECIES_SHADOW)
		var/new_species = pick(possible_species)
		if(!GLOB.all_species[new_species])
			new_species = SPECIES_HUMAN
		O.species = GLOB.all_species[new_species]

	if(istype(O, /obj/item/organ/external) && !malfunctioned)
		var/obj/item/organ/external/E = O
		E.sync_colour_to_human(C)

	O.pixel_x = rand(-6.0, 6)
	O.pixel_y = rand(-6.0, 6)

	if(O.species)
		// This is a very hacky way of doing of what organ/New() does if it has an owner
		O.w_class = max(O.w_class + mob_size_difference(O.species.mob_size, MOB_MEDIUM), 1)

	return O
// END GENERIC PRINTER

// CIRCUITS
/obj/item/circuitboard/bioprinter
	name = "bioprinter circuit"
	build_path = /obj/machinery/organ_printer/flesh
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	req_components = list(
							/obj/item/stack/cable_coil = 2,
							/obj/item/stock_parts/matter_bin = 2,
							/obj/item/stock_parts/manipulator = 2)

// FLESH ORGAN PRINTER
/obj/machinery/organ_printer/flesh
	name = "bioprinter"
	desc = "This is a growth chamber capable of quickly producing fresh body parts to fuel your inner mad scientist (or to perform transplants with, if you're boring like that.) Blood samples and biomass go in, kidneys come out."
	description_fluff = "Bioprinting new body parts can take days or even weeks, depending on the thing in question. However, some printers - like this one - can be built to run on a specialized phoron-based feedstock, allowing surrogate organs and appendages to be assembled in a matter of seconds. Printing in this way is insanely expensive, though, which prevents it from enjoying the ubiquity that slower machines do."
	icon_state = "bioprinter"
	circuit = /obj/item/circuitboard/bioprinter

/obj/machinery/organ_printer/flesh/full/Initialize()
	. = ..()
	container = new /obj/item/reagent_containers/glass/bottle/biomass(src)

/obj/machinery/organ_printer/flesh/dismantle()
	var/turf/T = get_turf(src)
	if(T)
		if(container)
			container.forceMove(T)
			container = null
	return ..()

/obj/machinery/organ_printer/flesh/print_organ(var/choice)
	var/obj/item/organ/O = ..()
	playsound(src, 'sound/machines/kitchen/microwave/microwave-end.ogg', 50, TRUE)
	visible_message(SPAN_NOTICE("\The [src] dings and spits out a newly-grown [O.name]."))
	return O

/obj/machinery/organ_printer/flesh/attackby(obj/item/W, mob/user)
	if (istype(W, /obj/item/reagent_containers/syringe))
		var/obj/item/reagent_containers/syringe/S = W
		var/datum/reagent/blood/sample = S.reagents.get_reagent("blood")
		if (!sample?.data)
			to_chat(user, SPAN_WARNING("\The [W] doesn't contain a valid blood sample."))
			return
		loaded_dna = sample.data
		S.reagents.clear_reagents()
		S.mode = SYRINGE_DRAW
		S.update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] fills \the [src] with a blood sample."),
			SPAN_NOTICE("You inject \the [src] with a blood sample from \the [W].")
		)
		return
	else if (istype(W, /obj/item/reagent_containers/glass))
		if (container)
			to_chat(user, SPAN_WARNING("\The [src] already has a container loaded."))
			return
		var/obj/item/reagent_containers/glass/G = W
		if (!do_after(user, 1 SECOND))
			return
		user.visible_message(
			SPAN_NOTICE("\The [user] loads \the [G] into \the [src]."),
			SPAN_NOTICE("You load \the [G] into \the [src].")
		)
		user.drop_from_inventory(G)
		G.forceMove(src)
		container = G
		return
	. = ..()
