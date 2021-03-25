/obj/item/weapon/energy_net
	name = "energy net"
	desc = "It's a net made of green energy."
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"
	throwforce = 0
	force = 0
	var/net_type = /obj/effect/energy_net

/obj/item/weapon/energy_net/dropped()
	spawn(10)
		if(src) qdel(src)

/obj/item/weapon/energy_net/throw_impact(atom/hit_atom)
	..()

	var/mob/living/M = hit_atom

	if(!istype(M) || locate(/obj/effect/energy_net) in M.loc)
		qdel(src)
		return 0

	var/turf/T = get_turf(M)
	if(T)
		var/obj/effect/energy_net/net = new net_type(T)
		if(net.buckle_mob(M))
			T.visible_message("[M] was caught in an energy net!")
		qdel(src)

	// If we miss or hit an obstacle, we still want to delete the net.
	spawn(10)
		if(src) qdel(src)

/obj/effect/energy_net
	name = "energy net"
	desc = "It's a net made of green energy."
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"

	density = 1
	opacity = 0
	mouse_opacity = 1
	anchored = 0

	can_buckle = 1
	buckle_lying = 0
	buckle_dir = SOUTH

	var/escape_time = 8 SECONDS

/obj/effect/energy_net/New()
	..()
	START_PROCESSING(SSobj, src)

/obj/effect/energy_net/Destroy()
	if(has_buckled_mobs())
		for(var/A in buckled_mobs)
			to_chat(A, "<span class='notice'>You are free of the net!</span>")
			unbuckle_mob(A)

	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/energy_net/process()
	if(!has_buckled_mobs())
		qdel(src)

/obj/effect/energy_net/user_unbuckle_mob(mob/living/buckled_mob, mob/user)
	user.setClickCooldown(user.get_attack_speed())
	visible_message("<span class='danger'>[user] begins to tear at \the [src]!</span>")
	if(do_after(user, escape_time, src, incapacitation_flags = INCAPACITATION_DEFAULT & ~(INCAPACITATION_RESTRAINED | INCAPACITATION_BUCKLED_FULLY)))
		if(!has_buckled_mobs())
			return
		visible_message("<span class='danger'>[user] manages to tear \the [src] apart!</span>")
		unbuckle_mob(buckled_mob)

/obj/effect/energy_net/post_buckle_mob(mob/living/M)
	if(M.buckled == src) //Just buckled someone
		..()
		layer = M.layer+1
		M.can_pull_size = 0
	else //Just unbuckled someone
		M.can_pull_size = initial(M.can_pull_size)
		qdel(src)
