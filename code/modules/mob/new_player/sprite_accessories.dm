/*

	Hello and welcome to sprite_accessories: For sprite accessories, such as hair,
	facial hair, and possibly tattoos and stuff somewhere along the line. This file is
	intended to be friendly for people with little to no actual coding experience.
	The process of adding in new hairstyles has been made pain-free and easy to do.
	Enjoy! - Doohl


	Notice: This all gets automatically compiled in a list in dna2.dm, so you do not
	have to define any UI values for sprite accessories manually for hair and facial
	hair. Just add in new hair types and the game will naturally adapt.

	!!WARNING!!: changing existing hair information can be VERY hazardous to savefiles,
	to the point where you may completely corrupt a server's savefiles. Please refrain
	from doing this unless you absolutely know what you are doing, and have defined a
	conversion in savefile.dm
*/

/datum/sprite_accessory

	var/icon			// the icon file the accessory is located in
	var/icon_state		// the icon_state of the accessory
	var/preview_state	// a custom preview state for whatever reason

	var/name			// the preview name of the accessory

	// Determines if the accessory will be skipped or included in random hair generations
	var/gender = NEUTER

	// Restrict some styles to specific species
	var/list/species_allowed = list("Human", "Lamia")

	// Whether or not the accessory can be affected by colouration
	var/do_colouration = 1


/*
////////////////////////////
/  =--------------------=  /
/  == Hair Definitions ==  /
/  =--------------------=  /
////////////////////////////
*/

/datum/sprite_accessory/hair

	icon = 'icons/mob/Human_face.dmi'	  // default icon for all hairs
	species_allowed = list("Human","Unathi","Akula", "Lamia")

	bald
		name = "Bald"
		icon_state = "bald"
		gender = MALE
		species_allowed = list("Human","Unathi","Akula","Lamia")

	short
		name = "Short Hair"	  // try to capatilize the names please~
		icon_state = "hair_a" // you do not need to define _s or _l sub-states, game automatically does this for you

	short2
		name = "Short Hair 2"
		icon_state = "hair_shorthair3"

	teshari
		name = "Teshari Default"
		icon_state = "seromi_default"
		species_allowed = list("Teshari")

	teshari_altdefault
		name = "Teshari Alt. Default"
		icon_state = "seromi_ears"
		species_allowed = list("Teshari")

	teshari_tight
		name = "Teshari Tight"
		icon_state = "seromi_tight"
		species_allowed = list("Teshari")

	teshari_excited
		name = "Teshari Spiky"
		icon_state = "seromi_spiky"
		species_allowed = list("Teshari")

	teshari_spike
		name = "Teshari Spike"
		icon_state = "seromi_spike"
		species_allowed = list("Teshari")

	teshari_long
		name = "Teshari Overgrown"
		icon_state = "seromi_long"
		species_allowed = list("Teshari")

	teshari_burst
		name = "Teshari Starburst"
		icon_state = "seromi_burst"
		species_allowed = list("Teshari")

	teshari_shortburst
		name = "Teshari Short Starburst"
		icon_state = "seromi_burst_short"
		species_allowed = list("Teshari")

	teshari_mohawk
		name = "Teshari Mohawk"
		icon_state = "seromi_mohawk"
		species_allowed = list("Teshari")

	cut
		name = "Cut Hair"
		icon_state = "hair_c"

	flair
		name = "Flaired Hair"
		icon_state = "hair_flair"

	long
		name = "Shoulder-length Hair"
		icon_state = "hair_b"

	/*longish
		name = "Longer Hair"
		icon_state = "hair_b2"*/

	longer
		name = "Long Hair"
		icon_state = "hair_vlong"

	longest
		name = "Very Long Hair"
		icon_state = "hair_longest"

	longfringe
		name = "Long Fringe"
		icon_state = "hair_longfringe"

	longestalt
		name = "Longer Fringe"
		icon_state = "hair_vlongfringe"

	halfbang
		name = "Half-banged Hair"
		icon_state = "hair_halfbang"

	halfbangalt
		name = "Half-banged Hair Alt"
		icon_state = "hair_halfbang_alt"

	ponytail1
		name = "Ponytail 1"
		icon_state = "hair_ponytail"

	ponytail2
		name = "Ponytail 2"
		icon_state = "hair_pa"

	ponytail3
		name = "Ponytail 3"
		icon_state = "hair_ponytail3"

	ponytail4
		name = "Ponytail 4"
		icon_state = "hair_ponytail4"

	ponytail5
		name = "Ponytail 5"
		icon_state = "hair_ponytail5"

	ponytail6
		name = "Ponytail 6"
		icon_state = "hair_ponytail6"

	fringetail
		name = "Fringetail"
		icon_state = "hair_fringetail"

	sideponytail
		name = "Side Ponytail"
		icon_state = "hair_stail"

	sideponytail4 //Not happy about this... but it's for the save files.
		name = "Side Ponytail 2"
		icon_state = "hair_ponytailf"

	sideponytail2
		name = "One Shoulder"
		icon_state = "hair_oneshoulder"

	sideponytail3
		name = "Tress Shoulder"
		icon_state = "hair_tressshoulder"

	wisp
		name = "Wisp"
		icon_state = "hair_wisp"

	parted
		name = "Parted"
		icon_state = "hair_parted"

	pompadour
		name = "Pompadour"
		icon_state = "hair_pompadour"

	sleeze
		name = "Sleeze"
		icon_state = "hair_sleeze"

	quiff
		name = "Quiff"
		icon_state = "hair_quiff"

	bedhead
		name = "Bedhead"
		icon_state = "hair_bedhead"

	bedhead2
		name = "Bedhead 2"
		icon_state = "hair_bedheadv2"

	bedhead3
		name = "Bedhead 3"
		icon_state = "hair_bedheadv3"

	beehive
		name = "Beehive"
		icon_state = "hair_beehive"

	beehive2
		name = "Beehive 2"
		icon_state = "hair_beehive2"

	bobcurl
		name = "Bobcurl"
		icon_state = "hair_bobcurl"
		species_allowed = list("Human","Unathi","Akula","Lamia")

	bob
		name = "Bob"
		icon_state = "hair_bobcut"
		species_allowed = list("Human","Unathi","Akula","Lamia")

	bun
		name = "Bun"
		icon_state = "hair_bun"

	bun2
		name = "Bun 2"
		icon_state = "hair_bun2"

	bun3
		name = "Bun 3"
		icon_state = "hair_bun3"

	bowl
		name = "Bowl"
		icon_state = "hair_bowlcut"

	buzz
		name = "Buzzcut"
		icon_state = "hair_buzzcut"
		species_allowed = list("Human","Unathi","Akula","Lamia")

	crew
		name = "Crewcut"
		icon_state = "hair_crewcut"

	combover
		name = "Combover"
		icon_state = "hair_combover"

	father
		name = "Father"
		icon_state = "hair_father"

	reversemohawk
		name = "Reverse Mohawk"
		icon_state = "hair_reversemohawk"

	devillock
		name = "Devil Lock"
		icon_state = "hair_devilock"

	dreadlocks
		name = "Dreadlocks"
		icon_state = "hair_dreads"

	curls
		name = "Curls"
		icon_state = "hair_curls"

	afro
		name = "Afro"
		icon_state = "hair_afro"

	afro2
		name = "Afro 2"
		icon_state = "hair_afro2"

	afro_large
		name = "Big Afro"
		icon_state = "hair_bigafro"

	rows
		name = "Rows"
		icon_state = "hair_rows1"

	rows2
		name = "Rows 2"
		icon_state = "hair_rows2"

	sargeant
		name = "Flat Top"
		icon_state = "hair_sargeant"

	emo
		name = "Emo"
		icon_state = "hair_emo"

	longemo
		name = "Long Emo"
		icon_state = "hair_emolong"

	fringeemo
		name = "Emo Fringe"
		icon_state = "hair_emofringe"

	veryshortovereyealternate
		name = "Overeye Very Short, Alternate"
		icon_state = "hair_veryshortovereyealternate"

	veryshortovereye
		name = "Overeye Very Short"
		icon_state = "hair_veryshortovereye"

	shortovereye
		name = "Overeye Short"
		icon_state = "hair_shortovereye"

	longovereye
		name = "Overeye Long"
		icon_state = "hair_longovereye"

	fag
		name = "Flow Hair"
		icon_state = "hair_f"

	feather
		name = "Feather"
		icon_state = "hair_feather"

	hitop
		name = "Hitop"
		icon_state = "hair_hitop"

	mohawk
		name = "Mohawk"
		icon_state = "hair_d"
		species_allowed = list("Human","Unathi","Akula","Lamia")

	jensen
		name = "Adam Jensen Hair"
		icon_state = "hair_jensen"

	gelled
		name = "Gelled Back"
		icon_state = "hair_gelled"

	gentle
		name = "Gentle"
		icon_state = "hair_gentle"

	spiky
		name = "Spiky"
		icon_state = "hair_spikey"
		species_allowed = list("Human","Unathi","Akula","Lamia")

	kusangi
		name = "Kusanagi Hair"
		icon_state = "hair_kusanagi"

	kagami
		name = "Pigtails"
		icon_state = "hair_kagami"

	himecut
		name = "Hime Cut"
		icon_state = "hair_himecut"

	braid
		name = "Floorlength Braid"
		icon_state = "bald" //Trust me, it's better this way.

	mbraid
		name = "Medium Braid"
		icon_state = "hair_shortbraid"

	braid2
		name = "Long Braid"
		icon_state = "hair_hbraid"

	odango
		name = "Odango"
		icon_state = "hair_odango"

	ombre
		name = "Ombre"
		icon_state = "hair_ombre"

	updo
		name = "Updo"
		icon_state = "hair_updo"

	skinhead
		name = "Skinhead"
		icon_state = "hair_skinhead"

	balding
		name = "Balding Hair"
		icon_state = "hair_e"
		gender = MALE // turnoff!

	familyman
		name = "The Family Man"
		icon_state = "hair_thefamilyman"

	mahdrills
		name = "Drillruru"
		icon_state = "hair_drillruru"

	dandypomp
		name = "Dandy Pompadour"
		icon_state = "hair_dandypompadour"

	poofy
		name = "Poofy"
		icon_state = "hair_poofy"

	crono
		name = "Chrono"
		icon_state = "hair_toriyama"

	vegeta
		name = "Vegeta"
		icon_state = "hair_toriyama2"

	cia
		name = "CIA"
		icon_state = "hair_cia"

	mulder
		name = "Mulder"
		icon_state = "hair_mulder"

	scully
		name = "Scully"
		icon_state = "hair_scully"

	nitori
		name = "Nitori"
		icon_state = "hair_nitori"

	joestar
		name = "Joestar"
		icon_state = "hair_joestar"

	volaju
		name = "Volaju"
		icon_state = "hair_volaju"

	eighties
		name = "80's"
		icon_state = "hair_80s"

	nia
		name = "Nia"
		icon_state = "hair_nia"

	unkept
		name = "Unkept"
		icon_state = "hair_unkept"

	modern
		name = "Modern"
		icon_state = "hair_modern"

	bald
		name = "Bald"
		icon_state = "bald"

	longeralt2
		name = "Long Hair Alt 2"
		icon_state = "hair_longeralt2"

	shortbangs
		name = "Short Bangs"
		icon_state = "hair_shortbangs"

	halfshaved
		name = "Half-Shaved Emo"
		icon_state = "hair_halfshaved"

	bun
		name = "Casual Bun"
		icon_state = "hair_bun"

	doublebun
		name = "Double-Bun"
		icon_state = "hair_doublebun"


/*
///////////////////////////////////
/  =---------------------------=  /
/  == Facial Hair Definitions ==  /
/  =---------------------------=  /
///////////////////////////////////
*/

/datum/sprite_accessory/facial_hair

	icon = 'icons/mob/Human_face.dmi'
	gender = MALE // barf (unless you're a dorf, dorfs dig chix /w beards :P)

	shaved
		name = "Shaved"
		icon_state = "bald"
		gender = NEUTER
		species_allowed = list("Human","Unathi","Tajara","Skrell", "Machine","Teshari","Akula","Lamia")

	teshari_beard
		name = "Teshari Beard"
		icon_state = "seromi_chin"
		species_allowed = list("Teshari")
		gender = NEUTER

	teshari_scraggly
		name = "Teshari Scraggly"
		icon_state = "seromi_scraggly"
		species_allowed = list("Teshari")
		gender = NEUTER

	teshari_chops
		name = "Teshari Chops"
		icon_state = "seromi_gap"
		species_allowed = list("Teshari")
		gender = NEUTER

	watson
		name = "Watson Mustache"
		icon_state = "facial_watson"

	hogan
		name = "Hulk Hogan Mustache"
		icon_state = "facial_hogan" //-Neek

	vandyke
		name = "Van Dyke Mustache"
		icon_state = "facial_vandyke"

	chaplin
		name = "Square Mustache"
		icon_state = "facial_chaplin"

	selleck
		name = "Selleck Mustache"
		icon_state = "facial_selleck"

	neckbeard
		name = "Neckbeard"
		icon_state = "facial_neckbeard"

	fullbeard
		name = "Full Beard"
		icon_state = "facial_fullbeard"

	longbeard
		name = "Long Beard"
		icon_state = "facial_longbeard"

	vlongbeard
		name = "Very Long Beard"
		icon_state = "facial_wise"

	elvis
		name = "Elvis Sideburns"
		icon_state = "facial_elvis"
		species_allowed = list("Human","Unathi","Akula","Lamia")

	abe
		name = "Abraham Lincoln Beard"
		icon_state = "facial_abe"

	chinstrap
		name = "Chinstrap"
		icon_state = "facial_chin"

	hip
		name = "Hipster Beard"
		icon_state = "facial_hip"

	gt
		name = "Goatee"
		icon_state = "facial_gt"

	jensen
		name = "Adam Jensen Beard"
		icon_state = "facial_jensen"

	volaju
		name = "Volaju"
		icon_state = "facial_volaju"

	dwarf
		name = "Dwarf Beard"
		icon_state = "facial_dwarf"

/*
///////////////////////////////////
/  =---------------------------=  /
/  == Alien Style Definitions ==  /
/  =---------------------------=  /
///////////////////////////////////
*/

/datum/sprite_accessory/hair
	una_spines_long
		name = "Long Unathi Spines"
		icon_state = "soghun_longspines"
		species_allowed = list("Unathi")

	una_spines_short
		name = "Short Unathi Spines"
		icon_state = "soghun_shortspines"
		species_allowed = list("Unathi")

	una_frills_long
		name = "Long Unathi Frills"
		icon_state = "soghun_longfrills"
		species_allowed = list("Unathi")

	una_frills_short
		name = "Short Unathi Frills"
		icon_state = "soghun_shortfrills"
		species_allowed = list("Unathi")

	una_horns
		name = "Unathi Horns"
		icon_state = "soghun_horns"
		species_allowed = list("Unathi")

	skr_tentacle_m
		name = "Skrell Male Tentacles"
		icon_state = "skrell_hair_m"
		species_allowed = list("Skrell")
		gender = MALE

	skr_tentacle_f
		name = "Skrell Female Tentacles"
		icon_state = "skrell_hair_f"
		species_allowed = list("Skrell")
		gender = FEMALE

	taj_ears
		name = "Tajaran Ears"
		icon_state = "ears_plain"
		species_allowed = list("Tajara")

	taj_ears_clean
		name = "Tajara Clean"
		icon_state = "hair_clean"
		species_allowed = list("Tajara")

	taj_ears_bangs
		name = "Tajara Bangs"
		icon_state = "hair_bangs"
		species_allowed = list("Tajara")

	taj_ears_braid
		name = "Tajara Braid"
		icon_state = "hair_tbraid"
		species_allowed = list("Tajara")

	taj_ears_shaggy
		name = "Tajara Shaggy"
		icon_state = "hair_shaggy"
		species_allowed = list("Tajara")

	taj_ears_mohawk
		name = "Tajaran Mohawk"
		icon_state = "hair_mohawk"
		species_allowed = list("Tajara")

	taj_ears_plait
		name = "Tajara Plait"
		icon_state = "hair_plait"
		species_allowed = list("Tajara")

	taj_ears_straight
		name = "Tajara Straight"
		icon_state = "hair_straight"
		species_allowed = list("Tajara")

	taj_ears_long
		name = "Tajara Long"
		icon_state = "hair_long"
		species_allowed = list("Tajara")

	taj_ears_rattail
		name = "Tajara Rat Tail"
		icon_state = "hair_rattail"
		species_allowed = list("Tajara")

	taj_ears_spiky
		name = "Tajara Spiky"
		icon_state = "hair_tajspiky"
		species_allowed = list("Tajara")

	taj_ears_messy
		name = "Tajara Messy"
		icon_state = "hair_messy"
		species_allowed = list("Tajara")

/datum/sprite_accessory/facial_hair

	taj_sideburns
		name = "Tajara Sideburns"
		icon_state = "facial_sideburns"
		species_allowed = list("Tajara")

	taj_mutton
		name = "Tajara Mutton"
		icon_state = "facial_mutton"
		species_allowed = list("Tajara")

	taj_pencilstache
		name = "Tajara Pencilstache"
		icon_state = "facial_pencilstache"
		species_allowed = list("Tajara")

	taj_moustache
		name = "Tajara Moustache"
		icon_state = "facial_moustache"
		species_allowed = list("Tajara")

	taj_goatee
		name = "Tajara Goatee"
		icon_state = "facial_goatee"
		species_allowed = list("Tajara")

	taj_smallstache
		name = "Tajara Smallsatche"
		icon_state = "facial_smallstache"
		species_allowed = list("Tajara")

//skin styles - WIP
//going to have to re-integrate this with surgery
//let the icon_state hold an icon preview for now
/datum/sprite_accessory/skin
	icon = 'icons/mob/human_races/r_human.dmi'

	human
		name = "Default human skin"
		icon_state = "default"
		species_allowed = list("Human")

	human_tatt01
		name = "Tatt01 human skin"
		icon_state = "tatt1"
		species_allowed = list("Human")

	tajaran
		name = "Default tajaran skin"
		icon_state = "default"
		icon = 'icons/mob/human_races/r_tajaran.dmi'
		species_allowed = list("Tajara")

	unathi
		name = "Default Unathi skin"
		icon_state = "default"
		icon = 'icons/mob/human_races/r_lizard.dmi'
		species_allowed = list("Unathi")

	skrell
		name = "Default skrell skin"
		icon_state = "default"
		icon = 'icons/mob/human_races/r_skrell.dmi'
		species_allowed = list("Skrell")

	akula
		name = "Default Akula skin"
		icon_state = "default"
		icon = 'icons/mob/human_races/r_shark.dmi'
		species_allowed = list("Akula")


/*
/////////////////////////////
/  =---------------------=  /
/  == Dicks Definitions ==  /
/  =---------------------=  /
/////////////////////////////
*/

/datum/sprite_accessory/dicks
	icon = 'icons/mob/human_races/extras/dicks.dmi'
	species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia")

	dik_none
		name = "None"
		icon = null
		icon_state = null
		species_allowed = list("Human","Unathi","Tajara","Skrell","Vox","Machine","Akula","Lamia")

	dik_normal
		name = "Normal Dick"
		icon_state = "normal"

	dik_circumcised
		name = "Circumcised Dick"
		icon_state = "cut"

	dik_big
		name = "Big Dick"
		icon_state = "big"

	dik_big2
		name = "Bigger Dick"
		icon_state = "big2"

	dik_small
		name = "Small Dick"
		icon_state = "small"

	dik_knotted
		name = "Knotted Dick"
		icon_state = "knotted"

	dik_feline
		name = "Feline Dick"
		icon_state = "feline"

	dik_tentacle
		name = "Tentacle Dicks"
		icon_state = "tentacle"

	dik_tentacle2
		name = "Tentacle Big Dicks"
		icon_state = "tentacle_big"

	dik_amputed
		name = "Amputed Dick"
		icon_state = "amputed"
		do_colouration = 0

/*
//////////////////////////////
/  =----------------------=  /
/  == Vagina Definitions ==  /
/  =----------------------=  /
//////////////////////////////
*/

/datum/sprite_accessory/vaginas
	icon = 'icons/mob/human_races/extras/vaginas.dmi'
	species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia")

	vag_none
		name = "None"
		icon = null
		icon_state = null
		species_allowed = list("Human","Unathi","Tajara","Skrell","Vox","Machine","Akula","Lamia")

	vag_normal
		name = "Normal Vagina"
		icon_state = "normal"

	vag_gaping
		name = "Gaping Vagina"
		icon_state = "gaping"

	vag_dripping
		name = "Dripping Vagina"
		icon_state = "dripping"

	vag_tentacle
		name = "Tentacle Vagina"
		icon_state = "tentacles"

	vag_dentata
		name = "Vagina Dentata"
		icon_state = "dentata"
		do_colouration = 0

/*
///////////////////////////////
/  =-----------------------=  /
/  == Breasts Definitions ==  /
/  =-----------------------=  /
///////////////////////////////
*/

/datum/sprite_accessory/breasts
	icon = 'icons/mob/human_races/extras/breasts.dmi'
	species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia")

	brt_none
		name = "None"
		icon = null
		icon_state = null
		species_allowed = list("Human","Unathi","Tajara","Skrell","Vox","Machine","Akula","Lamia")

	brt_normala
		name = "Tiny Breasts"
		icon_state = "normal_a"

	brt_normalb
		name = "Small Breasts"
		icon_state = "normal_b"

	brt_normalc
		name = "Normal Breasts"
		icon_state = "normal_c"

	brt_normald
		name = "Big Breasts"
		icon_state = "normal_d"

	brt_normale
		name = "Very Big Breasts"
		icon_state = "normal_e"


/*
///////////////////////////////
/  =-----------------------=  /
/  == Ears	  Definitions ==  /
/  =-----------------------=  /
///////////////////////////////
*/

/datum/sprite_accessory/ears
	icon = 'icons/mob/human_races/extras/ears.dmi'
	species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia")

	ear_none
		name = "None"
		icon = null
		icon_state = null
		species_allowed = list("Human","Unathi","Tajara","Skrell","Vox","Machine","Akula","Lamia")

	ear_bear
		name = "Bear Ears"
		icon_state = "bear"

	ear_bee
		name = "Bee Antenae"
		icon_state = "bee"
		do_colouration = 0

	ear_bee_c
		name = "Bee Antenae (Colorable)"
		icon_state = "bee_c"

	ear_bunny
		name = "Bunny Ears"
		icon_state = "bunny"

	ear_cat
		name = "Cat Ears"
		icon_state = "kitty"

	ear_deathclaw
		name = "Deathclaw Ears"
		icon_state = "deathclaw"
		do_colouration = 0

	ear_deathclaw_c
		name = "Deathclaw Ears (Colorable)"
		icon_state = "deathclaw_c"

	ear_horn_oni
		name = "Oni Horns"
		icon_state = "horns_oni"

	ear_horn_demon
		name = "Demon Horns"
		icon_state = "horns_demon"

	ear_horn_curled
		name = "Curled Horns"
		icon_state = "horns_curled"

	ear_horn_ram
		name = "Ram Horns"
		icon_state = "horns_ram"

	ear_horn_curled
		name = "Short Horns"
		icon_state = "horns_short"

	ear_kitsune_colour
		name = "Kitsune Ears"
		icon_state = "kitsune"

	ear_mouse
		name = "Mouse Ears"
		icon_state = "mouse"

	ear_squirrel
		name = "Squirrel Ears"
		icon_state = "squirrel"

	ear_wolf
		name = "Wolf Ears"
		icon_state = "wolf"

	ear_dog
		name = "Dog Ears"		// Citadel
		icon_state = "lab"

	ear_cow
		name = "Cow Ears + Horns"		// Citadel
		icon_state = "cow"

	ear_lop
		name = "Lop Bunny Ears"		// Citadel
		icon_state = "lop"

	ear_angler
		name = "Angler Lure"		// /tg/
		icon_state = "angler"

	ear_deer1
		name = "Deer Ears"		// Citadel
		icon_state = "deer1"

	ear_deer2
		name = "Deer Ears + Antlers"		// Citadel
		icon_state = "deer2"

	ear_antlers
		name = "Antlers (Brown)"		// Citadel
		icon_state = "antlers"
		do_colouration = 0

	ear_antlers_c
		name = "Antlers (Colorable)"		// Citadel
		icon_state = "antlers_c"

/*
///////////////////////////////
/  =-----------------------=  /
/  == Wings	  Definitions ==  /
/  =-----------------------=  /
///////////////////////////////
*/

/datum/sprite_accessory/wings
	icon = 'icons/mob/human_races/extras/wings.dmi'
	species_allowed = list("Human","Unathi","Tajara","Skrell","Akula","Lamia")

	wng_none
		name = "None"
		icon = null
		icon_state = null
		species_allowed = list("Human","Unathi","Tajara","Skrell","Vox","Machine","Akula","Lamia")

	wng_angel
		name = "Angel Wings"
		icon_state = "angel"

	wng_bee
		name = "Bee Wings"
		icon_state = "bee"

	wng_bee
		name = "Bee Wings (Uncolored)"
		icon_state = "bee"
		do_colouration = 0

	wng_bat
		name = "Bat Wings"
		icon_state = "bat"

	wng_feathered
		name = "Feathered Wings"
		icon_state = "feathered"

	wng_succubus
		name = "Succubus Wings"
		icon_state = "succubus"

	wng_smallfairy
		name = "Small Fairy Wings"		// /vg/
		icon_state = "smallfairy"

	wng_turtle
		name = "Turtle Shell"		// Citadel
		icon_state = "turtle"

	wng_tentacles
		name = "Back Tentacles"		// Citadel
		icon_state = "tentacle"

	wng_deathclawspines
		name = "Deathclaw Spines"
		icon_state = "deathclawspines"


/*
///////////////////////////////
/  =-----------------------=  /
/  == Tails	  Definitions ==  /
/  =-----------------------=  /
///////////////////////////////
*/

/datum/sprite_accessory/tails
	icon = 'icons/mob/human_races/extras/tails.dmi'
	species_allowed = list("Human","Unathi","Tajara","Skrell","Akula")

	tal_none
		name = "None"
		icon = null
		icon_state = null
		species_allowed = list("Human","Unathi","Tajara","Skrell","Vox","Machine","Akula")

	tal_bunny
		name = "Bunny Tail"
		icon_state = "bunny"

	tal_bear
		name = "Bear Tail"
		icon_state = "bear"

	tal_cat_down
		name = "Cat Tail, Down"
		icon_state = "kittydown"

	tal_cat_up
		name = "Cat Tail, Up"
		icon_state = "kittyup"

	tal_fox_cross
		name = "Fox Tail, Cross"
		icon_state = "crossfox"

	tal_mouse
		name = "Mouse Tail"
		icon_state = "mouse"
		do_colouration = 0

	tal_mouse_c
		name = "Mouse Tail (Colorable)"
		icon_state = "mouse_c"

	tal_deathclaw
		name = "Deathclaw Tail"
		icon_state = "deathclaw"
		do_colouration = 0

	tal_deathclaw_c
		name = "Deathclaw Tail (Colorable)"
		icon_state = "deathclaw_c"

	tal_kitsune
		name = "Kitsune Tails"
		icon_state = "kitsune"

	tal_squirrel
		name = "Squirrel Tail"
		icon_state = "squirrel"

	tal_tiger
		name = "Tiger Tail"
		icon_state = "tiger"

	tal_tiger_striped
		name = "Tiger Tail, Striped"
		icon_state = "stripeytiger"

	tal_wolf
		name = "Wolf Tail"
		icon_state = "wolf"

	tal_fox
		name = "Fox Tail"
		icon_state = "fox"

	tal_xeno
		name = "Xenomorph Tail"
		icon_state = "xeno"
		do_colouration = 0

	tal_xeno_c
		name = "Xenomorph Tail (Colorable)"
		icon_state = "xeno_c"

	tal_dog
		name = "Dog Tail"
		icon_state = "corgi"

	tal_tajara
		name = "Tajara Tail"
		icon_state = "tajara"

	tal_lizard
		name = "Unathi Tail"
		icon_state = "unathi"

	tal_sharktail
		name = "Akula Tail"
		icon_state = "sharktail"

	tal_succubus
		name = "Succubus Tail"
		icon_state = "succubus"

	tal_bee
		name = "Bee Stinger"
		icon_state = "bee"

	tal_feathers
		name = "Feathers"		// Citadel
		icon_state = "feathers"

	tal_cow
		name = "Cow Tail"		// Citadel
		icon_state = "cow"

	tal_deer
		name = "Deer Tail"		// Citadel
		icon_state = "deer"
