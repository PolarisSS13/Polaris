/mob/living/carbon/standard_weapon_hit_effects(obj/item/I, mob/living/user, var/effective_force, var/blocked, var/soaked, var/hit_zone)
	if(!effective_force || blocked >= 100)
		return 0

	//Hulk modifier
	if(HULK in user.mutations)
		effective_force *= 2

	//If the armor soaks all of the damage, it just skips the rest of the checks
	if(effective_force <= soaked)
		return 0

	//Apply weapon damage
	var/weapon_sharp = is_sharp(I)
	var/weapon_edge = has_edge(I)
	var/hit_embed_chance = I.embed_chance
	if(prob(getarmor(hit_zone, "melee"))) //melee armour provides a chance to turn sharp/edge weapon attacks into blunt ones
		weapon_sharp = 0
		weapon_edge = 0
		hit_embed_chance = I.force/(I.w_class*3)

	apply_damage(effective_force, I.damtype, hit_zone, blocked, soaked, sharp=weapon_sharp, edge=weapon_edge, used_weapon=I)

	//Melee weapon embedded object code.
	if (I && I.damtype == BRUTE && !I.anchored && !is_robot_module(I) && I.embed_chance > 0)
		var/damage = effective_force
		if (blocked)
			damage *= (100 - blocked)/100
			hit_embed_chance *= (100 - blocked)/100

		//blunt objects should really not be embedding in things unless a huge amount of force is involved
		var/embed_threshold = weapon_sharp? 5*I.w_class : 15*I.w_class

		if(damage > embed_threshold && prob(hit_embed_chance))
			src.embed(I, hit_zone)

	return 1
