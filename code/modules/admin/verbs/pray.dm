/mob/verb/pray(msg as text)
	set category = "IC"
	set name = "Pray"

	if(say_disabled)	//This is here to try to identify lag problems
		usr << "<font color='red'>Speech is currently admin-disabled.</font>"
		return

	msg = sanitize(msg)
	if(!msg)	return

	if(usr.client)
		if(msg)
			client.handle_spam_prevention(MUTE_PRAY)
			if(usr.client.prefs.muted & MUTE_PRAY)
				usr << "<font color='red'> You cannot pray (muted).</font>"
				return

	var/image/cross = image('icons/obj/storage.dmi',"bible")
	msg = "<span class='notice'>\icon[cross] <b><font color=purple>PRAY: </font>[key_name(src, 1)] (<A HREF='?_src_=holder;adminmoreinfo=\ref[src]'>?</A>) (<A HREF='?_src_=holder;adminplayeropts=\ref[src]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[src]'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=\ref[src]'>SM</A>) ([admin_jump_link(src, src)]) (<A HREF='?_src_=holder;secretsadmin=check_antagonist'>CA</A>) (<A HREF='?_src_=holder;adminspawncookie=\ref[src]'>SC</a>) (<A HREF='?_src_=holder;take_ic=\ref[src]'>TAKE</a>):</b> [msg]</span>"

	for(var/client/C in admins)
		if(R_ADMIN & C.holder.rights)
			if(C.is_preference_enabled(/datum/client_preference/admin/show_chat_prayers))
				C << msg
				C << 'sound/effects/ding.ogg'
	usr << "Your prayers have been received by the gods."

	feedback_add_details("admin_verb","PR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	//log_admin("HELP: [key_name(src)]: [msg]")

/proc/CentCom_announce(var/msg, var/mob/Sender, var/iamessage)
	var/msg_cciaa = "<span class='notice'><b><font color=orange>[uppertext(using_map.boss_short)][iamessage ? " IA" : ""]:</font>[key_name(Sender, 1)] (<A HREF='?_src_=holder;CentcommReply=\ref[Sender]'>RPLY</A>):</b> [msg]</span>"
	var/msg_admin = "<span class='notice'><b><font color=orange>[uppertext(using_map.boss_short)][iamessage ? " IA" : ""]:</font>[key_name(Sender, 1)] (<A HREF='?_src_=holder;adminplayeropts=\ref[Sender]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[Sender]'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=\ref[Sender]'>SM</A>) ([admin_jump_link(Sender, src)]) (<A HREF='?_src_=holder;secretsadmin=check_antagonist'>CA</A>) (<A HREF='?_src_=holder;BlueSpaceArtillery=\ref[Sender]'>BSA</A>) (<A HREF='?_src_=holder;CentcommReply=\ref[Sender]'>RPLY</A>):</b> [msg]</span>"

	var/cciaa_present = 0
	var/cciaa_afk = 0

	for(var/client/C in admins)
		if(R_ADMIN & C.holder.rights)
			to_chat(C, msg_admin)
		else if (R_CBIA & C.holder.rights)
			cciaa_present++
			if (C.is_afk())
				cciaa_afk++

			to_chat(C, msg_cciaa)

	discord_bot.send_to_cciaa("Emergency message from the station: `[msg]`, sent by [Sender]! Gamemode: [ticker.mode]")

	var/discord_msg = "[cciaa_present] agents online."
	if (cciaa_present)
		if ((cciaa_present - cciaa_afk) <= 0)
			discord_msg += " **All AFK!**"
		else
			discord_msg += " [cciaa_afk] AFK."

	discord_bot.send_to_cciaa(discord_msg)
	post_webhook_event(WEBHOOK_CBIA_EMERGENCY_MESSAGE, list("message"=msg, "sender"="[Sender]", "cciaa_present"=cciaa_present, "cciaa_afk"=cciaa_afk))

/proc/Syndicate_announce(var/msg, var/mob/Sender)
	msg = "<span class='notice'><b><font color=crimson>ILLEGAL:</font>[key_name(Sender, 1)] (<A HREF='?_src_=holder;adminplayeropts=\ref[Sender]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[Sender]'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=\ref[Sender]'>SM</A>) ([admin_jump_link(Sender, src)]) (<A HREF='?_src_=holder;secretsadmin=check_antagonist'>CA</A>) (<A HREF='?_src_=holder;BlueSpaceArtillery=\ref[Sender]'>BSA</A>) (<A HREF='?_src_=holder;SyndicateReply=\ref[Sender]'>RPLY</A>):</b> [msg]</span>"
	for(var/client/C in admins)
		if(R_ADMIN & C.holder.rights)
			to_chat(C, msg)