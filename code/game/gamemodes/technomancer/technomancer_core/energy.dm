// Here lives energy-related code and defines for the technomancer core.
// Energy acts as one of several limitations, and essentially acts as a classic 'mana' system.

/obj/item/weapon/technomancer_core
	var/energy = 10000
	var/max_energy = 10000
	var/regen_rate = 50				// How much energy to give every `process()` tick. Default core takes 200 seconds to fully recharge.
	var/energy_delta = 0			// How much we're gaining (or perhaps losing) every `process()`. Used for `stat()` tab.

// Adds energy to the core.
// Returns how much energy was actually given. E.g. 9900/10000 would return 100, even if 500 was given.
/obj/item/weapon/technomancer_core/proc/give_energy(amount)
	. = min(max_energy - energy, amount)
	energy = min(energy + amount, max_energy)
	update_energy_hud()

// Subtracts energy while ignoring any core modifiers.
// In most cases you should use `pay_energy()` instead.
// Also returns how much energy was actually taken, in a similar way as `give_energy()`.
/obj/item/weapon/technomancer_core/proc/drain_energy(amount)
	. = min(energy, amount)
	energy = between(0, energy - amount, max_energy)
	update_energy_hud()

// Checks if the user can afford the cost, and if so, subtracts the cost and returns TRUE.
// This lets you do both the check for if the user can afford the spell, as well as the actual subtraction.
// If a spell has a lot of different checks (e.g. range, valid target, etc), this call should come last,
// or else the user will pay energy for a spell that might fail for a different reason.
/obj/item/weapon/technomancer_core/proc/pay_energy(amount)
	amount = round(amount * energy_cost_modifier, 0.1)
	if(amount <= energy)
		energy = max(energy - amount, 0)
		update_energy_hud()
		return TRUE
	return FALSE

// 'pay_energy' is too vague of a name for a proc at the mob level.
/mob/proc/technomancer_pay_energy(amount)
	return 0

/mob/living/carbon/human/technomancer_pay_energy(amount)
	if(istype(back, /obj/item/weapon/technomancer_core))
		var/obj/item/weapon/technomancer_core/TC = back
		return TC.pay_energy(amount)
	return 0


/obj/item/weapon/technomancer_core/process()
	var/old_energy = energy
	handle_energy()
	energy_delta = energy - old_energy
	if(wearer && wearer.mind)
		if(!(technomancers.is_antagonist(wearer.mind))) // In case someone tries to wear a stolen core.
			wearer.adjust_instability(20)
	if(!wearer || wearer.stat == DEAD) // Unlock if we're dead or not worn.
		canremove = TRUE

// Called by `process()` every object tick.
/obj/item/weapon/technomancer_core/proc/handle_energy()
	// Paying before gaining lets the core sit at 100% instead of 99% forever if a summon exists somewhere.
	drain_energy(get_used_summon_slots() * energy_cost_per_slot)
	give_energy(regen_rate)


// Instantly updates the wearer's energy meter on their HUD, if one exists.
// This is awful and maybe one day it will be nuked from orbit.
/obj/item/weapon/technomancer_core/proc/update_energy_hud()
	if(wearer && ishuman(wearer))
		var/mob/living/carbon/human/H = wearer
		H.wiz_energy_update_hud()


/mob/living/carbon/human/proc/wiz_energy_update_hud()
	if(client && hud_used)
		if(istype(back, /obj/item/weapon/technomancer_core)) // I reckon there's a better way of doing this.
			var/obj/item/weapon/technomancer_core/core = back
			wiz_energy_display.invisibility = 0
			var/ratio = core.energy / core.max_energy
			ratio = max(round(ratio, 0.05) * 100, 5)
			wiz_energy_display.icon_state = "wiz_energy[ratio]"
		else
			wiz_energy_display.invisibility = 101