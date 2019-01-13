/client/proc/cmd_admin_check_player_logs(mob/living/M as mob in mob_list)
	set category = "Special Verbs"
	set name = "Check Player Attack Logs"
	set desc = "Check a player's attack logs."

//Views specific attack logs belonging to one player.
	var/dat = "<B>[M]'s Attack Log:<HR></B>"
	dat += "<b>Viewing attack logs of [M]</b> - (Played by ([key_name(M)]).<br>"
	if(M.mind)
		dat += "<b>Current Antag?:</b> [(M.mind.special_role)?"Yes":"No"]<br>"
	dat += "<br><b>Note:</b> This is arranged from earliest to latest. <br><br>"
	for(var/l in M.attack_log)
		dat += "<li>[l]</li>"

	usr << browse(dat, "window=admin_log")

	feedback_add_details("admin_verb","PL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


