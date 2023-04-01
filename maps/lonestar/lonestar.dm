#if !defined(USING_MAP_DATUM)

	#include "lonestar_areas.dm"
	#include "lonestar_defines.dm"
	#include "lonestar_jobs.dm"
	#include "lonestar_elevator.dm"
	#include "lonestar_events.dm"
	#include "lonestar_presets.dm"
	#include "lonestar_shuttles.dm"

	#include "shuttles/crew_shuttles.dm"
	#include "shuttles/heist.dm"
	#include "shuttles/merc.dm"
	#include "shuttles/ninja.dm"
	#include "shuttles/ert.dm"

	#include "loadout/loadout_accessories.dm"
	#include "loadout/loadout_head.dm"
	#include "loadout/loadout_suit.dm"
	#include "loadout/loadout_uniform.dm"

	#include "datums/supplypacks/munitions.dm"
	#include "items/encryptionkey_sc.dm"
	#include "items/headset_sc.dm"
	#include "items/clothing/sc_suit.dm"
	#include "items/clothing/sc_under.dm"
	#include "items/clothing/sc_accessory.dm"
	#include "job/outfits.dm"
	#include "structures/closets/engineering.dm"
	#include "structures/closets/medical.dm"
	#include "structures/closets/misc.dm"
	#include "structures/closets/research.dm"
	#include "structures/closets/security.dm"
	#include "turfs/outdoors.dm"
	#include "overmap/sectors.dm"

	#include "lonestar-01.dmm"
	#include "lonestar-02.dmm"
	#include "lonestar-03.dmm"
	#include "lonestar-04.dmm"
	#include "lonestar-05.dmm"
	#include "lonestar-06.dmm"
	#include "lonestar-07.dmm"
	#include "lonestar-08.dmm"
	#include "lonestar-09.dmm"
	#include "lonestar-10.dmm"

	#define USING_MAP_DATUM /datum/map/lonestar

	// todo: map.dmm-s here

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Lonestar Station

#endif