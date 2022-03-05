/client
	var/datum/managed_browser/changelingevolution/changelingevolution = null

/datum/managed_browser/changelingevolution
	base_browser_id = "evolution_tree"
	title = "Evolution Tree"
	size_x = 440
	size_y = 600
	var/textbody = null

/datum/managed_browser/changelingevolution/New(client/new_client)
	if(!new_client.mob || !new_client.mob.mind || !new_client.mob.mind.changeling)
		message_admins("[new_client] tried to access changeling evolutions while not changeling.")
		qdel(src)
	
	..()

/datum/managed_browser/changelingevolution/Destroy()
	if(my_client)
		my_client.changelingevolution = null
	return ..()

/datum/managed_browser/changelingevolution/get_html()
	var/list/dat = list("<html><body>")
	var/geneticpoints_current = my_client.mob.mind.changeling.geneticpoints
	var/geneticpoints_max = my_client.mob.mind.changeling.max_geneticpoints

	dat += "<center>Genetic Points Available: [geneticpoints_current] / [geneticpoints_max] <br>"
	dat += "Obtain more by feeding on your own kind. <br> <hr>"
	dat += "<a style='background-color:#c72121;' href='?src=\ref[src];inherent=1'>Inherent</a></center>"
	if(textbody)
		dat += "<table border='1' style='width:100%; background-color:#000000;'>"
		dat += "[textbody]"
		dat += "</table>"
	dat += "</body></html>"

	return dat.Join()

/datum/managed_browser/changelingevolution/Topic(href, href_list[])
	if(!my_client)
		return FALSE
	
	if(href_list["close"])
		return
	
	if(href_list["inherent"])
		var/list/ability_list = list()
		var/info = "These powers are inherent to your kind and will always be accessible, provided you have the chemicals to use them."
		for(var/datum/power/changeling/P in powerinstances)
			if(P.power_category == CHANGELING_POWER_INHERENT)
				ability_list[++ability_list.len] = P
		create_textbody(ability_list, "Inherent", info)


/datum/managed_browser/changelingevolution/proc/create_textbody(ability_list, cat, catinfo)
	textbody = "<tr><th><font color='#c72121'><center>[cat] Skills</font><br></th></tr>"
	textbody += "<tr><td><font color='#F7F7ED'>[catinfo]</center></font><br><hr></td></tr>"
	for(var/A in ability_list)
		var/datum/power/changeling/powerdata = A
		textbody += "<tr><td><font color='#c72121'><b>[initial(powerdata.name)]</b></font><br>"
		textbody += "<font color='#F7F7ED'>[initial(powerdata.desc)]</font><br><br>"
		textbody += "<font color='#F7F7ED'><i>[powerdata.helptext]</i></font></td></tr>"
	display()
