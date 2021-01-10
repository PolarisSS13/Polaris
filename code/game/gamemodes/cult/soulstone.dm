/////////////////////////
//		Soulstone
/////////////////////////

/obj/item/device/soulstone
	name = "Soul Stone Shard"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "soulstone"
	item_state = "electronic"
	desc = "A fragment of the legendary treasure known simply as the 'Soul Stone'. The shard still flickers with a fraction of the full artefacts power."
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 4, TECH_ARCANE = 1)
	var/imprinted = "empty"
	var/possible_constructs = list("Juggernaut","Wraith","Artificer","Harvester")

	// Charge soulstones only require a corpse to be drained, and then they can be used similar to a Posi to summon a ghost.
	var/charged = FALSE
	var/charge_only = FALSE

	var/ghost_query_type = /datum/ghost_query/soulstone

	var/searching = FALSE

/obj/item/device/soulstone/cultify()
	return

/obj/item/device/soulstone/cult
	name = "Imperfect Soul Stone Shard"
	charge_only = TRUE

//////////////////////////////Capturing////////////////////////////////////////////////////////

/obj/item/device/soulstone/attack(mob/living/carbon/human/M as mob, mob/user as mob)
	if(!charge_only)
		if(!istype(M, /mob/living/carbon/human))//If target is not a human.
			return ..()
		if(istype(M, /mob/living/carbon/human/dummy))
			return..()
		if(jobban_isbanned(M, "cultist"))
			to_chat(user, "<span class='warning'>This person's soul is too corrupt and cannot be captured!</span>")
			return..()

		if(M.has_brain_worms()) //Borer stuff - RR
			to_chat(user, "<span class='warning'>This being is corrupted by an alien intelligence and cannot be soul trapped.</span>")
			return..()

		add_attack_logs(user,M,"Soulstone'd with [src.name]")
		transfer_soul("VICTIM", M, user)

	else if(isliving(M))

		if(imprinted != "empty")
			to_chat(user, "<span class='notice'>This stone is already bound to \the [imprinted]!</span>")
			return ..()

		if(charged)
			to_chat(user, "<span class='notice'>This stone already holds enough power to summon a spirit!</span>")
			return ..()

		if(M.has_modifier_of_type(/datum/modifier/soul_drain))
			to_chat(user, "<span class='notice'>This individual has already pawned their soul to another!</span>")
			return ..()

		else if(M.stat == DEAD && M.mob_size > MOB_TINY)
			user.Beam(M,icon_state="drain_life",icon='icons/effects/beam.dmi',time=5 SECONDS, maxdistance=2,beam_type=/obj/effect/ebeam,beam_sleep_time=3)
			M.add_modifier(/datum/modifier/soul_drain, 0)
			charged = TRUE
			if(M.client)
				if(jobban_isbanned(M, "cultist") || M.has_brain_worms())
					return..()

				var/client/C = M.client
				window_flash(C)
				var/response = alert(C, "Do you want to play as a shade?", "Soulstone request", "Yes", "No")
				if(response == "Yes")
					response = alert(C, "Are you sure you want to play as a shade?", "Soulstone request", "Yes", "No") // Protection from a misclick.
				if(!C || !src)
					return
				if(response == "Yes")
					add_attack_logs(user,M,"Soulstone'd willingly with [src.name]")
					transfer_soul("VICTIM", M, user)

			return

	return ..()


///////////////////Options for using captured souls///////////////////////////////////////

/obj/item/device/soulstone/attack_self(mob/user)
	if (!in_range(src, user))
		return
	user.set_machine(src)
	var/dat = "<TT><B>Soul Stone</B><BR>"
	for(var/mob/living/simple_mob/construct/shade/A in src)
		dat += "Captured Soul: [A.name]<br>"
		dat += {"<A href='byond://?src=\ref[src];choice=Summon'>Summon Shade</A>"}
		dat += "<br>"
		dat += {"<a href='byond://?src=\ref[src];choice=Close'> Close</a>"}

	if(imprinted == "empty" && charged)
		dat += "<br>"
		dat += "<hr>"
		dat += "This stone has enough power to tear a spirit from the aether.<br>"
		dat += {"<A href='byond://?src=\ref[src];choice=Capture'>Capture Spirit</A>"}

	user << browse(dat, "window=aicard")
	onclose(user, "aicard")
	return




/obj/item/device/soulstone/Topic(href, href_list)
	var/mob/U = usr
	if (!in_range(src, U)||U.machine!=src)
		U << browse(null, "window=aicard")
		U.unset_machine()
		return

	add_fingerprint(U)
	U.set_machine(src)

	switch(href_list["choice"])//Now we switch based on choice.
		if ("Close")
			U << browse(null, "window=aicard")
			U.unset_machine()
			return

		if ("Summon")
			for(var/mob/living/simple_mob/construct/shade/A in src)
				A.status_flags &= ~GODMODE
				A.canmove = 1
				to_chat(A, "<b>You have been released from your prison, but you are still bound to [U.name]'s will. Help them suceed in their goals at all costs.</b>")
				A.forceMove(U.loc)
				A.cancel_camera()
				src.icon_state = "soulstone"

		if ("Capture")
			if(!ghost_query_type)
				return
			searching = 1

			var/datum/ghost_query/Q = new ghost_query_type()
			var/list/winner = Q.query()
			if(winner.len)
				var/mob/observer/dead/D = winner[1]
				transfer_personality(D)
			else
				reset_search()

	attack_self(U)

/*
 * Handling ghost joining.
 */

/obj/item/device/soulstone/proc/reset_search() //We give the players sixty seconds to decide, then reset the timer.
	if(imprinted != "empty")
		return

	src.searching = 0

	visible_message("<font color='blue'>\The [src] hisses quietly. Perhaps you can try again?</font>")

/obj/item/device/soulstone/proc/transfer_personality(var/mob/candidate)
	announce_ghost_joinleave(candidate, 0, "They are occupying a soulstone now.")
	src.searching = 0

	var/mob/living/simple_mob/construct/shade/S = new /mob/living/simple_mob/construct/shade(src)

	S.real_name = "Shade of [candidate.name]"
	S.name = "Shade of [candidate.name]"
	if(candidate.icon_state != "blank")
		S.icon = candidate.icon
		S.icon_state = candidate.icon_state
		S.overlays = candidate.overlays

	if(candidate.mind)
		S.mind = candidate.mind
		S.mind.reset()

	S.forceMove(src) //put shade in stone
	S.status_flags |= GODMODE //So they won't die inside the stone somehow
	S.canmove = 0//Can't move out of the soul stone
	S.color = rgb(254,0,0)
	S.alpha = 127
	if (candidate.client)
		candidate.client.mob = S
	S.cancel_camera()
	S.invisibility = 0


	src.icon_state = "soulstone2"
	src.name = "Soul Stone: [S.real_name]"
	to_chat(S, "Your soul has been captured! You are now bound to your summoner's will, help them suceed in their goals at all costs.")
	src.imprinted = "[S.name]"
	S.mind.assigned_role = "Shade"

	visible_message("<span class='cult'>\The [src] shimmers, as a visage appears refracted on the surface.</span>")

///////////////////////////Transferring to constructs/////////////////////////////////////////////////////
/obj/structure/constructshell
	name = "empty shell"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "construct"
	desc = "A wicked machine used by those skilled in magical arts. It is inactive."

/obj/structure/constructshell/cultify()
	return

/obj/structure/constructshell/cult
	icon_state = "construct-cult"
	desc = "This eerie contraption looks like it would come alive if supplied with a missing ingredient."

/obj/structure/constructshell/attackby(obj/item/O as obj, mob/user as mob)
	if(istype(O, /obj/item/device/soulstone))
		var/obj/item/device/soulstone/S = O;
		S.transfer_soul("CONSTRUCT",src,user)


////////////////////////////Proc for moving soul in and out off stone//////////////////////////////////////
/obj/item/device/soulstone/proc/transfer_human(var/mob/living/carbon/human/T,var/mob/U)
	if(!istype(T))
		return;
	if(src.imprinted != "empty")
		to_chat(U, "<span class='danger'>Capture failed!</span>: The soul stone has already been imprinted with [src.imprinted]'s mind!")
		return
	if ((T.health + T.halloss) > config.health_threshold_crit && T.stat != DEAD)
		to_chat(U, "<span class='danger'>Capture failed!</span>: Kill or maim the victim first!")
		return
	if(T.client == null)
		to_chat(U, "<span class='danger'>Capture failed!</span>: The soul has already fled it's mortal frame.")
		return
	if(src.contents.len)
		to_chat(U, "<span class='danger'>Capture failed!</span>: The soul stone is full! Use or free an existing soul to make room.")
		return

	for(var/obj/item/W in T)
		T.drop_from_inventory(W)

	new /obj/effect/decal/remains/human(T.loc) //Spawns a skeleton
	T.invisibility = 101

	var/atom/movable/overlay/animation = new /atom/movable/overlay( T.loc )
	animation.icon_state = "blank"
	animation.icon = 'icons/mob/mob.dmi'
	animation.master = T
	flick("dust-h", animation)
	qdel(animation)

	var/mob/living/simple_mob/construct/shade/S = new /mob/living/simple_mob/construct/shade( T.loc )
	S.forceMove(src) //put shade in stone
	S.status_flags |= GODMODE //So they won't die inside the stone somehow
	S.canmove = 0//Can't move out of the soul stone
	S.name = "Shade of [T.real_name]"
	S.real_name = "Shade of [T.real_name]"
	S.icon = T.icon
	S.icon_state = T.icon_state
	S.overlays = T.overlays
	S.color = rgb(254,0,0)
	S.alpha = 127
	if (T.client)
		T.client.mob = S
	S.cancel_camera()


	src.icon_state = "soulstone2"
	src.name = "Soul Stone: [S.real_name]"
	to_chat(S, "Your soul has been captured! You are now bound to [U.name]'s will, help them suceed in their goals at all costs.")
	to_chat(U, "<span class='notice'>Capture successful!</span> : [T.real_name]'s soul has been ripped from their body and stored within the soul stone.")
	to_chat(U, "The soulstone has been imprinted with [S.real_name]'s mind, it will no longer react to other souls.")
	src.imprinted = "[S.name]"
	qdel(T)

/obj/item/device/soulstone/proc/transfer_shade(var/mob/living/simple_mob/construct/shade/T,var/mob/U)
	if(!istype(T))
		return;
	if (T.stat == DEAD)
		to_chat(U, "<span class='danger'>Capture failed!</span>: The shade has already been banished!")
		return
	if(src.contents.len)
		to_chat(U, "<span class='danger'>Capture failed!</span>: The soul stone is full! Use or free an existing soul to make room.")
		return
	if(T.name != src.imprinted)
		to_chat(U, "<span class='danger'>Capture failed!</span>: The soul stone has already been imprinted with [src.imprinted]'s mind!")
		return

	T.forceMove(src) //put shade in stone
	T.status_flags |= GODMODE
	T.canmove = 0
	T.health = T.getMaxHealth()
	src.icon_state = "soulstone2"

	to_chat(T, "Your soul has been recaptured by the soul stone, its arcane energies are reknitting your ethereal form")
	to_chat(U, "<span class='notice'>Capture successful!</span> : [T.name]'s has been recaptured and stored within the soul stone.")

/obj/item/device/soulstone/proc/transfer_construct(var/obj/structure/constructshell/T,var/mob/U)
	var/mob/living/simple_mob/construct/shade/A = locate() in src
	if(!A)
		to_chat(U, "<span class='danger'>Capture failed!</span>: The soul stone is empty! Go kill someone!")
		return;
	var/construct_class = input(U, "Please choose which type of construct you wish to create.") as null|anything in possible_constructs
	switch(construct_class)
		if("Juggernaut")
			var/mob/living/simple_mob/construct/juggernaut/Z = new /mob/living/simple_mob/construct/juggernaut (get_turf(T.loc))
			Z.key = A.key
			if(iscultist(U))
				cult.add_antagonist(Z.mind)
			qdel(T)
			to_chat(Z, "<B>You are playing a Juggernaut. Though slow, you can withstand extreme punishment, and rip apart enemies and walls alike.</B>")
			to_chat(Z, "<B>You are still bound to serve your creator, follow their orders and help them complete their goals at all costs.</B>")
			Z.cancel_camera()
			qdel(src)
		if("Wraith")
			var/mob/living/simple_mob/construct/wraith/Z = new /mob/living/simple_mob/construct/wraith (get_turf(T.loc))
			Z.key = A.key
			if(iscultist(U))
				cult.add_antagonist(Z.mind)
			qdel(T)
			to_chat(Z, "<B>You are playing a Wraith. Though relatively fragile, you are fast, deadly, and even able to phase through walls.</B>")
			to_chat(Z, "<B>You are still bound to serve your creator, follow their orders and help them complete their goals at all costs.</B>")
			Z.cancel_camera()
			qdel(src)
		if("Artificer")
			var/mob/living/simple_mob/construct/artificer/Z = new /mob/living/simple_mob/construct/artificer (get_turf(T.loc))
			Z.key = A.key
			if(iscultist(U))
				cult.add_antagonist(Z.mind)
			qdel(T)
			to_chat(Z, "<B>You are playing an Artificer. You are incredibly weak and fragile, but you are able to construct fortifications, repair allied constructs (by clicking on them), and even create new constructs</B>")
			to_chat(Z, "<B>You are still bound to serve your creator, follow their orders and help them complete their goals at all costs.</B>")
			Z.cancel_camera()
			qdel(src)
		if("Harvester")
			var/mob/living/simple_mob/construct/harvester/Z = new /mob/living/simple_mob/construct/harvester (get_turf(T.loc))
			Z.key = A.key
			if(iscultist(U))
				cult.add_antagonist(Z.mind)
			qdel(T)
			to_chat(Z, "<B>You are playing a Harvester. You are relatively weak, but your physical frailty is made up for by your ranged abilities.</B>")
			to_chat(Z, "<B>You are still bound to serve your creator, follow their orders and help them complete their goals at all costs.</B>")
			Z.cancel_camera()
			qdel(src)
		if("Behemoth")
			var/mob/living/simple_mob/construct/juggernaut/behemoth/Z = new /mob/living/simple_mob/construct/juggernaut/behemoth (get_turf(T.loc))
			Z.key = A.key
			if(iscultist(U))
				cult.add_antagonist(Z.mind)
			qdel(T)
			to_chat(Z, "<B>You are playing a Behemoth. You are incredibly slow, though your slowness is made up for by the fact your shell is far larger than any of your bretheren. You are the Unstoppable Force, and Immovable Object.</B>")
			to_chat(Z, "<B>You are still bound to serve your creator, follow their orders and help them complete their goals at all costs.</B>")
			Z.cancel_camera()
			qdel(src)

/obj/item/device/soulstone/proc/transfer_soul(var/choice as text, var/target, var/mob/U as mob)
	switch(choice)
		if("VICTIM")
			transfer_human(target,U)
		if("SHADE")
			transfer_shade(target,U)
		if("CONSTRUCT")
			transfer_construct(target,U)
