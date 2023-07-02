/obj/structure/stasis_cage
	name = "stasis cage"
	desc = "A high-tech animal cage, designed to keep contained fauna docile and safe."
	icon = 'icons/obj/storage.dmi'
	icon_state = "critteropen"
	density = 1

	var/mob/living/simple_mob/contained

/obj/structure/stasis_cage/Initialize()
	. = ..()

	var/mob/living/simple_mob/A = locate() in loc
	if(A)
		contain(A)

/obj/structure/stasis_cage/attack_hand(var/mob/user)
	release()

/obj/structure/stasis_cage/attack_robot(var/mob/user)
	if(Adjacent(user))
		release()

/obj/structure/stasis_cage/proc/contain(var/mob/living/simple_mob/animal)
	if(contained || !istype(animal))
		return
	contained = animal
	animal.forceMove(src)
	animal.in_stasis = 1
	if(animal.buckled && istype(animal.buckled, /obj/effect/energy_net))
		animal.buckled.forceMove(animal.loc)
	icon_state = "critter"
	desc = initial(desc) + " \The [contained] is kept inside."

/obj/structure/stasis_cage/proc/release()
	if(!contained)
		return
	contained.dropInto(src)
	if(contained.buckled && istype(contained.buckled, /obj/effect/energy_net))
		contained.buckled.dropInto(src)
	contained.in_stasis = 0
	contained = null
	icon_state = "critteropen"
	underlays.Cut()
	desc = initial(desc)

/obj/structure/stasis_cage/Destroy()
	release()
	return ..()

/mob/living/simple_mob/MouseDrop(var/obj/structure/stasis_cage/over_object)
	if(!istype(over_object) || !Adjacent(over_object) || !CanMouseDrop(over_object, usr))
		return ..()

	if(src != usr && !(sleeping || lying) && !istype(buckled, /obj/effect/energy_net))
		to_chat(usr, SPAN_WARNING("It's going to be difficult to load \the [src] into \the [over_object] without putting it to sleep or capturing it in a net."))
		return

	if(usr == src)
		usr.visible_message(
			SPAN_NOTICE("\The [src] starts climbing into [src] \the [over_object]."),
			SPAN_NOTICE("You start climbing into \the [over_object].")
		)
	else
		usr.visible_message(
			SPAN_NOTICE("\The [usr] begins loading \the [src] into \the [over_object]."),
			SPAN_NOTICE("You begin loading \the [src] into \the [over_object].")
		)

	Bumped(usr)
	if(!do_after(usr, 20, over_object))
		return

	if(usr == src)
		usr.visible_message(
			SPAN_NOTICE("\The [usr] climbs into \the [over_object]."),
			SPAN_NOTICE("You climb into \the [over_object].")
		)
	else
		usr.visible_message(
			SPAN_NOTICE("\The [usr] finishes loading \the [src] into \the [over_object]."),
			SPAN_NOTICE("You finish loading \the [src] into \the [over_object].")
		)
	over_object.contain(src)
