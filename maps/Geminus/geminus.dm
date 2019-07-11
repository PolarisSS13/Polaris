#if !defined(USING_MAP_DATUM)

	#include "geminus-1.dmm"
	#include "geminus-2.dmm"
	#include "geminus-3.dmm"
	#include "geminus-VR.dmm"
	#include "geminus_shuttles.dm"
	#include "geminus_defines.dm"
	#include "geminus_elevator.dm"
	#include "geminus_areas.dm"
	#include "geminus_VR_games.dm"

	#define USING_MAP_DATUM /datum/map/geminus

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Geminus

#endif