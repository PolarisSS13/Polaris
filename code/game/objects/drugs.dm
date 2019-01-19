obj/item/weapon/reagent_containers/powder
	name = "powder"
	desc = "A powdered form of... something."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "powder"
	item_state = "powder"
	possible_transfer_amounts = null
	w_class = ITEMSIZE_TINY
	volume = 5
	var/list/filled_reagents

//Creates Cocaine Powder

/obj/item/weapon/reagent_containers/powder/cocaine/New()
	..()
	name = "powdered cocaine"
	desc = "A powdered form of a popular stimulant drug."
	reagents.add_reagent("cocaine", 5)

//Crushing
/obj/item/weapon/reagent_containers/pill/cocaine/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(is_sharp(W))
		new /obj/item/weapon/reagent_containers/powder/cocaine(src.loc)
		user.visible_message("<span class='warning'>[user] gently cuts up [src] with [W]!</span>")
		playsound(src.loc, 'sound/weapons/flipblade.ogg', 50, 1)
		qdel(src)
		return

	if(istype(W, /obj/item/weapon/card/id))
		new /obj/item/weapon/reagent_containers/powder/cocaine(src.loc)
		user.visible_message("<span class='warning'>[user] clumsily chops up [src] with [W]!</span>")
		qdel(src)
		return

		return ..()

//Snorting
/obj/item/weapon/reagent_containers/powder/cocaine/attackby(var/obj/item/weapon/W, var/mob/living/user)//Cast this to living from the start. Nothing non living should ever be calling this proc.

	if(!istype(W, /obj/item/weapon/glass_extra/straw) && !istype(W, /obj/item/weapon/rollingpaper))//If we're not attacking by those two things then don't snort cocaine.
		return ..()

	user.visible_message("<span class='warning'>[user] snorts the [src] with the [W]!</span>")

	if(reagents)
		reagents.trans_to_mob(user, amount_per_transfer_from_this, CHEM_BLOOD)//Make this user.

	qdel(src)//Delete this now
