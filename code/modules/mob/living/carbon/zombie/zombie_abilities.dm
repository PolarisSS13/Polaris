/mob/living/carbon/human/proc/corrosive_acid(O as obj|turf in oview(1)) //If they right click to corrode, an error will flash if its an invalid target./N
	set name = "Corrosive Acid (200)"
	set desc = "Drench an object in acid, destroying it over time."
	set category = "Abilities"

	if(!O in oview(1))
		src << "<span class='alium'>[O] is too far away.</span>"
		return

	// OBJ CHECK
	var/cannot_melt
	if(isobj(O))
		var/obj/I = O
		if(I.unacidable)
			cannot_melt = 1
	else
		if(istype(O, /turf/simulated/wall))
			var/turf/simulated/wall/W = O
			if(W.material.flags & MATERIAL_UNMELTABLE)
				cannot_melt = 1
		else if(istype(O, /turf/simulated/floor))
/*			var/turf/simulated/floor/F = O							//Turfs are qdel'd to space (Even asteroid tiles), will need to be touched by someone smarter than myself. -Mech
			if(F.flooring && (F.flooring.flags & TURF_ACID_IMMUNE))
*/
			cannot_melt = 1

	if(cannot_melt)
		src << "<span class='alium'>You cannot dissolve this object.</span>"
		return

	if(check_alien_ability(200,0,O_ACID))
		new /obj/effect/alien/acid(get_turf(O), O)
		visible_message("<span class='alium'><B>[src] vomits globs of vile stuff all over [O]. It begins to sizzle and melt under the bubbling mess of acid!</B></span>")

	return