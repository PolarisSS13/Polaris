var/list/clients = list()							//list of all clients
var/list/admins = list()							//list of all clients whom are admins
var/list/directory = list()							//list of all ckeys with associated client

//Since it didn't really belong in any other category, I'm putting this here
//This is for procs to replace all the goddamn 'in world's that are chilling around the code

var/global/list/player_list = list()				//List of all mobs **with clients attached**. Excludes /mob/new_player
var/global/list/mob_list = list()					//List of all mobs, including clientless
var/global/list/human_mob_list = list()				//List of all human mobs and sub-types, including clientless
var/global/list/silicon_mob_list = list()			//List of all silicon mobs, including clientless
var/global/list/living_mob_list = list()			//List of all alive mobs, including clientless. Excludes /mob/new_player
var/global/list/dead_mob_list = list()				//List of all dead mobs, including clientless. Excludes /mob/new_player

var/global/list/cable_list = list()					//Index for all cables, so that powernets don't have to look through the entire world all the time
var/global/list/chemical_reactions_list				//list of all /datum/chemical_reaction datums. Used during chemical reactions
var/global/list/chemical_reagents_list				//list of all /datum/reagent datums indexed by reagent id. Used by chemistry stuff
var/global/list/landmarks_list = list()				//list of all landmarks created
var/global/list/surgery_steps = list()				//list of all surgery steps  |BS12
var/global/list/side_effects = list()				//list of all medical sideeffects types by thier names |BS12
var/global/list/mechas_list = list()				//list of all mechs. Used by hostile mobs target tracking.
var/global/list/joblist = list()					//list of all jobstypes, minus borg and AI

var/global/list/turfs = list()						//list of all turfs

//Languages/species/whitelist.
var/global/list/all_species[0]
var/global/list/all_languages[0]
var/global/list/language_keys[0]					// Table of say codes for all languages
var/global/list/whitelisted_species = list("Human") // Species that require a whitelist check.
var/global/list/playable_species = list("Human")    // A list of ALL playable species, whitelisted, latejoin or otherwise.

// Posters
var/global/list/poster_designs = list()

// Uplinks
var/list/obj/item/device/uplink/world_uplinks = list()

//Preferences stuff
	//Hairstyles
var/global/list/hair_styles_list = list()			//stores /datum/sprite_accessory/hair indexed by name
var/global/list/hair_styles_male_list = list()
var/global/list/hair_styles_female_list = list()
var/global/list/facial_hair_styles_list = list()	//stores /datum/sprite_accessory/facial_hair indexed by name
var/global/list/facial_hair_styles_male_list = list()
var/global/list/facial_hair_styles_female_list = list()
var/global/list/skin_styles_female_list = list()		//unused
	//Underwear
var/global/list/underwear_top_t = list(
	"Bra, Red" = "t1", "Bra, White" = "t2", "Bra, Yellow" = "t3", "Bra, Blue" = "t4", "Bra, Black" = "t5", "Lacy Bra" = "t6", "Sports Bra, Black" = "t7", "Sports Bra, White" = "t8",
	"Sports Bra Alt, Black" = "t9", "Sporta Bra Alt, White" = "t10", "Bra, Baby-Blue" = "t11", "Bra, Green" = "t12", "Bra, Pink" = "t13", "Bra, Violet" = "t14",
	"Lacy Bra Alt" = "t15", "Lacy Bra Alt, Violet" = "t16", "Halterneck Bra, Black" = "t17", "Halterneck Bra, Blue" = "t18", "Halterneck Bra, Green" = "t19", "Halterneck Bra, Purple" = "t20",
	"Halterneck Bra, Red" = "t21", "Halterneck Bra, Teal" = "t22", "Halterneck Bra, Violet" = "t23", "Halterneck Bra, White" = "t24", "None")
var/global/list/underwear_bottom_t = list(
	"Briefs, White" = "b1", "Briefs, Grey" = "b2", "Briefs, Green" = "b3", "Briefs, Blue" = "b4", "Briefs, Black" = "b5", "Boxers, Loveheart" = "b7", "Boxers, Black" = "b8",
	"Boxers, Grey" = "b9", "Boxers, Green & Blue Striped" = "b10", "Panties, Red" = "b11", "Panties, White" = "b12", "Panties, Yellow" = "b13", "Panties, Blue" = "b14",
	"Panties, Light-Black" = "b15", "Thong" = "b16", "Panties, Black" = "b17", "Panties Alt, White" = "b18", "Compression Shorts, Black" = "b19", "Compression Shorts, White" = "b20",
	"Compression Shorts, Baby-Blue" = "b21", "Panties, Green" = "b22", "Compression Shorts, Pink" = "b23", "Thong, Violet" = "b24", "Thong Alt" = "b25", "Thong Alt, Violet" = "b26",
	"Alt Thong, Black" = "b27", "Alt Thong, Blue" = "b28", "Alt Thong, Green" = "b29", "Alt Thong, Purple" = "b30", "Alt Thong, Red" = "b31", "Alt Thong, Teal" = "b32",
	"Alt Thong, Violet" = "b33", "Alt Thong, White" = "b34", "None")
	//undershirt
var/global/list/undershirt_t = list(
	"White tank top" = "u1", "Black tank top" = "u2", "Black shirt" = "u3",
	"White shirt" = "u4", "White shirt 2" = "shirt_white_s", "White tank top 2" = "tank_white_s",
	"Black shirt 2" = "shirt_black_s", "Grey shirt" = "shirt_grey_s", "Heart shirt" = "lover_s",
	"I love NT shirt" = "ilovent_s", "White shortsleeve shirt" = "whiteshortsleeve_s", "Purple shortsleeve shirt" = "purpleshortsleeve_s",
	"Blue shortsleeve shirt" = "blueshortsleeve_s", "Green shortsleeve shirt" = "greenshortsleeve_s", "Black shortsleeve shirt" = "blackshortsleeve_s",
	"Blue shirt" = "blueshirt_s", "Red shirt" = "redshirt_s", "Yellow shirt" = "yellowshirt_s", "Green shirt" = "greenshirt_s",
	"Blue polo shirt" = "bluepolo_s", "Red polo shirt" = "redpolo_s", "White polo shirt" = "whitepolo_s",
	"Grey-yellow polo shirt" = "grayyellowpolo_s", "Fire tank top" = "tank_fire_s", "NT shirt" = "shirt_nano_s",
	"Blue shirt 2" = "shirt_blue_s", "Red shirt 2" = "shirt_red_s", "Red tank top" = "tank_red_s", "Green shirt 2" = "shirt_green_s",
	"Tiedye shirt" = "shirt_tiedye_s", "Green sport shirt" = "greenshirtsport_s", "Red sport shirt" = "redshirtsport_s",
	"Blue striped shirt" = "shirt_stripes_s", "Blue sport shirt" = "blueshirtsport_s", "None")
	//Socks
var/global/list/socks_t = list(
	"White normal" = "white_norm", "White short" = "white_short", "White knee" = "white_knee",
	"White thigh" = "white_thigh", "Black normal" = "black_norm", "Black short" = "black_short",
	"Black knee" = "black_knee", "Black thigh" = "black_thigh", "Thin knee" = "thin_knee",
	"Thin thigh" = "thin_thigh", "Pantyhose" = "pantyhose", "Striped thigh" = "striped_thigh",
	"Striped knee" = "striped_knee", "Rainbow knee" = "rainbow_knee", "Rainbow thigh" = "rainbow_thigh",
	"Fishnets" = "fishnet", "Thin white thigh" = "thinwhite_thigh", "Thin white knee" = "thinwhite_knee",
	"Green striped thigh" = "gstriped_thigh", "Green striped knee" = "gstriped_knee",
	"Purple striped thigh" = "pstriped_thigh", "Purple striped knee" = "pstriped_knee",
	"Blue striped thigh" = "bstriped_thigh", "Blue striped knee" = "bstriped_knee",
	"Yellow striped thigh" = "ystriped_thigh", "Yellow striped knee" = "ystriped_knee",
 	"Red striped thigh" = "rstriped_thigh", "Red striped knee" = "rstriped_knee",
 	"Orange striped thigh" = "ostriped_thigh", "Orange striped knee" = "ostriped_knee", "None")

	//Backpacks
var/global/list/backbaglist = list("Nothing", "Backpack", "Satchel", "Satchel Alt")
var/global/list/pdachoicelist = list("Default", "Slim", "Old")
var/global/list/exclude_jobs = list(/datum/job/ai,/datum/job/cyborg)

// Visual nets
var/list/datum/visualnet/visual_nets = list()
var/datum/visualnet/camera/cameranet = new()
var/datum/visualnet/cult/cultnet = new()

// Runes
var/global/list/rune_list = new()
var/global/list/escape_list = list()
var/global/list/endgame_exits = list()
var/global/list/endgame_safespawns = list()

var/global/list/syndicate_access = list(access_maint_tunnels, access_syndicate, access_external_airlocks)

// Strings which corraspond to bodypart covering flags, useful for outputting what something covers.
var/global/list/string_part_flags = list(
	"head" = HEAD,
	"face" = FACE,
	"eyes" = EYES,
	"upper body" = UPPER_TORSO,
	"lower body" = LOWER_TORSO,
	"legs" = LEGS,
	"feet" = FEET,
	"arms" = ARMS,
	"hands" = HANDS
)

// Strings which corraspond to slot flags, useful for outputting what slot something is.
var/global/list/string_slot_flags = list(
	"back" = SLOT_BACK,
	"face" = SLOT_MASK,
	"waist" = SLOT_BELT,
	"ID slot" = SLOT_ID,
	"ears" = SLOT_EARS,
	"eyes" = SLOT_EYES,
	"hands" = SLOT_GLOVES,
	"head" = SLOT_HEAD,
	"feet" = SLOT_FEET,
	"exo slot" = SLOT_OCLOTHING,
	"body" = SLOT_ICLOTHING,
	"uniform" = SLOT_TIE,
	"holster" = SLOT_HOLSTER
)

//////////////////////////
/////Initial Building/////
//////////////////////////

/proc/makeDatumRefLists()
	var/list/paths

	//Hair - Initialise all /datum/sprite_accessory/hair into an list indexed by hair-style name
	paths = typesof(/datum/sprite_accessory/hair) - /datum/sprite_accessory/hair
	for(var/path in paths)
		var/datum/sprite_accessory/hair/H = new path()
		hair_styles_list[H.name] = H
		switch(H.gender)
			if(MALE)	hair_styles_male_list += H.name
			if(FEMALE)	hair_styles_female_list += H.name
			else
				hair_styles_male_list += H.name
				hair_styles_female_list += H.name

	//Facial Hair - Initialise all /datum/sprite_accessory/facial_hair into an list indexed by facialhair-style name
	paths = typesof(/datum/sprite_accessory/facial_hair) - /datum/sprite_accessory/facial_hair
	for(var/path in paths)
		var/datum/sprite_accessory/facial_hair/H = new path()
		facial_hair_styles_list[H.name] = H
		switch(H.gender)
			if(MALE)	facial_hair_styles_male_list += H.name
			if(FEMALE)	facial_hair_styles_female_list += H.name
			else
				facial_hair_styles_male_list += H.name
				facial_hair_styles_female_list += H.name

	//Surgery Steps - Initialize all /datum/surgery_step into a list
	paths = typesof(/datum/surgery_step)-/datum/surgery_step
	for(var/T in paths)
		var/datum/surgery_step/S = new T
		surgery_steps += S
	sort_surgeries()

	//List of job. I can't believe this was calculated multiple times per tick!
	paths = typesof(/datum/job)-/datum/job
	paths -= exclude_jobs
	for(var/T in paths)
		var/datum/job/J = new T
		joblist[J.title] = J

	//Languages and species.
	paths = typesof(/datum/language)-/datum/language
	for(var/T in paths)
		var/datum/language/L = new T
		all_languages[L.name] = L

	for (var/language_name in all_languages)
		var/datum/language/L = all_languages[language_name]
		if(!(L.flags & NONGLOBAL))
			language_keys[lowertext(L.key)] = L

	var/rkey = 0
	paths = typesof(/datum/species)-/datum/species
	for(var/T in paths)
		rkey++
		var/datum/species/S = new T
		S.race_key = rkey //Used in mob icon caching.
		all_species[S.name] = S

		if(!(S.spawn_flags & IS_RESTRICTED))
			playable_species += S.name
		if(S.spawn_flags & IS_WHITELISTED)
			whitelisted_species += S.name

	//Posters
	paths = typesof(/datum/poster) - /datum/poster
	for(var/T in paths)
		var/datum/poster/P = new T
		poster_designs += P

	return 1

/* // Uncomment to debug chemical reaction list.
/client/verb/debug_chemical_list()

	for (var/reaction in chemical_reactions_list)
		. += "chemical_reactions_list\[\"[reaction]\"\] = \"[chemical_reactions_list[reaction]]\"\n"
		if(islist(chemical_reactions_list[reaction]))
			var/list/L = chemical_reactions_list[reaction]
			for(var/t in L)
				. += "    has: [t]\n"
	world << .
*/
