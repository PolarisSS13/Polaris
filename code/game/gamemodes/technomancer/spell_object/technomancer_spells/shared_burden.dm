/datum/technomancer_catalog/spell/shared_burden
	name = "Shared Burden"
	cost = 50
	category = SUPPORT_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/shared_burden)

/datum/spell_metadata/shared_burden
	name = "Shared Burden"
	desc = "One of the few functions that can manipulate someone's instability. \
	It attempts to equalize the instability between yourself and a targeted entity. \
	If the target is wearing armor that blocks strange energies, \
	the amount of instability transferred may vary."
	aspect = ASPECT_UNSTABLE
	icon_state = "tech_shared_burden"
	spell_path = /obj/item/weapon/spell/technomancer/shared_burden
	cooldown = 10 SECONDS

/datum/spell_metadata/shared_burden/get_spell_info()
	var/obj/item/weapon/spell/technomancer/shared_burden/spell = spell_path
	. = list()
	.["Energy Cost"] = initial(spell.transfer_energy_cost)
	.["Instability Cost"] = initial(spell.transfer_instability_cost)

/obj/item/weapon/spell/technomancer/shared_burden
	name = "shared burden"
	desc = "All shall have equal amounts of instability."
	icon_state = "shared_burden"
	cast_methods = CAST_RANGED
	var/transfer_energy_cost = 2000
	var/transfer_instability_cost = 5 // Technically 2.5, since half will by default get sent to the target.


/obj/item/weapon/spell/technomancer/shared_burden/on_ranged_cast(atom/hit_atom, mob/living/user)
	if(!isliving(hit_atom))
		to_chat(span("warning", "This function only works on entities."))
		return FALSE

	var/mob/living/L = hit_atom
	if(L == user)
		to_chat(span("warning", "Equalizing instability with yourself seems kind of pointless, doesn't it?"))
		return FALSE

	if(!pay_energy(transfer_energy_cost))
		to_chat(span("warning", "You lack the energy required to equalize instability!"))
		return FALSE

	adjust_instability(transfer_instability_cost)

	// Energy armor interferes with this spell, making it less efficent.
	var/their_energy_armor_ratio = 1 - (L.getarmor(null, "energy") / 100)
	var/our_energy_armor_ratio = 1 - (user.getarmor(null, "energy") / 100)

	var/transfer_ratio = min(our_energy_armor_ratio, their_energy_armor_ratio) // Use the lowest ratio between the two.

	var/our_old_instability = user.instability
	var/their_old_instability = L.instability

	var/our_instability_to_move = our_old_instability * transfer_ratio
	var/their_instability_to_move = their_old_instability * transfer_ratio

	user.adjust_instability(-our_instability_to_move)
	L.adjust_instability(-their_instability_to_move)

	var/instability_to_give = (our_instability_to_move + their_instability_to_move) / 2
	user.adjust_instability(instability_to_give)
	L.adjust_instability(instability_to_give)

	// Visuals/sounds/etc
	user.Beam(L, icon_state = "curse_fast", maxdistance = INFINITY, time = 1 SECOND)
	playsound(user, 'sound/effects/magic/technomancer/death.ogg', 75, 1)
	playsound(L, 'sound/effects/magic/technomancer/zap_hit.ogg', 75, 1)
	playsound(user, 'sound/effects/magic/technomancer/zap_hit.ogg', 75, 1)

	to_chat(user, span("notice", "Your instability has shifted by <b>[user.instability - our_old_instability]</b>."))
	to_chat(user, span("notice", "\The [L]'s instability has shifted by <b>[L.instability - their_old_instability]</b>."))
	to_chat(user, span("notice", "Transfered instability with an efficency of [transfer_ratio*100]%."))

	delete_after_cast = TRUE
	return TRUE