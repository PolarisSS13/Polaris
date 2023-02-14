
/obj/mecha/medical/serenity
	desc = "A lightweight exosuit made from a modified Gygax chassis combined with proprietary VeyMed medical tech. It's faster and sturdier than most medical mechs, but much of the armor plating has been stripped out, leaving it more vulnerable than a regular Gygax."
	name = "Serenity"
	icon_state = "medgax"
	initial_icon = "medgax"
	health = 150
	maxhealth = 150
	deflect_chance = 20
	step_in = 2
	max_temperature = 20000
	overload_coeff = 1
	wreckage = /obj/effect/decal/mecha_wreckage/gygax/serenity
	max_equip = 3
	step_energy_drain = 8
	cargo_capacity = 2
	max_hull_equip = 2
	max_weapon_equip = 0
	max_utility_equip = 2
	max_universal_equip = 1
	max_special_equip = 1

	overload_possible = 1

	force = 20	// 10 less than normal combat exos.
	melee_can_hit = TRUE
	melee_sound = 'sound/weapons/heavysmash.ogg'

	var/obj/item/clothing/glasses/hud/health/mech/hud

/obj/mecha/medical/serenity/Initialize()
	. = ..()
	hud = new /obj/item/clothing/glasses/hud/health/mech(src)
	return

/obj/mecha/medical/serenity/moved_inside(var/mob/living/carbon/human/H as mob)
	if(..())
		if(istype(H))	// Safety for brains, and other theoretical pilots.
			if(H.glasses)
				occupant_message("<font color='red'>[H.glasses] prevent you from using [src] [hud]</font>")
			else
				H.glasses = hud
				H.recalculate_vis()
		return 1
	else
		return 0

/obj/mecha/medical/serenity/go_out()
	if(ishuman(occupant))
		var/mob/living/carbon/human/H = occupant
		if(H.glasses == hud)
			H.glasses = null
			H.recalculate_vis()
	..()
	return

/obj/mecha/medical/serenity/melee_action(atom/T)
	if(internal_damage&MECHA_INT_CONTROL_LOST)
		T = safepick(oview(1,src))
	if(!melee_can_hit)
		return
	if(istype(T, /mob/living))
		var/mob/living/M = T
		if(src.occupant.a_intent == I_HURT || istype(src.occupant, /mob/living/carbon/brain)) //Brains cannot change intents; Exo-piloting brains lack any form of physical feedback for control, limiting the ability to 'play nice'.
			playsound(src, 'sound/weapons/heavysmash.ogg', 50, 1)
			if(damtype == "brute")
				step_away(M,src,15)
			/*
			if(M.stat>1)
				M.gib()
				melee_can_hit = 0
				if(do_after(melee_cooldown))
					melee_can_hit = 1
				return
			*/
			if(ishuman(T))
				var/mob/living/carbon/human/H = T
	//			if (M.health <= 0) return

				var/obj/item/organ/external/temp = H.get_organ(pick(BP_TORSO, BP_TORSO, BP_TORSO, BP_HEAD))
				if(temp)
					var/update = 0
					switch(damtype)
						if("brute")
							H.Paralyse(1)
							update |= temp.take_damage(rand(force/2, force), 0)
						if("fire")
							update |= temp.take_damage(0, rand(force/2, force))
						if("tox")
							if(H.reagents)
								if(H.reagents.get_reagent_amount("carpotoxin") + force < force*2)
									H.reagents.add_reagent("carpotoxin", force)
								if(H.reagents.get_reagent_amount("cryptobiolin") + force < force*2)
									H.reagents.add_reagent("cryptobiolin", force)
						if("halloss")
							H.stun_effect_act(1, force / 2, BP_TORSO, src)
						else
							return
					if(update)	H.UpdateDamageIcon()
				H.updatehealth()

			else
				switch(damtype)
					if("brute")
						M.Paralyse(1)
						M.take_overall_damage(rand(force/2, force))
					if("fire")
						M.take_overall_damage(0, rand(force/2, force))
					if("tox")
						if(M.reagents)
							if(M.reagents.get_reagent_amount("carpotoxin") + force < force*2)
								M.reagents.add_reagent("carpotoxin", force)
							if(M.reagents.get_reagent_amount("cryptobiolin") + force < force*2)
								M.reagents.add_reagent("cryptobiolin", force)
					else
						return
				M.updatehealth()
			src.occupant_message("You hit [T].")
			src.visible_message("<font color='red'><b>[src.name] hits [T].</b></font>")
		else
			step_away(M,src)
			src.occupant_message("You push [T] out of the way.")
			src.visible_message("[src] pushes [T] out of the way.")

		melee_can_hit = 0
		if(do_after(melee_cooldown))
			melee_can_hit = 1
		return

	else
		if(istype(T, /obj/machinery/disposal)) // Stops mechs from climbing into disposals
			return
		if(src.occupant.a_intent == I_HURT || istype(src.occupant, /mob/living/carbon/brain)) // Don't smash unless we mean it
			if(damtype == "brute")
				src.occupant_message("You hit [T].")
				src.visible_message("<font color='red'><b>[src.name] hits [T]</b></font>")
				playsound(src, 'sound/weapons/heavysmash.ogg', 50, 1)

				if(istype(T, /obj/structure/girder))
					T:take_damage(force * 3) //Girders have 200 health by default. Steel, non-reinforced walls take four punches, girders take (with this value-mod) two, girders took five without.
				else
					T:take_damage(force)

				melee_can_hit = 0

				if(do_after(melee_cooldown))
					melee_can_hit = 1
	return
