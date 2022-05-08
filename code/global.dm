//#define TESTING

// Items that ask to be called every cycle.
var/global/datum/datacore/data_core = null
var/global/list/machines                 = list()	// ALL Machines, wether processing or not.
var/global/list/processing_machines      = list()	// TODO - Move into SSmachines
var/global/list/processing_power_items   = list()	// TODO - Move into SSmachines
var/global/list/active_diseases          = list()
var/global/list/hud_icon_reference       = list()


var/global/list/global_mutations  = list() // List of hidden mutation things.

var/global/datum/universal_state/universe = new

var/global/list/global_map = null

// Noises made when hit while typing.
var/global/list/hit_appends	= list("-OOF", "-ACK", "-UGH", "-HRNK", "-HURGH", "-GLORF")
var/global/log_path			= "data/logs/" //See world.dm for the full calculated path
var/global/diary				= null
var/global/error_log			= null
var/global/debug_log			= null
var/global/href_logfile		= null
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
var/global/const/game_version	= "Polaris"
var/global/changelog_hash		= ""
var/global/game_year			= (text2num(time2text(world.realtime, "YYYY")) + 552)
var/global/round_progressing = 1

var/global/master_mode       = "extended" // "extended"
var/global/secret_force_mode = "secret"   // if this is anything but "secret", the secret rotation will forceably choose this mode.

var/global/host = null //only here until check @ code\modules\ghosttrap\trap.dm:112 is fixed

var/global/list/jobMax        = list()
var/global/list/bombers       = list()
var/global/list/admin_log     = list()
var/global/list/lastsignalers = list() // Keeps last 100 signals here in format: "[src] used \ref[src] @ location [src.loc]: [freq]/[code]"
var/global/list/lawchanges    = list() // Stores who uploaded laws to which silicon-based lifeform, and what the law was.
var/global/list/reg_dna       = list()

var/global/mouse_respawn_time = 5 // Amount of time that must pass between a player dying as a mouse and repawning as a mouse. In minutes.

var/global/list/monkeystart     = list()
var/global/list/wizardstart     = list()
var/global/list/newplayer_start = list()

//Spawnpoints.
var/global/list/latejoin            = list()
var/global/list/latejoin_gateway    = list()
var/global/list/latejoin_elevator   = list()
var/global/list/latejoin_cryo       = list()
var/global/list/latejoin_cyborg     = list()
var/global/list/latejoin_checkpoint = list()

var/global/list/prisonwarp         = list() // Prisoners go to these
var/global/list/holdingfacility    = list() // Captured people go here
var/global/list/xeno_spawn         = list() // Aliens spawn at at these.
var/global/list/tdome1             = list()
var/global/list/tdome2             = list()
var/global/list/tdomeobserve       = list()
var/global/list/tdomeadmin         = list()
var/global/list/prisonsecuritywarp = list() // Prison security goes to these.
var/global/list/prisonwarped       = list() // List of players already warped.
var/global/list/blobstart          = list()
var/global/list/ninjastart         = list()

var/global/list/cardinal    = list(NORTH, SOUTH, EAST, WEST)
var/global/list/cardinalz   = list(NORTH, SOUTH, EAST, WEST, UP, DOWN)
var/global/list/cornerdirs  = list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
var/global/list/cornerdirsz = list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST, NORTH|UP, EAST|UP, WEST|UP, SOUTH|UP, NORTH|DOWN, EAST|DOWN, WEST|DOWN, SOUTH|DOWN)
var/global/list/alldirs     = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
var/global/list/reverse_dir = list( // reverse_dir[dir] = reverse of dir
	 2,  1,  3,  8, 10,  9, 11,  4,  6,  5,  7, 12, 14, 13, 15, 32, 34, 33, 35, 40, 42,
	41, 43, 36, 38, 37, 39, 44, 46, 45, 47, 16, 18, 17, 19, 24, 26, 25, 27, 20, 22, 21,
	23, 28, 30, 29, 31, 48, 50, 49, 51, 56, 58, 57, 59, 52, 54, 53, 55, 60, 62, 61, 63
)

var/global/datum/configuration/config      = null

var/global/list/combatlog = list()
var/global/list/IClog     = list()
var/global/list/OOClog    = list()
var/global/list/adminlog  = list()

var/global/list/powernets = list()	// TODO - Move into SSmachines

var/global/Debug2 = 0
var/global/datum/debug/debugobj

var/global/datum/moduletypes/mods = new()

var/global/gravity_is_on = 1

var/global/join_motd = null

var/global/datum/metric/metric = new() // Metric datum, used to keep track of the round.

var/global/list/awaydestinations = list() // Away missions. A list of landmarks that the warpgate can take you to.


// For FTP requests. (i.e. downloading runtime logs.)
// However it'd be ok to use for accessing attack logs and such too, which are even laggier.
var/global/fileaccess_timer = 0
var/global/custom_event_msg = null

// Database connections. A connection is established on world creation.
// Ideally, the connection dies when the server restarts (After feedback logging.).
var/global/DBConnection/dbcon     = new() // Feedback    database (New database)
var/global/DBConnection/dbcon_old = new() // /tg/station database (Old database) -- see the files in the SQL folder for information on what goes where.

// Added for Xenoarchaeology, might be useful for other stuff.
var/global/list/alphabet_uppercase = list("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z")


// Used by robots and robot preferences.
var/global/list/robot_module_types = list(
	"Standard", "Engineering", "Surgeon",  "Crisis",
	"Miner",    "Janitor",     "Service",      "Clerical", "Security",
	"Research"
)

// Some scary sounds.
var/global/static/list/scarySounds = list(
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
	'sound/machines/door/old_airlock.ogg',
	'sound/effects/clownstep1.ogg',
	'sound/effects/clownstep2.ogg'
)

// Bomb cap!
var/global/max_explosion_range = 14

// Announcer intercom, because too much stuff creates an intercom for one message then hard del()s it.
var/global/obj/item/radio/intercom/omni/global_announcer = new /obj/item/radio/intercom/omni(null)

var/global/list/station_departments = list("Command", "Medical", "Engineering", "Science", "Security", "Cargo", "Civilian")

//Icons for in-game HUD glasses. Why don't we just share these a little bit?
var/global/static/icon/ingame_hud = icon('icons/mob/hud.dmi')
var/global/static/icon/ingame_hud_med = icon('icons/mob/hud_med.dmi')
var/global/static/icon/buildmode_hud = icon('icons/misc/buildmode.dmi')

//Keyed list for caching icons so you don't need to make them for records, IDs, etc all separately.
//Could be useful for AI impersonation or something at some point?
var/global/static/list/cached_character_icons = list()
