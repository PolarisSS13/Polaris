/mob/living/carbon/human/proc/revive_undead()
	set name = "Rise from Death"
	set desc = "Allows you to come back once you've died. This won't work without a brain however."
	set category = "Zombie"

	var/mob/living/carbon/human/C = src

	if(src.stat == DEAD)
		if(!has_brain(C))
			C << "<span class='notice'>You have no vessel! The connection between the parasitic entity within you and your brain is severed. You are dead, for real.</span>"
			return
		else
			dead_mob_list -= src
			living_mob_list += src

			if(!isundead(C))
				return 0
			C << "<span class='notice'>The parasitic entity inside you begins knitting your decomposing form back together. This will take <b>three and a half minutes</b>.</span>"
			C.visible_message("<span class='warning'>\The [C]'s entire form seems to twitch in a very unsettling way.</span>")


			if(do_after(user = C, delay = 2100, needhand = 0, incapacitation_flags = null))

				C.tod = null
				C.setToxLoss(0)
				C.setOxyLoss(0)
				C.setCloneLoss(0)
				C.SetParalysis(0)
				C.SetStunned(0)
				C.SetWeakened(0)
				C.radiation = 0
				C.heal_overall_damage(C.getBruteLoss(), C.getFireLoss())
				C.reagents.clear_reagents()
				if(ishuman(C))
					var/mob/living/carbon/human/H = src
					H.species.create_organs(H)
					H.restore_all_organs(ignore_prosthetic_prefs=1) //Covers things like fractures and other things not covered by the above.
					H.restore_blood()
					H.mutations.Remove(HUSK)
					H.status_flags &= ~DISFIGURED
					H.update_icons_body()
					for(var/limb in H.organs_by_name)
						var/obj/item/organ/external/current_limb = H.organs_by_name[limb]
						if(current_limb)
							current_limb.relocate()
							current_limb.open = 0

					BITSET(H.hud_updateflag, HEALTH_HUD)
					BITSET(H.hud_updateflag, STATUS_HUD)
					BITSET(H.hud_updateflag, LIFE_HUD)


					C.halloss = 0
					C.shock_stage = 0 //Pain
					C << "<span class='notice'>You rise from the dead.</span>"
					C.update_canmove()
					C.stat = CONSCIOUS
					C.forbid_seeing_deadchat = FALSE
					C.timeofdeath = null
					return 1
			else
				C << "<span class='notice'>Your vessel is interrupted.</span>"

	else
		C << "<span class='alium'>You can only use this while dead.</span>"
		return

/mob/living/carbon/human/proc/fermented_goo(O as obj|turf in oview(1)) //If they right click to corrode, an error will flash if its an invalid target./N
	set name = "Fermented Goo"
	set desc = "Drench an object in a foul goo, destroying it over time."
	set category = "Zombie"

	if(src.stat == DEAD)
		src << "<span class='alium'>You can't use this while dead!</span>"
	else
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
		else
			new /obj/effect/alien/acid(get_turf(O), O)
			visible_message("<span class='alium'><B>[src] spits out a foul smelling goo on [O]. It seems to be corrosive!</B></span>")

		return