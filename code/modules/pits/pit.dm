//functions for digging pits in the ground and storing stuff in it
#define NUMCONTENT 5
#define NUMBURYTIMES 3

/obj/dugpit
	name = "pit"
	anchored = 1
	icon = 'icons/misc/Pit.dmi'
	icon_state = "pit"
	mouse_opacity = 0
	layer = STAIRS_LAYER
	var/turf/simulated/floor/outdoors/dirt/parent

obj/dugpit/New(lnk)
	..()
	parent = lnk

/obj/dugpit/container_resist(mob/living/user)
	//try to unbury self
	to_chat(user, "<span class='danger'>You start digging from inside, trying to unbury self!</span>")
	if(do_after(user, (50), target = src))
		if (prob(25))
			to_chat(user, "<span class='danger'>You have managed to move some of the ground!</span>")
			parent.unburylevel++
			if (parent.unburylevel>=NUMBURYTIMES)
				to_chat(user, "<span class='danger'>You have undug yourself!</span>")
				parent.gets_dug(null)
		else
			to_chat(user, "<span class='danger'>The ground is too heavy!</span>")

/obj/dugpit/return_air()
	var/datum/gas_mixture/GM = new
	GM.temperature = parent.temperature
	return GM

//This proc is present in code/game/objects/items/weapons/storage/storage.dm L355, and should probably have them all merged up to /obj/ level, since it likely covers itself in a few other places.
//Cross-ref code/game/objects/items.dm L292
/turf/simulated/floor/outdoors/dirt/proc/handle_item_insertion(obj/item/W, mob/usr)
	if(!istype(W))
		return

	if(ishuman(usr))

		usr.remove_from_mob(W,target = src)
		add_fingerprint(usr)
		if (usr.client && usr.s_active != src)
			usr.client.screen -= W

		if(!istype(W, /obj/item/weapon/ore/glass ) )
			if (storedindex>=NUMCONTENT)
				to_chat(usr, "<span class='notice'>The pit is filled with items to the limit!</span>")
				return

			for(var/mob/M in viewers(usr, null))
				if(M == usr)
					usr.show_message("<span class='notice'>You put [W] in the hole.</span>", 1)
				else if(in_range(M, usr)) //If someone is standing close enough, they can tell what it is...
					M.show_message("<span class='notice'>[usr] puts [W] in the hole.</span>", 1)
				else if(W && W.w_class >= 3) //Otherwise they can only see large or normal items from a distance...
					M.show_message("<span class='notice'>[usr] puts [W] in the hole.</span>", 1)

		W.forceMove(mypit)
		W.on_enter_storage(mypit)
		pitcontents += W
		storedindex = storedindex+1

		if(istype(W, /obj/item/weapon/ore/glass) && pit_sand < 1 )
			usr.show_message("<span class='notice'>You fill the hole with sand</span>", 1)
			pit_sand = 1
				qdel(W)
	else return

/turf/simulated/floor/outdoors/dirt/attack_hand(mob/living/carbon/human/M)
	if (dug)
		if (storedindex==0)
			M.show_message("<span class='notice'>There is nothing in the pit!</span>", 1)
			return
		else
			var/obj/item/I = pitcontents[storedindex]
			storedindex = storedindex - 1
			I.loc = M.loc
			pitcontents-=I

/turf/simulated/floor/outdoors/dirt/proc/finishBury(mob/user)
	user.show_message("<span class='notice'>You cover the hole with dirt.</span>", 1)
	dug = 0
	if((storedindex >= 4) || ((gravebody || gravecoffin) != null))
		mypit.icon_state = "mound"
		update_icon()
	else if (2 < storedindex < 4)
		mypit.icon_state = "mound_medium"
		update_icon()
	else if (storedindex <= 2)
		mypit.icon_state = "mound_small"
		update_icon()

/turf/simulated/floor/outdoors/dirt/proc/finishBody()
	gravebody.loc = mypit
	unburylevel = 0

/turf/simulated/floor/outdoors/dirt/proc/finishCoffin()
	gravecoffin.loc = mypit

/turf/simulated/floor/outdoors/dirt/attackby(obj/item/weapon/W, mob/user, params)

	if(!W || !user)
		return 0

	var/digging_speed = (W.digspeed * 0.1) // should probably use toolspeed but eh, would require more checks

	if (digging_speed)
		if (pit_sand < 1)
			usr.show_message("<span class='notice'>You need to fill the hole with sand!</span>", 1)
			return
		var/turf/T = user.loc
		if (!istype(T, /turf))
			return
		if (dug)
			for (var/mob/living/mobongrave in mypit.loc)
				//bury the first one
				gravebody = mobongrave
				break
			for (var/obj/structure/closet/coffin/curcoffin in mypit.loc)
				if (!curcoffin.opened)
					gravecoffin = curcoffin
					break
			playsound(src, 'sound/misc/shovel_dig.ogg', 50, 1)
			if(!(gravebody in loc)) // prevents burying yourself while not on the tile
				gravebody = null
			if(!gravecoffin in loc) // just sanity checking
				gravecoffin = null
			if (gravebody!=null)
				user.show_message("<span class='notice'>You start covering the body in the hole with dirt...</span>", 1)
				if (do_after(user, (50 * digging_speed), target=gravebody))
					if(istype(src, /turf/simulated/floor/outdoors/dirt))
						finishBury(user)
						finishBody()
			else if (gravecoffin != null)
				user.show_message("<span class='notice'>You start burying the coffin...</span>", 1)
				if (do_after(user, (50 * digging_speed), target=gravebody))
					if(istype(src, /turf/simulated/floor/outdoors/dirt))
						finishBury(user)
						finishCoffin()
			else
				user.show_message("<span class='notice'>You start covering the hole with dirt...</span>", 1)
				if(do_after(user, (50 * digging_speed), target = src))
					if(istype(src, /turf/simulated/floor/outdoors/dirt))
						finishBury(user)


		else
			user.show_message("<span class='notice'>You start digging...</span>", 1)
			playsound(src, 'sound/misc/shovel_dig.ogg', 50, 1) //FUCK YO RUSTLE I GOT'S THE DIGS SOUND HERE
			if(do_after(user, (50 * digging_speed), target = src))
				if(istype(src, /turf/simulated/floor/outdoors/dirt))
					if(pit_sand < 1)
						user.show_message("<span class='notice'>The ground has been already dug up!</span>", 1)
						return
					user.show_message("<span class='notice'>You dig a hole.</span>", 1)
					gets_dug(user)
					new /obj/item/weapon/ore/glass(src)
					new /obj/item/weapon/ore/glass(src)
					new /obj/item/weapon/ore/glass(src)
					new /obj/item/weapon/ore/glass(src)
					new /obj/item/weapon/ore/glass(src)
					new /obj/item/weapon/ore/glass(src)
					src.pit_sand = 0
	else
		//not digging
		if (dug)
			//add items
			handle_item_insertion(W, user)
			return FALSE


/turf/simulated/floor/outdoors/dirt/proc/gets_dug(mob/user)
	if(dug)
		return
	for (var/obj/item/I in pitcontents)
		I.loc = user.loc
	if (mypit==null)
		mypit = new/obj/dugpit(src)
	mypit.icon_state = "pit"
	mypit.update_icon()
	mypit.invisibility = 0
	storedindex = 0
	pitcontents = list()
	dug = 1
	if (gravebody!=null)
		if (user!=null)
			to_chat(user, "<span class='danger'>You have found a body in the pit!</span>")
		gravebody.loc = mypit.loc
	if (gravecoffin!=null)
		if (user!=null)
			to_chat(user, "<span class='notice'>You have uncovered a coffin from the grave.</span>")
		gravecoffin.loc = mypit.loc
	gravebody = null
	gravecoffin = null
	return
