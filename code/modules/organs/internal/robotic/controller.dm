// ID 'card'
/obj/item/card/id/mantid
	name = "alien chip"
	icon = 'icons/obj/mantid.dmi'
	icon_state = "access_card"
	desc = "A slender, complex chip of alien circuitry."
	access = list(access_ascent)

/obj/item/card/id/mantid/update_icon()
	return

/obj/item/card/id/mantid/prevent_tracking()
	return TRUE

/obj/item/card/id/mantid/attack_self(mob/user)
	return

// ID implant/organ/interface device.
/obj/item/organ/internal/robotic/system_controller
	name = "system controller"
	desc = "A fist-sized lump of complex circuitry."
	icon = 'icons/obj/mantid.dmi'
	icon_state = "plant"
	parent_organ = BP_TORSO
	organ_tag = O_SYSTEM_CONTROLLER
	var/obj/item/card/id/id_card = /obj/item/card/id/mantid

/obj/item/organ/internal/robotic/system_controller/replaced(mob/living/carbon/human/target, obj/item/organ/external/affected)
	. = ..()
	if(owner)
		owner.set_id_info(id_card)
		owner.add_language(LANGUAGE_MANTID_BROADCAST)

/obj/item/organ/internal/robotic/system_controller/removed(mob/living/user)
	var/mob/living/carbon/human/H = owner
	. = ..()
	if(istype(H) && H != owner && !(locate(type) in H.internal_organs))
		H.remove_language(LANGUAGE_MANTID_BROADCAST)

/obj/item/organ/internal/robotic/system_controller/Initialize()
	if(ispath(id_card))
		id_card = new id_card(src)
	. = ..()

/obj/item/organ/internal/robotic/system_controller/GetIdCard()
	if(damage < min_broken_damage)
		return id_card

/obj/item/organ/internal/robotic/system_controller/GetAccess()
	if(id_card && damage < min_broken_damage)
		return id_card.GetAccess()
