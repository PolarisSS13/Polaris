// Not quite a species, simply here for Background system functionality at this time.

// POSITRONIC

GLOBAL_LIST_INIT(positronic_cultural_info, list( \
		TAG_CULTURE =   list(CULTURE_OTHER, \
							CULTURE_POSITRONIC \
							), \
		TAG_HOMEWORLD = list(HOME_SYSTEM_STATELESS, \
							HOME_SYSTEM_OTHER \
							), \
		TAG_FACTION =   list(FACTION_OTHER \
							), \
		TAG_RELIGION =  list(RELIGION_OTHER \
							), \
		TAG_SUBSPECIES = list(SUBSPECIES_GENERIC \
							) \
	)) \

// DRONE

GLOBAL_LIST_INIT(drone_cultural_info, list( \
		TAG_CULTURE =   list(CULTURE_OTHER \
							), \
		TAG_HOMEWORLD = list(HOME_SYSTEM_STATELESS, \
							HOME_SYSTEM_OTHER \
							), \
		TAG_FACTION =   list(FACTION_OTHER \
							), \
		TAG_RELIGION =  list(RELIGION_OTHER \
							), \
		TAG_SUBSPECIES = list(SUBSPECIES_GENERIC, \
							SUBSPECIES_DRONE_X, \
							SUBSPECIES_DRONE_EMERGENT
							) \
	)) \
