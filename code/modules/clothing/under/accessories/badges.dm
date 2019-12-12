/*
	Badges are worn on the belt or neck, and can be used to show that the holder is an authorized
	Security agent - the user details can be imprinted on holobadges with a Security-access ID card,
	or they can be emagged to accept any ID for use in disguises.
*/

/obj/item/clothing/accessory/badge
	name = "detective's badge"
	desc = "Police detective's badge, made from gold."
	icon_state = "badge"
	slot_flags = SLOT_BELT | SLOT_TIE

	var/stored_name
	var/badge_string = "Geminus City Police Department"
	var/name_reset = ""
	var/news_network_name

/obj/item/clothing/accessory/badge/old
	name = "faded badge"
	desc = "A faded badge, backed with leather. It bears the emblem of the Forensic division."
	icon_state = "badge_round"

/obj/item/clothing/accessory/badge/proc/set_name(var/new_name)
	stored_name = new_name
	name = "[initial(name)] ([stored_name])"

/obj/item/clothing/accessory/badge/attack_self(mob/user as mob)

	if(!stored_name)
		user << "You polish your old badge fondly, shining up the surface."
		set_name(user.real_name)
		return

	if(isliving(user))
		if(stored_name)
			user.visible_message("<span class='notice'>[user] displays their [src.name].\nIt reads: [stored_name], [badge_string].</span>","<span class='notice'>You display your [src.name].\nIt reads: [stored_name], [badge_string].</span>")
		else
			user.visible_message("<span class='notice'>[user] displays their [src.name].\nIt reads: [badge_string].</span>","<span class='notice'>You display your [src.name]. It reads: [badge_string].</span>")

/obj/item/clothing/accessory/badge/attack(mob/living/carbon/human/M, mob/living/user)
	if(isliving(user))
		user.visible_message("<span class='danger'>[user] invades [M]'s personal space, thrusting [src] into their face insistently.</span>","<span class='danger'>You invade [M]'s personal space, thrusting [src] into their face insistently.</span>")
		user.do_attack_animation(M)
		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN) //to prevent spam

// Sheriff Badge (toy)
/obj/item/clothing/accessory/badge/sheriff
	name = "sheriff badge"
	desc = "This town ain't big enough for the two of us, pardner."
	icon_state = "sheriff"
	item_state = "goldbadge"

/obj/item/clothing/accessory/badge/sheriff/attack_self(mob/user as mob)
	user.visible_message("[user] shows their sheriff badge. There's a new sheriff in town!",\
		"You flash the sheriff badge to everyone around you!")

/obj/item/clothing/accessory/badge/sheriff/attack(mob/living/carbon/human/M, mob/living/user)
	if(isliving(user))
		user.visible_message("<span class='danger'>[user] invades [M]'s personal space, the sheriff badge into their face!.</span>","<span class='danger'>You invade [M]'s personal space, thrusting the sheriff badge into their face insistently.</span>")
		user.do_attack_animation(M)
		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN) //to prevent spam

//.Holobadges.
/obj/item/clothing/accessory/badge/holo
	name = "holobadge"
	desc = "This glowing blue badge marks the holder as THE LAW."
	icon_state = "holobadge"
	var/emagged //Emagging removes Sec check.

/obj/item/clothing/accessory/badge/holo/verb/Reset()
	if(access_security in usr.GetIdCard().access || emagged)
		if(!stored_name)
			usr << "There is no information stored on the badge."
		else
			usr << "You reset the holobadge."
			stored_name = FALSE
			name = name_reset
	else
		usr << "[name] rejects your insufficient access rights."
	return

/obj/item/clothing/accessory/badge/holo/cord
	icon_state = "holobadge-cord"
	slot_flags = SLOT_MASK | SLOT_TIE | SLOT_BELT

/obj/item/clothing/accessory/badge/holo/attack_self(mob/user as mob)
	if(!stored_name)
		user << "Waving around a holobadge before swiping an ID would be pretty pointless."
		return
	return ..()

/obj/item/clothing/accessory/badge/holo/emag_act(var/remaining_charges, var/mob/user)
	if (emagged)
		user << "<span class='danger'>\The [src] is already cracked.</span>"
		return
	else
		emagged = 1
		user << "<span class='danger'>You crack the holobadge security checks.</span>"
		return 1

/obj/item/clothing/accessory/badge/holo/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/weapon/card/id) || istype(O, /obj/item/device/pda))

		var/obj/item/weapon/card/id/id_card = null

		if(istype(O, /obj/item/weapon/card/id))
			id_card = O
		else
			var/obj/item/device/pda/pda = O
			id_card = pda.id

		if(access_security in id_card.access || emagged)
			user << "You imprint your ID details onto the badge."
			if (!name_reset)
				name_reset = name
			set_name(user.real_name)
		else
			user << "[src] rejects your insufficient access rights."
		return
	..()

/obj/item/weapon/storage/box/holobadge
	name = "holobadge box"
	desc = "A box claiming to contain holobadges."
	New()
		new /obj/item/clothing/accessory/badge/holo(src)
		new /obj/item/clothing/accessory/badge/holo(src)
		new /obj/item/clothing/accessory/badge/holo(src)
		new /obj/item/clothing/accessory/badge/holo(src)
		new /obj/item/clothing/accessory/badge/holo/cord(src)
		new /obj/item/clothing/accessory/badge/holo/cord(src)
		..()
		return

/obj/item/clothing/accessory/badge/holo/warden
	name = "warden's holobadge"
	desc = "A silver police badge. Stamped with the words 'Warden.'"
	icon_state = "silverbadge"
	slot_flags = SLOT_TIE | SLOT_BELT

/obj/item/clothing/accessory/badge/holo/hos
	name = "chief of police's holobadge"
	desc = "An immaculately polished gold police badge. Labeled 'Chief of Police.'"
	icon_state = "goldbadge"
	slot_flags = SLOT_TIE | SLOT_BELT

/obj/item/clothing/accessory/badge/holo/detective
	name = "detective's holobadge"
	desc = "An immaculately polished gold police badge on leather. Labeled 'Detective.'"
	icon_state = "marshalbadge"
	slot_flags = SLOT_TIE | SLOT_BELT

/obj/item/clothing/accessory/badge/press
	name = "press badge"
	desc = "A leather-backed plastic badge displaying that the owner is certified press personnel."
	icon_state = "pressbadge"
	badge_string = "Journalist"
	var/emagged //for the stealthy antag

/obj/item/clothing/accessory/badge/press/verb/Reset()
	if(access_library in usr.GetIdCard().access || emagged)
		if(!stored_name)
			usr << "There is no information stored on the badge."
		else
			usr << "You reset the press badge."
			stored_name = FALSE
			name = name_reset
	else
		usr << "[name] rejects your insufficient access rights."
	return

/obj/item/clothing/accessory/badge/press/attack_self(mob/user as mob)

	if(!stored_name)
		user << "Waving around a press badge before swiping an ID would be pretty pointless."
		return

	if(isliving(user))
		if(stored_name && news_network_name)
			user.visible_message("<span class='notice'>[user] displays their [src.name].\nIt reads: [stored_name], [badge_string], [news_network_name].</span>","<span class='notice'>You display your [src.name].\nIt reads: [stored_name], [badge_string], [news_network_name].</span>")
		else if(stored_name)
			user.visible_message("<span class='notice'>[user] displays their [src.name].\nIt reads: [stored_name], [badge_string].</span>","<span class='notice'>You display your [src.name].\nIt reads: [stored_name], [badge_string].</span>")
		else
			user.visible_message("<span class='notice'>[user] displays their [src.name].\nIt reads: [badge_string].</span>","<span class='notice'>You display your [src.name]. It reads: [badge_string].</span>")

/obj/item/clothing/accessory/badge/press/verb/Change_Network()
	var/new_news_network_name = sanitize(input(usr,"What news network would you like to put on this badge?","News Network Name", news_network_name) as null|text)

	if(!isnull(new_news_network_name))
		src.news_network_name = new_news_network_name
		usr << "<span class='notice'>News Network changed to '[new_news_network_name]'.</span>"

/obj/item/clothing/accessory/badge/press/emag_act(var/remaining_charges, var/mob/user)
	if (emagged)
		user << "<span class='danger'>\The [src] is already cracked.</span>"
		return
	else
		emagged = 1
		user << "<span class='danger'>You crack the press badge's security checks.</span>"
		return 1

/obj/item/clothing/accessory/badge/press/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/weapon/card/id) || istype(O, /obj/item/device/pda))

		var/obj/item/weapon/card/id/id_card = null

		if(istype(O, /obj/item/weapon/card/id))
			id_card = O
		else
			var/obj/item/device/pda/pda = O
			id_card = pda.id

		if(access_library in id_card.access || emagged)
			user << "You imprint your ID details onto the badge."
			if (!name_reset)
				name_reset = name
			set_name(user.real_name)
		else
			user << "[src] rejects your insufficient access rights."
		return
	..()

/obj/item/weapon/storage/box/holobadge/hos
	name = "holobadge box"
	desc = "A box claiming to contain holobadges."
	New()
		new /obj/item/clothing/accessory/badge/holo(src)
		new /obj/item/clothing/accessory/badge/holo(src)
		new /obj/item/clothing/accessory/badge/holo/warden(src)
		new /obj/item/clothing/accessory/badge/holo/detective(src)
		new /obj/item/clothing/accessory/badge/holo/detective(src)
		new /obj/item/clothing/accessory/badge/holo/cord(src)
		new /obj/item/clothing/accessory/badge/holo/cord(src)
		..()
		return
