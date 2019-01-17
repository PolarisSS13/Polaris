#define INSTRUMENT_MIN_OCTAVE 1
#define INSTRUMENT_MAX_OCTAVE 9
#define INSTRUMENT_MAX_SUSTAIN 50		//Synth samples are only 50 ds long!


// /datum/instrument instrument_flags
#define INSTRUMENT_LEGACY (1<<0)					//Legacy instrument. Implies INSTRUMENT_DO_NOT_AUTOSAMPLE
#define INSTRUMENT_DO_NOT_AUTOSAMPLE (1<<1)			//Do not automatically sample
