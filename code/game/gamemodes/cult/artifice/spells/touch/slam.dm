
/datum/cultist/spell/slam
	name = "Alchemical Fist"
	desc = "Empower your fist, allowing you to slam a target, sending them flying, or to destroy a wall in one punch."
	cost = 150
	ability_icon_state = "const_fist"
	obj_path = /obj/item/weapon/spell/construct/slam
	category = CULT_OFFENSIVE_SPELLS

//Juggernaut Slam
/obj/item/weapon/spell/construct/slam
	name = "slam"
	desc = "Empower your FIST, to send an opponent flying."
	icon_state = "toggled_old"
	cast_methods = CAST_MELEE
	aspect = ASPECT_UNHOLY
	light_color = "#FF5C5C"
	light_power = -2
	cooldown = 15
	bloodcost = 30

/obj/item/weapon/spell/construct/slam/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)
	var/attack_message = "slams"
	if(pay_energy(bloodcost))
		if(istype(user, /mob/living/simple_mob))
			var/mob/living/simple_mob/S = user
			attack_message = pick(S.attacktext)
		if(isliving(hit_atom))
			var/mob/living/L = hit_atom
			L.visible_message("<span class='danger'>\The [user] [attack_message] \the [L], sending them flying!</span>")
			playsound(src, "punch", 50, 1)
			L.Weaken(2)
			L.adjustBruteLoss(rand(30, 50))
			var/throwdir = get_dir(src, L)
			L.throw_at(get_edge_target_turf(L, throwdir), 3, 1, src)
		if(istype(hit_atom, /obj/mecha))
			var/obj/mecha/M = hit_atom
			user.visible_message("<span class='danger'>\The [user] [attack_message] \the [M], sending it tumbling backwards!</span>")
			M.take_damage(rand(30,50))
			if(ishuman(M.occupant))
				to_chat(M.occupant, "<span class='danger'>\The [M]'s sudden movement throws you against the compartment!.</span>")
				var/blocked = M.occupant.run_armor_check(BP_TORSO,"melee")
				var/soaked = M.occupant.get_armor_soak(BP_TORSO,"melee")
				M.occupant.apply_damage(rand(20,30),BRUTE, BP_TORSO, blocked, soaked, src)
				M.occupant.apply_effect(rand(1 SECOND, 3 SECONDS), STUN, blocked, 1)
			var/throwdir = get_dir(src, M)
			M.throw_at(get_edge_target_turf(M, throwdir), 2, 1, src)
		if(istype(hit_atom, /turf/simulated/wall))
			var/turf/simulated/wall/W = hit_atom
			user.visible_message("<span class='warning'>\The [user] rears its fist, preparing to hit \the [W]!</span>")
			var/windup = cooldown
			if(W.reinf_material)
				windup = cooldown * 2
			if(do_after(user, windup))
				W.visible_message("<span class='danger'>\The [user] [attack_message] \the [W], obliterating it!</span>")
				W.dismantle_wall(1)
			else
				user.visible_message("<span class='notice'>\The [user] lowers its fist.</span>")
				return
	qdel(src)
