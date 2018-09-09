// This can be a human, skrell, unathi, or tajara child. Don't do any freaky interspecies shit with this. I'm watching you.
/obj/item/weapon/baby
	name = "baby"
	desc = "A very, very young child. How cute."
	icon = 'icons/obj/baby.dmi'
	icon_state = "baby-blackeyed"

/obj/item/weapon/baby/attack_self(mob/living/user as mob)
	if (user.client)
		if(user.client.prefs.muted & MUTE_IC)
			src << "\red You cannot speak in IC (muted)."
			return

	var/message = sanitize(copytext(input(user, "The baby...", "Baby Emote", null)  as text,1,MAX_MESSAGE_LEN))
	if(!message)
		return
	if ((src.loc == user && usr.stat == 0))
		for(var/mob/O in (viewers(user)))
			O.show_message("<B>[src]</B> [message]")