//This'll be used for gun permits, such as for heads of staff, antags, and bartenders

/obj/item/clothing/accessory/permit
	name = "permit"
	desc = "A permit for something."
	icon = 'icons/obj/card.dmi'
	icon_state = "permit"
	w_class = ITEMSIZE_TINY
	var/owner = 0	//To prevent people from just renaming the thing if they steal it
	var/tiered = TRUE // If this is true, this will have different tiers
	var/tier = 0	// different tiers allow different things

/obj/item/clothing/accessory/permit/New()
	..()
	update_icon()

/obj/item/clothing/accessory/permit/attack_self(mob/user as mob)
	if(isliving(user))
		if(!owner)
			set_name(user.name)
			to_chat(user, "[src] registers your name.")
		else
			to_chat(user, "[src] already has an owner!")

/obj/item/clothing/accessory/permit/proc/set_name(var/new_name)
	owner = 1
	if(new_name)
		src.name += " ([new_name])"
		desc += " It belongs to [new_name]."

/obj/item/clothing/accessory/permit/update_icon()
	if(tiered)
		icon_state = "[initial(icon_state)]_[tier]"

/obj/item/clothing/accessory/permit/emag_act(var/remaining_charges, var/mob/user)
	to_chat(user, "You reset the naming locks on [src]!")
	owner = 0

/obj/item/clothing/accessory/permit/gun
	name = "tier 0 weapon permit"
	desc = "A card indicating that the owner is allowed to carry a firearm."
	tier = 0
	price_tag = 50
	
/obj/item/clothing/accessory/permit/gun/tier_one
	name = "tier one weapon permit"
	desc = "A card indicating that the owner is allowed to carry a firearm."
	tier = 1
	price_tag = 200

/obj/item/clothing/accessory/permit/gun/tier_two
	name = "tier two weapon permit"
	desc = "A card indicating that the owner is allowed to carry a firearm."
	tier = 2
	price_tag = 700

/obj/item/clothing/accessory/permit/gun/tier_three
	name = "tier three weapon permit"
	desc = "A card indicating that the owner is allowed to carry a firearm."
	tier = 3
	price_tag = 1000

/obj/item/clothing/accessory/permit/gun/tier_four
	name = "tier four weapon permit"
	desc = "A card indicating that the owner is allowed to carry a firearm."
	tier = 4
	price_tag = 1500

/obj/item/clothing/accessory/permit/gun/tier_five
	name = "tier five weapon permit"
	desc = "A card indicating that the owner is allowed to carry a firearm."
	tier = 5
	price_tag = 3000

/obj/item/clothing/accessory/permit/gun/bar
	name = "bar shotgun permit"
	desc = "A card indicating that the owner is allowed to carry a shotgun in the bar."

/obj/item/clothing/accessory/permit/gun/planetside
	name = "planetside gun permit"
	desc = "A card indicating that the owner is allowed to carry a firearm while on the surface."

/obj/item/clothing/accessory/permit/drone
	name = "drone identification card"
	desc = "A card issued by the EIO, indicating that the owner is a Drone Intelligence. Drones are mandated to carry this card within SolGov space, by law."
	icon_state = "permit_drone"

//Some spare gun permits in a box
/obj/item/weapon/storage/box/gun_permits
	name = "box of spare gun permits"
	desc = "A box of spare gun permits."
	icon = 'icons/obj/storage.dmi'
	icon_state = "permit"
	starts_with = list(	/obj/item/clothing/accessory/permit/gun = 8)
