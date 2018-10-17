//#define TESTING
#if DM_VERSION < 506
#warn This compiler is out of date. You may experience issues with projectile animations.
#endif

// Items that ask to be called every cycle.
GLOBAL_DATUM(data_core, datum/datacore)
GLOBAL_LIST_EMPTY(all_areas)
GLOBAL_LIST_EMPTY(machines)	// ALL Machines, wether processing or not.
GLOBAL_LIST_EMPTY(processing_machines)	// TODO - Move into SSmachines
GLOBAL_LIST_EMPTY(processing_objects)
GLOBAL_LIST_EMPTY(processing_power_items)	// TODO - Move into SSmachines
GLOBAL_LIST_EMPTY(active_diseases)
GLOBAL_LIST_EMPTY(hud_icon_reference)


GLOBAL_LIST_EMPTY(global_mutations) // List of hidden mutation things.

GLOBAL_DATUM_INIT(universe, datum/universal_state, new GLOBAL_LIST(global_map))

// Noises made when hit while typing.
GLOBAL_LIST_INIT(hit_appends, list("-OOF", "-ACK", "-UGH", "-HRNK", "-HURGH", "-GLORF"))
var/log_path			= "data/logs/" //See world.dm for the full calculated path
var/diary				= null
var/error_log			= null
var/debug_log			= null
var/href_logfile		= null
// var/station_name		= "Northern Star"
// var/const/station_orig	= "Northern Star" //station_name can't be const due to event prefix/suffix
// var/const/station_short	= "Northern Star"
// var/const/dock_name		= "Vir Interstellar Spaceport"
// var/const/boss_name		= "Central Command"
// var/const/boss_short	= "CentCom"
// var/const/company_name	= "NanoTrasen"
// var/const/company_short	= "NT"
// var/const/star_name		= "Vir"
// var/const/starsys_name	= "Vir"
#define GAME_VERSION		"POLARIS"
var/changelog_hash		= ""
var/game_year			= (text2num(time2text(world.realtime, "YYYY")) + 544)
GLOBAL_VAR_INIT(round_progressing, 1)
var/master_mode       = "extended" // "extended"
var/secret_force_mode = "secret"   // if this is anything but "secret", the secret rotation will forceably choose this mode.

var/host = null //only here until check @ code\modules\ghosttrap\trap.dm:112 is fixed

GLOBAL_LIST_EMPTY(jobMax)
GLOBAL_LIST_EMPTY(bombers)
GLOBAL_LIST_EMPTY(admin_log)
GLOBAL_LIST_EMPTY(lastsignalers) // Keeps last 100 signals here in format: "[src] used \ref[src] @ location [src.loc]: [freq]/[code]"
GLOBAL_LIST_EMPTY(lawchanges) // Stores who uploaded laws to which silicon-based lifeform, and what the law was.
GLOBAL_LIST_EMPTY(reg_dna)

var/mouse_respawn_time = 5 // Amount of time that must pass between a player dying as a mouse and repawning as a mouse. In minutes.

GLOBAL_LIST_EMPTY(monkeystart)
GLOBAL_LIST_EMPTY(wizardstart)
GLOBAL_LIST_EMPTY(newplayer_start)

//Spawnpoints.
GLOBAL_LIST_EMPTY(latejoin)
GLOBAL_LIST_EMPTY(latejoin_gateway)
GLOBAL_LIST_EMPTY(latejoin_elevator)
GLOBAL_LIST_EMPTY(latejoin_cryo)
GLOBAL_LIST_EMPTY(latejoin_cyborg)

GLOBAL_LIST_EMPTY(prisonwarp) // Prisoners go to these
GLOBAL_LIST_EMPTY(holdingfacility) // Captured people go here
GLOBAL_LIST_EMPTY(xeno_spawn) // Aliens spawn at at these.
GLOBAL_LIST_EMPTY(tdome1)
GLOBAL_LIST_EMPTY(tdome2)
GLOBAL_LIST_EMPTY(tdomeobserve)
GLOBAL_LIST_EMPTY(tdomeadmin)
GLOBAL_LIST_EMPTY(prisonsecuritywarp) // Prison security goes to these.
GLOBAL_LIST_EMPTY(prisonwarped) // List of players already warped.
GLOBAL_LIST_EMPTY(blobstart)
GLOBAL_LIST_EMPTY(ninjastart)

GLOBAL_LIST_INIT(cardinal, list(NORTH, SOUTH, EAST, WEST))
GLOBAL_LIST_INIT(cardinalz, list(NORTH, SOUTH, EAST, WEST, UP, DOWN))
GLOBAL_LIST_INIT(cornerdirs, list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
GLOBAL_LIST_INIT(cornerdirsz, list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST, NORTH|UP, EAST|UP, WEST|UP, SOUTH|UP, NORTH|DOWN, EAST|DOWN, WEST|DOWN, SOUTH|DOWN))
GLOBAL_LIST_INIT(alldirs, list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
GLOBAL_LIST_INIT(reverse_dir, list( // reverse_dir[dir] = reverse of dir
	 2,  1,  3,  8, 10,  9, 11,  4,  6,  5,  7, 12, 14, 13, 15, 32, 34, 33, 35, 40, 42,
	41, 43, 36, 38, 37, 39, 44, 46, 45, 47, 16, 18, 17, 19, 24, 26, 25, 27, 20, 22, 21,
	23, 28, 30, 29, 31, 48, 50, 49, 51, 56, 58, 57, 59, 52, 54, 53, 55, 60, 62, 61, 63
)(

GLOBAL_DATUM(config, datum/configuration)
GLOBAL_DATUM(sun, datum/sun)

GLOBAL_LIST_EMPTY(combatlog)
GLOBAL_LIST_EMPTY(IClog)
GLOBAL_LIST_EMPTY(OOClog)
GLOBAL_LIST_EMPTY(adminlog)

GLOBAL_LIST_EMPTY(powernets)	// TODO - Move into SSmachines

GLOBAL_VAR_INIT(Debug2, 0)
GLOBAL_DATUM(debugobj, /datum/debug)

GLOBAL_DATUM_INIT(mods, datum/moduletypes, new ))

GLOBAL_VAR_INIT(gravity_is_on, 1)
var/join_motd = null

GLOBAL_DATUM_INIT(event_manager, datum/event_manager, new )) // Event Manager, the manager for events.
GLOBAL_DATUM_INIT(game_master, datum/game_master, new )) // Game Master, an AI for choosing events.
GLOBAL_DATUM_INIT(metric, datum/metric, new )) // Metric datum, used to keep track of the round.

GLOBAL_LIST_EMPTY(awaydestinations) // Away missions. A list of landmarks that the warpgate can take you to.

// Forum MySQL configuration. (for use with forum account/key authentication)
// These are all default values that will load should the forumdbconfig.txt file fail to read for whatever reason.
var/forumsqladdress = "localhost"
var/forumsqlport    = "3306"
var/forumsqldb      = "tgstation"
var/forumsqllogin   = "root"
var/forumsqlpass    = ""
var/forum_activated_group     = "2"
var/forum_authenticated_group = "10"

// For FTP requests. (i.e. downloading runtime logs.)
// However it'd be ok to use for accessing attack logs and such too, which are even laggier.
GLOBAL_VAR_INIT(fileaccess_timer, 0)
var/custom_event_msg = null

// Database connections. A connection is established on world creation.
// Ideally, the connection dies when the server restarts (After feedback logging.).
var/DBConnection/dbcon     = new() // Feedback    database (New database)
var/DBConnection/dbcon_old = new() // /tg/station database (Old database) -- see the files in the SQL folder for information on what goes where.

// Reference list for disposal sort junctions. Filled up by sorting junction's New()
GLOBAL_LIST_EMPTY(tagger_locations)

// Added for Xenoarchaeology, might be useful for other stuff.
GLOBAL_LIST_INIT(alphabet_uppercase, list("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"))


// Used by robots and robot preferences.
GLOBAL_LIST_INIT(robot_module_types, list(
	"Standard", "Engineering", "Surgeon",  "Crisis",
	"Miner",    "Janitor",     "Service",      "Clerical", "Security",
	"Research"
))

// Some scary sounds.
GLOBAL_LIST_INIT(scarySounds, list(
	'sound/weapons/thudswoosh.ogg',
	'sound/weapons/Taser.ogg',
	'sound/weapons/armbomb.ogg',
	'sound/voice/hiss1.ogg',
	'sound/voice/hiss2.ogg',
	'sound/voice/hiss3.ogg',
	'sound/voice/hiss4.ogg',
	'sound/voice/hiss5.ogg',
	'sound/voice/hiss6.ogg',
	'sound/effects/Glassbr1.ogg',
	'sound/effects/Glassbr2.ogg',
	'sound/effects/Glassbr3.ogg',
	'sound/items/Welder.ogg',
	'sound/items/Welder2.ogg',
	'sound/machines/airlock.ogg',
	'sound/effects/clownstep1.ogg',
	'sound/effects/clownstep2.ogg'
))

// Bomb cap!
GLOBAL_VAR_INIT(max_explosion_range, 14)
// Announcer intercom, because too much stuff creates an intercom for one message then hard del()s it.
var/global/obj/item/device/radio/intercom/omni/global_announcer = new /obj/item/device/radio/intercom/omni(null)

GLOBAL_LIST_INIT(station_departments, list("Command", "Medical", "Engineering", "Science", "Security", "Cargo", "Civilian"))

//Icons for in-game HUD glasses. Why don't we just share these a little bit?
var/static/icon/ingame_hud = icon('icons/mob/hud.dmi')
var/static/icon/ingame_hud_med = icon('icons/mob/hud_med.dmi')

//Keyed list for caching icons so you don't need to make them for records, IDs, etc all separately.
//Could be useful for AI impersonation or something at some point?
GLOBAL_LIST_EMPTY(cached_character_icons)
