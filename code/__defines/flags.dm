#define ALL (~0) //For convenience.
#define NONE 0

//for convenience
#define ENABLE_BITFIELD(variable, flag) (variable |= (flag))
#define DISABLE_BITFIELD(variable, flag) (variable &= ~(flag))
#define CHECK_BITFIELD(variable, flag) (variable & (flag))

//check if all bitflags specified are present
#define CHECK_MULTIPLE_BITFIELDS(flagvar, flags) ((flagvar & (flags)) == flags)

GLOBAL_LIST_INIT(bitflags, list(1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768))

// /atom/movable movement_type
#define UNSTOPPABLE (1<<0)			//Can not be stopped from moving from Cross(), CanPass(), or Uncross() failing. Still bumps everything it passes through, though.

// Flags bitmasks. - Used in /atom/var/flags
#define NOBLUDGEON         0x1    // When an item has this it produces no "X has been hit by Y with Z" message with the default handler.
#define CONDUCT            0x2   // Conducts electricity. (metal etc.)
#define ON_BORDER          0x4   // Item has priority to check when entering or leaving.
#define NOBLOODY           0x8   // Used for items if they don't want to get a blood overlay.
#define OPENCONTAINER      0x10 // Is an open container for chemistry purposes.
#define PHORONGUARD        0x20 // Does not get contaminated by phoron.
#define	NOREACT            0x40 // Reagents don't react inside this container.
#define PROXMOVE           0x80  // Does this object require proximity checking in Enter()?
#define OVERLAY_QUEUED     0x100 // Atom queued to SSoverlay for COMPILE_OVERLAYS

//Flags for items (equipment) - Used in /obj/item/var/item_flags
#define THICKMATERIAL          0x1  // Prevents syringes, parapens and hyposprays if equipped to slot_suit or slot_head.
#define STOPPRESSUREDAMAGE     0x2  // Counts towards pressure protection. Note that like temperature protection, body_parts_covered is considered here as well.
#define AIRTIGHT               0x4  // Functions with internals.
#define NOSLIP                 0x8  // Prevents from slipping on wet floors, in space, etc.
#define BLOCK_GAS_SMOKE_EFFECT 0x10 // Blocks the effect that chemical clouds would have on a mob -- glasses, mask and helmets ONLY! (NOTE: flag shared with ONESIZEFITSALL)
#define FLEXIBLEMATERIAL       0x20 // At the moment, masks with this flag will not prevent eating even if they are covering your face.

// Flags for pass_flags. - Used in /atom/var/pass_flags
#define PASSTABLE  0x1
#define PASSGLASS  0x2
#define PASSGRILLE 0x4
#define PASSBLOB   0x8
