/*
	Bat procs
*/
/obj/item/weapon/material/twohanded/baseballbat/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(user.incapacitated())
		return 0
	if(istype(damage_source, /obj/item/projectile)) //Bats can't block bullets.
		return 0

	//block as long as they are not directly behind us
	var/bad_arc = reverse_direction(user.dir) //arc of directions from which we cannot block
	if(check_shield_arc(user, bad_arc, damage_source, attacker))
		if(prob(get_block_chance(user, damage, damage_source, attacker)))
			if(istype(damage_source, /obj/item/weapon))
				user.visible_message("<span class='danger'>\The [user] hits [attack_text] with \the [src]!</span>")
				return PROJECTILE_REFLECT
	return 0

/obj/item/weapon/material/twohanded/baseballbat/proc/get_block_chance(mob/user, var/damage, atom/damage_source = null, mob/attacker = null)
	return base_block_chance


/*
	Reflection in a semi-randomised cone from the hit source.
*/
/atom/movable/proc/reflected(atom/a)
	var/target_x = src.x
	var/target_y = src.y

	if(a.dir == NORTH || a.dir == SOUTH)
		target_x += 10 - rand(rand(1, 5), rand(15, 20))
		target_y += (a.dir == SOUTH ? -1 : 1) * rand(rand(1, 5), rand(10, 15))
	else if(a.dir == EAST || a.dir == WEST)
		target_x += (a.dir == WEST ? -1 : 1) * rand(rand(1, 5), rand(10, 15))
		target_y += 10 - rand(rand(1, 5), rand(15, 20))

	var/turf/target = locate(target_x, target_y, src.z)
	var/target_range = get_dist(src.loc, target)
	var/target_speed = rand(1, target_range)

	throw_at(target, target_range, target_speed)

/*
	Baseball
*/
/obj/item/weapon/baseball
	name = "baseball"
	desc = "A ball."
	icon = 'icons/obj/sports.dmi'
	icon_state = "baseball"
	w_class = ITEMSIZE_SMALL
	throw_speed = 2
	throw_range = 20

/obj/item/weapon/ball/baseball/afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
		user.drop_item()
		src.throw_at(target, throw_range, throw_speed, user)

/*
	Baseball glove
*/
/obj/item/weapon/baseball_glove
	name = "baseball glove"
	desc = "A baseball glove."
	icon = 'icons/obj/sports.dmi'
	icon_state = "baseball_glove"

/obj/item/weapon/baseball_glove/attack_self(mob/user as mob)
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.in_throw_mode)
			C.throw_mode_off()
		else
			C.throw_mode_on()

/obj/item/weapon/baseball_glove/proc/glove_catch(mob/user as mob, var/obj/O)
	if(!user.get_inactive_hand())
		if(user.put_in_inactive_hand(O))
			visible_message("<span class='warning'>[user] catches [O]!</span>")
		else
			visible_message("<span class='warning'>[user] almost catches [O] but dropped it!</span>")

/*
	Baseball helmet
*/
/obj/item/clothing/head/baseball_helmet
	name = "baseball helmet"
	desc = "Baseball helmet."
	icon_state = "baseball_helm"
	armor = list(melee = 15, bullet = 1, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)