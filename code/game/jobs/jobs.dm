
var/global/const/ENGSEC			=(1<<0)

var/global/const/CAPTAIN			=(1<<0)
var/global/const/HOS				=(1<<1)
var/global/const/WARDEN			=(1<<2)
var/global/const/DETECTIVE			=(1<<3)
var/global/const/OFFICER			=(1<<4)
var/global/const/CHIEF				=(1<<5)
var/global/const/ENGINEER			=(1<<6)
var/global/const/ATMOSTECH			=(1<<7)
var/global/const/AI				=(1<<8)
var/global/const/CYBORG			=(1<<9)


var/global/const/MEDSCI			=(1<<1)

var/global/const/RD				=(1<<0)
var/global/const/SCIENTIST			=(1<<1)
var/global/const/CHEMIST			=(1<<2)
var/global/const/CMO				=(1<<3)
var/global/const/DOCTOR			=(1<<4)
var/global/const/GENETICIST		=(1<<5)
var/global/const/VIROLOGIST		=(1<<6)
var/global/const/PSYCHIATRIST		=(1<<7)
var/global/const/ROBOTICIST		=(1<<8)
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
var/global/const/LAWYER			=(1<<9)
var/global/const/CHAPLAIN			=(1<<10)
var/global/const/ASSISTANT			=(1<<11)
var/global/const/BRIDGE			=(1<<12)

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
