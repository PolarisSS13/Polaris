/////////////////////////////////////////
//			Alt Title Code
/////////////////////////////////////////

/datum/alt_title
	var/title = "GENERIC ALT TITLE"				// What the Alt-Title is called
	var/title_outfit = null						// The outfit used by the alt-title. If it's the same as the base job, leave this null.
	var/title_blurb = null						// What's amended to the job description for this Job title. If nothing's added, leave null.


// Inputs a string to return an alt_title datum
/datum/job/proc/find_alt_title(var/target_title)
	for(var/datum/alt_title/A in alt_titles)
		if(A.title == target_title)
			return A
	return null