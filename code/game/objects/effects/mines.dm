/obj/effect/mine
	name = "mine"
	desc = "Normal procedure is to jump 200 feet in the air and scatter yourself over a wide area."
	density = 0
	anchored = 1
	layer = 3
	icon = 'icons/obj/weapons.dmi'
	icon_state = "uglymine"
	var/triggerproc = "explode" //name of the proc called when the mine is triggered
	var/triggered = 0
	var/smoke_strength = 3
	var/mineitemtype = /obj/item/weapon/mine
	var/exposed = 0
	var/isolated = 0

/obj/effect/mine/New()
	icon_state = "uglyminearmed"

/obj/effect/mine/bullet_act()
	if(prob(25))
		call(src, triggerproc)()

/obj/effect/mine/Crossed(AM as mob|obj)
	Bumped(AM)

/obj/effect/mine/Bumped(mob/M as mob|obj)

	if(triggered) return

	if(istype(M, /mob/living/))
		call(src,triggerproc)(M)

/obj/effect/mine/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/screwdriver))
		if(src.exposed == 0)
			to_chat(user, "<span class='notice'>You begin to unscrew the cover from \the [src]...</span>")
			if(do_after(user, 30))
				src.exposed = 1
				to_chat(user, "<span class='notice'>You unscrew the cover from \the [src].</span>")
				return
			else
				to_chat(user, "<span class='danger'>You accidentally activate \the [src]! Run!</span>")
				playsound(loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)
				spawn(10)
					call(src,triggerproc)(user)
					return
		else
			to_chat(user, "<span class='notice'>You carefully screw the cover back onto \the [src].</span>")
			src.exposed = 0
			return
	else if(istype(W, /obj/item/weapon/wirecutters) && src.exposed == 1)
		to_chat(user, "<span class='notice'>You carefully look for the detonation wire...</span>")
		if(do_after(user, 30))
			to_chat(user, "<span class='notice'>You locate the detonation wire and begin isolating it from the rest...</span>")
		else
			to_chat(user, "<span class='danger'>You nick one of the wires! Run!</span>")
			spawn(10)
				call(src,triggerproc)(user)
				return
		if(do_after(user, 30))
			to_chat(user, "<span class='notice'>You isolate the detonation wire and...</span>")
			isolated = 1
		else
			to_chat(user, "<span class='danger'>Your tools brush against the activator! Run!</span>")
			spawn(10)
				call(src,triggerproc)(user)
				return
		if(prob(80) && isolated == 1)
			to_chat(user, "<span class='notice'>Snip!</span>")
			visible_message("<span class='danger'>[user] safely disarms \the [src]!</span>")
			new mineitemtype(get_turf(src))
			spawn(0)
				qdel(src)
				return
		else
			to_chat(user, "<span class='danger'>Snip! ... wait... wrong wire!</span>")
			spawn(10)
				visible_message("<span class='danger'>\The [src] starts beeping rapidly!</span>")
				playsound(loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)
				spawn(30)
					call(src,triggerproc)(user)
					return

/obj/effect/mine/proc/triggerrad(obj)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	triggered = 1
	s.set_up(3, 1, src)
	s.start()
	obj:radiation += 50
	randmutb(obj)
	domutcheck(obj,null)
	spawn(0)
		qdel(src)

/obj/effect/mine/proc/triggerstun(obj)
	triggered = 1
	if(ismob(obj))
		var/mob/M = obj
		M.Stun(30)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	s.set_up(3, 1, src)
	s.start()
	spawn(0)
		qdel(src)

/obj/effect/mine/proc/triggern2o(obj)
	//example: n2o triggerproc
	//note: im lazy //thats okay so am i
	triggered = 1
	for (var/turf/simulated/floor/target in range(1,src))
		if(!target.blocks_air)
			target.assume_gas("sleeping_agent", 30)

	spawn(0)
		qdel(src)

/obj/effect/mine/proc/triggerphoron(obj)
	triggered = 1
	for (var/turf/simulated/floor/target in range(1,src))
		if(!target.blocks_air)
			target.assume_gas("phoron", 30)

			target.hotspot_expose(1000, CELL_VOLUME)

	spawn(0)
		qdel(src)

/obj/effect/mine/proc/triggerkick(obj)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	triggered = 1
	s.set_up(3, 1, src)
	s.start()
	qdel(obj:client)
	spawn(0)
		qdel(src)

/obj/effect/mine/proc/explode(obj)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	triggered = 1
	s.set_up(3, 1, src)
	s.start()
	explosion(loc, 0, 2, 3, 5) //land mines are dangerous, folks.
	spawn(0)
		qdel(src)

/obj/effect/mine/proc/triggerfrag(obj)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	triggered = 1
	s.set_up(3, 1, src)
	s.start()
	..()
	var/turf/O = get_turf(src)
	if(!O)
		return
	src.fragmentate(O, 20, 7, list(/obj/item/projectile/bullet/pellet/fragment)) //only 20 weak fragments because you're stepping directly on it
	qdel(src)


/obj/effect/mine/dnascramble
	name = "radiation mine"
	desc = "Through the rain of Strontium 90..."
	icon_state = "uglymine"
	triggerproc = "triggerrad"
	mineitemtype = /obj/item/weapon/mine/dnascramble

/obj/effect/mine/phoron
	name = "incendiary mine"
	desc = "We didn't start the fire. This mine did."
	icon_state = "uglymine"
	triggerproc = "triggerphoron"
	mineitemtype = /obj/item/weapon/mine/phoron

/obj/effect/mine/kick
	name = "kick mine"
	desc = "Concentrated war crimes. Handle with care."
	icon_state = "uglymine"
	triggerproc = "triggerkick"
	mineitemtype = /obj/item/weapon/mine/kick

/obj/effect/mine/n2o
	name = "nitrous oxide mine"
	desc = "Nitrous oxide is no laughing matter."
	icon_state = "uglymine"
	triggerproc = "triggern2o"
	mineitemtype = /obj/item/weapon/mine/n2o

/obj/effect/mine/stun
	name = "stun mine"
	desc = "Stronger than a Pan-Galactic, but only half as volatile."
	icon_state = "uglymine"
	triggerproc = "triggerstun"
	mineitemtype = /obj/item/weapon/mine/stun

/obj/effect/mine/frag
	name = "fragmentation mine"
	desc = "Ever wanted to become a pincushion?"
	icon_state = "uglymine"
	triggerproc = "triggerfrag"
	mineitemtype = /obj/item/weapon/mine/frag
	var/fragment_types = list(/obj/item/projectile/bullet/pellet/fragment)
	var/num_fragments = 20  //total number of fragments produced by the grenade
	//The radius of the circle used to launch projectiles. Lower values mean less projectiles are used but if set too low gaps may appear in the spread pattern
	var/spread_range = 7

/obj/item/weapon/mine
	name = "mine"
	desc = "Normal procedure is to jump 200 feet in the air and scatter yourself over a wide area."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "uglymine"
	var/arming = 0
	var/countdown = 10
	var/minetype = /obj/effect/mine

/obj/item/weapon/mine/attack_self(mob/user as mob)
	if(!arming)
		to_chat(user, "<span class='warning'>You prime \the [name]! [countdown] seconds!</span>")
		activate(user)
		add_fingerprint(user)
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			C.throw_mode_on()
	else
		to_chat(user, "You cancel \the [name]'s priming sequence.")
		arming = 0
		countdown = initial(countdown)
		icon_state = initial(icon_state)
		add_fingerprint(user)
	return

/obj/item/weapon/mine/proc/activate(mob/user as mob)
	if(arming)
		return
	icon_state = initial(icon_state) + "armed"
	arming = 1
	playsound(loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)

	spawn(countdown*10)
		if(arming)
			prime()
			if(user)
				msg_admin_attack("[user.name] ([user.ckey]) primed \a [src] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")
			return

/obj/item/weapon/mine/proc/prime(mob/user as mob)
	visible_message("\The [src.name] beeps as the priming sequence completes.")
	new minetype(get_turf(src))
	spawn(0)
		qdel(src)

/obj/item/weapon/mine/dnascramble
	name = "radiation mine"
	desc = "Through the rain of Strontium 90..."
	icon_state = "uglymine"
	minetype = /obj/effect/mine/dnascramble

/obj/item/weapon/mine/phoron
	name = "incendiary mine"
	desc = "We didn't start the fire. This mine did."
	icon_state = "uglymine"
	minetype = /obj/effect/mine/phoron

/obj/item/weapon/mine/kick
	name = "kick mine"
	desc = "Concentrated war crimes. Handle with care."
	icon_state = "uglymine"
	minetype = /obj/effect/mine/kick

/obj/item/weapon/mine/n2o
	name = "nitrous oxide mine"
	desc = "Nitrous oxide is no laughing matter."
	icon_state = "uglymine"
	minetype = /obj/effect/mine/n2o

/obj/item/weapon/mine/stun
	name = "stun mine"
	desc = "Stronger than a Pan-Galactic, but only half as volatile."
	icon_state = "uglymine"
	minetype = /obj/effect/mine/stun

/obj/item/weapon/mine/frag
	name = "fragmentation mine"
	desc = "Ever wanted to become a pincushion?"
	icon_state = "uglymine"
	minetype = /obj/effect/mine/frag