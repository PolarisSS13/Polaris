/obj/item/paper/talisman
	icon_state = "paper_talisman"
	info = "<center><img src='talisman.png'></center><br/><br/>"
	can_write = FALSE

	/// The actual name of this talisman (like "Stun", "Blind", or so on), shown to cultists or ghosts that examine it.
	var/talisman_name
	/// A description of what this talisman actually does.
	var/talisman_desc
	/// The words spoken by a cultist activating this talisman.
	var/invocation = "Look at this photograph!"
	/// If true, cultists invoking this talisman will whisper, instead of speaking normally.
	var/whispered = TRUE
	/// If TRUE, the talisman will be deleted after invocation.
	var/delete_self = TRUE

/obj/item/paper/talisman/get_examine_desc()
	if ((isobserver(usr) || iscultist(usr)) && talisman_name && talisman_desc)
		return SPAN_OCCULT("This is a <b>[talisman_name]</b> talisman.<br>[talisman_desc]")
	else
		return desc

/obj/item/paper/talisman/show_content(mob/user, force_show)
	if (iscultist(user))
		return
	return ..()

/obj/item/paper/talisman/attack_self(mob/living/user)
	if (iscultist(user))
		invoke(user)
		!whispered ? user.say(invocation) : user.whisper(invocation)
		if (delete_self)
			qdel(src)
		return
	return ..()

/obj/item/paper/talisman/proc/invoke(mob/living/user)
	return

/*
Here's a template you can copy-paste to quickly get started on making a new talisman:

/obj/item/paper/talisman/SUBTYPE
	talisman_name = "TYPE"
	talisman_desc = "DESC"
	invocation = "Bruh"

/obj/item/paper/talisman/SUBTYPE/invoke(mob/living/user)
	return
*/
