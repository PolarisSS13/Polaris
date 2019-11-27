//Food
/datum/job/bartender
	title = "Bartender"
	flag = BARTENDER
	faction = "City"
	department = "Bar"
	department_flag = CIVILIAN
	total_positions = 2
	spawn_positions = 2
	email_domain = "foodstuffs.nt"
	supervisors = "the city clerk"
	selection_color = "#515151"
	idtype = /obj/item/weapon/card/id/civilian/bartender
	access = list(access_hydroponics, access_bar, access_kitchen)
	minimal_access = list(access_bar)
	minimum_character_age = 18
	wage = 15
	outfit_type = /decl/hierarchy/outfit/job/service/bartender
	alt_titles = list("Waiting Staff","Barkeep","Mixologist","Barista" = /decl/hierarchy/outfit/job/service/bartender/barista)


/datum/job/chef
	title = "Chef"
	flag = CHEF
	faction = "City"
	department = "Bar"
	department_flag = CIVILIAN
	total_positions = 2
	spawn_positions = 2
	email_domain = "foodstuffs.nt"
	supervisors = "the city clerk"
	selection_color = "#515151"
	idtype = /obj/item/weapon/card/id/civilian/chef
	access = list(access_hydroponics, access_bar, access_kitchen)
	minimal_access = list(access_kitchen)
	minimum_character_age = 15 //Those kids better serve some good burgers or I'll ask for the manager
	wage = 15
	outfit_type = /decl/hierarchy/outfit/job/service/chef
	alt_titles = list("Restaurant Cashier","Cook","Restaurant Host")

/datum/job/hydro
	title = "Botanist"
	flag = BOTANIST
	faction = "City"
	department_flag = CIVILIAN
	department = "Botany"
	total_positions = 2
	spawn_positions = 1
	supervisors = "the city clerk"
	email_domain = "foodstuffs.nt"
	selection_color = "#515151"
	idtype = /obj/item/weapon/card/id/civilian/botanist
	access = list(access_hydroponics, access_bar, access_kitchen)
	minimal_access = list(access_hydroponics)
	minimum_character_age = 16 //Eh, I can see it happening
	wage = 19
	outfit_type = /decl/hierarchy/outfit/job/service/gardener
	alt_titles = list("Hydroponicist", "Gardener","Farmer")

//Service
/datum/job/janitor
	title = "Sanitation Technician"
	flag = JANITOR
	faction = "City"
	department_flag = CIVILIAN
	department = "Civilian"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the city clerk"
	selection_color = "#515151"
	email_domain = "sanitation.gminus.plux.gov.nt"
	idtype = /obj/item/weapon/card/id/civilian/janitor
	access = list(access_janitor, access_maint_tunnels)
	minimal_access = list(access_janitor, access_maint_tunnels)
	minimum_character_age = 16 //Not making it any younger because being a janitor requires a lot of labor, or maybe it just means I'm very lazy? Oh well
	wage = 18
	outfit_type = /decl/hierarchy/outfit/job/service/janitor
	alt_titles = list("Recycling Technician", "Sanitation Engineer")

//More or less assistants
/datum/job/journalist
	title = "Journalist"
	flag = JOURNALIST
	faction = "City"
	department_flag = CIVILIAN
	department = "Civilian"
	total_positions = 4
	spawn_positions = 1
	supervisors = "the city clerk"
	selection_color = "#515151"
	idtype = /obj/item/weapon/card/id/civilian/journalist
	access = list(access_library, access_maint_tunnels)
	minimal_access = list(access_library)
	minimum_character_age = 16
	wage = 16
	outfit_type = /decl/hierarchy/outfit/job/civilian/journalist
	alt_titles = list("Archivist", "Librarian", "Radio Host")

/datum/job/defense
	title = "Defense Attorney"
	flag = LAWYER
	faction = "City"
	department_flag = CIVILIAN
	department = "Civilian"
	total_positions = 4
	spawn_positions = 1
	supervisors = "the Judge"
	selection_color = "#515151"
	idtype = /obj/item/weapon/card/id/civilian/defense
	wage = 100
	email_domain = "legal.nt"
	req_admin_notify = 1
	access = list(access_lawyer, access_sec_doors, access_maint_tunnels, access_heads)
	minimal_access = list(access_lawyer, access_sec_doors, access_heads)
//	minimal_player_age = 7 (More lawyers please.)
	minimum_character_age = 20
	alt_titles = list("Defense Lawyer","Defense Attorney","Barrister", "Legal Advisor")

	outfit_type = /decl/hierarchy/outfit/job/civilian/defense/defense


/datum/job/barber
	title = "Barber"
	flag = BARBER
	faction = "City"
	department_flag = CIVILIAN
	department = "Civilian"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the city clerk"
	selection_color = "#515151"
	idtype = /obj/item/weapon/card/id/civilian/barber
	minimum_character_age = 16
	access = list(access_barber, access_maint_tunnels)
	minimal_access = list(access_barber)
	wage = 17
	outfit_type = /decl/hierarchy/outfit/job/civilian/barber
	alt_titles = list("Hairdresser", "Stylist", "Beautician")

/datum/job/secretary //Paperwork monkey
	title = "City Hall Secretary"
	flag = SECRETARY
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "City"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Mayor and the City Council"
	selection_color = "#515151"
	idtype = /obj/item/weapon/card/id/civilian/secretary
	wage = 170
	access = list(access_heads, access_hop, access_maint_tunnels)
	minimal_access = list(access_heads, access_hop, access_maint_tunnels)
	email_domain = "gov.nt"

	minimum_character_age = 16
	ideal_character_age = 20 //Really anyone can be this job, not just teens

	alt_titles = list("Junior Clerk", "Assistant Notary", "Paralegal")

	outfit_type = /decl/hierarchy/outfit/job/civilian/secretary

//Cargo
/datum/job/qm
	title = "Factory Manager"
	flag = QUARTERMASTER
	department = "Cargo"
	department_flag = CIVILIAN
	faction = "City"
	head_position = 1
	total_positions = 1
	spawn_positions = 1
	supervisors = "the mayor"
	email_domain = ".aoki.nt"
	selection_color = "#7a4f33"
	idtype = /obj/item/weapon/card/id/cargo/head
	wage = 150
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station, access_heads)
	minimal_access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station)
	minimum_character_age = 20
	ideal_character_age = 35

	outfit_type = /decl/hierarchy/outfit/job/cargo/qm
	alt_titles = list("Supply Chief")

/datum/job/cargo_tech
	title = "Factory Worker"
	flag = CARGOTECH
	faction = "City"
	department = "Cargo"
	department_flag = CIVILIAN
	total_positions = 4
	email_domain = "aoki.nt"
	spawn_positions = 4
	supervisors = "the factory manager"
	selection_color = "#9b633e"
	idtype = /obj/item/weapon/card/id/cargo/cargo_tech
	wage = 20

	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_mining, access_mining_station)
	minimal_access = list(access_maint_tunnels, access_cargo, access_cargo_bot, access_mailsorting)
	minimum_character_age = 13

	outfit_type = /decl/hierarchy/outfit/job/cargo/cargo_tech
	alt_titles = list("Delivery Assistant")

/datum/job/mining
	title = "Miner"
	flag = MINER
	faction = "City"
	department = "Cargo"
	department_flag = CIVILIAN
	total_positions = 3
	spawn_positions = 3
	supervisors = "the factory manager"
	email_domain = "aoki.nt"
	selection_color = "#9b633e"
	idtype = /obj/item/weapon/card/id/cargo/mining
	wage = 20
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_mining, access_mining_station)
	minimal_access = list(access_mining, access_mining_station, access_mailsorting)
	minimum_character_age = 18

	outfit_type = /decl/hierarchy/outfit/job/cargo/mining
	alt_titles = list("Drill Technician","Prospector")
