/obj/item/device/public_intercom
	name = "request booth"
	icon = 'icons/obj/radio.dmi'
	icon_state = "lawyer"
	anchored = 1

	var/department = "Common" //Has to be linked to an actual department for it to work.
	var/service = "Common Broadcast"

/obj/item/device/public_intercom/lawyer
	name = "lawyer request booth"
	desc = "For all your legal needs. Just shout into this thing."
	icon_state = "lawyer"
	department = "Legal"
	service = "Legal Services"

/obj/item/device/public_intercom/attack_hand(mob/living/user as mob)
	var/text = sanitizeSafe(input(usr,"What message do you want to relay over to [service]?","Message"))
	if(text)
		global_announcer.autosay ("<FONT size=3>Relayed message in [user.loc.loc] from <B>[user]</B>: [text] </FONT>", "[service]", "[department]")

		user << "<span class='danger'>You sent over the message \"[text]\" over to the [service] hotline.</span>"
		log_say("(COMM: [src]) sent \"[text]\" to [service]", usr)