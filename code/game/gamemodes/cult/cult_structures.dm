/obj/structure/cult
	density = 1
	anchored = 1
	icon = 'icons/obj/cult.dmi'

/obj/structure/cult/cultify()
	return

/obj/structure/cult/talisman
	name = "Altar"
	desc = "A bloodstained altar dedicated to Nar-Sie."
	icon_state = "talismanaltar"

/obj/structure/cult/pylon
	name = "Pylon"
	desc = "A floating crystal that hums with an unearthly energy."
	icon_state = "blank"
	var/isbroken = 0
	light_range = 5
	light_color = "#3e0000"
//	var/obj/item/wepon = null

	var/shatter_message = "The pylon shatters!"
	var/impact_sound = 'sound/effects/Glasshit.ogg'
	var/shatter_sound = 'sound/effects/Glassbr3.ogg'

	var/activation_cooldown = 30 SECONDS
	var/last_activation = 0

	// Safely accepts alpha layers.
	var/primary_color = "#ff0000aa"
	var/secondary_color = "#ff0000aa"
	var/base_color = "#1a1a1a"

	var/image/crystal
	var/crystal_state = "crystal"
	var/image/base
	var/base_state = "base"
	var/image/surge
	var/surge_state = "surge"

	// Are we currently animating a power surge?
	var/surging = FALSE

/obj/structure/cult/pylon/update_icon()
	cut_overlays()

	if(!crystal)
		crystal = image(icon=src.icon,icon_state=crystal_state)

	if(!base)
		base = image(icon=src.icon,icon_state=base_state)

	if(!surge)
		surge = image(icon=src.icon,icon_state=surge_state)

	crystal.icon_state = crystal_state

	if(primary_color)
		crystal.color = primary_color

	base.icon_state = base_state

	if(base_color)
		base.color = base_color

	surge.icon_state = surge_state

	if(secondary_color)
		surge.color = secondary_color

	add_overlay(base)

	if(!isbroken)
		add_overlay(crystal)

/obj/structure/cult/pylon/proc/surge()
	if(!surging)
		update_icon()
		add_overlay(surge)
		surging = TRUE

		spawn(max(0.5 SECONDS,round(activation_cooldown / 10)))
			surging = FALSE
			cut_overlay(surge)

/obj/structure/cult/pylon/Initialize()
	..()
	START_PROCESSING(SSobj, src)
	update_icon()

/obj/structure/cult/pylon/attack_hand(mob/M as mob)
	attackpylon(M, 5)

/obj/structure/cult/pylon/attack_generic(var/mob/user, var/damage)
	attackpylon(user, damage)

/obj/structure/cult/pylon/attackby(obj/item/W as obj, mob/user as mob)
	attackpylon(user, W.force, W)

/obj/structure/cult/pylon/take_damage(var/damage)
	pylonhit(damage)

/obj/structure/cult/pylon/bullet_act(var/obj/item/projectile/Proj)
	pylonhit(Proj.get_structure_damage())

/obj/structure/cult/pylon/proc/pylonhit(var/damage)
	if(!isbroken)
		if(perform_damaged(damage) && prob(1+ damage * 5))
			visible_message("<span class='danger'>[shatter_message]</span>")
			STOP_PROCESSING(SSobj, src)
			playsound(src,shatter_sound, 75, 1)
			isbroken = 1
			density = 0
			update_icon()
			set_light(0)

/obj/structure/cult/pylon/proc/attackpylon(mob/user as mob, var/damage, var/obj/item/I)
	if(!isbroken)
		if(perform_attacked(user, damage, I) && prob(1+ damage * 5))
			user.visible_message(
				"<span class='danger'>[user] smashed \the [src]!</span>",
				"<span class='warning'>You hit \the [src], and its crystal breaks apart!</span>",
				"You hear a tinkle of crystal shards."
				)
			STOP_PROCESSING(SSobj, src)
			user.do_attack_animation(src)
			playsound(src,shatter_sound, 75, 1)
			isbroken = 1
			density = 0
			update_icon()
			set_light(0)
		else
			to_chat(user, "You hit \the [src]!")
			playsound(src,impact_sound, 75, 1)
	else
		if(prob(damage * 2))
			to_chat(user, "You pulverize what was left of \the [src]!")
			qdel(src)
		else
			to_chat(user, "You hit \the [src]!")
		playsound(src,impact_sound, 75, 1)

/obj/structure/cult/pylon/proc/repair(mob/user as mob)
	if(isbroken)
		START_PROCESSING(SSobj, src)
		to_chat(user, "You repair \the [src].")
		isbroken = 0
		density = 1
		update_icon()
		set_light(5)

/obj/structure/cult/pylon/proc/perform_attacked(mob/user, var/damage)	// Return true if the damage continues on.
	return TRUE

/obj/structure/cult/pylon/proc/perform_damaged(var/damage)	// Return true if the damage continues on.
	return TRUE

// Returns 1 if the pylon does something special.
/obj/structure/cult/pylon/proc/pylon_unique()
	return FALSE

/obj/structure/cult/pylon/process()
	if(!isbroken && (last_activation < world.time + activation_cooldown) && pylon_unique())
		last_activation = world.time
		surge()

/obj/structure/cult/tome
	name = "Desk"
	desc = "A desk covered in arcane manuscripts and tomes in unknown languages. Looking at the text makes your skin crawl."
	icon_state = "tomealtar"

//sprites for this no longer exist	-Pete
//(they were stolen from another game anyway)
/*
/obj/structure/cult/pillar
	name = "Pillar"
	desc = "This should not exist"
	icon_state = "pillar"
	icon = 'magic_pillar.dmi'
*/

/obj/effect/gateway
	name = "gateway"
	desc = "You're pretty sure that abyss is staring back."
	icon = 'icons/obj/cult.dmi'
	icon_state = "hole"
	density = 1
	unacidable = 1
	anchored = 1.0
	var/spawnable = null

/obj/effect/gateway/active
	light_range=5
	light_color="#ff0000"
	spawnable=list(
		/mob/living/simple_mob/animal/space/bats,
		/mob/living/simple_mob/creature,
		/mob/living/simple_mob/faithless
	)

/obj/effect/gateway/active/cult
	light_range=5
	light_color="#ff0000"
	spawnable=list(
		/mob/living/simple_mob/animal/space/bats/cult,
		/mob/living/simple_mob/creature/cult,
		/mob/living/simple_mob/faithless/cult
	)

/obj/effect/gateway/active/cult/cultify()
	return

/obj/effect/gateway/active/Initialize()
	addtimer(CALLBACK(src, .proc/spawn_and_qdel), rand(30, 60) SECONDS)

/obj/effect/gateway/active/proc/spawn_and_qdel()
	if(LAZYLEN(spawnable))
		var/t = pick(spawnable)
		new t(get_turf(src))
	qdel(src)

/obj/effect/gateway/active/Crossed(var/atom/A)
	if(A.is_incorporeal())
		return
	if(!istype(A, /mob/living))
		return

	var/mob/living/M = A

	to_chat(M, "<span class='danger'>Walking into \the [src] is probably a bad idea, you think.</span>")
