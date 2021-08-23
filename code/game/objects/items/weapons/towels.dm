/obj/item/weapon/towel
	name = "towel"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "towel"
	slot_flags = SLOT_HEAD | SLOT_BELT | SLOT_OCLOTHING
	force = 3.0
	w_class = ITEMSIZE_NORMAL
	attack_verb = list("whipped")
	hitsound = 'sound/weapons/towelwhip.ogg'
	desc = "A soft cotton towel."
	drop_sound = 'sound/items/drop/cloth.ogg'
	pickup_sound = 'sound/items/pickup/cloth.ogg'

/obj/item/weapon/towel/equipped(var/M, var/slot)
	..()
	switch(slot)
		if(slot_head)
			sprite_sheets = list(SPECIES_TESHARI = 'icons/mob/species/teshari/head.dmi')
		if(slot_wear_suit)
			sprite_sheets = list(SPECIES_TESHARI = 'icons/mob/species/teshari/suit.dmi')
		if(slot_belt)
			sprite_sheets = list(SPECIES_TESHARI = 'icons/mob/species/teshari/belt.dmi')

/obj/item/weapon/towel/attack_self(mob/living/user as mob)
		attack(user,user)

/obj/item/weapon/towel/attack(mob/living/carbon/human/M as mob, mob/living/carbon/user as mob)
	if(istype(M) && user.a_intent == I_HELP)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if(user.on_fire)
			user.visible_message("<span class='warning'>\The [user] uses \the [src] to pat out \the [M]'s flames with \the [src]!</span>")
			playsound(M, 'sound/weapons/towelwhip.ogg', 25, 1)
			M.ExtinguishMob(-1)
		else
			user.visible_message("<span class='notice'>\The [user] starts drying \the [M] off with \the [src]...</span>")
			if(do_mob(user, M, 3 SECONDS))
				user.visible_message("<span class='notice'>\The [user] dries \the [M] off with \the [src].</span>")
				playsound(M, 'sound/weapons/towelwipe.ogg', 25, 1)
				M.adjust_fire_stacks(-clamp(M.fire_stacks,-1.5,1.5))
		return

	. = ..()

/obj/item/weapon/towel/random/New()
	..()
	color = "#"+get_random_colour()