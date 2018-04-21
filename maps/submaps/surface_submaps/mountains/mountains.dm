// This causes PoI maps to get 'checked' and compiled, when undergoing a unit test.
// This is so Travis can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.
// When adding a new PoI, please add it to this list.
#if MAP_TEST
#include "deadBeacon.dmm"
#include "prepper1.dmm"
#include "prepper2.dmm"
#include "prepper3.dmm"
#include "prepper4.dmm"
#include "quarantineshuttle.dmm"
#include "quarantineshuttle2.dmm"
#include "quarantineshuttle3.dmm"
#include "quarantineshuttle4.dmm"
#include "quarantineshuttle5.dmm"
#include "Mineshaft1.dmm"
#include "Mineshaft2.dmm"
#include "Mineshaft3.dmm"
#include "Mineshaft4.dmm"
#include "Scave1.dmm"
#include "Scave2.dmm"
#include "Scave3.dmm"
#include "Scave4.dmm"
#include "crashed_ufo.dmm"
#include "crystal1.dmm"
#include "crystal2.dmm"
#include "crystal3.dmm"
#include "lost_explorer.dmm"
#include "CaveTrench.dmm"
#include "CaveTrench2.dmm"
#include "CaveTrench3.dmm"
#include "CaveTrench4.dmm"
#include "Cavelake.dmm"
#include "Rockb1.dmm"
#include "Rockb2.dmm"
#include "Rockb3.dmm"
#include "Rockb4.dmm"
#include "ritual.dmm"
#include "temple.dmm"
#include "temple2.dmm"
#include "CrashedMedShuttle1.dmm"
#include "CrashedMedShuttle2.dmm"
#include "CrashedMedShuttle3.dmm"
#include "CrashedMedShuttle4.dmm"
#include "digsite.dmm"
#include "vault1.dmm"
#include "vault2.dmm"
#include "vault3.dmm"
#include "vault4.dmm"
#include "vault5.dmm"
#include "IceCave1A.dmm"
#include "IceCave1B.dmm"
#include "IceCave1C.dmm"
#include "SwordCave.dmm"
#include "SupplyDrop1.dmm"
#include "SupplyDrop2.dmm"
#include "SupplyDrop3.dmm"
#include "SupplyDrop4.dmm"
#include "BlastMine1.dmm"
#include "BlastMine2.dmm"
#include "BlastMine3.dmm"
#include "BlastMine4.dmm"
#endif

// The 'mountains' is the mining z-level, and has a lot of caves.
// POIs here spawn in two different sections, the top half and bottom half of the map.
// The bottom half should be fairly tame, with perhaps a few enviromental hazards.
// The top half is when things start getting dangerous, but the loot gets better.

/datum/map_template/surface/mountains
	name = "Mountain Content"
	desc = "Don't dig too deep!"

// 'Normal' templates get used on the bottom half, and should be safer.
/datum/map_template/surface/mountains/normal

// 'Deep' templates get used on the top half, and should be more dangerous and rewarding.
/datum/map_template/surface/mountains/deep

// To be added: Templates for cave exploration when they are made.

/****************
 * Normal Caves *
 ****************/


//Abandoned Temple

/datum/map_template/surface/mountains/normal/abandonedtemple
	name = "Abandoned Temple 1"
	desc = "An ancient temple, long since abandoned. Perhaps alien in origin?"
	mappath = 'maps/submaps/surface_submaps/mountains/temple.dmm'
	template_group = "Abandoned Temple"
	cost = 20

/datum/map_template/surface/mountains/normal/abandonedtemple2
	name = "Abandoned Temple 2"
	desc = "An ancient temple, long since abandoned. Perhaps alien in origin? Also bats? Bats!?"
	mappath = 'maps/submaps/surface_submaps/mountains/temple2.dmm'
	template_group = "Abandoned Temple"
	cost = 25

/datum/map_template/surface/mountains/normal/corgiritual
	name = "Dark Ritual"
	desc = "Who put all these plushies here? What are they doing?"
	mappath = 'maps/submaps/surface_submaps/mountains/ritual.dmm'
	cost = 15

//Crashed Medical Shuttle

/datum/map_template/surface/mountains/normal/crashedmedshuttle1
	name = "Crashed Med Shuttle 1"
	desc = "A medical response shuttle that went missing some time ago. So this is where they went."
	mappath = 'maps/submaps/surface_submaps/mountains/CrashedMedShuttle1.dmm'
	template_group = "Crashed Med Shuttle"
	cost = 20

/datum/map_template/surface/mountains/normal/crashedmedshuttle2
	name = "Crashed Med Shuttle 2"
	desc = "A medical response shuttle that went missing some time ago. Some of the cavern has fallen in on the shuttle."
	mappath = 'maps/submaps/surface_submaps/mountains/CrashedMedShuttle2.dmm'
	template_group = "Crashed Med Shuttle"
	cost = 20

/datum/map_template/surface/mountains/normal/crashedmedshuttle3
	name = "Crashed Med Shuttle 3"
	desc = "A medical response shuttle that went missing some time ago. Now a Shantak den."
	mappath = 'maps/submaps/surface_submaps/mountains/CrashedMedShuttle3.dmm'
	template_group = "Crashed Med Shuttle"
	cost = 20

/datum/map_template/surface/mountains/normal/crashedmedshuttle4
	name = "Crashed Med Shuttle 4"
	desc = "A medical response shuttle that crash landed some time ago. Crew rescued and shuttle stripped for parts."
	mappath = 'maps/submaps/surface_submaps/mountains/CrashedMedShuttle4.dmm'
	template_group = "Crashed Med Shuttle"
	cost = 15

//Crystal Caves

/datum/map_template/surface/mountains/normal/crystal1
	name = "Crystal Cave 1"
	desc = "A small cave with glowing gems and diamonds."
	mappath = 'maps/submaps/surface_submaps/mountains/crystal1.dmm'
	cost = 5
	allow_duplicates = TRUE

/datum/map_template/surface/mountains/normal/crystal2
	name = "Crystal Cave 2"
	desc = "A moderate sized cave with glowing gems and diamonds."
	mappath = 'maps/submaps/surface_submaps/mountains/crystal2.dmm'
	cost = 10
	allow_duplicates = TRUE

/datum/map_template/surface/mountains/normal/crystal2
	name = "Crystal Cave 3"
	desc = "A large spiral of crystals with diamonds in the center."
	mappath = 'maps/submaps/surface_submaps/mountains/crystal3.dmm'
	cost = 15

/datum/map_template/surface/mountains/normal/deadBeacon
	name = "Abandoned Relay"
	desc = "An unregistered comms relay, abandoned to the elements."
	mappath = 'maps/submaps/surface_submaps/mountains/deadBeacon.dmm'
	cost = 10

/datum/map_template/surface/mountains/normal/digsite
	name = "Dig Site"
	desc = "A small abandoned dig site."
	mappath = 'maps/submaps/surface_submaps/mountains/digsite.dmm'
	cost = 10

//Ice Cave

/datum/map_template/surface/mountains/normal/IceCave1A
	name = "Ice Cave 1A"
	desc = "This cave's slippery ice makes it hard to navigate, but determined explorers will be rewarded."
	mappath = 'maps/submaps/surface_submaps/mountains/IceCave1A.dmm'
	template_group = "Ice  Cave"
	cost = 10

/datum/map_template/surface/mountains/normal/IceCave1B
	name = "Ice Cave 1B"
	desc = "This cave's slippery ice makes it hard to navigate, but determined explorers will be rewarded."
	mappath = 'maps/submaps/surface_submaps/mountains/IceCave1B.dmm'
	template_group = "Ice  Cave"
	cost = 10

/datum/map_template/surface/mountains/normal/IceCave1C
	name = "Ice Cave 1C"
	desc = "This cave's slippery ice makes it hard to navigate, but determined explorers will be rewarded."
	mappath = 'maps/submaps/surface_submaps/mountains/IceCave1C.dmm'
	template_group = "Ice  Cave"
	cost = 10

/datum/map_template/surface/mountains/normal/lost_explorer
	name = "Lost Explorer"
	desc = "The remains of an explorer who rotted away ages ago, and their equipment."
	mappath = 'maps/submaps/surface_submaps/mountains/lost_explorer.dmm'
	cost = 5

//Abandoned Mineshaft

/datum/map_template/surface/mountains/normal/Mineshaft1
	name = "Abandoned Mineshaft 1"
	desc = "An abandoned minning tunnel from a lost money making effort."
	mappath = 'maps/submaps/surface_submaps/mountains/Mineshaft1.dmm'
	template_group = "Abandoned Mineshaft"
	cost = 5

/datum/map_template/surface/mountains/normal/Mineshaft2
	name = "Abandoned Mineshaft 2"
	desc = "An abandoned minning tunnel from a lost money making effort, With a couple critters."
	mappath = 'maps/submaps/surface_submaps/mountains/Mineshaft2.dmm'
	template_group = "Abandoned Mineshaft"
	cost = 5

/datum/map_template/surface/mountains/normal/Mineshaft3
	name = "Abandoned Mineshaft 3"
	desc = "An abandoned drone minning tunnel from a lost money making effort."
	mappath = 'maps/submaps/surface_submaps/mountains/Mineshaft3.dmm'
	template_group = "Abandoned Mineshaft"
	cost = 5

/datum/map_template/surface/mountains/normal/Mineshaft4
	name = "Abandoned Mineshaft 4"
	desc = "An abandoned minning tunnel from a lost money making effort. Now with more bad critters"
	mappath = 'maps/submaps/surface_submaps/mountains/Mineshaft4.dmm'
	template_group = "Abandoned Mineshaft"
	cost = 5

//Prepper Hideout

/datum/map_template/surface/mountains/normal/prepper1
	name = "Prepper Bunker 1"
	desc = "A little hideaway for someone with more time and money than sense."
	mappath = 'maps/submaps/surface_submaps/mountains/prepper1.dmm'
	template_group = "Prepper"
	cost = 10

/datum/map_template/surface/mountains/normal/prepper2
	name = "Prepper Bunker 2"
	desc = "A little hideaway for someone with more time and money than sense. Now with ten percent more blastdoor"
	mappath = 'maps/submaps/surface_submaps/mountains/prepper2.dmm'
	template_group = "Prepper"
	cost = 10

/datum/map_template/surface/mountains/normal/prepper3
	name = "Prepper Bunker 3"
	desc = "A little hideaway for someone with more time and money than sense. Blastdoors and facing other way."
	mappath = 'maps/submaps/surface_submaps/mountains/prepper3.dmm'
	template_group = "Prepper"
	cost = 10

/datum/map_template/surface/mountains/normal/prepper4
	name = "Prepper Bunker 4"
	desc = "A little hideaway for someone with more time and money than sense. Extra long term defenses against looters."
	mappath = 'maps/submaps/surface_submaps/mountains/prepper4.dmm'
	template_group = "Prepper"
	cost = 10

//Quarantined Shuttle

/datum/map_template/surface/mountains/normal/qshuttle
	name = "Quarantined Shuttle 1"
	desc = "An emergency landing turned viral outbreak turned tragedy."
	mappath = 'maps/submaps/surface_submaps/mountains/quarantineshuttle.dmm'
	template_group = "Quarantined Shuttle"
	cost = 20

/datum/map_template/surface/mountains/normal/qshuttle2
	name = "Quarantined Shuttle 2"
	desc = "An emergency landing turned viral outbreak turned tragedy."
	mappath = 'maps/submaps/surface_submaps/mountains/quarantineshuttle2.dmm'
	template_group = "Quarantined Shuttle"
	cost = 20

/datum/map_template/surface/mountains/normal/qshuttle3
	name = "Quarantined Shuttle 3"
	desc = "An emergency landing turned viral outbreak turned tragedy. Shuttle broken in two."
	mappath = 'maps/submaps/surface_submaps/mountains/quarantineshuttle3.dmm'
	template_group = "Quarantined Shuttle"
	cost = 20

/datum/map_template/surface/mountains/normal/qshuttle4
	name = "Quarantined Shuttle 4"
	desc = "An emergency landing turned viral outbreak turned tragedy. Now a home."
	mappath = 'maps/submaps/surface_submaps/mountains/quarantineshuttle4.dmm'
	template_group = "Quarantined Shuttle"
	cost = 20

/datum/map_template/surface/mountains/normal/qshuttle5
	name = "Quarantined Shuttle 5"
	desc = "An emergency landing turned viral outbreak turned success story."
	mappath = 'maps/submaps/surface_submaps/mountains/quarantineshuttle5.dmm'
	template_group = "Quarantined Shuttle"
	cost = 20

//Rocky Base

/datum/map_template/surface/mountains/normal/Rockb1
	name = "Rocky Base 1"
	desc = "Someones underground hidey hole"
	mappath = 'maps/submaps/surface_submaps/mountains/Rockb1.dmm'
	template_group = "Rocky Base"
	cost = 15

/datum/map_template/surface/mountains/normal/Rockb2
	name = "Rocky Base 2"
	desc = "Someones underground hidey hole"
	mappath = 'maps/submaps/surface_submaps/mountains/Rockb2.dmm'
	template_group = "Rocky Base"
	cost = 15

/datum/map_template/surface/mountains/normal/Rockb3
	name = "Rocky Base 3"
	desc = "Someones underground hidey hole. Now with defense."
	mappath = 'maps/submaps/surface_submaps/mountains/Rockb3.dmm'
	template_group = "Rocky Base"
	cost = 15

/datum/map_template/surface/mountains/normal/Rockb4
	name = "Rocky Base 4"
	desc = "Someones underground hidey hole. Now with defense"
	mappath = 'maps/submaps/surface_submaps/mountains/Rockb4.dmm'
	template_group = "Rocky Base"
	cost = 15

//Supply Drop

/datum/map_template/surface/mountains/normal/supplydrop1
	name = "Supply Drop 1"
	desc = "A drop pod that landed deep within the mountains."
	mappath = 'maps/submaps/surface_submaps/mountains/SupplyDrop1.dmm'
	template_group = "Supply Drop"
	cost = 10
	allow_duplicates = TRUE

/datum/map_template/surface/mountains/normal/supplydrop2
	name = "Supply Drop 2"
	desc = "A drop pod that landed deep within the mountains. Has a active GPS"
	mappath = 'maps/submaps/surface_submaps/mountains/SupplyDrop2.dmm'
	template_group = "Supply Drop"
	cost = 10
	allow_duplicates = TRUE

/datum/map_template/surface/mountains/normal/supplydrop3
	name = "Supply Drop 3"
	desc = "A drop pod that landed deep within the mountains."
	mappath = 'maps/submaps/surface_submaps/mountains/SupplyDrop3.dmm'
	template_group = "Supply Drop"
	cost = 10
	allow_duplicates = TRUE

/datum/map_template/surface/mountains/normal/supplydrop4
	name = "Supply Drop 4"
	desc = "A drop pod that landed deep within the mountains. Has a active GPS"
	mappath = 'maps/submaps/surface_submaps/mountains/SupplyDrop4.dmm'
	template_group = "Supply Drop"
	cost = 10
	allow_duplicates = TRUE

/datum/map_template/surface/mountains/normal/SwordCave
	name = "Cursed Sword Cave"
	desc = "An underground lake. The sword on the lake's island holds a terrible secret."
	mappath = 'maps/submaps/surface_submaps/mountains/SwordCave.dmm'

//Vaults

/datum/map_template/surface/mountains/normal/vault1
	name = "Mine Vault 1"
	desc = "A small vault with potential loot."
	mappath = 'maps/submaps/surface_submaps/mountains/vault1.dmm'
	cost = 5
	allow_duplicates = TRUE

/datum/map_template/surface/mountains/normal/vault2
	name = "Mine Vault 2"
	desc = "A small vault with potential loot."
	mappath = 'maps/submaps/surface_submaps/mountains/vault2.dmm'
	cost = 5
	allow_duplicates = TRUE

/datum/map_template/surface/mountains/normal/vault3
	name = "Mine Vault 3"
	desc = "A small vault with potential loot. Also a horrible suprise."
	mappath = 'maps/submaps/surface_submaps/mountains/vault3.dmm'
	cost = 15

/**************
 * Deep Caves *
 **************/

//Blast Mine

/datum/map_template/surface/mountains/deep/BlastMine1
	name = "Blast Mine 1"
	desc = "An abandoned blast mining site, seems that local wildlife has moved in."
	mappath = 'maps/submaps/surface_submaps/mountains/BlastMine1.dmm'
	template_group = "Blast Mine"
	cost = 20

/datum/map_template/surface/mountains/deep/BlastMine2
	name = "Blast Mine 2"
	desc = "An abandoned blast mining site, seems that local tame wildlife has moved in."
	mappath = 'maps/submaps/surface_submaps/mountains/BlastMine2.dmm'
	template_group = "Blast Mine"
	cost = 15

/datum/map_template/surface/mountains/deep/BlastMine3
	name = "Blast Mine 3"
	desc = "An abandoned blast mining site, seems that horrible hostile wildlife has moved in."
	mappath = 'maps/submaps/surface_submaps/mountains/BlastMine3.dmm'
	template_group = "Blast Mine"
	cost = 25

/datum/map_template/surface/mountains/deep/BlastMine4
	name = "Blast Mine 4"
	desc = "An abandoned blast mining site, already been stripped of anything useful."
	mappath = 'maps/submaps/surface_submaps/mountains/BlastMine4.dmm'
	template_group = "Blast Mine"
	cost = 10

/datum/map_template/surface/mountains/deep/Cavelake
	name = "Cave Lake"
	desc = "A large underground lake."
	mappath = 'maps/submaps/surface_submaps/mountains/Cavelake.dmm'
	cost = 20

//Cave Trench

/datum/map_template/surface/mountains/deep/CaveTrench1
	name = "Cave River"
	desc = "A strange underground river."
	mappath = 'maps/submaps/surface_submaps/mountains/CaveTrench.dmm'
	template_group = "Cave Trench"
	cost = 20

/datum/map_template/surface/mountains/deep/CaveTrench2
	name = "Cave River"
	desc = "A strange underground river (Non-lethal)."
	mappath = 'maps/submaps/surface_submaps/mountains/CaveTrench2.dmm'
	template_group = "Cave Trench"
	cost = 25

/datum/map_template/surface/mountains/deep/CaveTrench3
	name = "Cave River"
	desc = "A strange underground river (More-lethal)."
	mappath = 'maps/submaps/surface_submaps/mountains/CaveTrench3.dmm'
	template_group = "Cave Trench"
	cost = 20

/datum/map_template/surface/mountains/deep/CaveTrench4
	name = "Cave River"
	desc = "A strange underground river (Critter)."
	mappath = 'maps/submaps/surface_submaps/mountains/CaveTrench4.dmm'
	template_group = "Cave Trench"
	cost = 15

/datum/map_template/surface/mountains/deep/crashed_ufo
	name = "Crashed UFO"
	desc = "A (formerly) flying saucer that is now embedded into the mountain, yet it still seems to be running..."
	mappath = 'maps/submaps/surface_submaps/mountains/crashed_ufo.dmm'
	cost = 40
	discard_prob = 50

/datum/map_template/surface/mountains/deep/lost_explorer
	name = "Lost Explorer, Deep"
	desc = "The remains of an explorer who rotted away ages ago, and their equipment. Again."
	mappath = 'maps/submaps/surface_submaps/mountains/lost_explorer.dmm'
	cost = 5

//Spider Cave

/datum/map_template/surface/mountains/deep/Scave1
	name = "Spider Cave 1"
	desc = "A minning tunnel home to an aggressive collection of spiders. (Default)"
	mappath = 'maps/submaps/surface_submaps/mountains/Scave1.dmm'
	template_group = "Spider Cave"
	cost = 20

/datum/map_template/surface/mountains/deep/Scave2
	name = "Spider Cave 2"
	desc = "A minning tunnel home to an aggressive collection of spiders."
	mappath = 'maps/submaps/surface_submaps/mountains/Scave2.dmm'
	template_group = "Spider Cave"
	cost = 20

/datum/map_template/surface/mountains/deep/Scave3
	name = "Spider Cave 3"
	desc = "A minning tunnel home to an aggressive collection of spiders. Less spiders more spiderlings"
	mappath = 'maps/submaps/surface_submaps/mountains/Scave3.dmm'
	template_group = "Spider Cave"
	cost = 20


/datum/map_template/surface/mountains/deep/Scave4
	name = "Spider Cave 4"
	desc = "A minning tunnel home to an aggressive collection of spiders. More spiders less spiderlings."
	mappath = 'maps/submaps/surface_submaps/mountains/Scave4.dmm'
	template_group = "Spider Cave"
	cost = 20

//Vaults

/datum/map_template/surface/mountains/deep/vault1
	name = "Mine Vault 1"
	desc = "A small vault with potential loot."
	mappath = 'maps/submaps/surface_submaps/mountains/vault1.dmm'
	cost = 5
	allow_duplicates = TRUE

/datum/map_template/surface/mountains/deep/vault2
	name = "Mine Vault 2"
	desc = "A small vault with potential loot."
	mappath = 'maps/submaps/surface_submaps/mountains/vault2.dmm'
	cost = 5
	allow_duplicates = TRUE

/datum/map_template/surface/mountains/deep/vault3
	name = "Mine Vault 3"
	desc = "A small vault with potential loot. Also a horrible suprise."
	mappath = 'maps/submaps/surface_submaps/mountains/vault3.dmm'
	cost = 15

/datum/map_template/surface/mountains/deep/vault4
	name = "Mine Vault 4"
	desc = "A small xeno vault with potential loot. Also horrible suprises."
	mappath = 'maps/submaps/surface_submaps/mountains/vault4.dmm'
	cost = 20

/datum/map_template/surface/mountains/deep/vault5
	name = "Mine Vault 5"
	desc = "A small xeno vault with potential loot. Also major horrible suprises."
	mappath = 'maps/submaps/surface_submaps/mountains/vault5.dmm'
	cost = 25
