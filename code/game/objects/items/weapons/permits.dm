//This'll be used for gun permits, such as for heads of staff, antags, and bartenders

/obj/item/weapon/permit
	name = "permit"
	desc = "A permit for something."
	icon = 'icons/obj/card.dmi'
	icon_state = "permit"
	w_class = ITEMSIZE_TINY
	var/owner = 0	//To prevent people from just renaming the thing if they steal it

/obj/item/weapon/permit/attack_self(mob/user as mob)
	if(isliving(user))
		if(!owner)
			set_name(user.name)
		else
			to_chat(user, "[src] already has an owner!")

/obj/item/weapon/permit/proc/set_name(var/new_name)
	owner = 1
	if(new_name)
		src.name += " ([new_name])"
		desc += " It belongs to [new_name]."

/obj/item/weapon/permit/emag_act(var/remaining_charges, var/mob/user)
	to_chat(user, "You reset the naming locks on [src]!")
	owner = 0

/obj/item/weapon/permit/gun
	name = "weapon permit"
	desc = "A card indicating that the owner is allowed to carry a firearm."

/obj/item/weapon/permit/gun/bar
	name = "bar shotgun permit"
	desc = "A card indicating that the owner is allowed to carry a shotgun in the bar."