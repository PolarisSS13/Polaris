/obj/item/paper/newtalisman
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
	var/whispered

/obj/item/paper/newtalisman/get_examine_desc()
	if ((isobserver(usr) || iscultist(usr)) && talisman_name && talisman_desc)
		return SPAN_OCCULT("This is a <b>[talisman_name]</b> talisman.<br>[talisman_desc]")
	else
		return desc

/obj/item/paper/newtalisman/show_content(mob/user, force_show)
	if (iscultist(user))
		return
	return ..()

/obj/item/paper/newtalisman/attack(mob/living/carbon/T, mob/living/user)
	if (iscultist(user) && user.a_intent == I_HURT)
		if (invocation)
			!whispered ? user.say(invocation) : user.whisper(invocation)
		add_attack_logs(user, T, "[lowertext(talisman_name)] talisman")
		invoke(user, T)
		qdel(src)
		return
	return ..()

/obj/item/paper/newtalisman/proc/invoke(mob/living/user, mob/living/target)
	return
