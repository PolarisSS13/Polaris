/obj/item/arrow/wood
	name = "wooden arrow"
	desc = "A wooden arrow with a stone tip. Simple, but gets the job done."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "arrow"
	item_state = "bolt"
	throwforce = 7
	w_class = ITEMSIZE_NORMAL
	sharp = 1
	edge = 0
	drop_sound = 'sound/items/drop/woodweapon.ogg'
	pickup_sound = 'sound/items/pickup/woodweapon.ogg'


/obj/item/arrow/energy
	name = "hardlight arrow"
	desc = "An arrow made out of energy! Classic?"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "hardlight"
	item_state = "bolt"
	throwforce = 6
	w_class = ITEMSIZE_NORMAL
	sharp = 1
	edge = 1
	embed_chance = 0
	catchable = FALSE // no catching energy

/obj/item/arrow/energy/throw_impact(atom/hit_atom)
	. = ..()
	qdel(src)

/obj/item/arrow/energy/equipped()
	if(isliving(loc))
		var/mob/living/L = loc
		L.drop_from_inventory(src)
	qdel(src)

/obj/item/gun/launcher/crossbow/bow
	name = "shortbow"
	desc = "A common shortbow, capable of firing arrows at high speed towards a target. Useful for hunting while keeping quiet."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "bow"
	item_state = "bow"
	fire_sound = 'sound/weapons/punchmiss.ogg' // TODO: Decent THWOK noise.
	fire_sound_text = "a light swoosh of air"
	fire_delay = 25
	slot_flags = SLOT_BACK
	release_speed = 15
	release_force = 20
	tension = 3
	var/drawn = FALSE
	drop_sound = 'sound/items/drop/woodweapon.ogg'
	pickup_sound = 'sound/items/pickup/woodweapon.ogg'


/obj/item/gun/launcher/crossbow/bow/update_release_force(obj/item/projectile)
	return 0

/obj/item/gun/launcher/crossbow/bow/proc/unload(mob/user)
	var/obj/item/arrow/A = bolt
	bolt = null
	drawn = FALSE
	A.forceMove(get_turf(user))
	user.put_in_hands(A)
	update_icon()

/obj/item/gun/launcher/crossbow/bow/consume_next_projectile(mob/user)
	if(!drawn)
		to_chat(user, "<span class='warning'>\The [src] is not drawn back!</span>")
		return null
	return bolt

/obj/item/gun/launcher/crossbow/bow/handle_post_fire(mob/user, atom/target)
	bolt = null
	drawn = FALSE
	update_icon()
	..()

/obj/item/gun/launcher/crossbow/bow/attack_hand(mob/living/user)
	if(loc == user && bolt && !drawn)
		user.visible_message("<b>[user]</b> removes [bolt] from [src].","You remove [bolt] from [src].")
		unload(user)
	else
		return ..()

/obj/item/gun/launcher/crossbow/bow/attack_self(mob/living/user)
	if(drawn)
		user.visible_message("<b>[user]</b> relaxes the tension on [src]'s string.","You relax the tension on [src]'s string.")
		drawn = FALSE
		update_icon()
	else
		draw(user)

/obj/item/gun/launcher/crossbow/bow/draw(var/mob/user)
	if(!bolt)
		to_chat(user, "You don't have anything nocked to [src].")
		return

	if(user.restrained())
		return

	current_user = user
	user.visible_message("<b>[user]</b> begins to draw back the string of [src].","<span class='notice'>You begin to draw back the string of [src].</span>")
	if(do_after(user, 25))
		drawn = TRUE
		user.visible_message("<b>[user]</b> draws the string on [src] back fully!", "You draw the string on [src] back fully!")
	update_icon()

/obj/item/gun/launcher/crossbow/bow/handle_click_empty(mob/user)
		return

/obj/item/gun/launcher/crossbow/bow/attackby(obj/item/W as obj, mob/user)
	if(!bolt && istype(W,/obj/item/arrow/wood))
		user.drop_from_inventory(W, src)
		bolt = W
		user.visible_message("[user] nocks [bolt] in [src].","You nock [bolt] in [src].")
		update_icon()

/obj/item/gun/launcher/crossbow/bow/update_icon()
	if(drawn)
		icon_state = "[initial(icon_state)]_firing"
	else if(bolt)
		icon_state = "[initial(icon_state)]_loaded"
	else
		icon_state = "[initial(icon_state)]"

/obj/item/gun/launcher/crossbow/bow/dropped(mob/user)
	if(drawn)
		to_chat(user, "<span class='warning'>\The [src]'s tension is relaxed as you let go of it!</span>")
		drawn = FALSE
	update_icon()


/obj/item/gun/launcher/crossbow/bow/hardlight
	name = "hardlight bow"
	icon_state = "bow_hardlight"
	item_state = "bow_hardlight"
	desc = "A modern twist on an ancient weapon, generating arrows from energy!"
	drop_sound = 'sound/items/drop/gun.ogg'
	pickup_sound = 'sound/items/pickup/gun.ogg'

/obj/item/gun/launcher/crossbow/bow/hardlight/unload(mob/user)
	qdel_null(bolt)
	update_icon()

/obj/item/gun/launcher/crossbow/bow/hardlight/attack_self(mob/living/user)
	if(drawn)
		user.visible_message("<b>[user]</b> relaxes the tension on [src]'s string.","You relax the tension on [src]'s string.")
		drawn = FALSE
		update_icon()
	else if(!bolt)
		user.visible_message("<b>[user]</b> fabricates a new hardlight projectile with [src].","You fabricate a new hardlight projectile with [src].")
		bolt = new /obj/item/arrow/energy(src)
		update_icon()
	else
		draw(user)