//passports are merely fluff, for now...

/obj/item/weapon/passport
	name = "passport"
	desc = "This is a passport that allows you to travel between colonies."
	icon = 'icons/obj/passport.dmi'
	icon_state = "passport"

	var/forged = FALSE
	var/citizenship = "Vetra"	// other options
	var/owner = "the owner"

/obj/item/weapon/passport/examine(mob/user)
	..()
	if(in_range(user, src) || istype(user, /mob/observer/dead))
		show_passport(usr)
	else
		to_chat(user, "<span class='notice'>You have to go closer if you want to read it.</span>")
	return


/obj/item/weapon/passport/proc/show_passport(mob/user)
	to_chat(user, "This is a [name] that shows that [owner] was born in [citizenship]."
	if(forged)
		to_chat(user, "The holographic seal appears strangely duller than usual."