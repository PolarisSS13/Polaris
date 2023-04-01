//Food

//////////////////////////////////
//			Bar Manager
//////////////////////////////////

/datum/job/barman
	title = "Bar Manager"
	flag = BAR_MANAGER
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "some questionable people"
	selection_color = "#696969"
	access = list(access_bar, access_barman, access_maint_tunnels)
	minimal_access = list(access_bar, access_barman)

	outfit_type = /decl/hierarchy/outfit/job/service/barman
	job_description = "A Bar Manager is in charge of the bar. No further comment."

//////////////////////////////////
//			Bartender
//////////////////////////////////

/datum/job/bartender
	title = "Bartender"
	flag = BARTENDER
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 4
	spawn_positions = 2
	supervisors = "the Bar Manager"
	selection_color = "#515151"
	access = list(access_bar, access_maint_tunnels)
	minimal_access = list(access_bar)

	outfit_type = /decl/hierarchy/outfit/job/service/bartender
	job_description = "A Bartender mixes drinks for the crew. They generally have permission to charge for drinks or deny service to unruly patrons."
	alt_titles = list("Fry Cook" = /datum/alt_title/fry_cook, "Bouncer" = /datum/alt_title/bouncer, "Piano Player" = /datum/alt_title/piano_player)

// Bartender Alt Titles
/datum/alt_title/fry_cook
	title = "Fry Cook"
	title_blurb = "A Fry Cook mans the kitchen in the bar, serving food to the alcoholic members of the crew. They generally have permission to charge \
					for meals or deny service to unruly patrons."

/datum/alt_title/bouncer
	title = "Bouncer"
	title_blurb = "Bouncers remove unruly or drunk customers at the request of their Manager or their Bartenders. They might be learning to make drinks."

/datum/alt_title/piano_player
	title = "Piano Player"
	title_blurb = "Piano Players are generally entertainment for the bar, but can be handy with a glass or microwave if no one else is around."

//////////////////////////////////
//			   Chef
//////////////////////////////////

/datum/job/chef
	title = "Chef"
	flag = CHEF
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Head of Personnel"
	selection_color = "#515151"
	access = list(access_bar, access_kitchen, access_maint_tunnels)
	minimal_access = list(access_kitchen)

	outfit_type = /decl/hierarchy/outfit/job/service/chef
	job_description = "A Chef cooks food for the crew. They generally have permission to charge for food or deny service to unruly diners."
	alt_titles = list("Cook" = /datum/alt_title/cook)

// Chef Alt Titles
/datum/alt_title/cook
	title = "Cook"

//////////////////////////////////
//			Shaft Miner
//////////////////////////////////

/datum/job/mining
	title = "Independent Prospector"
	flag = MINER
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Head of Personnel"
	selection_color = "#515151"
	economic_modifier = 5
	access = list(access_maint_tunnels, access_mining, access_mining_station)
	minimal_access = list(access_mining, access_mining_station)

	outfit_type = /decl/hierarchy/outfit/job/mining
	job_description = "An Independent Prospector ventures out of the station to gather valuable resources that they can bring back to the facility."
	alt_titles = list("Drill Technician" = /datum/alt_title/drill_tech, "Asteroid Miner" = /datum/alt_title/asteroid_miner)

/datum/alt_title/drill_tech
	title = "Drill Technician"
	title_blurb = "A Drill Technician specializes in operating and maintaining the machinery needed to extract ore from veins deep below the surface."

/datum/alt_title/asteroid_miner
	title = "Asteroid Miner"
	title_blurb = "Asteroid Miners specialize in the methods and practices required for zero gravity mining. Or they are learning to specialize. Either \
					way they have the required permits to use excavation equipment on asteroid rock."

//Service
//////////////////////////////////
//			Janitor
//////////////////////////////////
/datum/job/janitor
	title = "Janitor"
	flag = JANITOR
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Head of Personnel"
	selection_color = "#515151"
	access = list(access_janitor, access_maint_tunnels)
	minimal_access = list(access_janitor, access_maint_tunnels)

	outfit_type = /decl/hierarchy/outfit/job/service/janitor
	job_description = "A Janitor keeps the facility clean, as long as it doesn't interfere with active crime scenes."
	alt_titles = list("Custodian" = /datum/alt_title/custodian)

// Janitor Alt Titles
/datum/alt_title/custodian
	title = "Custodian"

//////////////////////////////////
//			Gunsmith
//////////////////////////////////
/datum/job/librarian
	title = "Gunsmith" //gunsmith to be moved to security
	flag = LIBRARIAN
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Head of Personnel"
	selection_color = "#515151"
	access = list(access_library, access_armory, access_maint_tunnels)
	minimal_access = list(access_library, access_armory)

	outfit_type = /decl/hierarchy/outfit/job/gunsmith
	job_description = "The Gunsmith curates the shooting range in the Gunsmithy, so the crew might enjoy it. They are also expected to be \
						able to assemble a host of various fire arms, as well as ammunition for the crew of the facility."
/*
	alt_titles = list("Journalist" = /datum/alt_title/journalist, "Writer" = /datum/alt_title/writer)

// Librarian Alt Titles
/datum/alt_title/journalist
	title = "Journalist"
	title_blurb = "The Journalist uses the Library as a base of operations, from which they can report the news and goings-on on the station with their camera."

/datum/alt_title/writer
	title = "Writer"
	title_blurb = "The Writer uses the Library as a quiet place to write whatever it is they choose to write."
*/
//////////////////////////////////
//		Lawyer
//////////////////////////////////

//var/global/lawyer = 0//Checks for another lawyer
/datum/job/lawyer
	title = "Public Defender"
	flag = LAWYER
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 1
	supervisors = "Lonestar Law"
	selection_color = "#515151"
	economic_modifier = 7
	access = list(access_lawyer, access_sec_doors, access_maint_tunnels, access_heads)
	minimal_access = list(access_lawyer, access_sec_doors, access_heads)
	minimal_player_age = 7

	outfit_type = /decl/hierarchy/outfit/job/pub_defender
	job_description = "A Public Defender makes sure that the crew has representation if the Sheriff has accused them of a crime. \
						They also will sometimes help regular civilians with their various paperwork needs, and should be able to\
						recognize more common breaches of Lonestar Law in contract form."

/*
/datum/job/lawyer/equip(var/mob/living/carbon/human/H)
	. = ..()
	if(.)
		H.implant_loyalty(H)
*/
