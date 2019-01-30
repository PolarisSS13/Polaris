
/turf/simulated/floor/water
	var/has_fish = TRUE //If the water has fish or not.

	var/list/rare_fish_list = list(/mob/living/simple_animal/fish/salmon, /mob/living/simple_animal/fish/pike)
	var/list/common_fish_list = list(/mob/living/simple_animal/fish/bass)
	var/list/uncommon_fish_list = list(/mob/living/simple_animal/fish/trout)
	var/list/junk_list = list(/obj/item/clothing/shoes/boots/cowboy)

	var/fish_type
	var/min_fishing_time = 5
	var/max_fishing_time = 30



/turf/simulated/floor/water/proc/pick_fish()
	var/chance_uncommon = 15
	var/chance_junk = 30
	var/chance_rare = 5
	var/chance_common = 40
	if(has_fish)
		if(prob(chance_rare) && rare_fish_list.len) // You won THE GRAND PRIZE!
			fish_type = pick(rare_fish_list)

		else if(prob(chance_uncommon) && uncommon_fish_list.len) // Otherwise you might still get something good.
			fish_type = pick(uncommon_fish_list)

		else if(prob(chance_junk) && junk_list.len) // Hah. Boots.
			fish_type = pick(junk_list)

		else if(prob(chance_common) && common_fish_list.len) // Otherwise you might still get something good.
			fish_type = pick(common_fish_list)

		else // Welp.
			fish_type = null
	else
		fish_type = null


/turf/simulated/floor/water/attackby(obj/item/weapon/P as obj, mob/user as mob)
//If you use a fishing rod on an open body of water that var/has_fish enabled
	if(istype(P, /obj/item/weapon/material/fishing_rod))
		playsound(src, 'sound/effects/footstep/slosh2.ogg', 5, 1, 5)
		user << "You cast [P.name] into the [src]."
		if(do_after(user,rand(min_fishing_time SECONDS,max_fishing_time SECONDS),user))
			playsound(src, 'sound/effects/footstep/slosh1.ogg', 5, 1, 5)
			user << "<span>You feel a tug and begin pulling!</span>"
			pick_fish()
			//List of possible outcomes.
			if(!fish_type)
				user << "You caught... nothing. How sad."
			else
				var/fished = new fish_type(src)
				user << "<span>You fish out [fished] from the water with [P.name]!</span>"



