/hook/startup/proc/start_laws()
	instantiate_laws()

	return 1

/proc/instantiate_laws()
	//This proc loads all laws, if they don't exist already.

	for(var/instance in subtypesof(/datum/law) - list(/datum/law/misdemeanor, /datum/law/major, /datum/law/criminal, /datum/law/capital))
		var/datum/law/I = new instance
		presidential_laws += I

	for(var/datum/law/misdemeanor/M in presidential_laws)
		misdemeanor_laws += M

	for(var/datum/law/criminal/C in presidential_laws)
		criminal_laws += C

	for(var/datum/law/major/P in presidential_laws)
		major_laws += P

	for(var/datum/law/capital/K in presidential_laws)
		capital_laws += K

	rebuild_law_ids()


/proc/rebuild_law_ids() //rebuilds entire law list IDs.

	var/n //misdemeanor number
	var/d //criminal number
	var/o //major number
	var/x //capital number

	for(var/datum/law/misdemeanor/M in presidential_laws)
		n += 1
		if(n < 10)
			M.id = "i[M.prefix]0[n]"
		else
			M.id = "i[M.prefix][n]"


	for(var/datum/law/criminal/C in presidential_laws)
		d += 1
		if(d < 10)
			C.id = "i[C.prefix]0[d]"
		else
			C.id = "i[C.prefix][d]"

	for(var/datum/law/major/P in presidential_laws)
		o += 1
		if(o < 10)
			P.id = "i[P.prefix]0[o]"
		else
			P.id = "i[P.prefix][o]"

	for(var/datum/law/capital/K in presidential_laws)
		x += 1
		if(x < 10)
			K.id = "i[K.prefix]0[x]"
		else
			K.id = "i[K.prefix][x]"

/proc/get_law_names()
	var/list/law_list = list()

	for(var/datum/law/L in presidential_laws)
		law_list += "[L.name]"

	return law_list

/client/verb/view_laws()
	set category = "Special Verbs"
	set name = "View Current Laws"
	set desc = "Allows you to view all laws. Including the bad ones."

	var/dat = list()

	dat += "<title>Current Laws</title>"

	dat += "<i>Currently, there are [presidential_laws.len] laws.</i><br>"
	dat += "<html><body>"


	//Misdemeanor Laws

	dat += "<h3>Misdemeanor Laws</h3>"
	dat += "<hr>"
	dat += "Misdemeanor Laws are known as \"petty\" laws - they don't make it to court on their own usually, they have a small fine. \
	If the paying party cannot afford the fine, there's usually a very small cell time. \
	Officers can charge the party on the spot or choose to waive it for the charged in certain circumstances."
	dat += "<br>"
	dat += "<hr>"
	dat += "<table align='center' bgcolor='black'  cellspacing='0' border=1><B><tr><th>ID</th><th>Name</th><th>Description</th><th>Fine</th><th>Cell Time</th><th>Notes</th></tr></B>"

	for(var/datum/law/misdemeanor/L in misdemeanor_laws)

		dat += "<tr>"

		dat += "<td width='5%' align='center' bgcolor='[L.law_color]'>[L.id]</td>"
		dat += "<td width='15%' align='center' bgcolor='[L.law_color]'><b>[L.name]</b></td>"
		dat += "</span>"

		dat += "<td width='35%' align='center'>[L.description]</td>"

		dat += "<td width='5%'  align='center'>[L.fine]</td>"
		dat += "<td width='5%'  align='center'>[L.cell_time]</td>"
		dat += "<td width='35%'  align='center'>[L.notes]</td>"

		dat += "</tr>"


	dat += "</table>"

	//Criminal Laws

	dat += "<h3>Criminal Laws</h3>"
	dat += "<hr>"
	dat += "Criminal law are laws that are serious enough to be taken to court and can be contested. These charges cannot be \
	waived by a police officer and are treated seriously."
	dat += "<br><br>"
	dat += "<hr>"
	dat += "<table align='center' bgcolor='black' cellspacing='0' border=1><B><tr><th>ID</th><th>Name</th><th>Description</th><th>Fine</th><th>Cell Time</th><th>Notes</th></tr></B>"

	for(var/datum/law/criminal/C in criminal_laws)

		dat += "<tr>"



		dat += "<td width='5%' align='center' bgcolor='[C.law_color]'>[C.id]</td>"
		dat += "<td width='15%' align='center' bgcolor='[C.law_color]'><b>[C.name]</b></td>"
		dat += "</span>"

		dat += "<td width='35%' align='center'>[C.description]</td>"

		dat += "<td width='5%'  align='center'>[C.fine]</td>"
		dat += "<td width='5%'  align='center'>[C.cell_time]</td>"
		dat += "<td width='35%'  align='center'>[C.notes]</td>"

		dat += "</tr>"

	dat += "</table>"

	//Major Laws

	dat += "<h3>Major Laws</h3>"
	dat += "<hr>"
	dat += "Major crimes are some of the most serious types of law violations. \
	They are almost always taken to court. All major crimes, current and future, include a mandatory fine that must be paid on the spot or as soon as possible by the felon, regardless of their plea."
	dat += "<br><br>"
	dat += "<hr>"
	dat += "<table align='center' bgcolor='black' cellspacing='0' border=1><B><tr><th>ID</th><th>Name</th><th>Description</th><th>Fine</th><th>Cell Time</th><th>Notes</th></tr></B>"

	for(var/datum/law/major/M in major_laws)

		dat += "<tr>"



		dat += "<td width='5%' align='center' bgcolor='[M.law_color]'>[M.id]</td>"
		dat += "<td width='15%' align='center' bgcolor='[M.law_color]'><b>[M.name]</b></td>"
		dat += "</span>"

		dat += "<td width='35%' align='center'>[M.description]</td>"

		dat += "<td width='5%'  align='center'>[M.fine]</td>"
		dat += "<td width='5%'  align='center'>[M.cell_time]</td>"
		dat += "<td width='35%'  align='center'>[M.notes]</td>"

		dat += "</tr>"

	dat += "</table>"


	//Capital Laws

	dat += "<h3>Capital Laws</h3>"
	dat += "<hr>"
	dat += "Capital Crimes are the most serious of all crimes. Some may even carry the death penalty if a judge rules it. \
	They do not have a cell time as they are always lifetime imprisonment/detention."
	dat += "<br><br>"
	dat += "<hr>"
	dat += "<table align='center' bgcolor='black' cellspacing='0' border=1><B><tr><th>ID</th><th>Name</th><th>Description</th><th>Cell Time</th><th>Notes</th></tr></B>"

	for(var/datum/law/capital/T in capital_laws)


		dat += "<tr>"



		dat += "<td width='5%' align='center' bgcolor='[T.law_color]'>[T.id]</td>"
		dat += "<td width='15%' align='center' bgcolor='[T.law_color]'><b>[T.name]</b></td>"
		dat += "</span>"

		dat += "<td width='35%' align='center'>[T.description]</td>"

		dat += "<td width='10%' align='center'><b>Permanent</b></td>"
		dat += "<td width='35%' align='center'>[T.notes]</td>"

		dat += "</tr>"


	dat += "</table>"

	if(persistent_economy)
		dat += "<h3>Age Policies:</h3><p>"
		dat += "<b>Voting Age:</b> [persistent_economy.voting_age]<br>"
		dat += "<b>Drinking Age:</b> [persistent_economy.drinking_age]<br>"
		dat += "<b>Smoking and Tobacco Usage Age:</b> [persistent_economy.smoking_age]<br>"
		dat += "<b>Gambling Age:</b> [persistent_economy.gambling_age]<br>"
		dat += "<b>Criminal Sentencing Age:</b> [persistent_economy.sentencing_age]<br>"

		dat += "<h3>Voting Policies:</h3><p>"
		dat += "<b>Voting Rights of Synthetics:</b> [persistent_economy.synth_vote ? "Can Vote" : "Cannot Vote"]<br>"
		dat += "<b>Voting Rights of Non-Vetra Citizens:</b> [persistent_economy.citizenship_vote ? "Can Vote" : "Cannot Vote"]<br>"
		dat += "<b>Voting Rights of Former Convicts:</b> [persistent_economy.criminal_vote ? "Can Vote" : "Cannot Vote"]<br>"

		dat += "<h3>Contraband Policies:</h3><p>"
		dat += "<b>Cannabis:</b> [persistent_economy.law_CANNABIS]<br>"
		dat += "<b>Alcoholic Beverages:</b> [persistent_economy.law_ALCOHOL]<br>"
		dat += "<b>Ecstasy:</b> [persistent_economy.law_ECSTASY]<br>"
		dat += "<b>Psilocybin:</b> [persistent_economy.law_PSILOCYBIN]<br>"
		dat += "<b>Crack:</b> [persistent_economy.law_CRACK]<br>"
		dat += "<b>Cocaine:</b> [persistent_economy.law_COCAINE]<br>"
		dat += "<b>Heroin:</b> [persistent_economy.law_HEROIN]<br>"
		dat += "<b>Meth:</b> [persistent_economy.law_METH]<br>"
		dat += "<b>Nicotine:</b> [persistent_economy.law_NICOTINE]<br>"
		dat += "<b>Stimm:</b> [persistent_economy.law_STIMM]<br>"
		dat += "<b>Cyanide:</b> [persistent_economy.law_CYANIDE]<br>"
		dat += "<b>Chloral Hydrate:</b> [persistent_economy.law_CHLORAL]<br>"
		dat += "<b>Ayahuasca:</b> [persistent_economy.law_AYAHUASCA]<br>"
		dat += "<b>LSD:</b> [persistent_economy.law_LSD]<br>"
		dat += "<b>DMT:</b> [persistent_economy.law_DMT]<br>"
		dat += "<b>Bath Salts:</b> [persistent_economy.law_BATHSALTS]<br>"
		dat += "<b>Krokodil:</b> [persistent_economy.law_KROKODIL]<br>"

		dat += "<br>"
    
		dat += "<b>Guns:</b> [persistent_economy.law_GUNS]<br>"	
		dat += "<b>Small Knives:</b> [persistent_economy.law_SMALLKNIVES]<br>"	
		dat += "<b>Large Knives:</b> [persistent_economy.law_LARGEKNIVES]<br>"	
		dat += "<b>Explosives and High-Detonating Devices:</b> [persistent_economy.law_EXPLOSIVES]<br>"	

	dat += "</body></html>"

	var/datum/browser/popup = new(usr, "Laws", "Presidential Laws", 640, 600, src)
	popup.set_content(jointext(dat,null))
	popup.open()


