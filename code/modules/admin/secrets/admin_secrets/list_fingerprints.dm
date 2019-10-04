/datum/admin_secret_item/admin_secret/list_fingerprints
	name = "List Fingerprints"

/datum/admin_secret_item/admin_secret/list_fingerprints/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	var/dat = "<B>Showing Fingerprints.</B><HR>"
	dat += "<table cellspacing=5><tr><th>Name</th><th>Fingerprints</th></tr>"
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.ckey)
			if(H.dna && H.unique_id)
				dat += "<tr><td>[H]</td><td>[H.get_full_print()]</td></tr>"
			else
				dat += "<tr><td>[H]</td><td>H.get_full_print() = null</td></tr>"
	dat += "</table>"
	user << browse(dat, "window=fingerprints;size=440x410")
