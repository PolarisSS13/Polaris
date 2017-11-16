/obj/item/clothing/suit/armor/beltshield
	name = "shield-emitting belt"
	desc = "A belt that can deploy a directional shield."
	icon = 'icons/obj/clothing/belts.dmi'
	icon_state = "shield-belt-0"
	item_state = "shield-belt-0"
	w_class = ITEMSIZE_NORMAL
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_MAGNET = 5, TECH_POWER = 4)
	slowdown = 0
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	action_button_name = "Toggle Belt Shield"
	var/active = 0
	var/datum/effect/effect/system/spark_spread/spark_system = null
	var/block_percentage = 75

/obj/item/clothing/suit/armor/beltshield/New()
	..()
	spark_system = new /datum/effect/effect/system/spark_spread()
	spark_system.set_up(5, 0, src)

/obj/item/clothing/suit/armor/beltshield/Destroy()
	qdel(spark_system)
	return ..()

/obj/item/clothing/suit/armor/beltshield/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	//Since this is a piece of armor that is passive, we do not need to check if the user is incapacitated.
	if(!active)
		return 0

	var/modified_block_percentage = block_percentage

	if(issmall(user)) // Smaller shield means better protection.
		modified_block_percentage += 15


	var/damage_blocked = damage * (modified_block_percentage / 100)

	damage = damage - damage_blocked

	if(istype(damage_source, /obj/item/projectile))
		var/obj/item/projectile/P = damage_source
		P.sharp = 0
		P.edge = 0
		P.embed_chance = 0
		if(P.agony)
			var/agony_blocked = P.agony * (modified_block_percentage / 100)
			P.agony -= agony_blocked
		P.damage = P.damage - damage_blocked

	user.visible_message("<span class='danger'>\The [user]'s [src] absorbs [attack_text]!</span>")
	to_chat(user, "<span class='warning'>Your shield has absorbed most of \the [damage_source].</span>")

	spark_system.start()
	playsound(user.loc, 'sound/weapons/blade1.ogg', 50, 1)
	return 0 // This shield does not block all damage, so returning 0 is needed to tell the game to apply the new damage.

/obj/item/clothing/suit/armor/beltshield/attack_self(mob/user)
	active = !active
	to_chat(user, "<span class='notice'>You [active ? "" : "de"]activate \the [src].</span>")
	user.update_action_buttons()
	update_icon()

/obj/item/clothing/suit/armor/beltshield/update_icon()
	icon_state = "shield-belt-[active]"
	item_state = "shield-belt-[active]"
	if(active)
		set_light(2, 1, l_color = "#006AFF")
	else
		set_light(0, 0, l_color = "#000000")
	..()
	return