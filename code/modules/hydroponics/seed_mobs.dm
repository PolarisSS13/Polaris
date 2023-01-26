// The following procs are used to grab players for mobs produced by a seed (mostly for dionaea).
/datum/seed/proc/handle_living_product(var/mob/living/host)

	if(!host || !istype(host)) return

	if(apply_color_to_mob)
		host.color = traits[TRAIT_PRODUCT_COLOUR]

	var/datum/ghosttrap/plant/P = get_ghost_trap("living plant")
	P.request_player(host, "Someone is harvesting [display_name]. ")

	spawn(75)
		if(!host.ckey && !host.client)
			host.death()  // This seems redundant, but a lot of mobs don't
			host.set_stat(DEAD) // handle death() properly. Better safe than etc.
			host.visible_message("<span class='danger'>[host] is malformed and unable to survive. It expires pitifully, leaving behind some seeds.</span>")

			var/total_yield = rand(1,3)
			for(var/j = 0;j<=total_yield;j++)
				var/obj/item/seeds/S = new(get_turf(host))
				S.seed_type = name
				S.update_seed()

// Returns null, if the plant doesn't produce mobs, or the mob produced.
/datum/seed/proc/create_hostile_mob(var/turf/T)
	if(!T)
		return

	if(ispath(get_trait(TRAIT_UNIQUE_PRODUCT), /mob/living))
		var/MobPath = get_trait(TRAIT_UNIQUE_PRODUCT)
		var/mob/living/L = new MobPath(T)
		L.faction = "plant"	// Plants together strong.

		if(!L.ai_holder)
			if(ishuman(L))	// By default, the only humanoid that plants can make is a monkey. Hence, prior reference.
				L.ai_holder = new /datum/ai_holder/simple_mob/humanoid/hostile(L)
				L.a_intent = I_HURT
				if(!L.hud_used)
					L.hud_used = new /datum/hud(L)
					L.create_mob_hud(L.hud_used)
			else
				L.ai_holder = new /datum/ai_holder/simple_mob/guard(L)
			L.ai_holder.hostile = TRUE
		else
			L.ai_holder.hostile = TRUE

		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			H.real_name = "[display_name] [H.real_name]"

		L.name = "[display_name] [L.name]"

		return L
