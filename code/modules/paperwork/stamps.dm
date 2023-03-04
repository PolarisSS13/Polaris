/obj/item/stamp
	name = "rubber stamp"
	desc = "A rubber stamp for stamping important documents."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "stamp-qm"
	item_state = "stamp"
	throwforce = 0
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_HOLSTER
	throw_speed = 7
	throw_range = 15
	matter = list(MAT_STEEL = 60)
	pressure_resistance = 2
	attack_verb = list("stamped")
	drop_sound = 'sound/items/drop/device.ogg'
	pickup_sound = 'sound/items/pickup/device.ogg'

	/// The authority this stamp represents. Used where the full object name would be inappropriate.
	var/authority_name = ""

	/// Any trailing possessiveness for authority_name.
	var/authority_suffix = ""


/obj/item/stamp/Initialize()
	. = ..()
	GenerateName()


/obj/item/stamp/proc/GenerateName()
	if (!authority_name)
		name = initial(name)
		return
	var/first_char = copytext_char(authority_name, 1, 2)
	if (lowertext(first_char) != first_char)
		name = "\improper [authority_name][authority_suffix] [initial(name)]"
	else
		name = "[authority_name][authority_suffix] [initial(name)]"


/obj/item/stamp/captain
	icon_state = "stamp-cap"
	authority_name = "site manager"
	authority_suffix = "'s"


/obj/item/stamp/hop
	icon_state = "stamp-hop"
	authority_name = "head of personnel"
	authority_suffix = "'s"


/obj/item/stamp/hos
	icon_state = "stamp-hos"
	authority_name = "head of security"
	authority_suffix = "'s"


/obj/item/stamp/ward
	icon_state = "stamp-ward"
	authority_name = "warden"
	authority_suffix = "'s"


/obj/item/stamp/ce
	icon_state = "stamp-ce"
	authority_name = "chief engineer"
	authority_suffix = "'s"


/obj/item/stamp/rd
	icon_state = "stamp-rd"
	authority_name = "research director"
	authority_suffix = "'s"


/obj/item/stamp/cmo
	icon_state = "stamp-cmo"
	authority_name = "chief medical officer"
	authority_suffix = "'s"


/obj/item/stamp/denied
	icon_state = "stamp-deny"
	attack_verb = list("DENIED")
	authority_name = "DENIED"


/obj/item/stamp/accepted
	icon_state = "stamp-ok"
	attack_verb = list("ACCEPTED")
	authority_name = "ACCEPTED"


/obj/item/stamp/clown
	icon_state = "stamp-clown"
	authority_name = "clown"
	authority_suffix = "'s"


/obj/item/stamp/internalaffairs
	icon_state = "stamp-intaff"
	authority_name = "internal affairs"


/obj/item/stamp/centcomm
	icon_state = "stamp-cent"
	authority_name = "CentCom"


/obj/item/stamp/qm
	icon_state = "stamp-qm"
	authority_name = "quartermaster"
	authority_suffix = "'s"


/obj/item/stamp/cargo
	icon_state = "stamp-cargo"
	authority_name = "cargo"


/obj/item/stamp/solgov
	icon_state = "stamp-sg"
	authority_name = "Sol Government"


/obj/item/stamp/solgovlogo
	icon_state = "stamp-sol"
	name = "logo stamp"
	authority_name = "Sol Government"


/obj/item/stamp/einstein
	icon_state = "stamp-einstein"
	authority_name = "Eintstein Engines"


/obj/item/stamp/hephaestus
	icon_state = "stamp-heph"
	authority_name = "Hephaestus Industries"


/obj/item/stamp/zeng_hu
	icon_state = "stamp-zenghu"
	authority_name = "Zeng-Hu Pharmaceuticals"


/obj/item/stamp/chameleon
	var/static/list/chameleon_stamps


/obj/item/stamp/chameleon/Initialize()
	. = ..()
	if (chameleon_stamps)
		return
	chameleon_stamps = list()
	for (var/obj/item/stamp/stamp as anything in (typesof(/obj/item/stamp) - type))
		stamp = new stamp
		chameleon_stamps[stamp.name] = list(stamp.icon_state, stamp.authority_name, stamp.authority_suffix)
	chameleon_stamps = sortList(chameleon_stamps)


/obj/item/stamp/chameleon/attack_self(mob/living/user)
	UpdateChameleon(user)


/obj/item/stamp/chameleon/proc/UpdateChameleon(mob/living/user)
	if (BlockInteraction(user))
		return
	var/response = input(user, "Select a stamp to copy:") as null | anything in chameleon_stamps
	if (!response || !(response in chameleon_stamps))
		return
	if (BlockInteraction(user))
		return
	var/list/stamp = chameleon_stamps[response]
	name = response
	icon_state = stamp[1]
	authority_name = stamp[2]
	authority_suffix = stamp[3]
