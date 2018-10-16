/datum/access
	var/id = 0
	var/desc = ""
	var/region = ACCESS_REGION_NONE
	var/access_type = ACCESS_TYPE_STATION

/datum/access/dd_SortValue()
	return "[access_type][desc]"

/*****************
* Station access *
*****************/
#define ACCESS_SECURITY		1
/datum/access/security
	id = access_security
	desc = "Security Equipment"
	region = ACCESS_REGION_SECURITY

#define ACCESS_BRIG		2 // Brig timers and permabrig
/datum/access/holding
	id = access_brig
	desc = "Holding Cells"
	region = ACCESS_REGION_SECURITY

#define ACCESS_ARMORY		3
/datum/access/armory
	id = access_armory
	desc = "Armory"
	region = ACCESS_REGION_SECURITY

#define ACCESS_FORENSICS_LOCKERS		4
/datum/access/forensics_lockers
	id = access_forensics_lockers
	desc = "Forensics"
	region = ACCESS_REGION_SECURITY

#define ACCESS_MEDICAL		5
/datum/access/medical
	id = access_medical
	desc = "Medical"
	region = ACCESS_REGION_MEDBAY

#define ACCESS_MORGUE		6
/datum/access/morgue
	id = access_morgue
	desc = "Morgue"
	region = ACCESS_REGION_MEDBAY

#define ACCESS_TOX		7
/datum/access/tox
	id = access_tox
	desc = "R&D Lab"
	region = ACCESS_REGION_RESEARCH

#define ACCESS_TOX_STORAGE		8
/datum/access/tox_storage
	id = access_tox_storage
	desc = "Toxins Lab"
	region = ACCESS_REGION_RESEARCH

#define ACCESS_GENETICS		9
/datum/access/genetics
	id = access_genetics
	desc = "Genetics Lab"
	region = ACCESS_REGION_MEDBAY

#define ACCESS_ENGINE		10
/datum/access/engine
	id = access_engine
	desc = "Engineering"
	region = ACCESS_REGION_ENGINEERING

#define ACCESS_ENGINE_EQUIP		11
/datum/access/engine_equip
	id = access_engine_equip
	desc = "Engine Room"
	region = ACCESS_REGION_ENGINEERING

#define ACCESS_MAINT_TUNNELS		12
/datum/access/maint_tunnels
	id = access_maint_tunnels
	desc = "Maintenance"
	region = ACCESS_REGION_ENGINEERING

#define ACCESS_EXTERNAL_AIRLOCKS		13
/datum/access/external_airlocks
	id = access_external_airlocks
	desc = "External Airlocks"
	region = ACCESS_REGION_ENGINEERING

#define ACCESS_EMERGENCY_STORAGE		14
/datum/access/emergency_storage
	id = access_emergency_storage
	desc = "Emergency Storage"
	region = ACCESS_REGION_ENGINEERING

#define ACCESS_CHANGE_IDS		15
/datum/access/change_ids
	id = access_change_ids
	desc = "ID Computer"
	region = ACCESS_REGION_COMMAND

#define ACCESS_AI_UPLOAD		16
/datum/access/ai_upload
	id = access_ai_upload
	desc = "AI Upload"
	region = ACCESS_REGION_COMMAND

#define ACCESS_TELEPORTER		17
/datum/access/teleporter
	id = access_teleporter
	desc = "Teleporter"
	region = ACCESS_REGION_COMMAND

#define ACCESS_EVA		18
/datum/access/eva
	id = access_eva
	desc = "EVA"
	region = ACCESS_REGION_COMMAND

#define ACCESS_HEADS		19
/datum/access/heads
	id = access_heads
	desc = "Bridge"
	region = ACCESS_REGION_COMMAND

#define ACCESS_CAPTAIN		20
/datum/access/captain
	id = access_captain
	desc = "Colony Director"
	region = ACCESS_REGION_COMMAND

#define ACCESS_ALL_PERSONAL_LOCKERS		21
/datum/access/all_personal_lockers
	id = access_all_personal_lockers
	desc = "Personal Lockers"
	region = ACCESS_REGION_COMMAND

#define ACCESS_CHAPEL_OFFICE		22
/datum/access/chapel_office
	id = access_chapel_office
	desc = "Chapel Office"
	region = ACCESS_REGION_GENERAL

#define ACCESS_TECH_STORAGE		23
/datum/access/tech_storage
	id = access_tech_storage
	desc = "Technical Storage"
	region = ACCESS_REGION_ENGINEERING

#define ACCESS_ATMOSPHERICS		24
/datum/access/atmospherics
	id = access_atmospherics
	desc = "Atmospherics"
	region = ACCESS_REGION_ENGINEERING

#define ACCESS_BAR		25
/datum/access/bar
	id = access_bar
	desc = "Bar"
	region = ACCESS_REGION_GENERAL

#define ACCESS_JANITOR		26
/datum/access/janitor
	id = access_janitor
	desc = "Custodial Closet"
	region = ACCESS_REGION_GENERAL

#define ACCESS_CREMATORIUM		27
/datum/access/crematorium
	id = access_crematorium
	desc = "Crematorium"
	region = ACCESS_REGION_GENERAL

#define ACCESS_KITCHEN		28
/datum/access/kitchen
	id = access_kitchen
	desc = "Kitchen"
	region = ACCESS_REGION_GENERAL

#define ACCESS_ROBOTICS		29
/datum/access/robotics
	id = access_robotics
	desc = "Robotics"
	region = ACCESS_REGION_RESEARCH

#define ACCESS_RD		30
/datum/access/rd
	id = access_rd
	desc = "Research Director"
	region = ACCESS_REGION_RESEARCH

#define ACCESS_CARGO		31
/datum/access/cargo
	id = access_cargo
	desc = "Cargo Bay"
	region = ACCESS_REGION_SUPPLY

#define ACCESS_CONSTRUCTION		32
/datum/access/construction
	id = access_construction
	desc = "Construction Areas"
	region = ACCESS_REGION_ENGINEERING

#define ACCESS_CHEMISTRY		33
/datum/access/chemistry
	id = access_chemistry
	desc = "Chemistry Lab"
	region = ACCESS_REGION_MEDBAY

#define ACCESS_CARGO_BOT		34
/datum/access/cargo_bot
	id = access_cargo_bot
	desc = "Cargo Bot Delivery"
	region = ACCESS_REGION_SUPPLY

#define ACCESS_HYDROPONICS		35
/datum/access/hydroponics
	id = access_hydroponics
	desc = "Hydroponics"
	region = ACCESS_REGION_GENERAL

#define ACCESS_MANUFACTURING		36
/datum/access/manufacturing
	id = access_manufacturing
	desc = "Manufacturing"
	access_type = ACCESS_TYPE_NONE

#define ACCESS_LIBRARY		37
/datum/access/library
	id = access_library
	desc = "Library"
	region = ACCESS_REGION_GENERAL

#define ACCESS_LAWYER		38
/datum/access/lawyer
	id = access_lawyer
	desc = "Internal Affairs"
	region = ACCESS_REGION_COMMAND

#define ACCESS_VIROLOGY		39
/datum/access/virology
	id = access_virology
	desc = "Virology"
	region = ACCESS_REGION_MEDBAY

#define ACCESS_CMO		40
/datum/access/cmo
	id = access_cmo
	desc = "Chief Medical Officer"
	region = ACCESS_REGION_COMMAND

#define ACCESS_QM		41
/datum/access/qm
	id = access_qm
	desc = "Quartermaster"
	region = ACCESS_REGION_SUPPLY

// /var/const/free_access_id = 43
// /var/const/free_access_id = 43
// /var/const/free_access_id = 44

#define ACCESS_SURGERY		45
/datum/access/surgery
	id = access_surgery
	desc = "Surgery"
	region = ACCESS_REGION_MEDBAY

// /var/const/free_access_id = 46

#define ACCESS_RESEARCH		47
/datum/access/research
	id = access_research
	desc = "Science"
	region = ACCESS_REGION_RESEARCH

#define ACCESS_MINING		48
/datum/access/mining
	id = access_mining
	desc = "Mining"
	region = ACCESS_REGION_SUPPLY

#define ACCESS_MINING_OFFICE		49
/datum/access/mining_office
	id = access_mining_office
	desc = "Mining Office"
	access_type = ACCESS_TYPE_NONE

#define ACCESS_MAILSORTING		50
/datum/access/mailsorting
	id = access_mailsorting
	desc = "Cargo Office"
	region = ACCESS_REGION_SUPPLY

// /var/const/free_access_id = 51
// /var/const/free_access_id = 52

#define ACCESS_HEADS_VAULT		53
/datum/access/heads_vault
	id = access_heads_vault
	desc = "Main Vault"
	region = ACCESS_REGION_COMMAND

#define ACCESS_MINING_STATION		54
/datum/access/mining_station
	id = access_mining_station
	desc = "Mining EVA"
	region = ACCESS_REGION_SUPPLY

#define ACCESS_XENOBIOLOGY		55
/datum/access/xenobiology
	id = access_xenobiology
	desc = "Xenobiology Lab"
	region = ACCESS_REGION_RESEARCH

#define ACCESS_CE		56
/datum/access/ce
	id = access_ce
	desc = "Chief Engineer"
	region = ACCESS_REGION_ENGINEERING

#define ACCESS_HOP		57
/datum/access/hop
	id = access_hop
	desc = "Head of Personnel"
	region = ACCESS_REGION_COMMAND

#define ACCESS_HOS		58
/datum/access/hos
	id = access_hos
	desc = "Head of Security"
	region = ACCESS_REGION_SECURITY

#define ACCESS_RC_ANNOUNCE		59 //Request console announcements
/datum/access/RC_announce
	id = access_RC_announce
	desc = "RC Announcements"
	region = ACCESS_REGION_COMMAND

#define ACCESS_KEYCARD_AUTH		60 //Used for events which require at least two people to confirm them
/datum/access/keycard_auth
	id = access_keycard_auth
	desc = "Keycode Auth. Device"
	region = ACCESS_REGION_COMMAND

#define ACCESS_TCOMSAT		61 // has access to the entire telecomms satellite / machinery
/datum/access/tcomsat
	id = access_tcomsat
	desc = "Telecommunications"
	region = ACCESS_REGION_COMMAND

#define ACCESS_GATEWAY		62
/datum/access/gateway
	id = access_gateway
	desc = "Gateway"
	region = ACCESS_REGION_COMMAND

#define ACCESS_SEC_DOORS		63 // Security front doors
/datum/access/sec_doors
	id = access_sec_doors
	desc = "Security"
	region = ACCESS_REGION_SECURITY

#define ACCESS_PSYCHIATRIST		64 // Psychiatrist's office
/datum/access/psychiatrist
	id = access_psychiatrist
	desc = "Psychiatrist's Office"
	region = ACCESS_REGION_MEDBAY

#define ACCESS_XENOARCH		65
/datum/access/xenoarch
	id = access_xenoarch
	desc = "Xenoarchaeology"
	region = ACCESS_REGION_RESEARCH

#define ACCESS_MEDICAL_EQUIP		66
/datum/access/medical_equip
	id = access_medical_equip
	desc = "Medical Equipment"
	region = ACCESS_REGION_MEDBAY

/******************
* Central Command *
******************/
#define ACCESS_CENT_GENERAL		101//General facilities.
/datum/access/cent_general
	id = access_cent_general
	desc = "General Facilities"
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_CENT_THUNDER		102//Thunderdome.
/datum/access/cent_thunder
	id = access_cent_thunder
	desc = "Entertainment Facilities"
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_CENT_SPECOPS		103//Special Ops.
/datum/access/cent_specops
	id = access_cent_specops
	desc = "Emergency Response Team Prep"
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_CENT_MEDICAL		104//Medical/Research
/datum/access/cent_medical
	id = access_cent_medical
	desc = "Medical Facilities"
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_CENT_LIVING		105//Living quarters.
/datum/access/cent_living
	id = access_cent_living
	desc = "Dormitories"
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_CENT_STORAGE		106//Generic storage areas.
/datum/access/cent_storage
	id = access_cent_storage
	desc = "Storage"
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_CENT_TELEPORTER		107//Teleporter.
/datum/access/cent_teleporter
	id = access_cent_teleporter
	desc = "Central Command Teleporter"
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_CENT_CREED		108//Creed's office.
/datum/access/cent_creed
	id = access_cent_creed
	desc = "Emergency Response Team Administration"
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_CENT_CAPTAIN		109//Captain's office/ID comp/AI.
/datum/access/cent_captain
	id = access_cent_captain
	desc = "Central Command Administration"
	access_type = ACCESS_TYPE_CENTCOM

/***************
* Antag access *
***************/
#define ACCESS_SYNDICATE		150//General Syndicate Access
/datum/access/syndicate
	id = access_syndicate
	access_type = ACCESS_TYPE_SYNDICATE

/*******
* Misc *
*******/
#define ACCESS_SYNTH		199
/datum/access/synthetic
	id = access_synth
	desc = "Synthetic"
	access_type = ACCESS_TYPE_NONE

#define ACCESS_CRATE_CASH		200
/datum/access/crate_cash
	id = access_crate_cash
	access_type = ACCESS_TYPE_NONE

#define ACCESS_TRADER		160//General Beruang Trader Access
/datum/access/trader
	id = access_trader
	access_type = ACCESS_TYPE_PRIVATE

#define ACCESS_ALIEN		300 // For things like crashed ships.
/datum/access/alien
	id = access_alien
	desc = "#%_^&*@!"
	access_type = ACCESS_TYPE_PRIVATE
