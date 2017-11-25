
/obj/machinery/chemical_dispenser
	var/_recharge_reagents = 1
	var/list/dispense_reagents = list()
	var/process_tick = 0

/obj/machinery/chemical_dispenser/process()
	if(!_recharge_reagents)
		return
	if(stat & (BROKEN|NOPOWER))
		return
	if(--process_tick <= 0)
		process_tick = 15
		. = 0
		for(var/id in dispense_reagents)
			var/datum/reagent/R = chemical_reagents_list[id]
			if(!R)
				crash_with("[src] at [x],[y],[z] failed to find reagent '[id]'!")
				dispense_reagents -= id
				continue
			var/obj/item/weapon/reagent_containers/chem_disp_cartridge/C = cartridges[R.name]
			if(C && C.reagents.total_volume < C.reagents.maximum_volume)
				var/to_restore = min(C.reagents.maximum_volume - C.reagents.total_volume, 5)
				use_power(to_restore * 500)
				C.reagents.add_reagent(id, to_restore)
				. = 1
		if(.)
			nanomanager.update_uis(src)



/obj/machinery/chemical_dispenser
	dispense_reagents = list(
		/datum/reagent/hydrogen, /datum/reagent/lithium, /datum/reagent/carbon, /datum/reagent/nitrogen, /datum/reagent/oxygen, /datum/reagent/fluorine,
		/datum/reagent/sodium, /datum/reagent/aluminum, /datum/reagent/silicon, /datum/reagent/phosphorus, /datum/reagent/sulfur, /datum/reagent/chlorine,
		/datum/reagent/potassium, /datum/reagent/iron, /datum/reagent/copper, /datum/reagent/mercury, /datum/reagent/radium, /datum/reagent/water,
		/datum/reagent/ethanol, /datum/reagent/sugar, /datum/reagent/acid, /datum/reagent/tungsten
		)

/obj/machinery/chemical_dispenser/ert
	dispense_reagents = list(
		/datum/reagent/inaprovaline, /datum/reagent/ryetalyn, /datum/reagent/paracetamol, /datum/reagent/tramadol, /datum/reagent/oxycodone,
		/datum/reagent/sterilizine, /datum/reagent/leporazine, /datum/reagent/kelotane, /datum/reagent/dermaline, /datum/reagent/dexalin,
		/datum/reagent/dexalinp, /datum/reagent/tricordrazine, /datum/reagent/dylovene, /datum/reagent/synaptizine,	/datum/reagent/hyronalin,
		/datum/reagent/arithrazine, /datum/reagent/alkysine, /datum/reagent/imidazoline, /datum/reagent/peridaxon, /datum/reagent/bicaridine,
		/datum/reagent/hyperzine, /datum/reagent/rezadone, /datum/reagent/spaceacillin, /datum/reagent/ethylredoxrazine, /datum/reagent/soporific,
		/datum/reagent/chloralhydrate, /datum/reagent/cryoxadone, /datum/reagent/clonexadone
		)

/obj/machinery/chemical_dispenser/bar_soft
	dispense_reagents = list(
		/datum/reagent/water, /datum/reagent/drink/ice, /datum/reagent/drink/coffee, /datum/reagent/drink/milk/cream, /datum/reagent/drink/tea,
		/datum/reagent/drink/tea/icetea, /datum/reagent/drink/soda/space_cola, /datum/reagent/drink/soda/spacemountainwind, /datum/reagent/drink/soda/dr_gibb,
		/datum/reagent/drink/soda/space_up, /datum/reagent/drink/soda/tonic, /datum/reagent/drink/soda/sodawater, /datum/reagent/drink/soda/lemon_lime,
		/datum/reagent/sugar, /datum/reagent/drink/juice/orange, /datum/reagent/drink/juice/lime, /datum/reagent/drink/juice/watermelon,
		/datum/reagent/ethanol/thirteenloko, /datum/reagent/drink/soda/grapesoda
		)

/obj/machinery/chemical_dispenser/bar_alc
	dispense_reagents = list(
		/datum/reagent/drink/soda/lemon_lime, /datum/reagent/sugar, /datum/reagent/drink/juice/orange, /datum/reagent/drink/juice/lime,
		/datum/reagent/drink/soda/sodawater, /datum/reagent/drink/soda/tonic, /datum/reagent/ethanol/beer, /datum/reagent/ethanol/coffee/kahlua,
		/datum/reagent/ethanol/whiskey, /datum/reagent/ethanol/wine, /datum/reagent/ethanol/vodka, /datum/reagent/ethanol/gin, /datum/reagent/ethanol/rum,
		/datum/reagent/ethanol/tequilla, /datum/reagent/ethanol/vermouth, /datum/reagent/ethanol/cognac, /datum/reagent/ethanol/ale, /datum/reagent/ethanol/mead
		)

/obj/machinery/chemical_dispenser/bar_coffee
	dispense_reagents = list(
		/datum/reagent/drink/coffee, /datum/reagent/drink/coffee/cafe_latte, /datum/reagent/drink/coffee/soy_latte, /datum/reagent/drink/hot_coco,
		/datum/reagent/drink/milk, /datum/reagent/drink/milk/cream, /datum/reagent/drink/tea, /datum/reagent/drink/ice, /datum/reagent/drink/juice/orange,
		/datum/reagent/drink/juice/lemon, /datum/reagent/drink/juice/lime, /datum/reagent/drink/juice/berry, /datum/reagent/nutriment/mint
		)