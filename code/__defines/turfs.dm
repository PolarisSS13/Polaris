#define TURF_REMOVE_CROWBAR     1
#define TURF_REMOVE_SCREWDRIVER 2
#define TURF_REMOVE_SHOVEL      4
#define TURF_REMOVE_WRENCH      8
#define TURF_CAN_BREAK          16
#define TURF_CAN_BURN           32
#define TURF_HAS_EDGES          64
#define TURF_HAS_CORNERS        128
#define TURF_IS_FRAGILE         256
#define TURF_ACID_IMMUNE        512
//turf can be removed using mining equipment, like jackhammer
//(you cannot remove paving using crowbar or showel)
#define TURF_REMOVE_MINEREQUIP  1024

#define isCardinal(x)			(x == NORTH || x == SOUTH || x == EAST || x == WEST)
#define isDiagonal(x)			(x == NORTHEAST || x == SOUTHEAST || x == NORTHWEST || x == SOUTHWEST)