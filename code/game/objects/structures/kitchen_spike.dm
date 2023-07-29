//////Kitchen Spike

/obj/structure/kitchenspike
	name = "meat spike"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "spike"
	desc = "A spike for collecting meat from animals."
	density = 1
	anchored = 1
	var/meat = 0
	var/occupied
	var/meat_type
	var/victim_name = "corpse"

/obj/structure/kitchenspike/attackby(obj/item/grab/G as obj, mob/user as mob)
	if(!istype(G, /obj/item/grab) || !ismob(G.affecting))
		return
	if(occupied)
		to_chat(user, "<span class = 'danger'>The spike already has something on it, finish collecting its meat first!</span>")
	else
		if(spike(G.affecting))
			var/datum/gender/T = gender_datums[G.affecting.get_visible_gender()]
			visible_message("<span class = 'danger'>[user] has forced [G.affecting] onto the spike, killing [T.him] instantly!</span>")
			var/mob/M = G.affecting
			M.forceMove(src)
			qdel(G)
			qdel(M)
		else
			to_chat(user, "<span class='danger'>They are too big for the spike, try something smaller!</span>")

/obj/structure/kitchenspike/proc/spike(var/mob/living/victim)
	if(!istype(victim))
		return FALSE

	if(!ishuman(victim))
		return FALSE

	var/mob/living/carbon/human/H = victim
	if(!istype(H.species, /datum/species/monkey))
		return FALSE

	meat_type = H.species.meat_type
	icon_state = "spikebloody"

	victim_name = victim.name
	occupied = 1
	meat = 5
	return TRUE

/obj/structure/kitchenspike/attack_hand(mob/user as mob)
	if(..() || !occupied)
		return
	meat--
	new meat_type(get_turf(src))
	if(meat > 1)
		to_chat(user, "You cut some meat from \the [victim_name]'s body.")
	else if(meat == 1)
		to_chat(user, "You remove the last piece of meat from \the [victim_name]!")
		icon_state = "spike"
		occupied = 0
