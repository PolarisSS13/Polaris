// this code here enables people to dig up worms from certain tiles.

/turf/simulated/floor/outdoors/grass/attackby(obj/item/weapon/S as obj, mob/user as mob)
	if(istype(S, /obj/item/weapon/shovel))
		to_chat(user, "<span class='notice'>You start digging.</span>")
		playsound(user.loc, 'sound/effects/rustle1.ogg', 50, 1)
		new/obj/item/weapon/reagent_containers/food/snacks/worm(src)