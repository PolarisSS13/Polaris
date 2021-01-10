
/datum/cultist/spell/agonizingsphere
	name = "Agonizing Sphere"
	desc = "Opens a microscopic hole to the plane of elemental suffering. Too small to be used in alchemical processes, but perfectly painful to nearby mortals."
	cost = 300
	ability_icon_state = "const_rune"
	obj_path = /obj/item/weapon/spell/construct/spawner/agonizing_sphere
	category = CULT_OFFENSIVE_SPELLS


//Harvester Pain Orb

/obj/item/weapon/spell/construct/spawner/agonizing_sphere
	name = "sphere of agony"
	desc = "Call forth a portal to a dimension of naught but pain at your target."

	spawner_type = /obj/effect/temporary_effect/pulse/agonizing_sphere

/obj/item/weapon/spell/construct/spawner/agonizing_sphere/on_ranged_cast(atom/hit_atom, mob/user)
	if(within_range(hit_atom) && pay_energy(bloodcost))
		..()

/obj/item/weapon/spell/construct/spawner/agonizing_sphere/on_throw_cast(atom/hit_atom, mob/user)
	pay_energy(bloodcost / 2)
	if(isliving(hit_atom))
		var/mob/living/L = hit_atom
		L.add_modifier(/datum/modifier/agonize, 10 SECONDS)

/obj/effect/temporary_effect/pulse/agonizing_sphere
	name = "agonizing sphere"
	desc = "A portal to some hellish place. Its screams wrack your body with pain.."
	icon_state = "red_static_sphere"
	time_to_die = null
	light_range = 4
	light_power = 5
	light_color = "#FF0000"
	pulses_remaining = 10
	pulse_delay = 1 SECOND

/obj/effect/temporary_effect/pulse/agonizing_sphere/on_pulse()
	for(var/mob/living/L in view(4,src))
		if(!iscultist(L) && !istype(L, /mob/living/simple_mob/construct))
			L.add_modifier(/datum/modifier/agonize, 2 SECONDS)
			if(L.isSynthetic())
				to_chat(L, "<span class='cult'>Your chassis warps as the [src] pulses!</span>")
				L.adjustFireLoss(4)
