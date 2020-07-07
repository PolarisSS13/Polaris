// Variants of the base object that can be bought in the Catalog.
// Each has different stats, strengths, and weaknesses.

// High risk, high reward core.
/obj/item/weapon/technomancer_core/unstable
	name = "unstable core"
	desc_to_append = "This one is rather unstable, and could prove dangerous to the user, as it feeds off \
	unstable energies that can occur with overuse of this machine."
	energy = 13000
	max_energy = 13000
	regen_rate = 35
	instability_modifier = 1.2
	energy_cost_modifier = 0.7
	spell_power_modifier = 1.1
	var/base_regen = null
	var/regen_per_instability = 1.5

/obj/item/weapon/technomancer_core/unstable/Initialize()
	base_regen = regen_rate // Avoiding the overhead of `initial()` calls every tick by doing this.
	return ..()

/obj/item/weapon/technomancer_core/unstable/handle_energy()
	var/instability_bonus = 0
	if(wearer && isliving(wearer))
		var/mob/living/L = loc
		instability_bonus = L.instability * regen_per_instability
	regen_rate = base_regen + instability_bonus
	..()


// Speedier, but lower capacity.
/obj/item/weapon/technomancer_core/rapid
	name = "rapid core"
	desc_to_append = "This one has a superior recharge rate, at the price of storage capacity. \
	It also includes integrated motion assistance, increasing agility somewhat."
	energy = 7000
	max_energy = 7000
	regen_rate = 70
	slowdown = -1
	instability_modifier = 0.9
	cooldown_modifier = 0.9


// Big batteries but slow regen, buying energy spells is highly recommended.
/obj/item/weapon/technomancer_core/bulky
	name = "bulky core"
	desc_to_append = "This variant is more cumbersome and bulky, due to the additional energy capacitors installed, \
	which allows for a massive energy storage, as well as stronger function usage. \
	It also comes at a price of a subpar fractal reactor."
	energy = 20000
	max_energy = 20000
	regen_rate = 25
	slowdown = 1
	instability_modifier = 1.0
	spell_power_modifier = 1.4


// For those dedicated to summoning hoards of things.
/obj/item/weapon/technomancer_core/summoner
	name = "summoner core"
	desc_to_append = "This type is optimized for plucking hapless creatures and machines from other locations, \
	to do your bidding. The maximum amount of entities that you can bring over at once is higher with this core, \
	and the maintenance cost is significantly lower."
	energy = 8000
	max_energy = 8000
	regen_rate = 40
	max_summon_slots = 40
	instability_modifier = 1.2
	energy_cost_per_slot = 1


// For those who hate instability.
/obj/item/weapon/technomancer_core/safety
	name = "safety core"
	desc_to_append = "This type is designed to be the closest thing you can get to 'safe' for a Core. \
	Instability from this is significantly reduced. You can even dance if you want to, and leave your apprentices behind."
	energy = 7000
	max_energy = 7000
	regen_rate = 30
	instability_modifier = 0.3
	spell_power_modifier = 0.7


// For those who want to blow everything on a few spells.
/obj/item/weapon/technomancer_core/overcharged
	name = "overcharged core"
	desc_to_append = "This type will use as much energy as it can in order to pump up the strength of functions used to insane levels."
	energy = 15000 // Effectively 7.5k.
	max_energy = 15000
	regen_rate = 40
	instability_modifier = 1.1
	spell_power_modifier = 1.75
	energy_cost_modifier = 2.0


// For use only for the GOLEM.
/obj/item/weapon/technomancer_core/golem
	name = "integrated core"
	desc = "A bewilderingly complex 'black box' that allows the wearer to accomplish amazing feats.  This type is not meant \
	to be worn on the back like other cores.  Instead it is meant to be installed inside a synthetic shell.  As a result, it's \
	a lot more robust."
	energy = 25000
	max_energy = 25000
	regen_rate = 100 //250 seconds to full
	instability_modifier = 0.75
