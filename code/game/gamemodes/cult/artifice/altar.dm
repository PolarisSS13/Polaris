
/obj/structure/cult/altar
	name = "altar"
	desc = "An alchemical altar used for research into the arcane arts."
	icon_state = "altar"

	var/obj/item/device/crystalball/spellfocus = null

	var/obj/item/weapon/book/tome/tome = null

	var/image/orb
	var/orb_state = "crystalball"
	var/image/book
	var/tome_state = "tome"

	var/spell_tab = CULT_ALL_SPELLS

/obj/structure/cult/altar/Destroy()
	var/turf/T = get_turf(src)
	if(T)
		if(spellfocus)
			spellfocus.forceMove(T)
			spellfocus = null
		if(tome)
			tome.forceMove(T)
			tome = null

	else
		if(spellfocus)
			qdel(spellfocus)
			spellfocus = null
		if(tome)
			qdel(tome)
			tome = null

	..()

/obj/structure/cult/altar/AltClick(mob/living/user)
	if(tome)
		tome.forceMove(get_turf(src))

	if(spellfocus)
		spellfocus.forceMove(get_turf(src))

	tome = null
	spellfocus = null

	return ..()

/obj/structure/cult/altar/update_icon()
	..()
	cut_overlays()

	if(!orb)
		orb = image(icon=src.icon,icon_state=orb_state)

	if(!book)
		book = image(icon=src.icon,icon_state=tome_state)

	if(tome)
		book.icon_state = tome.icon_state

		if(tome.color)
			book.color = tome.color
		else
			book.color = null

		add_overlay(book)

	if(spellfocus)
		orb.icon_state = spellfocus.icon_state

		if(spellfocus.color)
			orb.color = spellfocus.color
		else
			orb.color = null

		add_overlay(orb)

/obj/structure/cult/altar/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/material/kitchen/utensil/fork/tuning))
		if(do_after(user, 3 SECONDS, src))
			playsound(get_turf(src),W.usesound, 50, 1)
			anchored = !anchored
			update_icon()
			return

	if(!spellfocus && istype(W, /obj/item/device/crystalball))
		user.drop_from_inventory(W)

		spellfocus = W

		spellfocus.forceMove(src)
		update_icon()
		return

	if(!tome && istype(W, /obj/item/weapon/book/tome))
		user.drop_from_inventory(W)

		tome = W

		tome.forceMove(src)
		update_icon()
		return

	return ..()

/obj/structure/cult/altar/proc/show_categories(var/category)
	if(category)
		if(spell_tab != category)
			return "<a href='byond://?src=\ref[src];spell_category=[category]'>[category]</a>"
		else
			return "<b>[category]</b>"

/obj/structure/cult/altar/attack_hand(var/mob/living/user)
	if(!user)
		return 0

	if(!iscultist(user))
		to_chat(user, "<span class='danger'>\The [src] does not respond to your touch.</span>")
		return 0

	if(!spellfocus)
		to_chat(user, "<span class='danger'>\The [src] lacks a spell focus..</span>")
		return 0

	var/datum/bloodnet/BN = spellfocus.getBloodnet()

	if(!BN)
		BN = user.getBloodnet()

	var/dat = ""
	user.set_machine(src)
	dat += "[show_categories(CULT_ALL_SPELLS)] | [show_categories(CULT_OFFENSIVE_SPELLS)] | [show_categories(CULT_DEFENSIVE_SPELLS)] | \
	[show_categories(CULT_UTILITY_SPELLS)] | [show_categories(CULT_SUPPORT_SPELLS)]<br>"
	for(var/datum/cultist/spell/spell in GLOB.cultspell_list)
		if(spell.hidden)
			continue

		if(spell_tab != CULT_ALL_SPELLS && spell.category != spell_tab)
			continue

		dat += "<b>[spell.name]</b><br>"
		dat += "<i>[spell.desc]</i><br>"
		if(spell.needs_tome && !tome)
			dat += "<span class='cult'>Your altar lacks the appropriate literature to channel this enchantment.</span>"
		else
			if(!BN || spell.cost <= BN.current_volume)
				dat += "<a href='byond://?src=\ref[src];spell_choice=[spell.name]'>Enchant</a> ([spell.cost])<br><br>"
			else
				dat += "<font color='red'><b>Cannot afford!</b></font><br><br>"

	user << browse(dat, "window=radio")
	onclose(user, "radio")

/obj/structure/cult/altar/Topic(href, href_list)
	..()
	var/mob/living/L = usr

	if(L.stat || L.restrained())
		return

	if(!anchored || !spellfocus)
		to_chat(L, "\The [src] won't allow you to do that, as it is improperly prepared!")
		return

	if(in_range(src, L) && istype(loc, /turf))
		L.set_machine(src)
		if(href_list["spell_category"])
			spell_tab = href_list["spell_category"]
		if(href_list["spell_choice"])
			var/datum/cultist/spell/new_spell = null
			//Locate the spell.
			for(var/datum/cultist/spell/spell in GLOB.cultspell_list)
				if(spell.name == href_list["spell_choice"])
					new_spell = spell
					break

			if(new_spell && spellfocus)
				if(spellfocus.getBloodnet())
					var/datum/bloodnet/BN = spellfocus.getBloodnet()
					if(!BN)
						BN = L.getBloodnet()

					if(!BN)
						to_chat(L, "<span class='danger'>\The [spellfocus] fails to channel your connection to the otherworld.</span>")
						return

					if(new_spell.cost <= BN.current_volume)
						if(!spellfocus.has_spell(new_spell))
							BN.adjustBlood(-1 * new_spell.cost)
							to_chat(L, "<span class='notice'>You have just bought [new_spell.name].</span>")
							spellfocus.add_spell(new_spell.obj_path, new_spell.name, new_spell.ability_icon_state)
						else //We already own it.
							to_chat(L, "<span class='danger'>You already have [new_spell.name]!</span>")
							return
					else //Can't afford.
						to_chat(L, "<span class='danger'>You can't afford that!</span>")
						return

		attack_hand(L)

	return
