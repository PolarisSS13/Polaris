/obj/item/weapon/reagent_containers/powder
	name = "powder"
	desc = "A powdered form of... something."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "powder"
	item_state = "powder"
	amount_per_transfer_from_this = 2
	possible_transfer_amounts = 2
	flags = OPENCONTAINER
	w_class = ITEMSIZE_TINY
	volume = 50

/obj/item/weapon/reagent_containers/powder/examine(mob/user)
	..()
	if(reagents)
		user << "There's about <b>[reagents.total_volume] units</b> here."

/obj/item/weapon/reagent_containers/powder/New()
	..()
	get_appearance()

/obj/item/weapon/reagent_containers/powder/proc/get_appearance()
// Get the dominant reagent, so we can have it named that. And color.
	if (reagents.reagent_list.len > 0)
		color = reagents.get_color()
		var/datum/reagent/R = reagents.get_master_reagent()
		var/new_name = lowertext(R)
		name = "powdered [new_name]"

/////Creates Various Drugs/////

/obj/item/weapon/reagent_containers/powder/cocaine/New()
	..()
	name = "powdered cocaine"
	desc = "A powdered form of a popular stimulant drug."
	reagents.add_reagent("cocaine", volume)

/obj/item/weapon/reagent_containers/powder/heroin/New()
	..()
	name = "powdered heroin"
	desc = "Are we really doing this? Were all those government PSAs for nothing?"
	reagents.add_reagent("diamorphine", volume)

/obj/item/weapon/reagent_containers/powder/cannabis/New()
	..()
	name = "powdered cannabis"
	desc = "Someone get the Mob Barley on, we've got the stuff."
	reagents.add_reagent("cannabis", volume)

// Makes it so any pill can essentially become, "a sniffed drug".
/obj/item/weapon/reagent_containers/pill/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(is_sharp(W))
		var/obj/item/weapon/reagent_containers/powder/J = new /obj/item/weapon/reagent_containers/powder(src.loc)
		user.visible_message("<span class='warning'>[user] gently cuts up [src] with [W]!</span>")
		playsound(src.loc, 'sound/effects/chop.ogg', 50, 1)

		if(reagents)
			reagents.trans_to_obj(J, reagents.total_volume)
		J.get_appearance()
		qdel(src)

	if(istype(W, /obj/item/weapon/card/id))
		var/obj/item/weapon/reagent_containers/powder/J = new /obj/item/weapon/reagent_containers/powder(src.loc)
		user.visible_message("<span class='warning'>[user] clumsily chops up [src] with [W]!</span>")
		playsound(src.loc, 'sound/effects/chop.ogg', 50, 1)

		if(reagents)
			reagents.trans_to_obj(J, reagents.total_volume)
		J.get_appearance()
		qdel(src)

	return ..()

//////Snorting///////

//Cast this to living from the start. Nothing non living should ever be calling this proc.
/obj/item/weapon/reagent_containers/powder/attackby(var/obj/item/weapon/W, var/mob/living/user)

//If we're not attacking by those two things then don't snort cocaine.
	if(!istype(W, /obj/item/weapon/glass_extra/straw) && !istype(W, /obj/item/weapon/rollingpaper))
		return ..()

	user.visible_message("<span class='warning'>[user] snorts [src] with [W]!</span>")
	playsound(loc, 'sound/effects/snort.ogg', 50, 1)

	if(reagents)
		reagents.trans_to_mob(user, amount_per_transfer_from_this, CHEM_BLOOD)//Make this user.

	qdel(src)//Delete this now


/////Grinding/////

/obj/item/weapon/grinder
	name = "grinder"
	desc = "I suppose this is what kids like to use these days."
	w_class = ITEMSIZE_SMALL
	icon = 'icons/obj/chemical.dmi'
	icon_state = "grinder"

// To do: Make the grinder icon a bit lighter, so we can make them multi-colored.

/obj/item/weapon/grinder/attackby(var/obj/item/weapon/W, var/mob/living/user)
	var/ground = 0

//Basically, if we grind stuff, we get nice powder back,
//preferably back in the place we got it.
	if (istype(W, /obj/item/weapon/reagent_containers/food/snacks/grown))
		var/obj/item/weapon/reagent_containers/food/snacks/grown/G = W
		//Can't grind stuff that isn't dried, sadly.
		if (!G.dry)
			to_chat(usr,"<span class='notice'>[G] must be dried before you can use [src] to grind it.</span>")
			return
		ground = 1

	if (istype(W, /obj/item/weapon/reagent_containers/drugs/baggie))
		if(!W.reagents.total_volume)
			to_chat(usr,"Looks like [W] is empty.")
		else
			ground = 1

	if (istype(W, /obj/item/weapon/reagent_containers/pill))
		ground = 1


	if(!ground)
		to_chat(usr,"You don't seem to be able to grind [W].")
		return

	var/obj/item/weapon/reagent_containers/powder/J = new /obj/item/weapon/reagent_containers/powder(user.loc)
	if (!istype(W, /obj/item/weapon/reagent_containers/drugs/baggie))
		J.name = "[W.name] powder"
	to_chat(usr,"<span class='notice'>You use [src] to refine [W.name] into a powder!</span>")
	playsound(loc, 'sound/items/grinder.ogg', 50, 1)
	if(W.reagents)
		W.reagents.trans_to_obj(J, W.reagents.total_volume)
		J.get_appearance()
	if(ishuman(usr) && !usr.get_active_hand())
		usr.put_in_hands(J)
	if (!istype(W, /obj/item/weapon/reagent_containers/drugs/baggie))
		qdel(W)//If this isn't a baggie, delete it. Otherwise just empty baggie.


/obj/item/weapon/reagent_containers/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if (istype(W, /obj/item/weapon/reagent_containers/powder))
		if(!W.reagents.total_volume)
			//If the powder gets transferred entirely, we're good.
			qdel(W)
