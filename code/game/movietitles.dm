/proc/roll_titles()
	set waitfor = 0
	for(var/client/C)
		if(C.mob)
			C.mob.overlay_fullscreen("fishbed",/obj/screen/fullscreen/fishbed)
			C.mob.overlay_fullscreen("scanlines",/obj/screen/fullscreen/scanline)
			C.mob.overlay_fullscreen("whitenoise",/obj/screen/fullscreen/noise)

	to_world('sound/music/smthingaboutus.ogg')
	var/list/titles = list()
	var/list/cast = list()
	var/list/chunk = list()
	var/chunksize = 0
	titles += "<center><h1>EPISODE [rand(1,1000)] - THE [pick("DOWNFALL OF","RISE OF","TROUBLE WITH","FINAL STAND OF","DARK SIDE OF")] [pick("CITY FOLK","THE CORRUPT METROPOLIS","THE CLASS WAR","COLONY LIFE","THE WAGE SLAVES","THE POLLUXIANS","[uppertext(using_map.station_name)]")]</h1></center>"
	for(var/mob/living/carbon/human/H in mob_list)
		if(!cast.len && !chunksize)
			chunk += "CAST:"
		chunk += "[H.species.get_random_name(H.gender)]\t\t\tas\t\t\t[uppertext(H.real_name)]"
		chunksize++
		if(chunksize > 4)
			cast += "<center>[jointext(chunk,"<br>")]</center>"
			chunk.Cut()
			chunksize = 0
	if(chunk.len)
		cast += "<center>[jointext(chunk,"<br>")]</center>"
	titles += cast
	var/list/corpses = list()
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.stat == 2)
			if(H.real_name)
				corpses += H.real_name
	if(corpses.len)
		titles += "<center>BASED ON REAL EVENTS<br>In memory of [english_list(corpses)].</center>"

	var/list/staff = list("PRODUCTION STAFF:")
	var/list/staffjobs = list("Coffe Fetcher", "Cameraman", "Angry Yeller", "Chair Operator", "Choreographer", "Historical Consultant", "Costume Designer", "Chief Editor", "Executive Assistant")
	var/list/goodboys = list()
	for(var/client/C in admins)
		if((C.holder.rights & R_MOD) && !(C.holder.rights & R_DEBUG|R_ADMIN))
			goodboys += "[C.ckey]"
		else
			var/datum/species/S = all_species[pick(all_species)]
			var/g = prob(50) ? MALE : FEMALE
			staff += "[uppertext(pick(staffjobs))] - [S.get_random_name(g)] a.k.a. '[C.key]'"

	titles += "<center>[jointext(staff,"<br>")]</center>"
	if(goodboys.len)
		titles += "<center>STAFF'S GOOD BOYS:<br>[english_list(goodboys)]</center>"


	var/disclaimer = "Sponsored by [using_map.company_name].<br>All rights reserved.<br>"
	disclaimer += pick("Use for parody prohibited. Prohibited.", "All stunts were performed by underpaid interns. Do NOT try at home.", "[using_map.company_name] does not endorse behaviour depicted. Attempt at your own risk.")
	titles += "<center>[disclaimer]</center>"

	for(var/part in titles)
		Show2Group4Delay(ScreenText(null, titles[part] ? titles[part] : part,"1,CENTER"), null, 60)
		sleep(65)
