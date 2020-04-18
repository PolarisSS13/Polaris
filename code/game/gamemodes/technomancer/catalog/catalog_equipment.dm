/datum/technomancer_catalog/object/equipment

// Alternative Cores

/datum/technomancer_catalog/object/equipment/core
	cost = 100

/datum/technomancer_catalog/object/equipment/core/New()
	if(!LAZYLEN(object_paths))
		return ..()
	var/list/dat = list("<br>")
	var/obj/item/weapon/technomancer_core/core = object_paths[1]
	var/obj/item/weapon/technomancer_core/default_core = /obj/item/weapon/technomancer_core

	dat += "Capacity: [color_by_comparison(
		initial(core.max_energy),
		initial(default_core.max_energy),
		"[initial(core.max_energy) / 1000]k"
		)]"

	dat += "Recharge: [color_by_comparison(
		initial(core.regen_rate),
		initial(default_core.regen_rate),
		"[initial(core.regen_rate) / 2]/s"
		)]"

	dat += "Instability Modifier: [color_by_comparison(
		initial(core.instability_modifier),
		initial(default_core.instability_modifier),
		"[initial(core.instability_modifier) * 100]%",
		FALSE
		)]"

	dat += "Energy Cost Modifier: [color_by_comparison(
		initial(core.energy_cost_modifier),
		initial(default_core.energy_cost_modifier),
		"[initial(core.energy_cost_modifier) * 100]%",
		FALSE
		)]"

	dat += "Cooldown Modifier: [color_by_comparison(
		initial(core.cooldown_modifier),
		initial(default_core.cooldown_modifier),
		"[initial(core.cooldown_modifier) * 100]%",
		FALSE
		)]"

	dat += "Spell Power: [color_by_comparison(
		initial(core.spell_power_modifier),
		initial(default_core.spell_power_modifier),
		"[initial(core.spell_power_modifier) * 100]%"
		)]"

	dat += "Summon Slots: [color_by_comparison(
		initial(core.max_summons),
		initial(default_core.max_summons),
		"[initial(core.max_summons)]"
		)]"

	desc += dat.Join("<br>")
	return ..()

/datum/technomancer_catalog/object/equipment/core/proc/color_by_comparison(new_value, standard_value, text_output, higher_is_better = TRUE)
	switch(SIGN(new_value - standard_value))
		if(1)
			return span("[higher_is_better ? "good" : "bad"]", text_output)
		if(0)
			return text_output
		if(-1)
			return span("[higher_is_better ? "bad" : "good"]", text_output)

/datum/technomancer_catalog/object/equipment/core/default_core
	name = "Manipulation Core"
	desc = "The default core that you most likely already have.  This is here in-case you change your mind after buying \
	another core, don't forget to refund the old core."
	object_paths = list(/obj/item/weapon/technomancer_core)

/datum/technomancer_catalog/object/equipment/core/rapid_core
	name = "Rapid Core"
	desc = "A core optimized for passive regeneration, however at the cost of capacity. \
	Complex gravatics and force manipulation allows the wearer to also run slightly faster."
	object_paths = list(/obj/item/weapon/technomancer_core/rapid)

/datum/technomancer_catalog/object/equipment/core/bulky_core
	name = "Bulky Core"
	desc = "This core has very large capacitors, however it also has a subpar fractal reactor. \
	The user is recommended to purchase one or more energy-generating Functions as well if using this core. \
	The intense weight of the core unfortunately can cause the wear to move slightly slower, \
	and the closeness of the capacitors causes a slight increase in incoming instability."
	object_paths = list(/obj/item/weapon/technomancer_core/bulky)

/datum/technomancer_catalog/object/equipment/core/unstable
	name = "Unstable Core"
	desc = "This core feeds off unstable energies around the user in addition to a fractal reactor. This means that it performs \
	better as the user has more instability, which could prove dangerous to the inexperienced or unprepared. The rate of recharging \
	increases as the user accumulates more instability, eventually exceeding even the rapid core in regen speed, at a huge risk."
	object_paths = list(/obj/item/weapon/technomancer_core/unstable)

/datum/technomancer_catalog/object/equipment/core/recycling
	name = "Recycling Core"
	desc = "This core is optimized for energy efficency, being able to sometimes recover energy that would have been lost with other \
	cores. Each time energy is spent, there is a chance of recovering half of what was spent."
	object_paths = list(/obj/item/weapon/technomancer_core/recycling)

/datum/technomancer_catalog/object/equipment/core/summoner
	name = "Summoner Core"
	desc = "A unique type of core, this one sacrifices other characteristics in order to optimize it for the purposes teleporting \
	entities from vast distances, and keeping them there. Wearers of this core can maintain many more summons at once, and the energy \
	demand for maintaining summons is severely reduced."
	object_paths = list(/obj/item/weapon/technomancer_core/summoner)

/datum/technomancer_catalog/object/equipment/core/safety
	name = "Safety Core"
	desc = "This core is designed so that the wearer suffers almost no instability. It unfortunately comes at a cost of subpar \
	ratings for everything else."
	object_paths = list(/obj/item/weapon/technomancer_core/safety)

/datum/technomancer_catalog/object/equipment/core/overcharged
	name = "Overcharged Core"
	desc = "A core that was created in order to get the most power out of functions. It does this by shoving the most power into \
	those functions, so it is the opposite of energy efficent, however the enhancement of functions is second to none for other \
	cores."
	object_paths = list(/obj/item/weapon/technomancer_core/overcharged)


// Other equipment

/datum/technomancer_catalog/object/equipment/belt_of_holding
	name = "Belt of Holding"
	desc = "A belt with a literal pocket which opens to a localized pocket of 'Blue-Space', allowing for more storage.  \
	The nature of the pocket allows for storage of larger objects than what is typical for other belts, and in larger quanities.  \
	It will also help keep your pants on."
	cost = 50
	object_paths = list(/obj/item/weapon/storage/belt/holding)

/obj/item/weapon/storage/belt/holding
	name = "Belt of Holding"
	desc = "Can hold more than you'd expect."
	icon_state = "ems"
	max_w_class = ITEMSIZE_NORMAL // Can hold normal sized items.
	storage_slots = 14	// Twice the capacity of a typical belt.
	max_storage_space = ITEMSIZE_COST_NORMAL * 14


/datum/technomancer_catalog/object/equipment/thermals
	name = "Thermoncle"
	desc = "A fancy monocle with a thermal optic lens installed. Allows you to see people across walls."
	cost = 150
	object_paths = list(/obj/item/clothing/glasses/thermal/plain/monocle)


/datum/technomancer_catalog/object/equipment/night_vision
	name = "Night Vision Goggles"
	desc = "Strategical goggles which will allow the wearer to see in the dark. \
	Perfect for the sneaky type, just get rid of the lights first, or make your \
	own darkness by other means."
	cost = 25
	object_paths = list(/obj/item/clothing/glasses/night)


/datum/technomancer_catalog/object/equipment/omnisight
	name = "Omnisight Scanner"
	desc = "A very rare scanner worn on the face, which allows the wearer to see nearly anything across walls."
	cost = 300
	object_paths = list(/obj/item/clothing/glasses/omni)

/obj/item/clothing/glasses/omni
	name = "Omnisight Scanner"
	desc = "A pair of goggles which, while on the surface appear to be build very poorly, reveal to be very advanced in \
	capabilities.  The lens appear to be multiple optical matrices layered together, allowing the wearer to see almost anything \
	across physical barriers."
	icon_state = "uzenwa_sissra_1"
	action_button_name = "Toggle Goggles"
	origin_tech = list(TECH_MAGNET = 6, TECH_ENGINEERING = 6)
	toggleable = 1
	vision_flags = SEE_TURFS|SEE_MOBS|SEE_OBJS
	prescription = 1 // So two versions of these aren't needed.


/datum/technomancer_catalog/object/equipment/med_hud
	name = "Medical HUD"
	desc = "A commonly available HUD for medical professionals, which displays how healthy an individual is. \
	May be useful for support-based apprentices, or for those who want to know how close to dead their enemies \
	are."
	cost = 25
	object_paths = list(/obj/item/clothing/glasses/hud/health)


/datum/technomancer_catalog/object/equipment/scepter
	name = "Scepter of Enhancement"
	desc = "A gem sometimes found in the depths of asteroids undoing xeno-archaeological expeditions \
	makes up the basis for this device. Energy is channeled into it from the Core and the user, \
	causing many functions to be enhanced in various ways, so long as it is held in the off-hand. \
	Be careful not to lose this!"
	cost = 200
	object_paths = list(/obj/item/weapon/scepter)

/obj/item/weapon/scepter
	name = "scepter of enhancement"
	desc = "It's a purple gem, attached to a rod and a handle, along with small wires.  It looks like it would make a good club."
	icon = 'icons/obj/technomancer.dmi'
	icon_state = "scepter"
	force = 15
	slot_flags = SLOT_BELT
	attack_verb = list("beaten", "smashed", "struck", "whacked")

/obj/item/weapon/scepter/attack_self(mob/living/carbon/human/user)
	var/obj/item/item_to_test = user.get_other_hand(src)
	if(istype(item_to_test, /obj/item/weapon/spell/technomancer))
		var/obj/item/weapon/spell/technomancer/S = item_to_test
		S.on_scepter_use_cast(user)

/obj/item/weapon/scepter/afterattack(atom/target, mob/living/carbon/human/user, proximity_flag, click_parameters)
	if(proximity_flag)
		return ..()
	var/obj/item/item_to_test = user.get_other_hand(src)
	if(istype(item_to_test, /obj/item/weapon/spell/technomancer))
		var/obj/item/weapon/spell/technomancer/S = item_to_test
		S.on_scepter_ranged_cast(target, user)


/datum/technomancer_catalog/object/equipment/spyglass
	name = "Spyglass"
	desc = "A mundane spyglass, it may prove useful to those who wish to scout ahead, or fight from an extreme range."
	cost = 100
	object_paths = list(/obj/item/device/binoculars/spyglass)

/obj/item/device/binoculars/spyglass
	name = "spyglass"
	desc = "It's a hand-held telescope, useful for star-gazing, recon, and peeping."
	icon_state = "spyglass"
	slot_flags = SLOT_BELT
