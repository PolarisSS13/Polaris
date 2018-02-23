/obj/item/weapon/melee/chainofcommand
	name = "chain of command"
	desc = "A tool used by great men to placate the frothing masses."
	icon_state = "chain"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 10
	throwforce = 7
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_COMBAT = 4)
	attack_verb = list("flogged", "whipped", "lashed", "disciplined")

	suicide_act(mob/user)
		var/datum/gender/T = gender_datums[user.get_visible_gender()]
		user.visible_message(span("danger", "\The [user] [T.is] strangling [T.himself] with \the [src]! It looks like [T.he] [T.is] trying to commit suicide."), span("danger", "You start to strangle yourself with \the [src]!"), span("danger", "You hear the sound of someone choking!"))
		return (OXYLOSS)

/obj/item/weapon/melee/umbrella
	name = "umbrella"
	desc = "To keep the rain off you. Use with caution on windy days."
	icon = 'icons/obj/items.dmi'
	icon_state = "umbrella_closed"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 5
	throwforce = 5
	w_class = ITEMSIZE_NORMAL
	var/open = FALSE

/obj/item/weapon/melee/umbrella/New()
	..()
	color = "#"+get_random_colour()
	update_icon()

/obj/item/weapon/melee/umbrella/attack_self()
	src.toggle_umbrella()

/obj/item/weapon/melee/umbrella/proc/toggle_umbrella()
	open = !open
	icon_state = "umbrella_[open ? "open" : "closed"]"
	item_state = icon_state
	update_icon()
	if(ishuman(src.loc))
		var/mob/living/carbon/human/H = src.loc
		H.update_inv_l_hand(0)
		H.update_inv_r_hand()
	..()

/obj/item/weapon/melee/cursedblade
	name = "crystal blade"
	desc = "The red crystal blade's polished surface glints in the light, giving off a faint glow."
	icon_state = "soulblade"
	slot_flags = SLOT_BELT | SLOT_BACK
	force = 30
	throwforce = 10
	w_class = ITEMSIZE_NORMAL
	sharp = 1
	edge = 1
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	can_speak = 1
	var/mob/living/carbon/brain/brainmob = null //The curse of the sword is that it has someone trapped inside.


/obj/item/weapon/melee/cursedblade/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(default_parry_check(user, attacker, damage_source) && prob(50))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		playsound(user.loc, 'sound/weapons/punchmiss.ogg', 50, 1)
		return 1
	return 0

/obj/item/weapon/melee/cursedblade/New()
	src.brainmob = new(src)
	src.brainmob.add_language(LANGUAGE_GALCOM)
	src.brainmob.loc = src
	src.brainmob.container = src
	src.brainmob.stat = 0
	src.brainmob.silent = 0
	src.brainmob.name = "cursed sword"
	src.brainmob.real_name = "cursed sword"
	dead_mob_list -= src.brainmob

/obj/item/weapon/melee/cursedblade/examine(mob/user)
	if(!..(user))
		return

	var/msg = "<span class='info'>*---------*</span>\nThis is \icon[src] \a <EM>[src]</EM>!\n[desc]\n"
	msg += "<span class='warning'>"

	if(src.brainmob && src.brainmob.key)
		switch(src.brainmob.stat)
			if(CONSCIOUS)
				if(!src.brainmob.client)	msg += "The blade's bright glint seems dull.\n" //afk
			if(UNCONSCIOUS)		msg += "<span class='warning'>The blade seems oddly lifeless.</span>\n"
			if(DEAD)			msg += "<span class='deadsay'>The blade seems completely lifeless.</span>\n"
	else
		msg += "<span class='deadsay'>The blade seems completely lifeless, its bright glow now dull.</span>\n"
	msg += "</span><span class='info'>*---------*</span>"
	to_chat(usr,msg)
	return