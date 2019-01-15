GLOBAL_VAR_INIT(musician_maxlines, 600)
GLOBAL_VAR_INIT(musician_maxlinechars, 100)
GLOBAL_VAR_INIT(musician_hearcheck_mindelay, 5)

// /datum/instrument instrument_flags
#define INSTRUMENT_LEGACY (1<<0)					//Legacy instrument. Implies INSTRUMENT_DO_NOT_AUTOSAMPLE
#define INSTRUMENT_DO_NOT_AUTOSAMPLE (1<<1)			//Do not automatically sample
