/obj/item/weapon/nullrod
	name = "null rod"
	desc = "A rod of pure obsidian, its very presence disrupts and dampens the powers of paranormal phenomenae."
	icon_state = "nullrod"
	item_state = "nullrod"
	slot_flags = SLOT_BELT
	force = 15
	throw_speed = 1
	throw_range = 4
	throwforce = 10
	w_class = ITEMSIZE_SMALL
	drop_sound = 'sound/items/drop/sword.ogg'
	pickup_sound = 'sound/items/pickup/sword.ogg'
	var/cooldown = 0 // floor tap cooldown

	suicide_act(mob/user)
		var/datum/gender/T = gender_datums[user.get_visible_gender()]
		to_chat(viewers(user),"<span class='danger'>[user] is impaling [T.himself] with the [src.name]! It looks like [T.he] [T.is] trying to commit suicide.</span>")
		return (BRUTELOSS|FIRELOSS)

/obj/item/weapon/nullrod/staff
	name = "null staff"
	desc = "A staff of pure obsidian, its very presence disrupts and dampens the powers of paranormal phenomenae."
	icon_state = "nullstaff"
	item_state = "nullstaff"
	slot_flags = SLOT_BELT | SLOT_BACK
	w_class = ITEMSIZE_LARGE

/obj/item/weapon/nullrod/orb
	name = "null sphere"
	desc = "An orb of pure obsidian, its very presence disrupts and dampens the powers of paranormal phenomenae."
	icon_state = "nullorb"
	item_state = "nullorb"

/obj/item/weapon/nullrod/athame
	name = "null athame"
	desc = "An athame of pure obsidian, its very presence disrupts and dampens the powers of paranormal phenomenae."
	icon_state = "nullathame"
	item_state = "nullathame"

/obj/item/weapon/nullrod/verb/change(mob/user)
	set name = "Reconfigure Null Item"
	set category = "Object"
	set src in usr

	var/list/options = list()
	options["Null rod"] = list(/obj/item/weapon/nullrod)
	options["Null staff"] = list(/obj/item/weapon/nullrod/staff)
	options["Null sphere"] = list(/obj/item/weapon/nullrod/orb)
	options["Null athame"] = list(/obj/item/weapon/nullrod/athame)
	var/choice = input(user,"What form would you like your obsidian relic to take?") as null|anything in options
	if(src && choice)
		to_chat(user, SPAN_NOTICE("You start reconfiguring your obsidian relic."))
		if(!do_after(user, 2 SECONDS))
			return
		var/list/things_to_spawn = options[choice]
		for(var/new_type in things_to_spawn) // Spawn the null item
			var/atom/movable/AM = new new_type(get_turf(src))
			if(istype(AM, /obj/item/weapon/nullrod))
				to_chat(user, "You have reconfigured your obsidian relic to \the [AM].")
		qdel(src)


/obj/item/weapon/nullrod/attack(mob/M as mob, mob/living/user as mob) //Paste from old-code to decult with a null rod.

	add_attack_logs(user,M,"Hit with [src] (nullrod)")

	user.setClickCooldown(user.get_attack_speed(src))
	user.do_attack_animation(M)

	if (!(istype(user, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
		to_chat(user, "<span class='danger'>You don't have the dexterity to do this!</span>")
		return

	if ((CLUMSY in user.mutations) && prob(50))
		to_chat(user, "<span class='danger'>The rod slips out of your hand and hits your head.</span>")
		user.take_organ_damage(10)
		user.Paralyse(20)
		return

	if (M.stat !=2)
		if(cult && (M.mind in cult.current_antagonists) && prob(33))
			to_chat(M, "<span class='danger'>The power of [src] clears your mind of the cult's influence!</span>")
			to_chat(user, "<span class='danger'>You wave [src] over [M]'s head and see their eyes become clear, their mind returning to normal.</span>")
			cult.remove_antagonist(M.mind)
			M.visible_message("<span class='danger'>\The [user] waves \the [src] over \the [M]'s head.</span>")
		else if(prob(10))
			to_chat(user, "<span class='danger'>The rod slips in your hand.</span>")
			..()
		else
			to_chat(user, "<span class='danger'>The rod appears to do nothing.</span>")
			M.visible_message("<span class='danger'>\The [user] waves \the [src] over \the [M]'s head.</span>")
			return

/obj/item/weapon/nullrod/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity)
		return
	if(istype(A, /turf/simulated/floor) && (cooldown + 5 SECONDS < world.time))
		cooldown = world.time
		user.visible_message(SPAN_NOTICE("[user] loudly taps their [src.name] against the floor."))
		playsound(user.loc, 'sound/effects/shieldbash.ogg', 50, 1)
		var/rune_found = FALSE
		for(var/obj/effect/rune/R in orange(2, get_turf(src)))
			if(R == src)
				continue
			rune_found = TRUE
			R.invisibility = 0
		if(rune_found)
			visible_message(SPAN_NOTICE("A holy glow permeates the air!"))
		return