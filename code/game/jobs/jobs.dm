
var/global/const/ENGSEC			=(1<<0)

var/global/const/CAPTAIN			=(1<<0)//steward
var/global/const/HOS				=(1<<1)//sheriff
var/global/const/WARDEN			=(1<<2)//warden
var/global/const/DETECTIVE			=(1<<3)//no
var/global/const/OFFICER			=(1<<4)//deputy
var/global/const/CHIEF				=(1<<5)//yep
var/global/const/ENGINEER			=(1<<6)//yeah
var/global/const/ATMOSTECH			=(1<<7)//pestcontrol
var/global/const/ITS				=(1<<8)//IT Specialist
var/global/const/AI				=(1<<9)//remove?
var/global/const/CYBORG			=(1<<10)//sure


var/global/const/MEDSCI			=(1<<1)

var/global/const/RANCH_HEAD		=(1<<0)//garage
var/global/const/GARAGE_HEAD		=(1<<1)//greasemonky
var/global/const/CHEMIST			=(1<<2)//lol maybe
var/global/const/CMO				=(1<<3)//LT. docs
var/global/const/DOCTOR			=(1<<4)//SGT. docs
var/global/const/GENETICIST		=(1<<5)//
var/global/const/VIROLOGIST		=(1<<6)//
var/global/const/PSYCHIATRIST		=(1<<7)//chaplain
var/global/const/ROBOTICIST		=(1<<8)//mechanic
var/global/const/XENOBIOLOGIST		=(1<<9)//ranch hand
var/global/const/PARAMEDIC			=(1<<10)//lonestar trooper


var/global/const/CIVILIAN			=(1<<2)

var/global/const/HOP				=(1<<0)
var/global/const/BAR_MANAGER		=(1<<1)
var/global/const/BARTENDER			=(1<<2)
var/global/const/CHEF				=(1<<3)
var/global/const/JANITOR			=(1<<4)
var/global/const/LIBRARIAN			=(1<<5)//gunsmith?
var/global/const/QUARTERMASTER		=(1<<6)
var/global/const/CARGOTECH			=(1<<7)
var/global/const/MINER				=(1<<8)
var/global/const/LAWYER			=(1<<9)//seems like an rp role
var/global/const/CHAPLAIN			=(1<<10)//merge with psych
var/global/const/ASSISTANT			=(1<<11)
var/global/const/BRIDGE			=(1<<12)
var/global/const/PILOT 			=(1<<13)
var/global/const/HERMIT		=(1<<14)
var/global/const/DOGGO		=(1<<15)

/*
var/global/const/ENGSEC				=(1<<0)

var/global/const/CAPTAIN			=(1<<0)
var/global/const/HOS				=(1<<1)
var/global/const/WARDEN				=(1<<2)
var/global/const/DETECTIVE			=(1<<3)
var/global/const/OFFICER			=(1<<4)
var/global/const/CHIEF				=(1<<5)
var/global/const/ENGINEER			=(1<<6)
var/global/const/ATMOSTECH			=(1<<7)
var/global/const/AI					=(1<<8)
var/global/const/CYBORG				=(1<<9)


var/global/const/MEDSCI				=(1<<1)

var/global/const/RD					=(1<<0)
var/global/const/SCIENTIST			=(1<<1)
var/global/const/CHEMIST			=(1<<2)
var/global/const/CMO				=(1<<3)
var/global/const/DOCTOR				=(1<<4)
var/global/const/GENETICIST			=(1<<5)
var/global/const/VIROLOGIST			=(1<<6)
var/global/const/PSYCHIATRIST		=(1<<7)
var/global/const/ROBOTICIST			=(1<<8)
var/global/const/XENOBIOLOGIST		=(1<<9)
var/global/const/PARAMEDIC			=(1<<10)


var/global/const/CIVILIAN			=(1<<2)

var/global/const/HOP				=(1<<0)
var/global/const/BARTENDER			=(1<<1)
var/global/const/BOTANIST			=(1<<2)
var/global/const/CHEF				=(1<<3)
var/global/const/JANITOR			=(1<<4)
var/global/const/LIBRARIAN			=(1<<5)
var/global/const/QUARTERMASTER		=(1<<6)
var/global/const/CARGOTECH			=(1<<7)
var/global/const/MINER				=(1<<8)
var/global/const/LAWYER				=(1<<9)
var/global/const/CHAPLAIN			=(1<<10)
var/global/const/ASSISTANT			=(1<<11)
var/global/const/BRIDGE				=(1<<12)
var/global/const/HERMIT				=(1<<13)
var/global/const/DOGGO				=(1<<14)
*/

/proc/guest_jobbans(var/job)
	return ( (job in SSjob.get_job_titles_in_department(DEPARTMENT_COMMAND)) || (job in SSjob.get_job_titles_in_department(DEPARTMENT_SYNTHETIC)) || (job in SSjob.get_job_titles_in_department(DEPARTMENT_SECURITY)) )

/proc/get_job_datums()
	var/list/occupations = list()
	var/list/all_jobs = typesof(/datum/job)

	for(var/A in all_jobs)
		var/datum/job/job = new A()
		if(!job)	continue
		occupations += job

	return occupations

/proc/get_alternate_titles(var/job)
	var/list/jobs = get_job_datums()
	var/list/titles = list()

	for(var/datum/job/J in jobs)
		if(J.title == job)
			titles = J.alt_titles

	return titles
