/obj/item/weapon/stopwatch
	name = "antique pocketwatch"
	desc = "A 19th century gold-plated ornate pocketwatch. I wonder what this button does?"
	icon = 'icons/obj/stopwatch.dmi'
	icon_state = "stopwatch"
	w_class = ITEMSIZE_SMALL
	var/broken = 0
	var/timer = 0
	var/activated = 0
	var/mob/living/carbon/human/watchowner = null
	slot_flags = SLOT_ID | SLOT_BELT | SLOT_TIE
/obj/item/weapon/stopwatch/New()
	..()
	processing_objects |= src


/obj/item/weapon/stopwatch/verb/lifesaver()
	set name = "Wind up the watch"
	set category = "Object"
	var/mob/living/carbon/human/H = usr
	if (!ishuman(H))
		to_chat(H, "<font color='blue'>You have no clue what to do with this thing.</font>")
		return
	if(!watchowner)
		to_chat(H, "<font color='blue'>You wind up the [src]. You hear a faint ticking, coming seemingly out of nowhere.</font>")
		watchowner = H
		return
	else
		to_chat(H, "<font color='blue'>You wind up the [src]. Nothing happens.</font>")
		return


/obj/item/weapon/stopwatch/attack_self(var/mob/living/user as mob)
	if (!ishuman(user))
		to_chat(user, "<font color='blue'>You have no clue what to do with this thing.</font>")
	if(timer <= 0 && !broken && !activated) //somehow, it skips ticks sometimes
		timer = 8
		icon_state = "stopwatch_on"
		var/obj/effect/timestop/T = new /obj/effect/timestop(user.loc)
		T.immune += user
		T.forceMove(get_turf(user.loc))
		T.timestop()
		activated = 1
	else if(broken)
		to_chat(user, "<font color='blue'>It completely stopped.</font>")
	else
		to_chat(user, "<font color='blue'>The [src] is recharging...</font>")


/obj/item/weapon/stopwatch/process()
	if(watchowner && !broken)
		if(prob(10))
			to_chat(watchowner, pick("<font color='blue'>Tick...</font>" , "<font color='blue'>Tock...</font>"))
			if(prob(10))
				to_chat(watchowner, pick("<font color='red'>This ticking is driving you insane...</font>" , "<font color='red'>Make the ticking stop!</font>", "<font color='red'>You feel like you're late for something.</font>", "<font color='red'>I have no time.</font>"))
				watchowner.adjustBrainLoss(5)
		if(watchowner.health < (watchowner.maxHealth - watchowner.maxHealth/2))
			watchowner.adjustBruteLoss(-15)
			watchowner.adjustFireLoss(-15)
			watchowner.adjustToxLoss(-15)
			watchowner.adjustOxyLoss(-50)
			timer = 0
			attack_self(watchowner)
			broken = 1
			icon_state = "stopwatch_cd"
			to_chat(watchowner, "<font color='blue'>Ticking stopped...</font>")
			processing_objects -= src
	if(timer > 0)
		timer--
	else if (timer <= 0)//ditto as above
		if(activated)
			icon_state = "stopwatch_cd"
			activated = 0
			timer = 15
		else
			icon_state = "stopwatch"


