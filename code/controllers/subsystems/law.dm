//
// Handles current president set laws, contraband and other player-persistent data relating to the colon.
//



SUBSYSTEM_DEF(law)
	name = "Law"
	init_order = INIT_ORDER_LAW
	flags = SS_NO_FIRE

/datum/controller/subsystem/law/Initialize(timeofday)
	instantiate_laws()

	return ..()

/datum/controller/subsystem/law/proc/instantiate_laws()
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

/datum/controller/subsystem/law/proc/rebuild_law_ids() //rebuilds entire law list IDs.

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