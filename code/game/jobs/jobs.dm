
#define ENGSEC		(1<<0)

#define CAPTAIN		(1<<0)
#define HOS		(1<<1)
#define WARDEN		(1<<2)
#define DETECTIVE		(1<<3)
#define OFFICER		(1<<4)
#define CHIEF		(1<<5)
#define ENGINEER		(1<<6)
#define ATMOSTECH		(1<<7)
#define AI		(1<<8)
#define CYBORG		(1<<9)


#define MEDSCI		(1<<1)

#define RD		(1<<0)
#define SCIENTIST		(1<<1)
#define CHEMIST		(1<<2)
#define CMO		(1<<3)
#define DOCTOR		(1<<4)
#define GENETICIST		(1<<5)
#define VIROLOGIST		(1<<6)
#define PSYCHIATRIST		(1<<7)
#define ROBOTICIST		(1<<8)
#define XENOBIOLOGIST		(1<<9)
#define PARAMEDIC		(1<<10)


#define CIVILIAN		(1<<2)

#define HOP		(1<<0)
#define BARTENDER		(1<<1)
#define BOTANIST		(1<<2)
#define CHEF		(1<<3)
#define JANITOR		(1<<4)
#define LIBRARIAN		(1<<5)
#define QUARTERMASTER		(1<<6)
#define CARGOTECH		(1<<7)
#define MINER		(1<<8)
#define LAWYER		(1<<9)
#define CHAPLAIN		(1<<10)
#define ASSISTANT		(1<<11)
#define BRIDGE		(1<<12)


GLOBAL_LIST_INIT(assistant_occupations, list(
))


GLOBAL_LIST_INIT(command_positions, list(
	"Colony Director",
	"Head of Personnel",
	"Head of Security",
	"Chief Engineer",
	"Research Director",
	"Chief Medical Officer",
	"Command Secretary"
))


GLOBAL_LIST_INIT(engineering_positions, list(
	"Chief Engineer",
	"Station Engineer",
	"Atmospheric Technician",
))


GLOBAL_LIST_INIT(medical_positions, list(
	"Chief Medical Officer",
	"Medical Doctor",
	"Geneticist",
	"Psychiatrist",
	"Chemist",
	"Paramedic"
))


GLOBAL_LIST_INIT(science_positions, list(
	"Research Director",
	"Scientist",
	"Geneticist",	//Part of both medical and science
	"Roboticist",
	"Xenobiologist"
))

//BS12 EDIT
GLOBAL_LIST_INIT(cargo_positions, list(
	"Quartermaster",
	"Cargo Technician",
	"Shaft Miner"
))

GLOBAL_LIST_INIT(civilian_positions, list(
	"Head of Personnel",
	"Bartender",
	"Botanist",
	"Chef",
	"Janitor",
	"Librarian",
	"Lawyer",
	"Chaplain",
	"Assistant"
))


GLOBAL_LIST_INIT(security_positions, list(
	"Head of Security",
	"Warden",
	"Detective",
	"Security Officer"
))


GLOBAL_LIST_INIT(planet_positions, list(
	"Explorer",
	"Pilot",
	"Search and Rescue"
))


GLOBAL_LIST_INIT(nonhuman_positions, list(
	"AI",
	"Cyborg",
	"pAI"
))


/proc/guest_jobbans(var/job)
	return ((job in command_positions) || (job in nonhuman_positions) || (job in security_positions))

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
