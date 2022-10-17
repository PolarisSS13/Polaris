#define EMPTY_BITFIELD 0

/* Directions */
///All the cardinal direction bitflags.
#define ALL_CARDINALS (NORTH|SOUTH|EAST|WEST)


/* -- /datum/var/datum_flags -- */

#define DF_VAR_EDITED			(1<<0)
#define DF_ISPROCESSING			(1<<1)
#define DF_USE_TAG				(1<<2)


/* -- /atom/var/atom_flags -- */

/// The atom has been initialized.
#define ATOM_INITIALIZED (1<<0)

#define NOCONDUCT					(1<<1)	// Conducts electricity. (metal etc.)
#define ON_BORDER				(1<<2)	// Item has priority to check when entering or leaving.
#define OPENCONTAINER			(1<<3)	// Is an open container for chemistry purposes.
#define	NOREACT					(1<<4)	// Reagents don't react inside this container.
#define OVERLAY_QUEUED			(1<<5)	// Atom is queued for an overlay update
#define SLANDMARK_FLAG_AUTOSET (1<<6) // If set, will set base area and turf type to same as where it was spawned at
#define SLANDMARK_FLAG_ZERO_G (1<<7) // Zero-G shuttles moved here will lose gravity unless the area has ambient gravity.


/* -- /turf/var/turf_flags -- */

/// The turf is blessed; it interferes with cult behaviors.
#define TURF_IS_BLESSED (1<<0)

/// The turf prevents wizard movement spells.
#define TURF_PREVENTS_JAUNT (1<<1)


/* -- /atom/movable/var/movement_type -- */

#define UNSTOPPABLE				(1<<0)			//Can not be stopped from moving from Cross(), CanPass(), or Uncross() failing. Still bumps everything it passes through, though.


/* -- /obj/item/var/item_flags -- */

#define THICKMATERIAL			(1<<0)	// Prevents syringes, parapens and hyposprays if equipped to slot_suit or slot_head.
#define AIRTIGHT				(1<<1)	// Functions with internals.
#define NOSLIP					(1<<2)	// Prevents from slipping on wet floors, in space, etc.
#define BLOCK_GAS_SMOKE_EFFECT	(1<<3)	// Blocks the effect that chemical clouds would have on a mob -- glasses, mask and helmets ONLY! (NOTE: flag shared with ONESIZEFITSALL)
#define FLEXIBLEMATERIAL		(1<<4)	// At the moment, masks with this flag will not prevent eating even if they are covering your face.
#define ALLOW_SURVIVALFOOD		(1<<5)	// Allows special survival food items to be eaten through it
#define NOBLOODY				(1<<6)	// Used for items if they don't want to get a blood overlay.
#define NOBLUDGEON				(1<<7)	// When an item has this it produces no "X has been hit by Y with Z" message with the default handler.
#define PHORONGUARD				(1<<8)	// Item does not get contaminated by phoron.


/* -- /atom/var/pass_flags -- */

#define PASSTABLE				(1<<0)
#define PASSGLASS				(1<<1)
#define PASSGRILLE				(1<<2)
#define PASSBLOB				(1<<3)
#define PASSMOB					(1<<4)
