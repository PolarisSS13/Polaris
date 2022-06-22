//Thanks to:
// - https://en.wikipedia.org/wiki/List_of_landforms
// - https://en.wikipedia.org/wiki/Outline_of_classical_architecture

var/global/list/gyne_geoforms = list(
	"abime",         "abyss",         "ait",         "anabranch",    "arc",           "arch",          "archipelago",  "arete",
	"arroyo",        "atoll",         "ayre",        "badlands",     "bar",           "barchan",       "barrier",      "basin",
	"bay",           "bayou",         "beach",       "bight",        "blowhole",      "blowout",       "bluff",        "bornhardt",
	"braid",         "nest",          "calanque",    "caldera",      "canyon"	,     "cape",          "cave",         "cenote",
	"channel",       "cirque",        "cliff",       "coast",        "col",           "colony",        "cone",         "confluence",
	"corrie",        "cove",          "crater",      "crevasse",     "cryovolcano",   "cuesta",        "cusps",        "yardang",
	"dale",          "dam",           "defile",      "dell",         "delta",         "diatreme",      "dike",         "divide",
	"doab",          "doline",        "dome",        "draw",         "dreikanter",    "drumlin",       "dune",         "ejecta",
	"erg",           "escarpment",    "esker",       "estuary",      "fan",           "fault",         "field",        "firth",
	"fissure",       "fjard",         "fjord",       "flat",         "flatiron",      "floodplain",    "foibe",        "foreland",
	"geyser",        "glacier",       "glen",        "gorge",        "graben",        "gulf",          "gully",        "guyot",
	"headland",      "hill",          "hogback",     "hoodoo",       "horn",          "horst",         "inlet",        "interfluve",
	"island",        "islet",         "isthmus",     "kame",         "karst",         "karst",         "kettle",       "kipuka",
	"knoll",         "lagoon",        "lake",        "lavaka",       "levee",         "loess",         "maar",         "machair",
	"malpas",        "mamelon",       "marsh",       "meander",      "mesa",          "mogote",        "monadnock",    "moraine",
	"moulin",        "nunatak",       "oasis",       "outwash",      "pediment",      "pediplain",     "peneplain",    "peninsula",
	"pingo",         "pit"	,         "plain",       "plateau",      "plug",          "polje",         "pond",         "potrero",
	"pseudocrater",  "quarry",        "rapid",       "ravine",       "reef",          "ria",           "ridge",        "riffle",
	"river",         "sandhill",      "sandur",      "scarp",        "scowle",        "scree",         "seamount",     "shelf",
	"shelter",       "shield",        "shoal",       "shore",        "sinkhole",      "sound",         "spine",        "spit",
	"spring",        "spur",          "strait",      "strandflat",   "strath",        "stratovolcano", "stream",       "subglacier",
	"summit",        "supervolcano",  "surge",       "swamp",        "table",         "tepui",         "terrace",      "terracette",
	"thalweg",       "tidepool",      "tombolo",     "tor",          "towhead",       "tube",          "tunnel",       "turlough",
	"tuya",          "uvala",         "vale",        "valley",       "vent",          "ventifact",     "volcano",      "wadi",
	"waterfall",     "watershed"
)

var/global/list/gyne_architecture = list(
	"barrel",        "annular",       "aynali",      "baroque",      "catalan",       "cavetto",       "catenary",     "cloister",
	"corbel",        "cross",         "cycloidal",   "cylindrical",  "diamond",       "domical",       "fan",          "lierne",
	"muqarnas",      "net",           "nubian",      "ogee",         "ogival",        "parabolic",     "hyperbolic",   "volute",
	"quadripartite", "rampant",       "rear",        "rib",          "sail",          "sexpartite",    "shell",        "stalactite",
	"stellar",       "stilted",       "surbased",    "surmounted",   "timbrel",       "tierceron",     "tripartite",   "tunnel",
	"grid",          "acroterion ",   "aedicule",    "apollarium",   "aegis",         "apse",          "arch",         "architrave",
	"archivolt",     "amphiprostyle", "atlas",       "bracket",      "capital",       "caryatid",      "cella",        "colonnade",
	"column",        "cornice",       "crepidoma",   "crocket",      "cupola",        "decastyle",     "dome",         "eisodos",
	"entablature",   "epistyle ",     "euthynteria", "exedra",       "finial",        "frieze",        "gutta",        "imbrex",
	"tegula",        "keystone",      "metope",      "naos",         "nave",          "opisthodomos",  "orthostates",  "pediment",
	"peristyle",     "pilaster",      "plinth",      "portico",      "pronaos",       "prostyle",      "quoin",        "stoa",
	"suspensura",    "term ",         "tracery",     "triglyph",     "sima",          "stylobate",     "unitary",      "sovereign",
	"grand",         "supreme",       "rampant",     "isolated",     "standalone",    "seminal",       "pedagogical",  "locus",
	"figurative",    "abstract",      "aesthetic",   "grandiose",    "kantian",       "pure",          "conserved",    "brutalist",
	"extemporary",   "theological",   "theoretical", "centurion",    "militant",      "eusocial",      "prominent",    "empirical",
	"key",           "civic",         "analytic",    "formal",       "atonal",        "tonal",         "synchronized", "asynchronous",
	"harmonic",      "discordant",    "upraised",    "sunken",       "life",          "order",         "chaos",        "systemic",
	"system",        "machine",       "mechanical",  "digital",      "electrical",    "electronic",    "somatic",      "cognitive",
	"mobile",        "immobile",      "motile",      "immotile",     "environmental", "contextual",    "stratified",   "integrated",
	"ethical",       "micro",         "macro",       "genetic",      "intrinsic",     "extrinsic",     "academic",     "literary",
	"artisan",       "absolute",      "absolutist",  "autonomous",   "collectivist",  "bicameral",     "colonialist",  "federal",
	"imperial",      "independant",   "managed",     "multilateral", "neutral",       "nonaligned",    "parastatal"
)

/datum/language/mantid
	name = LANGUAGE_MANTID_VOCAL
	desc = "A curt, sharp language developed for use over mantid comms."
	speech_verb = "clicks"
	ask_verb = "chirps"
	exclaim_verb = "rasps"
	colour = "alien"
	syllables = list("-","=","+","_","|","/")
	space_chance = 0
	key = "|"
	flags = RESTRICTED
	machine_understands = FALSE
	signlang_verb = list(
		"flashes",
		"gleams",
		"flares"
	)
	var/static/list/correct_mouthbits = list(
		SPECIES_MANTID,
		SPECIES_ZADDAT
	)

/datum/language/mantid/get_random_name(gender, name_count, syllable_count, syllable_divisor)
	return "[random_id(/datum/species/mantid, 10000, 99999)] [capitalize(pick(global.gyne_architecture))] [capitalize(pick(global.gyne_geoforms))]"

/datum/language/mantid/can_be_spoken_properly_by(var/mob/speaker)
	var/mob/living/S = speaker
	if(!istype(S))
		return FALSE
	if(S.isSynthetic())
		return TRUE
	if(ishuman(speaker))
		var/mob/living/carbon/human/H = speaker
		if(H.species.name in correct_mouthbits)
			return TRUE
	return FALSE

/datum/language/mantid/muddle(var/message)
	message = replacetext(message, "...",  ".")
	message = replacetext(message, "!?",   ".")
	message = replacetext(message, "?!",   ".")
	message = replacetext(message, "!",    ".")
	message = replacetext(message, "?",    ".")
	message = replacetext(message, ",",    "")
	message = replacetext(message, ";",    "")
	message = replacetext(message, ":",    "")
	message = replacetext(message, ".",    "...")
	message = replacetext(message, "&#39", "'")
	return message

/datum/language/mantid/broadcast(var/mob/living/speaker,var/message,var/speaker_mask)
	. = ..(speaker, message, speaker.real_name)

/datum/language/mantid/nonvocal
	name = LANGUAGE_MANTID_SIGN
	key = "]"
	desc = "A complex visual language of bright bio-luminescent flashes, 'spoken' natively by the mantids."
	colour = "alien"
	speech_verb = "flashes"
	ask_verb = "gleams"
	exclaim_verb = "flares"
	flags = RESTRICTED | NO_STUTTER | NONVERBAL

#define MANTID_SCRAMBLE_CACHE_LEN 20
/datum/language/mantid/nonvocal/scramble(var/input)
	if(input in scramble_cache)
		var/n = scramble_cache[input]
		scramble_cache -= input
		scramble_cache[input] = n
		return n
	var/scrambled_text = ""
	scramble_cache[input] = make_rainbow("**********************************")
	if(scramble_cache.len > MANTID_SCRAMBLE_CACHE_LEN)
		scramble_cache.Cut(1, scramble_cache.len-MANTID_SCRAMBLE_CACHE_LEN-1)
	return scrambled_text
#undef MANTID_SCRAMBLE_CACHE_LEN

/datum/language/mantid/nonvocal/can_speak_special(var/mob/living/speaker)
	if(istype(speaker) && speaker.isSynthetic())
		return TRUE
	else if(ishuman(speaker))
		var/mob/living/carbon/human/H = speaker
		return H.species.name == SPECIES_MANTID
	return FALSE

/datum/language/mantid/worldnet
	name = LANGUAGE_MANTID_BROADCAST
	key = "\["
	desc = "The mantids have a habit of maintaining an extensive self-supporting broadcast network for use in team communications."
	colour = "alien"
	speech_verb = "flashes"
	ask_verb = "gleams"
	exclaim_verb = "flares"
	flags = RESTRICTED | NO_STUTTER | NONVERBAL | HIVEMIND

/datum/language/mantid/worldnet/check_special_condition(var/mob/living/carbon/other)
	if(istype(other) && (locate(/obj/item/organ/internal/robotic/system_controller) in other.internal_organs))
		return TRUE
	return FALSE
