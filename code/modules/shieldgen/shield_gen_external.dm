//---------- external shield generator
//generates an energy field that loops around any built up area in space (is useless inside) halts movement and airflow, is blocked by walls, windows, airlocks etc

/obj/machinery/shield_gen/external
	name = "hull shield generator"

/obj/machinery/shield_gen/external/preset/New()
	..()
	component_parts += new /obj/item/weapon/circuitboard/shield_gen_ex(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator/pico(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator/pico(src)
	component_parts += new /obj/item/weapon/stock_parts/subspace/transmitter(src)
	component_parts += new /obj/item/weapon/stock_parts/subspace/crystal(src)
	component_parts += new /obj/item/weapon/stock_parts/subspace/amplifier(src)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(src)
	component_parts += new /obj/item/stack/cable_coil(src, 5)
	//RefreshParts() - uncomment if you add upgrade effects

//NOT MULTIZ COMPATIBLE
//Search for space turfs within range that are adjacent to a simulated turf.
/obj/machinery/shield_gen/external/get_shielded_turfs()
	var/list/out = list()
	
	var/turf/gen_turf = get_turf(src)
	if (!gen_turf)
		return
	
	var/turf/T
	for (var/x_offset = -field_radius; x_offset <= field_radius; x_offset++)
		for (var/y_offset = -field_radius; y_offset <= field_radius; y_offset++)
			T = locate(gen_turf.x + x_offset, gen_turf.y + y_offset, gen_turf.z)
			if (istype(T, /turf/space))
				//check neighbors of T
				if (locate(/turf/simulated/) in orange(1, T))
					out += T
	return out
